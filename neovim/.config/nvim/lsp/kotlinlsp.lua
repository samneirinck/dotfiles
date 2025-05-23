return {
	cmd = { 'kotlin-ls', '--stdio' },
	single_file_support = true,
	root_markers = { 'build.gradle', 'build.gradle.kts', 'pom.xml' },
	filetypes = { 'kotlin' },
}
