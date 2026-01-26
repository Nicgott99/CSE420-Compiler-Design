#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H

#include<bits/stdc++.h>
using namespace std;

/**
 * @class symbol_info
 * @brief Represents a symbol in the compiler's symbol table
 * 
 * This class encapsulates information about symbols (identifiers) found during
 * lexical and syntax analysis. It stores basic properties like name and type,
 * and can be extended to store additional attributes for variables, arrays, 
 * and functions.
 */
class symbol_info
{
private:
    string name;    ///< Symbol identifier name
    string type;    ///< Symbol type information

    // Write necessary attributes to store what type of symbol it is (variable/array/function)
    // Write necessary attributes to store the type/return type of the symbol (int/float/void/...)
    // Write necessary attributes to store the parameters of a function
    // Write necessary attributes to store the array size if the symbol is an array

public:
    /**
     * @brief Constructor for symbol_info
     * @param name The identifier name of the symbol
     * @param type The type information of the symbol
     */
    symbol_info(string name, string type)
    {
        this->name = name;
        this->type = type;
    }

    /**
     * @brief Get the name of the symbol
     * @return String containing the symbol name
     */
    string get_name()
    {
        return name;
    }

    /**
     * @brief Get the type of the symbol
     * @return String containing the symbol type
     */
    string get_type()
    {
        return type;
    }

    /**
     * @brief Set the name of the symbol
     * @param name New name for the symbol
     */
    void set_name(string name)
    {
        this->name = name;
    }

    /**
     * @brief Set the type of the symbol
     * @param type New type for the symbol
     */
    void set_type(string type)
    {
        this->type = type;
    }

    // Write necessary functions to set and get the attributes

    /**
     * @brief Destructor for symbol_info
     */
    ~symbol_info()
    {
        // Write necessary code to deallocate memory, if necessary
    }
};

#endif // SYMBOL_INFO_H