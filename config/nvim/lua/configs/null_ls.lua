local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Go formatting is handled by conform.lua (gofmt + goimports)
    -- null_ls.builtins.diagnostics.markdownlint, -- enable after: :MasonInstall markdownlint
  },
})
