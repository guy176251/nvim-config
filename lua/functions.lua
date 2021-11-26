-- Determines if harpoon_bnext and harpoon_bprevious
-- should switch between buffers or harpoon marks
-- `true` - harpoon
-- `false` - buffers
local function harpoon_tab_switch()
    return require("harpoon.mark").get_length() > 1
end

-- Dynamically switches between bnext and harpoon.ui.nav_next
function _G.harpoon_bnext()
    if harpoon_tab_switch() then
        require("harpoon.ui").nav_next()
        print("Harpoon nav_next")
    else
        vim.api.nvim_command("bnext")
        print("bnext")
    end
end

-- Dynamically switches between bprevious and harpoon.ui.nav_prev
function _G.harpoon_bprevious()
    if harpoon_tab_switch() then
        require("harpoon.ui").nav_prev()
        print("Harpoon nav_prev")
    else
        vim.api.nvim_command("bprevious")
        print("bprevious")
    end
end

-- Runs harpoon.mark.toggle_file and refreshes lualine elements
function _G.harpoon_toggle_file()
    require("harpoon.mark").toggle_file()
    vim.api.nvim_command("redrawtabline")
    vim.api.nvim_command("redrawstatus")
end

function _G.harpoon_clear_all()
    require("harpoon.mark").clear_all()
    vim.api.nvim_command("redrawtabline")
    vim.api.nvim_command("redrawstatus")
end

-- I want my bclose bindings to also remove harpoon marks
function _G.harpoon_rm_file()
    require("harpoon.mark").rm_file()
    vim.api.nvim_command("bd")
end

-- Lualine status element for harpoon
function _G.harpoon_status()
    local marked_files = require("harpoon.mark").get_length()
    local status_str = "Harpoon: %d file"
    if marked_files > 1 then
        status_str = status_str .. "s"
    end
    status_str = (harpoon_tab_switch() and "● " or "") .. status_str
    return string.format(status_str, marked_files)
end
--[[string.format("Harpoon: %d files", require("harpoon.mark").get_length())]]
