return {
  -- Import LazyVim language extras
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Ensure all Treesitter parsers are installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Go
        "go",
        "gomod",
        "gowork",
        "gosum",

        -- Python
        "python",
        "toml",
        "requirements",

        -- TypeScript/JavaScript/Node
        "typescript",
        "javascript",
        "tsx",
        "jsx",
        "jsdoc",
        "json",
        "jsonc",
        "html",
        "css",
      })
    end,
  },
}