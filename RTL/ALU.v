module ALU(a,b,opcode,serial_in,result,zero);

input [7:0] a,b;
input [3:0] opcode;
input serial_in;

output reg [7:0] result;
output reg zero;

always@(*)
begin
        begin
			case(opcode)
			4'b0000: result = a + b;
			4'b0001: result = a - b;
			4'b0010: 
			if (b!=0)
			result = a / b;
			else
			result = 8'b0;
			4'b0011: result = a * b;
			4'b0100: result = {a[6:0], serial_in};
			4'b0101: result = {a[6:0], a[7]};
			4'b0110: result = ~a;
			4'b0111: result = a + 1;
			4'b1001: result = ~b;
			4'b1010: result = a & b;
			4'b1011: result = ~(a & b);
			4'b1100: result = ~(a | b);
			4'b1101: result = a | b;
			4'b1110: result = a ^ b;
			4'b1111: result = ~(a ^ b);
			default: result = 8'b0;
			endcase
		end
		
		if (result==8'b0)
			zero=1;
		else
			zero=0;
    
end
endmodule
