return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- This ensures our keymaps are set after LazyVim's defaults
    },
    config = function()
      -- Buffer delete and move to previous - override W
      vim.keymap.set("n", "W", function()
        vim.cmd("bprevious | bd #")
      end, { desc = "Delete buffer and go to previous", noremap = true })
    end,
  },
}