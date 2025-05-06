return {
	cmd = { '/Users/sam.neirinck/Code/github.com/amgdev9/kotlin-lsp/app/build/install/app/bin/app' },
	-- cmd = { '/Users/sam.neirinck/Code/github.com/samneirinck/coalesce/build/install/coalesce/bin/coalesce' },
	cmd_env = {
		JAVA_OPTS = '-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:9005'
	},
	root_markers = { 'build.gradle', 'build.gradle.kts' },
	filetypes = { 'kotlin' },
}
