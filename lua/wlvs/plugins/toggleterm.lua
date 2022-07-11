return function()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if not status_ok then
    return
  end

  -- local util = require("util")
  local round = function(num)
    return math.floor(num + 0.5)
  end

  toggleterm.setup({
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    -- direction = "float",
    direction = "horizontal",
    close_on_exit = false,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      -- height = round(vim.opt.lines:get() * 0.9),
      -- width = round(vim.opt.columns:get() * 0.45),
      -- col = vim.opt.columns:get() * 0.54,
      -- row = vim.opt.lines:get() * 0.05,
      winblend = 6,
    },
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
  })
end
