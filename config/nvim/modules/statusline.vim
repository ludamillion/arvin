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
  return ' ' . l:repo . '@' . l:branch
endfunction

" Function: display errors from Ale in statusline
" function! LinterStatus() abort
"   let l:counts = ale#statusline#Count(bufnr(''))
"   let l:all_errors = l:counts.error + l:counts.style_error
"   let l:all_non_errors = l:counts.total - l:all_errors
"   return l:counts.total == 0 ? '' : printf('[%d/%d]', l:all_non_errors, l:all_errors)
" endfunction

function! LspStatusSymbol() abort
  if luaeval('vim.lsp.buf.server_ready()')
    return '↑'
  else
    return '↓'
  endif
endfunction

let s:currentmode={
\ 'n': 'Normal',
\ 'no': 'N·Operator Pending',
\ 'v': 'Visual',
\ 'V': 'V·Line',
\ '^V': 'V·Block',
\ 's': 'Select',
\ 'S': 'S·Line',
\ '^S': 'S·Block',
\ 'i': 'Insert',
\ 'R': 'Replace',
\ 'Rv': 'V·Replace',
\ 'c': 'Command',
\ 'cv': 'Vim Ex',
\ 'ce': 'Ex',
\ 'r': 'Prompt',
\ 'rm': 'More',
\ 'r?': 'Confirm',
\ '!': 'Shell',
\ 't': 'Terminal'}
"
" Function: return current mode
" abort -> function will abort soon as error detected
function! ModeCurrent() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register
    " 3rd arg is used when return of mode() == 0, which is case with ^V
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = get(s:currentmode, l:modecurrent, 'V·Block')
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

set statusline=
set statusline+=%.36{GitInfo()}\ ->\ %t
set statusline+=%=
set statusline+=ᓚᘏᗢ\ %q%m\[%{ModeCurrent()}]
set statusline+=[lsp\ %{LspStatusSymbol()}]
" set statusline+=%#WildMenu#%{LinterStatus()}\ lsp[%{LspStatusSymbol()}]

