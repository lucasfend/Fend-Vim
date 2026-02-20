return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end)

        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        vim.keymap.set("n", "<M-1>", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "<M-2>", function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", "<M-3>", function()
            harpoon:list():select(3)
        end)
        vim.keymap.set("n", "<M-4>", function()
            harpoon:list():select(4)
        end)

        vim.keymap.set("n", "<leader>hr", function()
            local harpoon = require("harpoon")
            local current_file = vim.fn.expand("%")
            local list = harpoon:list()

            for i, item in ipairs(list.items) do
                if item.value == current_file then
                    table.remove(list.items, i)
                    vim.notify("Harpoon tagged", vim.log.levels.INFO)
                    return
                end
            end
            vim.notify("Harpoon untagged", vim.log.levels.INFO)
        end, { desc = "Harpoon remove" })
    end,
}
