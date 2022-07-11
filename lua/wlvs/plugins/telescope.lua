return function()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  local layout_actions = require 'telescope.actions.layout'
  local themes = require 'telescope.themes'

  local function get_border(opts)
    return vim.tbl_deep_extend('force', opts or {}, {
      borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
        results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
    })
  end

  ---@param opts table
  ---@return table
  local function dropdown(opts)
    return themes.get_dropdown(get_border(opts))
  end

  telescope.setup {
    defaults = {
      set_env = { ['TERM'] = vim.env.TERM },
      borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      -- BUG: remove prefix as it is currently broken
      -- seems to relate to prompt buffers although currently it isn't being set to a prompt buffer
      -- @see: https://github.com/nvim-telescope/telescope.nvim/issues/1251
      -- prompt_prefix = '', -- 
      -- selection_caret = '» ',
      prompt_prefix = " ❯ ",
      selection_caret = "❯ ",
      mappings = {
        i = {
          ['<C-w>'] = actions.send_selected_to_qflist,
          -- ['<c-c>'] = function()
          --     vim.cmd 'stopinsert!'
          -- end,
          ['<esc>'] = actions.close,
          ['<c-s>'] = actions.select_horizontal,
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
          ['<c-e>'] = layout_actions.toggle_preview,
          ['<c-l>'] = layout_actions.cycle_layout_next,
        },
        n = {
          ['<C-w>'] = actions.send_selected_to_qflist,
        },
      },
      file_ignore_patterns = { 'node_modules/.*', '%.jpg', '%.jpeg', '%.png', '%.svg', '%.otf', '%.ttf' },
      path_display = { 'smart', 'absolute', 'truncate' },
      layout_strategy = 'flex',
      layout_config = {
        horizontal = {
          preview_width = 0.45,
        },
        cursor = get_border {
          layout_config = {
            cursor = { width = 0.3 },
          },
        },
      },
      winblend = 3,
      history = {
        path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
      },
    },
    extensions = {
      frecency = {
        workspaces = {
          -- conf = vim.env.DOTFILES,
          -- project = vim.env.PROJECTS_DIR,
          -- wiki = vim.g.wiki_path,
        },
      },
      fzf = {
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
      },
    },
    pickers = {
      buffers = dropdown {
        sort_mru = true,
        sort_lastused = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        previewer = false,
        theme = 'dropdown',
        mappings = {
          i = { ['<c-x>'] = 'delete_buffer' },
          n = { ['<c-x>'] = 'delete_buffer' },
        },
      },
      oldfiles = dropdown(),
      live_grep = {
        file_ignore_patterns = { '.git/' },
      },
      current_buffer_fuzzy_find = dropdown {
        previewer = false,
        shorten_path = false,
      },
      lsp_code_actions = {
        theme = 'cursor',
      },
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        hidden = true,
      },
      git_branches = dropdown(),
      git_bcommits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
      git_commits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
      reloader = dropdown(),
    },
  }

  local builtins = require 'telescope.builtin'

  local function project_files(opts)
    print "Finding Files"
    if not pcall(builtins.git_files, opts) then
      builtins.find_files(opts)
    end
  end

  local function nvim_config()
    builtins.find_files {
      prompt_title = '~ nvim config ~',
      cwd = vim.fn.stdpath 'config',
      file_ignore_patterns = { '.git/.*' },
    }
  end

  local function dotfiles()
    builtins.find_files {
      prompt_title = '~ dotfiles ~',
      cwd = vim.g.dotfiles,
    }
  end

  local function grep_prompt()
    builtins.grep_string({
      path_display = { "shorten" },
      search = vim.fn.input("Grep String ❱ "),
    })
  end

  local function grep_word()
    builtins.grep_string({
      path_display = { "shorten" },
      search = vim.fn.expand("<cword>"),
    })
  end

  local function installed_plugins()
    builtins.find_files {
      cwd = vim.fn.stdpath 'data' .. '/site/pack/packer',
    }
  end

  require('which-key').register {
    ['<C-p>'] = { project_files, 'telescope: find files' },
    ['<leader>f'] = {
      name = '+telescope',
      f = { builtins.find_files, 'find files' },
      o = { builtins.buffers, 'buffers' },
      s = { grep_prompt, "Grep string"},
      w = { grep_word, "Grep word"},
      -- s = { builtins.live_grep, 'grep string' },
    },
  }
end
