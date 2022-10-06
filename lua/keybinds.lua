-- these are my custom functions
require("functions")

--local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ","

map("v", "<C-C>", '"+y')
--map("n", "<Tab>", ":bnext<CR>")
--map("n", "<S-Tab>", ":bprevious<CR>")
map("n", "<Tab>", ":lua harpoon_bnext()<CR>")
map("n", "<S-Tab>", ":lua harpoon_bprevious()<CR>")
--map("n", "<esc>", ":noh<cr><esc>", { silent = true }) --After searching, pressing escape stops the highlight

--map("n", "<Leader>w", [[:%s/\s\+$//e<CR>]])
--map("n", "<Leader>x", ":Bclose <CR>")
map("n", "<Leader>t", ":tabnew<CR>")

-- Move split
map("n", "<A-Right>", "<C-W><S-L>")
map("n", "<A-Left>", "<C-W><S-H>")
map("n", "<A-Up>", "<C-W><S-K>")
map("n", "<A-Down>", "<C-W><S-J>")

--map("n", "<A-l>", "<C-W><S-L>")
--map("n", "<A-h>", "<C-W><S-H>")
--map("n", "<A-k>", "<C-W><S-K>")
--map("n", "<A-j>", "<C-W><S-J>")

-- Split navigations
map("n", "<C-Right>", "<C-W><C-L>")
map("n", "<C-Left>", "<C-W><C-H>")
map("n", "<C-Up>", "<C-W><C-K>")
map("n", "<C-Down>", "<C-W><C-J>")

--map("n", "<C-l>", "<C-W><C-L>")
--map("n", "<C-h>", "<C-W><C-H>")
--map("n", "<C-k>", "<C-W><C-K>")
--map("n", "<C-j>", "<C-W><C-J>")

-- Resize split
--map("n", "-", "<C-W>-")
--map("n", "+", "<C-W>+")
--map("n", "(", "<C-W><")
--map("n", ")", "<C-W>>")

-- Scroll viewport
map("n", "<S-Up>", "<C-Y>")
map("n", "<S-Down>", "<C-E>")
map("v", "<S-Up>", "<C-Y>")
map("v", "<S-Down>", "<C-E>")
map("i", "<S-Up>", "<C-X><C-Y>")
map("i", "<S-Down>", "<C-X><C-E>")
--map("n", "<PageUp>", "<C-Y>")
--map("n", "<PageDown>", "<C-E>")
--map("v", "<PageUp>", "<C-Y>")
--map("v", "<PageDown>", "<C-E>")
--map("i", "<PageUp>", "<C-X><C-Y>")
--map("i", "<PageDown>", "<C-X><C-E>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- map Enter to switch tabs
--map("n", "<Enter>", ":tabnext<CR>")
--map("n", "<Backspace>", ":tabprevious<CR>")

-- Terminal binds
map("t", "<Esc>", [[<C-\><C-n>]])
map("n", [[<Leader>\]], ':split | term<CR>')
map("n", [[<Leader>|]], ':vsplit | term<CR>')

---------
-- HOP --
---------
local hop_opts = "{ create_hl_autocmd = true }"
local hopword = [[<cmd>lua require'hop'.hint_words(]] .. hop_opts .. [[)<cr>]]
local hopline = [[<cmd>lua require'hop'.hint_lines_skip_whitespace(]] .. hop_opts .. [[)<cr>]]

--map("n", "<m-l>", hopline, {silent = true})
--map("v", "<m-l>", hopline, {silent = true})
--map("n", "<m-w>", hopword, {silent = true})
--map("v", "<m-w>", hopword, {silent = true})

map("n", "W", hopline, { silent = true })
map("v", "W", hopline, { silent = true })
map("n", "w", hopword, { silent = true })
map("v", "w", hopword, { silent = true })

-- args: direction: bool, inclusive: bool
-- inclusive is broken in hop as of this comment
--local hop_hint_char1 = function(args)
--    local direction = args.forward and "AFTER_CURSOR" or "BEFORE_CURSOR"
--    local inclusive = args.inclusive and "true" or "false"
--
--    return ("<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection." ..
--        direction .. ", current_line_only = true, inclusive_jump = " .. inclusive .. " })<cr>")
--end
--
--vim.api.nvim_set_keymap("", "f", hop_hint_char1({forward = true, inclusive = false}), {})
--vim.api.nvim_set_keymap("", "F", hop_hint_char1({forward = false, inclusive = false}), {})
--vim.api.nvim_set_keymap("", "t", hop_hint_char1({forward = true, inclusive = false}), {})
--vim.api.nvim_set_keymap("", "T", hop_hint_char1({forward = false, inclusive = false}), {})

-- place this in one of your configuration file(s)
--vim.api.nvim_set_keymap(
--    "n",
--    "f",
--    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
--    {}
--)
--vim.api.nvim_set_keymap(
--    "n",
--    "F",
--    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
--    {}
--)
--vim.api.nvim_set_keymap(
--    "",
--    "f",
--    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
--    {}
--)
--vim.api.nvim_set_keymap(
--    "",
--    "F",
--    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
--    {}
--)
--vim.api.nvim_set_keymap(
--    "",
--    "t",
--    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
--    {}
--)
--vim.api.nvim_set_keymap(
--    "",
--    "T",
--    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
--    {}
--)

---------
-- FZF --
---------
map("n", "<Leader>o", ":Files<CR>")
--map("n", "<Leader>O", [[:lua vim.fn['fzf#vim#files']('~/')<CR>]])
map("n", "<Leader>O", ":Files ~/<CR>")
map("n", "<Leader>p", ":Buffers<CR>")
map("n", "<Leader>h", ":Helptags<CR>")
map("n", "<Leader>;", ":History:<CR>")
map("n", "<Leader>c", ":Commands<CR>")
map("n", "<Leader>r", ":Rg <C-R><C-W><CR>")
map("n", "<Leader>R", ":Rg<CR>")
map("n", "<Leader>s", ":Lines<CR>")
--map("n", "<Leader>[", ":Windows <CR>")

map("n", "<Leader>gf", ":GFiles<CR>")
map("n", "<Leader>gn", ":GFiles?<CR>")
map("n", "<Leader>gc", ":Commits<CR>")

------------------
-- FZF-CHECKOUT --
------------------
map("n", "<Leader>gb", ":GBranches<CR>")

---------
-- ALE --
---------
--map("n", "<c-k>", ":ALEPreviousWrap <CR>", {silent = true})
--map("n", "<c-j>", ":ALENextWrap <CR>", {silent = true})
--map("n", "<space>f", ":ALEFix<CR>", {silent = true})

-------------
-- HARPOON --
-------------

--map("n", "<Leader>m", [[:lua require("harpoon.mark").add_file() <CR>]])
map("n", "<Leader>x", ":lua harpoon_rm_file()<CR>")
map("n", "<Leader>ma", [[:lua harpoon_toggle_file()<CR>]])
map("n", "<Leader>mc", [[:lua harpoon_clear_all()<CR>]])
map("n", "<Leader>ml", [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]])
map("n", "<Leader>mt", [[:lua harpoon_btoggle()<CR>]])

--map("n", "<Leader>n", [[:lua require("harpoon.ui").nav_next() <CR>]])
--map("n", "<Leader>N", [[:lua require("harpoon.ui").nav_prev() <CR>]])

-----------
-- CODEX --
-----------
--local create_completion = ":lua vim.fn.CreateCompletion(200)<CR>"
--local create_completion = ":lua vim.fn.CreateCompletionLine()<CR>"
--map("n", "<C-x>", create_completion)
--map("i", "<C-x>", ("<C-o>" .. create_completion))
--map("i", "<C-x>", "<Esc>li<C-g>u<Esc>l:CreateCompletion<CR>")

--------------
-- NVIM FZF --
--------------
map("n", "<Leader>mm", [[:lua fzf_buffer_add_to_harpoon()<CR>]])
map("n", "<Leader>mo", [[:lua fzf_files_to_harpoon()<CR>]])
map("n", "<Leader>ml", [[:lua fzf_select_harpoon_mark()<CR>]])

-- RNVIMR
-- https://github.com/kevinhwang91/rnvimr
map("n", "<Leader>f", [[:RnvimrToggle<CR>]])
