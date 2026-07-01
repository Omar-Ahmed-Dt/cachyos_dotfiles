require "nvchad.autocmds"

-- Gray background for markdown code blocks
vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#2a2a2a" })

-- sudo write
vim.api.nvim_create_user_command("W", function()
  vim.cmd('silent! write !sudo tee % > /dev/null')
  vim.cmd('edit!')
end, {})

-- Markdown: <C-p> to open preview
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<C-p>", ":MarkdownPreview<CR>", { noremap = true, silent = true, buffer = true })
  end,
})

-- ini/dosini comment string
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dosini", "ini" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

-- json/jsonc comment string
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jsonc", "json" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})
