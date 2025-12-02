return {
    {
        "folke/snacks.nvim",
        keys = {
            { "<leader>e", false },
            { "<leader>E", false },
        },
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            {
                "<leader>E",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git Explorer",
            },
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer Explorer",
            },
        },
        opts = {
            enable_git_status = true,
            enable_diagnostics = false,

            filesystem = {
                group_empty_dirs = true,

                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },

            default_component_configs = {
                -- visual configs
                indent = {
                    indent_size = 2,
                    padding = 0,
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    highlight = "NeoTreeIndentMarker",
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },

                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "",
                },

                git_status = {
                    symbols = {
                        added = "+",
                        modified = "",
                        deleted = "x",
                        renamed = "->",
                        untracked = "?",
                        ignored = "i",
                        unstaged = "",
                        staged = "s",
                        conflict = "!",
                    },
                },

                modified = {
                    symbol = "!",
                    highlight = "NeoTreeModified",
                },

                name = {
                    trailing_slash = false,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
            },

            window = {
                width = 45,
                mappings = {
                    ["/"] = "noop",
                },
            },
        },
    },
}
