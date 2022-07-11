local ls = require("luasnip")

-- local f = ls.function_node
local s = ls.s

local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep

-- local keymap = vim.api.nvim_set_keymap
-- local opts = { noremap = true, silent = true }

local M = {}

-- M.same = function(index)
--   return f(function(args)
--     return args[1]
--   end, { index })
-- end

ls.snippets = {
  all = {
    ls.parser.parse_snippet("exp", "-- this expanded!"),
  },
  lua = {
    s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
  },
}

-- shorcut to source my luasnips file again, which will reload my snippets
-- keymap("n", "<leader>s", "<cmd>source ~/.config/nvim/lua/wlvs/snips/init.lua<CR>", opts)

return M
