# myvm

My own attempt at writing the VM in C++. It should be shorter and easier to understand.

## Versions

* [v1 ](v1/README.md) - implements HALT, NOP, TRAP, ADD, SUB, LDI, LDA, BNZ. A test program is hard-coded

## Opcodes

These are described on page 232 of Bennett's bool.

00 HALT
01 NOP
02 TRAP
03 ADD
04 SUB
05 MUL
06 DIV
07 STI
08 LDI
09 LDA
10 LDR
11 BZE
12 BNZ
13 BRA
14 BAL

## Registers and calling conventions

The VAM has 16 registers, labelled R0..R15

The following special purpose or conventions apply:
* R0 - always 0
* R1 - stack pointer
* R2 - holds address of called routine
* R3 - holds return address of the entering routine
* R4 - return result

Routine arguments are passed on the stack, not in registers.
