-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Buffer delete and move to previous
vim.keymap.set("n", "W", function()
  require("bufferline.commands").cycle(-1)
  vim.cmd("bd #")
end, { desc = "Delete buffer and go to previous" })
-- Unbind arrow keys in normal and visual modes (but allow in insert mode)
vim.keymap.set({ "n", "v" }, "<Up>", "<Nop>", { desc = "Disable up arrow" })
vim.keymap.set({ "n", "v" }, "<Down>", "<Nop>", { desc = "Disable down arrow" })
vim.keymap.set({ "n", "v" }, "<Left>", "<Nop>", { desc = "Disable left arrow" })
vim.keymap.set({ "n", "v" }, "<Right>", "<Nop>", { desc = "Disable right arrow" })

-- Move visual selection up/down with Shift+J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
