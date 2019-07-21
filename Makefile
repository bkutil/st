test:
	./st_test

style:
	diction -s README.md
	style README.md

.PHONY: test style
