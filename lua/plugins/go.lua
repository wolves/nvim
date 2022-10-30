local M = {
  ft = "go",
}

function M.config()
  local go = require("go")
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  go.setup({
    disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
    go = "go",
    goimport = "gopls",
    --   fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
    --   gofmt = "gofumpt", -- gofmt cmd,
    max_line_len = 100,
    tag_transform = false,
    gotests_template = "",
    gotests_template_dir = "",
    comment_placeholder = "",
    icons = false,
    verbose = false,
    lsp_cfg = {
      capabilities = capabilities,
      settings = {
        gopls = {
          codelenses = {
            generate = true,
            gc_details = false,
            test = true,
            tidy = true,
          },
          analyses = {
            unusedparams = true,
          },
        },
      },
    },
    lsp_gofumpt = true,
    lsp_diag_virtual_text = true,
    lsp_on_attach = function(client, buffnr)
      local wk = require("which-key")
      local leader = {
        c = {
          name = "+code",
          a = { "<cmd>GoCodeAction<CR>", "Code Action" },
          e = { "<cmd>GoIfErr<CR>", "Add If Err" },
          m = {
            name = "+mod",
            i = { "<cmd>GoModInit<CR>", "Mod Init" },
            t = { "<cmd>GoModTidy<CR>", "Mod Tidy" },
          },
          r = { "<cmd>GoRun<CR>", "Run" },
          t = {
            name = "+tests",
            a = { "<cmd>GoAlt!<CR>", "Alt File" },
            s = { "<cmd>GoAltS!<CR>", "Horz Alt File" },
            v = { "<cmd>GoAltV!<CR>", "Vert Alt File" },
            r = { "<cmd>GoTest<CR>", "Run Tests" },
            u = { "<cmd>GoTestFunc<CR>", "Run Func Test" },
            f = { "<cmd>GoTestFile<CR>", "Run File Test" },
            c = { "<cmd>GoCoverage<CR>", "Coverage" },
          },
        },
      }

      wk.register(leader, { prefix = "<leader>" })
    end,
    lsp_codelens = true,
    lsp_keymaps = false,
    lsp_diag_hdlr = true,
  })

  local group = vim.api.nvim_create_augroup("Golang", {})

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    group = group,
    callback = function()
      require("go.format").goimport()
      -- vim.cmd("silent! lua require('go.format').goimport()")
    end,
  })
end

return M
