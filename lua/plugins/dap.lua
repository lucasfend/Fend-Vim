return {
  {
    "mfussenegger/nvim-dap",
    lazy = false, -- Força o carregamento no início
    -- AQUI ESTÁ A CORREÇÃO DO CRASH:
    -- Definimos uma função de config vazia para impedir que o Lazy
    -- tente chamar require('dap').setup(), que não existe.
    config = function() end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      -- Listeners para abrir/fechar a UI automaticamente
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
