module param0();
reg [63:0] mem [0:(9*16)-1];
initial
begin
$readmemh("D:/Mohamed Adel Elsheimy/zero-riscy-system-verilog-pulpinov1/param0",mem);
end

endmodule