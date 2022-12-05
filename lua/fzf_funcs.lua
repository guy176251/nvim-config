local M = {}

function M.cwd()
    local path = vim.fn.expand("%:p:h")
    vim.cmd("Files " .. path)
end

return M
