return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },
    -- Terraform syntax highlighting and formatting
    {
        "hashivim/vim-terraform",
        ft = { "terraform", "tf", "hcl" },
        config = function()
            vim.g.terraform_fmt_on_save = 1
            vim.g.terraform_align = 1
        end,
    },
    -- Go LSP
    {
        "ray-x/go.nvim",
        dependencies = { { "ray-x/guihua.lua", build = "cd lua/fzy && make" } },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },
    -- Autocompletion (nvim-cmp already in NVChad, just extend)
    {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter",
    },
    { "f3fora/cmp-spell", lazy = true },
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.null_ls")
        end,
    },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_start = 0
        end,
    },
    -- markdown preview in a file
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("configs.render_markdown").setup()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "lua", "json", "http", "bash", "terraform", "hcl",
            },
        },
    },
    -- REST client (with hererocks to fix Lua 5.4 vs 5.1 mismatch)
    {
        "rest-nvim/rest.nvim",
        ft = { "http" },
        dependencies = { "nvim-lua/plenary.nvim" },
        rocks = {
            hererocks = true,
        },
        config = function()
            require("rest-nvim").setup({
                result_split_horizontal = false,
                skip_ssl_verification = false,
                highlight = {
                    enabled = true,
                    timeout = 150,
                },
                result = {
                    show_url = true,
                    show_curl_command = true,
                    show_http_info = true,
                    show_headers = true,
                },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- lua stuff
                "lua-language-server",
                "stylua",
                -- web dev
                "css-lsp",
                "html-lsp",
                "typescript-language-server",
                "emmet-ls",
                "json-lsp",
                "prettier",
                "eslint-lsp",
                -- shell
                "bash-language-server",
                "shfmt",
                "shellcheck",
                -- python
                "pyright",
                "black",
                -- terraform
                "terraform-ls",
                -- ansible
                "ansible-language-server",
                -- docker
                "dockerfile-language-server",
                -- markdown
                "markdownlint",
            },
        },
    },
    -- markdown table editing: <Leader>tm to toggle, || for rows
    {
        "dhruvasagar/vim-table-mode",
        ft = { "markdown" },
        init = function()
            vim.g.table_mode_corner = "|"
        end,
    },
}
