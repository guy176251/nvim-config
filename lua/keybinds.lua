--local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ","

require("functions")

map("v", "<C-C>", '"+y')
--map("n", "<Tab>", ":bnext<CR>")
--map("n", "<S-Tab>", ":bprevious<CR>")
map("n", "<Tab>", ":lua harpoon_bnext()<CR>")
map("n", "<S-Tab>", ":lua harpoon_bprevious()<CR>")
map("n", "<esc>", ":noh<cr><esc>", {silent = true}) --After searching, pressing escape stops the highlight

map("n", "<Leader>w", [[:%s/\s\+$//e <CR>]])
--map("n", "<Leader>x", ":Bclose <CR>")
map("n", "<Leader>t", ":tabnew <CR>")

-- Split navigations
map("n", "<C-Right>", "<C-W><C-L>")
map("n", "<C-Left>", "<C-W><C-H>")
map("n", "<C-Up>", "<C-W><C-K>")
map("n", "<C-Down>", "<C-W><C-J>")

-- Resize split
map("n", "<M-j>", "<C-W>-")
map("n", "<M-k>", "<C-W>+")
map("n", "<M-h>", "<C-W><")
map("n", "<M-l>", "<C-W>>")

-- Scroll viewport
map("n", "<S-Up>", "<C-Y>")
map("n", "<S-Down>", "<C-E>")
map("v", "<S-Up>", "<C-Y>")
map("v", "<S-Down>", "<C-E>")
map("i", "<S-Up>", "<C-X><C-Y>")
map("i", "<S-Down>", "<C-X><C-E>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- map Enter to switch tabs
--map("n", "<Enter>", ":tabnext<CR>")
--map("n", "<Backspace>", ":tabprevious<CR>")

---------
-- HOP --
---------
local hopword = [[<cmd>lua require'hop'.hint_words()<cr>]]
local hopline = [[<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>]]
--map("n", "<m-l>", hopline, {silent = true})
--map("v", "<m-l>", hopline, {silent = true})
--map("n", "<m-w>", hopword, {silent = true})
--map("v", "<m-w>", hopword, {silent = true})
map("n", "W", hopline, {silent = true})
map("v", "W", hopline, {silent = true})
map("n", "w", hopword, {silent = true})
map("v", "w", hopword, {silent = true})

---------
-- FZF --
---------
map("n", "<Leader>o", ":Files <CR>")
map("n", "<Leader>O", [[:lua vim.fn['fzf#vim#files']('~/') <CR>]])
map("n", "<Leader>g", ":GFiles <CR>")
map("n", "<Leader>p", ":Buffers <CR>")
map("n", "<Leader>h", ":Helptags <CR>")
map("n", "<Leader>;", ":History: <CR>")
map("n", "<Leader>c", ":Commands <CR>")
map("n", "<Leader>s", ":Rg <CR>")
--map("n", "<Leader>[", ":Windows <CR>")

---------
-- ALE --
---------
--map("n", "<c-k>", ":ALEPreviousWrap <CR>", {silent = true})
--map("n", "<c-j>", ":ALENextWrap <CR>", {silent = true})

-------------
-- HARPOON --
-------------

--map("n", "<Leader>m", [[:lua require("harpoon.mark").add_file() <CR>]])
map("n", "<Leader>x", ":lua harpoon_rm_file()<CR>")
map("n", "<Leader>m", [[:lua harpoon_toggle_file()<CR>]])
map("n", "<Leader>M", [[:lua harpoon_clear_all()<CR>]])
map("n", "<Leader>l", [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]])

--map("n", "<Leader>n", [[:lua require("harpoon.ui").nav_next() <CR>]])
--map("n", "<Leader>N", [[:lua require("harpoon.ui").nav_prev() <CR>]])
