return {
    { "projekt0n/github-nvim-theme" },

    { "doums/darcula" },

    {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.nord_contrast = true
            vim.g.nord_borders = false
            vim.g.nord_disable_background = false
            vim.g.nord_italic = false

            require("nord").set()

            local group = vim.api.nvim_create_augroup("NordCustomOverrides", { clear = true })

            vim.api.nvim_create_autocmd("ColorScheme", {
                group = group,
                pattern = "*",
                callback = function()
                    local nord_bg = "#2E3440"
                    local transparent = "NONE"

                    local hl = vim.api.nvim_set_hl

                    hl(0, "WinSeparator", { fg = nord_bg, bg = nord_bg })
                    hl(0, "VertSplit", { fg = nord_bg, bg = nord_bg })

                    hl(0, "Normal", { bg = nord_bg })
                    hl(0, "NormalNC", { bg = nord_bg })
                    hl(0, "SignColumn", { bg = nord_bg })
                    hl(0, "LineNr", { bg = nord_bg, fg = "#4C566A" })
                    hl(0, "CursorLineNr", { bg = nord_bg })

                    hl(0, "NeoTreeNormal", { bg = nord_bg })
                    hl(0, "NeoTreeNormalNC", { bg = nord_bg })
                    hl(0, "NeoTreeWinSeparator", { fg = nord_bg, bg = nord_bg })
                    hl(0, "NvimTreeNormal", { bg = nord_bg })
                    hl(0, "NvimTreeWinSeparator", { fg = nord_bg, bg = nord_bg })

                    hl(0, "WinBar", { bg = nord_bg })
                    hl(0, "WinBarNC", { bg = nord_bg })
                    hl(0, "NormalFloat", { bg = nord_bg })
                    hl(0, "FloatBorder", { fg = nord_bg, bg = nord_bg })
                end,
            })

            vim.cmd("doautocmd ColorScheme")
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        opts = {
            compile = true,
            commentStyle = { italic = true },
            keywordStyle = { italic = true },
            theme = "dragon",
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                        },
                    },
                },
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    float = { bg = "none" },
                }
            end,
        },
    },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "nord",
            defaults = {
                autocmds = true,
                keymaps = true,
            },
        },
        config = function(_, opts)
            require("lazyvim.util").config.setup(opts)

            vim.opt.foldcolumn = "0"
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                separator_style = "slant",

                always_show_bufferline = true,
                show_buffer_close_icons = false,
                show_close_icon = false,

                indicator = {
                    style = "none",
                },
            },
        },
    },

    -- OTHER UI CONFIG STUFF

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options.section_separators = { left = "", right = "" }
            opts.options.component_separators = { left = "|", right = "|" }
        end,
    },

    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "nvim-mini/mini.indentscope", enabled = false },

    {
        "folke/noice.nvim",
        enabled = false,
        opts = {
            cmdline = { view = "cmdline" },
        },
    },

    {
        "folke/snacks.nvim",
        opts = {
            indent = { enabled = false },
            scope = { enabled = false },
        },
    },
}
