--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
	nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
	nmap("gd", require("telescope.builtin").lsp_definitions, "Goto definition")
	nmap("gr", require("telescope.builtin").lsp_references, "Goto references")
	nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace add folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace remove folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "Workspace list folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	nmap("<leader>cf", "<cmd>Format<cr>", "Format current buffer with LSP")
end

-- Sign icons
for name, icon in pairs(require("core.icons").diagnostics) do
	local sign_name = "DiagnosticSign" .. name
	local hl_name = "Diagnostic" .. name
	vim.fn.sign_define(sign_name, { text = icon, texthl = hl_name, numhl = "" })
end

-- local opts = require("lspconfig").opts
-- local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
--
-- if opts.inlay_hints.enabled and inlay_hint then
-- 	require("core.lsp").on_attach(function(client, buffer)
-- 		if client.supports_method("textDocument/inlayHint") then
-- 			inlay_hint(buffer, true)
-- 		end
-- 	end)
-- end
--
-- if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
-- 	opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
-- 		or function(diagnostic)
-- 			local icons = require("core.icons").diagnostics
-- 			for d, icon in pairs(icons) do
-- 				if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
-- 					return icon
-- 				end
-- 			end
-- 		end
-- end
-- vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
local servers = {
	clangd = {},
	-- golsp = {},
	pyright = {},
	rust_analyzer = {},
	-- tsserver = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})
