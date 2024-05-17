return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  priority = 100,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    -- { "abecodes/tabout.nvim", opts = { ignore_beginning = false, completion = false } },
  },
  config = function()
    require("config.completion")
  end,
  -- opts = function()
  --   vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --   local cmp = require("cmp")
  --   local luasnip = require("luasnip")
  --   local defaults = require("cmp.config.default")()
  --
  --   local function shift_tab(fallback)
  --     if not cmp.visible() then
  --       return fallback()
  --     end
  --     if luasnip.jumpable(-1) then
  --       luasnip.jump(-1)
  --     end
  --   end
  --
  --   local function tab(fallback) -- make TAB behave like Android Studio
  --     if not cmp.visible() then
  --       return fallback()
  --     end
  --     if not cmp.get_selected_entry() then
  --       return cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  --     end
  --     if luasnip.expand_or_jumpable() then
  --       return luasnip.expand_or_jump()
  --     end
  --     cmp.confirm()
  --   end
  --
  --   return {
  --     snippet = {
  --       expand = function(args)
  --         luasnip.lsp_expand(args.body)
  --       end,
  --     },
  --     mapping = cmp.mapping.preset.insert({
  --       ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --       ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --       ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
  --       ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
  --       ["<C-Space>"] = cmp.mapping.complete(),
  --       ["<C-e>"] = cmp.mapping.abort(),
  --       ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --       ["<S-TAB>"] = cmp.mapping(shift_tab, { "i", "s" }),
  --       ["<TAB>"] = cmp.mapping(tab, { "i", "s" }),
  --       -- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --       -- ["<S-CR>"] = cmp.mapping.confirm({
  --       --   behavior = cmp.ConfirmBehavior.Replace,
  --       --   select = true,
  --       -- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --     }),
  --     sources = cmp.config.sources({
  --       { name = "nvim_lsp" },
  --       { name = "luasnip" },
  --       { name = "path" },
  --       { name = "buffer" },
  --     }),
  --     formatting = {
  --       format = function(_, item)
  --         local icons = require("config.settings").icons.kinds
  --         if icons[item.kind] then
  --           item.kind = icons[item.kind] .. item.kind
  --         end
  --         return item
  --       end,
  --     },
  --     experimental = {
  --       ghost_text = {
  --         hl_group = "CmpGhostText",
  --       },
  --     },
  --     sorting = defaults.sorting,
  --   }
  -- end,
}
