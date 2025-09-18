require("lazy").setup({
	defaults = {
		lazy = true,
	},
	dev = {
		-- reuse files from pkgs.vimPlugins.*
		path = "<lazyPath>",
		patterns = { "." },
		-- fallback to download
		fallback = true,
	},
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

		-- LazyVim Extras
		{ import = "lazyvim.plugins.extras.dap.core" },

		{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },

		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.java" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },
		{ import = "lazyvim.plugins.extras.lang.php" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.lang.tex" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },

		-- The following configs are needed for fixing lazyvim on nix

		-- disable mason.nvim, use programs.neovim.extraPackages
		{ "mason-org/mason-lspconfig.nvim", enabled = false },
		{ "mason-org/mason.nvim", enabled = false },

		-- import/override with your plugins
		{ import = "plugins" },

		-- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
		{
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				opts.ensure_installed = {}
			end,
		},
	},
})
