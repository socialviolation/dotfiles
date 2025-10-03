return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Override the default find_files to include hidden files by default
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Find Files (including hidden)",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-h>"] = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            require("telescope.builtin").find_files({
              hidden = true,
              default_text = line,
            })
          end,
        },
        n = {
          ["<C-h>"] = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            require("telescope.builtin").find_files({
              hidden = true,
              default_text = line,
            })
          end,
        },
      },
    },
  },
}