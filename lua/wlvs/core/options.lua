local opt = vim.opt
local indent = 2

local options = {
  autowrite = true,
  clipboard = "unnamedplus",
  completeopt = "menu,menuone,noselect",
  conceallevel = 3,
  confirm = true,
  cursorline = true,
  expandtab = true,
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",
  -- guifont = "FiraCode Nerd Font:h12",
  -- hidden = true,
  ignorecase = true,
  inccommand = "nosplit",
  joinspaces = false,
  laststatus = 0,
  list = true,
  mouse = "a",
  number = true,
  pumblend = 10,
  pumheight = 10,
  scrolloff = 4,
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
  shiftround = true,
  shiftwidth = indent,
  showmode = false,
  sidescrolloff = 8,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  spelllang = { "en" },
  splitbelow = true,
  splitright = true,
  relativenumber = true,
  -- rmatoptions = "jcroqlnt",
  tabstop = indent,
  termguicolors = true,
  timeoutlen = 300,
  undofile = true,
  undolevels = 10000,
  updatetime = 200,
  wildmode = "longest:full,full",
  winminwidth = 5,
  wrap = false,

  fillchars = {
    --   horiz = "━",
    --   horizup = "┻",
    --   horizdown = "┳",
    --   vert = "┃",
    --   vertleft = "┫",
    --   vertright = "┣",
    --   verthoriz = "╋",im.o.fillchars = [[eob: ,
    -- fold = " ",
    foldopen = "",
    -- foldsep = " ",
    foldclose = "",
  },
}

-- Global
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.ruby_host_prog = "/home/wlvs/.asdf/shims/ruby"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Use proper syntax highlighting in code blocks
local fences = {
  "lua",
  -- "vim",
  "json",
  "typescript",
  "javascript",
  "js=javascript",
  "ts=typescript",
  "shell=sh",
  "python",
  "sh",
  "console=sh",
}
vim.g.markdown_fenced_languages = fences

-- Set Options
for k, v in pairs(options) do
  opt[k] = v
end
