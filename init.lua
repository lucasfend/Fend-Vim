-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.fn.serverstart("/tmp/nvim-" .. vim.fn.getpid() .. ".sock")
