#ifndef THREE_ADDR_CODE_H
#define THREE_ADDR_CODE_H

#include <iostream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

/**
 * @class ThreeAddressCode
 * @brief Represents a single three-address code instruction
 *
 * Three-address code (TAC) is an intermediate representation where each
 * instruction has at most three operands. It's the bridge between syntax
 * and machine code.
 *
 * Formats supported:
 *   - x = y op z         (binary operation: op in {+, -, *, /, %})
 *   - x = op y           (unary operation: op in {-, !})
 *   - x = y              (assignment)
 *   - goto L             (unconditional jump)
 *   - if y relop z goto L (conditional jump: relop in {<, >, ==, !=, <=, >=})
 *   - call function(args)(function call)
 *   - return x           (function return)
 *   - x = array[y]       (array access)
 *   - array[x] = y       (array assignment)
 *   - print(x)           (output statement)
 */
class ThreeAddressCode {
private:
    int lineNum;              ///< Unique instruction number
    string op;                ///< Operation: +, -, *, /, %, <, >, ==, etc.
    string arg1, arg2;        ///< Operands
    string result;            ///< Destination operand
    string label;             ///< Label for jump targets (empty if not applicable)
    bool isConditional;       ///< True if conditional jump
    bool isFunctionCall;      ///< True if function call
    bool isReturn;            ///< True if return statement
    bool isArrayAccess;       ///< True if array read/write

public:
    // Constructor for binary operations: result = arg1 op arg2
    ThreeAddressCode(int line, const string& o, const string& a1, const string& a2, const string& r)
        : lineNum(line), op(o), arg1(a1), arg2(a2), result(r), isConditional(false),
          isFunctionCall(false), isReturn(false), isArrayAccess(false) {}

    // Constructor for unary operations or jumps
    ThreeAddressCode(int line, const string& o, const string& a1, const string& r)
        : lineNum(line), op(o), arg1(a1), arg2(""), result(r), isConditional(false),
          isFunctionCall(false), isReturn(false), isArrayAccess(false) {}

    // Constructor for conditional jumps: if arg1 relop arg2 goto label
    ThreeAddressCode(int line, const string& relop, const string& a1, const string& a2, const string& lbl, bool cond)
        : lineNum(line), op(relop), arg1(a1), arg2(a2), result(""), label(lbl),
          isConditional(cond), isFunctionCall(false), isReturn(false), isArrayAccess(false) {}

    // Getters
    int getLineNum() const { return lineNum; }
    string getOp() const { return op; }
    string getArg1() const { return arg1; }
    string getArg2() const { return arg2; }
    string getResult() const { return result; }
    string getLabel() const { return label; }
    bool getIsConditional() const { return isConditional; }
    bool getIsFunctionCall() const { return isFunctionCall; }
    bool getIsReturn() const { return isReturn; }
    bool getIsArrayAccess() const { return isArrayAccess; }

    // Setters
    void setLabel(const string& l) { label = l; }
    void setConditional(bool c) { isConditional = c; }
    void setFunctionCall(bool f) { isFunctionCall = f; }
    void setReturn(bool r) { isReturn = r; }
    void setArrayAccess(bool a) { isArrayAccess = a; }

    /**
     * @brief Convert TAC to human-readable string format
     * @return Formatted string representation
     */
    string toString() const {
        stringstream ss;
        ss << "(" << lineNum << ") ";

        if (isConditional) {
            ss << "if " << arg1 << " " << op << " " << arg2 << " goto " << label;
        } else if (isReturn) {
            ss << "return " << arg1;
        } else if (isArrayAccess && arg2 != "") {
            // Array read: result = array[arg1]
            ss << result << " = " << op << "[" << arg1 << "]";
        } else if (isArrayAccess && arg2 == "") {
            // Array write: array[result] = arg1
            ss << op << "[" << result << "] = " << arg1;
        } else if (isFunctionCall) {
            ss << result << " = call " << op << "(" << arg1 << ")";
        } else if (arg2 == "") {
            // Unary or assignment
            if (result == "") {
                ss << "goto " << label;
            } else {
                ss << result << " = " << op << " " << arg1;
            }
        } else {
            // Binary operation
            ss << result << " = " << arg1 << " " << op << " " << arg2;
        }

        return ss.str();
    }

    /**
     * @brief Print TAC instruction to output stream
     * @param os Output stream
     */
    void print(ostream& os) const {
        os << toString() << endl;
    }
};

/**
 * @class ThreeAddressCodeGenerator
 * @brief Manages and generates three-address code instructions
 */
class ThreeAddressCodeGenerator {
private:
    vector<ThreeAddressCode> instructions; ///< All TAC instructions
    int instructionCount;                  ///< Counter for unique instruction numbering
    int tempVarCount;                      ///< Counter for temporary variable generation
    int labelCount;                        ///< Counter for label generation

public:
    ThreeAddressCodeGenerator() : instructionCount(0), tempVarCount(0), labelCount(0) {}

    /**
     * @brief Generate a temporary variable name
     * @return Unique temp variable (e.g., t0, t1, t2, ...)
     */
    string generateTempVariable() {
        return "t" + to_string(tempVarCount++);
    }

    /**
     * @brief Generate a unique label name
     * @return Unique label (e.g., L0, L1, L2, ...)
     */
    string generateLabel() {
        return "L" + to_string(labelCount++);
    }

    /**
     * @brief Add a binary operation TAC
     * @param op Operation (+, -, *, /, %, <, >, ==, etc.)
     * @param arg1 First operand
     * @param arg2 Second operand
     * @param result Destination variable
     */
    void emitBinaryOp(const string& op, const string& arg1, const string& arg2, const string& result) {
        instructions.push_back(ThreeAddressCode(instructionCount++, op, arg1, arg2, result));
    }

    /**
     * @brief Add a unary operation TAC
     * @param op Operation (-, !)
     * @param arg Operand
     * @param result Destination variable
     */
    void emitUnaryOp(const string& op, const string& arg, const string& result) {
        instructions.push_back(ThreeAddressCode(instructionCount++, op, arg, result));
    }

    /**
     * @brief Add an assignment TAC
     * @param arg Source variable
     * @param result Destination variable
     */
    void emitAssignment(const string& arg, const string& result) {
        instructions.push_back(ThreeAddressCode(instructionCount++, "=", arg, result));
    }

    /**
     * @brief Add a conditional jump TAC
     * @param relop Relational operator (<, >, ==, !=, <=, >=)
     * @param arg1 First operand
     * @param arg2 Second operand
     * @param label Jump destination
     */
    void emitConditionalJump(const string& relop, const string& arg1, const string& arg2, const string& label) {
        ThreeAddressCode tac(instructionCount++, relop, arg1, arg2, label, true);
        instructions.push_back(tac);
    }

    /**
     * @brief Add an unconditional jump TAC
     * @param label Jump destination
     */
    void emitUnconditionalJump(const string& label) {
        instructions.push_back(ThreeAddressCode(instructionCount++, "", "", "", label, false));
        instructions.back().setLabel(label);
    }

    /**
     * @brief Add an array access (read) TAC: result = array[index]
     * @param arrayName Array variable name
     * @param index Array index
     * @param result Destination variable
     */
    void emitArrayAccess(const string& arrayName, const string& index, const string& result) {
        ThreeAddressCode tac(instructionCount++, arrayName, index, result);
        tac.setArrayAccess(true);
        instructions.push_back(tac);
    }

    /**
     * @brief Add an array assignment (write) TAC: array[index] = value
     * @param arrayName Array variable name
     * @param index Array index
     * @param value Source value
     */
    void emitArrayAssignment(const string& arrayName, const string& index, const string& value) {
        ThreeAddressCode tac(instructionCount++, arrayName, value, "");
        tac.setArrayAccess(true);
        tac.setResult(index);
        instructions.push_back(tac);
    }

    /**
     * @brief Add a function call TAC
     * @param funcName Function name
     * @param args Function arguments (comma-separated for clarity in output)
     * @param result Destination variable (for return value)
     */
    void emitFunctionCall(const string& funcName, const string& args, const string& result) {
        ThreeAddressCode tac(instructionCount++, funcName, args, result);
        tac.setFunctionCall(true);
        instructions.push_back(tac);
    }

    /**
     * @brief Add a return statement TAC
     * @param value Return value (empty string for void return)
     */
    void emitReturn(const string& value) {
        ThreeAddressCode tac(instructionCount++, "return", value, "");
        tac.setReturn(true);
        instructions.push_back(tac);
    }

    /**
     * @brief Add a print statement TAC
     * @param arg Variable/value to print
     */
    void emitPrint(const string& arg) {
        instructions.push_back(ThreeAddressCode(instructionCount++, "print", arg, ""));
    }

    /**
     * @brief Get all generated TAC instructions
     * @return Vector of all TAC instructions
     */
    const vector<ThreeAddressCode>& getInstructions() const {
        return instructions;
    }

    /**
     * @brief Print all TAC instructions to output stream
     * @param os Output stream
     */
    void printAll(ostream& os) const {
        os << endl << "=== Three-Address Code ===" << endl;
        for (const auto& instr : instructions) {
            instr.print(os);
        }
        os << "==== End of TAC ====" << endl << endl;
    }

    /**
     * @brief Clear all instructions (reset generator)
     */
    void clear() {
        instructions.clear();
        instructionCount = 0;
        tempVarCount = 0;
        labelCount = 0;
    }

    /**
     * @brief Get the count of generated instructions
     * @return Number of TAC instructions
     */
    int getInstructionCount() const {
        return instructions.size();
    }
};

#endif // THREE_ADDR_CODE_H
