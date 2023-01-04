local function grep_string_prompt()
  require("telescope.builtin").grep_string({
    path_display = { "shorten" },
    search = vim.fn.input("Grep String ❱ "),
  })
end

local function grep_word()
  require("telescope.builtin").grep_string({
    path_display = { "shorten" },
    search = vim.fn.expand("<cword>"),
  })
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ss", grep_string_prompt, desc = "Grep Prompt" },
    { "<leader>sw", grep_word, desc = "Grep Current Word" },
  },
  config = function()
    local telescope = require("telescope")
    local borderless = true
    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = borderless and 0 or 10,
      },
    })
    telescope.load_extension("fzf")
  end,
}
