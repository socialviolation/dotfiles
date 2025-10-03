-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Buffer delete and move to previous
vim.keymap.set("n", "W", function()
  require("bufferline.commands").cycle(-1)
  vim.cmd("bd #")
end, { desc = "Delete buffer and go to previous" })
