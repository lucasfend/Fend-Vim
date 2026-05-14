return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4" },
                },
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                shfmt = {
                    prepend_args = { "-i", "4" },
                },
                google_java_format = {
                    command = vim.fn.expand("~/.local/bin/google-java-format"),
                    args = { "--aosp", "-" },
                    stdin = true,
                },
            },
            formatters_by_ft = {
                kotlin = { "ktlint" },
                java = { "google_java_format", lsp_format = "never" },
            },
        },
    },
}
