return {
  {
    "Wansmer/treesj",
    keys = {
      -- { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
      { "gS", "<cmd>TSJSplit<cr>", desc = "Split" },
      { "gJ", "<cmd>TSJJoin<cr>", desc = "Join" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
  },

  -- better-escape (jk == esc)
  {
    "max397574/better-escape.nvim",
    event = "BufReadPost",
    config = function()
      local esc = require("better_escape")

      esc.setup({
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        default_mappings = true,
        mappings = {
          i = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
          },
        },
        -- keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
      })
    end,
  },
}
