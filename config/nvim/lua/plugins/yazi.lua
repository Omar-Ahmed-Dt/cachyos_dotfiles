return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- {
    --   "<leader>y",
    --   "<cmd>Yazi<cr>",
    --   desc = "Open yazi at current file",
    -- },
    {
      "<leader>y",
      "<cmd>Yazi<cr>",
      desc = "Open yazi at current file",
    },
    {
      "<leader>Y",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume last yazi session",
    },
  },
  opts = {
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  },
  init = function()
    -- Disable netrw so yazi handles directories
    vim.g.loaded_netrwPlugin = 1
  end,
}
