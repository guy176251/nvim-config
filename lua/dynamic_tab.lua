local M = {}

-- Whether to switch between buffers or tabs
function M.tab_mode()
    return vim.fn.tabpagenr("$") > 1
end

function M.tab()
    vim.cmd(M.tab_mode() and "tabn" or "bnext")
end

function M.shift_tab()
    vim.cmd(M.tab_mode() and "tabp" or "bprevious")
end

return M
