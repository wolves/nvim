local M = {
  run = ":TSUpdate",
  event = "User PackerDefered",
  module = "nvim-treesitter",
  requires = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "RRethy/nvim-treesitter-textsubjects",
    "nvim-treesitter/nvim-treesitter-refactor",
    "p00f/nvim-ts-rainbow",
    -- { "mfussenegger/nvim-treehopper", module = "tsht" },
  },
}

function M.init()
  -- vim.cmd([[
  --   omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
  --   xnoremap <silent> m :lua require('tsht').nodes()<CR>
  -- ]])
end

function M.config()
  local rainbow_clrs = {}
  local kana_ok, kana_clr = pcall(require, "kanagawa.colors")

  if kana_ok then
    rainbow_clrs = {
      kana_clr.autumnYellow,
      kana_clr.oniViolet,
      kana_clr.crystalBlue,
      -- kana_color.fujiWhite,
      -- kana_color.sakuraPink,
      -- kana_color.springGreen,
    }
  else
    rainbow_clrs = {
      "Gold",
      "Orchid",
      "DodgerBlue",
      -- "Cornsilk",
      -- "Salmon",
      -- "LawnGreen",
    }
  end
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      -- "comment", -- comments are slowing down TS bigtime, so disable for now
      "cpp",
      "css",
      "fish",
      "gitignore",
      "go",
      "graphql",
      "help",
      "html",
      "http",
      "java",
      "javascript",
      "jsdoc",
      "jsonc",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "meson",
      "ninja",
      "nix",
      "norg",
      "org",
      "php",
      "python",
      "regex",
      "rust",
      "scss",
      "sql",
      "svelte",
      "teal",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vue",
      "wgsl",
      "yaml",
      -- "wgsl",
      -- "json",
      -- "markdown",
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = false },
    rainbow = {
      enable = true,
      colors = rainbow_clrs,
      disable = { "lua", "json", "html" },
    },
    matchup = {
      enable = true,
    },
    context_commentstring = { enable = true, enable_autocmd = false },
    incremental_selection = {
      enable = false,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-n>",
        scope_incremental = "<C-s>",
        node_decremental = "<C-r>",
      },
    },
    refactor = {
      smart_rename = {
        enable = true,
        client = {
          smart_rename = "<leader>cr",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          -- goto_definition = "gd",
          -- list_definitions = "gnD",
          -- list_definitions_toc = "gO",
          -- goto_next_usage = "<a-*>",
          -- goto_previous_usage = "<a-#>",
        },
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = true, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      },
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ["gD"] = "@function.outer",
        },
      },
    },
  })
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.markdown.filetype_to_parsername = "octo"
end

return M
