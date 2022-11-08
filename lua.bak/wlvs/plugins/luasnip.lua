return function()
    local fn = vim.fn

    local ls = require 'luasnip'
    local extras = require 'luasnip.extras'
    local types = require 'luasnip.util.types'

    local snippet = ls.snippet
    local text = ls.text_node
    local f = ls.function_node
    local insert = ls.insert_node
    local l = extras.lambda
    local match = extras.match

    ls.config.set_config {
    history = false,
    region_check_events = 'CursorMoved,CursorHold,InsertEnter',
    delete_check_events = 'InsertLeave',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '●', 'Operator' } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { '●', 'Type' } },
        },
      },
    },
    enable_autosnippets = true,
    }
    local opts = { expr = true }
    wlvs.imap('<c-j>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-j>'", opts)
    wlvs.imap('<c-k>', "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev': '<c-k>'", opts)
    wlvs.snoremap('<c-j>', function()
        ls.jump(1)
    end)
    wlvs.snoremap('<c-k>', function()
        ls.jump(-1)
    end)

    ls.snippets = {
    lua = {
    }
    }
end
