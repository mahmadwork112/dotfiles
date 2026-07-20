return {
  -- 1. Prevent LazyVim from auto-starting a duplicate, generic dartls instance
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {
          autostart = false, -- Handled entirely by flutter-tools instead
        },
      },
    },
  },

  -- 2. Your modified flutter-tools setup
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      -- Automatically hook into LazyVim's auto-completion capabilities (handles blink.cmp or nvim-cmp)
      local capabilities = {}
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities()
      else
        local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = cmp_lsp.default_capabilities()
        end
      end

      require("flutter-tools").setup({
        lsp = {
          capabilities = capabilities,
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
  },
}
