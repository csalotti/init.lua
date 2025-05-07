return {
	settings = {
		python = {
			pythonPath = "./venv/bin/python",
		},
		basedpyright = {
			-- Using Ruff's import organizer
                        disableOrganizeImports = true,
                        analysis = {
                            typeCheckingMode = "basic"
                        },
                },
        },
}
