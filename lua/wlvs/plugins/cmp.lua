return function()
  local api = vim.api
  local t = wlvs.replace_termcodes
  local cmp = require 'cmp'
  local fmt = string.format

  local function feed(key, mode)
    api.nvim_feedkeys(t(key), mode or '', true)
  end

  local function get_luasnip()
    local ok, luasnip = wlvs.safe_require('luasnip', { silent = true })
    if not ok then
      return nil
    end
    return luasnip
  end

  local function tab(fallback)
    local luasnip = get_luasnip()
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip and luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif api.nvim_get_mode().mode == 'c' then
      fallback()
    else
      feed '<Plug>(Tabout)'
    end
  end

  local function shift_tab(fallback)
    local luasnip = get_luasnip()
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    elseif api.nvim_get_mode().mode == 'c' then
      fallback()
    else
      feed '<Plug>(Tabout)'
    end
  end

  cmp.setup {
    experimental = {
      ghost_text = false, -- disable whilst using copilot
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }
    },
    formatting = {
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = wlvs.style.lsp.kinds[vim_item.kind]
        local name = entry.source.name
        local completion = entry.completion_item.data
        -- FIXME: automate this using a regex to normalise names
        local menu = ({
          nvim_lsp = '[LSP]',
          -- nvim_lua = '[Lua]',
          -- emoji = '[Emoji]',
          path = '[Path]',
          -- calc = '[Calc]',
          -- neorg = '[Neorg]',
          -- orgmode = '[Org]',
          -- cmp_tabnine = '[TN]',
          luasnip = '[Luasnip]',
          buffer = '[Buffer]',
          -- spell = '[Spell]',
          -- cmdline = '[Command]',
          -- cmp_git = '[Git]',
        })[name]

        vim_item.menu = menu
        return vim_item
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      -- { name = 'cmp_tabnine' },
      -- { name = 'spell' },
      -- { name = 'neorg' },
      -- { name = 'orgmode' },
      -- { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end
