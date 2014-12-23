The project consists of a basic processor with a flow-through architecture where instructions are all executed in one clock cycle. 
The processor's components are as follows:
1. Program counter
2. ALU
3. Instruction and data memory 
4. 2-port Register file (8 registers)
5. Branch controller (for different branch conditions)

A block diagram of the processor is provided in this project folder.

The instruction word is 32-bits with a format as follows:
LSBJRX#_param_s1_s2_dest_literal

b31-25 indicate the type of instruction
b31: load 
b30: store 
b29: branch
b28: jump
b27: register to register (add, subtract, etc.)
b26: reset
b25: literal bit (to indicate that the literal of the instruction is used)

b24-21 indicate the parameter for the ALU or Branch controller.

b20-18 is the address of source 1 
b17-15 is the address of source 2
b14-12 is the address of the destination
b11-0 is the literal

eg. ram[0] 	= 32'b0000100_0011_000_001_010_000000000000;	//r2r, add, r2 = r0+r1
