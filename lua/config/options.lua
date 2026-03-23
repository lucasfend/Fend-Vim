-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- JAVA OPTIONS
local java_home = "/home/fendvim/.sdkman/candidates/java/21.0.9-jbr"
vim.env.JAVA_HOME = java_home
vim.env.PATH = java_home .. "/bin:" .. vim.env.PATH

-- IDENTATION STUFF
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.autoformat = true

vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#81A1C1" })
