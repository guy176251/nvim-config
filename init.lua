require("base")

if (not vim.g.vscode) and os.getenv("NO_PLUGINS") == nil then
	require("specifics")
	require("plugins")
	require("buffer_tools").init()
end
