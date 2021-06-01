local nvim_lsp = require('lspconfig')
local api = vim.api
local lsp = vim.lsp
local fn  = vim.fn

local on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true }

  -- vim.b.omnifunc = lsp.omnifunc

  api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

-- local servers = {'vimls','tsserver', 'cssls', 'solargraph', 'sumneko_lua', 'diagnosticls'}
local servers = {'vimls','tsserver', 'cssls', 'html', 'solargraph', 'diagnosticls'}
for _, server in ipairs(servers) do nvim_lsp[server].setup {
    on_attach = on_attach,
  }
end

nvim_lsp.diagnosticls.setup{
  on_attach=on_attach,
  filetypes = { 'javascript', 'typescript', 'css', 'scss' },
  init_options = {
    linters = {
      eslint = {
        sourceName = 'eslint',
        command = './node_modules/.bin/eslint',
        rootPatterns = {
          '.git',
          'eslintrc.js',
          'package.json'
        },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
        security = 'severity' },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
      stylelint = {
        sourceName = 'stylelint',
        command = './node_modules/.bin/stylelint',
        rootPatterns = {
          '.git',
          'stylelintrc',
          'package.json'
        },
        debounce = 100,
        args = { '--formatter', 'json', '--stdin-filename', '%filepath' },
        parseJson = {
          errorsRoot = '[0].warnings',
          line = 'line',
          column = 'column',
          message = '${text}',
          security = 'severity'
        },
        securities = {
          error = 'error',
          warning = 'warning'
        }
      },
      rubocop = {
        command = "bundle",
        sourceName = "rubocop",
        debounce = 100,
        args = {
          "exec",
          "rubocop",
          "--format",
          "json",
          "--force-exclusion",
          "--stdin",
          "%filepath"
        },
        parseJson = {
          errorsRoot = "files[0].offenses",
          line = "location.start_line",
          endLine = "location.last_line",
          column = "location.start_column",
          endColumn = "location.end_column",
          message = "[${cop_name}] ${message}",
          security = "severity"
        },
        securities = {
          fatal = "error",
          error = "error",
          warning = "warning",
          convention = "info",
          refactor = "info",
          info = "info"
        }
      }
    },
    filetypes = {
      javascript = 'eslint',
      typescript = 'eslint',
      scss = 'stylelint',
      css = 'stylelint'
    },
  }
}

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    -- virtual_text = {
    --   prefix = "⨳",
    --   spacing = 8
    -- },
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ':help vim.lsp.diagnostic.set_signs()'
    signs = true,

    -- This is similar to:
    -- 'let g:diagnostic_insert_delay = 1'
    update_in_insert = false,
  }
  )

vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]

fn.sign_define(
  "LspDiagnosticsSignError",
  {
    text = "",
    texthl = "LspDiagnosticsSignError"
  }
  )
fn.sign_define(
  "LspDiagnosticsSignWarning",
  {
    text = "!",
    texthl = "LspDiagnosticsSignWarning"
  }
  )
fn.sign_define(
  "LspDiagnosticsSignInformation",
  {
    text = "?",
    texthl = "LspDiagnosticsSignInformation"
  }
  )
fn.sign_define(
  "LspDiagnosticsSignHint",
  {
    text = "➤",
    texthl = "LspDiagnosticsSignHint"
  }
  )
