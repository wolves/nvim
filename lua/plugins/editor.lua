return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    --keys = {
    --  {
    --    "<leader>ft",
    --    function()
    --      require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
    --    end,
    --    desc = "NeoTree",
    --  },
    --},
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
}
