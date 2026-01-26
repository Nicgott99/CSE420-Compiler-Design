# CSE420 Assignment 2 - Makefile
# Compiles lexical and syntax analyzer for C-like language

# Compiler and flags
CC = g++
FLEX = flex
BISON = bison
CFLAGS = -std=c++14 -Wall -Wextra -O2

# Directories
SRCDIR = src
INCDIR = include
TESTDIR = test-cases
OUTPUTDIR = output

# Source files
LEX_FILE = $(SRCDIR)/lex_analyzer.l
YACC_FILE = $(SRCDIR)/syntax_analyzer.y

# Generated files
LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = y.tab.c
YACC_HEADER = y.tab.h

# Target executable
TARGET = compiler

# Include path
INCLUDES = -I$(INCDIR)

# Default target
all: $(TARGET)

# Build the compiler
$(TARGET): $(LEX_OUTPUT) $(YACC_OUTPUT)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $^

# Generate lexer
$(LEX_OUTPUT): $(LEX_FILE) $(YACC_HEADER)
	$(FLEX) $(LEX_FILE)

# Generate parser
$(YACC_OUTPUT) $(YACC_HEADER): $(YACC_FILE)
	$(BISON) -d $(YACC_FILE)

# Create output directory
$(OUTPUTDIR):
	mkdir -p $(OUTPUTDIR)

# Test targets
test: $(TARGET) $(OUTPUTDIR)
	@echo "Running test cases..."
	@for i in 1 2 3; do \
		echo "Testing input$$i.c..."; \
		./$(TARGET) $(TESTDIR)/input$$i.c > $(OUTPUTDIR)/output$$i.txt 2>&1; \
		cp my_log.txt $(OUTPUTDIR)/log$$i.txt; \
	done
	@echo "Test results saved in $(OUTPUTDIR)/"

# Test individual files
test1: $(TARGET) $(OUTPUTDIR)
	./$(TARGET) $(TESTDIR)/input1.c
	cp my_log.txt $(OUTPUTDIR)/log1.txt

test2: $(TARGET) $(OUTPUTDIR)
	./$(TARGET) $(TESTDIR)/input2.c
	cp my_log.txt $(OUTPUTDIR)/log2.txt

test3: $(TARGET) $(OUTPUTDIR)
	./$(TARGET) $(TESTDIR)/input3.c
	cp my_log.txt $(OUTPUTDIR)/log3.txt

# Clean generated files
clean:
	rm -f $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER)
	rm -f $(TARGET)
	rm -f my_log.txt
	rm -rf $(OUTPUTDIR)

# Clean all including backup files
distclean: clean
	rm -f *~ $(SRCDIR)/*~ $(INCDIR)/*~ $(TESTDIR)/*~

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Build the compiler (default)"
	@echo "  test     - Run all test cases"
	@echo "  test1    - Run test case 1"
	@echo "  test2    - Run test case 2" 
	@echo "  test3    - Run test case 3"
	@echo "  clean    - Remove generated files"
	@echo "  distclean- Remove all generated and backup files"
	@echo "  help     - Show this help message"

# Phony targets
.PHONY: all test test1 test2 test3 clean distclean help

# Dependencies
$(LEX_FILE): $(INCDIR)/symbol_info.h
$(YACC_FILE): $(INCDIR)/symbol_table.h $(INCDIR)/scope_table.h $(INCDIR)/symbol_info.h