require("which-key").register({
  ["<leader>j"] = { name = "Jupyter", _ = "which_key_ignore", mode = { "n", "v" } },
})

require("which-key").register({
  ["<leader>t"] = { name = "Todo", _ = "which_key_ignore", mode = { "n", "v" } },
})
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<cr>", { desc = "Open quickfix list with all the TODOs" })
vim.keymap.set(
  "n",
  "<leader>td",
  "<cmd>TroubleToggle document_diagnostics<cr>",
  { desc = "Toggle Trouble for the current file" }
)
vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle todo<cr>", { desc = "Toggle Trouble for the current file" })
