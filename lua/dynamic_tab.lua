local M = {}

-- Whether to switch between buffers or tabs
local function tab_mode()
    return vim.fn.tabpagenr("$") > 1
end

-- Whether to show windows or buffers in lualine
local function window_mode()
    return vim.fn.winnr("$") > 1 or tab_mode()
end

M.tab_mode = tab_mode
M.window_mode = window_mode

function M.tab()
    vim.cmd(tab_mode() and "tabn" or "bnext")
end

function M.shift_tab()
    vim.cmd(tab_mode() and "tabp" or "bprevious")
end

return M
