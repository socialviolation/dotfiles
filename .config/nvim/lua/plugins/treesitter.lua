return {
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