#include <cstddef>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <unordered_set>
#include <string>
#include <utility>
#include <vector>

//using namespace std;
//

using std::cerr;
using std::cout;
using std::map;
using std::ofstream;
using std::pair;
using std::string;
//using std::unordered_set;
using std::vector;

typedef uint8_t byte;
typedef struct { string label; int addr; } ref_t;
//typedef pair<string, int> ref_t; 
//typedef struct bytes_t { byte arr[sizeof(int)]; } bytes_t;

vector<byte> bcode; // bytecodes
int reg[16]; // registers
map<string, int> labels; // position of labels
vector<ref_t> unresolved_labels;

void bput(byte b) { bcode.push_back((byte) b); }
byte bget(int& ip) { return bcode[ip++]; }


union reg_t {
	byte bytes[sizeof(int)];
	int  i;
};

void bputint(int i) 
{
	//byte* bs = static_cast<byte*>(static_cast<void*>(&i));
	//for(int j = 0; j< sizeof(int); ++j) bcode.push_back(bs[j]);

	union reg_t bytes;
	bytes.i = i;
	for(int j = 0; j< sizeof(int); ++j) bcode.push_back(bytes.bytes[j]);
}

int bgetint(int& ip)
{
	union reg_t bytes;
	//bytes.i = i;
	for(int j = 0; j< sizeof(int); ++j) 
		bytes.bytes[j] = bcode[ip++];
	return bytes.i;
}


void label(string name)
{
	int addr = bcode.size();
	labels[name] = addr;
	//cout << "label " << name << " " << addr << "\n";
}

void resolve_labels()
{
	for(auto& ref: unresolved_labels) {
		//const string& label = ref.first;
		//int& addr = ref.second;
		int offset = labels[ref.label];
		union reg_t addr;
		addr.i = ref.addr;
		//cout << "resolving " << ref.label << " overlay at " << ref.addr << " offset " << offset << "\n";
		for(int j=0; j<sizeof(int); ++j) {
			bcode[ref.addr + j] = offset & 0xFF;
			offset >>= 8;
		}
	}
}

void halt() { bput(0); }
void nop() { bput(1); }
void trap() { bput(2); }

void add(int rx, int ry)
{
	bput(3);
	bput(rx);
	bput(ry);
}
void sub(int rx, int ry)
{
	bput(4);
	bput(rx);
	bput(ry);
}


void lda(int off, byte rx, byte ry)
{
	bput(9);
	bputint(off);
	bput(rx);
	bput(ry);
}

void bnz(string label)
{ 
	bput(12); 
	//auto it = labels.find(label);
	//if(it == labels.end()) { // unresolved reference
	int addr = (int) bcode.size();
	ref_t ref{label, addr};
	unresolved_labels.push_back(ref);
	bputint(0xDEAD2BAD); 
	//cout << "writing bnz label " << label << " for address " << addr << "\n";
	//} else { // we know what the reference is, so just use it
	//	bputint(it->second);
//}
}

void run() 
{
	for(int i = 0; i<16; i++) reg[i] = 0;

	int ip = 0, zset = 0;
	while(byte b = bcode[ip++]) { // halt is automatically taken care of
		int off, rx, ry, ryn, tmp;
		switch(b) {
			case 1:	break; // nop
			case 2: // trap
				//cout << "trap called";
				cout << (char) reg[15] ;
				break;
			case 3: // add
				rx = reg[bget(ip)];
				ryn = bget(ip);
				ry = reg[ryn];
				ry = rx + ry;
				reg[ryn] = ry;
				zset = ry == 0;
				break;
			case 4: // sub
				rx = reg[bget(ip)];
				ryn = bget(ip);
				ry = reg[ryn];
				ry = rx - ry;
				reg[ryn] = ry;
				zset = ry == 0;
				break;
			case 9:  //lda
				off = bgetint(ip);
				rx = reg[bget(ip)];
				ryn = bget(ip);
				//cout << "lda " << off << " " << rx << "  ryn " << ryn << "\n";
				reg[ryn] = rx + off;
				zset = reg[ryn] == 0;
				break;
			case 12: // bnz
				tmp = bgetint(ip);
				if(zset == 0) ip = tmp;
				//cout << "bnz " << ip << "\n";
				break;
			default:
				cerr << "Guru meditation with byte " << b <<  "at ip " << (ip-1) << "\n";
		}
	}
}

void prog()
{
	nop();
	lda(5, 0, 1);
	lda(1, 2, 2);
	sub(0, 2);
	lda('X', 0, 15);
	label("L1");
	trap();
	add(2, 1);
	//lda(-1, 1, 1);
	bnz("L1");	
	halt();
}

void dump()
{
	//for(int i = 0; i<bcode.size(); ++i)
	ofstream ostr;
	ostr.open("a.bin");
	for(auto b: bcode) ostr << b;
	ostr.close();
	//cout << "\nDump finished\n";
}

int main() 
{
	prog();
	resolve_labels();
	dump();
	run();
	return 0;
}
