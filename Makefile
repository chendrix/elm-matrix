CC = elm make
PACKAGE = elm package
INSTALL = install
SRC = src
TEST = test
OPEN = open
NODE = node
BASH = bash

PACKAGE_FLAGS = -y

BUILD_DIR = build
RESOURCES_DIR = resources

all: package/install clean compile

Index.html = index.html
open: all $(Index.html)
	$(OPEN) $(Index.html)

compile: matrix

Matrix = Matrix
Matrix.js = $(BUILD_DIR)/$(Matrix).js
Matrix.elm = $(SRC)/$(Matrix).elm
matrix: $(Matrix.js)
$(Matrix.js): $(Matrix.elm)
	$(CC) --output $(Matrix.js) $(Matrix.elm)

clean:
	rm -rf $(BUILD_DIR)

package/install:
	$(PACKAGE) $(INSTALL) $(PACKAGE_FLAGS)

#### TEST ####################

$(RESOURCES_DIR):
	mkdir -p $(RESOURCES_DIR)

test/bootstrap:
	npm install jsdom

ElmIo.sh = $(RESOURCES_DIR)/elm-io.sh
test/install: $(ElmIo.sh)
$(ElmIo.sh): $(RESOURCES_DIR)
	curl https://raw.githubusercontent.com/maxsnew/IO/1.0.1/elm-io.sh > $(ElmIo.sh)

TestRunner.elm = TestRunner.elm
RawTest.js = $(BUILD_DIR)/raw-test.js
Test.js = $(BUILD_DIR)/test.js
test/before: $(Test.js)
$(Test.js): $(TestRunner.elm) $(ElmIo.sh)
	$(CC) $(TestRunner.elm) --output $(RawTest.js)
	bash $(ElmIo.sh) $(RawTest.js) $(Test.js)

test: $(Test.js)
	$(NODE) $(Test.js)


#### TRAVIS ###################

travis/install: test/bootstrap
	npm install --global elm

travis/before: $(Test.js)
