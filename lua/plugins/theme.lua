-- Omarchy-managed theme.
--
-- On omarchy (Linux) the active theme lives at the path below, which omarchy
-- repoints when you switch themes. We source it dynamically so theme switches
-- flow through without touching this file.
--
-- On machines without omarchy (e.g. macOS) the path doesn't exist, so this is a
-- no-op and the default colorscheme (see colorscheme.lua) applies.
--
-- This file replaces what used to be a committed symlink to the omarchy path,
-- which dangled on non-omarchy machines.
local uv = vim.uv or vim.loop
local omarchy_theme = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

if uv.fs_stat(omarchy_theme) then
  return dofile(omarchy_theme)
end

return {}
