module Program_Counter (clk,reset,pc_src,target,pc_out);

input clk,reset;
input [1:0] pc_src;
input [5:0] target;
output reg [5:0] pc_out;

always@(posedge clk)
begin 
	if (reset)
		pc_out<=6'b0;
	else 
		case(pc_src)
			2'b00: pc_out<=pc_out+1;
			2'b01: pc_out<=target;
			2'b10: pc_out<=target;
			2'b11: pc_out<=pc_out;
		endcase
end	
endmodule
