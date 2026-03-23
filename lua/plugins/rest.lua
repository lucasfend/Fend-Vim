return {
    "mistweaverco/kulala.nvim",
    opts = {
        formatters = {
            json = { "jq", "." },
        },
        contenttypes = {
            ["application/json"] = {
                ft = "json",
                formatter = { "jq", "." },
            },
            ["application/vnd.api+json"] = {
                ft = "json",
                formatter = { "jq", "." },
            },
        },
        winbar = true,
        default_view = "body",
    },
    keys = {
        {
            "<leader>rr",
            function()
                require("kulala").run()
            end,
            desc = "Send Request",
        },
        {
            "<leader>rt",
            function()
                require("kulala").toggle_view()
            end,
            desc = "Toggle Headers/Body",
        },
    },
    config = function(_, opts)
        require("kulala").setup(opts)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "kulala_ui",
            callback = function()
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
            end,
        })
    end,
}
