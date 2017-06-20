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
