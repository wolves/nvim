local M = {
  cmd = "Neotree",
  requires = {
    {
      "s1n7ax/nvim-window-picker",
      opt = false,
      tag = "1.*",
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
    },
  },
}

function M.config()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  require("neo-tree").setup({ filesystem = { follow_current_file = true } })
end

return M
