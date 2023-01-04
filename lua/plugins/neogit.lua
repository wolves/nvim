return {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  config = {
    disable_commit_confirmation = true,
    kind = "split",
    commit_popup = {
      kind = "split",
    },
    popup = {
      kind = "split",
    },
    signs = {
      -- { CLOSED, OPENED }
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
    integrations = { diffview = true },
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
  },
}
