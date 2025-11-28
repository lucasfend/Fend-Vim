return {
    {
        "mfussenegger/nvim-jdtls",
        opts = function(_, opts)
            local mason_root = vim.fn.stdpath("data") .. "/mason"
            local bundles = {}

            local debug_path = mason_root
                .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
            local debug_jar = vim.fn.glob(debug_path, true)
            if debug_jar ~= "" then
                table.insert(bundles, debug_jar)
            end

            local test_path = mason_root .. "/packages/java-test/extension/server/*.jar"
            local test_jars = vim.fn.glob(test_path, true, true)
            if #test_jars > 0 then
                vim.list_extend(bundles, test_jars)
            end

            opts.init_options = opts.init_options or {}
            opts.init_options.bundles = bundles

            local original_on_attach = opts.on_attach
            opts.on_attach = function(client, buffer)
                if original_on_attach then
                    original_on_attach(client, buffer)
                end

                if client.name == "jdtls" then
                    local ok_dap, _ = pcall(require, "dap")

                    if ok_dap then
                        local ok_jdtls, jdtls = pcall(require, "jdtls")
                        if ok_jdtls then
                            pcall(jdtls.setup_dap, { hotcodereplace = "auto", config_overrides = {} })
                            require("jdtls.dap").setup_dap_main_class_configs()

                            local ok_setup, jdtls_setup = pcall(require, "jdtls.setup")
                            if ok_setup then
                                jdtls_setup.add_commands()
                            end
                        end
                    else
                        vim.notify("Problem with dap of Java", vim.log.levels.WARN)
                    end
                end
            end
        end,
    },
}
