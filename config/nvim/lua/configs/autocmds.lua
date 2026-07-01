vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    vim.bo.modifiable = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 80

    local ok, cmp = pcall(require, "cmp")
    if ok then
      cmp.setup.buffer({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "async_path" },
          { name = "spell", keyword_length = 3, max_item_count = 8 },
        }),
      })
    end
  end,
})

local function set_spell_highlights()
  vim.api.nvim_set_hl(0, "SpellBad",   { undercurl = true, sp = "#fb4934" })
  vim.api.nvim_set_hl(0, "SpellCap",   { undercurl = true, sp = "#fabd2f" })
  vim.api.nvim_set_hl(0, "SpellRare",  { undercurl = true, sp = "#83a598" })
  vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#8ec07c" })
end

set_spell_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_spell_highlights,
})

