local M = {}

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS
local FORMATTING = methods.internal.FORMATTING

M.diagnostics = {
	ruff = function()
		local custom_end_col = {
			end_col = function(entries, line)
				if not line then
					return
				end

				local start_col = entries["col"]
				local message = entries["message"]
				local code = entries["code"]
				local default_position = start_col + 1

				local pattern = nil
				local trimmed_line = line:sub(start_col, -1)

				if code == "F841" or code == "F823" then
					pattern = [[Local variable %`(.*)%`]]
				elseif code == "F821" or code == "F822" then
					pattern = [[Undefined name %`(.*)%`]]
				elseif code == "F401" then
					pattern = [[%`(.*)%` imported but unused]]
				elseif code == "F841" then
					pattern = [[Local variable %`(.*)%` is assigned to but never used]]
				end
				if not pattern then
					return default_position
				end

				local results = message:match(pattern)
				local _, end_col = trimmed_line:find(results, 1, true)

				if not end_col then
					return default_position
				end

				end_col = end_col + start_col
				if end_col > tonumber(start_col) then
					return end_col
				end

				return default_position
			end,
		}

		return h.make_builtin({
			name = "ruff",
			meta = {
				url = "https://github.com/charliermarsh/ruff/",
				description = "An extremely fast Python linter, written in Rust.",
			},
			method = DIAGNOSTICS,
			filetypes = { "python" },
			generator_opts = {
				command = "ruff",
				args = { "check", "-n", "-e", "--stdin-filename", "$FILENAME", "-" },
				format = "line",
				check_exit_code = function(code)
					return code == 0
				end,
				to_stdin = true,
				ignore_stderr = true,
				on_output = h.diagnostics.from_pattern(
					[[(%d+):(%d+): ((%u)%w+) (.*)]],
					{ "row", "col", "code", "severity", "message" },
					{
						adapters = {
							custom_end_col,
						},
						severities = {
							E = h.diagnostics.severities["error"], -- pycodestyle errors
							W = h.diagnostics.severities["warning"], -- pycodestyle warnings
							F = h.diagnostics.severities["information"], -- pyflakes
							A = h.diagnostics.severities["information"], -- flake8-builtins
							B = h.diagnostics.severities["warning"], -- flake8-bugbear
							C = h.diagnostics.severities["warning"], -- flake8-comprehensions
							T = h.diagnostics.severities["information"], -- flake8-print
							U = h.diagnostics.severities["information"], -- pyupgrade
							D = h.diagnostics.severities["information"], -- pydocstyle
							M = h.diagnostics.severities["information"], -- Meta
						},
					}
				),
			},
			factory = h.generator_factory,
		})
	end,

	shellcheck = function()
		return h.make_builtin({
			name = "shellcheck",
			meta = {
				url = "https://www.shellcheck.net/",
				description = "A shell script static analysis tool.",
			},
			method = DIAGNOSTICS,
			filetypes = { "sh" },
			generator_opts = {
				command = "shellcheck",
				args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
				to_stdin = true,
				format = "json",
				check_exit_code = function(code)
					return code <= 1
				end,
				on_output = function(params)
					local parser = h.diagnostics.from_json({
						attributes = { code = "code" },
						severities = {
							info = h.diagnostics.severities["information"],
							style = h.diagnostics.severities["hint"],
						},
					})

					return parser({ output = params.output.comments })
				end,
			},
			factory = h.generator_factory,
		})
	end,
}

M.formatters = {
	templ = function()
		return h.make_builtin({
			name = "templ",
			method = FORMATTING,
			filetypes = { "templ" },
			generator_opts = {
				command = "templ",
				args = { "fmt" },
				to_stdin = true,
			},
			factory = h.formatter_factory,
		})
	end,
	ruff_code = function()
		return h.make_builtin({
			name = "ruff",
			method = FORMATTING,
			filetypes = { "python" },
			generator_opts = {
				command = "ruff",
				args = { "format", "--stdin-filename", "$FILENAME", "-" },
				to_stdin = true,
			},
			factory = h.formatter_factory,
		})
	end,
	ruff_imports = function()
		return h.make_builtin({
			name = "ruff",
			method = FORMATTING,
			filetypes = { "python" },
			generator_opts = {
				command = "ruff",
				args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
				to_stdin = true,
			},
			factory = h.formatter_factory,
		})
	end,
}

return M
