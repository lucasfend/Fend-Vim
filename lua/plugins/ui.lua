return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "hard",
                transparent_mode = true,
            })

            local function set_transparency()
                local groups = {
                    "Normal",
                    "NormalNC",
                    "NormalFloat",
                    "FloatBorder",
                    "FloatTitle",
                    "FloatShadow",
                    "FloatShadowThrough",
                    "NeoTreeNormal",
                    "NeoTreeNormalNC",
                    "NeoTreeEndOfBuffer",
                    "NeoTreeSignColumn",
                    "NeoTreeFloatBorder",
                    "NeoTreeFloatTitle",
                    "NeoTreeTitleBar",
                    "NeoTreeWinSeparator",
                    "EndOfBuffer",
                    "SignColumn",
                    "WinSeparator",
                    "CursorLine",
                    "NeoTreeCursorLine",
                    "Pmenu",
                    "NormalSB",
                }

                for _, group in ipairs(groups) do
                    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
                end
            end

            set_transparency()

            vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "ColorScheme" }, {
                callback = function()
                    vim.schedule(set_transparency)
                end,
            })
        end,
    },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
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
    { "folke/noice.nvim", enabled = false },
    { "nvim-mini/mini.animate", enabled = false },
}
