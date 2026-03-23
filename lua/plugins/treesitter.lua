return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    return lang ~= "jsonc"
                end, opts.ensure_installed)

                if not vim.tbl_contains(opts.ensure_installed, "json") then
                    table.insert(opts.ensure_installed, "json")
                end
            end
        end,
    },
}
