#include "scope_table.h"

class symbol_table
{
private:
    scope_table *active_scope;
    int num_buckets;
    int next_scope_id;
    ofstream* log_stream;

public:
    symbol_table(int num_buckets, ofstream* log)
    {
        this->num_buckets = num_buckets;
        this->active_scope = NULL;  
        this->next_scope_id = 1;   
        this->log_stream = log;              
    }

    ~symbol_table()
    {
        while (active_scope != NULL)
        {
            exit_scope();
        }
    }

    void enter_scope()
    {
        scope_table *new_table = new scope_table(num_buckets, next_scope_id++, active_scope);
        active_scope = new_table;
        *log_stream << "New ScopeTable with ID " << active_scope->get_unique_id() << " created\n\n";
    }

    void exit_scope()
    {
        if (active_scope == NULL)
        {
            *log_stream << "No scope to exit.\n\n";
            return;
        }
        *log_stream << "Scopetable with ID " << active_scope->get_unique_id() << " removed\n\n";
        scope_table *old_scope = active_scope;
        active_scope = active_scope->get_parent_scope();  
        delete old_scope;  
    }

    bool insert(symbol_info* symbol)
    {
        if (active_scope == NULL)
        {
            return false;  
        }
        return active_scope->insert_in_scope(symbol);
    }
    
    symbol_info* lookup(symbol_info* symbol)
    {
        string sym_name = symbol->getname();
        scope_table *current_scope = active_scope;
        while (current_scope != NULL)
        {
            symbol_info* found = current_scope->lookup_in_scope(symbol);
            if (found != NULL)
            {
                return found;  
            }
            current_scope = current_scope->get_parent_scope();  
        }
        return NULL;  
    }

    void print_current_scope()
    {
        if (active_scope != NULL)
        {
            active_scope->print_scope_table(*log_stream);
        }
        else
        {
            *log_stream << "No active scope.\n";
        }
    }

    void print_all_scopes()
    {
        *log_stream << "################################\n\n";
        scope_table *current_scope = active_scope;
        while (current_scope != NULL)
        {
            current_scope->print_scope_table(*log_stream);
            current_scope = current_scope->get_parent_scope();
        }
        *log_stream << "################################\n\n";
    }
};