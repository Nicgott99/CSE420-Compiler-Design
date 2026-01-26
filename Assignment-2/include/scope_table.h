#ifndef SCOPE_TABLE_H
#define SCOPE_TABLE_H

#include "symbol_info.h"
#include <list>
#include <vector>

/**
 * @class scope_table
 * @brief Manages symbol storage for a single scope level
 * 
 * This class implements a hash table to store symbols within a specific scope.
 * It supports insertion, lookup, and deletion of symbols, and maintains a 
 * reference to its parent scope for hierarchical scope management.
 */
class scope_table
{
private:
    int bucket_count;                           ///< Number of hash table buckets
    int unique_id;                             ///< Unique identifier for this scope
    scope_table *parent_scope = NULL;          ///< Pointer to parent scope
    vector<list<symbol_info *>> table;        ///< Hash table with chaining

    /**
     * @brief Hash function to determine bucket for a symbol name
     * @param name Symbol name to hash
     * @return Bucket index for the symbol
     */
    int hash_function(string name)
    {
        // write your hash function here
        // Placeholder implementation - should be replaced with proper hash function
        return 0;
    }

public:
    /**
     * @brief Default constructor
     */
    scope_table();

    /**
     * @brief Parameterized constructor
     * @param bucket_count Number of buckets in the hash table
     * @param unique_id Unique identifier for this scope
     * @param parent_scope Pointer to parent scope table
     */
    scope_table(int bucket_count, int unique_id, scope_table *parent_scope);

    /**
     * @brief Get parent scope table
     * @return Pointer to parent scope table
     */
    scope_table *get_parent_scope();

    /**
     * @brief Get unique identifier of this scope
     * @return Unique ID of the scope
     */
    int get_unique_id();

    /**
     * @brief Look up a symbol in this scope only
     * @param symbol Symbol to search for
     * @return Pointer to symbol if found, NULL otherwise
     */
    symbol_info *lookup_in_scope(symbol_info* symbol);

    /**
     * @brief Insert a symbol into this scope
     * @param symbol Symbol to insert
     * @return True if insertion successful, false if symbol already exists
     */
    bool insert_in_scope(symbol_info* symbol);

    /**
     * @brief Delete a symbol from this scope
     * @param symbol Symbol to delete
     * @return True if deletion successful, false if symbol not found
     */
    bool delete_from_scope(symbol_info* symbol);

    /**
     * @brief Print all symbols in this scope table
     * @param outlog Output stream to write the scope table contents
     */
    void print_scope_table(ofstream& outlog);

    /**
     * @brief Destructor - cleans up all symbols in this scope
     */
    ~scope_table();

    // you can add more methods if you need
};

// complete the methods of scope_table class
void scope_table::print_scope_table(ofstream& outlog)
{
    outlog << "ScopeTable # "+ to_string(unique_id) << endl;

    //iterate through the current scope table and print the symbols and all relevant information
}

#endif // SCOPE_TABLE_H