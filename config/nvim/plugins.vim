" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.config/nvim/plugged')

" === Infrastructure Plugins ===
"
" Language Server Protocol and completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" Linting
Plug 'dense-analysis/ale'

" Snippit support
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Fuzzy finding
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

Plug 'gcmt/taboo.vim'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" Not exactly minimal but I don't want to have to think about language support
" right now
Plug 'sheerun/vim-polyglot'

" Ember HTMLbars syntax highlighting
Plug 'joukevandermaas/vim-ember-hbs'
Plug 'mattn/emmet-vim'

Plug 'junegunn/goyo.vim'

" Colorscheme
Plug '~/code/liminal'

Plug 'norcalli/nvim-colorizer.lua'

" Note taking
Plug 'fcpg/vim-waikiki'
Plug 'alok/notational-fzf-vim'

" Tim Pope Land
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-rails'

Plug 'justinmk/vim-sneak'

" Auto save
Plug '907th/vim-auto-save'

" Opt-in autopairing
Plug 'tranvansang/vim-close-pair'

" Spelling
Plug 'kamykn/spelunker.vim'

" Terminal ease of use
Plug 'kassio/neoterm'

Plug '~/code/vim-reveal'

" Initialize plugin system
call plug#end()
