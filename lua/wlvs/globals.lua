local fn = vim.fn
local api = vim.api
local fmt = string.format

--------------------------------------------------------------------------------
-- Global
--------------------------------------------------------------------------------
--
--- store all callbacks in one global table so they are able to survive re-requiring this file
-- _G.__wlvs_global_callbacks = __wlvs_global_callbacks or {}
_G.wlvs = {
  -- _store = __wlvs_global_callbacks,
  --- work around to place functions in the global scope but namespaced within a table.
  --- TODO: refactor this once nvim allows passing lua functions to mappings
  mappings = {},
}

------------------------------------------------------------------------------//
-- UI Elements
------------------------------------------------------------------------------//
do
    local palette = {
    pale_red = '#E06C75',
    dark_red = '#be5046',
    light_red = '#c43e1f',
    dark_orange = '#FF922B',
    green = '#98c379',
    bright_yellow = '#FAB005',
    light_yellow = '#e5c07b',
    dark_blue = '#4e88ff',
    magenta = '#c678dd',
    comment_grey = '#5c6370',
    grey = '#3E4556',
    whitesmoke = '#626262',
    bright_blue = '#51afef',
    teal = '#15AABF',
    }

    wlvs.style = {
    icons = {
      error = '✗',
      warn = '',
      info = '',
      hint = '',
    },
    lsp = {
      colors = {
        error = palette.pale_red,
        warn = palette.dark_orange,
        hint = palette.bright_yellow,
        info = palette.teal,
      },
      kind_highlights = {
        Text = 'String',
        Method = 'Method',
        Function = 'Function',
        Constructor = 'TSConstructor',
        Field = 'Field',
        Variable = 'Variable',
        Class = 'Class',
        Interface = 'Constant',
        Module = 'Include',
        Property = 'Property',
        Unit = 'Constant',
        Value = 'Variable',
        Enum = 'Type',
        Keyword = 'Keyword',
        File = 'Directory',
        Reference = 'Preproc',
        Constant = 'Constant',
        Struct = 'Type',
        Event = 'Variable',
        Operator = 'Operator',
        TypeParameter = 'Type',
      },
      kinds = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = 'ﰠ',
        Variable = '',
        Class = 'ﴯ',
        Interface = '',
        Module = '',
        Property = 'ﰠ',
        Unit = '塞',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = 'פּ',
        Event = '',
        Operator = '',
        TypeParameter = '',
      },
    },
    palette = palette
    }
end

------------------------------------------------------------------------------//
-- Debug
------------------------------------------------------------------------------//
-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- @see: https://www.reddit.com/r/neovim/comments/p84iu2/useful_functions_to_explore_lua_objects/
-- USAGE:
-- in lua: P({1, 2, 3})
-- in commandline: :lua P(vim.loop)
---@vararg any
function P(...)
    local objects, v = {}, nil
    for i = 1, select('#', ...) do
        v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, '\n'))
    return ...
end

function _G.dump_text(...)
    local objects, v = {}, nil
    for i = 1, select('#', ...) do
        v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    local lines = vim.split(table.concat(objects, '\n'), '\n')
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    vim.fn.append(lnum, lines)
    return ...
end

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function wlvs.plugin_installed(plugin_name)
    if not installed then
        local dirs = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/start/*', true, true)
        local opt = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/opt/*', true, true)
        vim.list_extend(dirs, opt)
        installed = vim.tbl_map(function(path)
            return fn.fnamemodify(path, ':t')
        end, dirs)
    end
    return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function wlvs.plugin_loaded(plugin_name)
    local plugins = packer_plugins or {}
    return plugins[plugin_name] and plugins[plugin_name].loaded
end

-----------------------------------------------------------------------------//
-- Utils
-----------------------------------------------------------------------------//
---Check whether or not the location or quickfix list is open
---@return boolean
function wlvs.is_vim_list_open()
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        local location_list = fn.getloclist(0, { filewinid = 0 })
        local is_loc_list = location_list.filewinid > 0
        if vim.bo[buf].filetype == 'qf' or is_loc_list then
            return true
        end
    end
    return false
end

-- function wlvs._create(f)
--     table.insert(wlvs._store, f)
--     return #wlvs._store
-- end

-- function wlvs._execute(id, args)
--     wlvs._store[id](args)
-- end

---@class Autocommand
---@field events string[] list of autocommand events
---@field targets string[] list of autocommand patterns
---@field modifiers string[] e.g. nested, once
---@field command string | function

---@param command Autocommand
local function is_valid_target(command)
    local valid_type = command.targets and vim.tbl_islist(command.targets)
    return valid_type or vim.startswith(command.events[1], 'User ')
end

local L = vim.log.levels

---@class Autocommand
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function wlvs.augroup(name, commands)
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

---Create an autocommand
---@param name string
---@param commands Autocommand[]
-- function wlvs.augroup(name, commands)
--     vim.cmd('augroup ' .. name)
--     vim.cmd 'autocmd!'
--     for _, c in ipairs(commands) do
--         if c.command and c.events and is_valid_target(c) then
--             local command = c.command
--             if type(command) == 'function' then
--                 local fn_id = wlvs._create(command)
--                 command = fmt('lua wlvs._execute(%s)', fn_id)
--             end
--             c.events = type(c.events) == 'string' and { c.events } or c.events
--             vim.cmd(
--             string.format(
--             'autocmd %s %s %s %s',
--                 table.concat(c.events, ','),
--                 table.concat(c.targets or {}, ','),
--                 table.concat(c.modifiers or {}, ' '),
--                 command
--             )
--             )
--         else
--             vim.notify(
--             fmt('An autocommand in %s is specified incorrectly: %s', name, vim.inspect(name)),
--                 L.ERROR
--             )
--         end
--     end
--     vim.cmd 'augroup END'
-- end

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
function wlvs.source(path, prefix)
    if not prefix then
        vim.cmd(fmt('source %s', path))
    else
        vim.cmd(fmt('source %s/%s', vim.g.vim_dir, path))
    end
end

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function wlvs.safe_require(module, opts)
    opts = opts or { silent = false }
    local ok, result = pcall(require, module)
    if not ok and not opts.silent then
        vim.notify(result, vim.log.levels.ERROR, { title = fmt('Error requiring: %s', module) })
    end
    return ok, result
end

---Check if a cmd is executable
---@param e string
---@return boolean
function wlvs.executable(e)
    return fn.executable(e) > 0
end

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function wlvs.deep_merge(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
            wlvs.deep_merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return any
function wlvs.replace_termcodes(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

--- Usage:
--- 1. Call `local stop = utils.profile('my-log')` at the top of the file
--- 2. At the bottom of the file call `stop()`
--- 3. Restart neovim, the newly created log file should open
function wlvs.profile(filename)
    local base = '/tmp/config/profile/'
    fn.mkdir(base, 'p')
    local success, profile = pcall(require, 'plenary.profile.lua_profiler')
    if not success then
        vim.api.nvim_echo({ 'Plenary is not installed.', 'Title' }, true, {})
    end
    profile.start()
    return function()
        profile.stop()
        local logfile = base .. filename .. '.log'
        profile.report(logfile)
        vim.defer_fn(function()
            vim.cmd('tabedit ' .. logfile)
        end, 1000)
    end
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function wlvs.has(feature)
    return vim.fn.has(feature) > 0
end

wlvs.nightly = wlvs.has 'nvim-0.7'

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function wlvs.find(haystack, matcher)
    local found
    for _, needle in ipairs(haystack) do
        if matcher(needle) then
            found = needle
            break
        end
    end
    return found
end

---Determine if a value of any type is empty
---@param item any
---@return boolean
function wlvs.empty(item)
    if not item then
        return true
    end
    local item_type = type(item)
    if item_type == 'string' then
        return item == ''
    elseif item_type == 'table' then
        return vim.tbl_isempty(item)
    end
end

---Create an nvim command
---@param args table
-- function wlvs.command(args)
--     local nargs = args.nargs or 0
--     local name = args[1]
--     local rhs = args[2]
--     local types = (args.types and type(args.types) == 'table') and table.concat(args.types, ' ') or ''
--
--     if type(rhs) == 'function' then
--         local fn_id = wlvs._create(rhs)
--         rhs = string.format('lua wlvs._execute(%d%s)', fn_id, nargs > 0 and ', <f-args>' or '')
--     end
--
--     vim.cmd(string.format('command! -nargs=%s %s %s %s', nargs, types, name, rhs))
-- end

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
function wlvs.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

function wlvs.invalidate(path, recursive)
    if recursive then
        for key, value in pairs(package.loaded) do
            if key ~= '_G' and value and vim.fn.match(key, path) ~= -1 then
                package.loaded[key] = nil
                require(key)
            end
        end
    else
        package.loaded[path] = nil
        require(path)
    end
end


-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { desc = opts } or opts and vim.deepcopy(opts) or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('keep', opts, parent_opts))
  end
end

local map_opts = { noremap = false, silent = true }
local noremap_opts = { noremap = true, silent = true }

-- A recursive commandline mapping
wlvs.nmap = make_mapper('n', map_opts)
-- A recursive select mapping
wlvs.xmap = make_mapper('x', map_opts)
-- A recursive terminal mapping
wlvs.imap = make_mapper('i', map_opts)
-- A recursive operator mapping
wlvs.vmap = make_mapper('v', map_opts)
-- A recursive insert mapping
wlvs.omap = make_mapper('o', map_opts)
-- A recursive visual & select mapping
wlvs.tmap = make_mapper('t', map_opts)
-- A recursive visual mapping
wlvs.smap = make_mapper('s', map_opts)
-- A recursive normal mapping
wlvs.cmap = make_mapper('c', { noremap = false, silent = false })
-- A non recursive normal mapping
wlvs.nnoremap = make_mapper('n', noremap_opts)
-- A non recursive visual mapping
wlvs.xnoremap = make_mapper('x', noremap_opts)
-- A non recursive visual & select mapping
wlvs.vnoremap = make_mapper('v', noremap_opts)
-- A non recursive insert mapping
wlvs.inoremap = make_mapper('i', noremap_opts)
-- A non recursive operator mapping
wlvs.onoremap = make_mapper('o', noremap_opts)
-- A non recursive terminal mapping
wlvs.tnoremap = make_mapper('t', noremap_opts)
-- A non recursive select mapping
wlvs.snoremap = make_mapper('s', noremap_opts)
-- A non recursive commandline mapping
wlvs.cnoremap = make_mapper('c', { noremap = true, silent = false })
