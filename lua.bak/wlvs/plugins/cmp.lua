return function()
  local cmp = require 'cmp'

  local fn = vim.fn
  local api = vim.api
  local fmt = string.format
  local t = wlvs.replace_termcodes

  local border = wlvs.style.current.border
  local lsp_hls = wlvs.style.lsp.kind_highlights

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

  local cmp_window = {
    borer = border,
    winhighlight = table.concat({
      'Normal:NormalFloat',
      'FloatBorder:FloatBorder',
      'CursorLine:Visual',
      'Search:None',
    }, ','),
  }

  cmp.setup {
    preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered(cmp_window),
      documentation = cmp.config.window.bordered(cmp_window),
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
      fields = { 'abbr', 'kind', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = fmt('%s %s', wlvs.style.lsp.kinds[vim_item.kind], vim_item.kind)
        -- vim_item.kind = fmt('%s %s', wlvs.style.lsp.codicons[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          -- nvim_lua = '[Lua]',
          -- emoji = '[Emoji]',
          path = '[Path]',
          -- calc = '[Calc]',
          -- neorg = '[Neorg]',
          -- orgmode = '[Org]',
          -- cmp_tabnine = '[TN]',
          luasnip = '[SN]',
          buffer = '[B]',
          -- spell = '[Spell]',
          cmdline = '[Cmd]',
          git = '[Git]',
        })[entry.source.name]

        vim_item.dup = ({
          luasnip = 0,
          -- nvim_lsp = 0,
          path = 0,
          buffer = 0,
          cmdline = 0,
        })[entry.source.name] or 0
        return vim_item
      end,
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
    sources = cmp.config.sources({
      { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = 'cmdline_history' },
      { name = 'path' },
    }),
    -- mapping = cmp.mapping.preset.cmdline(),
    -- sources = cmp.config.sources({
    --   { name = 'path' }
    -- }, {
    --   { name = 'cmdline' }
    -- })
  })
end
