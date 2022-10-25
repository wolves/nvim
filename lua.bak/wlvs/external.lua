local M ={
  kitty = {},
}

local hl_ok, H = wlvs.safe_require('wlvs.highlights', { silent = true })

local fn = vim.fn
local fmt = string.format

function M.kitty.set_background()
  if not hl_ok then
    return
  end
  if vim.env.KITTY_LISTEN_ON then
    local bg = H.get_hl('MsgArea', 'bg')
    fn.jobstart(fmt('kitty @ --to %s set-colors background=%s', vim.env.KITTY_LISTEN_ON, bg))
  end
end

---Reset the kitty terminal colors
function M.kitty.clear_background()
  if not hl_ok then
    return
  end
  if vim.env.KITTY_LISTEN_ON then
    local bg = H.get_hl('Normal', 'bg')
    -- this is intentionally synchronous so it has time to execute fully
    fn.system(fmt('kitty @ --to %s set-colors background=%s', vim.env.KITTY_LISTEN_ON, bg))
  end
end

local function fileicon()
  local name = fn.bufname()
  local icon, hl
  -- local loaded, devicons = wlvs.safe_require 'nvim-web-devicons'
  -- if loaded then
  if false then
    icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ':e'), { default = true })
  end
  return icon, hl
end

function M.title_string()
  if not hl_ok then
    return
  end
  local dir = fn.fnamemodify(fn.getcwd(), ':t')
  local icon, hl = fileicon()
  if not hl then
    return (icon or '') .. ' '
  end
  return fmt('%s #[fg=%s]%s ', dir, H.get_hl(hl, 'fg'), icon)
end

return M
