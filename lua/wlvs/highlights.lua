local fmt = string.format
local api = vim.api
local levels = vim.log.levels

local M = {}

---get a highlight groups details from the nvim API and format the result
---to match the attributes seen when using `:highlight GroupName`
--- `nvim_get_hl_by_name` e.g.
---```json
---{
--- foreground: 123456
--- background: 123456
--- italic: true
--- bold: true
--}
---```
--- is converted to
---```json
---{
--- gui: {"italic", "bold"}
--- guifg: #FFXXXX
--- guibg: #FFXXXX
--}
---```
---@param group_name string A highlight group name
local function get_hl(group_name)
  local attrs = { foreground = 'guifg', background = 'guibg' }
  local hl = api.nvim_get_hl_by_name(group_name, true)
  local result = {}
  if hl then
    local gui = {}
    for key, value in pairs(hl) do
      local t = type(value)
      if t == 'number' and attrs[key] then
        result[attrs[key]] = '#' .. bit.tohex(value, 6)
      elseif t == 'boolean' then -- NOTE: we presume that a boolean value is a GUI attribute
        table.insert(gui, key)
      end
    end
    result.gui = #gui > 0 and gui or nil
  end
  return result
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---in the right format
---@param grp string
---@param attr string
---@param fallback string
---@return string
function M.get_hl(grp, attr, fallback)
  if not grp then
    vim.notify('Cannot get a highlight without specifying a group', levels.ERROR)
    return 'NONE'
  end
  local hl = get_hl(grp)
  local color = hl[attr:match 'gui' and attr or fmt('gui%s', attr)] or fallback
  if not color then
    vim.notify(fmt('%s %s does not exist', grp, attr), levels.INFO)
    return 'NONE'
  end
  -- convert the decimal RGBA value from the hl by name to a 6 character hex + padding if needed
  return color
end

return M
