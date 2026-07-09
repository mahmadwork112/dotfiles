return {
  "ojroques/nvim-osc52",
  config = function()
    require("osc52").setup({
      max_len = 0, -- No limit on the length of text you can copy
      silent = true, -- Don't show a message every time you copy
    })

    -- Define a custom function to handle copying
    local function copy()
      if vim.v.event.operator == "y" then
        require("osc52").copy_register("+")
      end
    end

    -- Trigger the copy function automatically whenever text is yanked
    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = copy,
    })
  end,
}
