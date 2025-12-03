require('go').setup()
require('nvim-web-devicons').setup()

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.keymap.set('n', '<C-Q>', '<Cmd>:qa!<CR>')
vim.keymap.set('n', '<C-q>', '<Cmd>:wq<CR>')


-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

vim.lsp.set_log_level("error")

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Force proper background colors
vim.cmd([[
  hi Normal guibg=#1a1b26
  hi NormalFloat guibg=#1a1b26
  hi NormalNC guibg=#1a1b26
  hi NeoTreeNormal guibg=#1a1b26
  hi NeoTreeNormalNC guibg=#1a1b26
  hi NeoTreeEndOfBuffer guibg=#1a1b26
]])
