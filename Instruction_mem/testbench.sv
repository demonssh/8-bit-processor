/**
  * File:  insMem_tb.sv
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
  *	  This part of the test tests whether the program can split the instructions efficiently and extract the correct data by calling the instructions in the memfile.
  *		
  *	Input: instruction_input_tb
  *	Output: control_tb, register_1_tb, register_2_tb, immediate_tb, MemRead_tb, MemtoReg_tb, MemWrite_tb, ALUSrc_tb, RegWrite_tb


**/
`timescale 1ns/100ps
module eight_bit_instruction_memory_TEST;
  
  // Define input and output registers
  // in order to make different between variable in testbench and variable in design file
  // the variable in testbench will be end by _tb
  reg [7:0]instruction_input_index_tb;//8 bit input
  reg [7:0]instruction_input_tb;
  reg [2:0]control_tb; //4 bit control
  reg register_rt_rd_tb; //1 bit output
  reg register_rs_tb;//8 bit output
  reg [2:0]immediate_tb;
  
  reg MemRead_tb;
  reg MemtoReg_tb;
  reg MemWrite_tb;
  reg ALUSrc_tb;
  reg RegWrite_tb;

  reg [2:0]shamt;
  reg [2:0]op_code;
  reg [7:0]RAM[9:0];//5 pairs of 8-bit input
  
  //Call the module
  eight_bit_instruction_memory dut(.instruction_input_index(instruction_input_index_tb), .instruction_input(instruction_input_tb), .control(control_tb), .register_rt_rd(register_rt_rd_tb), .register_rs(register_rs_tb), .immediate(immediate_tb), .MemRead(MemRead_tb), .MemtoReg(MemtoReg_tb), .MemWrite(MemWrite_tb), .ALUSrc(ALUSrc_tb), .RegWrite(RegWrite_tb));
  
  initial
    begin
      $readmemb("memfile.dat",RAM); // Read memory in binary
    end
  
  initial
    begin
      // Read the RAM data from a binary file
      // The binary file containt the instruction index of the program
      instruction_input_index_tb = RAM[0];	// Initialize a monitor to display the values of the input and output registers
    end
  
  always
    begin
      // Use an always block to update the instruction_input_index_tb register based on the values in the RAM data
      #15 instruction_input_index_tb = RAM[1];
      #15 instruction_input_index_tb = RAM[2];
      #15 instruction_input_index_tb = RAM[3];
      #15 instruction_input_index_tb = RAM[4];
    end
  
  
  // Initialize a monitor to display the values of the input and output registers
  initial
    begin
      //seperate from warnings
      $display("----------------------------------------------------------------------------");
  //header row
      //output once
      $display("Project 2 Log\n");
      $display("instruction_input_index\t\tinstruction_input\t\tcontrol\t\tregister_rt_rd\t\tregister_rs\t\timmediate\t\tMemRead\t\tMemtoReg\t\tMemWrite\t\tALUSrc\t\tRegWrite");
      $display("----------------------------------------------------------------------------");
      $monitor("%b\t\t%b\t\t\t%b\t\t%b\t\t\t%b\t\t\t%b\t\t\t%b\t\t%b\t\t\t%b\t\t\t%b\t\t%b",instruction_input_index_tb, instruction_input_tb, control_tb, register_rt_rd_tb, register_rs_tb, immediate_tb, MemRead_tb, MemtoReg_tb, MemWrite_tb, ALUSrc_tb, RegWrite_tb); //finish the monitor variables
    end

  //Make sure it ends
initial #60 $finish; 
endmodule  