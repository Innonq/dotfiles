-- monokai.lua (transparent, no plugins)

vim.opt.termguicolors = true
vim.cmd("highlight clear")
vim.cmd("syntax reset")
vim.g.colors_name = "monokai-transparent"

local c = {
  fg       = "#F8F8F2",
  red      = "#F92672",
  green    = "#A6E22E",
  yellow   = "#E6DB74",
  blue     = "#66D9EF",
  magenta  = "#AE81FF",
  cyan     = "#A1EFE4",
  gray     = "#75715E",
  darkgray = "#3E3D32",
}

local set = vim.api.nvim_set_hl

-- Editor (no bg)
set(0, "Normal",       { fg = c.fg, bg = "none" })
set(0, "NormalFloat",  { fg = c.fg, bg = "none" })
set(0, "EndOfBuffer",  { fg = c.darkgray })
set(0, "CursorLine",   { bg = "#2A2A2A" }) -- subtle line highlight
set(0, "LineNr",       { fg = c.gray })
set(0, "CursorLineNr", { fg = c.yellow, bold = true })
set(0, "Visual",       { bg = "#3E4452" })
set(0, "Search",       { fg = "#000000", bg = c.yellow })
set(0, "IncSearch",    { fg = "#000000", bg = c.red })
set(0, "MatchParen",   { fg = c.red, bold = true })

-- Syntax
set(0, "Comment",    { fg = c.gray, italic = true })
set(0, "Constant",   { fg = c.cyan })
set(0, "String",     { fg = c.yellow })
set(0, "Character",  { fg = c.yellow })
set(0, "Number",     { fg = c.magenta })
set(0, "Boolean",    { fg = c.magenta })
set(0, "Identifier", { fg = c.blue })
set(0, "Function",   { fg = c.green })
set(0, "Statement",  { fg = c.red })
set(0, "Keyword",    { fg = c.red })
set(0, "Operator",   { fg = c.red })
set(0, "PreProc",    { fg = c.magenta })
set(0, "Type",       { fg = c.blue })
set(0, "Special",    { fg = c.cyan })

-- Diagnostics (built-in LSP)
set(0, "DiagnosticError", { fg = c.red })
set(0, "DiagnosticWarn",  { fg = c.yellow })
set(0, "DiagnosticInfo",  { fg = c.blue })
set(0, "DiagnosticHint",  { fg = c.cyan })

-- UI (transparent)
set(0, "Pmenu",      { fg = c.fg, bg = "none" })
set(0, "PmenuSel",   { fg = "#000000", bg = c.blue })
set(0, "StatusLine", { fg = c.fg, bg = "none" })
set(0, "VertSplit",  { fg = c.darkgray, bg = "none" })
set(0, "FloatBorder",{ fg = c.blue, bg = "none" })

