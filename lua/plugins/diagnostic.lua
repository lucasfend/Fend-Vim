return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "ghost", -- "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont"
                hi = {
                    error = "DiagnosticError",
                    warn = "DiagnosticWarn",
                    info = "DiagnosticInfo",
                    hint = "DiagnosticHint",
                },
                options = {
                    show_source = true,
                    use_icons_from_diagnostic = true,
                    add_messages = true,
                    throttle = 20,
                    softwrap = 20,

                    multilines = {
                        enabled = true,
                        always_show = true,
                    },
                },
            })

            -- unset the default LazyVim diagnostic
            vim.diagnostic.config({
                virtual_text = false,
                -- signs = true,
                -- underline = true,
                -- update_in_insert = false,
            })
        end,
    },
}
