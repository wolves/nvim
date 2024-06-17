--require("lazyvim.config.keymaps")

local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

-- local id
-- for _, key in ipairs({ "h", "j", "k", "l" }) do
--   local count = 0
--   vim.keymap.set("n", key, function()
--     if count >= 10 then
--       id = vim.notify("Hold it Cowboy!", vim.log.levels.WARN, {
--         icon = "🤠",
--         replace = id,
--         keep = function()
--           return count >= 10
--         end,
--       })
--     else
--       count = count + 1
--       vim.defer_fn(function()
--         count = count - 1
--       end, 5000)
--       return key
--     end
--   end, { expr = true })
-- end

--wk.setup({
--  show_help = false,
--  triggers = "auto",
--  plugins = { spelling = true },
--  key_labels = { ["<leader>"] = "SPC" },
--  triggers_blacklist = {
--    i = { "j", "k" },
--    v = { "j", "k" },
--  },
--})

-- Atempting fixing <C-c> -> <esc> remapping error
-- vim.keymap.set("i", "<C-c>", "<C-c>")

-- Move to window using the <ctrl> movement keys
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- Move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

vim.keymap.set("n", "<C-Left>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")

-- Move to splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Tree
-- vim.keymap.set("n", "<C-e>", "<cmd>Neotree toggle reveal<CR>")
vim.keymap.set("n", "<C-e>", "<cmd>lua require('mini.files').open()<CR>")

-- Search
local function search(backward)
  vim.cmd([[echo "1> "]])
  local first = vim.fn.getcharstr()
  vim.fn.search(first, "s" .. (backward and "b" or ""))
  vim.schedule(function()
    vim.cmd([[echo "2> "]])
    local second = vim.fn.getcharstr()
    vim.fn.search(first .. second, "c" .. (backward and "b" or ""))

    vim.fn.setreg("/", first .. second)
  end)
end

vim.keymap.set("n", "s", search)
vim.keymap.set("n", "S", function()
  search(true)
end)

-- Clear search with <esc>
vim.keymap.set("", "<esc>", ":noh<esc>")
vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

local leader = {
  w = { "<cmd>w!<CR>", "Save" },
  q = { "<cmd>q!<CR>", "Quit" },
  b = {
    name = "+buffer",
    b = {
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Buffers",
    },
  },
  e = { "<cmd>lua require('mini.files').open()<CR>", "File Explorer" },
  f = {
    name = "+file",
    n = { "<cmd>enew<CR>", "New" },
  },
  g = {
    name = "+git",
    g = { "<cmd>Neogit<CR>", "Neogit" },
    d = { "<cmd>DiffviewOpen<CR>", "Diffview" },
    h = { name = "+hunk" },
  },
  m = {
    name = "+harpoon",
  },
  t = {
    name = "+toggle",
    c = { util.toggle_colors, "Colorscheme Light/Dark" },
    f = { require("plugins.lsp.format").toggle, "Format on Save" },
    n = {
      function()
        util.toggle("relativenumber", true)
        util.toggle("number")
      end,
      "Line Numbers",
    },
    s = {
      function()
        util.toggle("spell")
      end,
      "Spelling",
    },
    w = {
      function()
        util.toggle("wrap")
      end,
      "Word Wrap",
    },
  },
}

for i = 0, 10 do
  leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })

wk.register({ g = { name = "+goto" } })
