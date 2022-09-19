----------------------------------------------------------------------------------------------------
-- Styles
----------------------------------------------------------------------------------------------------
-- Consistent store of various UI items to reuse throughout my config

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
  border = {
    line = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
    rectangle = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  },
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
    codicons = {
      Text = '',
      Method = '',
      Function = '',
      Constructor = '',
      Field = '',
      Variable = '',
      Class = '',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '',
      Enum = '',
      Keyword = '',
      Snippet = '',
      Color = '',
      File = '',
      Reference = '',
      Folder = '',
      EnumMember = '',
      Constant = '',
      Struct = '',
      Event = '',
      Operator = '',
      TypeParameter = '',
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

----------------------------------------------------------------------------------------------------
-- Global style settings
----------------------------------------------------------------------------------------------------
-- Some styles can be tweaked here to apply globally i.e. by setting the current value for that style

-- The current styles for various UI elements
wlvs.style.current = {
  border = wlvs.style.border.line,
}
