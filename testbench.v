`timescale 1ns/1ns

module testbench();
reg clk_i;
reg rst_ni;//, instr_gnt_i,instr_rvalid_i, data_gnt_i, data_rvalid_i;

/////*****  Core Selection (Micro or Zero)   *****/////
//reg RV32E;
//reg RV32M;
///////////////////////////////////////////////////////
    

//wire [3:0] test;
//wire instr_req_o, data_req_o;
//wire [31:0] data_addr_o;
//wire [3:0] test_data_wdata_o/*, data_addr_o*/;
//wire data_we_o;

wire [7:0] SEG;
wire [7:0] strobe;
wire       led_toggle_based_on_mul_execution_time;


// instantiate device to be tested
top dut (
         .clk_i(clk_i),
         .rst_ni(rst_ni),
         
         /////*****  Core Selection (Micro or Zero)   *****/////
//         .RV32E (RV32E),
//         .RV32M (RV32M),
///////////////////////////////////////////////////////
         
//         .test(test),
//         .instr_gnt_i(instr_gnt_i),
//         .instr_rvalid_i(instr_rvalid_i),
//         .data_gnt_i(data_gnt_i),
//         .data_rvalid_i(data_rvalid_i),
//         .instr_req_o(instr_req_o),
//         .data_req_o(data_req_o),
//         .test_data_wdata_o(test_data_wdata_o) 
//         .data_addr_o(data_addr_o), 
//         .data_we_o(data_we_o)
           .SEG(SEG),
           .strobe(strobe),
           .led_toggle_based_on_mul_execution_time(led_toggle_based_on_mul_execution_time)
         );

// initialize test
initial
begin

clk_i = 1;
rst_ni = 0; # 20; rst_ni = 1;

repeat (1000000)  @(negedge clk_i);
        #1000000 
        $stop;
//if(instr_req_o == 1'b1)
//    begin
//    instr_rvalid_i = 1'b1;
//    instr_gnt_i = 1'b1;
//    end
//else 
//    begin
//    instr_rvalid_i = 1'b0;
//    instr_gnt_i = 1'b0;
//    end

//if(data_req_o == 1'b1)
//    begin   
//    data_rvalid_i = 1'b1;
//    data_gnt_i = 1'b1;
//    end
//else
//    begin
//    data_rvalid_i = 1'b0;
//    data_gnt_i = 1'b0;
//    end  
end

// generate clock to sequence tests
always
begin
clk_i = 1; # 5; clk_i = 0; # 5;
end

// check results
//always @ (negedge clk_i)
//begin
//	if (data_we_o) begin
//		if (data_addr_o == 84 & test_data_wdata_o == 7) begin
//			$display ("Simulation succeeded");
//			$stop;
//		end else if (data_addr_o != 80) begin
//			$display ("Simulation failed");
//			#1200
//			$stop;
//			end
//	end
//end

endmodule
