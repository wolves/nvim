local wk = require("which-key")

local M = {}

function M.setup(client, buffer)
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
        a = {
          { vim.lsp.buf.code_action, "Code Action" },
          { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action", mode = "v" },
        },
        d = { vim.diagnostic.open_float, "Line Diagnostics" },
        f = {
          { require("plugins.lsp.formatting").format, "Format Document", cond = cap.documentFormatting },
          {
            require("plugins.lsp.formatting").format,
            "Format Range",
            cond = cap.documentRangeFormatting,
            mode = "v",
          },
        },
        l = {
          name = "+lsp",
          i = { "<cmd>LspInfo<CR>", "Lsp Info" },
          a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
          l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Folders" },
          r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
        },
        r = {
          function()
            require("inc_rename")
            return ":IncRename " .. vim.fn.expand("<cword>")
          end,
          "Rename",
          cond = cap.renameProvider,
          expr = true,
        },
      },
      x = {
        d = { "<cmd>Telescope diagnostics<cr>", "Search Diagnostics" },
      },
    },
    g = {
      name = "+goto",
      d = { "<cmd>Telescope lsp_definitions<CR>", "Goto Definition" },
      D = { "<cmd>Telescope lsp_declarations<CR>", "Goto Declaration" },
      I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementations" },
      r = { "<cmd>Telescope lsp_references<CR>", "References" },
      R = { "<cmd>Trouble lsp_references<CR>", "Trouble References" },
      s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
      t = { "<cmd>Telescope lsp_type_definitions<CR>", "Goto Type Definition" },
    },
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
    ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostic" },
    ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
    ["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", "Prev Error" },
    ["]e"] = { "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", "Next Error" },
    ["[w"] = {
      "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<CR>",
      "Prev Warning",
    },
    ["]w"] = {
      "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<CR>",
      "Next Warning",
    },
  }

  wk.register(keymap)
end

return M
