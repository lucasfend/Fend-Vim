return {
    -- keybinds
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
            vim.opt.laststatus = 3
        end,
        opts = function(_, opts)
            opts.options.globalstatus = true
            opts.options.component_separators = { left = "", right = "" }
            opts.options.section_separators = { left = "", right = "" }

            local colors = {
                bg = "#161616",
                bubble = "#262626",
                text = "#dde1e6",
                dim = "#525252",
                pink = "#ff7eb6",
                purple = "#be95ff",
                blue = "#33b1ff",
                teal = "#08bdba",
                cyan = "#3ddbd9",
                green = "#42be65",
                lblue = "#82cfff",
                red = "#ee5396",
                trans = "None",
            }

            local function bubble_style(fg_color)
                return { bg = colors.bubble, fg = fg_color, gui = "bold" }
            end

            local function has_diagnostic()
                local d = vim.diagnostic.get(0)
                return d and #d > 0
            end

            local function has_lsp()
                local clients = vim.lsp.get_clients()
                return next(clients) ~= nil
            end

            local function has_branch()
                return vim.b.gitsigns_status_dict ~= nil or vim.b.gitsigns_head ~= nil
            end

            local function split(condition)
                return {
                    function()
                        return "│"
                    end,
                    color = { fg = colors.bg, bg = colors.bubble },
                    padding = { left = 0, right = 0 },
                    cond = condition,
                }
            end

            opts.options.theme = {
                normal = { c = { fg = colors.text, bg = colors.trans }, x = { fg = colors.text, bg = colors.trans } },
                inactive = { c = { fg = colors.dim, bg = colors.trans }, x = { fg = colors.dim, bg = colors.trans } },
            }

            opts.sections.lualine_a = {}
            opts.sections.lualine_b = {}
            opts.sections.lualine_y = {}
            opts.sections.lualine_z = {}

            opts.sections.lualine_c = {
                {
                    "mode",
                    fmt = function(str)
                        return str:sub(1, 1)
                    end,
                    color = bubble_style(colors.pink),
                    separator = { left = "", right = "" },
                    padding = { left = 1, right = 1 },
                },

                split(),

                {
                    "branch",
                    icon = "",
                    color = bubble_style(colors.purple),
                    padding = { left = 1, right = 1 },
                    cond = has_branch,
                },

                split(has_branch),

                {
                    function()
                        local fname = vim.fn.expand("%:t")
                        if fname == "" then
                            return "[No Name]"
                        end
                        local ok, devicons = pcall(require, "nvim-web-devicons")
                        local icon = ""
                        if ok then
                            local f_icon = devicons.get_icon(fname, vim.fn.expand("%:e"), { default = true })
                            if f_icon then
                                icon = f_icon .. " "
                            end
                        end
                        local modified = vim.bo.modified and " - has changes" or ""
                        local readonly = (vim.bo.readonly or not vim.bo.modifiable) and " " or ""
                        return icon .. fname .. modified .. readonly
                    end,
                    color = bubble_style(colors.blue),
                    separator = { right = "" },
                    padding = { left = 1, right = 1 },
                },
            }

            opts.sections.lualine_x = {
                {
                    function()
                        return ""
                    end,
                    color = { fg = colors.bubble, bg = colors.bg },
                    padding = { left = 0, right = 0 },
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    diagnostics_color = {
                        error = { fg = colors.red, bg = colors.bubble },
                        warn = { fg = colors.pink, bg = colors.bubble },
                        info = { fg = colors.cyan, bg = colors.bubble },
                        hint = { fg = colors.text, bg = colors.bubble },
                    },
                    padding = { left = 0, right = 1 },
                },
                split(has_diagnostic),

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
                            return "  LSP ~ " .. table.concat(client_names, ", ")
                        end
                        return ""
                    end,
                    color = bubble_style(colors.teal),
                    padding = { left = 1, right = 1 },
                },
                split(has_lsp),

                {
                    "filesize",
                    color = bubble_style(colors.cyan),
                    padding = { left = 1, right = 1 },
                },
                split(),

                {
                    function()
                        local line = vim.fn.line(".")
                        local col = vim.fn.col(".")
                        local total = vim.fn.line("$")
                        local percent = math.floor((line / total) * 100)
                        return string.format("%d%%%% %d:%d", percent, line, col)
                    end,
                    color = bubble_style(colors.lblue),
                    separator = { right = "" },
                    padding = { left = 1, right = 1 },
                },
            }
        end,
    },
}
