return function ()
  local rt = require 'rust-tools'

  local setup ={
    server = {
      settings = {
        -- on_attach = function(_, bufnr)
        --     -- Hover actions
        --     vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        --     -- Code action groups
        --     vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        --     require 'illuminate'.on_attach(client)
        -- end,
        ["rust-analyzer"] = {
          assist = {
            importEnforceGranularity = true,
            importPrefix = "crate"
          },
          cargo = {
            allFeatures = true
          },
          checkOnSave = {
            -- default: `cargo check`
            command = "clippy"
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
        },
      }
    }
  }

  rt.setup(setup)
end
