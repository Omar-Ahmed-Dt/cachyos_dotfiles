-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  -- THEMES
  -- theme = "seoul256_dark",
  theme = "gruvbox",
  -- theme = "gruvchad",
  -- theme = "catppuccin",
  -- theme = "everforest",
  -- theme = "nord",
  -- theme = "tomorrow_night",
    --
  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    Visual = { bg = "#504945", fg = "#D5C4A1" },
  },
}

-- statusline
M.ui = {
    -- top bar(tabufline)
    tabufline = {
        order = { "buffers", "tabs" },
   },

    statusline = {
      theme = "default",  -- can be: "default", "vscode", "vscode_colored", "minimal"

      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "arrow", -- only affects default/minimal themes
      order = nil,
      modules = nil,
    },
    nvimtree = {
        enabled = false,
    }
}

-- Dashboard
M.nvdash = {
    load_on_startup = true,
    header = {
    "██╗  ██╗███████╗██████╗  █████╗ ",
    "██║  ██║██╔════╝██╔══██╗██╔══██╗",
    "███████║█████╗  ██████╔╝███████║",
    "██╔══██║██╔══╝  ██╔══██╗██╔══██║",
    "██║  ██║███████╗██║  ██║██║  ██║",
    "╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝",
    "                               ",
  },

}

return M
