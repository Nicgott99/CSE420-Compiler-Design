# Changelog

All notable changes to the CSE420 Compiler Design project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-01-26

### Added - Assignment 2: Lexical and Syntax Analysis
- Complete lexical analyzer using Flex with 18 keyword recognition
- Comprehensive syntax analyzer using Bison with full C-like grammar
- Three-tier symbol management system (symbol_info, scope_table, symbol_table)
- Hash-based symbol storage with collision resolution
- Hierarchical scope management with stack-based operations
- Expression parsing with proper operator precedence
- Control flow statement support (if-else, for, while)
- Function definition and parameter list handling
- Comprehensive test suite with 3 test cases
- Professional build system with automated testing
- Complete documentation suite with implementation details
- Error handling with line number tracking
- Parse tree generation with semantic actions

### Technical Specifications
- **Lexical Analysis:** 120+ lines, regular expression based tokenization
- **Syntax Analysis:** 500+ lines, 25+ grammar production rules  
- **Symbol Tables:** Modular design with extensible architecture
- **Test Coverage:** Basic functionality, control flow, nested scopes
- **Documentation:** README, implementation report, contribution guidelines

### Performance
- **Time Complexity:** O(n) lexical analysis, O(n³) worst-case parsing
- **Memory Efficiency:** Hash table based symbol storage
- **Error Recovery:** Graceful handling with continued parsing
- **Scalability:** Supports large source files and deep nesting

## [1.0.0] - 2026-01-26

### Added - Project Foundation
- Initial repository structure and README
- Project overview and technology stack documentation
- Academic context and course information
- Repository organization for multi-assignment structure

---

## Future Releases

### [3.0.0] - Assignment 3: Symbol Table & Scope Management
- Enhanced symbol attributes with type information
- Advanced scope resolution algorithms  
- Semantic error detection and reporting
- Function signature validation
- Variable declaration conflict detection

### [4.0.0] - Assignment 4: Semantic Analysis & Code Generation
- Complete semantic analyzer implementation
- Three-address intermediate code generation
- Basic optimization techniques
- Target code generation
- Complete compiler pipeline

---

**Versioning Notes:**
- Major versions correspond to assignment completions
- Minor versions indicate significant feature additions
- Patch versions represent bug fixes and documentation updates