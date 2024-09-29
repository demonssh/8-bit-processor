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
  *   This module is mainly used to read the previously stored instruction index and since the current CPU is not designed to branch or jump, each time the current instruction index is added by one and passed to the next instruction memory. This part of the test is performed by testing whether the input instruction index can be correctly added to one.
  *		 
  *	Input: instruction_input_index_old_tb
  *	Output: instruction_input_index_new_tb
  
**/
module eight_bit_counter_Test;
  reg [7:0]instruction_input_index_old_tb;	//set up the input variable
  reg [7:0]instruction_input_index_new_tb;	//set up the output variable
  
  initial
    begin
    instruction_input_index_old_tb = 0;
    end
  
  // Instantiate the "eight_bit_counter" module and connect its inputs and outputs to the input and output registers
  eight_bit_counter dut(.instruction_input_index_old(instruction_input_index_old_tb), .instruction_input_index_new(instruction_input_index_new_tb)); // assign up the variable connect to variable in design.sv
  
  // Use an always block to update the "instruction_input_index_old_tb" register with new values every 5 units of time
  always
    begin
      #5 instruction_input_index_old_tb = 1;
      #5 instruction_input_index_old_tb = 2;
      #5 instruction_input_index_old_tb = 3;
      
    end
  
  // Initialize a monitor to display the values of the input and output registers
  initial
    begin
      $display("instruction_input_index_old\t\tinstruction_input_index_new");	// set up the display element
      $monitor("%d\t\t\t\t%d",instruction_input_index_old_tb, instruction_input_index_new_tb);	//assign the display element with the test variable
    end
  
  initial
    #25 $finish; // the reason is to show the situation a = 1, b = 1 more clearly in EPWave
  
endmodule