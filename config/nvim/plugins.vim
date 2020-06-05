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
" Linting
Plug 'w0rp/ale'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Fuzzy finding
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Snippet support
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" Print function signatures in echo area
Plug 'Shougo/echodoc.vim'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fubitive'

" Ember HTMLbars syntax highlighting
Plug 'joukevandermaas/vim-ember-hbs'

" Not exactly minimal but I don't want to have to think about language support
" right now
Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-rails'

" Improved syntax highlighting and indentation
Plug 'othree/yajs.vim'

" === UI === "
Plug 'tpope/vim-vinegar'

Plug 'junegunn/goyo.vim'

" Colorscheme
Plug 'morhetz/gruvbox'
Plug 'fxn/vim-monochrome'
Plug '~/projects/tachyon.vim'
Plug '~/projects/minimal-fedu.vim'

" Note taking
Plug 'vimwiki/vimwiki'

" Session Managment
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" Convenience
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

" Undo Tree
Plug 'simnalamburt/vim-mundo'

Plug 'terryma/vim-expand-region'
Plug 'jiangmiao/auto-pairs'
Plug 'adelarsq/vim-matchit'
Plug 'ntpeters/vim-better-whitespace'
" Tags
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" Spelling
Plug 'kamykn/spelunker.vim'

" Smoother Terminal experience
Plug 'kassio/neoterm'

" Initialize plugin system
call plug#end()
