#==========================
#|       VARIABLES        |
#==========================
TARGET=apoena
BIN_DIR=bin

CC=gcc
CLANG=clang

CFLAGS=-W
CFLAGS+=-Wall
CFLAGS+=-ansi
CFLAGS+=-pedantic
CFLAGS+=-std=c99
CFLAGS+=-g
CFLAGS+=-Wno-unused-parameter
CFLAGS+=-Wno-implicit-fallthrough

SRC_DIR=src
OBJ_DIR=obj

SRCS = $(shell find $(SRC_DIR) -name '*.c')
OBJS=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

LIB_SRCS = $(shell find $(SRC_DIR)/lib -name '*.c')
LIB_OBJS=$(LIB_SRCS:.c=.o)


TEST_SRCS=$(wildcard test/**/*.c)
TEST_SRCS+=$(wildcard test/*.c)
TEST_OBJS=$(TEST_SRCS:.c=.o)

#==========================
#           MAIN          |
#==========================
all: $(TARGET)

#==========================
#        BUILDING         |
#==========================
$(TARGET): $(OBJS)
	@echo "> Building Apoena"
	@mkdir -p $(BIN_DIR)
	@$(CC) -o $(BIN_DIR)/$@ $^ $(CFLAGS) -O3 -Isrc
	@echo "> Successfully Compiled"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -o $@ -c $< -Isrc

#==========================
#|       UNIT TESTS       |
#==========================

test_target: $(TEST_SRCS) $(LIB_SRCS)
	@echo "-------------------"
	@echo "< Testing Apoena  >"
	@echo "-------------------"
	@mkdir -p $(BIN_DIR)
	@$(CC) -g -o $(BIN_DIR)/$@ $^ $(CFLAGS) -Isrc
	@export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer
	@export ASAN_OPTIONS=detect_leaks=1
	@./$(BIN_DIR)/$@
	@rm $(BIN_DIR)/$@

test: test_target

#==========================
#      CLEAN PROJECT      |
#==========================
clean:
	@rm -rf $(TARGET) $(OBJS) $(BIN_DIR) $(TEST_OBJS)
