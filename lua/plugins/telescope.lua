local function grep_string_prompt()
  require("telescope.builtin").grep_string({
    path_display = { "shorten" },
    search = vim.fn.input("Grep String ❱ "),
  })
end

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>sg", grep_string_prompt, desc = "Grep Prompt" },
  },
}
