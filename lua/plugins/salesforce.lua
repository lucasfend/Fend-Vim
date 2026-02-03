return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                apex_ls = {
                    apex_enable_semantic_errors = true,
                    apex_enable_completion_statistics = false,
                    filetypes = { "apex" },
                },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "apex", "soql", "sosl" })
            end
        end,
    },

    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "apex-language-server")
        end,
    },

    {
        "xixiaofinland/sf.nvim",
        ft = { "apex", "soql", "sosl", "javascript", "html" }, -- html/js inclusos para LWC/Aura
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
                "<leader>st",
                function()
                    require("sf").toggle_term()
                end,
                desc = "SF: Toggle Terminal",
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
        },
    },
}
