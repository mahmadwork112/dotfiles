return {
  "tpope/vim-fugitive",
  cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite" }, -- lazy-load these commands
  keys = {
    { "<Leader>gg", "<cmd>Git<cr>", desc = "Open Fugitive" },
  },
}
