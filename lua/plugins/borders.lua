-- Set plugin border style
local border_style = "rounded"

return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      local bordered = require("cmp.config.window").bordered
      return vim.tbl_deep_extend("force", opts, {
        window = {
          completion = bordered(border_style),
          documentation = bordered(border_style),
        },
      })
    end,
  },
  {
    "which-key.nvim",
    opts = { window = { border = border_style } },
  },
  {
    "gitsigns.nvim",
    opts = { preview_config = { border = border_style } },
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      require("lspconfig.ui.windows").default_options.border = border_style
      return opts
    end,
  },
  {
    "mason.nvim",
    opts = {
      ui = { border = border_style },
    },
  },
}
