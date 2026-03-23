vim.filetype.add({
    extension = {
        html = function(path, _)
            local angular_markers = vim.fs.find({ "angular.json", "project.json" }, {
                path = vim.fs.dirname(path),
                upward = true,
                type = "file",
            })

            if #angular_markers > 0 then
                return "htmlangular"
            end

            return "html"
        end,
    },
})

return {
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.angular" },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                angularls = {
                    -- Removemos "html" da tabela para evitar vazamento pro Salesforce
                    filetypes = { "typescript", "htmlangular", "typescriptreact" },
                },
                eslint = {
                    settings = { workingDirectory = { mode = "auto" } },
                },
            },
        },
    },
}
