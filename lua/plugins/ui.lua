return {
    { "projekt0n/github-nvim-theme" },

    {
        "nyoom-engineering/oxocarbon.nvim",
        config = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme oxocarbon")

            vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#161616", bg = "#161616" })
        end,
    },

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
            vim.opt.fillchars = { vert = " ", eob = " ", diff = "╱" }
        end,
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
