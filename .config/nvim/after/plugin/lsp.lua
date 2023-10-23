local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})

  local opts = {buffer = bufnr}
  local bind = vim.keymap.set

  bind('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
end)

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})
