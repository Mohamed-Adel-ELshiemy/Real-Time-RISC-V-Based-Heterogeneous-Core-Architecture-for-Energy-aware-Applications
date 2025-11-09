//`timescale 1ns/1ns

module instruction_mem (input clk, rst,
//                        input [10:0] 	  a,
                        input [5:0] 	  a,
                        input             instr_req_i,
                        output reg        instr_gnt_o, instr_rvalid_o,
						output reg [31:0] rd
						);
						
(* ram_style = "distributed" *)			 
reg [31:0] RAM [0:31];

initial
begin
//$readmemh ("D:/Mohamed Adel Elsheimy/project_3/last.txt",RAM);
$readmemh ("D:/Mohamed Adel Elsheimy/Bahgat_new/riscy/ri5cy_sim/new.txt",RAM);
end

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        rd = 32'b0;
        instr_gnt_o    = 1'b0;
        instr_rvalid_o = 1'b0;
    end  
    else if(instr_req_i)
    begin
          if (a < 6'd32)
          begin
              instr_rvalid_o = 1'b1;    
              rd = RAM[a];
              instr_gnt_o    = 1'b1;
          end
    end
    else 
    begin
        instr_gnt_o    = 1'b0;
        instr_rvalid_o = 1'b0;
        rd = 32'b0;
    end
end

//assign rd = RAM[a]; // word aligned

endmodule