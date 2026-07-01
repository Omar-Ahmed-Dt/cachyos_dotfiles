-- ~/.config/nvim/lua/configs/render_markdown.lua
local M = {}

-- Gruvbox color palette
-- local colors = {
--   bg0     = "#282828",
--   bg1     = "#3c3836",
--   bg2     = "#504945",
--   bg3     = "#665c54",
--   bg4     = "#7c6f64",
--   fg0     = "#fbf1c7",
--   fg1     = "#ebdbb2",
--   fg2     = "#d5c4a1",
--   fg3     = "#bdae93",
--   fg4     = "#a89984",
--   red     = "#fb4934",
--   green   = "#b8bb26",
--   yellow  = "#fabd2f",
--   blue    = "#83a598",
--   purple  = "#d3869b",
--   aqua    = "#8ec07c",
--   orange  = "#fe8019",
--   -- Dimmed background variants for heading backgrounds
--   red_bg    = "#3c1f1e",
--   green_bg  = "#2e3518",
--   yellow_bg = "#3c3219",
--   blue_bg   = "#2b3339",
--   purple_bg = "#3b2e35",
--   aqua_bg   = "#2b3530",
--   orange_bg = "#3c2e1e",
-- }

local colors = {
  bg0 = "#282828",
  bg1 = "#3c3836",
  bg2 = "#504945",
  bg3 = "#665c54",
  bg4 = "#7c6f64",

  fg0 = "#fbf1c7",
  fg1 = "#ebdbb2",
  fg2 = "#d5c4a1",
  fg3 = "#bdae93",
  fg4 = "#a89984",

  red    = "#cc241d",
  green  = "#98971a",
  yellow = "#d79921",
  blue   = "#458588",
  purple = "#b16286",
  aqua   = "#689d6a",
  orange = "#d65d0e",

  bright_red    = "#fb4934",
  bright_green  = "#b8bb26",
  bright_yellow = "#fabd2f",
  bright_blue   = "#83a598",
  bright_purple = "#d3869b",
  bright_aqua   = "#8ec07c",
  bright_orange = "#fe8019",
}

local function set_highlights()
  local hl = vim.api.nvim_set_hl

  -- Heading foregrounds (icon colors)
  hl(0, "RenderMarkdownH1", { fg = colors.red, bold = true })
  hl(0, "RenderMarkdownH2", { fg = colors.orange, bold = true })
  hl(0, "RenderMarkdownH3", { fg = colors.yellow, bold = true })
  hl(0, "RenderMarkdownH4", { fg = colors.green, bold = true })
  hl(0, "RenderMarkdownH5", { fg = colors.blue, bold = true })
  hl(0, "RenderMarkdownH6", { fg = colors.purple, bold = true })

  -- Heading backgrounds (full-line bg behind headings)
  hl(0, "RenderMarkdownH1Bg", { fg = colors.red, bg = colors.red_bg, bold = true })
  hl(0, "RenderMarkdownH2Bg", { fg = colors.orange, bg = colors.orange_bg, bold = true })
  hl(0, "RenderMarkdownH3Bg", { fg = colors.yellow, bg = colors.yellow_bg, bold = true })
  hl(0, "RenderMarkdownH4Bg", { fg = colors.green, bg = colors.green_bg, bold = true })
  hl(0, "RenderMarkdownH5Bg", { fg = colors.blue, bg = colors.blue_bg, bold = true })
  hl(0, "RenderMarkdownH6Bg", { fg = colors.purple, bg = colors.purple_bg, bold = true })

  -- Code blocks
  hl(0, "RenderMarkdownCode", { bg = colors.bg1 })
  hl(0, "RenderMarkdownCodeBorder", { fg = colors.bg4, bg = colors.bg1 })
  hl(0, "RenderMarkdownCodeInline", { bg = colors.bg1 })
  hl(0, "RenderMarkdownCodeInfo", { fg = colors.fg4 })
  hl(0, "RenderMarkdownCodeFallback", { fg = colors.fg4 })

  -- Bullets
  hl(0, "RenderMarkdownBullet", { fg = colors.orange })

  -- Checkboxes
  hl(0, "RenderMarkdownUnchecked", { fg = colors.fg4 })
  hl(0, "RenderMarkdownChecked", { fg = colors.green })
  hl(0, "RenderMarkdownTodo", { fg = colors.yellow })

  -- Quotes (per-level cycling)
  hl(0, "RenderMarkdownQuote1", { fg = colors.blue })
  hl(0, "RenderMarkdownQuote2", { fg = colors.purple })
  hl(0, "RenderMarkdownQuote3", { fg = colors.aqua })
  hl(0, "RenderMarkdownQuote4", { fg = colors.green })
  hl(0, "RenderMarkdownQuote5", { fg = colors.yellow })
  hl(0, "RenderMarkdownQuote6", { fg = colors.orange })

  -- Dash / thematic break
  hl(0, "RenderMarkdownDash", { fg = colors.bg4 })

  -- Links
  hl(0, "RenderMarkdownLink", { fg = colors.aqua, underline = true })
  hl(0, "RenderMarkdownLinkTitle", { fg = colors.aqua })
  hl(0, "RenderMarkdownWikiLink", { fg = colors.blue, underline = true })

  -- Tables
  hl(0, "RenderMarkdownTableHead", { fg = colors.blue, bold = true })
  hl(0, "RenderMarkdownTableRow", { fg = colors.fg4 })

  -- Callout semantic highlights
  hl(0, "RenderMarkdownInfo", { fg = colors.blue })
  hl(0, "RenderMarkdownSuccess", { fg = colors.green })
  hl(0, "RenderMarkdownHint", { fg = colors.purple })
  hl(0, "RenderMarkdownWarn", { fg = colors.yellow })
  hl(0, "RenderMarkdownError", { fg = colors.red })
  hl(0, "RenderMarkdownQuote", { fg = colors.fg3, italic = true })

  -- Misc
  hl(0, "RenderMarkdownSign", { fg = colors.bg4 })
  hl(0, "RenderMarkdownMath", { fg = colors.blue })
  hl(0, "RenderMarkdownInlineHighlight", { bg = colors.yellow_bg, fg = colors.yellow })
  hl(0, "RenderMarkdownIndent", { fg = colors.bg3 })
  hl(0, "RenderMarkdownHtmlComment", { fg = colors.bg4, italic = true })
end

M.setup = function()
  -- Apply gruvbox highlights before plugin setup
  set_highlights()

  require("render-markdown").setup({
    enabled = true,
    render_modes = { "n", "v" },
    -- Headings
    heading = {
      enabled = true,
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
    },
    -- Bullets
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    -- Checkboxes
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰄵 " },
    },
    -- Blockquotes
    quote = {
      enabled = true,
      icon = "▍",
    },
    -- Code blocks
    code = {
      enabled = true,
      style = "full",
      highlight = "RenderMarkdownCode",
    },
    -- Links
    link = {
      enabled = true,
      icon = "󰌷 ",
    },
  })

  -- Re-apply after ColorScheme changes to persist the theme
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_highlights,
  })
end

return M
