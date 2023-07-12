local map = require("helpers").map

local function silent_map(mode, lhs, rhs)
    map(mode, lhs, rhs, { silent = true })
end

silent_map("n", "<Up>", "gk")
silent_map("n", "<Down>", "gj")
silent_map("n", "<Home>", "g<Home>")
silent_map("n", "<End>", "g<End>")

silent_map("v", "<Up>", "gk")
silent_map("v", "<Down>", "gj")
silent_map("v", "<Home>", "g<Home>")
silent_map("v", "<End>", "g<End>")

silent_map("i", "<Up>", "<C-o>gk")
silent_map("i", "<Down>", "<C-o>gj")
silent_map("i", "<Home>", "<C-o>g<Home>")
silent_map("i", "<End>", "<C-o>g<End>")
