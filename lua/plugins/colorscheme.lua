return {
  {
    "rebelot/kanagawa.nvim",
    opts = {
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
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },
}
