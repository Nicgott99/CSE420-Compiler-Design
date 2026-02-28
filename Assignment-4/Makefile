# CSE420 Assignment 4 - Makefile
# Compiles intermediate code generator with three-address code generation

# Compiler and tools
CC     = g++
FLEX   = flex
BISON  = bison
CFLAGS = -fpermissive -w

# Directories
SRCDIR  = src
INCDIR  = include
TESTDIR = test-cases

# Source files
LEX_FILE  = $(SRCDIR)/22101371.l
YACC_FILE = $(SRCDIR)/22101371.y

# Generated intermediate files
LEX_OUTPUT  = lex.yy.c
YACC_OUTPUT = y.tab.c
YACC_HEADER = y.tab.h
YACC_DEBUG  = y.output

# Target executable
TARGET = compiler

# Include path
INCLUDES = -I$(INCDIR)

# Default target
.PHONY: all
all: $(TARGET)

# Build the compiler in two steps: object files then link
$(TARGET): $(LEX_OUTPUT) $(YACC_OUTPUT)
	$(CC) $(CFLAGS) $(INCLUDES) -c -o y.o $(YACC_OUTPUT)
	$(CC) $(CFLAGS) $(INCLUDES) -c -o l.o $(LEX_OUTPUT)
	$(CC) -o $@ y.o l.o

# Generate parser (requires -d for header, --debug for verbose output)
$(YACC_OUTPUT) $(YACC_HEADER): $(YACC_FILE)
	$(BISON) -d -y --debug --verbose $(YACC_FILE)

# Generate lexer (depends on the Bison header)
$(LEX_OUTPUT): $(LEX_FILE) $(YACC_HEADER)
	$(FLEX) $(LEX_FILE)

# Run the test case
.PHONY: test
test: $(TARGET)
	@echo "===== Running Test Case ====="
	./$(TARGET) < $(TESTDIR)/input.c

# Clean generated files
.PHONY: clean
clean:
	rm -f $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER) y.o l.o $(TARGET)
	rm -f $(YACC_DEBUG)
	rm -f 22101371_tac.txt

# Remove all generated files including executables
.PHONY: distclean
distclean: clean
	rm -f *.output
	rm -f *.tab.*

# Display help
.PHONY: help
help:
	@echo "CSE420 Assignment 4: Intermediate Code Generation"
	@echo "Usage:"
	@echo "  make          - Build the compiler (default)"
	@echo "  make test     - Compile and run test case"
	@echo "  make clean    - Remove intermediate (generated) files"
	@echo "  make distclean- Remove all generated files including executable"
	@echo "  make help     - Display this help message"

.PHONY: all
