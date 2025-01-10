set number
set relativenumber
set tabstop=4
set mouse=a
let mapleader = " "
" Plugin installation with vim-plug
call plug#begin(stdpath('data') . '/plugged')

" Gruvbox theme
Plug 'morhetz/gruvbox'

Plug 'scottmckendry/cyberdream.nvim'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
" Web Dev Icons for Nvim Tree and other plugins
Plug 'kyazdani42/nvim-web-devicons'

" File explorer
Plug 'kyazdani42/nvim-tree.lua'

Plug 'petertriho/nvim-scrollbar'

Plug 'hrsh7th/nvim-cmp'             " Autocompletion plugin
Plug 'hrsh7th/cmp-buffer'           " Buffer completions
Plug 'hrsh7th/cmp-path'             " Path completions
Plug 'hrsh7th/cmp-nvim-lsp'         " LSP completions
Plug 'hrsh7th/cmp-nvim-lua'         " Lua API completions
Plug 'saadparwaiz1/cmp_luasnip'     " Snippet completions
Plug 'L3MON4D3/LuaSnip'             " Snippet engine
Plug 'neovim/nvim-lspconfig' 
Plug 'rafamadriz/friendly-snippets'

Plug 'onsails/lspkind.nvim'

call plug#end()

" Apply the Gruvbox theme
syntax enable
set background=dark
colorscheme cyberdream
highlight Normal guibg=NONE ctermbg=NONE
highlight NormalFloat guibg=NONE ctermbg=NONE
imap <C-c> <Esc>"+ygi
imap <C-x> <Esc>"+dgi
imap <C-v> <Esc>"+pa

set guicursor=n-v-c-i:block
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json,*.css,*.scss,*.md,*.html,*.go,*.java,*.vim execute 'silent! !prettier --write %' | silent! edit
autocmd CursorHold,FocusLost * silent! write
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

require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = {"truncate"},
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {mirror = false},
      vertical = {mirror = false},
    },
    file_ignore_patterns = {"node_modules", ".git/"},
  },
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })

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
    color = '#4B0082',  -- Hex code for color Indigo
}
,
    marks = {
        Search = { color = '#FFD700' },
        Error = { color = '#FF0000' },
        Warn = { color = '#FFA500' },
        Info = { color = '#00FFFF' },
        Hint = { color = '#00FF00' },
        Misc = { color = '#9400D3' },
    },
})

local cmp = require'cmp'
local lspkind = require'lspkind'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For LuaSnip users
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- Show both symbol and text
      maxwidth = 50,        -- Limit the width of the completion menu
      ellipsis_char = '...', -- Ellipsis for truncated items
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll up in docs
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll down in docs
    ['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion menu
    ['<C-e>'] = cmp.mapping.abort(),         -- Close the completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm completion
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item() -- Navigate to the next item in the menu
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump() -- Expand snippet or jump forward
      else
        fallback() -- Fallback to regular Tab behavior
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item() -- Navigate to the previous item in the menu
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1) -- Jump backward in snippets
      else
        fallback() -- Fallback to regular Shift-Tab behavior
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP-based completions
    { name = 'luasnip' },  -- Snippets
    { name = 'path' },     -- File path completions
  }, {
    { name = 'buffer' },   -- Buffer-based completions
  })
})

-- Command-line completion
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require("luasnip.loaders.from_vscode").lazy_load()

EOF

