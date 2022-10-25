local nnoremap = wlvs.nnoremap
local inoremap = wlvs.inoremap

nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')

nnoremap('<ESC>', '<cmd>nohlsearch<CR>')
nnoremap('<C-c>', '<cmd>nohlsearch<CR>')

inoremap('<C-c>', '<ESC>')
