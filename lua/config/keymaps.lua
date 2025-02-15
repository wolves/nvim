-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map({ "n", "v" }, "<leader>w", "<cmd>w!<CR>", { desc = "Save", remap = true })
map({ "n", "v" }, "<leader>q", "<cmd>q!<CR>", { desc = "Quit", remap = true })
