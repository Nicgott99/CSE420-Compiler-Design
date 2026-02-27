# Changelog — Assignment 3

All notable changes to this assignment are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [3.0.0] - 2026-02-28

### Added — Assignment 3: Semantic Analysis & Symbol Table Management

#### Lexical Analyzer (`src/22101371.l`)
- Token definitions for 17 C-like reserved keywords
- Operator tokens: `ADDOP`, `MULOP`, `INCOP`, `DECOP`, `RELOP`, `ASSIGNOP`, `LOGICOP`, `NOT`
- Delimiter tokens: parentheses, braces, brackets, comma, semicolon
- `symbol_info` payloads attached to operator and literal tokens via `yylval`
- Line counter incremented on every newline for precise error reporting

#### Syntax & Semantic Analyzer (`src/22101371.y`)
- Full Bison grammar covering: function definitions, variable/array declarations,
  compound statements, control flow (`if-else`, `for`, `while`), expressions,
  function calls and `printf` statements
- Dangling-else ambiguity resolved with `%prec LOWER_THAN_ELSE`
- Separate `ofstream` instances for parse log and error report
- **Semantic actions in every production rule:**
  - Scope creation on `{` and destruction on `}`
  - Automatic insertion of function parameters into the inner scope
  - Duplicate declaration detection for variables and functions
  - Undeclared variable and undeclared function detection
  - Array vs. scalar usage enforcement (index required / index forbidden)
  - Array index integer-type check
  - Type propagation through expression trees (arithmetic, relational, logical)
  - `void` operand detection
  - Float-to-int assignment warning
  - Division by zero and modulus by zero detection
  - Modulus-on-non-integer-type detection
  - Return type mismatch against the enclosing function's declared return type
  - Function argument count and per-argument type validation
- Running error counter written to both output files at program end

#### Symbol Management (`include/`)
- `symbol_info.h` — complete symbol descriptor with name, category, symbol type,
  data type, parameter list, and array size
- `scope_table.h` — single-scope hash table with polynomial rolling hash,
  separate chaining, insert / lookup / delete / print operations
- `symbol_table.h` — hierarchical scope manager; `enter_scope` / `exit_scope`
  maintain a singly-linked stack via parent pointers; `lookup` walks the full
  scope chain; `print_all_scopes` dumps every active scope

#### Build & Tooling
- `Makefile` with targets: `all`, `test`, `clean`, `distclean`, `help`
- `script.sh` one-shot build and run script

#### Documentation
- `README.md` — full project documentation with feature table, build instructions,
  test case description, and academic notes
- `LICENSE` — MIT License
- `CHANGELOG.md` — this file

#### Test Case
- `test-cases/input.c` — single test file that exercises all semantic error paths:
  multiple declaration, array index type error, float-to-int assignment, modulus
  on non-integer, array-used-as-scalar, and undeclared-variable errors

### Technical Specifications
- **Lexical Analyzer:** 101 lines, regular-expression based
- **Semantic Analyzer:** 720 lines, 30+ Bison production rules with embedded semantic actions
- **Symbol Table:** three-file modular design, hash-table and linked-list based
- **Error Categories:** 11 distinct semantic error types
- **Output:** structured parse log + dedicated error report with line numbers

---

## [2.0.0] - 2026-01-26 *(see Assignment-2/CHANGELOG.md)*

Assignment 2: Lexical & Syntax Analysis — Flex lexer, Bison parser, three-tier
symbol table, 3 test cases, professional build system and documentation.

---

## [1.0.0] - 2026-01-26 *(initial project scaffolding)*

Repository initialised with root README and project structure overview.
