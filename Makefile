NM=node_modules
NM_BIN=$(NM)/.bin

LODASH_LIB=$(NM)/lodash/dist/lodash.min.js

SP=.serve.pid
CP=.watch.pid

COFFEE=$(wildcard *.coffee)
JS=$(COFFEE:.coffee=.js)
%.js: %.coffee
	$(NM_BIN)/coffee -c $<

all: $(JS)

node_modules:
	npm install
	cp $(LODASH_LIB) .

run_server:
	$(NM_BIN)/serve & echo "$$!" > $(SP)
kill_server:
	kill $(shell cat $(SP))
	rm $(SP)

run_watch:
	$(NM_BIN)/coffee -cw . & echo "$$!" > $(CP)
kill_watch:
	kill $(shell cat $(CP))
	rm $(CP)

clean:
	rm -f $(JS)

mrproper: clean
	rm -rf $(NM)

.PHONY: node_modules run_server kill_server run_watch kill_watch clean mrproper
