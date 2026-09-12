module Instruction_Memory(addr,instr);

input [5:0] addr;
output reg [15:0] instr;

reg [15:0]mem[63:0];

always @(*)
	instr = mem[addr] ;
	
	
initial
begin 
$readmemb("program_bne.txt", mem);  
end
	
endmodule