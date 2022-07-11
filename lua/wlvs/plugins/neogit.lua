local M = {}

function M.setup()
end

function M.config()
  local status_ok, neogit = pcall(require, "neogit")
  if not status_ok then
    return
  end

  neogit.setup {
    integrations = {
      diffview = true,
    },
    disable_commit_confirmation = true,
    mappings = {
      status = { [">"] = "Toggle"},
    },
    signs = {
      -- { CLOSED, OPENED }
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
  }
end

return M
