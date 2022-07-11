-- env file highlighting
vim.cmd([[au BufRead,BufNewFile .env.* set filetype=sh]])
-- Dockerfile file highlighting
vim.cmd([[au BufRead,BufNewFile Dockerfile.* set filetype=dockerfile]])
vim.cmd([[au BufWrite * normal zx]])
-- jinja highlighting
vim.cmd([[au BufRead,BufNewFile *.jinja set filetype=html]])

local opt = vim.opt -- to set options
local fn = vim.fn
local g = vim.g

opt.autoindent = true
opt.autoread = true
--opt.autowrite = true
opt.expandtab = true
opt.hlsearch = true
opt.ignorecase = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.showcmd = true
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.title = true
opt.wildmenu = true
opt.termguicolors = true
opt.linebreak = true

opt.inccommand = "split" -- Get a preview of replacements
opt.incsearch = true -- Shows the match while typing

opt.undofile = true
--opt.undodir = "~/.local/share/nvim/undodir"

opt.encoding = "utf-8"
opt.fileformat = "unix"
opt.scrolloff = 4 -- Lines of context
opt.shiftwidth = 4
opt.tabstop = 4
opt.synmaxcol = 4000
opt.textwidth = 0
--opt.titlestring = "NVIM: %f"
opt.titlestring = [[NVIM: [%{fnamemodify(getcwd(), ':t')}] %t]]

opt.cursorline = true
opt.cursorcolumn = true

--opt.foldlevel = 1
opt.foldlevelstart = 10
--opt.foldenable = false
opt.foldmethod = "indent"
--opt.foldmethod = "syntax"
--opt.foldmethod = "expr"
--opt.foldexpr = "nvim_treesitter#foldexpr()"

-----------------------------------------------------
-- DISABLE HIGHLIGHT OUTSIDE OF SEARCH AND REPLACE --
-----------------------------------------------------
vim.cmd([[
" Enable highlighting all the matches in incsearch mode
" But don't enable hlsearch always
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter [/\?:] :set hlsearch
  autocmd CmdlineLeave [/\?:] :set nohlsearch
augroup END
]])

---------------
-- PROVIDERS --
---------------
local pyenv_root = vim.env.PYENV_ROOT
if pyenv_root ~= nil then
    g.python3_host_prog = pyenv_root .. "/shims/python3"
else
    g.python3_host_prog = "/usr/bin/python3"
end

------------------
-- ONEDARK.NVIM --
------------------
--g.onedark_style = "cool"
--g.onedark_style = "darker"
--g.onedark_toggle_style_keymap = "<nop>"
--g.onedark_darker_diagnostics = false

-- Lua
require("onedark").setup({
    style = "darker",
    toggle_style_key = "<nop>",
})
require("onedark").load()

----------------
-- BCLOSE.VIM --
----------------
g.bclose_no_plugin_maps = true

----------------
-- BRACEY.VIM --
----------------
-- https://github.com/turbio/bracey.vim
g.bracey_refresh_on_save = true

-----------------------
-- TREESITTER CONFIG --
-----------------------
local ts_visual_disable = { "typescript", "tsx", "html", "javascript" }
require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    highlight = {
        enable = true,
        disable = ts_visual_disable,
    },
    rainbow = {
        enable = true,
        disable = ts_visual_disable,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
})

-----------------------
-- GITHUB NVIM THEME --
-----------------------
--require("github-theme").setup(
--    {
--        theme_style = "dark_default",
--        hide_inactive_statusline = false
--    }
--)
g.github_hide_inactive_statusline = false

-------------
-- LUALINE --
-------------

require("lualine").setup({
    options = { theme = "onedark", icons_enabled = true },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            "FugitiveHead",
        },
        lualine_c = { "filename" },
        lualine_x = {
            "encoding",
            "fileformat",
            "filetype",
            [[string.format("%d Lines", vim.fn.line('$'))]],
            {
                "diagnostics",
                sources = { "nvim_diagnostic", "ale" },
            },
        },
        lualine_y = {
            "progress",
        },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                show_filename_only = false, -- shows shortened relative path when false
                show_modified_status = true, -- shows indicator then bufder is modified
                max_length = function()
                    return vim.o.columns * 5 / 6
                end, -- maximum width of buffers component
                filetype_names = {
                    TelescopePrompt = "Telescope",
                    dashboard = "Dashboard",
                    packer = "Packer",
                    fzf = "FZF",
                    alpha = "Alpha",
                    ["lsp-installer"] = "LSP Installer",
                }, -- shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                buffers_color = {
                    active = nil, -- color for active buffer
                    inactive = nil, -- color for inactive buffer
                },
            },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                [[string.format("Tab %d/%d", vim.fn.tabpagenr(), vim.fn.tabpagenr('$'))]],
                cond = function()
                    return fn.tabpagenr("$") > 1
                end,
            },
            {
                [[harpoon_status()]],
                cond = function()
                    return require("harpoon.mark").get_length() > 0
                end,
            },
        },
    },
    extensions = {},
})

-------------
-- HARPOON --
-------------

--Here is the set of global settings and their default values.

require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
    },
})

--------------
-- NVIM FZF --
--------------
require("fzf").default_options = {
    fzf_cli_args = " --height 100% --preview='bat --color=always --style=header,grid --line-range :300 {}' ",
}

----------------------
-- INDENT-BLANKLINE --
----------------------
--vim.opt.termguicolors = true
--vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]
--
--require("indent_blankline").setup {
--    char = "",
--    char_highlight_list = {
--        "IndentBlanklineIndent1",
--        "IndentBlanklineIndent2"
--    },
--    space_char_highlight_list = {
--        "IndentBlanklineIndent1",
--        "IndentBlanklineIndent2"
--    },
--    show_trailing_blankline_indent = false
--}

--vim.opt.list = true
--vim.opt.listchars:append("eol:↴")
--
--require("indent_blankline").setup {
--    show_end_of_line = true
--}
--vim.opt.listchars:append("eol:↴")
--vim.opt.listchars:append("space:⋅")
opt.list = true

require("indent_blankline").setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
})

-- PETOBENS/POET-V --
g.poetv_executables = { "poetry" }
g.poetv_auto_activate = 1
