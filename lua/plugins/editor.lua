local util = require("util")

return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "left",
            dir = require("util").get_root(),
          })
        end,
        desc = "Explorer (root dir)",
        remap = true,
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "float",
            dir = require("util").get_root(),
          })
        end,
        desc = "Explorer Float (root dir)",
        remap = true,
      },
    },
    opts = require("config.neo-tree"),
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
          vim.cmd([[set showtabline=0]])
        end
      end
    end,
    -- opts = {
    --   filesystem = {
    --     follow_current_file = true,
    --     hijack_netrw_behavior = "open_current",
    --     filtered_items = {
    --       visible = true,
    --       hide_dotfiles = false,
    --       hide_gitignored = true,
    --       never_show = {
    --         ".DS_Store",
    --       },
    --     },
    --   },
    -- },
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

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
      { "<leader>sg", util.telescope("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", util.telescope("live_grep"), { cwd = false }, desc = "Grep (cwd)" },
      { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Jump to Mark" },
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      {
        "<leader>sy",
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
    opts = {
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

  -- easily jump to any location and enhanced f/t motions for Leap
  -- {
  --   "ggandor/leap.nvim",
  --   event = "VeryLazy",
  --   dependencies = { { "ggandor/flit.nvim", config = { labeled_modes = "nv" } } },
  --   config = function()
  --     require("leap").add_default_mappings(true)
  --   end,
  -- },

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

  -- better-escape (jk == esc)
  {
    "max397574/better-escape.nvim",
    event = "BufReadPost",
    config = function()
      local esc = require("better_escape")

      esc.setup({
        mapping = { "jk", "jj" }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
      })
    end,
  },

  -- neoscroll
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    config = function()
      require("neoscroll").setup({})
      local map = {}

      map["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } }
      map["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } }
      map["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
      map["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }
      map["<C-y>"] = { "scroll", { "-0.10", "false", "80" } }
      map["<C-e>"] = { "scroll", { "0.10", "false", "80" } }
      map["zt"] = { "zt", { "150" } }
      map["zz"] = { "zz", { "150" } }
      map["zb"] = { "zb", { "150" } }

      require("neoscroll.config").set_mappings(map)
    end,
  },

  -- toggleterm (better terminal)
  {
    "akinsho/nvim-toggleterm.lua",
    event = "UIEnter",
    keys = "<C-\\>",
    config = function()
      require("toggleterm").setup({
        size = 20,
        hide_numbers = true,
        open_mapping = [[<C-\>]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 0.3, -- Bak has 2
        start_in_insert = true,
        persist_size = true,
        direction = "horizontal",
      })

      -- Hide number column for
      -- vim.cmd [[au TermOpen * setlocal nonumber norelativenumber]]

      -- Esc twice to get to normal mode
      vim.cmd([[tnoremap <esc><esc> <C-\><C-N>]])
    end,
  },

  -- neogit
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    opts = {
      disable_commit_confirmation = true,
      kind = "floating",
      commit_editor = {
        kind = "floating",
      },
      popup = {
        kind = "floating",
      },
      signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = { diffview = true },
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    },
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      end,
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure({
        delay = 200,
        filetypes_denylist = {
          "alpha",
          "dashboard",
          "DoomInfo",
          "fugitive",
          "help",
          "norg",
          "NvimTree",
          "Outline",
          "toggleterm",
        },
      })
    end,
    -- stylua: ignore
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
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
    opts = {
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
