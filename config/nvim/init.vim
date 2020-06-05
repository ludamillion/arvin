scriptencoding utf-8
source ~/.config/nvim/plugins.vim

let mapleader="\<Space>"

" Set options {{{
set autoindent                                                " Always set autoindenting on
set autoread                                                  " Automatically read changes in the file
set autowrite                                                 " automatically write files when switching buffers
set backspace=indent,eol,start                                " Make backspace behave properly in insert mode
set clipboard=unnamedplus                                     " Use system clipboard; requires has('unnamedplus') to be 1
set colorcolumn=151                                           " Display text width column
set completeopt=longest,menuone,preview                       " Better insert mode completions
set foldmethod=syntax foldnestmax=10 nofoldenable foldlevel=1 " Fold by syntax up to depth 10 but not by default
set formatoptions-=co                                         " Disable auto comments on new lines in normal mode
set grepprg=rg\ --vimgrep                                     " User Ripgrep for grep commands
set hidden                                                    " Hide buffers instead of closing them even if they contain unwritten changes
set ignorecase smartcase                                      " Searches are case insensitive...unless they contain at least one capital letter
set inccommand=split                                          " Show split and live preview when doing :substitution
set incsearch                                                 " Incremental search highlight
set laststatus=2                                              " Always display the status bar
set lazyredraw                                                " Lazily redraw screen while executing macros, and other commands
set list
set listchars=tab:⊢\ ,trail:░
set number relativenumber                                     " Show relative line numbers by default
set noshowmode
set noswapfile                                                " Disable swap files
set nowrap                                                    " Disable soft wrap for lines
set scrolloff=2                                               " Always show 2 lines above/below the cursor
set shortmess+=c                                              " Don't give completion messages like 'match 1 of 2' or 'The only match'
set showcmd                                                   " Display incomplete commands
set splitbelow                                                " Vertical splits will be at the bottom
set splitright                                                " Horizontal splits will be to the right
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab            " Use two spaces for indentation
set textwidth=120
set ttimeout                                                  " Time waited for key press(es) to complete...
set ttimeoutlen=50                                            "  ...makes for a faster key response
set wildmenu                                                  " Better menu with completion in command mode
set wildmode=longest:full,full
" }}}

nnoremap ! :!
nnoremap s :w<cr>

"replace the word under cursor
nnoremap <leader>* :%s/\<<c-r><c-w>\>//g<left><left>

" move lines around
nnoremap <leader>j :m+<cr>==
nnoremap <leader>k :m-2<cr>==
xnoremap <leader>k :m-2<cr>gv=gv
xnoremap <leader>j :m'>+<cr>gv=gv

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" === FZF === "

let g:fzf_layout = { 'window': { 'width': 0.90, 'height': 0.8 } }

command! -bang ProjectFiles call fzf#vim#files(getcwd(), <bang>0)

" === Coc.nvim === "
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 1 | pclose | endif
" autocmd CursorHold * silent call CocActionAsync('highlight')

let g:coc_global_extensions = ['coc-tsserver', 'coc-css', 'coc-json', 'coc-html', 'coc-vimlsp', 'coc-highlight', 'coc-ember']

" === NeoSnippet === "
" Map <C-k> as shortcut to activate snippet if available
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

let g:neosnippet#snippets_directory='~/.config/nvim/snippets'
let g:neosnippet#enable_conceal_markers = 0

" === echodoc === "
let g:echodoc#enable_at_startup = 1

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0

" === Signify === "
let g:signify_sign_delete = '-'

" === Notes === "
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

" Session Management
let g:session_autoload = 'no'

let g:better_whitespace_guicolor='#d08770'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Color Scheme and Status Line {{{
" extracted from https://github.com/krisezra87/dotvim/blob/master/vimrc
highlight CursorLineNR cterm=bold ctermbg=NONE

function! GitInfo()
    let l:longpath = FugitiveGitDir()
    let l:branch = FugitiveHead()
    if empty(l:branch)
      return ''
    endif
    let l:taildir = fnamemodify(l:longpath,':t')
    if l:taildir ==# '.git'
        let l:repo = fnamemodify(l:longpath,':~:h:t')
    else
        " We have just encountered a submodule
        let l:repo = l:taildir
    endif
    return l:repo . '|' . l:branch
endfunction

" Function: display errors from Ale in statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('[Lint %d:%d]', l:all_non_errors, l:all_errors)
endfunction

set statusline=
set statusline+=%#Search#
set statusline+=\ %{GitInfo()}\ 
set statusline+=%#Normal#
set statusline+=%=
set statusline+=%.80f\ %m\[%{&filetype}\]
set statusline+=%#Search#
set statusline+=%{LinterStatus()}

"}}}

" Enable true color support
if (has("termguicolors"))
 set termguicolors
endif

" hi! Comment cterm=italic gui=italic

" set background=dark
" let g:monochrome_italic_comments = 1
colorscheme tachyon
"
" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type

hi! link ALEWarning WarningMsg
hi! link ALEErrorSign WarningMsg
hi! link ALEWarningSign Number

hi! LineNr ctermbg=NONE guibg=NONE
hi! SignColumn ctermbg=NONE guibg=NONE

" Highlight git change signs
hi! SignifySignAdd guifg=#99c794
hi! SignifySignDelete guifg=#ec5f67
hi! SignifySignChange guifg=#c594c5

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of preview window when open
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction

function! CycleLineNumbers()
  if &l:rnu == 0 && &l:nu == 0
    setlocal rnu nu
  elseif &l:rnu == 1
    setlocal nornu nu
  elseif &l:rnu == 0 && &l:nu == 1
    setlocal nornu nonu
  endif
endfunction

" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" Move to previous buffer and kill 'current' buffer
noremap <leader>x :bp<Bar>bd #<CR>

" Indent closer to home
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" use Q to replay q macro (q is for quick)
nnoremap Q @q

" Substitute
nnoremap <c-s> :%s/
vnoremap <c-s> :s/

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
vnoremap L g_

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit + SJL
augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute 'normal! g`"zvzz' |
    \ endif
augroup END

fun! VexToggle(dir)
  if exists("t:vex_buf_nr")
    call VexClose()
  else
    call VexOpen(a:dir)
  endif
endf

fun! VexOpen(dir)
  let g:netrw_browse_split=4    " open files in previous window
  let vex_width = 40

  execute "Vexplore " . a:dir
  let t:vex_buf_nr = bufnr("%")
  wincmd H

  call VexSize(vex_width)
endf

fun! VexClose()
  let cur_win_nr = winnr()
  let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

  1wincmd w
  close
  unlet t:vex_buf_nr

  execute (target_nr - 1) . "wincmd w"
  call NormalizeWidths()
endf

fun! VexSize(vex_width)
  execute "vertical resize" . a:vex_width
  set winfixwidth
  call NormalizeWidths()
endf

fun! NormalizeWidths()
  let eadir_pref = &eadirection
  set eadirection=hor
  set equalalways! equalalways!
  let &eadirection = eadir_pref
endf

augroup NetrwGroup
  autocmd! BufEnter * call NormalizeWidths()
augroup END

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "
"
" === FZF shorcuts === "
nmap ; :Buffers<CR>
nmap <leader>p :ProjectFiles<CR>
nmap <leader>s :Rg<CR>

nmap <leader>m :call VexToggle("")<cr>
nmap <leader>n :call VexToggle(getcwd())<cr>

" Toggle line numbers
nnoremap <leader>N :call CycleLineNumbers()<cr>

" Tagbar
nnoremap <leader>t :TagbarToggle<cr>

" === coc.nvim === "
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)

" === Search shorcuts === "
"   <leader>h - Find and replace
map <leader>h :%s///<left><left>

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" Delete current visual selection and dump in black hole buffer before pasting
" Used when you want to paste over something without it getting copied to
" Vim's default buffer
vnoremap <leader>p "_dP

nnoremap <leader>B :enew<cr>

"cycle between last two open buffers
nnoremap <leader><leader> <c-^>

" Uppercase U undoes undo
nmap U <C-r>

vmap v <Plug>(expand_region_expand)
vmap V <Plug>(expand_region_shrink)

inoremap <C-q> <c-o>gqap

" Quickly drop back to normal mode in terminal mode
tnoremap jj <C-\><C-n>

nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

"move to the split in the direction shown, or create a new split
nnoremap <silent> <C-h> :call WinMove('h')<cr>
nnoremap <silent> <C-j> :call WinMove('j')<cr>
nnoremap <silent> <C-k> :call WinMove('k')<cr>
nnoremap <silent> <C-l> :call WinMove('l')<cr>
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

set tags^=.git/tags

nnoremap <leader>g :Gstatus<CR>

nnoremap j gj
nnoremap k gk

"keep text selected after indentation
vnoremap < <gv
vnoremap > >gv

" Feature toggles

let g:goyo_width = 120
nnoremap <leader>F :Goyo<cr>

" === Spelunker ===
nnoremap <silent> <leader>zn :call spelunker#jump_next()<cr>
nnoremap <silent> <leader>zp :call spelunker#jump_prev()<cr>
nnoremap <silent> <leader>zl :call spelunker#correct_all_from_list()<cr>
nnoremap <silent> <leader>zg :call spelunker#execute_with_target_word('spellgood')<cr>

let g:spelunker_check_type = 1
"
" Override highlight setting.
highlight SpelunkerSpellBad cterm=underline ctermfg=16 gui=underline guifg=#af9e9e
highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE

" ============================================================================ "
" ===                                 MISC.                                === "
" ============================================================================ "

" Automatically switch to insert mode when entering a terminal buffer and back
" to normal mode when leaving
augroup TerminalBehavior
  " Start terminal in insert mode
  autocmd!
  au BufEnter * if &buftype == 'neoterm' | :startinsert | endif
  au BufLeave * if &buftype == 'neoterm' | :stopinsert | endif
  au BufEnter, BufRead  * if &buftype == 'neoterm' | :setlocal nonumber norelativenumber | endif
  nnoremap <silent> <leader>T :Ttoggle<CR>
  tnoremap <C-x> <C-\><C-n><C-w>q
augroup END

let g:neoterm_default_mod="vertical"

" Extend the global default (NOTE: Remove comments in dictionary before sourcing)
call expand_region#custom_text_objects({
  \ 'a]'  :1,
  \ 'ab'  :1,
  \ 'aB'  :1,
  \ 'ii'  :0,
  \ 'ai'  :0,
  \ 'a"'  :0,
  \ 'a''' :0,
  \ })

" Use the global default + the following for ruby
call expand_region#custom_text_objects('ruby', {
  \ 'im' :1,
  \ 'am' :1,
  \ })

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backup

" Ale Setup
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'ruby': ['rubocop'],
  \ 'css': ['prettier'],
  \ 'scss': ['stylelint']
  \ }

let g:ale_ruby_rubocop_executable = 'bin/rubocop'
let g:ale_javascript_eslint_executable = 'npm run lint'

let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

function! s:BufferCount() abort
    return len(filter(range(1, bufnr('$')), 'bufwinnr(v:val) != -1'))
endfunction

function! s:LListToggle() abort
    let buffer_count_before = s:BufferCount()
    " Location list can't be closed if there's cursor in it, so we need
    " to call lclose twice to move cursor to the main pane
    silent! lclose
    silent! lclose

    if s:BufferCount() == buffer_count_before
        execute "silent! lopen " . 15
    endif
endfunction

nnoremap <leader>l :nohlsearch<cr>

autocmd! InsertEnter * set nohlsearch

if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif

autocmd! FileType help wincmd H

nmap <leader>hg :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" vim:foldmethod=marker:foldlevel=0
