return {
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                separator_style = "thin",
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                show_close_icon = false,
                indicator = { style = "none" },
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "",
                        padding = 1,
                    },
                },
            },
            highlights = {
                fill = {
                    bg = "#161616",
                },
                background = {
                    fg = "#525252",
                    bg = "#161616",
                },
                buffer_selected = {
                    fg = "#ffffff",
                    bg = "#161616",
                    bold = true,
                    italic = false,
                },
                close_button = {
                    fg = "#525252",
                    bg = "#161616",
                },
                close_button_selected = {
                    fg = "#ff5f5f",
                    bg = "#161616",
                },
                separator = {
                    fg = "#161616",
                    bg = "#161616",
                },
                separator_selected = {
                    fg = "#161616",
                    bg = "#161616",
                },
                modified = {
                    fg = "#d7875f",
                    bg = "#161616",
                },
                modified_selected = {
                    fg = "#d7875f",
                    bg = "#161616",
                },
                duplicate_selected = {
                    fg = "#ffffff",
                    bg = "#161616",
                    italic = true,
                },
                duplicate = {
                    fg = "#525252",
                    bg = "#161616",
                    italic = true,
                },
            },
        },
    },
}
