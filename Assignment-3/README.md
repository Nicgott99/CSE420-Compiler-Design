# Assignment 3: Semantic Analysis & Symbol Table Management

## 📋 Overview

This assignment extends the compiler frontend with a full **semantic analyzer** built on top of the lexical and syntax analyzers from Assignment 2. It introduces scope-aware symbol table management, type checking, and semantic error detection for a C-like programming language using **Flex** and **Bison**.

## 🎯 Learning Objectives

- Design and implement a hierarchical, scope-based symbol table
- Perform semantic analysis including type checking and type coercion warnings
- Detect and report semantic errors (undeclared variables, multiple declarations, type mismatches, etc.)
- Integrate semantic actions into a Bison grammar
- Generate structured parse logs and error reports

## 🔧 Components

### 1. Lexical Analyzer (`src/22101371.l`)
- Tokenises C-like source code into a stream of typed tokens
- Recognises 17 reserved keywords, all C operators, identifiers, integer and floating-point constants
- Attaches `symbol_info` payloads to tokens for downstream use in semantic actions

### 2. Syntax & Semantic Analyzer (`src/22101371.y`)
- Full Bison grammar for a C-like language (functions, variables, arrays, control flow, expressions)
- **Semantic actions** embedded in every production rule:
  - Symbol insertion and duplicate-declaration detection
  - Cross-scope symbol lookup for undeclared-variable detection
  - Type propagation through expression trees
  - Type-mismatch and void-operation error reporting
  - Division/modulus by zero detection
  - Return-type validation against function signatures
  - Argument-count and argument-type checking on function calls
- Writes a detailed **parse log** (`22101371_log.txt`) and a separate **error report** (`22101371_error.txt`)

### 3. Symbol Management System

#### `include/symbol_info.h`
- Core symbol descriptor class
- Stores: name, category, symbol type (`Variable` / `Array` / `Function Definition`), data type (`int` / `float` / `void`), parameter type list, array size

#### `include/scope_table.h`
- Single-scope hash table using separate chaining (polynomial rolling hash)
- Supports: `insert_in_scope`, `lookup_in_scope`, `delete_from_scope`, `print_scope_table`

#### `include/symbol_table.h`
- Hierarchical scope manager (stack of `scope_table` instances)
- Supports: `enter_scope`, `exit_scope`, `insert`, `lookup` (walks entire scope chain), `print_all_scopes`

## 🏗️ Project Structure

```
Assignment-3/
├── include/                     # Header files
│   ├── symbol_info.h            # Symbol descriptor class
│   ├── scope_table.h            # Single-scope hash table
│   └── symbol_table.h           # Hierarchical scope manager
├── src/                         # Source files
│   ├── 22101371.l               # Flex lexical analyzer
│   └── 22101371.y               # Bison grammar + semantic actions
├── test-cases/
│   └── input.c                  # Test input with intentional semantic errors
├── Makefile                     # Build automation
├── script.sh                    # One-shot build & run script
├── CHANGELOG.md                 # Version history
├── LICENSE                      # MIT License
└── README.md                    # This documentation
```

## 🚀 Build Instructions

### Prerequisites
- GCC / G++ with C++14 or later
- Flex (Fast Lexical Analyzer Generator)
- Bison (GNU Parser Generator)
- GNU Make

### Compilation

```bash
# Build the compiler
make

# Or build and run the bundled test case in one step
make test
```

### Using the build script

```bash
# Grant execute permission (Linux / WSL / Git Bash)
chmod +x script.sh
./script.sh
```

### Manual build (step-by-step)

```bash
bison -d -y --debug --verbose src/22101371.y
g++ -fpermissive -w -c -o y.o y.tab.c
flex src/22101371.l
g++ -fpermissive -w -c -o l.o lex.yy.c
g++ -o compiler y.o l.o
./compiler test-cases/input.c
```

### Cleanup

```bash
# Remove generated files
make clean

# Remove everything including backups
make distclean
```

## 📊 Test Case

### Test Input (`test-cases/input.c`)
The bundled test case deliberately contains a variety of semantic errors to exercise all detection paths:

| Error | Description |
|-------|-------------|
| Multiple declaration | `float c` declared twice in the same scope |
| Array index type mismatch | `a[2.5]` — index must be integer |
| Float-to-int assignment with warning | `i = 2.3` |
| Modulus on non-integer | `j = 2 % 3.7` |
| Array used as variable | `a = 4` (array cannot be used without index) |
| Undeclared variable | `b = 8` |

## 📈 Features Implemented

### ✅ Lexical Analysis
- [x] 17 keyword tokens
- [x] Arithmetic, relational, logical and assignment operators
- [x] Identifier, integer constant, floating-point constant tokens
- [x] `symbol_info` payloads attached to operator and literal tokens

### ✅ Syntax Analysis
- [x] Full C-like grammar (functions, parameters, declarations, statements, expressions)
- [x] Proper operator precedence and associativity
- [x] Dangling-else resolved with `%prec LOWER_THAN_ELSE`
- [x] Parse tree logged to `22101371_log.txt`

### ✅ Semantic Analysis
- [x] Scope entry on every compound statement, exit on closing brace
- [x] Function parameters inserted into inner scope automatically
- [x] Duplicate variable / function declaration detection
- [x] Undeclared variable and undeclared function detection
- [x] Array vs. scalar usage validation
- [x] Array index integer-type enforcement
- [x] Arithmetic type propagation (`int` + `float` → `float`)
- [x] `void` operand detection
- [x] Float-to-int assignment warning
- [x] Division by zero and modulus by zero detection
- [x] Modulus-on-non-integer detection
- [x] Return type mismatch detection
- [x] Function argument count and type validation

### ✅ Symbol Management
- [x] Polynomial rolling hash for fast bucket placement
- [x] Separate chaining for collision resolution
- [x] Full scope-chain lookup (inner → outer)
- [x] Detailed scope print at every scope exit

## 🔬 Technical Specifications

### Grammar Features
- **Types:** `int`, `float`, `void`
- **Declarations:** scalar variables, fixed-size arrays
- **Functions:** definition, parameter lists, return statements
- **Control Flow:** `if-else`, `for`, `while`
- **Expressions:** full C-like operator precedence including unary, multiplicative, additive, relational, logical and assignment levels

### Symbol Table Design
- **Hash Function:** polynomial rolling hash modulo bucket count
- **Collision Resolution:** separate chaining with `std::list`
- **Scope Management:** singly-linked stack via parent pointers
- **Lookup:** walks the scope chain from innermost to outermost

## 🐛 Error Handling

Errors are written to `22101371_error.txt` with the offending line number:

```
At line no: <N> <error description>
```

All errors are also counted; the final total is written to both output files.

## 📝 Output Files

| File | Description |
|------|-------------|
| `22101371_log.txt` | Full parse log — every production rule applied, with the reconstructed source fragment and the current symbol table printed at each scope exit |
| `22101371_error.txt` | Semantic (and syntax) errors with line numbers and error totals |

## 🎓 Academic Notes

This assignment demonstrates:
1. **Semantic Analysis** — enforcing language semantics beyond what grammars can express
2. **Type Systems** — propagating and checking types through expression trees
3. **Scope Rules** — lexical scoping with nested compound statements
4. **Error Recovery** — continuing analysis after errors to report all issues in one pass

---

**Author:** Md Hasib Ullah Khan Alvie  
**Student ID:** 22101371  
**Email:** mdhasibullahkhanalvie@gmail.com  
**Institution:** BRAC University  
**Course:** CSE420 - Compiler Design  
**Semester:** Fall 2025
