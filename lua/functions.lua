local bug =
    [[

Weird bug:

When at home directory or in a dot directory, `Marked.get_current_index()` returns `nil` on files.
Caused by differences in the outputs of `Marked.get_marked_file_name()`
and `require("harpoon.utils").normalize_path()`.

Example:
    marked:
    ./code/py/old/test.py

    utils:
    code/py/old/test.py

]]

-- true: harpoon
-- false: regular buffer
vim.g.my_harpoon_tab_switch = false

-- Determines if harpoon_bnext and harpoon_bprevious
-- should switch between buffers or harpoon marks
-- `true` - harpoon
-- `false` - buffers
local function harpoon_tab_switch()
    --return require("harpoon.mark").get_length() > 0
    return vim.g.my_harpoon_tab_switch
end

-- Checks if a table contains a value.
local function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local strip_dot_slash = function(str)
    local first_two = string.sub(str, 1, 2)
    if first_two == "./" then
        str = string.sub(str, 3)
    end
    return str
end

local fzf_run_with_opts = function(args)
    local opts = require("fzf").default_options

    opts.width = math.floor(vim.o.columns * 0.9)
    opts.height = math.floor(vim.o.lines * 0.6)

    local old_cli_args = opts.fzf_cli_args
    if args.multi then
        opts.fzf_cli_args = opts.fzf_cli_args .. " --multi "
    end

    local results = args.fn()

    opts.fzf_cli_args = old_cli_args

    return results
end

-- Does a fzf function call with the default options set.
-- idk if there's a better way to do this
local fzf_call = function(args)
    local fn = function()
        local fzf = require("fzf").fzf
        if args.flags then
            return fzf(args.items, args.flags)
        elseif args.items then
            return fzf(args.items)
        else
            return fzf()
        end
    end

    local results = fzf_run_with_opts({fn = fn, multi = args.multi})
    local stripped_results = {}
    for _, filepath in ipairs(results) do
        stripped_results[#stripped_results + 1] = strip_dot_slash(filepath)
    end
    return stripped_results
end
--coroutine.wrap(fzf_call)()

-- Returns list of buffer file paths.
-- Does not include buffers without a file path.
local get_buffer_paths = function()
    local buffers = {}
    for b = 1, vim.fn.bufnr "$" do
        if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, "buftype") == "" then
            local buf_path = vim.fn.expand("#" .. b)
            if buf_path ~= "" then
                buffers[#buffers + 1] = strip_dot_slash(buf_path)
            --print(buf_path)
            end
        end
    end

    return buffers
end

-- toggles tab mode
function _G.harpoon_btoggle(on)
    if on == nil then
        vim.g.my_harpoon_tab_switch = require("harpoon.mark").get_length() > 0 and not vim.g.my_harpoon_tab_switch
    else
        vim.g.my_harpoon_tab_switch = on and require("harpoon.mark").get_length() > 0
    end
    print(vim.g.my_harpoon_tab_switch and "Tab: Harpoon" or "Tab: Buffer")
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
    require("harpoon.mark").add_file()
    vim.api.nvim_command("redrawtabline")
    vim.api.nvim_command("redrawstatus")
end

function _G.harpoon_clear_all()
    require("harpoon.mark").clear_all()
    _G.harpoon_btoggle()
    vim.api.nvim_command("redrawtabline")
    vim.api.nvim_command("redrawstatus")
end

-- I want my bclose bindings to also remove harpoon marks
function _G.harpoon_rm_file()
    require("harpoon.mark").rm_file()
    vim.api.nvim_command("Bclose")
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

-- Marks buffers for harpoon
local buffer_to_harpoon = function()
    local buf_paths = get_buffer_paths()
    local results = fzf_call({items = buf_paths, multi = true})

    if results then
        local sorted_results = {}
        -- original buf_paths table is correctly ordered, easier to take from there
        -- and just check if each item is in results.
        for _, filepath in ipairs(buf_paths) do
            if has_value(results, filepath) then
                sorted_results[#sorted_results + 1] = filepath
            end
        end
        local Marked = require("harpoon.mark")
        Marked.set_mark_list(sorted_results)
        _G.harpoon_btoggle(true)
    end
end

function _G.fzf_buffer_add_to_harpoon()
    coroutine.wrap(buffer_to_harpoon)()
end

-- Opens files from fzf, then marks them with harpoon.
local files_to_harpoon = function()
    local results = fzf_call({multi = true})

    if results then
        -- opens all results into buffer
        local cmd = ":n "
        for _, filepath in ipairs(results) do
            cmd = cmd .. filepath .. " "
        end
        vim.cmd(cmd)

        local buf_paths = get_buffer_paths()
        local sorted_results = {}
        for _, filepath in ipairs(buf_paths) do
            print(filepath)
            if has_value(results, filepath) then
                sorted_results[#sorted_results + 1] = filepath
            end
        end
        local Marked = require("harpoon.mark")
        Marked.set_mark_list(sorted_results)
        _G.harpoon_btoggle(true)
    end
end

function _G.fzf_files_to_harpoon()
    coroutine.wrap(files_to_harpoon)()
end

local get_marked_file_names = function()
    local Marked = require("harpoon.mark")
    local filepaths = {}
    for i = 1, Marked.get_length() do
        filepaths[#filepaths + 1] = Marked.get_marked_file_name(i)
    end
    return filepaths
end

local select_harpoon_mark = function()
    local results = fzf_call({items = get_marked_file_names()})

    if results then
        vim.api.nvim_win_set_buf(0, vim.fn.bufnr(results[1]))
    end
end

function _G.fzf_select_harpoon_mark()
    coroutine.wrap(select_harpoon_mark)()
end

_G.harpoon_open_marks = function()
    local filepaths = get_marked_file_names()
    if #filepaths ~= 0 then
        local cmd = ":n "

        for _, filepath in ipairs(filepaths) do
            cmd = cmd .. filepath .. " "
        end
        vim.cmd(cmd)
    end
end
