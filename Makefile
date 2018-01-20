tests := $(wildcard test/core/??-*)
test_core_targets := $(tests:test/core/%=tmp/test/core/%)

.PHONY: test
test: test-setup $(test_core_targets)

.PHONY: test-setup
test-setup:
	@rm -rf tmp/test/ tmp/log/
	mkdir -p tmp/test/ tmp/log/

.PHONY: $(test_core_targets)
$(test_core_targets): tmp/test/core/%: test/core/% test-setup
	@echo --- starting: $< >&2
	@mkdir -p tmp/$< tmp/log/$<
	@cp -a pglite.d/ tmp/$<
	@echo --- in: tmp/$< >&2
	@echo --- log: tmp/log/$</stdio.log >&2
	@( cd tmp/$< && $(realpath $<) 2>&1 ) > tmp/log/$</stdio.log
	@echo +++ succeeded: $< >&2

