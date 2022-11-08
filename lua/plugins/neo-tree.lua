local M = {
  cmd = "Neotree",
  requires = { "s1n7ax/nvim-window-picker" },
}

function M.config()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  require("neo-tree").setup({
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.cmd("setlocal signcolumn=no")
          vim.cmd("highlight! Cursor blend=100")
        end,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = function()
          vim.cmd("highlight! Cursor blend=0")
        end,
      },
    },
    filesystem = {
      follow_current_file = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {
          ".DS_Store",
        },
      },
    },
    window = {
      mappings = {
        o = "toggle_node",
        ["<CR>"] = "open_with_window_picker",
        ["<c-s>"] = "split_with_window_picker",
        ["<c-v>"] = "vsplit_with_window_picker",
      },
    },
  })
end

return M
