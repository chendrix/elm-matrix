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

TestRunner.elm = test/TestRunner.elm
Test.html = $(BUILD_DIR)/test.html
test: $(Test.html)
$(Test.html): $(TestRunner.elm)
	$(CC) $(TestRunner.elm) --output $(Test.html)

test/open: clean test
	$(OPEN) $(Test.html)

