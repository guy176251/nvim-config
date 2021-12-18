-- Determines if harpoon_bnext and harpoon_bprevious
-- should switch between buffers or harpoon marks
-- `true` - harpoon
-- `false` - buffers
local function harpoon_tab_switch()
    return require("harpoon.mark").get_length() > 1
end

local bug =
    [[

Weird bug:

When at home directory, `Marked.get_current_index()` returns `nil` on files.
Caused by differences in the outputs of `Marked.get_marked_file_name()`
and `require("harpoon.utils").normalize_path()`.

Example:
    marked:
    ./code/py/old/test.py

    utils:
    code/py/old/test.py

]]

local harpoon_cycle_marked_file = function(up)
    local step = up and 1 or -1

    local Marked = require("harpoon.mark")
    local current_index = Marked.get_current_index()
    local number_of_items = Marked.get_length()

    current_index = current_index + step
    current_index = current_index % number_of_items

    require("harpoon.ui").nav_file(current_index)
end

-- Dynamically switches between bnext and harpoon.ui.nav_next
function _G.harpoon_bnext()
    if harpoon_tab_switch() then
        --require("harpoon.ui").nav_next()
        -- for some reason, next and prev have opposite directions
        require("harpoon.ui").nav_prev()
        --harpoon_cycle_marked_file(true)
        print("Harpoon nav_next")
    else
        vim.api.nvim_command("bnext")
        print("bnext")
    end
end

-- Dynamically switches between bprevious and harpoon.ui.nav_prev
function _G.harpoon_bprevious()
    if harpoon_tab_switch() then
        --require("harpoon.ui").nav_prev()
        -- for some reason, next and prev have opposite directions
        require("harpoon.ui").nav_next()
        --harpoon_cycle_marked_file(false)
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
    vim.api.nvim_command("bw")
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
local get_harpoon_marked = function()
    local Marked = require("harpoon.mark")
    local contents = {}

    for idx = 1, Marked.get_length() do
        local file = Marked.get_marked_file_name(idx)
        if file == "" then
            file = "(empty)"
        end
        contents[idx] = string.format("%s", file)
    end

    return contents
end

local fzf_opts = function()
    return {
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.6)
    }
end

local sleep = function(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
    end
end

-- Marks buffers for harpoon
function _G.fzf_buffer_add_to_harpoon()
    -- Returns list of buffer file paths.
    -- Does not include buffers without a file path.
    local get_buffer_paths = function()
        local buffers = {}
        for b = 1, vim.fn.bufnr "$" do
            if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, "buftype") == "" then
                local buf_path = vim.fn.expand("#" .. b)
                if buf_path ~= "" then
                    buffers[#buffers + 1] = buf_path
                end
            end
        end

        return buffers
    end

    local add_to_harpoon = function()
        local fzf = require("fzf").fzf
        local action = require "fzf.actions".action

        local buf_paths = get_buffer_paths()

        -- items is a table of selected or hovered fzf items
        local shell =
            action(
            function(items, fzf_lines, fzf_cols)
                -- get last item
                local buf = vim.fn.bufnr(items[#items])

                -- you can return either a string or a table to show in the preview
                -- window
                return vim.api.nvim_buf_get_lines(buf, 0, fzf_lines, false)
            end
        )

        --''\''nvim'\'' --headless --clean --cmd '\''luafile /home/guy/.local/share/nvim/site/pack/packer/start/nvim-fzf/action_helper.lua'\'' '\''/tmp/nvimDUg2xo/3'\'' 7 {+}'
        --
        local results = fzf(buf_paths, " --multi ", fzf_opts())
        if results then
            local Marked = require("harpoon.mark")
            Marked.set_mark_list(results)
        --for _, p in ipairs(results) do
        --    Marked.toggle_file(p)
        --    --sleep(0.5)
        --end
        end
    end

    --coroutine.wrap(add_to_harpoon)()
    require("fzf-commands").files({fzf = add_to_harpoon})
end

--local testing = function ()
--    coroutine.wrap(function ()
--        local fzf = require("fzf").fzf
--        fzf({}, '', {  })
--    end)()
--end

-- width: 139
-- margin width: 14
-- 90% width
-- height: 35
-- margin height: 14
-- 60% height
