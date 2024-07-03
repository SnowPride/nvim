require("which-key").register({
  ["<leader>j"] = { name = "Jupyter", _ = "which_key_ignore", mode = { "n", "v" } },
})

require("which-key").register({
  ["<leader>t"] = { name = "Trouble", _ = "which_key_ignore", mode = { "n", "v" } },
})
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<cr>", { desc = "Open quickfix list with all the TODOs" })
vim.keymap.set(
  "n",
  "<leader>td",
  "<cmd>TroubleToggle document_diagnostics<cr>",
  { desc = "Toggle Trouble for the current file" }
)
vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle todo<cr>", { desc = "Toggle TODOs for the current file" })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- vim.keymap.set("n", "<leader>h", "<cmd>Dashboard<cr>", { desc = "Go to homepage" })
