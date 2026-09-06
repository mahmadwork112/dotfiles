-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- file saving inside of insert mode
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file and go to normal mode" })

-- lazy-vim like switching tabs.
vim.keymap.set("n", "<S-H>", function() require("astrocore.buffer").nav(-1) end, { desc = "Previous tab/buffer" })
vim.keymap.set("n", "<S-L>", function() require("astrocore.buffer").nav(1) end, { desc = "Next tab/buffer" })
