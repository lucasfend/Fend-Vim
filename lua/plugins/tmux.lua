return {
    -- navigation
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
            vim.cmd([[
        augroup TpipelineHideStatus
          autocmd!
          autocmd VimEnter,BufEnter * set laststatus=0
        augroup END
      ]])
        end,
    },

    -- lualine
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.options.globalstatus = false
            opts.options.section_separators = { left = "", right = "" }
            opts.options.component_separators = { left = "|", right = "|" }

            local colors = {
                bg_island = "#3B4252",
                fg_text = "#D8DEE9",
                fg_icon = "#88C0D0",
                transparent = "None",
            }

            -- only visual stuff
            opts.sections.lualine_a = {
                {
                    function()
                        return ""
                    end,
                    padding = { left = 0, right = 0 },
                    color = { fg = colors.bg_island, bg = colors.transparent },
                },
                {
                    function()
                        return ""
                    end,
                    padding = { left = 1, right = 1 },
                    color = { fg = colors.fg_icon, bg = colors.bg_island },
                },
                {
                    function()
                        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                    end,
                    padding = { left = 0, right = 1 },
                    color = { fg = colors.fg_text, bg = colors.bg_island, gui = "bold" },
                },
                {
                    function()
                        return ""
                    end,
                    padding = { left = 0, right = 0 },
                    color = { fg = colors.bg_island, bg = colors.transparent },
                },
            }

            opts.sections.lualine_b = {}
            opts.sections.lualine_c = {}
            opts.sections.lualine_x = {}
            opts.sections.lualine_y = {}

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
                    return "  " .. table.concat(client_names, ", ")
                end
                return msg
            end

            opts.sections.lualine_z = {
                {
                    function()
                        return ""
                    end,
                    padding = { left = 0, right = 0 },
                    color = { fg = colors.bg_island, bg = colors.transparent },
                },
                {
                    get_lsp,
                    color = { fg = "#EBCB8B", bg = colors.bg_island },
                    padding = { left = 1, right = 1 },
                },
                {
                    function()
                        return "|"
                    end,
                    color = { fg = colors.fg_text, bg = colors.bg_island },
                    padding = { left = 0, right = 0 },
                    cond = function()
                        return #vim.lsp.get_clients() > 0
                    end,
                },
                {
                    "datetime",
                    style = "%H:%M",
                    color = { fg = colors.fg_text, bg = colors.bg_island, gui = "bold" },
                    padding = { left = 1, right = 1 },
                },
                {
                    function()
                        return ""
                    end,
                    padding = { left = 0, right = 0 },
                    color = { fg = colors.bg_island, bg = colors.transparent },
                },
            }
        end,
    },

    {
        "folke/snacks.nvim",
        opts = function()
            vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
                callback = function()
                    local file = vim.fn.expand("%:t")
                    if file == "" then
                        file = "[No Name]"
                    end
                    local extension = vim.fn.expand("%:e")
                    local icon, _ = require("nvim-web-devicons").get_icon(file, extension)
                    if not icon then
                        icon = ""
                    end

                    vim.fn.system("tmux rename-window '" .. icon .. " " .. file .. "'")
                end,
            })
        end,
    },
}
