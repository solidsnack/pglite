test:
	@rm -rf tmp
	@mkdir -p tmp
	cd tmp/ && ../pglite setup
	cd tmp/ && ../pglite connect -v ON_ERROR_STOP=on -c 'SELECT TRUE'
	cd tmp/ && ../pglite clean
	@rm -rf tmp

install:
	cp -a pglite /usr/local/bin/

