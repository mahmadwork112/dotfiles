return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1500, -- Forces it to load after dankcolors
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat",
          "NemoTreeNormal",
          "NeoTreeNormalNC",
          "BufferLineBackground",
          "BufferLineFill",
        },
      })
    end,
  },
}
