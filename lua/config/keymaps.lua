-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local delmap = vim.keymap.del

vim.keymap.del("n", "<c-/>")
delmap("t", "<C-/>", { desc = "Hide Terminal" })

map({ "n", "v" }, "<leader>w", "<cmd>w!<CR>", { desc = "Save", remap = true })
map({ "n", "v" }, "<leader>q", "<cmd>q!<CR>", { desc = "Quit", remap = true })

map("n", "<c-\\>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
