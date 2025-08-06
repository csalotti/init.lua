vim.lsp.config("basedpyright", {
	settings = {
		python = { pythonPath = vim.fn.exepath("python3") },
		basedpyright = { disableOrganizeImports = true, analysis = { typeCheckingMode = "standard" } },
	},
})
