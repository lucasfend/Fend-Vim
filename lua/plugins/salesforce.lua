-- needed so neovim can figure that .cls files should trigger apex LSP
vim.filetype.add({
    extension = {
        cls = "apex",
        trigger = "apex",
    },
})

return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                apex = { "prettier" },
                javascript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {

                -- apex - backend
                apex_ls = {
                    apex_enable_semantic_errors = true,
                    apex_enable_completion_statistics = false,
                    filetypes = { "apex" },
                    cmd = {
                        "java",
                        "-cp",
                        vim.fn.expand(
                            "~/.local/share/nvim/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar"
                        ),
                        "apex.jorje.lsp.ApexLanguageServerLauncher",
                    },
                },

                lwc_ls = {},

                vtsls = {},

                cssls = {},

                eslint = {
                    settings = {
                        workingDirectory = { mode = "auto" },
                    },
                },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "apex", "soql", "sosl", "javascript", "html", "css" })
            end
        end,
    },

    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "apex-language-server",
                "lwc-language-server",
                "eslint-lsp",
                "css-lsp",
                "vtsls",
            })
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                apex = { "pmd" },
            }

            lint.linters.pmd = {
                cmd = "pmd",
                stdin = false,
                ignore_exitcode = true,
                args = {
                    "check",
                    "--no-progress",
                    "-R",
                    "category/apex/bestpractices.xml,category/apex/errorprone.xml,category/apex/performance.xml,category/apex/security.xml",
                    "-f",
                    "json",
                    "-d",
                    function()
                        return vim.fn.expand("%:p")
                    end,
                },
                parser = function(output, bufnr)
                    local start_idx = string.find(output, "{")
                    if not start_idx then
                        return {}
                    end

                    local clean_json = string.sub(output, start_idx)
                    local ok, parsed = pcall(vim.json.decode, clean_json)

                    if not ok or not parsed.files then
                        return {}
                    end

                    local diagnostics = {}
                    for _, file in ipairs(parsed.files) do
                        if file.violations then
                            for _, v in ipairs(file.violations) do
                                table.insert(diagnostics, {
                                    lnum = v.beginline - 1,
                                    col = v.begincolumn - 1,
                                    end_lnum = (v.endline or v.beginline) - 1,
                                    end_col = v.endcolumn or v.begincolumn,
                                    severity = vim.diagnostic.severity.WARN,
                                    source = "pmd",
                                    message = v.rule .. ": " .. vim.trim(v.description),
                                })
                            end
                        end
                    end
                    return diagnostics
                end,
            }

            vim.api.nvim_create_user_command("PmdOff", function()
                vim.b.pmd_disabled = true

                local ns = require("lint").get_namespace("pmd")
                vim.diagnostic.reset(ns, 0)

                vim.notify("PMD Off for current file", vim.log.levels.WARN)
            end, { desc = "Disable PMD linting for the current buffer" })

            vim.api.nvim_create_user_command("PmdOn", function()
                vim.b.pmd_disabled = false
                vim.notify("PMD On for current file", vim.log.levels.INFO)

                require("lint").try_lint()
            end, { desc = "Enable PMD linting for the current buffer" })

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                group = vim.api.nvim_create_augroup("ApexLinting", { clear = true }),
                pattern = { "*.cls", "*.trigger" },
                callback = function()
                    if vim.b.pmd_disabled then
                        return
                    end

                    local ruleset = vim.fn.findfile("pmd-ruleset.xml", ".;")

                    if ruleset == "" then
                        ruleset =
                            "category/apex/bestpractices.xml,category/apex/errorprone.xml,category/apex/performance.xml,category/apex/security.xml"
                    end

                    lint.linters.pmd.args = {
                        "check",
                        "--no-progress",
                        "-R",
                        ruleset,
                        "-f",
                        "json",
                        "-d",
                        vim.fn.expand("%:p"),
                    }

                    lint.try_lint()
                end,
            })
        end,
    },

    {
        "xixiaofinland/sf.nvim",
        ft = { "apex", "soql", "sosl", "javascript", "html", "css" },
        cmd = "SF",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "ibhagwan/fzf-lua",
        },
        config = function()
            require("sf").setup({
                enable_hotkeys = false,
                terminal = "integrated",

                term_config = {
                    dimensions = {
                        height = 0.5,
                    },
                },
            })
        end,
        keys = {
            -- shortcuts
            {
                "<leader>ss",
                function()
                    require("sf").set_target_org()
                end,
                desc = "SF: Set Target Org",
            },
            {
                "<leader>sq",
                function()
                    -- ask for the sobject name
                    vim.ui.input({ prompt = "sObject for the query (ex: Account): " }, function(input)
                        if not input or input == "" then
                            return
                        end

                        -- check where the file pattern is
                        local paths = {
                            ".sfdx/tools/sobjects/standardObjects/" .. input .. ".cls",
                            ".sfdx/tools/sobjects/customObjects/" .. input .. ".cls",
                        }

                        local file_path = nil
                        for _, p in ipairs(paths) do
                            if vim.fn.filereadable(p) == 1 then
                                file_path = p
                                break
                            end
                        end

                        if not file_path then
                            vim.notify("sObject not found. Run <leader>so", vim.log.levels.WARN)
                            return
                        end

                        -- get only the field name using regex
                        local fields = {}
                        for line in io.lines(file_path) do
                            -- search for fields
                            local field = string.match(line, "global%s+[%w_]+%s+([%w_]+);")
                            if field then
                                table.insert(fields, field)
                            end
                        end

                        require("fzf-lua").fzf_exec(fields, {
                            prompt = input .. " Fields> ",
                            fzf_opts = {
                                -- tab to mark multiple fields
                                ["--multi"] = true,
                            },
                            actions = {
                                ["default"] = function(selected)
                                    if not selected or #selected == 0 then
                                        return
                                    end

                                    -- kinda off appends with , the fields selected
                                    local result = table.concat(selected, ", ")

                                    -- insert text right where cursor is
                                    local pos = vim.api.nvim_win_get_cursor(0)
                                    local row = pos[1] - 1
                                    local col = pos[2]
                                    vim.api.nvim_buf_set_text(0, row, col, row, col, { result })
                                end,
                            },
                        })
                    end)
                end,
                desc = "SOQL: Fuzzy find & Insert fields",
            },
            {
                "<leader>sea",
                function()
                    require("sf").execute_anonymous()
                end,
                mode = { "n", "v" },
                desc = "SF: Execute Anonymous Apex",
            },
            {
                "<leader>so",
                function()
                    vim.notify("Generating sObjects (standard and custom ones)", vim.log.levels.INFO)

                    vim.fn.jobstart("sf-sobjects-gen.sh", {
                        on_exit = function(_, code)
                            if code == 0 then
                                vim.notify("sObjects updated. LSP restarting", vim.log.levels.INFO)
                                vim.cmd("LspRestart apex_ls")
                            else
                                vim.notify("Error while generating sObjects", vim.log.levels.ERROR)
                            end
                        end,
                    })
                end,
                desc = "SF: Generate SObjects definitions",
            },
            {
                "<leader>sf",
                function()
                    require("sf").fetch_org_list()
                end,
                desc = "SF: Fetch Org List",
            },

            {
                "<leader>sp",
                function()
                    require("sf").save_and_push()
                end,
                desc = "SF: Push Current File",
            },
            {
                "<leader>sr",
                function()
                    require("sf").retrieve()
                end,
                desc = "SF: Retrieve Current File",
            },
            {
                "<leader>sd",
                function()
                    require("sf").diff_in_org()
                end,
                desc = "SF: Diff Local vs Org",
            },

            {
                "<leader>sc",
                function()
                    require("sf").create_metadata()
                end,
                desc = "SF: Create Metadata (LWC/Apex)",
            },

            {
                "<leader>sa",
                function()
                    require("sf").run_all_tests_in_this_file()
                end,
                desc = "SF: Run All Tests (File)",
            },
            {
                "<leader>su",
                function()
                    require("sf").run_current_test()
                end,
                desc = "SF: Run Test Under Cursor",
            },
            {
                "<leader>sc",
                function()
                    require("sf").toggle_sign()
                end,
                desc = "SF: Toggle Coverage",
            },

            {
                "<leader>st",
                function()
                    require("sf").toggle_term()
                end,
                desc = "SF: Toggle Terminal",
            },
        },
    },
}
