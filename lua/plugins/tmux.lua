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
        "vimpostor/vim-tpipeline",
        dependencies = { "nvim-lualine/lualine.nvim" },
        enabled = inside_tmux,
        config = function()
            vim.opt.cmdheight = 0
            vim.opt.laststatus = 0
        end,
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
            opts.options.component_separators = { left = "", right = "" }
            opts.options.section_separators = { left = "", right = "" }

            local colors = {
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

            local function txt_style(fg_color)
                return { bg = colors.trans, fg = fg_color, gui = "bold" }
            end

            local function has_branch()
                return vim.b.gitsigns_status_dict ~= nil or vim.b.gitsigns_head ~= nil
            end
            local function has_diagnostic()
                local d = vim.diagnostic.get(0)
                return d and #d > 0
            end
            local function has_lsp()
                local clients = vim.lsp.get_clients()
                return next(clients) ~= nil
            end

            local function split(condition)
                return {
                    function()
                        return "│"
                    end,
                    color = { fg = colors.dim, bg = colors.trans },
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
                    color = txt_style(colors.pink),
                    padding = { left = 1, right = 1 },
                },
                split(),
                {
                    "branch",
                    icon = "",
                    color = txt_style(colors.purple),
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
                        local modified = vim.bo.modified and " ●" or ""
                        local readonly = (vim.bo.readonly or not vim.bo.modifiable) and " " or ""
                        return icon .. fname .. modified .. readonly
                    end,
                    color = txt_style(colors.blue),
                    padding = { left = 1, right = 1 },
                },
            }

            opts.sections.lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    diagnostics_color = {
                        error = { fg = colors.red, bg = colors.trans },
                        warn = { fg = colors.pink, bg = colors.trans },
                        info = { fg = colors.cyan, bg = colors.trans },
                        hint = { fg = colors.text, bg = colors.trans },
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
                            return "  " .. table.concat(client_names, ", ")
                        end
                        return ""
                    end,
                    color = txt_style(colors.teal),
                    padding = { left = 1, right = 1 },
                },
                split(has_lsp),
                {
                    "filesize",
                    color = txt_style(colors.cyan),
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
                    color = txt_style(colors.lblue),
                    padding = { left = 1, right = 1 },
                },
            }
        end,
    },
}
