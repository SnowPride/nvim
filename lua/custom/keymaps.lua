require("which-key").register({
  ["<leader>j"] = { name = "Jupyter", _ = "which_key_ignore", mode = { "n", "v" } },
})

--Molten
vim.keymap.set(
  "n",
  "<leader>jp",
  "<cmd>MoltenInit python3<cr>",
  { silent = true, noremap = true, desc = "Start Python 3 kernel" }
)
vim.keymap.set(
  "n",
  "<leader>jr",
  "<cmd>MoltenReevaluateCell<cr>",
  { silent = true, noremap = true, desc = "Re-evalute cell" }
)
vim.keymap.set(
  "v",
  "<leader>jc",
  ":<c-u>MoltenEvaluateVisual<cr>gv",
  { silent = true, noremap = true, desc = "Evaluate visual selection" }
)
