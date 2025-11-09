//`timescale 1ns/1ns

module data_mem (input 			clk, rst, we,
                 input          data_req_i,
                 input [31:0]    a,
				 input [31:0] 	/*a,*/ wd,
				 input [3:0]    data_be_i,
				 output  reg    data_gnt_o,data_rvalid_o,
				 output reg [31:0] 	rd
				 );

reg [31:0] rd_temp;			 
reg  [31:0] RAM [0:31] ;

//assign rd = RAM[a[31:2]];//[31:2]]; // word aligned

integer i;

always @(posedge clk , negedge rst)
begin
//    RAM [1] <= 'd6;
//    RAM [2] <= 'd8;
    data_rvalid_o <= 1'b0;
    data_gnt_o    <= 1'b0;
	if(rst==1'b0)
		begin
			data_gnt_o <= 1'b0;
			for(i=0;i<32;i=i+1)
			begin
				    RAM [i] <= 32'h0000_0000;
			end	
		end
	else if(data_req_i == 1'b1 && we == 1'b0)
	    begin
	    if(a < 32)
	    begin
	    data_rvalid_o <= 1'b1;
             if (data_be_i == 4'b1111)
             begin
                 rd_temp    <= RAM[a[31:2]];
                 rd         <= rd_temp; 
                 data_gnt_o <= 1'b1;
             end
             if (data_be_i == 4'b1110)
             begin
                 rd_temp    <= RAM[a[31:2]];
                 rd         <= rd_temp[31:8]; 
                 data_gnt_o <= 1'b1;
             end 
             if (data_be_i == 4'b1100)
             begin
                 rd_temp    <= RAM[a[31:2]];
                 rd         <= rd_temp[31:16]; 
                 data_gnt_o <= 1'b1;
             end
             if (data_be_i == 4'b1000)
             begin
                 rd_temp    <= RAM[a[31:2]];
                 rd         <= rd_temp[31:24]; 
                 data_gnt_o <= 1'b1;
             end
         end              
	     end
	     
	 else if(data_req_i == 1'b0 && we == 1'b1)
		       begin
		       if (data_be_i == 4'b1111)
                begin
                     RAM[a[31:2]] <= wd ;
                     data_gnt_o    <= 1'b1;
	             end
	             if (data_be_i == 4'b1110)
                begin
                     RAM[a[31:2]] <= wd[31:8] ;
                     data_gnt_o    <= 1'b1;
	             end
	             if (data_be_i == 4'b1100)
                begin
                     RAM[a[31:2]] <= wd[31:16] ;
                     data_gnt_o    <= 1'b1;
	             end
	             if (data_be_i == 4'b1000)
                begin
                     RAM[a[31:2]] <= wd[31:24] ;
                     data_gnt_o    <= 1'b1;
	             end
		       end
		end

endmodule