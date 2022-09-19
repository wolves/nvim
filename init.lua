------------------------------------------------------------------------------//
--    _/          _/  _/      _/      _/    _/_/_/   
--   _/          _/  _/      _/      _/  _/          
--  _/    _/    _/  _/      _/      _/    _/_/       
--   _/  _/  _/    _/        _/  _/          _/      
--    _/  _/      _/_/_/_/    _/      _/_/_/         
------------------------------------------------------------------------------//
vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand '~/.dotfiles'
vim.g.vim_dir = vim.g.dotfiles .. '~/.config/nvim'


------------------------------------------------------------------------------//
-- Leader
------------------------------------------------------------------------------//
vim.g.mapleader = ' ' -- Remap leader key
vim.g.maplocalleader = ' ' -- Local leader is <Space>

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...)
  return ...
end
function R(name)
  RELOAD(name)
  return require(name)
end

------------------------------------------------------------------------------//
-- Config
------------------------------------------------------------------------------//
R 'wlvs.globals'
R 'wlvs.styles'
R 'wlvs.settings'
R 'wlvs.highlights'
-- R 'wlvs.statusline'
R 'wlvs.plugins'
