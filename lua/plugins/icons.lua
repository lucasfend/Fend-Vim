return {
    { "nvim-mini/mini.icons", enabled = false },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
            color_icons = true,
            default = true,
            strict = true,
        },
        config = function(_, opts)
            require("nvim-web-devicons").setup(opts)
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            local icons = require("lazyvim.config").icons
            opts.options = opts.options or {}
            opts.options.component_separators = { left = "|", right = "|" }
            opts.options.section_separators = { left = "", right = "" }
        end,
    },
}
