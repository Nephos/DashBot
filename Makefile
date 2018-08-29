NAME=`ls -d src/*/ | cut -f2 -d'/'`

all: deps_opt build

run:
	crystal run src/$(NAME).cr
build:
	crystal build src/$(NAME).cr --stats
release:
	crystal build src/$(NAME).cr --stats --release
test:
	crystal spec
deps:
	shards install
deps_update:
	shards update
deps_opt:
	@[ -d lib/ ] || make deps
doc:
	crystal docs

.PHONY: all run build release test deps deps_update doc
