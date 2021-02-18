require('lsp_config')

require('compe').setup {
  enabled = true;
  debug = false;
  min_length = 3;
  preselect = 'enable';
  allow_prefix_unmatch = false;

  source = {
    path = true;
    buffer = true;
    vsnip = true;
    nvim_lsp = true;
  };
}
