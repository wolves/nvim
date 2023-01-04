local util = require("util")

return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>ft",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("util").get_root() })
        end,
        desc = "NeoTree",
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    config = {
      filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {
            ".DS_Store",
          },
        },
      },
    },
  },

  -- search/replace in multiple files

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>/", util.telescope("live_grep"), desc = "Find in Files (Grep)" },
      { "<leader><space>", util.telescope("find_files"), desc = "Find Files" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>ff", util.telescope("find_files"), desc = "Find Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Branches" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      { "<leader>ha", "<cmd>Telescope autocommands<CR>", desc = "Auto Commands" },
      { "<leader>hc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>hf", "<cmd>Telescope filetypes<CR>", desc = "File Types" },
      { "<leader>hh", "<cmd>Telescope help_tags<CR>", desc = "Help Pages" },
      { "<leader>hk", "<cmd>Telescope keymaps<CR>", desc = "Key Maps" },
      { "<leader>hm", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
      { "<leader>ho", "<cmd>Telescope vim_options<CR>", desc = "Options" },
      { "<leader>hs", "<cmd>Telescope highlights<CR>", desc = "Search Highlight Groups" },
      { "<leader>ht", "<cmd>Telescope builtin<CR>", desc = "Telescope" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<CR>", desc = "Command History" },
      { "<leader>sg", util.telescope("live_grep"), desc = "Grep" },
      { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Jump to Mark" },
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      {
        "<leader>ss",
        util.telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol",
      },
    },
    config = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<C-i>"] = function()
              util.telescope("find_files", { no_ignore = true })()
            end,
            ["<C-h>"] = function()
              util.telescope("find_files", { hidden = true })()
            end,
            ["<C-Down>"] = function(...)
              return require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-Up>"] = function(...)
              return require("telescope.actions").cycle_history_prev(...)
            end,
          },
        },
      },
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        show_help = false,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
      })
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+help" },
        ["<leader>n"] = { name = "+noice" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },

  -- better diagnostics list etc
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = {
      auto_open = false,
      use_diagnostic_signs = true, -- en
    },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Trouble" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", "Todo Trouble" },
      { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo Trouble" },
      { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
    },
  },
}
