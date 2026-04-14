return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      handlers = {},
      ensure_installed = {
        "delve",
        "python",
        "cppdbg",
      },
    })

    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      -- WARNING: Only for linux
      command = vim.env.HOME .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
    }

    dap.configurations.cpp = {
      {
        name = "Test Launch",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set("n", "<leader>dp", dap.continue, { desc = "Start/Continue" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Set Breakpoint" })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<leader>dl", dapui.toggle, { desc = "See last session result." })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Install golang specific config
    require("dap-go").setup({
      dap_configurations = {
        {
          name = "Attach remote",
          type = "go",
          request = "attach",
          mode = "remote",
          connect = {
            host = "127.0.0.1",
            port = "40000",
          },
          cwd = "${workspaceFolder}",
          trace = "verbose",
          apiVersion = "2",
          -- Might need
          -- substitutePath = {
          -- 	{ from = "${workspaceFolder}", to = "/app" },
          -- },
        },
      },
      delve = {
        type = "server",
        port = "40000",
      },
    })

    -- Don't start dlv if debugging remotely
    -- dap.adapters.go = {
    -- 	type = "server",
    -- 	port = "40000",
    -- }
  end,
}
