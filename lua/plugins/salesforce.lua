return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {

                -- apex - backend
                apex_ls = {
                    apex_enable_semantic_errors = true,
                    apex_enable_completion_statistics = false,
                    filetypes = { "apex" },
                },

                -- LWC - web components
                lwc_ls = {
                    filetypes = { "html", "javascript" },
                    root_dir = require("lspconfig").util.root_pattern("sfdx-project.json"),
                },

                -- default .js support
                vtsls = {},
                -- default .css support
                cssls = {},
                -- mandatory linting that might be added furthermore in the root of any project
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
                "<leader>ta",
                function()
                    require("sf").run_all_tests_in_this_file()
                end,
                desc = "SF: Run All Tests (File)",
            },
            {
                "<leader>tt",
                function()
                    require("sf").run_current_test()
                end,
                desc = "SF: Run Test Under Cursor",
            },
            {
                "<leader>tc",
                function()
                    require("sf").toggle_coverage()
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
