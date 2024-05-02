return {
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      floating_window = false,
      hint_prefix = " ",
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "sindrets/diffview.nvim",
    opts = {},
  },
  {
    "vladdoster/remember.nvim",
    config = function()
      require("remember")
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup()
      require("telescope").load_extension("projects")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = "<c-t>",
      persist_mode = false,
      shade_terminals = false,
      -- direction = "float",
      float_opts = {
        border = "curved",
      },
      on_create = function()
        pcall(function()
          vim.cmd(":PinBuftype")
        end)
      end,
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        keyword = "fg",
        pattern = [[(KEYWORDS)\s*(\([^\)]*\))?:]],
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_preview = false,
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "laytan/cloak.nvim",
    opts = {},
  },
}
