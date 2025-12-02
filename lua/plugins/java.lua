return {
    {
        "mfussenegger/nvim-jdtls",
        init = function()
            vim.api.nvim_set_hl(0, "SpringBeanDef", { fg = "#6DB33F" })
            vim.api.nvim_set_hl(0, "SpringBeanInj", { fg = "#C5E478" })

            vim.fn.sign_define("SpringBean", { text = "󰛨", texthl = "SpringBeanDef", linehl = "", numhl = "" })
            vim.fn.sign_define("SpringInjection", { text = "", texthl = "SpringBeanInj", linehl = "", numhl = "" })

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged" }, {
                pattern = "*.java",
                callback = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    if vim.bo[bufnr].filetype ~= "java" then
                        return
                    end

                    vim.fn.sign_unplace("SpringGroup", { buffer = bufnr })

                    local query_string = [[
                        (marker_annotation
                            name: (identifier) @name
                            (#any-of? @name "Component" "Service" "Repository" "Controller" "RestController" "Configuration" "Bean")
                        ) @bean_def

                        (field_declaration
                            (modifiers
                                (marker_annotation name: (identifier) @inj_name)
                            )
                            (#any-of? @inj_name "Autowired" "Inject")
                        ) @bean_inj

                        (field_declaration
                            (modifiers) @mods
                            type: (type_identifier)
                            (#match? @mods "private")
                            (#match? @mods "final")
                            (#not-match? @mods "static")
                        ) @bean_inj
                    ]]

                    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "java")
                    if not ok or not parser then
                        return
                    end
                    local tree = parser:parse()[1]
                    local root = tree:root()
                    local query = vim.treesitter.query.parse("java", query_string)

                    for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
                        local capture_name = query.captures[id]
                        local row, _, _, _ = node:range()

                        local sign_name = "SpringBean"
                        if capture_name == "bean_inj" then
                            sign_name = "SpringInjection"
                        end

                        vim.fn.sign_place(0, "SpringGroup", sign_name, bufnr, { lnum = row + 1, priority = 10 })
                    end
                end,
            })
        end,
        opts = function(_, opts)
            local mason_root = vim.fn.stdpath("data") .. "/mason"
            local bundles = {}

            local spring_boot_path = mason_root .. "/packages/spring-boot-tools/extension/language-server/*.jar"
            local spring_boot_jars = vim.fn.glob(spring_boot_path, true, true)

            if #spring_boot_jars == 0 then
                spring_boot_path = mason_root .. "/packages/vscode-spring-boot-tools/extension/language-server/*.jar"
                spring_boot_jars = vim.fn.glob(spring_boot_path, true, true)
            end

            if #spring_boot_jars > 0 then
                vim.list_extend(bundles, spring_boot_jars)
            end

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
