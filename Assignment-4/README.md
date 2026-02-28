# Assignment 4: Intermediate Code Generation (Three-Address Code)

## 📋 Overview

This assignment builds upon the compiler frontend from Assignment 2 & 3 by introducing **intermediate code generation**. The compiler now translates a C-like source language into **three-address code (TAC)**, a simple intermediate representation where each instruction has at most three operands. This is a crucial bridge between high-level source code and machine code generation.

## 🎯 Learning Objectives

- Understand intermediate code generation and its importance in compilation
- Design and implement three-address code (TAC) representation
- Generate TAC from an abstract syntax tree during parsing
- Handle control flow constructs (loops, conditionals) in TAC
- Manage temporary variables and labels for control flow
- Integrate TAC generation into the semantic analyzer

## 🔧 Components

### 1. Lexical Analyzer (`src/22101371.l`)
- Extended tokenizer from Assignment 3
- Recognizes C-like tokens: keywords, operators, identifiers, literals
- Maintains line counter for error reporting
- Passes symbol information to parser via `yylval`

### 2. Syntax & Semantic + TAC Analyzer (`src/22101371.y`)
- Full Bison grammar covering C-like language constructs
- **TAC generation in semantic actions:**
  - Binary/unary operations → temporary variables
  - Assignments → direct TAC emission
  - Conditional statements → label generation + conditional jumps
  - Loops → loop-back jumps + condition checks
  - Function calls → function call TAC instructions
  - Array access/assignment → array TAC variants
- Exports TAC to `22101371_tac.txt` with line numbers and operation details
- Maintains symbol table from Assignment 3 for type information

### 3. Three-Address Code System (`include/three_addr_code.h`)

#### `ThreeAddressCode` class
- Represents a single TAC instruction
- Stores: operation, operands (arg1, arg2), result, label
- Supports multiple TAC formats:
  - Binary: `x = y op z` (addition, subtraction, multiplication, division, modulo)
  - Unary: `x = op y` (negation, logical NOT)
  - Assignment: `x = y`
  - Conditional jump: `if y relop z goto L`
  - Unconditional jump: `goto L`
  - Array access: `x = array[y]`
  - Array assignment: `array[x] = y`
  - Function calls: `x = call func(args)`
  - Return: `return x`
  - Print: `print x`
- Methods: `toString()`, `print()` for debugging

#### `ThreeAddressCodeGenerator` class
- Manages TAC instruction generation and emission
- Utilities:
  - `generateTempVariable()` → generates unique temp vars (t0, t1, ...)
  - `generateLabel()` → generates unique labels (L0, L1, ...)
  - `emitBinaryOp()` → emits binary operation TAC
  - `emitUnaryOp()` → emits unary operation TAC
  - `emitConditionalJump()` → emits conditional jump TAC
  - `emitUnconditionalJump()` → emits unconditional jump TAC
  - `emitArrayAccess()` → emits array read
  - `emitArrayAssignment()` → emits array write
  - `emitFunctionCall()` → emits function call TAC
  - `emitReturn()` → emits return statement
  - `emitPrint()` → emits print statement
- Prints all TAC to output stream with formatting

### 4. Symbol Management System (from Assignment 3)
- `include/symbol_info.h` → Symbol descriptor
- `include/scope_table.h` → Single-scope hash table
- `include/symbol_table.h` → Hierarchical scope manager

## 🏗️ Project Structure

```
Assignment-4/
├── include/                     # Header files
│   ├── symbol_info.h            # Symbol descriptor class
│   ├── scope_table.h            # Single-scope hash table
│   ├── symbol_table.h           # Hierarchical scope manager
│   └── three_addr_code.h        # Three-address code representation
├── src/                         # Source files
│   ├── 22101371.l               # Flex lexical analyzer
│   └── 22101371.y               # Bison grammar + TAC generation
├── test-cases/
│   └── input.c                  # Test input (GCD function)
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

# Run test case
make test

# Clean intermediate files
make clean

# Clean everything including executable
make distclean

# One-shot build & test
./script.sh
```

### Output Files
- `compiler` → Executable compiler
- `22101371_tac.txt` → Generated three-address code (with test case)
- `y.tab.c`, `lex.yy.c` → Generated lexer and parser
- `y.output` → Bison debug information

## 📝 Example TAC Output

For the input:
```c
int main() {
    int x, y;
    x = 5;
    y = x + 3;
    return y;
}
```

Generated TAC:
```
=== Three-Address Code ===
(0) x = 5
(1) t0 = x + 3
(2) y = t0
(3) return y
==== End of TAC ====
```

For control flow (if-else):
```
if x > 0 goto L0
y = -1
goto L1
L0:
y = 1
L1:
print y
```

## 🔄 TAC Formats Reference

| Format | Syntax | Example | Meaning |
|--------|--------|---------|---------|
| Binary Op | `x = y op z` | `t0 = a + b` | Add a and b, store in t0 |
| Unary Op | `x = op y` | `t1 = -t0` | Negate t0, store in t1 |
| Assignment | `x = y` | `result = t1` | Copy t1 to result |
| Cond Jump | `if y relop z goto L` | `if x > 5 goto L0` | Jump if x > 5 |
| Uncond Jump | `goto L` | `goto L1` | Unconditional jump |
| Array Read | `x = array[y]` | `t2 = arr[i]` | Read array[i] into t2 |
| Array Write | `array[x] = y` | `arr[i] = t2` | Write t2 to array[i] |
| Function Call | `x = call f(args)` | `t3 = call gcd(a, b)` | Call gcd(a,b), store result |
| Return | `return x` | `return result` | Return from function |
| Print | `print x` | `print result` | Output variable |

## 🎓 Key Concepts

### Why Three-Address Code?
1. **Simplification**: Reduces complexity from arbitrary expressions to simple 3-operand instructions
2. **Optimization**: Easier to apply compiler optimizations (constant folding, dead code elimination, etc.)
3. **Code Generation**: Direct translation to machine instructions
4. **Debugging**: Intermediate representation helps visualize compilation process

### Temporary Variables
- Used to break complex expressions into simple operations
- Generated names: `t0`, `t1`, `t2`, ...
- Each temporary holds the result of one operation

### Labels and Control Flow
- Labels mark jump targets (e.g., loop starts, if-else branches)
- Generated names: `L0`, `L1`, `L2`, ...
- Conditional jumps: `if condition goto L`
- Unconditional jumps: `goto L`

## 🛠️ Technologies Used

- **Flex** – Lexical analyzer generator
- **Bison** – Parser generator
- **C++** – Implementation language
- **GNU Make** – Build automation

## 📚 References

- Modern Compiler Implementation (Andrew Appel)
- Compilers: Principles, Techniques, and Tools (Aho, Lam, Sethi, Ullman)
- Three-Address Code Representation: https://en.wikipedia.org/wiki/Three-address_code

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Created at:** BRAC University, CSE420 Fall 2025
**Student:** Md Hasib Ullah Khan Alvie (22101371)
**Semester:** Fall 2025

