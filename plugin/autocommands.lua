local fn = vim.fn
local api = vim.api
local fmt = string.format
local contains = vim.tbl_contains
local map = vim.keymap.set

-- vim.api.nvim_exec(
--   [[
--    augroup vimrc -- Ensure all autocommands are cleared
--    autocmd!
--    augroup END
--   ]],
--   ''
-- )

local smart_close_filetypes = {
  'help',
  'startuptime',
  'git-status',
  'git-log',
  'gitcommit',
  'LuaTree',
  'log',
  'tsplayground',
  'qf',
  'lspinfo',
  'Trouble',
}

local smart_close_buftypes = {}

local function smart_close()
  if fn.winnr '$' ~= 1 then
    api.nvim_win_close(0, true)
  end
end

wlvs.augroup('SmartClose', {
  {
    -- Close certain filetypes by pressing q.
    event = { 'FileType' },
    pattern = { '*' },
    command = function()
      local is_unmapped = fn.hasmapto('q', 'n') == 0

      local is_eligible = is_unmapped
        or vim.wo.previewwindow
        or contains(smart_close_buftypes, vim.bo.buftype)
        or contains(smart_close_filetypes, vim.bo.filetype)

      if is_eligible then
        wlvs.nnoremap('q', smart_close, { buffer = 0, nowait = true })
      end
    end,
  },
})

wlvs.augroup('Golang', {
  {
    event = {'BufWritePre'},
    pattern = {'*.go'},
    command = "silent! lua require('go.format').goimport()"
  }
})

wlvs.augroup('CheckOutsideTime', {
  {
    -- automatically check for changed files outside vim
    event = { 'WinEnter', 'BufWinEnter', 'BufWinLeave', 'BufRead', 'BufEnter', 'FocusGained' },
    pattern = '*',
    command = 'silent! checktime',
  },
})

wlvs.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = { 'TextYankPost' },
    pattern = '*',
    command = function()
      vim.highlight.on_yank({
        timeout = 500,
        on_visual = false,
        higroup = 'Visual',
      })
    end,
  },
})

local save_excluded = {
  'neo-tree',
  'neo-tree-popup',
  'qf',
  'gitcommit',
  'NeogitCommitMessage',
}
local function can_save()
  return wlvs.empty(vim.bo.buftype)
    and not wlvs.empty(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

wlvs.augroup('Utilities', {
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid.
    event = { 'BufReadPost' },
    command = function()
      if vim.bo.ft ~= 'gitcommit' and vim.fn.win_gettype() ~= 'popup' then
        local last_place_mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_nr = last_place_mark[1]
        local last_line = vim.api.nvim_buf_line_count(0)

        if line_nr > 0 and line_nr <= last_line then
          vim.api.nvim_win_set_cursor(0, last_place_mark)
        end
      end
    end,
  },
  -- {
  --   -- Remember Cursor locations
  --   events = { 'BufWinEnter' },
  --   targets = { '*' },
  --   command = function()
  --     local pos = fn.line [['"]]
  --     if
  --       vim.bo.ft ~= 'gitcommit'
  --       and vim.fn.win_gettype() ~= 'popup'
  --       and pos > 0
  --       and pos <= fn.line '$'
  --     then
  --       vim.cmd 'keepjumps normal g`"'
  --     end
  --   end,
  -- },
  {
    event = { 'FileType' },
    pattern = { 'gitcommit', 'gitrebase' },
    command = 'set bufhidden=delete',
  },
  {
    event = { 'BufWritePre', 'FileWritePre' },
    pattern = { '*' },
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      if can_save() then
        vim.cmd('silent! update')
      end
    end,
  },
})
