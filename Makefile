.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	mangacore-wallet-client.min.js

clean:
	rm mangacore-wallet-client.js
	rm mangacore-wallet-client.min.js

mangacore-wallet-client.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@

mangacore-wallet-client.min.js: mangacore-wallet-client.js
	uglify  -s $<  -o $@

cover:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- --reporter spec test
