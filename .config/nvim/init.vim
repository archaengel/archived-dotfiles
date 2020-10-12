" Native options
set number
set relativenumber
set termguicolors
set completeopt=menuone,noinsert,noselect
set colorcolumn=80
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set incsearch
set nohlsearch
set scrolloff=8
set smartcase
set updatetime=50
set listchars=tab:>\ ,trail:-,nbsp:+,space:•
set list
set signcolumn=yes:1
set path=.
set re=0


" Specify a directory for plugins
call plug#begin(stdpath("data") . "/plugged")
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tpope/vim-commentary'
Plug 'norcalli/nvim_utils'
Plug 'gruvbox-community/gruvbox'
Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'
call plug#end()

let g:gruvbox_contrast_dark='hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

colorscheme gruvbox
set background=dark
set syntax

" Neoformat
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_javascript_prettier = {
      \ 'exe': './node_modules/.bin/prettier',
      \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
      \ 'stdin': 1,
      \ }

augroup Linting
    autocmd!
    autocmd BufWritePre *.js Neoformat
    autocmd BufWritePre *.rs Neoformat
augroup END

augroup Indentation
    autocmd!
    autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2
augroup END

" Setup language server
lua <<EOF
    local nvim_lsp = require'nvim_lsp'
    nvim_lsp.tsserver.setup{ on_attach=require'completion'.on_attach }
    nvim_lsp.rls.setup{ on_attach=require'completion'.on_attach }
    nvim_lsp.jedi_language_server.setup{
        on_attach=require'completion'.on_attach
    }
    nvim_lsp.sumneko_lua.setup{
        on_attach=require'completion'.on_attach,
        settings={
            Lua={
                runtime={ version="LuaJIT", path=vim.split(package.path, ';'), },
                diagnostics={
                    enable=true,
                    globals={ "vim" },
                },
                workspace={
                    library={
                        [vim.fn.expand("$VIMRUNTIME/lua")]=true,
                    },
                },
            }
        }
    }
EOF


