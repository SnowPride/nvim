return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  opts = {
    preview_config = { border = "rounded" },
    signs = {
      add = { text = "▌" },
      change = { text = "▌" },
      delete = { text = "▌" },
      topdelete = { text = "▌" },
      changedelete = { text = "▌" },
      untracked = { text = "▌" },
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      local function nav_hunk(direction)
        return function()
          gitsigns.nav_hunk(direction)
        end
      end

      map("n", "<leader>gj", nav_hunk("next"), { desc = "Jump to next hunk" })
      map("n", "<leader>gk", nav_hunk("prev"), { desc = "Jump to previous hunk" })
      map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview git hunk" })
      map("n", "<leader>gb", gitsigns.blame_line, { desc = "Toggle blame on current line" })
      map("n", "<leader>gf", gitsigns.blame, { desc = "Blame whole file" })
    end,
  },
}
