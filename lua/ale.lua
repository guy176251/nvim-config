local g = vim.g

-- neds to be before plugin startup
g.ale_completion_enabled = false
g.ale_linters_explicit = true

g.ale_fix_on_save = false
g.ale_fixers = {
    --c = {"clang-format"},
    cpp = {"clang-format"},
    sh = {"shfmt"},
    python = {"isort", "black"},
    lua = {"luafmt"},
    json = {"prettier"},
    css = {"prettier"},
    scss = {"prettier"},
    html = {"prettier"},
    javascript = {"prettier"},
    typescript = {"prettier"},
    javascriptreact = {"prettier"},
    typescriptreact = {"prettier"}
}

g.ale_linters = {
    sh = {"bashate"}
    --python = {"flake8"},
    --cpp = {"g++"},
    --html = {"tidy"},
    --css = {"stylelint"}
}

g.ale_lint_on_text_changed = "normal"
--g.ale_lint_on_text_changed = "never"
g.ale_lint_on_enter = true
g.ale_lint_on_insert_leave = true
g.ale_lint_on_filetype_changed = false
g.ale_lint_on_save = false

--local flake8_ignore_args = "--ignore=E501,E265,E402,E262,E261,E241,E266"
--g.ale_python_flake8_options = flake8_ignore_args
--g.ale_python_autopep8_options = flake8_ignore_args
--g.ale_lua_luafmt_options = ""
--g.ale_javascript_prettier_options = "--print-width 120 --tab-width 4"
g.ale_c_clangformat_options = '-style="{IndentWidth: 4,TabWidth: 4}"'
g.ale_sh_bashate_options = "-i E006,E042,E003"
--g.ale_sh_shfmt_options = "-kp -s"
