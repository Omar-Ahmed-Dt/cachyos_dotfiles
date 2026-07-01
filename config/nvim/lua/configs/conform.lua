local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    go = { "gofmt", "goimports" },
    lua = { "stylua" },
    markdown = { "prettier" },
  },

  format_on_save = function(bufnr)
    local filetype = vim.bo[bufnr].filetype
    return filetype == "go" or filetype == "lua" or filetype == "markdown"
  end,
})

