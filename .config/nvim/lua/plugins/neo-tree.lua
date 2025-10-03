return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["H"] = "none", -- Disable H in neo-tree to allow Shift+H buffer navigation
        ["."] = "toggle_hidden", -- Use . to toggle hidden files instead
      },
    },
  },
}