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

    -- pipeline
    {
        "vimpostor/vim-tpipeline",
        lazy = false,
        init = function()
            vim.g.tpipeline_autoembed = 1
        end,
        config = function()
            vim.opt.laststatus = 0
            vim.opt.cmdheight = 0
            vim.cmd([[
                augroup TpipelineHideStatus
                  autocmd!
                  autocmd VimEnter,BufEnter * set laststatus=0
                augroup END
            ]])
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.options.globalstatus = false
            opts.options.section_separators = { left = "", right = "" }
            opts.options.component_separators = { left = "", right = "" }

            -- colors
            local colors = {
                pink = "#ff7eb6",
                text = "#c0c0c0",
                dim = "#505050",
                trans = "None",

                error = "#d75f5f",
                warn = "#d7875f",
                info = "#d75f87",
            }

            -- theme itself
            opts.options.theme = {
                normal = {
                    a = { fg = colors.pink, bg = colors.trans, gui = "bold" },
                    b = { fg = colors.text, bg = colors.trans },
                    c = { fg = colors.text, bg = colors.trans },
                },
                insert = {
                    a = { fg = colors.pink, bg = colors.trans, gui = "bold" },
                    b = { fg = colors.text, bg = colors.trans },
                    c = { fg = colors.text, bg = colors.trans },
                },
                visual = {
                    a = { fg = colors.pink, bg = colors.trans, gui = "bold" },
                    b = { fg = colors.text, bg = colors.trans },
                    c = { fg = colors.text, bg = colors.trans },
                },
                replace = {
                    a = { fg = colors.pink, bg = colors.trans, gui = "bold" },
                    b = { fg = colors.text, bg = colors.trans },
                    c = { fg = colors.text, bg = colors.trans },
                },
                command = {
                    a = { fg = colors.pink, bg = colors.trans, gui = "bold" },
                    b = { fg = colors.text, bg = colors.trans },
                    c = { fg = colors.text, bg = colors.trans },
                },
                inactive = {
                    a = { fg = colors.dim, bg = colors.trans },
                    b = { fg = colors.dim, bg = colors.trans },
                    c = { fg = colors.dim, bg = colors.trans },
                },
            }

            -- left section
            opts.sections.lualine_a = {
                {
                    "mode",
                    icon = "",
                    padding = { left = 2, right = 2 },
                },
            }

            opts.sections.lualine_b = {
                {
                    "filename",
                    file_status = true,
                    path = 0,
                    color = { fg = colors.pink, gui = "bold" },
                    padding = { left = 1, right = 1 },
                },
            }

            opts.sections.lualine_c = {
                {
                    "branch",
                    icon = "",
                    color = { fg = colors.pink, gui = "bold" },
                    padding = { left = 2, right = 2 },
                },
            }

            opts.sections.lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " " },
                    diagnostics_color = {
                        error = { fg = colors.error, bg = colors.trans },
                        warn = { fg = colors.warn, bg = colors.trans },
                        info = { fg = colors.info, bg = colors.trans },
                    },
                    padding = { left = 2, right = 2 },
                },
            }

            opts.sections.lualine_y = {}

            -- lsp get setup
            local function get_lsp()
                local msg = ""
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                    return msg
                end
                local client_names = {}
                for _, client in ipairs(clients) do
                    if client.name ~= "null-ls" and client.name ~= "copilot" then
                        table.insert(client_names, client.name)
                    end
                end
                if #client_names > 0 then
                    return "  " .. table.concat(client_names, ", ")
                end
                return msg
            end

            -- lps and clock infos
            opts.sections.lualine_z = {
                {
                    get_lsp,
                    color = { fg = colors.pink, gui = "bold" },
                    padding = { left = 1, right = 2 },
                },
                {
                    "datetime",
                    style = "  %H:%M",
                    color = { fg = colors.pink, gui = "bold" },
                    padding = { left = 1, right = 2 },
                },
            }
        end,
    },
}
