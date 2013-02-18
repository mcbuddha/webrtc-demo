NM=node_modules
NM_BIN=$(NM)/.bin
JSLIB=static/js/lib

LODASH_LIB=$(NM)/lodash/dist/lodash.min.js

SP=.serve.pid
CP=.watch.pid

STYLUS=$(wildcard *.styl static/css/*.styl)
CSS=$(STYLUS:.styl=.css)
%.css: %.styl
	$(NM_BIN)/stylus --import static/css/solarized/colors.styl < $< > $@

JADE=$(wildcard *.jade static/html/*.jade)
HTML=$(JADE:.jade=.html)
%.html: %.jade
	$(NM_BIN)/jade < $< --path $< > $@

COFFEE=$(wildcard *.coffee static/js/*.coffee)
JS=$(COFFEE:.coffee=.js)
%.js: %.coffee
	$(NM_BIN)/coffee -c $<

all: $(CSS) $(HTML) $(JS)

node_modules:
	npm install
	cp $(LODASH_LIB) $(JSLIB)

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
	rm -f $(CSS) $(HTML) $(JS)

mrproper: clean
	rm -rf $(NM)
	rm -f $(JSLIB)/*.js

.PHONY: node_modules run_server kill_server run_watch kill_watch clean mrproper
