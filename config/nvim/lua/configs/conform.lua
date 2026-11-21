return {
  formatters_by_ft = {
    go = { "gofmt", "goimports" },
    lua = { "stylua" },
    markdown = { "prettier" },
  },

  format_on_save = function(bufnr)
    local filetype = vim.bo[bufnr].filetype
    if filetype == "go" or filetype == "lua" or filetype == "markdown" then
      return { timeout_ms = 1000, lsp_fallback = true }
    end
  end,
}
