return function()
  local wk = require 'which-key'

  local setup = {
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      }
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
      -- override the label used to display some keys. It doesn't effect WK in any other way.
      -- For example:
      -- ["<space>"] = "SPC",
      -- ["<cr>"] = "RET",
      -- ["<tab>"] = "TAB",
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
      border = "rounded", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    -- triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      i = { "j", "k" },
      v = { "j", "k" },
    },
  }

  local opts = {
    mode = 'n',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  }

  local mappings = {
    ["w"] = { "<cmd>w!<cr>", "Save" },
    ["q"] = { "<cmd>q!<cr>", "Quit" },
    ["/"] = { '<cmd>lua require("Comment.api").toggle_current_linewise()<CR>', "Comment" },
    b = {
      name = "Buffers",
      b = {
        "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        "Buffers",
      },
      d = { "<cmd>Bdelete!<CR>", "Close Buffer" },
      q = { "<cmd>Bwipeout<CR>", "Wipeout Buffer"},
    },
    g = {
      name = "Git",
      g = { "<cmd>Neogit<cr>", "Neogit" },
      j = { "<cmd>lua require('gitsigns').next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require('gitsigns').prev_hunk()<cr>", "Prev Hunk" },
      l = { "<cmd>GitBlameToggle<cr>", "Blame" },
      p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview Hunk" },
    },
    ["h"] = {
      name = "Help",
      p = {
        name = 'Packer',
        p = { '<cmd>PackerSync<cr>', "Packer Sync" },
      },
    },
    x = {
      name = "+errors",
      x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
    },
  }

  wk.setup(setup)
  wk.register(mappings, opts)
end
