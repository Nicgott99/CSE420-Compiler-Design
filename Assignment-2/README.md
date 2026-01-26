# Assignment 2: Lexical and Syntax Analysis

## 📋 Overview

This assignment implements a complete lexical and syntax analyzer for a C-like programming language using **Flex** and **Bison**. The analyzer can parse variable declarations, function definitions, control flow statements, and expressions while building a symbol table for scope management.

## 🎯 Learning Objectives

- Implement lexical analysis using regular expressions
- Design context-free grammar for syntax analysis  
- Build symbol table data structures for scope management
- Handle error detection and recovery
- Generate parse trees and semantic analysis output

## 🔧 Components

### 1. Lexical Analyzer (`lex_analyzer.l`)
- **Purpose:** Tokenizes C-like source code into meaningful tokens
- **Features:**
  - Keywords recognition (if, else, for, while, int, float, void, etc.)
  - Operator classification (arithmetic, relational, logical, assignment)
  - Identifier and constant recognition
  - Whitespace and comment handling
  - Line number tracking for error reporting

### 2. Syntax Analyzer (`syntax_analyzer.y`)
- **Purpose:** Parses token streams according to C-like grammar rules
- **Grammar Support:**
  - Variable declarations (int, float, arrays)
  - Function definitions with parameters
  - Control structures (if-else, for, while)
  - Expression evaluation with proper precedence
  - Compound statements and scope blocks

### 3. Symbol Management System

#### `symbol_info.h`
- Basic symbol representation
- Stores name and type information
- Extensible for additional attributes

#### `scope_table.h`  
- Hash table implementation for single scope
- Symbol insertion, lookup, and deletion
- Collision handling with chaining

#### `symbol_table.h`
- Hierarchical scope management  
- Stack-based scope entry/exit
- Cross-scope symbol lookup

## 🏗️ Project Structure

```
Assignment-2/
├── include/                 # Header files
│   ├── symbol_info.h       # Symbol representation
│   ├── scope_table.h       # Single scope management
│   └── symbol_table.h      # Hierarchical scope system
├── src/                    # Source files
│   ├── lex_analyzer.l      # Flex lexical analyzer
│   └── syntax_analyzer.y   # Bison syntax analyzer
├── test-cases/             # Test input files
│   ├── input1.c           # Basic declarations and functions
│   ├── input2.c           # Control flow and scopes
│   └── input3.c           # Complex nested scopes
├── Makefile               # Build configuration
└── README.md             # This documentation
```

## 🚀 Build Instructions

### Prerequisites
- GCC compiler with C++14 support
- Flex (Fast Lexical Analyzer Generator)
- Bison (GNU Parser Generator)
- Make utility

### Compilation
```bash
# Build the compiler
make

# Or build everything explicitly
make all
```

### Testing
```bash
# Run all test cases
make test

# Run specific test cases
make test1    # Basic functionality
make test2    # Control flow 
make test3    # Nested scopes
```

### Cleanup
```bash
# Remove generated files
make clean

# Remove all including backups
make distclean
```

## 📊 Test Cases

### Test Case 1: Basic Functionality
- **File:** `input1.c`
- **Tests:** Variable declarations, arrays, function definition, function calls
- **Focus:** Core lexical and syntax recognition

### Test Case 2: Control Flow
- **File:** `input2.c`  
- **Tests:** Multiple functions, for/while loops, if-else statements
- **Focus:** Control structure parsing and scope management

### Test Case 3: Complex Scoping
- **File:** `input3.c`
- **Tests:** Deep nested if statements, variable shadowing
- **Focus:** Advanced scope handling and symbol resolution

## 📈 Features Implemented

### ✅ Lexical Analysis
- [x] Keyword recognition (18 keywords)
- [x] Operator tokenization (arithmetic, relational, logical)
- [x] Identifier and constant parsing
- [x] Delimiter and punctuation handling
- [x] Error character detection

### ✅ Syntax Analysis  
- [x] Expression parsing with precedence
- [x] Statement and declaration parsing
- [x] Function definition handling
- [x] Control flow statement parsing
- [x] Parse tree generation

### ✅ Symbol Management
- [x] Symbol info data structure
- [x] Hash-based scope tables
- [x] Hierarchical symbol tables
- [x] Scope entry/exit operations

## 🔬 Technical Specifications

### Grammar Features
- **Variables:** int, float, void types with arrays
- **Functions:** Parameter lists, return values, definitions
- **Expressions:** Arithmetic, relational, logical operations
- **Control Flow:** if-else, for, while loops
- **Operators:** Full C-like operator precedence

### Symbol Table Design
- **Hash Function:** Efficient string hashing for symbol lookup
- **Collision Resolution:** Chaining with linked lists
- **Scope Management:** Stack-based scope hierarchy
- **Symbol Attributes:** Name, type, extensible properties

## 🐛 Error Handling

- **Lexical Errors:** Unrecognized characters
- **Syntax Errors:** Grammar rule violations  
- **Line Number Tracking:** Precise error location reporting
- **Error Recovery:** Continues parsing after errors

## 📝 Output Format

### Parse Tree Output
- Rule application logging
- Abstract syntax tree representation
- Line number annotations

### Symbol Table Output
- Scope-by-scope symbol listings
- Symbol attributes and types
- Hierarchical scope visualization

## 🎓 Academic Notes

This assignment demonstrates fundamental compiler construction concepts:
1. **Regular Expressions** for lexical pattern matching
2. **Context-Free Grammars** for syntax specification
3. **Symbol Tables** for semantic information management
4. **Error Handling** for robust compiler design

## ⚡ Performance Considerations

- **Hash Table Efficiency:** O(1) average symbol lookup
- **Memory Management:** Proper allocation/deallocation
- **Error Recovery:** Minimal performance impact
- **Scalability:** Supports large source files

---

**Author:** Student ID 22101371  
**Course:** CSE420 - Compiler Design  
**Date:** January 2026