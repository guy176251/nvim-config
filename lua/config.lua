-- env file highlighting
vim.cmd [[au BufRead,BufNewFile .env.* set filetype=sh]]

local opt = vim.opt -- to set options
local fn = vim.fn
local g = vim.g

opt.autoindent = true
opt.autoread = true
--opt.autowrite = true
opt.expandtab = true
opt.foldenable = false
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

----------------
-- BCLOSE.VIM --
----------------
g.bclose_no_plugin_maps = true

----------------
-- BRACEY.VIM --
----------------
-- https://github.com/turbio/bracey.vim
--g.bracey_refresh_on_save = true

-----------------------
-- TREESITTER CONFIG --
-----------------------
require("nvim-treesitter.configs").setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {"typescript", "tsx", "html"}
    }
}

-------------
-- LUALINE --
-------------

require("lualine").setup {
    options = {theme = "onedark", icons_enabled = true},
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            "branch"
        },
        lualine_c = {"filename"},
        lualine_x = {
            "encoding",
            "fileformat",
            "filetype",
            [[string.format("%d Lines", vim.fn.line('$'))]],
            {
                "diagnostics",
                sources = {"nvim_lsp", "ale"}
            }
        },
        lualine_y = {
            "progress"
        },
        lualine_z = {"location"}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                show_filename_only = false, -- shows shortened relative path when false
                show_modified_status = true, -- shows indicator then bufder is modified
                max_length = vim.o.columns * 1, -- maximum width of buffers component
                filetype_names = {
                    TelescopePrompt = "Telescope",
                    dashboard = "Dashboard",
                    packer = "Packer",
                    fzf = "FZF",
                    alpha = "Alpha",
                    ["lsp-installer"] = "LSP Installer"
                }, -- shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                buffers_color = {
                    active = nil, -- color for active buffer
                    inactive = nil -- color for inactive buffer
                }
            }
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
                end
            }
        }
    },
    extensions = {}
}
