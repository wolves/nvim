local Util = require("util")

local config = {
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = Util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "diagnostics",
    -- "document_symbols",
  },
  source_selector = {
    winbar = true, -- toggle to show selector on winbar
    content_layout = "center",
    tabs_layout = "equal",
    show_separator_on_edge = false,
    sources = {
      { source = "filesystem", display_name = "󰉓  Files" },
      { source = "buffers", display_name = "󰈙 Bufs" },
      { source = "git_status", display_name = "  Git" },
      -- { source = "document_symbols", display_name = "o" },
      { source = "diagnostics", display_name = "󰒡  Diag" },
    },
  },
  window = {
    width = 44,
    mappings = {
      ["<cr>"] = "open_with_window_picker",
      ["s"] = "vsplit_with_window_picker",
      ["S"] = "split_with_window_picker",
    },
  },
  filesystem = {
    hijack_netrw_behavior = "open_current",
    window = {
      mappings = {
        ["H"] = "navigate_up",
        ["<bs>"] = "toggle_hidden",
        ["."] = "set_root",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["a"] = { "add", config = { show_path = "relative" } }, -- "none", "relative", "absolute"
      },
    },
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
      never_show = {
        ".DS_Store",
      },
    },
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every
    },
    -- time the current file is changed while the tree is open.
    group_empty_dirs = true, -- when true, empty folders will be grouped together
  },
}

return config
