return {
    { "nvim-mini/mini.icons", enabled = false },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
            color_icons = true,
            default = true,
            strict = true,

            override_by_extension = {
                ["cls"] = {
                    icon = " ", -- Ícone de nuvem (Nerd Font)
                    color = "#00A1E0",
                    name = "ApexClass",
                },
                -- Já aproveitando o embalo para outros arquivos SFDC
                ["trigger"] = {
                    icon = " ", -- Ícone de raio para Triggers
                    color = "#00A1E0",
                    name = "ApexTrigger",
                },
                ["soql"] = {
                    icon = " ", -- Ícone de banco de dados para buscas
                    color = "#00A1E0",
                    name = "SOQL",
                },
                ["sosl"] = {
                    icon = " ", -- Ícone de lupa para buscas textuais
                    color = "#00A1E0",
                    name = "SOSL",
                },
            },
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
