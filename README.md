# CSE420 Compiler Design

A comprehensive collection of compiler design assignments implementing lexical analysis, syntax analysis, and semantic analysis for a C-like programming language.

## 📚 Course Information
- **Course:** CSE420 - Compiler Design
- **Student ID:** 22101371
- **Institution:** [Your University Name]

## 🎯 Project Overview

This repository contains the implementation of a complete compiler frontend including:

1. **Lexical Analyzer** - Tokenization and pattern recognition
2. **Syntax Analyzer** - Grammar parsing and syntax tree generation  
3. **Semantic Analyzer** - Symbol table management and type checking

## 📂 Repository Structure

```
├── Assignment-2/           # Lexical & Syntax Analysis
├── Assignment-3/           # Symbol Table & Scope Management (Coming Soon)
├── Assignment-4/           # Semantic Analysis & Code Generation (Coming Soon)
└── README.md
```

## 🚀 Current Progress

### ✅ Assignment 2 - Lexical & Syntax Analysis (COMPLETED)
- [x] **Lexical Analyzer** - Complete Flex implementation with 18+ keywords
- [x] **Syntax Analyzer** - Full Bison grammar with C-like language support  
- [x] **Symbol Management** - Three-tier architecture (symbol_info, scope_table, symbol_table)
- [x] **Hash Tables** - Efficient symbol storage with collision resolution
- [x] **Error Handling** - Comprehensive error reporting with line numbers
- [x] **Test Suite** - 3 comprehensive test cases covering all functionality
- [x] **Build System** - Professional Makefile with automated testing
- [x] **Documentation** - Complete technical documentation and guides
- [x] **Version Control** - Professional Git workflow with semantic commits

**Current Status:** 🎉 Assignment 2 successfully implemented and deployed with production-quality code!

### ⏳ Upcoming Assignments
- [ ] **Assignment 3** - Advanced Symbol Table Management & Scope Resolution
- [ ] **Assignment 4** - Semantic Analysis & Intermediate Code Generation

## 🛠️ Technologies Used

- **Flex** - Fast lexical analyzer generator
- **Bison** - Parser generator
- **C++** - Implementation language
- **Make** - Build automation

## 📋 Features

- **Multi-language Support:** Recognizes C-like syntax including keywords, operators, and identifiers
- **Error Recovery:** Comprehensive error detection and reporting
- **Symbol Management:** Efficient symbol table implementation with scope handling
- **Test Coverage:** Extensive test cases covering edge cases

## 🏃‍♂️ How to Run

```bash
# Compile the analyzer
make

# Run with input file
./compiler input.c

# View output
cat output.log
```

## 📊 Assignment Details

Each assignment builds upon the previous one, creating a complete compiler pipeline:

1. **Lexical Analysis:** Breaking source code into tokens
2. **Syntax Analysis:** Building parse trees from tokens  
3. **Semantic Analysis:** Type checking and symbol resolution
4. **Code Generation:** Producing intermediate code

## 🤝 Contributing

This is an academic project. Please respect academic integrity policies.

## 📄 License

This project is for educational purposes as part of CSE420 coursework.

---

*Last Updated: January 2026*