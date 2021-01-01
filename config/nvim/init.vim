scriptencoding utf-8
source ~/.config/nvim/plugins.vim

let mapleader="\<Space>"
let maplocalleader = "\<F7>"

" Set options {{{
set autoindent                                                " Always set autoindenting on
set autoread                                                  " Automatically read changes in the file
set autowrite                                                 " automatically write files when switching buffers
set backspace=indent,eol,start                                " Make backspace behave properly in insert mode
set clipboard=unnamedplus                                     " Use system clipboard; requires has('unnamedplus') to be 1
set completeopt=menu,menuone,noinsert,noselect
set foldmethod=syntax foldnestmax=10 nofoldenable foldlevel=1 " Fold by syntax up to depth 10 but not by default
set grepprg=rg\ --vimgrep                                     " User Ripgrep for grep commands
set hidden                                                    " Hide buffers instead of closing them even if they contain unwritten changes
set ignorecase smartcase                                      " Searches are case insensitive...unless they contain at least one capital letter
set inccommand=split                                          " Show split and live preview when doing :substitution
set incsearch                                                 " Incremental search highlight
set lazyredraw                                                " Lazily redraw screen while executing macros, and other commands
set list
set listchars=tab:⊢\ ,trail:░
set matchpairs+=<:>
set number relativenumber                                 " Show relative line numbers by default
set noshowmode
set noswapfile                                                " Disable swap files
set nowrap                                                    " Disable soft wrap for lines
set scrolloff=2                                               " Always show 2 lines above/below the cursor
set shortmess+=c                                              " Don't give completion messages like 'match 1 of 2' or 'The only match'
set showcmd                                                   " Display incomplete commands
set signcolumn=yes
set splitbelow                                                " Vertical splits will be at the bottom
set splitright                                                " Horizontal splits will be to the right
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab            " Use two spaces for indentation
set textwidth=120
set ttimeout                                                  " Time waited for key press(es) to complete...
set ttimeoutlen=10 timeoutlen=1000                            "  ...makes for a faster key response
set wildmenu                                                  " Better menu with completion in command mode
set wildmode=longest:full,full
" }}}

nnoremap ! :!
nnoremap <leader>w :w<cr>

"replace the word under cursor
nnoremap <leader>* :%s/\<<c-r><c-w>\>//g<left><left>

" move lines around
nnoremap <silent> <c-j> :m+<cr>==
nnoremap <silent> <c-k> :m-2<cr>==
xnoremap <silent> <c-k> :m-2<cr>gv=gv
xnoremap <silent> <c-j> :m'>+<cr>gv=gv

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" lua << END
"   require'lspconfig'.solargraph.setup{}
"   require'lspconfig'.tsserver.setup{}
"   require'lspconfig'.cssls.setup{}
"   require'lspconfig'.html.setup{}
"   require'lspconfig'.vimls.setup{}
" END

" nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> gR <cmd>lua vim.lsp.buf.rename()<CR>
:lua << EOF
  local nvim_lsp = require('lspconfig')

  local on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xd', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- This will disable virtual text, like doing:
      -- let g:diagnostic_enable_virtual_text = 0
      virtual_text = true,

      -- This is similar to:
      -- let g:diagnostic_show_sign = 1
      -- To configure sign display,
      --  see: ":help vim.lsp.diagnostic.set_signs()"
      signs = true,

      -- This is similar to:
      -- "let g:diagnostic_insert_delay = 1"
      update_in_insert = false,
    }
  )

  nvim_lsp.diagnosticls.setup {
    on_attach = on_attach_vim,
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "css",
      "scss",
      "markdown",
      -- "pandoc",
    },
    init_options = {
      linters = {
        eslint = {
          command = "eslint",
          rootPatterns = {".git", ".eslintrc.cjs", ".eslintrc", ".eslintrc.json", ".eslintrc.js"},
          debounce = 100,
          args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
          sourceName = "eslint",
          parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "[eslint] ${message} [${ruleId}]",
            security = "severity",
          },
          securities = {[2] = "error", [1] = "warning"},
        },
        markdownlint = {
          command = "markdownlint",
          rootPatterns = {".git"},
          isStderr = true,
          debounce = 100,
          args = {"--stdin"},
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = "markdownlint",
          securities = {undefined = "hint"},
          formatLines = 1,
          formatPattern = {"^.*:(\\d+)\\s+(.*)$", {line = 1, column = -1, message = 2}},
        },
      },
      filetypes = {
        javascript = "eslint",
        javascriptreact = "eslint",
        typescript = "eslint",
        typescriptreact = "eslint",
        ["typescript.tsx"] = "eslint",
        markdown = "markdownlint",
        -- pandoc = "markdownlint",
      },
      formatters = {
        prettierEslint = {
          command = "prettier-eslint",
          args = {"--stdin"},
          rootPatterns = {".eslintrc.cjs", ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".git"},
        },
        prettier = {command = "prettier", args = {"--stdin-filepath", "%filename"}},
      },
      formatFiletypes = {
        css = "prettier",
        javascript = "prettierEslint",
        javascriptreact = "prettierEslint",
        json = "prettier",
        scss = "prettier",
        typescript = "prettierEslint",
        typescriptreact = "prettierEslint",
        ["typescript.tsx"] = "prettierEslint",
      },
    },
  }

  local servers = {'vimls','tsserver', 'cssls', 'html', 'solargraph'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

command! Format execute 'lua vim.lsp.buf.formatting()'

" set omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype ruby,javascript,html,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Completion mappings
set dictionary=/usr/share/dict/words

" Complete using the project tags file
inoremap <C-]>     <C-x><C-]>
" Language and context aware omni-completion
inoremap <C-Space> <C-x><C-o>
" Keyword completion from the current buffer
inoremap <C-b>     <C-x><C-p>
" File path completion
inoremap <C-f>     <C-x><C-f>
" Dictionary completion
inoremap <C-d>     <C-x><C-k>

" === ALE ===

-" Ale Setup
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'ruby': ['rubocop'],
  \ 'rspec': ['rubocop'],
  \ 'handlebars': ['ember-template-lint'],
  \ 'css': ['prettier'],
  \ 'scss': ['stylelint']
  \ }

let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\  'javascript': ['eslint'],
\  'scss': ['stylelint'],
\  'ruby': ['rubocop']
\}

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_ruby_rubocop_executable = 'bin/rubocop'
let g:ale_javascript_eslint_executable = 'node_modules/.bin/eslint'

let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'

let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0

" let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

" === FZF === "

command! -bang ProjectFiles call fzf#vim#files(getcwd(), <bang>0)

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - Popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 1 | pclose | endif

" === vsnip === "
" Map <C-j> as shortcut to activate snippet if available
imap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

g:vsnip_snippet_dir = ~/.config/nvim/vsnip

" === Notes === 
" let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
let g:waikiki_wiki_roots = ['~/Dropbox/vimwiki']
let g:waikiki_default_maps = 1

command! OpenWikiTab execute '$tab ' . g:waikiki_wiki_roots[0] . ''<cr>

nnorema <silent> <leader>ww :OpenWikiTab<cr>
  " exec 'mksession! ' . g:sessions_dir . '/' . name

let g:nv_search_paths = ['~/Dropbox/vimwiki', '~/wiki']
nnoremap <silent> <leader>n :NV<cr>

" === AutoSave === "
let g:auto_save        = 1
let g:auto_save_silent = 1
" let g:auto_save_events = ['BufLeave', 'CursorHold', 'FocusLost']

" === Pairify === "
let g:close_pair_key = '<C-c>'

" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Color Scheme and Status Line {{{

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
  return ' ' . l:repo . '@' . l:branch . ' '
endfunction

" Function: display errors from Ale in statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('[%d/%d]', l:all_non_errors, l:all_errors)
endfunction
    " function! LspStatus() abort
    "   let sl = ''
    "   if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    "     let sl.='E:'
    "     let sl.='%{luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Error]])")}'
    "     let sl.=' W:'
    "     let sl.='%{luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Warning]])")}'
    "   else
    "       let sl.=' off'
    "   endif
    "   return sl
    " endfunction

function! LspStatusSymbol() abort
  if luaeval('vim.lsp.buf.server_ready()')
    return '↑'
  else
    return '↓'
  endif
endfunction

set statusline=
set statusline+=%#WildMenu#\ %.36{GitInfo()}ᓚᘏᗢ\ %#Normal#\ %t
set statusline+=%=
set statusline+=%q%m\[%{&filetype}\|%l:%c\]
set statusline+=%#WildMenu#%{LinterStatus()}\ lsp[%{LspStatusSymbol()}]

"}}}

" Enable true color support
if (has("termguicolors"))
  set termguicolors
endif

set background=dark
colorscheme min_fedu

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
noremap <silent> <leader>x :bp<Bar>bd #<CR>

function! DropBuffer()
endfunction

" Indent closer to home
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>
vnoremap <S-Tab> <<<Esc>

" use Q to replay q macro (q is for quick)
nnoremap Q @q

" Substitute
nnoremap <c-s> :%s/\v
vnoremap <c-s> :s/\v

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

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

let g:sneak#s_next = 1
"
" Tab manipulation
noremap <silent> <leader>tn :tabnew<CR>
noremap <silent> <leader>tc :tabclose<CR>
noremap <silent> <leader>tm :tabmove<Space><C-r>=input("Where to bub?: ")<CR><CR>

" Tab switching with <leader>number
noremap <silent> <leader>1 1gt
noremap <silent> <leader>2 2gt
noremap <silent> <leader>3 3gt
noremap <silent> <leader>4 4gt
noremap <silent> <leader>5 5gt
noremap <silent> <leader>6 6gt
noremap <silent> <leader>7 7gt
noremap <silent> <leader>8 8gt
noremap <silent> <leader>9 9gt

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit + SJL
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif

  " Unless that file is a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup END

augroup MarkdownEditing
  autocmd!
  autocmd BufWinEnter *.md set wrap
  autocmd BufWinLeave *.md set nowrap
augroup END

au BufReadPost *.hbs set syntax=handlebars.html
" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "
"
" === FZF shorcuts === "
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

nnoremap <silent> <leader>, :Buffers<CR>
nnoremap <silent> <leader>p :ProjectFiles<CR>
nnoremap <silent> <leader>s :Rg<CR>
nnoremap <silent> // :BLines<CR>
nnoremap <silent> ?? :Lines<CR>

nnoremap <silent> <c-p> :GFiles<CR>

nnoremap <silent> <Leader>d :Lexplore<CR>
nnoremap <silent> <Leader>f :Vexplore<CR>

let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore

" Toggle line numbers
nnoremap <silent> <leader>N :call CycleLineNumbers()<cr>

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

nnoremap <silent> <leader>B :enew<cr>

"cycle between last two open buffers
nnoremap <leader><leader> <c-^>

" Uppercase U undoes undo
nmap U <C-r>

" Step through undo history
nnoremap _ g-
nnoremap + g+

nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

nnoremap <silent> <leader>ev :$tabnew $MYVIMRC<cr>

command! RefreshConfig source $MYVIMRC <bar> echo "Refreshed vimrc!"
nnoremap <silent> <leader>sv :RefreshConfig<cr>

nnoremap <silent> <leader>+ :tab split<CR>
nnoremap <leader>= <C-w>=

nnoremap ; :

" Remember that ; and , where used to repeat character searches
" fix command that you shadowed with the prevoius one
nnoremap <Leader>; ;

" Open :help in a new tab
command! -nargs=? -complete=help Helptab $tab help <args>
cnoreabbrev <expr> ht getcmdtype() == ':' && getcmdline() == 'ht' ? 'Helptab' : 'ht'

"move to the split in the direction shown, or create a new split
nnoremap <silent> <C-w>h :call WinMove('h')<cr>
nnoremap <silent> <C-w>j :call WinMove('j')<cr>
nnoremap <silent> <C-w>k :call WinMove('k')<cr>
nnoremap <silent> <C-w>l :call WinMove('l')<cr>
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

nnoremap <silent> <leader>g :Gstatus<CR>

nnoremap j gj
nnoremap k gk

nnoremap <c-Home> :tabfirst<cr>
nnoremap <c-End> :tablast<cr>
nnoremap <c-PageUp> :tabprevious<cr>
nnoremap <c-PageDown> :tabnext<cr>

"keep text selected after indentation
vnoremap < <gv
vnoremap > >gv

" Feature toggles

let g:goyo_width = 120
nnoremap <silent> <leader>F :Goyo<cr>

" === Spelunker ===
nnoremap <silent> <leader>zn :call spelunker#jump_next()<cr>
nnoremap <silent> <leader>zp :call spelunker#jump_prev()<cr>
nnoremap <silent> <leader>zl :call spelunker#correct_all_from_list()<cr>
nnoremap <silent> <leader>zf :call spelunker#correct_all_feeling_lucky()<cr>
nnoremap <silent> <leader>zg :call spelunker#execute_with_target_word('spellgood')<cr>

" ============================================================================ "
" ===                                 MISC.                                === "
" ============================================================================ "

augroup TerminalBehavior
  " Start terminal in insert mode
  autocmd!
  au FileType neoterm :startinsert
  au FileType neoterm :stopinsert
  nnoremap <silent> <leader>t <cmd>Ttoggle<CR>
  nnoremap <silent> <leader>T <cmd>:$tab Tnew<CR>

  highlight! TermCursor ctermfg=LightBlue guifg=LightBlue

  autocmd Filetype neoterm setlocal nonumber norelativenumber

  " Quickly drop back to normal mode in terminal mode
  tnoremap <buffer> <esc> <C-\><C-n>

  " Move between windows exactly the same way as usual
  tnoremap <silent> <C-w>h <C-\><C-n>:call WinMove('h')<cr>
  tnoremap <silent> <C-w>j <C-\><C-n>:call WinMove('j')<cr>
  tnoremap <silent> <C-w>k <C-\><C-n>:call WinMove('k')<cr>
  tnoremap <silent> <C-w>l <C-\><C-n>:call WinMove('l')<cr>
augroup END

let g:neoterm_default_mod='belowright' " open terminal in bottom split
let g:neoterm_size=16 " terminal split size
let g:neoterm_autoscroll=1 " scroll to the bottom when running a command
nnoremap <leader><cr> :TREPLSendLine<cr>
vnoremap <leader><cr> :TREPLSendSelection<cr>

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backup
set backupdir=~/.config/nvim/tmp
set dir=~/.config/nvim/tmp

function! s:BufferCount() abort
  return len(filter(range(1, bufnr('$')), 'bufwinnr(v:val) != -1'))
endfunction

function! ListToggle(list) abort
  let buffer_count_before = s:BufferCount()

  if a:list ==? 'quick'
    let prepend = 'c'
  else
    let prepend = 'l'
  endif

  " Location list can't be closed if there's cursor in it, so we need
  " to call lclose twice to move cursor to the main pane
  execute "silent! " . prepend . "close"
  execute "silent! " . prepend . "close"

  if s:BufferCount() == buffer_count_before
    execute "silent! " . prepend . "open " . 15
  endif
endfunction

nnoremap <silent> <leader>l :call ListToggle('loc')<cr>
nnoremap <silent> <leader>q :call ListToggle('quick')<cr>

autocmd! InsertEnter * set nohlsearch

autocmd! FileType help wincmd H

nnoremap <silent> <leader>hg :call SynStack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

let g:sessions_dir = '~/Dropbox/vim-sessions'

function! SaveSession(...) abort
  if a:0 > 0
    let name = a:1
  else
    let name = GitInfo()
  endif

  exec 'mksession! ' . g:sessions_dir . '/' . name
endfunction

function! LoadSession(...) abort
  if a:0 > 0
    let name = a:1
  else
    let name = GitInfo()
  endif

  exec 'so ' . g:sessions_dir . '/' . name
endfunction

" vim:foldmethod=marker:foldlevel=0
