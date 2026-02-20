return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup()

        vim.keymap.set("x", "<leader>re", function()
            require("refactoring").refactor("Extract Function")
        end)
        vim.keymap.set("x", "<leader>rf", function()
            require("refactoring").refactor("Extract Function To File")
        end)
        vim.keymap.set("x", "<leader>rv", function()
            require("refactoring").refactor("Extract Variable")
        end)
    end,
}
