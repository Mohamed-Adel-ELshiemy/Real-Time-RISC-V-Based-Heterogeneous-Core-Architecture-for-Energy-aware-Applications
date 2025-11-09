module zeroriscy_core_tb();

  parameter N_EXT_PERF_COUNTERS = 0;
  parameter RV32E               = 0;
  parameter RV32M               = 1;


  // Clock and Reset
  logic        clk_i;
  logic        rst_ni;

  logic        clock_en_i;    // enable clock, otherwise it is gated
  logic        test_en_i;     // enable all clock gates for testing

  // Core ID, Cluster ID and boot address are considered more or less static
  logic [ 3:0] core_id_i;
  logic [ 5:0] cluster_id_i;
  logic [31:0] boot_addr_i;

  // Instruction memory interface
  logic        instr_req_o;
  logic        instr_gnt_i;
  logic        instr_rvalid_i;
  logic [31:0] instr_addr_o;
  logic [31:0] instr_rdata_i;

  // Data memory interface
  logic        data_req_o;
  logic        data_gnt_i;
  logic        data_rvalid_i;
  logic        data_we_o;
  logic [3:0]  data_be_o;
  logic [31:0] data_addr_o;
  logic [31:0] data_wdata_o;
  logic [31:0] data_rdata_i;
  logic        data_err_i;

  // Interrupt inputs
  logic        irq_i;                 // level sensitive IR lines
  logic [4:0]  irq_id_i;
  logic        irq_ack_o;             // irq ack
  logic [4:0]  irq_id_o;

  // Debug Interface
  logic        debug_req_i;
  logic        debug_gnt_o;
  logic        debug_rvalid_o;
  logic [14:0] debug_addr_i;
  logic        debug_we_i;
  logic [31:0] debug_wdata_i;
  logic [31:0] debug_rdata_o;
  logic        debug_halted_o;
  logic        debug_halt_i;
  logic        debug_resume_i;

  // CPU Control Signals
   logic        fetch_enable_i;
   logic        core_busy_o;

   logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i;
   
//   logic [31:0] mem [0:31];

initial 
begin
		$dumpfile("zeroriscy_core.vcd");
		$dumpvars("0,zeroriscy_core_tb");
//		$readmemh("D:/Mohamed Adel Elsheimy/zero-riscy-system-verilog-pulpinov1/Fibonacci_Machine_Code.txt",mem);
		clk_i 			= 1'b1;
		rst_ni			= 1'b0;
		clock_en_i      = 1'b1;
		test_en_i       = 1'b0;
		debug_req_i		= 1'b0;
		debug_addr_i	= 15'b0; //
		debug_we_i		= 1'b0;
		debug_wdata_i	= 32'b0; //
		debug_halt_i	= 1'b0;
		debug_resume_i	= 1'b0;
		
		instr_gnt_i    = 1'b1;
	    instr_rvalid_i = 1'b1;
	    instr_rdata_i  = 32'd0;
	    data_gnt_i     = 1'b1;
	    data_rvalid_i  = 1'b1;
        data_rdata_i   = 32'd0;
        data_err_i     = 1'b0;
		
		core_id_i      = 4'b0;
		cluster_id_i   = 6'b0;
		boot_addr_i    = 32'b0;
		
		irq_i          = 1'b0;
		irq_id_i       = 5'b0;
		
		fetch_enable_i = 1'b1;
		
		ext_perf_counters_i = 'b1;
		
		#60
		rst_ni			= 1'b1;
		#60
		clock_en_i      = 1'b1;
		debug_req_i		=  'b1;
		debug_we_i		= 1'b1;
		#60
		debug_halt_i	= 1'b1;
		#120
		debug_resume_i	= 1'b1;
		#120
		debug_halt_i	= 1'b0;
		#1200
		$stop;
		
end

//reg [4:0] i = 5'b0;

//always @(posedge clk_i)
//begin

//    instr_rdata_i = mem[i][31:0];
//	i <= i+1'b1;
//	debug_addr_i <= debug_addr_i + 15'b1;
//end

// check results
always @ (negedge clk_i)
begin
    if (data_we_o) begin
        if (data_addr_o == 84 & data_wdata_o == 7) begin
            $display ("Simulation succeeded");
            $stop;
        end else if (data_addr_o != 80) begin
            $display ("Simulation failed");
            $stop;
            end
    end
end

always #30 clk_i = ~clk_i;

zeroriscy_core#(
				.N_EXT_PERF_COUNTERS (N_EXT_PERF_COUNTERS),
				.RV32E               (RV32E),
				.RV32M               (RV32M)
)
uut(
  // Clock and Reset
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

endmodule