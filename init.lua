require("base")

if not vim.g.vscode then
    require("specifics")
    require("plugins")
    require("buffer_tools").init()
end
