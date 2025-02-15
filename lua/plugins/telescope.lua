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
  keys = {
    { "<leader>sg", grep_string_prompt, desc = "Grep Prompt" },
    { "<leader>sG", grep_word, desc = "Grep Current Word" },
  },
}
