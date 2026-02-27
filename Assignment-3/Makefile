# CSE420 Assignment 3 - Makefile
# Compiles semantic analyzer with symbol table and scope management

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
	@echo "Running test case (test-cases/input.c)..."
	./$(TARGET) $(TESTDIR)/input.c
	@echo ""
	@echo "=== Parse Log ==="
	@cat 22101371_log.txt
	@echo ""
	@echo "=== Error Log ==="
	@cat 22101371_error.txt

# Clean generated files
.PHONY: clean
clean:
	rm -f $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER) $(YACC_DEBUG)
	rm -f y.o l.o
	rm -f $(TARGET)
	rm -f 22101371_log.txt 22101371_error.txt

# Remove everything including backups
.PHONY: distclean
distclean: clean
	rm -f *~ $(SRCDIR)/*~ $(INCDIR)/*~

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all       - Build the compiler (default)"
	@echo "  test      - Build and run the test case"
	@echo "  clean     - Remove generated files"
	@echo "  distclean - Remove all generated and backup files"
	@echo "  help      - Show this help message"

# Header dependencies
$(LEX_FILE):  $(INCDIR)/symbol_info.h
$(YACC_FILE): $(INCDIR)/symbol_info.h $(INCDIR)/scope_table.h $(INCDIR)/symbol_table.h
