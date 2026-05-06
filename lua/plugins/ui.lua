return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            -- Configuração inicial (Dark com transparência)
            require("gruvbox").setup({
                contrast = "hard",
                transparent_mode = true,
            })

            -- Comando Light: Desliga a transparência nativa do plugin e muda pra claro
            vim.api.nvim_create_user_command("GruvboxLight", function()
                vim.o.background = "light"
                require("gruvbox").setup({ contrast = "hard", transparent_mode = false })
                vim.cmd("colorscheme gruvbox")
            end, {})

            -- Comando Dark: Liga a transparência nativa do plugin e muda pra escuro
            vim.api.nvim_create_user_command("GruvboxDark", function()
                vim.o.background = "dark"
                require("gruvbox").setup({ contrast = "hard", transparent_mode = true })
                vim.cmd("colorscheme gruvbox")
            end, {})

            local function set_transparency()
                -- Trava de segurança: impede que a sua transparência customizada
                -- remova o fundo branco no modo light.
                if vim.o.background == "light" then
                    return
                end

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
