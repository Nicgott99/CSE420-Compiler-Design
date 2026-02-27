#include "symbol_info.h"

class scope_table
{
private:
    int num_buckets;
    int scope_id;
    scope_table *outer_scope = NULL;
    vector<list<symbol_info *>> hash_table;

    int calculate_hash(string sym_name)
    {
        unsigned long hash_val = 0;
        for (char ch : sym_name)
        {
            hash_val = (hash_val * 31 + ch) % num_buckets;
        }
        return hash_val;
    }

public:
    scope_table() {}

    scope_table(int num_buckets, int scope_id, scope_table *outer_scope = NULL)
        : num_buckets(num_buckets), scope_id(scope_id), outer_scope(outer_scope)
    {
        hash_table.resize(num_buckets);
    }

    scope_table *get_parent_scope()
    {
        return outer_scope;
    }

    int get_unique_id()
    {
        return scope_id;
    }

    symbol_info *lookup_in_scope(symbol_info* symbol)
    {
        string sym_name = symbol->getname();
        int bucket_idx = calculate_hash(sym_name);
        for (symbol_info *entry : hash_table[bucket_idx])
        {
            if (entry->getname() == sym_name)
            {
                return entry; 
            }
        }
        return nullptr;
    }

    bool insert_in_scope(symbol_info* symbol)
    {
        if (lookup_in_scope(symbol) != nullptr)
        {
            return false;
        }
        int bucket_idx = calculate_hash(symbol->getname());
        hash_table[bucket_idx].push_back(symbol);
        return true;
    }

    bool delete_from_scope(symbol_info* symbol)
    {
        string sym_name = symbol->getname();
        int bucket_idx = calculate_hash(sym_name);
        for (auto iter = hash_table[bucket_idx].begin(); iter != hash_table[bucket_idx].end(); ++iter)
        {
            if ((*iter)->getname() == sym_name)
            {
                hash_table[bucket_idx].erase(iter);
                return true;
            }
        }
        return false;
    }

    void print_scope_table(ofstream& log_stream)
    {
        log_stream << "ScopeTable # " + to_string(scope_id) << endl;

        for (int bucket_num = 0; bucket_num < num_buckets; ++bucket_num)
        {
            if (!hash_table[bucket_num].empty())
            {
                log_stream << bucket_num << " --> " << endl;
                for (symbol_info *entry : hash_table[bucket_num])
                {
                    log_stream << "< " << entry->getname() << " : " << entry->get_type() << " >" << endl;

                    if (entry->get_symbol_type() == "Function Definition")
                    {
                        vector<string> params_list = entry->get_params();
                        int param_count = params_list.size();
                        entry->set_size(param_count);

                        log_stream << entry->get_symbol_type() << endl;
                        log_stream << "Return Type: " << entry->get_return_type() << endl;
                        log_stream << "Number of Parameters: " << param_count << endl;

                        log_stream << "Parameter Details: ";
                        for (size_t param_idx = 0; param_idx < param_count; param_idx++) 
                        {
                            log_stream << params_list[param_idx];
                            if (param_idx != param_count - 1) 
                            {
                                log_stream << ", ";
                            }
                        }

                        log_stream << endl;
                    }
                    else
                    {
                        log_stream << entry->get_symbol_type() << endl;
                        log_stream << "Type: " << entry->get_return_type() << endl;
                        if (entry->get_symbol_type() == "Array")
                        {
                            log_stream << "Size: " << entry->get_size() << endl;
                        }
                    }
                }
                log_stream << endl;
            }
        }
    }

    ~scope_table()
    {
        for (int bucket_num = 0; bucket_num < num_buckets; ++bucket_num)
        {
            for (symbol_info *entry : hash_table[bucket_num])
            {
                delete entry;
            }
        }
    }
};