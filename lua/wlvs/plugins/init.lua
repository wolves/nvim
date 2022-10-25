local utils = require 'wlvs.utils.plugins'

local conf = utils.conf
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath('cache') .. '/packer/packer_compiled.lua'

---Some plugins are not safe to be reloaded because their setup functions
---and are not idempotent. This wraps the setup calls of such plugins
---@param func fun()
function wlvs.block_reload(func)
  if vim.g.packer_compiled_loaded then
    return
  end
  func()
end

------------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
------------------------------------------------------------------------------//
utils.bootstrap_packer()
------------------------------------------------------------------------------ }}}1
wlvs.safe_require 'impatient'

local packer = require('packer')

packer.startup({
  function(use, use_rocks)
    use { 'wbthomason/packer.nvim', opt = true }

    ------------------------------------------------------------------------------//
    -- Core {{{3
    ------------------------------------------------------------------------------//
    use { 'nvim-lua/plenary.nvim' }
    use { 'nvim-lua/popup.nvim' }

    -- }}}
    ------------------------------------------------------------------------------//
    -- Keys {{{1
    ------------------------------------------------------------------------------//

    use { 'folke/which-key.nvim', config = conf 'whichkey' }

    -- }}}
    ------------------------------------------------------------------------------//
    -- Telescope {{{1
    ------------------------------------------------------------------------------//
    --
    use {
      'ahmedkhalf/project.nvim',
      config = function()
        require('project_nvim').setup()
      end,
    }

    use {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<c-p>', '<leader>ff', '<leader>fo', '<leader>fs' },
      module_pattern = 'telescope.*',
      config = conf 'telescope',
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'fzf'
          end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = 'tami5/sqlite.lua',
        },
      },
    }

    -- }}}
    ------------------------------------------------------------------------------//
    -- Treesitter {{{1
    ------------------------------------------------------------------------------//

    -- TODO: if a plugin which is specified as after for other plugins is converted to opt=true
    -- trying to move that plugin to the opt directory fails
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      event = 'BufReadPre',
      config = conf 'treesitter',
      local_path = 'contributing',
      -- wants = { 'null-ls.nvim' },
      requires = {
        { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' },
        { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
        {
          'nvim-treesitter/playground',
          keys = '<leader>E',
          cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
          setup = function()
            require('which-key').register { ['<leader>E'] = 'treesitter: highlight cursor group' }
          end,
          config = function()
            wlvs.nnoremap('<leader>E', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
          end,
        },
      },
    }

    use {
      'abecodes/tabout.nvim',
      wants = { 'nvim-treesitter' },
      after = { 'nvim-cmp' },
      config = function()
        require('tabout').setup {
          completion = false,
          ignore_beginning = false,
        }
      end,
    }

    -- }}}
    ----------------------------------------------------------------------------//
    -- GIT {{{1
    -----------------------------------------------------------------------------//
    use { 'lewis6991/gitsigns.nvim', config = conf 'gitsigns' }
    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      requires = 'plenary.nvim',
      setup = conf('neogit').setup,
      config = conf('neogit').config,
    }

    -- }}}
    ----------------------------------------------------------------------------//
    -- LSP, Completion & Debugger {{{1
    -----------------------------------------------------------------------------//
    use { 'neovim/nvim-lspconfig', config = conf 'lspconfig' }
    use {
      "williamboman/mason.nvim",
      config = function()
        require('mason').setup()
      end
    }
    use { "williamboman/mason-lspconfig.nvim" }
    -- use {
    --   'williamboman/nvim-lsp-installer',
    --   requires = 'nvim-lspconfig',
    --   config = function()
    --     local lsp_installer_servers = require 'nvim-lsp-installer.servers'
    --     for name, _ in pairs(wlvs.lsp.servers) do
    --       ---@type boolean, table|string
    --       local ok, server = lsp_installer_servers.get_server(name)
    --       if ok then
    --         if not server:is_installed() then
    --           server:install()
    --         end
    --       end
    --     end
    --   end,
    -- }

    use 'b0o/schemastore.nvim'

    -- use {
    --   'jose-elias-alvarez/null-ls.nvim',
    --   requires = { 'nvim-lua/plenary.nvim' },
    --   -- trigger loading after lspconfig has started the other servers
    --   -- since there is otherwise a race condition and null-ls' setup would
    --   -- have to be moved into lspconfig.lua otherwise
    --   config = function()
    --     local null_ls = require 'null-ls'
    --     -- NOTE: this plugin will break if it's dependencies are not installed
    --     null_ls.setup {
    --       debounce = 150,
    --       on_attach = wlvs.lsp.on_attach,
    --       sources = {
    --         null_ls.builtins.code_actions.gitsigns,
    --         null_ls.builtins.formatting.stylua.with {
    --           condition = function(_utils)
    --             return wlvs.executable 'stylua' and _utils.root_has_file 'stylua.toml'
    --           end,
    --         },
    --         null_ls.builtins.formatting.prettier.with {
    --           filetypes = { 'html', 'json', 'yaml', 'markdown' }, -- , 'graphql', 'markdown' },
    --           condition = function()
    --             return wlvs.executable 'prettier'
    --           end,
    --         },
    --       },
    --     }
    --   end,
    -- }

    use {
      'ray-x/lsp_signature.nvim',
      config = function()
        require('lsp_signature').setup {
          bind = true,
          fix_pos = false,
          auto_close_after = 15, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = 'rounded' },
        }
      end,
    }

    use {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      event = 'InsertEnter',
      config = conf 'cmp',
      requires = {
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        -- { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        -- { 'petertriho/cmp-git', after = 'nvim-cmp' },
        -- { 'tzachar/cmp-tabnine', run = './install.sh', after = 'nvim-cmp' },
      },
    }



    use {
      "folke/trouble.nvim",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup({
          auto_open = false,
          use_diagnostic_signs = true, -- en
        })
      end,
    }
    -- }}}
    ------------------------------------------------------------------------------//
    -- Editor {{{1
    ------------------------------------------------------------------------------//

    use { 'max397574/better-escape.nvim', config = conf 'better-escape' }
    use { 'akinsho/toggleterm.nvim', config = conf 'toggleterm' }
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup {
          mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', 'zt', 'zz', 'zb' },
          stop_eof = false,
          hide_cursor = true,
        }
      end,
    }

    -- }}}
    ------------------------------------------------------------------------------//
    -- User Interface {{{1
    ------------------------------------------------------------------------------//

    -- Icons
    use 'kyazdani42/nvim-web-devicons'
    use 'mortepau/codicons.nvim'
    use {
      'akinsho/bufferline.nvim',
      config = conf 'bufferline',
      requires = 'nvim-web-devicons',
    }

    use { 'moll/vim-bbye' }

    use {
      'lukas-reineke/indent-blankline.nvim',
      event = 'BufReadPre',
      config = conf 'blankline',
    }

    -- Colors
    use {
      'rebelot/kanagawa.nvim',
      config = conf 'colorscheme',
    }
    use { 'folke/tokyonight.nvim' }
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup {
          '*';
          css = { names = false };
          html = { names = false };
        }
      end
    }

    -- Tree
    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = conf('neo-tree'),
      keys = { '<C-N>' },
      cmd = { 'NeoTree' },
      requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'kyazdani42/nvim-web-devicons',
        { 's1n7ax/nvim-window-picker', tag = '1.*', config = conf('window-picker') },
      },
    })

    -- }}}
    ------------------------------------------------------------------------------//
    -- Utilities {{{1
    ------------------------------------------------------------------------------//
    use {
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      requires = 'rafamadriz/friendly-snippets',
      config = conf 'luasnip',
    }

    -- use {
    --   'AckslD/nvim-neoclip.lua',
    --   config = function()
    --     require('neoclip').setup {
    --       enable_persistent_history = true,
    --       keys = {
    --         telescope = {
    --           i = { select = '<c-p>', paste = '<CR>', paste_behind = '<c-k>' },
    --           n = { select = 'p', paste = '<CR>', paste_behind = 'P' },
    --         },
    --       },
    --     }
    --     local function clip()
    --       require('telescope').extensions.neoclip.default(
    --         require('telescope.themes').get_dropdown()
    --       )
    --     end
    --
    --     -- require('which-key').register {
    --     --   ['<localleader>p'] = { clip, 'neoclip: open yank history' },
    --     -- }
    --   end,
    -- }

    use({
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        wlvs.block_reload(function()
          require('todo-comments').setup({
            highlight = {
              exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
            },
          })
          wlvs.nnoremap('<leader>lt', '<Cmd>TodoTrouble<CR>', 'trouble: todos')
        end)
      end,
    })

    -- }}}
    ------------------------------------------------------------------------------//
    -- Text Editing {{{1
    ------------------------------------------------------------------------------//

    use {
      'AndrewRadev/splitjoin.vim',
      config = function()
        require('which-key').register { gS = 'splitjoin: split', gJ = 'splitjoin: join' }
      end,
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    }
    use { 'windwp/nvim-autopairs', config = conf 'autopairs' }
    use { 'tpope/vim-surround' }

    -- }}}
    ------------------------------------------------------------------------------//
    -- Profiling & Startup {{{1
    ------------------------------------------------------------------------------//
    -- use {
    --   'nathom/filetype.nvim',
    --   config = function()
    --     require('filetype').setup {
    --       overrides = {
    --         literal = {
    --           ['kitty.conf'] = 'kitty',
    --           ['.gitignore'] = 'conf',
    --           ['.env'] = 'sh',
    --         },
    --       },
    --     }
    --   end,
    -- }

    use 'lewis6991/impatient.nvim'
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    }

    -- }}}
    ------------------------------------------------------------------------------//
    -- Languages {{{1
    ------------------------------------------------------------------------------//
    use {
      'ray-x/go.nvim',
      ft = 'go',
      config = conf 'go',
    }

    use { 'ray-x/guihua.lua' }

    use {
      'simrat39/rust-tools.nvim',
      config = conf 'rust',
    }

    use({ "npxbr/glow.nvim", cmd = "Glow" })

    use 'plasticboy/vim-markdown'
    use({
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
    })

    -- }}}
    ------------------------------------------------------------------------------//
    -- Packer Config {{{1
    ------------------------------------------------------------------------------//
  end,
  log = { level = 'info' },
  config = {
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = 'rounded',
      open_cmd = 'silent topleft 65vnew',
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
})

-- }}}
------------------------------------------------------------------------------//
-- Packer Commands
------------------------------------------------------------------------------//
wlvs.command('PackerCompiledEdit', function()
  vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
end)

wlvs.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  wlvs.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

wlvs.augroup('PackerSetupInit', {
  {
    event = { 'BufWritePost' },
    pattern = { '*/wlvs/plugins/*.lua' },
    description = "Packer setup and reload",
    command = function()
      wlvs.invalidate('wlvs.plugins', true)
      packer.compile()
    end,
  },
})

-- wlvs.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
-- wlvs.nnoremap('<leader>pc', [[<Cmd>PackerClean<CR>]])

-- vim:foldmethod=marker
