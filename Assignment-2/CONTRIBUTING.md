# Contributing to CSE420 Compiler Design

## 🎯 Project Overview

This repository contains assignments for CSE420 - Compiler Design course, implementing a complete compiler pipeline for a C-like programming language.

## 📋 Development Guidelines

### Code Standards

#### C++ Style Guidelines
- **Naming Convention:** snake_case for variables, PascalCase for classes
- **Documentation:** Doxygen-style comments for all public methods
- **Memory Management:** RAII principles, proper cleanup in destructors
- **Error Handling:** Comprehensive error checking with meaningful messages

#### Flex/Bison Guidelines  
- **Lexical Rules:** Clear, well-commented regular expressions
- **Grammar Rules:** Properly documented production rules
- **Semantic Actions:** Clean, understandable code in grammar actions
- **Error Recovery:** Graceful error handling and reporting

### Git Workflow

#### Commit Message Format
```
<type>(<scope>): <description>

<body>

<footer>
```

**Types:**
- `feat`: New features
- `fix`: Bug fixes  
- `docs`: Documentation changes
- `test`: Test additions/modifications
- `build`: Build system changes
- `refactor`: Code refactoring

**Examples:**
```bash
feat(lexer): Add support for floating-point constants
test(parser): Add test cases for nested scoping
build(makefile): Optimize compilation flags
docs(readme): Update installation instructions
```

#### Branch Strategy
- **main:** Production-ready code
- **develop:** Integration branch for features
- **feature/**: Individual feature development
- **hotfix/**: Critical bug fixes

### Documentation Requirements

#### README Files
- **Project Overview:** Clear description of functionality
- **Installation:** Step-by-step build instructions
- **Usage:** Examples and test case descriptions
- **Architecture:** High-level design explanation

#### Code Documentation
- **Header Files:** Complete API documentation
- **Implementation:** Complex algorithm explanations
- **Test Cases:** Purpose and expected outcomes

### Testing Standards

#### Test Case Categories
1. **Unit Tests:** Individual component validation
2. **Integration Tests:** Component interaction testing
3. **System Tests:** End-to-end functionality validation
4. **Error Tests:** Error handling verification

#### Coverage Requirements
- **Core Functionality:** 100% test coverage
- **Error Paths:** All error conditions tested
- **Edge Cases:** Boundary condition validation
- **Performance:** Large input handling verification

## 🛠️ Development Environment

### Required Tools
```bash
# Compiler toolchain
sudo apt-get install gcc g++
sudo apt-get install flex bison
sudo apt-get install make

# Development utilities
sudo apt-get install git
sudo apt-get install valgrind  # Memory debugging
sudo apt-get install gdb       # Debugging
```

### IDE Configuration
**VS Code Extensions:**
- C/C++ Extension Pack
- Flex/Bison Language Support  
- GitLens for Git integration
- Better Comments for documentation

### Build Verification
```bash
# Verify installation
gcc --version
flex --version
bison --version
make --version

# Build project
make all

# Run tests
make test

# Clean build
make clean
```

## 📊 Assignment Structure

### Assignment 2: Lexical & Syntax Analysis
- **Lexical Analyzer:** Token recognition and classification
- **Syntax Analyzer:** Grammar parsing and parse tree generation
- **Symbol Tables:** Basic symbol management infrastructure

### Assignment 3: Symbol Table & Scope Management
- **Enhanced Symbols:** Type information and attributes
- **Scope Resolution:** Advanced scoping rules
- **Error Detection:** Semantic error identification

### Assignment 4: Semantic Analysis & Code Generation  
- **Type Checking:** Static type analysis
- **Intermediate Code:** Three-address code generation
- **Optimization:** Basic optimization techniques

## 🔍 Code Review Process

### Review Checklist
- [ ] Code follows style guidelines
- [ ] All functions have proper documentation
- [ ] Test cases cover new functionality
- [ ] No memory leaks (verified with valgrind)
- [ ] Error handling is comprehensive
- [ ] Build passes without warnings

### Performance Considerations
- **Time Complexity:** Document algorithm complexity
- **Space Complexity:** Monitor memory usage patterns
- **Scalability:** Test with large input files
- **Error Recovery:** Minimize performance impact

## 🐛 Debugging Guidelines

### Common Issues

#### Flex/Bison Integration
```bash
# Generate debug information
bison -d -v syntax_analyzer.y
flex lex_analyzer.l

# Check for conflicts
cat y.output  # Examine parser conflicts
```

#### Memory Issues
```bash
# Check for memory leaks
valgrind --leak-check=full ./compiler test.c

# Debug with gdb
gdb ./compiler
(gdb) run test.c
(gdb) bt  # Backtrace on crash
```

#### Build Problems
```bash
# Clean rebuild
make distclean
make all

# Verbose make output
make V=1
```

## 📈 Performance Benchmarking

### Test Metrics
- **Compilation Time:** Time to build the compiler
- **Parse Time:** Time to parse input files
- **Memory Usage:** Peak memory consumption
- **Error Recovery:** Time to recover from errors

### Benchmark Tests
```bash
# Time compilation
time make all

# Profile parser performance
time ./compiler large_input.c

# Memory usage analysis
valgrind --tool=massif ./compiler test.c
```

## 🎓 Learning Resources

### Compiler Theory
- **Dragon Book:** Compilers: Principles, Techniques, and Tools
- **Modern Compiler Implementation:** Andrew Appel series
- **Flex & Bison:** O'Reilly Media guide

### Online Resources
- **Flex Manual:** https://github.com/westes/flex
- **Bison Manual:** https://www.gnu.org/software/bison/
- **C++ Reference:** https://cppreference.com/

### Academic Papers
- **Symbol Tables:** Efficient hash table implementations
- **Error Recovery:** Panic mode vs. phrase level recovery
- **Parse Tree Optimization:** Memory-efficient tree structures

---

## 📞 Contact & Support

For questions about this project:
- **Course:** CSE420 - Compiler Design
- **Student ID:** 22101371
- **Institution:** [Your University]

## 📄 License

This project is for academic use only as part of CSE420 coursework. Please respect academic integrity policies.