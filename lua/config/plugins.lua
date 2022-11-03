local packer = require("util.packer")

local config = {
  profile = {},
  display = {},
  opt_default = true,
  auto_reload_compiled = false,
  -- list of plugins that should be taken from ~/projects
  -- this is NOT packer functionality!
  local_plugins = {
    -- folke = true,
    -- ["folke/neodev.nvim"] = false,
    -- ["null-ls.nvim"] = true,
    -- ["nvim-lspconfig"] = true,
    -- ["nvim-notify"] = true,
    -- ["yanky.nvim"] = true,
    -- ["nvim-treesitter"] = true,
  },
}

local function plugins(use, plugin)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim" })
  use({ "nvim-lua/plenary.nvim", module = "plenary" })
  plugin("folke/noice.nvim")

  -- Keymapping
  use({
    "folke/which-key.nvim",
    module = "which-key",
  })

  -- Telescope
  plugin("nvim-telescope/telescope.nvim")

  -- Treesitter
  plugin("nvim-treesitter/nvim-treesitter")

  -- LSP
  use({ "neovim/nvim-lspconfig", plugin = "lsp" })

  plugin("williamboman/mason.nvim")
  use({
    "williamboman/mason-lspconfig.nvim",
    module = "mason-lspconfig",
  })

  use({ "jose-elias-alvarez/typescript.nvim", module = "typescript" })
  plugin("jose-elias-alvarez/null-ls.nvim")

  use({ "b0o/SchemaStore.nvim", module = "schemastore" })

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    module = "trouble",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        auto_open = false,
        use_diagnostic_signs = true, -- en
      })
    end,
  })

  use({
    "SmiteshP/nvim-navic",
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
    end,
  })

  -- Language Support
  plugin("simrat39/rust-tools.nvim")
  plugin("ray-x/go.nvim")
  use({ "ray-x/guihua.lua" })

  -- Theme: Colors
  plugin("rebelot/kanagawa.nvim")

  -- Theme: Icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })

  -- Editor Interface
  plugin("hrsh7th/nvim-cmp")
  plugin("akinsho/bufferline.nvim")
  use({
    "moll/vim-bbye",
    opt = false,
  })
  plugin("nvim-neo-tree/neo-tree.nvim")
  use({
    "s1n7ax/nvim-window-picker",
    opt = false,
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { "neo-tree-popup", "quickfix", "incline" },
            buftype = { "terminal", "quickfix", "nofile" },
          },
        },
        -- other_win_hl_color = require('wlvs.highlights').get_hl('Visual', 'bg'),
      })
    end,
  })
  use({
    "MunifTanjim/nui.nvim",
    module = "nui",
  })
  plugin("rcarriga/nvim-notify")
  plugin("akinsho/nvim-toggleterm.lua")
  plugin("karb94/neoscroll.nvim")
  plugin("max397574/better-escape.nvim")
  plugin("lukas-reineke/indent-blankline.nvim")
  plugin("NvChad/nvim-colorizer.lua")
  plugin("folke/todo-comments.nvim")
  plugin("nvim-lualine/lualine.nvim")
  plugin("b0o/incline.nvim")

  -- Text Editing
  plugin("numToStr/Comment.nvim")

  plugin("windwp/nvim-autopairs")

  plugin("L3MON4D3/LuaSnip")

  use({
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup({})
    end,
  })

  use({
    "AndrewRadev/splitjoin.vim",
    opt = false,
    -- config = function()
    --   vim.keymap.set("n", "gS", "<cmd>SplitJoinSplit<CR>", { desc = "Split Join Split" })
    --   -- require("which-key").register({ gS = "splitjoin: split", gJ = "splitjoin: join" })
    -- end,
  })

  use({
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    module = "inc_rename",
    config = function()
      require("inc_rename").setup()
    end,
  })

  -- Git
  plugin("lewis6991/gitsigns.nvim")
  plugin("TimUntersberger/neogit")
  use({ "rlch/github-notifications.nvim", module = "github-notifications" })
  plugin("sindrets/diffview.nvim")

  -- Profile/Startup
  use({
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 15
      -- vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
    end,
  })
end

return packer.setup(config, plugins)
