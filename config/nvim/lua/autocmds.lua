require "nvchad.autocmds"
require "configs.autocmds"

-- sudo write
vim.api.nvim_create_user_command("W", function()
  vim.cmd('silent! write !sudo tee % > /dev/null')
  vim.cmd('edit!')
end, {})

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
