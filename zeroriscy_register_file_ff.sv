// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the â€œLicenseâ€?); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an â€œAS ISâ€? BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

////////////////////////////////////////////////////////////////////////////////
// Engineer:       Francesco Conti - f.conti@unibo.it                         //
//                                                                            //
// Additional contributions by:                                               //
//                 Markus Wegmann - markus.wegmann@technokrat.ch              //
//                                                                            //
// Design Name:    RISC-V register file                                       //
// Project Name:   zero-riscy                                                 //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Register file with 31 or 15x 32 bit wide registers.        //
//                 Register 0 is fixed to 0. This register file is based on   //
//                 flip flops.                                                //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//`timescale 1ns/1ns
`include "D:/Mohamed Adel Elsheimy/zero-riscy-system-verilog-pulpinov1/include/zeroriscy_config.sv"

module zeroriscy_register_file
#(
  parameter RV32E         = 0,
  parameter DATA_WIDTH    = 32
)
(
  // Clock and Reset
  input  logic                   clk,
  input  logic                   rst_n,
  
  /////*****  Core Selection (Micro or Zero)   *****/////
//  input  logic        RV32E,
  ///////////////////////////////////////////////////////

  input  logic                   test_en_i,

  //Read port R1
  input  logic [4:0]             raddr_a_i,
  output logic [DATA_WIDTH-1:0]  rdata_a_o,

  //Read port R2
  input  logic [4:0]             raddr_b_i,
  output logic [DATA_WIDTH-1:0]  rdata_b_o,


  // Write port W1
  input  logic [4:0]              waddr_a_i,
  input  logic [DATA_WIDTH-1:0]   wdata_a_i,
  input  logic                    we_a_i,
  ////////////////////
  //output [3:0] test,
  ///////////////////
        
  //////////////////////////////////////////////////////
  output [31:0] operand_1,
  output [31:0] operand_2,
//  output [31:0] data_RF_X5_ADD_to_seven_segment_display,
//  output [31:0] data_RF_X5_MUL_to_seven_segment_display,
//  output [31:0] data_RF_X5_DIV_to_seven_segment_display,
//  output [31:0] data_RF_X5_OR_to_seven_segment_display,
  output        led_toggle_based_on_mul_execution_time,
  output [31:0] Multiplicationexecution_time_test
  //////////////////////////////////////////////////////
);

  localparam    ADDR_WIDTH = 5;
  localparam    NUM_WORDS  = 2**ADDR_WIDTH;

//    assign    ADDR_WIDTH = RV32E ? 4 : 5;

//  logic [DATA_WIDTH-1:0] rf_reg [NUM_WORDS-1:0];
//  logic [DATA_WIDTH-1:0] rf_reg_tmp [NUM_WORDS-1:0];
//  logic [NUM_WORDS-1:0]                 we_a_dec;

    logic [DATA_WIDTH-1:0] rf_reg [NUM_WORDS-1:0];
    logic [DATA_WIDTH-1:0] rf_reg_tmp [NUM_WORDS-1:0];
    logic [NUM_WORDS-1:0]                 we_a_dec;
   
  always_comb
  begin : we_a_decoder
    for (int i = 0; i < NUM_WORDS; i++) begin
      if (waddr_a_i == i)
        we_a_dec[i] = we_a_i;
      else
        we_a_dec[i] = 1'b0;
    end
  end


  genvar i;
  generate

    // loop from 1 to NUM_WORDS-1 as R0 is nil
    for (i = 1; i < NUM_WORDS; i++)
    begin : rf_gen

      always_ff @(posedge clk, negedge rst_n)
      begin : register_write_behavioral
        if (rst_n==1'b0) begin
          rf_reg_tmp[i] <= 'b0;
        end 
        else if (we_a_dec[i]) begin
            rf_reg_tmp[i] <= wdata_a_i;
        end
        else begin
            rf_reg_tmp[i] <= rf_reg_tmp[i];
        end
      end

//     always_ff @(posedge clk, negedge rst_n)
//      begin : register_write_behavioral
//        if ((rst_n==1'b0)) begin
//          rf_reg_tmp[i] <= 'b0;
//        end 
//        else if (we_a_dec[i]) begin
//            rf_reg_tmp[i] <= wdata_a_i;
//        end
//        else begin
//            rf_reg_tmp[i] <= rf_reg_tmp[i];
//        end
//      end

    end

    // R0 is nil
    assign rf_reg[0] = '0;
    assign rf_reg[NUM_WORDS-1:1] = rf_reg_tmp[NUM_WORDS-1:1];

  endgenerate

  assign rdata_a_o = rf_reg[raddr_a_i];
  assign rdata_b_o = rf_reg[raddr_b_i];
  
  /////////////////////////////////////
 // assign test = rf_reg[3][3:0];
  ////////////////////////////////////

///////////////////////////////////////////////////////////////
  assign operand_1 = rf_reg[10];
  assign operand_2 = rf_reg[11];
//  assign data_RF_X5_ADD_to_seven_segment_display = rf_reg[4];
//  assign data_RF_X5_MUL_to_seven_segment_display = rf_reg[5];
//  assign data_RF_X5_DIV_to_seven_segment_display = rf_reg[6];
//  assign data_RF_X5_OR_to_seven_segment_display  = rf_reg[7];
  assign led_toggle_based_on_mul_execution_time  = rf_reg[8][0:0];
  assign Multiplicationexecution_time_test       = rf_reg[9];
  //////////////////////////////////////////////////////////////

endmodule
