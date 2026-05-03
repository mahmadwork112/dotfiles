return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    "folke/snacks.nvim",
  },

  config = function()
    vim.o.autoread = true

    local opencode = require("opencode")

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      opencode.ask("@this: ", { submit = true })
    end, { desc = "Opencode: Ask" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      opencode.select()
    end, { desc = "Opencode: Select Action" })

    vim.keymap.set({ "n", "t" }, "<leader>ot", function()
      opencode.toggle()
    end, { desc = "Opencode: Toggle Window" })
  end,
}
