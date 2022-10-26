local wk = require("which-key")

local M = {}

function M.setup(client, bufer)
  local cap = client.server_capabilities

  local keymap = {
    buffer = buffer,
    ["<leader>"] = {
      c = {
        name = "+code",
        {
          cond = client.name == "tsserver",
          o = { "<cmd>:TypescriptOrganizeImports<CR>", "Organize Imports" },
          R = { "<cmd>:TypescriptRenameFile<CR>", "Rename File" },
        },
        l = {
          name = "+lsp",
          i = { "<cmd>LspInfo<CR>", "Lsp Info" },
        },
      },
      g = {
        name = "+goto",
        d = { "<cmd>Telescope lsp_definitions<CR>", "Goto Definition" },
        r = { "<cmd>Telescope lsp_references<CR>", "References" },
        R = { "<cmd>Trouble lsp_references<CR>", "Trouble References" },
      },
    },
  }

  wk.register(keymap)
end

return M
