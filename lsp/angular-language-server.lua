-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.

local root_dir = vim.fn.getcwd()
local node_modules_dir = vim.fs.find("node_modules", { path = root_dir })[1]
local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or "?"
local default_probe_dir = project_root and (project_root .. "/node_modules") or ""

local ngserver_exe = vim.fn.exepath("ngserver")
local ngserver_path = #(ngserver_exe or "") > 0 and vim.fs.dirname(vim.uv.fs_realpath(ngserver_exe)) or "?"
local extension_path = vim.fs.normalize(vim.fs.joinpath(ngserver_path, "../../../"))

-- angularls will get module by `require.resolve(PROBE_PATH, MODULE_NAME)` of nodejs
local ts_probe_dirs = vim.iter({ extension_path, default_probe_dir }):join(",")
local ng_probe_dirs = vim.iter({ extension_path, default_probe_dir })
	:map(function(p)
		return vim.fs.joinpath(p, "/@angular/language-server/node_modules")
	end)
	:join(",")

local function get_angular_core_version()
	if not project_root then
		return ""
	end

	local package_json = project_root .. "/package.json"
	if not vim.uv.fs_stat(package_json) then
		return ""
	end

	local contents = io.open(package_json):read("*a")
	local json = vim.json.decode(contents)
	if not json.dependencies then
		return ""
	end

	local angular_core_version = json.dependencies["@angular/core"]

	angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

	return angular_core_version
end

local cmd = {
	"ngserver",
	"--stdio",
	"--tsProbeLocations",
	ts_probe_dirs,
	"--ngProbeLocations",
	ng_probe_dirs,
}

local angular_version = get_angular_core_version()
if string.len(angular_version) > 0 then
	table.insert(cmd, "--angularCoreVersion")
	table.insert(cmd, angular_version)
end

--vim.lsp.log.error("==================================================")
--vim.lsp.log.error("ngserver_path", ngserver_path)
--vim.lsp.log.error("extension_path", extension_path)
--vim.lsp.log.error("ts_probe_dirs", ts_probe_dirs)
--vim.lsp.log.error("ng_probe_dirs", ng_probe_dirs)
--vim.lsp.log.error("cmd", vim.iter(cmd):join(" "))
--vim.lsp.log.error("==================================================")

return {
	cmd = cmd,
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
	root_markers = { "angular.json", "nx.json" },
}
