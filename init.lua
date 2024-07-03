require("core.options")

-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  {
    -- Core plugins
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "felipec/vim-sanegx",
    "Lun4m/nvim-ansible",
    -- "mfussenegger/nvim-ansible",
    -- "b0o/schemastore.nvim",
    {
      "mrcjkb/rustaceanvim",
      version = "^4",
      ft = { "rust" },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
        "folke/neodev.nvim",
      },
      opts = function(_, opts)
        require("lspconfig.ui.windows").default_options.border = "rounded"
        return opts
      end,
      config = function() end,
    },
    {
      "jay-babu/mason-null-ls.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
      },
    },
    {
      "stevearc/conform.nvim",
      opts = {},
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "rafamadriz/friendly-snippets",
      },
    },
    {
      "folke/which-key.nvim",
      opts = { window = { border = "rounded" } },
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          cond = function()
            return vim.fn.executable("make") == 1
          end,
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      build = ":TSUpdate",
    },

    { import = "core.debug" },
    -- Extra plugins
    { import = "custom.plugins" },
  },
  -- lazy.nvim options
  {
    ui = {
      border = "rounded",
    },
  }
)

require("core.keymaps")
require("core.autocommands")
require("core.telescope")
require("core.treesitter")
require("core.lsp")
require("core.cmp")

-- Separate custom plugin keymap
require("custom.keymaps")

-- document existing key chains
require("which-key").register({
  ["<leader>b"] = { name = "Buffer", _ = "which_key_ignore" },
  ["<leader>c"] = { name = "Code", _ = "which_key_ignore", mode = { "n", "v" } },
  ["<leader>d"] = { name = "Debug", _ = "which_key_ignore" },
  ["<leader>g"] = { name = "Git", _ = "which_key_ignore" },
  ["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
  ["<leader>w"] = { name = "Workspace", _ = "which_key_ignore" },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
