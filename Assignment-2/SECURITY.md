# Security Policy

## Supported Versions

This is an academic project for CSE420 - Compiler Design course. Security updates are provided for the current assignment version only.

| Version | Supported          |
| ------- | ------------------ |
| 2.x.x   | :white_check_mark: |
| 1.x.x   | :x:                |

## Reporting a Security Vulnerability

This is an educational project, but if you discover any security issues:

1. **Academic Integrity**: Do not share solutions publicly
2. **Code Quality**: Report potential memory leaks or buffer overflows
3. **Build Security**: Report issues with the build system

### Contact
- Course: CSE420 - Compiler Design
- Student ID: 22101371

### Response Timeline
- Initial response: Within 48 hours
- Status update: Weekly during active development
- Resolution: Based on assignment timeline

## Security Considerations

### Memory Safety
- All dynamic allocations have corresponding deallocations
- Proper bounds checking in array operations
- No buffer overflow vulnerabilities in lexer/parser

### Input Validation
- Lexical analyzer handles malformed input gracefully
- Parser includes error recovery mechanisms
- No arbitrary code execution from input files

### Build Security
- Makefile uses relative paths only
- No external dependencies beyond standard tools
- Clean targets properly remove generated files

## Academic Use Only

This project is intended for educational purposes only. Please respect:
- Academic integrity policies
- Copyright restrictions
- Educational fair use guidelines