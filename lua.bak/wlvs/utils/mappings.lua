------------------------------------------------------------------------------//
-- Mappings
------------------------------------------------------------------------------//

-- - https://github.com/b0o/mapx.nvim <-- Check Out

local api = vim.api
local fmt = string.format

---check if a mapping already exists
---@param lhs string
---@param mode string
---@return boolean
function wlvs.has_map(lhs, mode)
  mode = mode or 'n'
  return vim.fn.maparg(lhs, mode) ~= ''
end



---Factory function to create multi mode map functions
---e.g. `wlvs.map({"n", "s"}, lhs, rhs, opts)`
---@param target string
---@return fun(modes: string[], lhs: string, rhs: string, opts: table)
local function multimap(target)
  return function(modes, lhs, rhs, opts)
    for _, m in ipairs(modes) do
      wlvs[m .. target](lhs, rhs, opts)
    end
  end
end

wlvs.map = multimap 'map'
wlvs.noremap = multimap 'noremap'
