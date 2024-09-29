/**
  * File:  InstructionMemory.sv
  *
  * Author1:  JunZhe Li (junzheli@buffalo.edu)
  * Partner: Andy Dong, Rupin Pradeep, Joseph Yang
  * Date:     03/31/2023
  * Course:   CSE490
  *
  * Summary of File:
  *
  *   This module mainly includes the instruction storage and acquisition, the whole program includes one input and eight outputs, 
  *		the main work is to read the corresponding instruction index from the program counter and read the corresponding instruction directly from 
  *		the instruction memory, through the disassembly of the instruction, extract the opcode and other data for analysis, and finally 
  *		control the whole process through the output of each part.
  *		
  *	Input: instruction_input
  *	Output: control, register_1, register_2, immediate, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite
  
  * Getting Start:
  *	The output includes a control signal to indicate which operation the ALU is performing, register_1 & register_2 to indicate which register is used to store the calculation, MemRead to determine if the current instruction needs to read from memory, MemWrite to determine if the current instruction needs to read from memory to register, MemtoReg to determine if the result of the current instruction is the result of a direct connection to the ALU or the result of reading from memory, and ALUSrc to determine if the source of the ALU is the result of a regU or the result of reading from memory. MemWrite is used to determine whether the current instruction needs to read data from memory to register, MemtoReg is used to determine whether the result of the current instruction is directly connected to ALU or read from memory, ALUSrc is used to determine whether the source of ALU is register or intermediate value, and finally RegWrite is used to determine whether the result of the current instruction is directly connected to ALU or read from memory. is used to determine whether the current instruction needs to write the final result back to register memory.


**/
`timescale 1ns/100ps //Time and percision
module eight_bit_instruction_memory(instruction_input_index, instruction_input, control, register_rt_rd, register_rs, immediate, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite);
  // the reason why using output reg is because the output value need to be assign, so the wire does not work
  input [7:0]instruction_input_index;	// Input: 8-bit instruction input index
  output reg [7:0]instruction_input;	// Output: 8-bit instruction input
  output reg [2:0]control;	// Output: 3-bit control
  output reg register_rt_rd;	// Output: Register number for destination or source
  output reg register_rs;	// Output: Register number for source
  output reg [2:0]immediate; // Output: 3-bit immediate value

  output reg MemRead;	// Output: Read data from memory flag
  output reg MemtoReg;	// Output: Memory or ALU result to register flag
  output reg MemWrite;	// Output: Write data to memory flag
  output reg ALUSrc;	// Output: Choose between immediate or register for second operand flag
  output reg RegWrite;	// Output: Write result to register flag
  
  reg register_1_reg;//number of register
  reg register_2_reg;//number of register
  reg [2:0]immediate_reg; // 3 bit inmmediate
  reg [2:0]control_reg;
  reg MemRead_reg;	// MemRead flag Transit value
  reg MemtoReg_reg;	// MemtoReg flag Transit value
  reg MemWrite_reg;	// MemWrite flag Transit value
  reg ALUSrc_reg;	// ALUSrc flag Transit value
  reg RegWrite_reg;	// RegWrite flag Transit value
  reg [2:0]shamt;
  reg [2:0]op_code; // Can't use output in the case statement, so it's required to be done outside of procedural block
  reg [7:0]instruction_mem_cache[255:0];
  
  // Load instruction memory from a file called "instruction_mem.dat"
  initial begin
  	$readmemb("instruction_mem.dat", instruction_mem_cache);
  end
  
  // Define the always block to update the output based on the input and control values
  //Always is required since it will always execute whenever my inputs or control is changed
  always @ (instruction_input_index) @ (regFlagRead) begin
    instruction_input = instruction_mem_cache[instruction_input_index]; // collect instruction input by looking up the index of the instruction
    
    // Extract the opcode, immediate value, shamt, and register values from the instruction
    op_code = instruction_input[7:5]; 
  	immediate = instruction_input[2:0];
  	shamt = instruction_input[2:0];
  	register_rt_rd = instruction_input[4];
  	register_rs = instruction_input[3];
    
    //if op_code == 000 that means that the input instruction is R-type
  	if(op_code == 3'b000) begin
        // Use a case statement to determine the control signals based on the opcode and shamt values
    	case(shamt)
         	3'b000: begin	//add
           		control_reg = 3'b010;
           		MemRead_reg = 1'b0;
           		MemtoReg_reg = 1'b0;
           		MemWrite_reg = 1'b0;
           		ALUSrc_reg = 1'b0;
           		RegWrite_reg = 1'b1;
         	end
         	3'b111: begin	//sll
           		control_reg = 3'b111;
           		MemRead_reg = 1'b0;
           		MemtoReg_reg = 1'b0;
           		MemWrite_reg = 1'b0;
           		ALUSrc_reg = 1'b0;
           		RegWrite_reg = 1'b1;
         	end
      	endcase
    end
    // becuase the project setup, there only two type of instruction, when the opcode is not 0, that mean the instructionis I-type
  	else begin
    	case(op_code)	//Below are cases for each operation
      		3'b100: begin	//addi
        		control_reg = 3'b010;
        		MemRead_reg = 1'b0;
        		MemtoReg_reg = 1'b0;
        		MemWrite_reg = 1'b0;
        		ALUSrc_reg = 1'b1;
        		RegWrite_reg = 1'b1;
            end
      		3'b101:	begin	//sw
              	control_reg = 3'b010;
              	MemRead_reg = 1'b1;
        		MemtoReg_reg = 1'b0;
        		MemWrite_reg = 1'b1;
        		ALUSrc_reg = 1'b1;
        		RegWrite_reg = 1'b0;
            end
      		3'b110:	begin	//lw
              	control_reg = 3'b010;
              	MemRead_reg = 1'b1;
        		MemtoReg_reg = 1'b1;
        		MemWrite_reg = 1'b0;
        		ALUSrc_reg = 1'b1;
        		RegWrite_reg = 1'b1;
            end
      endcase
    end
  	control = control_reg;
    MemRead = MemRead_reg;
    MemtoReg = MemtoReg_reg;
    MemWrite = MemWrite_reg;
    ALUSrc = ALUSrc_reg;
    RegWrite = RegWrite_reg;
  end
endmodule