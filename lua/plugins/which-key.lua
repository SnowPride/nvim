return {
  "folke/which-key.nvim",
  opts = {
    preset = "modern",
    icons = { mappings = false, group = "", keys = { Space = "" }, breadcrumb = "" },
    win = { border = "rounded" },
    spec = {
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug" },
      { "<leader>g", group = "Git" },
      { "<leader>j", group = "Jupyter" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Trouble" },
      { "<leader>w", group = "Workspace" },
    },
  },
}
