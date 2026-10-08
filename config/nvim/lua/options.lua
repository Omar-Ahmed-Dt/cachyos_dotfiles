require "nvchad.options"

local opt = vim.opt

-- Horizontal and vertical crosshair
opt.cursorline = true
opt.cursorcolumn = true
opt.cursorlineopt = "number,line"

vim.cmd [[
  highlight CursorLine guibg=#2c2c2c
  highlight CursorColumn guibg=#2c2c2c
  highlight ColorColumn guibg=#2c2c2c
]]

-- Guide at column 100
opt.colorcolumn = "100"
opt.textwidth = 0

opt.wrap = true
opt.linebreak = true

-- Other UX defaults
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- opt.winbar = "%f"
opt.clipboard = ""
