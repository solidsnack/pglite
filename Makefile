tests := $(wildcard test/??-*)

.PHONY: test
test: test-setup $(tests:test/%=test//run//%)

.PHONY: test-setup
test-setup:
	@rm -rf tmp/test/
	mkdir -p tmp/test/

test//run//%: test/%
	@echo --- starting: $^ >&2
	$^ 2>&1 > tmp/$^
	@echo --- succeeded: $^ >&2

