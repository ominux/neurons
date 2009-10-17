#ifndef CONFIGURATION_H_
#define CONFIGURATION_H_

#include <map>
#include <sstream>
#include "Object.h"
#include "utils.h"

using namespace std;

class Configuration : public Object
{
public:
  string filename;

  map< string, string> stock;

  Configuration(string filename)
  {
    assert(fileExists(filename));
    this->filename = filename;
    loadFromFile(filename);
  };

  string retrieve(string name)
  {
    return stock[name];
  };

  void add(string nameVariable, string value){
    stock[nameVariable] = value;
  }

  bool load(istream& in){
    string name, attribute;
    char lineb[1024]; //lines of 1024 chars
    while(in.good()){
      in.getline(lineb,1024);
      string line(lineb);
      stringstream linestream(line);
      linestream >> name;
      if(name.length() > 0){
        if (name[0] == '#')
          continue;
      }
      linestream >> attribute;
      stock[name] = attribute;
    }
    return true;
  }

  void save(ostream& out){
    for(map<string, string>::iterator it = stock.begin();
        it != stock.end();
        it++){
      out << it->first << " " << it->second << std::endl;
    }
  }

};



#endif