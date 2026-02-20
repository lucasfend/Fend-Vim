return {
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                separator_style = "thin",

                always_show_bufferline = false,

                show_buffer_close_icons = true,
                show_close_icon = false,
                indicator = { style = "none" },

                name_formatter = function(buf)
                    local ok, harpoon = pcall(require, "harpoon")
                    if not ok then
                        return buf.name
                    end

                    local buf_path = vim.fn.fnamemodify(buf.path, ":.")
                    local list = harpoon:list()

                    for i, item in ipairs(list.items) do
                        if item.value == buf_path then
                            return string.format("[H:%d] %s", i, buf.name)
                        end
                    end

                    return buf.name
                end,

                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "",
                        highlight = "Normal",
                        separator = false,
                    },
                },
            },

            highlights = {
                fill = { bg = "NONE" },
                offset_separator = { bg = "NONE", fg = "NONE" },
                background = { fg = "#928374", bg = "NONE" },

                close_button = { fg = "#928374", bg = "NONE" },
                close_button_selected = { fg = "#fb4934", bg = "NONE" },

                separator = { fg = "#3c3836", bg = "NONE" },
                separator_selected = { fg = "#3c3836", bg = "NONE" },

                modified = { fg = "#fe8019", bg = "NONE" },
                modified_selected = { fg = "#fe8019", bg = "NONE" },

                duplicate_selected = {
                    fg = "#fbf1c7",
                    bg = "NONE",
                    italic = true,
                },
                duplicate = {
                    fg = "#928374",
                    bg = "NONE",
                    italic = true,
                },

                error = { fg = "#cc241d", bg = "NONE" },
                error_diagnostic = { fg = "#cc241d", bg = "NONE" },
                error_selected = {
                    fg = "#fb4934",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },
                error_diagnostic_selected = {
                    fg = "#fb4934",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },

                warning = { fg = "#d79921", bg = "NONE" },
                warning_diagnostic = { fg = "#d79921", bg = "NONE" },
                warning_selected = {
                    fg = "#fabd2f",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },
                warning_diagnostic_selected = {
                    fg = "#fabd2f",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },

                info = { fg = "#458588", bg = "NONE" },
                info_diagnostic = { fg = "#458588", bg = "NONE" },
                info_selected = {
                    fg = "#83a598",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },
                info_diagnostic_selected = {
                    fg = "#83a598",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },

                hint = { fg = "#689d6a", bg = "NONE" },
                hint_diagnostic = { fg = "#689d6a", bg = "NONE" },
                hint_selected = {
                    fg = "#8ec07c",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },
                hint_diagnostic_selected = {
                    fg = "#8ec07c",
                    bg = "NONE",
                    bold = true,
                    italic = false,
                },
            },
        },

        config = function(_, opts)
            require("bufferline").setup(opts)

            local groups = {
                "TabLine",
                "TabLineFill",
                "TabLineSel",
                "BufferLineFill",
                "BufferLineBackground",
                "BufferLineOffset",
                "BufferLineSeparator",
                "BufferLineSeparatorSelected",
            }

            for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, { bg = "NONE" })
            end

            vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
                fg = "#fbf1c7",
                bg = "NONE",
                bold = true,
            })

            vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", {
                fg = "#fbf1c7",
                bg = "NONE",
                bold = true,
            })
        end,
    },
}
