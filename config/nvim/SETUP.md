# NvChad Setup Guide (Arch Linux)

[Vim Cheat Sheet](https://vim.rtorr.com/)

## 1. System Dependencies

```bash
sudo pacman -S neovim git nodejs npm python python-pip go ripgrep unzip curl
```

> **nodejs + npm** are required for markdown-preview.nvim and typescript LSP.
> **go** is required for go.nvim and gopls.

---

## 2. Install NvChad v2.5

Remove any existing Neovim config first:

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

Clone the NvChad starter:

```bash
git clone -b v2.5 https://github.com/NvChad/starter ~/.config/nvim
```

---

## 3. Copy Config Files

Replace the starter files with your custom config. The structure is:

```
~/.config/nvim/
├── init.lua
└── lua/
    ├── chadrc.lua
    ├── mappings.lua
    ├── options.lua
    ├── autocmds.lua
    ├── configs/
    │   ├── lazy.lua
    │   ├── lspconfig.lua
    │   ├── null_ls.lua
    │   ├── render_markdown.lua
    │   └── conform.lua
    └── plugins/
        ├── init.lua
        └── comment.lua
```

---

## 4. First Launch & Plugin Install

Open Neovim — Lazy will auto-install all plugins:

```bash
nvim
```

Wait for Lazy to finish. Then run inside Neovim:

```
:MasonInstallAll
```

---

## 5. Build markdown-preview.nvim (IMPORTANT)

This step is **not automatic** and must be done manually:

```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npm install
```

Or inside Neovim:

```
:Lazy build markdown-preview.nvim
```

> Without this step, `:MarkdownPreview` and `<C-p>` won't work.

---

## 6. Installed Plugins

| Plugin | Purpose |
|--------|---------|
| `iamcco/markdown-preview.nvim` | Live markdown preview in browser (`<C-p>`) |
| `MeanderingProgrammer/render-markdown.nvim` | Rendered markdown in Neovim editor |
| `ray-x/go.nvim` | Go LSP, formatting, and tools |
| `hashivim/vim-terraform` | Terraform syntax + auto-format on save |
| `nvimtools/none-ls.nvim` | Null-ls for extra linters/formatters |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source |
| `rest-nvim/rest.nvim` | HTTP client (`.http` files) |
| `williamboman/mason.nvim` | LSP/tool installer |

---

## 7. LSP Servers (auto-installed by Mason)

- `lua-language-server`, `stylua`
- `html-lsp`, `css-lsp`, `typescript-language-server`, `emmet-ls`, `json-lsp`
- `prettier`, `eslint-lsp`
- `bash-language-server`, `shfmt`, `shellcheck`
- `pyright`, `black`
- `terraform-ls`
- `ansible-language-server`
- `dockerfile-language-server`

---

## 8. Key Mappings

| Key | Mode | Action |
|-----|------|--------|
| `<C-p>` | Normal (markdown) | Toggle browser markdown preview |
| `<C-s>` | Normal | Save file |
| `<C-c>` | Normal | Copy whole file |
| `<leader>ff` | Normal | Find files (Telescope) |
| `<leader>fw` | Normal | Live grep (Telescope) |
| `<leader>fb` | Normal | Find buffers |
| `<leader>d` | Normal | Open dashboard |
| `<leader>x` | Normal | Close buffer |
| `<tab>` | Normal | Next buffer |
| `<S-tab>` | Normal | Previous buffer |
| `<A-v>` | Normal/Term | Toggle vertical terminal |
| `<A-h>` | Normal/Term | Toggle horizontal terminal |
| `<A-f>` | Normal/Term | Toggle floating terminal |
| `<leader>/` | Normal/Visual | Toggle comment |

---

## 9. Theme & UI

- **Theme**: `gruvchad` with transparency enabled
- **Statusline**: `default` theme with `arrow` separators
- **Dashboard**: Custom HERA ASCII header on startup
- **Comments**: italic style

---

## 10. Editor Settings

- Tab = 4 spaces
- Line wrap at column 100
- Relative + absolute line numbers
- Cursor crosshair (line + column highlight)
- Filename shown in winbar

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `:MarkdownPreview` not found | Run `npm install` in the plugin's `app/` dir (Step 5) |
| LSP not working | Run `:MasonInstallAll` then restart Neovim |
| go.nvim errors | Make sure `go` is installed and `$GOPATH/bin` is in `$PATH` |
| rest.nvim errors | Plugin uses hererocks — let it build on first load |
