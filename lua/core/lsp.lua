--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
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

-- Signcolumn Diagnostic icons
for name, icon in pairs(require("core.icons").diagnostics) do
  local sign_name = "DiagnosticSign" .. name
  local hl_name = "Diagnostic" .. name
  vim.fn.sign_define(sign_name, { text = icon, texthl = hl_name, numhl = "" })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup({ ui = { border = "rounded" } })
require("mason-lspconfig").setup()

-- Enable the following language servers
local servers = {
  clangd = {
    cmd = {
      "clangd",
      "--all-scopes-completion",
      "--background-index",
      "--clang-tidy",
      "--compile_args_from=filesystem", -- lsp-> does not come from compie_commands.json
      "--completion-parse=always",
      "--completion-style=bundled",
      "--cross-file-rename",
      "--debug-origin",
      "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
      "--fallback-style=Qt",
      "--folding-ranges",
      "--function-arg-placeholders",
      "--header-insertion=iwyu",
      "--pch-storage=memory", -- could also be disk
      "--suggest-missing-includes",
      "-j=4",              -- number of workers
      -- "--resource-dir="
      "--log=error",
      --[[ "--query-driver=/usr/bin/g++", ]]
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "h" },
    single_file_support = true,
    init_options = {
      compilationDatabasePath = vim.fn.getcwd() .. "/build",
    },
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    -- commands = {},
  },
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
    if server_name == "rust_analyzer" then
      return
    end
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end,
})

-- rust_analyzer
require("rustaceanvim")
vim.g.rustaceanvim = {
  server = {
    on_attach = on_attach,
  },
}

-- Given the linter and formatter list, extract a list of all tools that need to be installed
local function mason_autoinstall(linters, formatters, debuggers, ignore)
  local linter_list = vim.tbl_flatten(vim.tbl_values(linters))
  local formatter_list = vim.tbl_flatten(vim.tbl_values(formatters))
  local tools = vim.list_extend(linter_list, formatter_list)
  vim.list_extend(tools, debuggers)

  -- only unique tools
  table.sort(tools)
  tools = vim.fn.uniq(tools)

  -- remove exceptions not to install
  tools = vim.tbl_filter(function(tool)
    return not vim.tbl_contains(ignore, tool)
  end, tools)
  return tools
end

local formatters = {
  -- javascript = { "biome" },
  -- typescript = { "biome" },
  -- json = { "biome" },
  -- jsonc = { "biome" },
  lua = { "stylua" },
  python = { "isort", "black" },
  -- yaml = { "prettier" },
  -- html = { "prettier" },
  -- markdown = {
  --   "markdown-toc",
  --   "markdownlint",
  -- },
  sh = { "shellcheck", "shfmt" },
  -- bib = { "trim_whitespace", "bibtex-tidy" },
  -- ["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
  -- ["*"] = { "codespell" },
}

local linters = {}
local debuggers = {}
local dont_install = {}
-- not real formatters, but pseudo-formatters from conform.nvim
-- {
-- "trim_whitespace",
-- "trim_newlines",
-- "squeeze_blanks",
-- "injected",
-- }

require("mason-null-ls").setup({
  ensure_installed = mason_autoinstall(linters, formatters, debuggers, dont_install),
  automatic_installation = false,
})

require("conform").setup({ formatters_by_ft = formatters })
