wlvs.lsp = {}
local fmt = string.format
-- local lspconfig_util = require "lspconfig.util"

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
-- Show the popup diagnostics window, but only once for the current cursor location
-- by checking whether the word under the cursor has changed.
local function diagnostic_popup()
  local cword = vim.fn.expand('<cword>')
  if cword ~= vim.w.lsp_diagnostics_cword then
    vim.w.lsp_diagnostics_cword = cword
    vim.diagnostic.open_float(0, { scope = 'cursor', focus = false })
  end
end

local function setup_autocommands(client, _)
  if client and client.server_capabilities.code_lens then
    wlvs.augroup('LspCodeLens', {
      {
        events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        targets = { '<buffer>' },
        command = vim.lsp.codelens.refresh,
      },
    })
  end
  if client and client.server_capabilities.document_highlight then
    wlvs.augroup('LspCursorCommands', {
      {
        events = { 'CursorHold' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { 'CursorHoldI' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { 'CursorMoved' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.clear_references,
      },
    })
  end
  if client and client.server_capabilities.document_formatting then
    -- format on save
    wlvs.augroup('LspFormat', {
      {
        events = { 'BufWritePre' },
        targets = { '<buffer>' },
        command = function()
          -- BUG: folds are are removed when formatting is done, so we save the current state of the
          -- view and re-apply it manually after formatting the buffer
          -- @see: https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939
          vim.cmd 'mkview!'
          local ok, msg = pcall(vim.lsp.buf.formatting_sync, nil, 2000)
          if not ok then
            vim.notify(fmt('Error formatting file: %s', msg))
          end
          vim.cmd 'loadview'
        end,
      },
    })
  end
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
local function setup_mappings(client)
  local ok = pcall(require, 'lsp-format')
  local format = ok and '<Cmd>Format<CR>' or vim.lsp.buf.formatting
  local function with_desc(desc)
    return { buffer = 0, desc = desc }
  end

  if client.server_capabilities.documentFormattingProvider then
    wlvs.nnoremap('<leader>rf', format, with_desc('lsp: format buffer'))
  end

  if client.server_capabilities.codeActionProvider then
    wlvs.nnoremap('<leader>ca', vim.lsp.buf.code_action, with_desc('lsp: code action'))
    wlvs.xnoremap('<leader>ca', vim.lsp.buf.range_code_action, with_desc('lsp: code action'))
  end

  if client.server_capabilities.definitionProvider then
    wlvs.nnoremap('gd', vim.lsp.buf.definition, with_desc('lsp: definition'))
  end

  if client.server_capabilities.referencesProvider then
    wlvs.nnoremap('gr', vim.lsp.buf.references, with_desc('lsp: references'))
  end

  if client.server_capabilities.hoverProvider then
    wlvs.nnoremap('K', vim.lsp.buf.hover, with_desc('lsp: hover'))
  end

  if client.supports_method('textDocument/prepareCallHierarchy') then
    wlvs.nnoremap('gI', vim.lsp.buf.incoming_calls, with_desc('lsp: incoming calls'))
  end

  if client.server_capabilities.implementationProvider then
    wlvs.nnoremap('gi', vim.lsp.buf.implementation, with_desc('lsp: implementation'))
  end

  if client.server_capabilities.typeDefinitionProvider then
    wlvs.nnoremap('<leader>gd', vim.lsp.buf.type_definition, with_desc('lsp: go to type definition'))
  end

  if client.server_capabilities.codeLensProvider then
    wlvs.nnoremap('<leader>cl', vim.lsp.codelens.run, with_desc('lsp: run code lens'))
  end

  if client.server_capabilities.renameProvider then
    wlvs.nnoremap('<leader>rn', vim.lsp.buf.rename, with_desc('lsp: rename'))
  end
end

function wlvs.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client)

  local format_ok, lsp_format = pcall(require, 'lsp-format')
  if format_ok then
    lsp_format.on_attach(client)
  end

  if client.server_capabilities.definitionProvider then
    vim.bo[bufnr].tagfunc = 'v:lua.wlvs.lsp.tagfunc'
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- This is a product of over-engineering dear reader. The LSP servers table
--- can contain a server specified in a bunch of different ways, which is arguably
--- barely more convenient. This function is a helper than then marshals things
--- into the correct shape. All this is more for fun and experimentation with lua
--- than because it's remotely necessary.
---@param name string | number
---@param config table<string, any> | function | string
---@return table<string, any>
function wlvs.lsp.convert_config(name, config)
  if type(name) == 'number' then
    name = config
  end
  local config_type = type(config)
  local data = ({
    ['string'] = function()
      return {}
    end,
    ['boolean'] = function()
      return {}
    end,
    ['table'] = function()
      return config
    end,
    ['function'] = function()
      return config()
    end,
  })[config_type]()
  return name, data
end

-- ---Logic to (re)start installed language servers for use initialising lsps
-- ---and restarting them on installing new ones
-- function wlvs.lsp.get_server_config(server)
--   local nvim_lsp_ok, cmp_nvim_lsp = wlvs.safe_require 'cmp_nvim_lsp'
--   local conf = wlvs.lsp.servers[server.name]
--   local conf_type = type(conf)
--   local config = conf_type == 'table' and conf or conf_type == 'function' and conf() or {}
--   config.flags = { debounce_text_changes = 500 }
--   config.on_attach = wlvs.lsp.on_attach
--   config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
--   if nvim_lsp_ok then
--     cmp_nvim_lsp.update_capabilities(config.capabilities)
--   end
--   return config
-- end

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
---@param config table<string, any>
---@return string, table<string, any>
function wlvs.lsp.get_server_config(config)
  config.on_attach = config.on_attach or wlvs.lsp.on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  local nvim_lsp_ok, cmp_nvim_lsp = wlvs.safe_require('cmp_nvim_lsp')
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  return config
end

--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
wlvs.lsp.servers = {
  'bashls',
  'cssls',
  'jsonls',
  'tsserver',
  'vimls',
  'yamlls',
  gopls = false,
  -- gopls = { analyses = { unusedparams = false }, staticcheck = true },
  -- jsonls = function()
  --   return {
  --     settings = {
  --       json = {
  --         schemas = require('schemastore').json.schemas(),
  --       },
  --     },
  --   }
  -- end,
  -- rust_analyzer = {},
  -- yamlls = {},
  sumneko_lua = function()
    return {
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim',
              'describe',
              'it',
              'before_each',
              'after_each',
              'packer_plugins',
            },
          },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        },
      },
    }
  end,
}

return function()
  require('nvim-lsp-installer').setup({
    automatic_installation = true,
  })
  if vim.v.vim_did_enter == 1 then
    return
  end
  for name, config in pairs(wlvs.lsp.servers) do
    name, config = wlvs.lsp.convert_config(name, config)
    if config then
      require('lspconfig')[name].setup(wlvs.lsp.get_server_config(config))
    end
  end
  -- local lsp_installer = require 'nvim-lsp-installer'
  -- lsp_installer.on_server_ready(function(server)
  --   server:setup(wlvs.lsp.get_server_config(server))
  --   vim.cmd [[ do User LspAttachBuffers ]]
  -- end)
end
