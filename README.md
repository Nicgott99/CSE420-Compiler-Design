# CSE420 Compiler Design

A comprehensive collection of compiler design assignments implementing lexical analysis, syntax analysis, and semantic analysis for a C-like programming language.

## 📚 Course Information

| Field | Details |
|-------|---------|
| **Course** | CSE420 - Compiler Design |
| **Student** | Md Hasib Ullah Khan Alvie |
| **Student ID** | 22101371 |
| **Email** | mdhasibullahkhanalvie@gmail.com |
| **Institution** | BRAC University |
| **Semester** | Fall 2025 |

## 🎯 Project Overview

This repository contains the implementation of a complete compiler frontend including:

1. **Lexical Analyzer** - Tokenization and pattern recognition
2. **Syntax Analyzer** - Grammar parsing and parse tree generation
3. **Semantic Analyzer** - Scope-aware symbol table management and type checking

## 📂 Repository Structure

```
CSE420-Compiler-Design/
├── Assignment-2/           # Lexical & Syntax Analysis
│   ├── include/            #   Header files
│   ├── src/                #   Flex & Bison sources
│   ├── test-cases/         #   3 test inputs
│   ├── Makefile
│   ├── README.md
│   ├── LICENSE
│   ├── CHANGELOG.md
│   └── ...
├── Assignment-3/           # Semantic Analysis & Symbol Table Management
│   ├── include/            #   Header files
│   ├── src/                #   Flex & Bison sources
│   ├── test-cases/         #   Test input
│   ├── Makefile
│   ├── README.md
│   ├── LICENSE
│   └── CHANGELOG.md
├── Assignment-4/           # Intermediate Code Generation (Three-Address Code)
│   ├── include/            #   Header files (TAC system + symbol management)
│   ├── src/                #   Flex & Bison sources
│   ├── test-cases/         #   Test input
│   ├── Makefile
│   ├── script.sh
│   ├── README.md
│   ├── LICENSE
│   └── CHANGELOG.md
└── README.md               # This file
```

## 🚀 Current Progress

### ✅ Assignment 2 — Lexical & Syntax Analysis (COMPLETED)
- [x] **Lexical Analyzer** — Complete Flex implementation with 18+ keywords
- [x] **Syntax Analyzer** — Full Bison grammar with C-like language support
- [x] **Symbol Management** — Three-tier architecture (`symbol_info`, `scope_table`, `symbol_table`)
- [x] **Hash Tables** — Efficient symbol storage with collision resolution
- [x] **Error Handling** — Comprehensive error reporting with line numbers
- [x] **Test Suite** — 3 comprehensive test cases covering all functionality
- [x] **Build System** — Professional Makefile with automated testing
- [x] **Documentation** — Complete technical documentation and contribution guides

> See [Assignment-2/README.md](Assignment-2/README.md) for full details.

### ✅ Assignment 3 — Semantic Analysis & Symbol Table Management (COMPLETED)
- [x] **Scope-Aware Symbol Table** — Hierarchical scope manager with stack-based enter/exit
- [x] **Type Checking** — Full type propagation through expression trees
- [x] **Semantic Errors** — 11 distinct error categories (undeclared variables/functions, type mismatches, duplicate declarations, void operations, zero division, etc.)
- [x] **Function Validation** — Argument count and type checking on every call site
- [x] **Return Type Validation** — Checked against the enclosing function's declared type
- [x] **Parse Log** — Detailed `22101371_log.txt` with every production rule applied
- [x] **Error Report** — Dedicated `22101371_error.txt` with line numbers and error totals
- [x] **MIT License** — Open-source license included

> See [Assignment-3/README.md](Assignment-3/README.md) for full details.

### ✅ Assignment 4 — Intermediate Code Generation (Three-Address Code) (COMPLETED)
- [x] **Three-Address Code System** — Complete TAC representation with 9 instruction formats
- [x] **TAC Generator** — Automatic temporary variable and label generation
- [x] **Semantic Actions** — Full TAC emission during parsing
- [x] **Instruction Formats** — Binary ops, unary ops, assignments, jumps, array access, function calls, returns, prints
- [x] **Symbol Integration** — Full inheritance of symbol table from Assignment 3
- [x] **Test Case** — GCD function demonstrating recursion and control flow
- [x] **Build System** — Extended Makefile with TAC-specific targets
- [x] **Documentation** — Comprehensive TAC concepts and reference guide (280+ lines)
- [x] **MIT License** — Open-source license included

> See [Assignment-4/README.md](Assignment-4/README.md) for full details.

## 🛠️ Technologies Used

- **Flex** — Fast lexical analyzer generator
- **Bison** — Parser generator (LALR(1))
- **C++** — Implementation language
- **GNU Make** — Build automation

## 🏃‍♂️ Quick Start

```bash
# --- Assignment 2 ---
cd Assignment-2
make
make test

# --- Assignment 3 ---
cd Assignment-3
make
make test
# Outputs: 22101371_log.txt, 22101371_error.txt

# --- Assignment 4 ---
cd Assignment-4
make
make test
# Outputs: TAC instructions from three-address code compiler
```

## 📊 Assignment Overview

| Assignment | Topic | Status |
|-----------|-------|--------|
| Assignment 2 | Lexical & Syntax Analysis | ✅ Complete |
| Assignment 3 | Semantic Analysis & Symbol Table | ✅ Complete |
| Assignment 4 | Intermediate Code Generation (TAC) | ✅ Complete |

## 🤝 Contributing

This is an academic project. Please respect academic integrity policies.

## 📄 License

Each assignment folder contains its own MIT License.  
This repository is maintained for educational purposes as part of CSE420 coursework.

---

*Last Updated: January 2025*