local config = function()
  require("kanagawa").setup({
    compile = false,
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    -- variablebuiltinStyle = { italic = true },
    -- specialReturn = true, -- special highlight for the return keyword
    -- specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = true,
    globalStatus = true,
    colors = {},
    overrides = function(colors)
      return {
        WinSeparator = { fg = colors.palette.oniViolet },
      }
    end,
    theme = "wave",
    background = {
      dark = "wave",
      light = "lotus",
    },
  })
  vim.cmd.colorscheme("kanagawa-wave")
  vim.cmd.highlight({ "WinSeparator", "guibg=None" })
end

return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = config,
}
