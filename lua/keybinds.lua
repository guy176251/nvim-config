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
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")
--map("n", "<Tab>", ":lua harpoon_bnext()<CR>")
--map("n", "<S-Tab>", ":lua harpoon_bprevious()<CR>")
map("n", "<Esc>", ":noh<CR><Esc>", { silent = true }) --After searching, pressing escape stops the highlight

map("n", "<Leader>w", [[:%s/\s\+$//e<CR>]])
--map("n", "<Leader>x", ":Bclose <CR>")
map("n", "<Leader>x", ":bp|bd #<CR>")
map("n", "<Leader>t", ":tabnew<CR>")

-- Move split
map("n", "<A-Right>", "<C-W><S-L>")
map("n", "<A-Left>", "<C-W><S-H>")
map("n", "<A-Up>", "<C-W><S-K>")
map("n", "<A-Down>", "<C-W><S-J>")

-- Split navigations
map("n", "<C-Right>", "<C-W><C-L>")
map("n", "<C-Left>", "<C-W><C-H>")
map("n", "<C-Up>", "<C-W><C-K>")
map("n", "<C-Down>", "<C-W><C-J>")

-- Resize split
map("n", "-", "<C-W>-")
map("n", "+", "<C-W>+")
map("n", "(", "<C-W><")
map("n", ")", "<C-W>>")

-- Scroll viewport
map("n", "<S-Up>", "<C-Y>")
map("n", "<S-Down>", "<C-E>")
map("v", "<S-Up>", "<C-Y>")
map("v", "<S-Down>", "<C-E>")
map("i", "<S-Up>", "<C-X><C-Y>")
map("i", "<S-Down>", "<C-X><C-E>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- Terminal binds
local term_command = "split | set norelativenumber | set nonumber | term"
map("t", "<C-Space>", [[<C-\><C-n>]])
map("n", [[<Leader>\]], ":" .. term_command .. "<CR>")
map("n", [[<Leader>|]], ":v" .. term_command .. "<CR>")

---------
-- HOP --
---------
local hop_opts = "{ create_hl_autocmd = true }"
local hopword = [[<cmd>lua require'hop'.hint_words(]] .. hop_opts .. [[)<cr>]]
local hopline = [[<cmd>lua require'hop'.hint_lines_skip_whitespace(]] .. hop_opts .. [[)<cr>]]

map("n", "W", hopline, { silent = true })
map("v", "W", hopline, { silent = true })
map("n", "w", hopword, { silent = true })
map("v", "w", hopword, { silent = true })

---------
-- FZF --
---------
map("n", "<Leader>o", ":Files<CR>")
map("n", "<Leader>O", ":Files ~/<CR>")
map("n", "<Leader>p", ":Buffers<CR>")
map("n", "<Leader>h", ":Helptags<CR>")
map("n", "<Leader>;", ":History:<CR>")
map("n", "<Leader>c", ":Commands<CR>")
map("n", "<Leader>r", ":Rg <C-R><C-W><CR>")
map("n", "<Leader>R", ":Rg<CR>")
map("n", "<Leader>s", ":Lines<CR>")

map("n", "<Leader>gf", ":GFiles<CR>")
map("n", "<Leader>gn", ":GFiles?<CR>")
map("n", "<Leader>gc", ":Commits<CR>")

------------------
-- FZF-CHECKOUT --
------------------
map("n", "<Leader>gb", ":GBranches<CR>")

-------------
-- HARPOON --
-------------

--map("n", "<Leader>m", [[:lua require("harpoon.mark").add_file() <CR>]])
--map("n", "<Leader>x", ":lua harpoon_rm_file()<CR>")
--map("n", "<Leader>ma", [[:lua harpoon_toggle_file()<CR>]])
--map("n", "<Leader>mc", [[:lua harpoon_clear_all()<CR>]])
--map("n", "<Leader>ml", [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]])
--map("n", "<Leader>mt", [[:lua harpoon_btoggle()<CR>]])

--map("n", "<Leader>n", [[:lua require("harpoon.ui").nav_next() <CR>]])
--map("n", "<Leader>N", [[:lua require("harpoon.ui").nav_prev() <CR>]])

--------------
-- NVIM FZF --
--------------
--map("n", "<Leader>mm", [[:lua fzf_buffer_add_to_harpoon()<CR>]])
--map("n", "<Leader>mo", [[:lua fzf_files_to_harpoon()<CR>]])
--map("n", "<Leader>ml", [[:lua fzf_select_harpoon_mark()<CR>]])

-- RNVIMR
-- https://github.com/kevinhwang91/rnvimr
map("n", "<Leader>f", [[:RnvimrToggle<CR>]])
