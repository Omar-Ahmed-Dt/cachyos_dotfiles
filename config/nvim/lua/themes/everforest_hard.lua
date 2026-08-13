-- Everforest (dark, hard contrast) -- https://github.com/sainnhe/everforest
-- Palette sourced from sainnhe/everforest palette.md

local M = {}

M.base_30 = {
  white = "#D3C6AA",
  darker_black = "#1E2326", -- bg_dim
  black = "#272E33", -- bg0, nvim bg
  black2 = "#2E383C", -- bg1
  one_bg = "#2E383C", -- bg1
  one_bg2 = "#374145", -- bg2
  one_bg3 = "#414B50", -- bg3
  grey = "#495156", -- bg4
  grey_fg = "#4F5B58", -- bg5
  grey_fg2 = "#859289", -- grey1
  light_grey = "#9DA9A0", -- grey2
  red = "#E67E80",
  baby_pink = "#D699B6",
  pink = "#D699B6",
  line = "#374145", -- bg2, vertsplit
  green = "#83C092", -- aqua
  vibrant_green = "#A7C080", -- green
  nord_blue = "#7FBBB3", -- blue
  blue = "#7FBBB3",
  yellow = "#DBBC7F",
  sun = "#E69875", -- orange
  purple = "#D699B6",
  dark_purple = "#D699B6",
  teal = "#83C092", -- aqua
  orange = "#E69875",
  cyan = "#83C092", -- aqua
  statusline_bg = "#2E383C", -- bg1
  lightbg = "#374145", -- bg2
  pmenu_bg = "#83C092", -- aqua
  folder_bg = "#7FBBB3", -- blue
}

M.base_16 = {
  base00 = "#272E33",
  base01 = "#2E383C",
  base02 = "#374145",
  base03 = "#414B50",
  base04 = "#495156",
  base05 = "#D3C6AA",
  base06 = "#ddd0b4",
  base07 = "#e7dabe",
  base08 = "#83C092",
  base09 = "#D699B6",
  base0A = "#A7C080",
  base0B = "#DBBC7F",
  base0C = "#E69875",
  base0D = "#A7C080",
  base0E = "#E67E80",
  base0F = "#D699B6",
}

M.type = "dark"

M.polish_hl = {
  treesitter = {
    ["@tag"] = { fg = M.base_30.orange },
    ["@tag.delimiter"] = { fg = M.base_30.vibrant_green },
  },
  git = {
    DiffAdd = { fg = M.base_30.vibrant_green },
  },
}

M = require("base46").override_theme(M, "everforest_hard")

return M
