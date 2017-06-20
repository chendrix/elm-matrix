CC = elm make
PACKAGE = elm package
INSTALL = install
SRC = src
TEST = test
OPEN = open
NODE = node
BASH = bash
ROOT = ..

PACKAGE_FLAGS = -y

BUILD_DIR = build
RESOURCES_DIR = resources

clean:
	rm -rf $(BUILD_DIR)

#### TEST ####################

TestRunner.elm = $(ROOT)/test/TestRunner.elm
Test.html = $(BUILD_DIR)/test.html
test: $(Test.html)
$(Test.html): $(TestRunner.elm)
	$(CC) $(TestRunner.elm) --output $(Test.html)

test/open: clean test
	$(OPEN) $(Test.html)
