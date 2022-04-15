.PHONY: format
format:
	@swift format \
		--in-place \
		--ignore-unparsable-files \
		--recursive .
