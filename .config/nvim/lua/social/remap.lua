vim.g.mapleader = " "

-- set in normal mode, pressing PV (project view) executes the :Ex (netrw)
vim.keymap.set("n", "<leader>nt", "<cmd>Neotree toggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd>Neotree reveal<CR>")
vim.keymap.set("n", "<leader>ng", "<cmd>Neotree float git_status<CR>")
vim.keymap.set("n", "<leader>c/", "<cmd>noh<CR>")
-- Visual mode, if highlighted, move lines up and down 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- N mode, keep cursor in location while half page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- N mode, keep cursor centered while iterating searches
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- don't replace buffer while overwrite pasting
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Quick Fix list
vim.keymap.set("x", "<leader>w", "<cmd>w<CR>")

-- Leader yank, copies to system clipboard instead of vim buffer
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- dont' deleting to void register (vim buffer)
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- capital q can die?
vim.keymap.set("n", "Q", "<nop>")

-- Quick Fix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- rename currently highlighted symbol
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make current file executable. 
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Custom nick
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- setup neotree as default & disable netrw
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1
vim.api.nvim_create_autocmd("VimEnter", {
    command = "set nornu nonu | Neotree toggle",
})
vim.api.nvim_create_autocmd("BufEnter", {
    command = "set rnu nu",
})
