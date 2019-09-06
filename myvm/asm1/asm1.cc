#include <string>
#include <vector>

using std::string;
using std::vector;

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

int main()
{
	return 0;
}
