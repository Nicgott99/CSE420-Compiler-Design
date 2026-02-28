# Changelog — Assignment 4

All notable changes to this assignment are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [4.0.0] - 2026-03-01

### Added — Assignment 4: Intermediate Code Generation (Three-Address Code)

#### Three-Address Code System (`include/three_addr_code.h`)

**`ThreeAddressCode` class:**
- Core representation of a single TAC instruction
- Supports 9 different TAC formats:
  - Binary operations: `x = y op z` (for +, -, *, /, %, <, >, ==, !=, <=, >=)
  - Unary operations: `x = op y` (for -, !)
  - Assignments: `x = y`
  - Conditional jumps: `if y relop z goto L`
  - Unconditional jumps: `goto L`
  - Array access: `x = array[y]`
  - Array assignment: `array[x] = y`
  - Function calls: `x = call func(args)`
  - Return statements: `return x`
  - Print statements: `print x`
- Full getters/setters for all fields
- `toString()` method for human-readable output
- `print()` method for direct stream output

**`ThreeAddressCodeGenerator` class:**
- Global TAC generator instance in parser
- Instruction counter for unique numbering
- Utility generators:
  - `generateTempVariable()` → produces t0, t1, t2, ... on demand
  - `generateLabel()` → produces L0, L1, L2, ... for jumps
- TAC emission methods:
  - `emitBinaryOp(op, arg1, arg2, result)` → add two-operand instruction
  - `emitUnaryOp(op, arg, result)` → add one-operand instruction
  - `emitAssignment(arg, result)` → add assignment
  - `emitConditionalJump(relop, arg1, arg2, label)` → add conditional jump
  - `emitUnconditionalJump(label)` → add goto statement
  - `emitArrayAccess(array, index, result)` → add array read
  - `emitArrayAssignment(array, index, value)` → add array write
  - `emitFunctionCall(func, args, result)` → add function call
  - `emitReturn(value)` → add return statement
  - `emitPrint(value)` → add printf statement
- `printAll(stream)` → outputs all TAC with formatting
- `getInstructions()` → returns vector of all TAC
- `getInstructionCount()` → returns total TAC count

#### Extended Lexical Analyzer (`src/22101371.l`)
- Reuses and extends Assignment 3 lexer
- Full token set: 17 keywords, all C operators, identifiers, constants
- Symbol payloads via `symbol_info` objects
- Line counting for error reporting
- Whitespace and comment handling

#### Extended Parser with TAC Generation (`src/22101371.y`)
- Reuses grammar from Assignment 3 with TAC emission
- **TAC emission in every production rule:**
  - Binary expressions → emit binary TAC + bind temporary to nonterminal
  - Unary expressions → emit unary TAC
  - Assignments → emit assignment TAC
  - If statements → emit conditional jump + manage labels
  - While loops → emit loop-back jump + condition check
  - For loops → emit counter operations + jumps
  - Function calls → emit function call TAC
  - Array access → emit array TAC variants
- Symbol table integration for type checking
- Parse log with TAC instructions
- Error report with semantic issues

#### Symbol Management (from Assignment 3, reused)
- `include/symbol_info.h` – Descriptor with name, type, category, array size
- `include/scope_table.h` – Hash table with collision chaining (31-bit rolling hash)
- `include/symbol_table.h` – Stack of scopes for hierarchical lookup

#### Build System
- **Makefile** with targets:
  - `make` (or `make all`) – Build compiler
  - `make test` – Compile and run test case
  - `make clean` – Remove intermediate files
  - `make distclean` – Remove all generated files
  - `make help` – Display usage
- **script.sh** – One-shot build & test harness

#### Test Case (`test-cases/input.c`)
```c
int gcd(int a, int b) {
    if (b == 0)
        return a;
    else
        return gcd(b, a % b);
}

int main() {
    int x, y, result;
    x = 48;
    y = 18;
    result = gcd(x, y);
    printf(result);
    return 0;
}
```
- Demonstrates:
  - Function definition with recursion
  - Conditional (if-else) with TAC jumps
  - Assignment and function calls → TAC
  - Return statements
  - GCD algorithm translates to ~20 TAC instructions

#### Documentation
- Comprehensive README with:
  - Assignment overview and learning objectives
  - Detailed component descriptions
  - Project structure tree
  - Build & run instructions
  - Example TAC output with explanation
  - TAC formats reference table
  - Key concepts and why TAC matters
  - Technologies & references

### Related
- Extends Assignment 2 (lexical + syntax analysis)
- Extends Assignment 3 (semantic analysis + symbol tables)
- Foundation for Assignment 5 (machine code generation)

### Notes
- TAC is the de facto intermediate representation in production compilers
- This assignment bridges high-level source code and low-level machine code
- Real compilers (GCC, LLVM, etc.) use similar intermediate representations
- TAC can be further optimized before code generation (dead code elimination, constant folding, etc.)

---

## [3.0.0] - 2026-02-28

See Assignment 3 CHANGELOG for semantic analysis details.

---

## [2.0.0] - 2026-02-27

See Assignment 2 CHANGELOG for lexical & syntax analysis details.

---

## [1.0.0] - 2026-02-20

Initial project setup for CSE420 Compiler Design course.
