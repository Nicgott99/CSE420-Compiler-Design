#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include "scope_table.h"

/**
 * @class symbol_table
 * @brief Manages hierarchical symbol tables for nested scopes
 * 
 * This class provides a complete symbol table management system supporting
 * nested scopes. It handles scope creation/destruction, symbol insertion,
 * and lookup operations across the scope hierarchy.
 */
class symbol_table
{
private:
    scope_table *current_scope;     ///< Pointer to the current active scope
    int bucket_count;              ///< Number of buckets for new scope tables
    int current_scope_id;          ///< Counter for generating unique scope IDs

public:
    /**
     * @brief Constructor for symbol table
     * @param bucket_count Number of buckets for hash tables in each scope
     */
    symbol_table(int bucket_count);

    /**
     * @brief Destructor - cleans up all scope tables
     */
    ~symbol_table();

    /**
     * @brief Create and enter a new scope
     * 
     * Creates a new scope table and makes it the current active scope.
     * The previous scope becomes the parent of the new scope.
     */
    void enter_scope();

    /**
     * @brief Exit the current scope
     * 
     * Destroys the current scope and returns to the parent scope.
     * The current scope becomes the parent of the destroyed scope.
     */
    void exit_scope();

    /**
     * @brief Insert a symbol into the current scope
     * @param symbol Symbol to insert
     * @return True if insertion successful, false if symbol already exists in current scope
     */
    bool insert(symbol_info* symbol);

    /**
     * @brief Look up a symbol in the symbol table
     * 
     * Searches for the symbol starting from the current scope and moving up
     * through parent scopes until the symbol is found or all scopes are searched.
     * 
     * @param symbol Symbol to search for
     * @return Pointer to symbol if found, NULL otherwise
     */
    symbol_info* lookup(symbol_info* symbol);

    /**
     * @brief Print the current scope table
     */
    void print_current_scope();

    /**
     * @brief Print all scope tables from current to global
     * @param outlog Output stream to write the scope tables
     */
    void print_all_scopes(ofstream& outlog);

    // you can add more methods if you need 
};

// complete the methods of symbol_table class

// Implementation template for print_all_scopes method
// void symbol_table::print_all_scopes(ofstream& outlog)
// {
//     outlog<<"################################"<<endl<<endl;
//     scope_table *temp = current_scope;
//     while (temp != NULL)
//     {
//         temp->print_scope_table(outlog);
//         temp = temp->get_parent_scope();
//     }
//     outlog<<"################################"<<endl<<endl;
// }

#endif // SYMBOL_TABLE_H