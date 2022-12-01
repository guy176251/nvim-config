local M = {}

-- Grabbed from harpoon code
function M.get_marked_files()
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

return M
