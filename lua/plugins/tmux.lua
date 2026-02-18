local inside_tmux = vim.env.TMUX ~= nil

return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function()
            vim.opt.cmdheight = 0

            if inside_tmux then
                vim.opt.laststatus = 0
            else
                vim.opt.laststatus = 3
            end
        end,
        opts = function(_, opts)
            opts.options.globalstatus = true
            opts.options.theme = "gruvbox"
            opts.options.component_separators = { left = "", right = "" }
            opts.options.section_separators = { left = "", right = "" }

            opts.sections.lualine_a = {
                {
                    "mode",
                    fmt = function(str)
                        return str:sub(1, 1)
                    end,
                },
            }

            opts.sections.lualine_b = {
                { "branch", icon = "" },
            }

            opts.sections.lualine_c = {
                {
                    "filename",
                    path = 0,
                    symbols = {
                        modified = " ●",
                        readonly = " ",
                        unnamed = "[No Name]",
                    },
                    color = { fg = "#ebdbb2", gui = "bold" },
                },
                {
                    function()
                        local current_node = vim.treesitter.get_node()
                        if not current_node then
                            return ""
                        end
                        while current_node do
                            local type = current_node:type()
                            if
                                type == "function_declaration"
                                or type == "function_definition"
                                or type == "method_declaration"
                            then
                                for child in current_node:iter_children() do
                                    if
                                        child:type() == "identifier"
                                        or child:type() == "name"
                                        or child:type() == "property_identifier"
                                    then
                                        return "󰊕 " .. vim.treesitter.get_node_text(child, 0)
                                    end
                                end
                                break
                            end
                            current_node = current_node:parent()
                        end
                        return ""
                    end,
                    color = { fg = "#d65d0e" },
                },
            }

            opts.sections.lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                },
                {
                    function()
                        local clients = vim.lsp.get_clients()
                        if next(clients) == nil then
                            return ""
                        end
                        local client_names = {}
                        for _, client in ipairs(clients) do
                            if client.name ~= "null-ls" and client.name ~= "copilot" then
                                table.insert(client_names, client.name)
                            end
                        end
                        if #client_names > 0 then
                            return "  LSP - " .. table.concat(client_names, ", ")
                        end
                        return ""
                    end,
                    color = { fg = "#928374" },
                },
            }

            opts.sections.lualine_y = {
                "filesize",
                "progress",
            }

            opts.sections.lualine_z = {
                "location",
                {
                    function()
                        return os.date("%H:%M")
                    end,
                    icon = " ",
                },
            }
        end,
    },
}
