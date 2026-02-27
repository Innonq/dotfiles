#!/usr/bin/env bash
# waybar-ticker.sh — Scrolling crypto & stock ticker for Waybar.
# Runs as a persistent process: fetches prices, then scrolls text by
# outputting shifted substrings at 20fps for smooth motion.
#
# Dependencies: curl, jq, bc
# APIs: CoinGecko (crypto), Alpha Vantage (stocks)
# Both are FREE but require a free API key — sign up at:
#   https://www.coingecko.com/en/api   (Demo plan)
#   https://www.alphavantage.co/support/#api-key

# ─── CONFIG ──────────────────────────────────────────────────────────────────
# Paste your free API keys here:
COINGECKO_API_KEY=""
ALPHAVANTAGE_API_KEY=""

# Crypto pairs — CoinGecko IDs (lowercase).
# Common IDs: bitcoin, ethereum, solana, dogecoin, cardano, ripple
CRYPTO_IDS=("bitcoin" "ethereum" "solana" "ripple")
CRYPTO_LABELS=("BTC" "ETH" "SOL" "XRP")

# Stock symbols — Alpha Vantage ticker symbols
STOCK_SYMBOLS=()

# Display width (characters visible in the Waybar label at once)
DISPLAY_WIDTH=35

# Scroll speed: seconds between each scroll step (0.05 = 20fps, very smooth)
SCROLL_SPEED=0.1

# Pause duration: seconds to pause at the start of each full cycle
SCROLL_PAUSE=2

# How often to re-fetch prices from APIs (seconds)
FETCH_INTERVAL=60

# Network timeout (seconds)
CURL_TIMEOUT=10

# Cache file for graceful fallback
CACHE_FILE="/tmp/waybar-ticker-cache.txt"
# ─── END CONFIG ──────────────────────────────────────────────────────────────

SEP="  ·  "

safe_curl() {
    curl -sf --max-time "$CURL_TIMEOUT" "$@" 2>/dev/null || echo ""
}

format_change() {
    local change="$1"
    if [[ -z "$change" || "$change" == "null" ]]; then
        echo "(?%)"
        return
    fi
    change="${change#+}"

    # Check sign using string matching — no bc needed
    if [[ "$change" == -* ]]; then
        echo "${change}%"
    elif [[ "$change" == "0.0" || "$change" == "0" || "$change" == "0.00" ]]; then
        echo "0.0%"
    else
        echo "+${change}%"
    fi
}

# Track changes for per-item coloring
declare -A ITEM_COLORS

fetch_crypto() {
    local ids_joined
    ids_joined=$(IFS=,; echo "${CRYPTO_IDS[*]}")

    local url="https://api.coingecko.com/api/v3/simple/price?ids=${ids_joined}&vs_currencies=usd&include_24hr_change=true"
    local headers=()
    if [[ -n "$COINGECKO_API_KEY" ]]; then
        headers=(-H "x-cg-demo-api-key: ${COINGECKO_API_KEY}")
    fi

    local response
    response=$(safe_curl "${headers[@]}" "$url")
    [[ -z "$response" ]] && return 1

    local items=()
    for i in "${!CRYPTO_IDS[@]}"; do
        local id="${CRYPTO_IDS[$i]}"
        local label="${CRYPTO_LABELS[$i]}"
        local price change

        price=$(echo "$response" | jq -r ".\"${id}\".usd // empty" 2>/dev/null)
        change=$(echo "$response" | jq -r ".\"${id}\".usd_24h_change // empty" 2>/dev/null)
        [[ -z "$price" ]] && continue

        # Format price: 2 decimals for >= $1, 4 decimals for sub-dollar
        local int_price
        int_price=$(printf "%.0f" "$price" 2>/dev/null || echo 0)
        if (( int_price >= 1 )); then
            price=$(printf "%.2f" "$price")
        else
            price=$(printf "%.4f" "$price")
        fi

        if [[ -n "$change" && "$change" != "null" ]]; then
            change=$(printf "%.1f" "$change")
        fi

        local fc
        fc=$(format_change "$change")
        items+=("${label} \$${price} (${fc})")
    done

    if [[ ${#items[@]} -gt 0 ]]; then
        local result="${items[0]}"
        for ((i=1; i<${#items[@]}; i++)); do
            result+="${SEP}${items[$i]}"
        done
        echo "$result"
    fi
}

fetch_stocks() {
    [[ -z "$ALPHAVANTAGE_API_KEY" || ${#STOCK_SYMBOLS[@]} -eq 0 ]] && return 1

    local items=()
    for symbol in "${STOCK_SYMBOLS[@]}"; do
        local url="https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${symbol}&apikey=${ALPHAVANTAGE_API_KEY}"
        local response
        response=$(safe_curl "$url")
        [[ -z "$response" ]] && continue

        local price change
        price=$(echo "$response" | jq -r '."Global Quote"."05. price" // empty' 2>/dev/null)
        change=$(echo "$response" | jq -r '."Global Quote"."10. change percent" // empty' 2>/dev/null)
        [[ -z "$price" ]] && continue

        price=$(printf "%.2f" "$price")

        if [[ -n "$change" && "$change" != "null" ]]; then
            change="${change%\%}"
            change=$(printf "%.1f" "$change")
        fi

        local fc
        fc=$(format_change "$change")
        items+=("${symbol} \$${price} (${fc})")
    done

    if [[ ${#items[@]} -gt 0 ]]; then
        local result="${items[0]}"
        for ((i=1; i<${#items[@]}; i++)); do
            result+="${SEP}${items[$i]}"
        done
        echo "$result"
    fi
}

# ─── FETCH ALL ───────────────────────────────────────────────────────────────
FULL_TEXT=""
TOOLTIP=""

fetch_all() {
    local crypto_text stock_text

    crypto_text=$(fetch_crypto 2>/dev/null || echo "")
    stock_text=$(fetch_stocks 2>/dev/null || echo "")

    if [[ -n "$crypto_text" && -n "$stock_text" ]]; then
        FULL_TEXT="${crypto_text}${SEP}${stock_text}"
    elif [[ -n "$crypto_text" ]]; then
        FULL_TEXT="$crypto_text"
    elif [[ -n "$stock_text" ]]; then
        FULL_TEXT="$stock_text"
    else
        if [[ -f "$CACHE_FILE" ]]; then
            FULL_TEXT=$(cat "$CACHE_FILE")
        else
            FULL_TEXT="Ticker: No data"
        fi
        return
    fi

    echo "$FULL_TEXT" > "$CACHE_FILE"
    TOOLTIP="Crypto &amp; Stock Ticker\nUpdated: $(date '+%H:%M:%S')"
}

# ─── MAIN LOOP ───────────────────────────────────────────────────────────────
main() {
    fetch_all

    local offset=0
    local last_fetch
    last_fetch=$(date +%s)
    local step_count=0

    while true; do
        # Re-fetch prices periodically
        local now
        now=$(date +%s)
        if (( now - last_fetch >= FETCH_INTERVAL )); then
            fetch_all
            last_fetch=$now
        fi

        # Build padded string that wraps seamlessly
        local padded="${FULL_TEXT}${SEP}${FULL_TEXT}${SEP}"
        local len=${#FULL_TEXT}
        local total_len=$(( len + ${#SEP} ))

        # Extract visible window
        local visible="${padded:$offset:$DISPLAY_WIDTH}"

        # Advance scroll position, wrap at one full copy
        offset=$(( (offset + 1) % total_len ))

        # Output Waybar JSON (plain text, no Pango — keeps it simple & fast)
        jq -cn \
            --arg text "$visible" \
            --arg tooltip "${TOOLTIP:-Ticker}" \
            --arg class "ticker" \
            '{text: $text, tooltip: $tooltip, class: $class}'

        # Brief pause at the start of each cycle so text is readable
        if (( offset == 0 )); then
            sleep "$SCROLL_PAUSE"
        else
            sleep "$SCROLL_SPEED"
        fi
    done
}

main
