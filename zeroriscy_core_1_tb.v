`timescale 1ns/1ns

module zeroriscy_core_tb();

  parameter N_EXT_PERF_COUNTERS = 0,
            RV32E               = 0,
            RV32M               = 1,
            bus_width           = 32;

reg clk_i, rst_ni,/* clock_en_i, test_en_i,*/ data_gnt_i, data_rvalid_i;
//reg [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i;
//reg [3:0] core_id_i; 
//reg [5:0] cluster_id_i; 
//reg [31:0] boot_addr_i; 
reg instr_gnt_i, instr_rvalid_i, data_err_i/*, irq_i, debug_req_i, debug_we_i, debug_halt_i, debug_resume_i, fetch_enable_i*/;
reg [31:0] instr_rdata_i, data_rdata_i;
/*, debug_wdata_i;
reg [4:0] irq_id_i;
reg [14:0] debug_addr_i;*/  
wire data_req_o, data_we_o, instr_req_o,/* debug_gnt_o, debug_rvalid_o, debug_halted_o,*/ core_busy_o;
wire [31:0] instr_addr_o, data_addr_o, data_wdata_o/*, irq_ack_o, debug_rdata_o*/;
wire [3:0] data_be_o;
//wire [4:0] irq_id_o;

reg [63:0] mem [0:(9*16)-1];  //mem depth is 150 row

//reg [31:0] instr_rdata_i_expected;

reg [7:0] i = 8'd0;

initial 
begin 
	$dumpfile("zeroriscy_core.vcd");
    $dumpvars(0, zeroriscy_core_tb);
//	$readmemh("D:/Mohamed Adel Elsheimy/zero-riscy-system-verilog-pulpinov1/param0",mem);
    $readmemh("D:/Mohamed Adel Elsheimy/zero-riscy-system-verilog-pulpinov1/Fibonacci_Machine_Code",mem);
	clk_i          = 1'b1;
	rst_ni         = 1'b1;
	instr_gnt_i    = 1'b1;
	instr_rvalid_i = 1'b1;
	instr_rdata_i  = 32'd0;
	data_gnt_i     = 1'b1;
	data_rvalid_i  = 1'b1;
	data_rdata_i   = 32'd0;
	data_err_i     = 1'b0;
	#60
	rst_ni         = 1'b0;
	#60
    rst_ni         = 1'b1;
	instr_rvalid_i = 1'b0;
	#60
	instr_gnt_i    = 1'b0;
	instr_rvalid_i = 1'b1;
	#60
	$stop;
end

always @(posedge clk_i)
begin

	{instr_rdata_i} = mem[i][31:0];
	i <= i+1'b1;
end
/*
always @(negedge clk_i)
begin
	if(instr_rdata_i_expected != instr_rdata_i)
	$display("wrong ISA %h",)
end
*/
always #15 clk_i = ~clk_i ;

zeroriscy_core #(
					.N_EXT_PERF_COUNTERS(N_EXT_PERF_COUNTERS),
					.RV32E              (RV32E),
					.RV32M              (RV32M),
					.bus_width          (bus_width)
)
UUT(
  // Clock and Reset
				.clk_i(clk_i),
				.rst_ni(rst_ni),
  
  // Instruction memory interface
				.instr_req_o(instr_req_o),
				.instr_gnt_i(instr_gnt_i),
				.instr_rvalid_i(instr_rvalid_i),
				.instr_addr_o(instr_addr_o),
				.instr_rdata_i(instr_rdata_i),

  // Data memory interface
				.data_req_o(data_req_o),
				.data_gnt_i(data_gnt_i),
				.data_rvalid_i(data_rvalid_i),
				.data_we_o(data_we_o),
				.data_be_o(data_be_o),
				.data_addr_o(data_addr_o),
				.data_wdata_o(data_wdata_o),
				.data_rdata_i(data_rdata_i),
				.data_err_i(data_err_i),
				
				.core_busy_o(core_busy_o)
				
);

/*
 zeroriscy_core #(N_EXT_PERF_COUNTERS = 0 ,bus_width = 32)
	UUT (              
					.clk_i(clk_i),
					.rst_ni(rst_ni),

					.clock_en_i(clock_en_i),    // enable clock, otherwise it is gated
					.test_en_i(test_en_i),     // enable all clock gates for testing

  // Core ID, Cluster ID and boot address are considered more or less static
					.core_id_i(core_id_i),
					.cluster_id_i(cluster_id_i),
					.boot_addr_i(boot_addr_i),

  // Instruction memory interface
					.instr_req_o(instr_req_o),
					.instr_gnt_i(instr_gnt_i),
					.instr_rvalid_i(instr_rvalid_i),
					.instr_addr_o(instr_addr_o),
					.instr_rdata_i(instr_rdata_i),

  // Data memory interface
					.data_req_o(data_req_o),
					.data_gnt_i(data_gnt_i),
					.data_rvalid_i(data_rvalid_i),
					.data_we_o(data_we_o),
					.data_be_o(data_be_o),
					.data_addr_o(data_addr_o),
					.data_wdata_o(data_wdata_o),
					.data_rdata_i(data_rdata_i),
					.data_err_i(data_err_i),

  // Interrupt inputs
					.irq_i(irq_i),                 // level sensitive IR lines
					.irq_id_i(irq_id_i),
					.irq_ack_o(irq_ack_o),             // irq ack
					.irq_id_o(irq_id_o),

  // Debug Interface
					.debug_req_i(debug_req_i),
					.debug_gnt_o(debug_gnt_o),
					.debug_rvalid_o(debug_rvalid_o),
					.debug_addr_i(debug_addr_i),
					.debug_we_i(debug_we_i),
					.debug_wdata_i(debug_wdata_i),
					.debug_rdata_o(debug_rdata_o),
					.debug_halted_o(debug_halted_o),
					.debug_halt_i(debug_halt_i),
					.debug_resume_i(debug_resume_i),

  // CPU Control Signals
					.fetch_enable_i(fetch_enable_i),
					.core_busy_o(core_busy_o),

					.ext_perf_counters_i(ext_perf_counters_i)
  );
*/  
endmodule  