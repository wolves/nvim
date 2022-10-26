return {
  keys = "<C-\\>",
  config = function()
    require("toggleterm").setup({
      size = 20,
      hide_numbers = true,
      open_mapping = [[<C-\>]],
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 0.3, -- Bak has 2
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
    })

    -- Hide number column for
    -- vim.cmd [[au TermOpen * setlocal nonumber norelativenumber]]

    -- Esc twice to get to normal mode
    vim.cmd([[tnoremap <esc><esc> <C-\><C-N>]])
  end,
}
