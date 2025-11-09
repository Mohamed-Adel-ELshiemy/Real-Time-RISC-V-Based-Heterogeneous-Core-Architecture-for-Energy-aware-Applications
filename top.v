`timescale 1ns/1ps

module top #(  parameter N_EXT_PERF_COUNTERS = 'b10,
               parameter RV32E               = 'b0,
               parameter RV32M               = 'b1
  ) 
  (
//   input           clk_i_n, clk_i_p,

   input          clk_i,
   input 		  rst_ni,
   
   /////*****  Core Selection (Micro or Zero)   *****/////
//    input         RV32E,
//    input         RV32M,
    ///////////////////////////////////////////////////////
    
//            input           instr_gnt_i,instr_rvalid_i,
//            input           data_gnt_i,data_rvalid_i,
//			output  [3:0] 	test_data_wdata_o// data_addr_o,
//			output          instr_req_o,
//			output          data_req_o,
//			output  [3:0]   data_be_o,
//			output			data_we_o
    ////////////////////
//        output [3:0] test,
    //////////////////////
        
        /////////// seven segment display ports/////////////
        output [7:0] SEG,
        output [7:0] strobe,
        /* operation selector */
//        input [1:0] sel,
        ///////////////////////////////////////////////
        
        /////////////////led_toggle_based_on_mul_execution_time////////////////
        output      led_toggle_based_on_mul_execution_time
        ///////////////////////////////////////////////////////////////////////
			);


//  instantiate 7-segment display;
//    reg  [31:0] data_temp;
    wire [31:0] operand_1;
    wire [31:0] operand_2;  
//    wire [31:0] data_RF_X5_ADD_to_seven_segment_display;
//    wire [31:0] data_RF_X5_MUL_to_seven_segment_display;
//    wire [31:0] data_RF_X5_DIV_to_seven_segment_display;
//    wire [31:0] data_RF_X5_OR_to_seven_segment_display;
    wire [31:0] Multiplicationexecution_time_test;
    wire [6:0] segments;
//    display_8hex display_UUT(.clk(clk_i),.data(data_temp), .seg(segments), .strobe(strobe)); 
    display_8hex display_UUT(.clk(clk_i),.data({Multiplicationexecution_time_test[15:0], operand_2[7:0], operand_1[7:0]}), .seg(segments), .strobe(strobe));
    assign SEG[6:0] = segments;
    assign SEG[7] = 1'b1;
    
//    always @ (*)
//    begin
//        if(sel == 2'b0)
//        begin
//            data_temp = ({data_RF_X5_ADD_to_seven_segment_display[15:0], operand_2[7:0], operand_1[7:0]});
//        end
//        else if(sel == 2'b01)
//        begin 
//            data_temp = ({data_RF_X5_MUL_to_seven_segment_display[15:0], operand_2[7:0], operand_1[7:0]});
//        end 
//        else if(sel == 2'b10)
//        begin 
//            data_temp = ({data_RF_X5_DIV_to_seven_segment_display[15:0], operand_2[7:0], operand_1[7:0]});
//        end 
//        else if(sel == 2'b11)
//        begin 
//            data_temp = ({data_RF_X5_OR_to_seven_segment_display[15:0], operand_2[7:0], operand_1[7:0]});
//        end 
//    end

//  parameter N_EXT_PERF_COUNTERS = 0;
//  parameter RV32E               = 'b0;
//  parameter RV32M               = 'b0;


  // Clock and Reset
//  logic        clk_i;
//  logic        rst_ni;
   
//   wire          clk_i;
   wire [31:0]   data_wdata_o;
   wire           instr_gnt_i,instr_rvalid_i;
   wire           data_gnt_i,data_rvalid_i;
   wire [31:0] 	  data_addr_o;
   wire           instr_req_o;
   wire           data_req_o;
   wire  [3:0]    data_be_o;
   wire			  data_we_o;
  
  wire        clock_en_i = 1'b1;    // enable clock, otherwise it is gated
  wire        test_en_i = 1'b0;     // enable all clock gates for testing

  // Core ID, Cluster ID and boot address are considered more or less static
  wire [ 3:0] core_id_i = 4'b0;
  wire [ 5:0] cluster_id_i = 6'b0;
  wire [31:0] boot_addr_i = 32'b0;

  // Instruction memory interface
//  wire        instr_req_o;
//  wire        instr_gnt_i;// = 1'b1;
//  wire        instr_rvalid_i;// = 1'b1;
  wire [31:0] instr_addr_o;
  wire [31:0] instr_rdata_i;

  // Data memory interface
//  wire        data_req_o;
//  wire        data_gnt_i;// = 1'b1;
//  wire        data_rvalid_i;// = 1'b1;
//  logic        data_we_o;
//  wire [3:0]  data_be_o;
//  wire [31:0] data_addr_o;
//  wire [31:0] data_wdata_o;
  wire [31:0] data_rdata_i;
  wire        data_err_i = 1'b0;

  // Interrupt inputs
  wire        irq_i = 1'b0;                 // level sensitive IR lines
  wire [4:0]  irq_id_i = 5'b0;
  wire        irq_ack_o;             // irq ack
  wire [4:0]  irq_id_o;

  // Debug Interface
  wire        debug_req_i = 1'b0;
  wire        debug_gnt_o;
  wire        debug_rvalid_o;
  wire [14:0] debug_addr_i = 15'b0;
  wire        debug_we_i = 1'b0;
  wire [31:0] debug_wdata_i = 32'b0;
  wire [31:0] debug_rdata_o;
  wire        debug_halted_o;
  wire        debug_halt_i = 1'b0;
  wire        debug_resume_i = 1'b0;

  // CPU Control Signals
   wire        fetch_enable_i = 1'b1;
   wire        core_busy_o;

   wire [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i = 'b01;
   			
////////////////////////////////////////////////////////////////////////
// clk_wiz_0 instance_name
//   (
//    // Clock out ports
//    .clk_out1(clk_i),     // output clk_out1
//   // Clock in ports
//    .clk_in1_p(clk_i_p),    // input clk_in1_p
//    .clk_in1_n(clk_i_n));    // input clk_in1_n
/////////////////////////////////////////////////////////////////////////   			


// instantiate processor and memories
zeroriscy_core#(
				.N_EXT_PERF_COUNTERS (N_EXT_PERF_COUNTERS),
				.RV32E               (RV32E),
				.RV32M               (RV32M)
)
uut(
  // Clock and Reset
  .clk_i     (clk_i),
  .rst_ni    (rst_ni),
  
   /////*****  Core Selection (Micro or Zero)   *****/////
//   .RV32E    (RV32E),
//   .RV32M    (RV32M),
   ///////////////////////////////////////////////////////

  .clock_en_i (clock_en_i),    // enable clock, otherwise it is gated
  .test_en_i  (test_en_i),     // enable all clock gates for testing

  // Core ID, Cluster ID and boot address are considered more or less static
  .core_id_i     (core_id_i),
  .cluster_id_i  (cluster_id_i),
  .boot_addr_i   (boot_addr_i),

  // Instruction memory interface
 .instr_req_o    (instr_req_o),
 .instr_gnt_i    (instr_gnt_i),
 .instr_rvalid_i (instr_rvalid_i),
 .instr_addr_o   (instr_addr_o),
 .instr_rdata_i  (instr_rdata_i),

  // Data memory interface
  .data_req_o    (data_req_o),
  .data_gnt_i    (data_gnt_i),
  .data_rvalid_i (data_rvalid_i),
  .data_we_o     (data_we_o),
  .data_be_o     (data_be_o),
  .data_addr_o   (data_addr_o),
  .data_wdata_o  (data_wdata_o),
  .data_rdata_i  (data_rdata_i),
  .data_err_i    (data_err_i),

  // Interrupt inputs
  .irq_i         (irq_i),                 // level sensitive IR lines
  .irq_id_i      (irq_id_i),
  .irq_ack_o     (irq_ack_o),             // irq ack
  .irq_id_o      (irq_id_o),

  // Debug Interface
  .debug_req_i    (debug_req_i),
  .debug_gnt_o    (debug_gnt_o),
  .debug_rvalid_o (debug_rvalid_o),
  .debug_addr_i   (debug_addr_i),
  .debug_we_i     (debug_we_i),
  .debug_wdata_i  (debug_wdata_i),
  .debug_rdata_o  (debug_rdata_o),
  .debug_halted_o (debug_halted_o),
  .debug_halt_i   (debug_halt_i),
  .debug_resume_i (debug_resume_i),

  // CPU Control Signals
  .fetch_enable_i  (fetch_enable_i),
  .core_busy_o     (core_busy_o),

  .ext_perf_counters_i (ext_perf_counters_i),
  ////////////////////////////////////////////
//  .test(test),
  ////////////////////////////////////////////
  
  //////////////////////////////////////////////////////////////////////////////
  .operand_1    (operand_1),
  .operand_2    (operand_2),
//  .data_RF_X5_ADD_to_seven_segment_display(data_RF_X5_ADD_to_seven_segment_display),
//  .data_RF_X5_MUL_to_seven_segment_display(data_RF_X5_MUL_to_seven_segment_display),
//  .data_RF_X5_DIV_to_seven_segment_display(data_RF_X5_DIV_to_seven_segment_display),
//  .data_RF_X5_OR_to_seven_segment_display(data_RF_X5_OR_to_seven_segment_display),
  .led_toggle_based_on_mul_execution_time    (led_toggle_based_on_mul_execution_time),
  .Multiplicationexecution_time_test         (Multiplicationexecution_time_test)
  //////////////////////////////////////////////////////////////////////////////
);


//  //instantiation of data_memory
//  data_mem data_memory(
//                        .clk(clk_i),
//                        .rst(rst_ni),
//                        .data_req_i(data_req_o),
//                        .data_gnt_o(data_gnt_i),
//                        .data_rvalid_o(data_rvalid_i), 
//                        .we(data_we_o),
//				        .a(data_addr_o),
//				        .data_be_i(data_be_o), 
//				        .wd(data_wdata_o),
//				        .rd(data_rdata_i)
//				       );
				       

/////////////////////////////////////////////////////////////////////////////////////////////////////

xilinx_bram #(
    .NB_COL(4),                           // Specify number of columns (number of bytes)
    .COL_WIDTH(8),                        // Specify column width (byte width, typically 8 or 9)
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY"),      // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) xilinx_bram_uut(
    .addra(data_addr_o[9:0]),             // Address bus, width determined from RAM_DEPTH
    .dina(data_wdata_o),                  // RAM input data
    .data_req_i(data_req_o),
    .data_gnt_o(data_gnt_i),
    .data_rvalid_o(data_rvalid_i),
    .clka(clk_i),                         // Clock
    .wea(data_be_o),                      // Byte-write enable
    .ena(data_we_o),                      // RAM Enable, for additional power savings, disable port when not in use
    .douta(data_rdata_i)                  // RAM output data
  );

/////////////////////////////////////////////////////////////////////////////////////////////////////




  //instantiation of instruction_memory				       
  instruction_mem instruction_memory( 
                                     .clk(clk_i),
                                     .rst(rst_ni),
                                     .instr_req_i(instr_req_o),
                                     .instr_gnt_o(instr_gnt_i),
                                     .instr_rvalid_o(instr_rvalid_i),
//                                     .a(instr_addr_o[12:2]),
				                     .a(instr_addr_o[7:2]),
				                     .rd(instr_rdata_i)
					                 );	

  ///////////////////////////////////////////////////////////////////////////////////////
  
//  Instr_Mem Instr_Mem_uut(
//                           .clk (clk_i), 
//                           .WE(),
//                           .rst_n(rst_ni),
//                            .instr_adress(instr_addr_o), 
//                            .datain(),
//                            .instr_req_i(instr_req_o),
//                            .instr_gnt_o(instr_gnt_i), 
//                            .instr_rvalid_o(instr_rvalid_i),
//                            .instr_read(instr_rdata_i)
//);
  
  ///////////////////////////////////////////////////////////////////////////////////////
  
  
  
//  assign test_data_wdata_o = data_wdata_o[3:0];
  	
//  	always@(*)
//  	begin
//  	test_data_wdata_o = data_wdata_o[3:0];
//  	end
  								 
endmodule