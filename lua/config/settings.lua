local settings = {
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    kinds = {
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Enum = "了 ",
      EnumMember = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = "ﰮ ",
      Keyword = " ",
      Method = "ƒ ",
      Property = " ",
      Snippet = "﬌ ",
      Struct = " ",
      Text = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
  borders = {
    --- @class BorderIcons
    thin = {
      top = "▔",
      right = "▕",
      bottom = "▁",
      left = "▏",
      top_left = "🭽",
      top_right = "🭾",
      bottom_right = "🭿",
      bottom_left = "🭼",
    },
    ---@type BorderIcons
    empty = {
      top = " ",
      right = " ",
      bottom = " ",
      left = " ",
      top_left = " ",
      top_right = " ",
      bottom_right = " ",
      bottom_left = " ",
    },
    ---@type BorderIcons
    thick = {
      top = "▄",
      right = "█",
      bottom = "▀",
      left = "█",
      top_left = "▄",
      top_right = "▄",
      bottom_right = "▀",
      bottom_left = "▀",
    },
  },
}

return settings
