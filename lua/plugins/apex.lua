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
                vim.list_extend(opts.ensure_installed, { "apex" })
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
}
