require('lsp_config')

require('compe').setup {
  enabled = true;
  debug = false;
  min_length = 3;
  preselect = 'enable';
  allow_prefix_unmatch = false;

  source = {
    buffer = true;
    nvim_lsp = true;
    path = true;
    spell = true;
    vsnip = true;
  };
}
