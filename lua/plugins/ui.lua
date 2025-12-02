return {
    { "projekt0n/github-nvim-theme" },
    { "doums/darcula" },
    { "nyoom-engineering/oxocarbon.nvim" },

    {
        "shaunsingh/nord.nvim",
        config = function()
            vim.g.nord_contrast = true
            vim.g.nord_borders = false
            vim.g.nord_disable_background = false
            vim.g.nord_italic = false
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
            colorscheme = "oxocarbon",
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
