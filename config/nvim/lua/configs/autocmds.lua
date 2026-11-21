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
    vim.opt_local.textwidth = 0 -- soft wrap only; prettier handles formatting
    vim.opt_local.conceallevel = 2

    -- move by visual line on wrapped text
    vim.keymap.set("n", "j", "gj", { buffer = true })
    vim.keymap.set("n", "k", "gk", { buffer = true })

    if vim.bo.filetype == "markdown" then
      vim.keymap.set("n", "<C-p>", "<cmd>MarkdownPreviewToggle<CR>", { desc = "markdown preview in browser", buffer = true })
    end

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

