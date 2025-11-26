return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- 1. CAMINHOS MANUAIS (Fix para Fedora 43/Mason)
      local mason_root = vim.fn.stdpath("data") .. "/mason"
      local bundles = {}

      -- Busca Debug Adapter
      local debug_path = mason_root
        .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
      local debug_jar = vim.fn.glob(debug_path, true)
      if debug_jar ~= "" then
        table.insert(bundles, debug_jar)
      end

      -- Busca Java Test
      local test_path = mason_root .. "/packages/java-test/extension/server/*.jar"
      local test_jars = vim.fn.glob(test_path, true, true)
      if #test_jars > 0 then
        vim.list_extend(bundles, test_jars)
      end

      -- 2. INJETA OS BUNDLES
      opts.init_options = opts.init_options or {}
      opts.init_options.bundles = bundles

      -- 3. ON_ATTACH (Configura o Debug se ele existir)
      local original_on_attach = opts.on_attach
      opts.on_attach = function(client, buffer)
        if original_on_attach then
          original_on_attach(client, buffer)
        end

        if client.name == "jdtls" then
          -- Tenta carregar o dap de forma segura
          local ok_dap, _ = pcall(require, "dap")

          if ok_dap then
            -- Se o dap existe, configura o Java Debug
            local ok_jdtls, jdtls = pcall(require, "jdtls")
            if ok_jdtls then
              pcall(jdtls.setup_dap, { hotcodereplace = "auto", config_overrides = {} })
              require("jdtls.dap").setup_dap_main_class_configs()

              -- CRIA OS COMANDOS (:JdtTestClass)
              local ok_setup, jdtls_setup = pcall(require, "jdtls.setup")
              if ok_setup then
                jdtls_setup.add_commands()
              end
            end
          else
            vim.notify("⚠️ O plugin 'nvim-dap' não foi carregado. Debug/Testes desativados.", vim.log.levels.WARN)
          end
        end
      end
    end,
  },
}
