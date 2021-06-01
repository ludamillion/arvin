" Always set autoindenting on
set autoindent

" Automatically read changes in the file
set autoread
"
" automatically write files when switching buffers
set autowrite

" Make backspace behave properly in insert mode
set backspace=indent,eol,start

" Use system clipboard; requires has('unnamedplus') to be 1
set clipboard=unnamedplus

set completeopt=menu,menuone,noselect

" Fold by syntax up to depth 10 but not by default
set foldmethod=syntax foldnestmax=10 nofoldenable foldlevel=1 

" User Ripgrep for grep commands
set grepprg=rg\ --vimgrep

" Hide buffers instead of closing them even if they contain unwritten changes
set hidden

" Searches are case insensitive...unless they contain at least one capital letter
set ignorecase smartcase

" Show split and live preview when doing :substitution
set inccommand=split

" Incremental search highlight
set incsearch

" Lazily redraw screen while executing macros, and other commands
set lazyredraw

set list
set listchars=tab:⊢\ ,trail:―,extends:…,precedes:…

set matchpairs+=<:>

" Show relative line numbers by default
set nonumber norelativenumber
set noshowmode


" Disable swap files
set noswapfile

" Disable soft wrap for lines
set nowrap

" Always show 2 lines above/below the cursor
set scrolloff=2                                               

" Don't give completion messages like 'match 1 of 2' or 'The only match'
set shortmess+=cI

" Display incomplete commands
set showcmd
set signcolumn=yes

" Vertical splits will be at the bottom
set splitbelow

" Horizontal splits will be to the right
set splitright

" Use two spaces for indentation
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set textwidth=120

" Time waited for key press(es) to complete...
set ttimeout

"  ...makes for a faster key response
set ttimeoutlen=10 timeoutlen=1000

" Better menu with completion in command mode
set wildmenu
set wildmode=longest:full,full

