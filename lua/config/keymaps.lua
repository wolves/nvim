--require("lazyvim.config.keymaps")

local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

local id
for _, key in ipairs({ "h", "j", "k", "l" }) do
  local count = 0
  vim.keymap.set("n", key, function()
    if count >= 10 then
      id = vim.notify("Hold it Cowboy!", vim.log.levels.WARN, {
        icon = "🤠",
        replace = id,
        keep = function()
          return count >= 10
        end,
      })
    else
      count = count + 1
      vim.defer_fn(function()
        count = count - 1
      end, 5000)
      return key
    end
  end, { expr = true })
end

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

-- Switch buffers with tab
vim.keymap.set("n", "<C-Left>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")

-- Move to splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Tree
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle reveal<CR>")

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
    --d = { "<cmd>Bdelete!<CR>", "Close Buffer" },
    --q = { "<cmd>Bwipeout!<CR>", "Wipeout Buffer" },
  },
  f = {
    name = "+file",
    n = { "<cmd>enew<CR>", "New" },
    r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
    t = { "<cmd>Neotree toggle<CR>", "Neotree" },
  },
  g = {
    name = "+git",
    g = { "<cmd>Neogit<CR>", "Neogit" },
    b = { "<cmd>Telescope git_branches<CR>", "Branches" },
    c = { "<cmd>Telescope git_commits<CR>", "Commits" },
    d = { "<cmd>DiffviewOpen<CR>", "Diffview" },
    s = { "<cmd>Telescope git_status<CR>", "Status" },
    h = { name = "+hunk" },
  },
  ["h"] = {
    name = "+help",
    a = { "<cmd>:Telescope autocommands<CR>", "Auto Commands" },
    c = { "<cmd>:Telescope commands<CR>", "Commands" },
    h = { "<cmd>:Telescope help_tags<CR>", "Help Pages" },
    k = { "<cmd>:Telescope keymaps<CR>", "Key Maps" },
    m = { "<cmd>:Telescope man_pages<CR>", "Man Pages" },
    o = { "<cmd>Telescope vim_options<CR>", "Options" },
    p = {
      name = "+packer",
      p = { "<cmd>PackerSync<cr>", "Sync" },
      s = { "<cmd>PackerStatus<cr>", "Status" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      c = { "<cmd>PackerCompile<cr>", "Compile" },
    },
  },
  -- o = {
  --   name = "+open",
  --   n = { require("github-notifications.menu").notifications, "Github Notifications" },
  -- },
  s = {
    name = "+search",
    b = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Buffer" },
    g = { "<cmd>Telescope live_grep<CR>", "Grep" },
    h = { "<cmd>Telescope command_history<CR>", "Command History" },
    --s = { require("plugins.telescope").grep_string_prompt, "Grep Prompt" },
    w = { require("plugins.telescope").grep_word, "Current Word" },
  },
  t = {
    name = "+toggle",
    --f = { require("plugins.lsp.formatting").toggle, "Format on Save" },
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
  x = {
    name = "+errors",
    t = { "<cmd>TodoTrouble<CR>", "Todo Trouble" },
    tt = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>", "Todo Trouble" },
    T = { "<cmd>TodoTelescope<CR>", "Todo Telescope" },
    x = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Trouble" },
  },
}

for i = 0, 10 do
  leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })

wk.register({ g = { name = "+goto" } })
