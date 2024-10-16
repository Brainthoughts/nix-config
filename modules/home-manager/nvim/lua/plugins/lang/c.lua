return {
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			if not dap.adapters["cppdbg"] then
				dap.adapters["cppdbg"] = {
					id = "cppdbg",
					type = "executable",
					command = "/home/alexn/Documents/cpptools/debugAdapters/bin/OpenDebugAD7",
				}
			end
			for _, lang in ipairs({ "c", "cpp" }) do
				dap.configurations[lang] = {
					{
						name = "Launch file",
						type = "cppdbg",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopAtEntry = true,
					},
					-- {
					-- 	name = "Attach to gdbserver :1234",
					-- 	type = "cppdbg",
					-- 	request = "launch",
					-- 	MIMode = "gdb",
					-- 	miDebuggerServerAddress = "localhost:1234",
					-- 	miDebuggerPath = "/usr/bin/gdb",
					-- 	cwd = "${workspaceFolder}",
					-- 	program = function()
					-- 		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					-- 	end,
					-- },
				}
			end
		end,
	},
}
