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
            },

            formatters_by_ft = {
                kotlin = { "ktlint" },
            },

            formatters_by_ft = {
                java = { "google-java-format" },
            },
        },
    },
}
