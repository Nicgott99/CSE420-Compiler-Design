#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H

#include<bits/stdc++.h>
using namespace std;

class symbol_info
{
private:
    string sym_name;  
    string sym_category;
    string category_type = "NAN";
    string data_type;
    vector<string> param_types;
    int array_dimension;

public:
    symbol_info(string name, string category)
    {
        this->sym_name = name;
        this->sym_category = category;
    }

    string getname()
    {
        return sym_name;
    }

    string get_type()
    {
        return sym_category;
    }

    string get_symbol_type()
    {
        return category_type;
    }

    string get_return_type()
    {
        return data_type;
    }

    int get_size()
    {
        return array_dimension;
    }

    vector<string> get_params()
    {
        return param_types;
    }

    void set_name(string name)
    {
        this->sym_name = name;
    }

    void set_type(string category)
    {
        this->sym_category = category;
    }

    void set_symbol_type(string category_type)
    {
        this->category_type = category_type;
    }

    void set_return_type(string data_type)
    {
        this->data_type = data_type;
    }

    void set_size(int array_dimension)
    {
        this->array_dimension = array_dimension;
    }

    void add_param_type(string param)
    {
        param_types.push_back(param);
    }
};

#endif