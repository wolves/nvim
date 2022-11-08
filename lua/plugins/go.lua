local M = {
  ft = "go",
}

local go_lsp_mappings = function(client, bufnr)
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
end

local go_lsp_inlay_hints = {
  enable = true,
  -- Only show inlay hints for the current line
  only_current_line = false,
  -- Event which triggers a refersh of the inlay hints.
  -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
  -- not that this may cause higher CPU usage.
  -- This option is only respected when only_current_line and
  -- autoSetHints both are true.
  only_current_line_autocmd = "CursorHold",
  -- whether to show variable name before type hints with the inlay hints or not
  -- default: false
  show_variable_name = true,
  -- prefix for parameter hints
  parameter_hints_prefix = " ",
  show_parameter_hints = true,
  -- prefix for all the other hints (type, chaining)
  other_hints_prefix = "=> ",
  -- whether to align to the lenght of the longest line in the file
  max_len_align = false,
  -- padding from the left if max_len_align is true
  max_len_align_padding = 1,
  -- whether to align to the extreme right or not
  right_align = false,
  -- padding from the right if right_align is true
  right_align_padding = 6,
  -- The color of the hints
  highlight = "Comment",
}

function M.config()
  local go = require("go")
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  go.setup({
    disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
    go = "go",
    goimport = "gopls",
    fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
    gofmt = "gofumpt", -- gofmt cmd,
    max_line_len = 120,
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
    lsp_on_attach = go_lsp_mappings,
    lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
    lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
    -- function(bufnr)
    --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
    -- end
    -- to setup a table of codelens
    lsp_diag_hdlr = true,
    lsp_diag_underline = true,
    --virtual text setup
    -- lsp_diag_virtual_text = { space = 0, prefix = "❮" },
    lsp_diag_virtual_text = true,
    lsp_diag_signs = true,
    lsp_diag_update_in_insert = false,
    lsp_document_formatting = true,
    -- set to true: use gopls to format
    -- false if you want to use other formatter tool(e.g. efm, nulls)
    lsp_inlay_hints = go_lsp_inlay_hints,
    gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
    gopls_remote_auto = true, -- add -remote=auto to gopls
    gocoverage_sign = "█",
    sign_priority = 5, -- change to a higher number to override other signs
    dap_debug = true, -- set to false to disable dap
    dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
    -- false: do not use keymap in go/dap.lua.  you must define your own.
    -- windows: use visual studio keymap
    dap_debug_gui = true, -- set to true to enable dap gui, highly recommend
    dap_debug_vt = true, -- set to true to enable dap virtual text
    textobjects = true, -- enable default text jobects through treesittter-text-objects
    test_runner = "richgo", -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
    verbose_tests = true, -- set to add verbose flag to tests
    run_in_floatterm = true, -- set to true to run in float window. :GoTermClose closes the floatterm
    -- float term recommend if you use richgo/ginkgo with terminal color

    trouble = false, -- true: use trouble to open quickfix
    test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
    luasnip = false, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
    --  Do not enable this if you already added the path, that will duplicate the entries
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
