return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      lsp = {
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisServerLineStartAt1 = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
    })
  end,
}
