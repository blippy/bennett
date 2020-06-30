# myvm

My own attempt at writing the VM in C++. It should be shorter and easier to understand.

## Versions

* [v1 ](v1/README.md) - implements HALT, NOP, TRAP, ADD, SUB, LDI, LDA, BNZ. A test program is hard-coded

## Opcodes

These are described on page 232 of Bennett's bool.

00 HALT
01 NOP
02 TRAP
03 ADD Rx, Ry \ Ry := Rx + Ry
04 SUB Rx, Ry \ Ry := Rx - Ry
05 MUL Rx, Ry 
06 DIV
07 STI Rx,offset(Ry) \ *(Ry+offset) := Rx
08 LDI offset(Rx), Ry \ Ry  := *(Rx+offset)
09 LDA offset(Rx), Ry \ Ry := Rx + offset
10 LDR Rx, Ry  \ Ry := Rx
11 BZE offset
12 BNZ offset
13 BRA offset
14 BAL Rx, Ry
15 SYS  offset \ make a system call
16 BLTZ offset \ branch on less than or equal to 0
17 BGTZ offset \ branch on greater than or equal to 0 

Instructions 15 onwards were added by M Carter. They are understood by asm.p6, disasm.p6 and vam. vc does not generate them, nor does asm or disasm understand them

SYS is for making "system" calls

## Registers and calling conventions

The VAM has 16 registers, labelled R0..R15

The following special purpose or conventions apply:
* R0 - always 0
* R1 - stack pointer
* R2 - holds address of called routine
* R3 - holds return address of the entering routine
* R4 - return result

Routine arguments are passed on the stack, not in registers.
