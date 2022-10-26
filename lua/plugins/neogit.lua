local M = {
  cmd = "Neogit",
}

function M.config()
  require("neogit").setup({
    kind = "split",
    signs = {
      -- { CLOSED, OPENED }
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
    integrations = { diffview = true },
  })
end

function M.init()
  vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=floating<cr>", { desc = "Neogit" })
end

return M
