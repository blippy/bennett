#include <cassert>
#include <cstdint>
#include <istream>
#include <iostream>
#include <map>
//#include <regex>
#include <string>
#include <vector>

using std::cin;
//using std::cmatch;
using std::cout;
using std::map;
//using std::regex;
//using std::regex_match;
using std::string;
using std::vector;

typedef uint8_t byte;

enum argtypes { NIL = 0, RX, RY, OFF };

typedef struct {
	string name;
	argtypes args[3];
} ocdesc_t; // opcode descriptions

vector<ocdesc_t> opcodes =
{
	{"HALT", {NIL, NIL, NIL}},
	{"NOP", {NIL, NIL, NIL}},
	{"TRAP", {NIL, NIL, NIL}},
	{"ADD", {RX, RY, NIL}},
	{"SUB", {RX, RY, NIL}},
	{"MUL", {RX, RY, NIL}},
	{"DIV", {RX, RY, NIL}},
	{"STI", {RX, OFF, RY}},
	{"LDI", {OFF, RX, RY}},
	{"LDA", {OFF, RX, RY}},
	{"LDR", {RX, RY, NIL}},
	{"BZE", {OFF, NIL, NIL}},
	{"BNZ", {OFF, NIL, NIL}},
	{"BRA", {OFF, NIL, NIL}},
	{"BAL", {RX, RY, NIL}}
};

map<string, byte> opmap; 

void init_opmap()
{
	byte idx = 0;
	for(auto& oc: opcodes)
		opmap[oc.name] = idx++;
}

const char white[] = " \t\r";

std::string trim(const std::string& str)
{
    if(str.length() ==0) { return str;}
    size_t first = str.find_first_not_of(white);
    if(first == std::string::npos) return "";
    size_t last = str.find_last_not_of(white);
    return str.substr(first, (last-first+1));
}

std::vector<std::string> tokenize_line(std::string &input) //, const char sep= ' ')
{
        std::vector<std::string> output;
        std::string trimmed = input;
        std::string token;
        size_t first;
        int i;
loop:
        trimmed = trim(trimmed);
        if(trimmed.length() == 0) goto fin;
        //cout << "len = " << trimmed.length() << endl;
        if(trimmed[0] == '#') goto fin;
        if(trimmed[0] == '"') {
                token = "";
                for(i=1; i<trimmed.length(); i ++) {
                        switch (trimmed[i]) {
                        case '"':
                                output.push_back(token);
                                trimmed = trimmed.substr(i+1);
                                goto loop;
                        case ' ':
                                token += ' ' ; //167 ; // 26; // so that fields work
                                break;
                        default :
                                token += trimmed[i];
                        }
                }
                // hit eol without enclosing "
                output.push_back(token);
                goto fin;
        } else { // normal case
                first = trimmed.find_first_of(white);
                if(first == std::string::npos) {
                        output.push_back(trimmed);
                        goto fin;
                }
                token = trimmed.substr(0, first);
                output.push_back(token);
                trimmed = trimmed.substr(first+1);
                goto loop;
        }
        assert(false); // we should never get here


fin:
        return output;
}


void read_label(string line)
{
	string label;
	for(auto c:line) {
		if(c==':')
			break;
		else 
			label += c;
	}

	cout << "label: `" << label << "'\n";
}

void read_command(string line)
{
	/*
	regex rx1 ("\\s+(\\w+)\\s+(.*)");
	cmatch cm1;
	regex_match(line.c_str(), cm1, rx1);
	cout << "COMMAND: " << cm1[0] << "," << cm1[1] << "\n";
	*/
	while(isspace(line[0])) line.erase(0,1);
	cout << "Remaining line: " << line << "\n";
	string instr;
	while(!isspace(line[0]) && line[0]) { 
		instr += line[0]; 
		line.erase(0,1);  
		//cout << (int)line[0] ;
	}
	//while(isspace(line[0])) line.erase(0,1);
	cout << "args:" << line << "\n";

	cout << "inst:" << instr << "\n";

	for(int i =0; i<line.size(); ++i) {
		char c = line[i];
		if(c == 'R' || c == ',' || c == '(' || c == ')')
			line[i] = ' ';
	}

	vector<string> args = tokenize_line(line);
	for(auto& arg: args) {
		cout << "arg: " << arg << "\n";
	}
	cout <<"\n";
}

int main()
{
	init_opmap();
	string line;
	while(getline(cin, line)) {
		if(line.size()==0 || line[0] == '\\') continue;
		if(isspace(line[0])) 
			read_command(line);
		else 
			read_label(line);
		

		//cout << "line: " << line << "\n";
	}

	return 0;
}
