set number
set relativenumber
set tabstop=4
set mouse=a
" Plugin installation with vim-plug
call plug#begin(stdpath('data') . '/plugged')

" Gruvbox theme
Plug 'morhetz/gruvbox'

" Web Dev Icons for Nvim Tree and other plugins
Plug 'kyazdani42/nvim-web-devicons'

" File explorer
Plug 'kyazdani42/nvim-tree.lua'

Plug 'petertriho/nvim-scrollbar'

call plug#end()

" Apply the Gruvbox theme
syntax enable
set background=dark
colorscheme gruvbox
highlight Normal guibg=NONE ctermbg=NONE
highlight NormalFloat guibg=NONE ctermbg=NONE

lua << EOF
local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Key mappings
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts("Open"))
    vim.keymap.set('n', 'o', api.node.open.edit, opts("Open"))
    vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts("Open"))
    vim.keymap.set('n', 'l', api.node.open.edit, opts("Expand Folder"))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts("Collapse Folder"))
end

require("nvim-tree").setup {
    on_attach = my_on_attach,
    view = {
        side = "left",
        width = 30,
    },
    renderer = {
        icons = {
            glyphs = {
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                },
            },
        },
    },
    filters = {
        git_ignored = false,
        dotfiles = false,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
}

require('scrollbar').setup({
    show = true,
    handle = {
        color = '#FFD700', -- Gold color, you can change this
    },
    marks = {
        Search = { color = '#FFD700' },
        Error = { color = '#FF0000' },
        Warn = { color = '#FFA500' },
        Info = { color = '#00FFFF' },
        Hint = { color = '#00FF00' },
        Misc = { color = '#9400D3' },
    },
})

EOF
