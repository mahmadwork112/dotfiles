-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Exit insert mode after saving",
  callback = function()
    -- Check if we are currently in insert mode or replace mode
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" or mode == "ic" or mode == "ix" or mode == "R" then
      vim.cmd("stopinsert")
    end
  end,
})
