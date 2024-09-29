/**
  * File:  PCcounter.sv
  *
  * Author1:  JunZhe Li (junzheli@buffalo.edu)
  * Partner: Andy Dong, Rupin Pradeep, Joseph Yang
  * Date:     03/31/2023
  * Course:   CSE490
  *
  * Summary of File:
  *
  *   This module is mainly used to read the previously stored instruction index and since the current CPU is not designed to branch or jump, each time the current instruction index is added by one and passed to the next instruction memory.
  *		
  *	Input: instruction_input_index_old
  *	Output: instruction_input_index_new
  
**/
module eight_bit_counter(
  input [7:0]instruction_input_index_old,//8 bit old instruction_index_input
  output reg [7:0]instruction_input_index_new//8 bit new instruction_index_output
    );
  
    initial
      // Initialize the "instruction_input_index_new" register
      // Wait until the "regFlagRead" signal goes high
      begin @ (regFlagRead)
        //because in this project, there are no branch and jump instruction the the pccounter update by plus one. 
            assign instruction_input_index_new = instruction_input_index_old + 1; // assign the new value of the instruction index
        end
    
endmodule