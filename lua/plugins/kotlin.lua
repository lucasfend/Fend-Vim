return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local configs = require("lspconfig.configs")

            if not configs.kotlin_lsp then
                configs.kotlin_lsp = {
                    default_config = {
                        cmd = { "kotlin-lsp" },
                        filetypes = { "kotlin" },
                        root_dir = lspconfig.util.root_pattern(
                            "settings.gradle.kts",
                            "settings.gradle",
                            "build.gradle.kts",
                            "build.gradle",
                            ".git"
                        ),
                        single_file_support = true,
                    },
                }
            end

            lspconfig.kotlin_lsp.setup({})
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "kotlin",
            },
        },
    },
}
