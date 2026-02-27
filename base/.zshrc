# #######################################################################################
# ZSH CONFIGURATION - Minimal
# #######################################################################################


###################
### HISTORY ###
###################
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

###################
### COMPLETION ###
###################
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

###################
###   ALIASES   ###
###################

# Quality of Life Aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

###################
### KEYBINDINGS ###
###################
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end


###################
### PROMPT WITH GIT ###
###################
autoload -U colors && colors

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' stagedstr '%F{yellow}+%f'
zstyle ':vcs_info:git:*' formats ' %F{cyan}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{cyan}(%b|%a%u%c)%f'
zstyle ':vcs_info:*' enable git

PROMPT='%F{cyan}%~%f%F{magenta}${vcs_info_msg_0_}%f %F{green}❯%f '
RPROMPT='%F{250}%D{%H:%M:%S}%f'

###################
### PLUGINS ###
###################
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


###################
### ENVIRONMENT ###
###################
export EDITOR=nvim
export VISUAL=nvim
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PATH="$HOME/.local/bin:$PATH"

###################
### MISC OPTIONS ###
###################
setopt AUTO_CD
setopt NO_BEEP

stty stop undef
