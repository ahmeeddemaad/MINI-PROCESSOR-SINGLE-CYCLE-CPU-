module Control_Unit(
input [15:0]instr,
input zero,
output reg reg_write , wb_src,
output reg [3:0] alu_op,
output reg [1:0] pc_src
);
wire [1:0] decision;
assign decision = instr[15:14];
always @ (*)
	begin
	// default values
	pc_src=2'b11;
	wb_src=0;
	alu_op=4'b1000;
	reg_write=0;
	case (decision)
	2'b00:
			begin
			alu_op=instr[13:10]; 
			reg_write=1;
			pc_src=2'b0;
			wb_src=0;
			end
	
	
	2'b01:
			begin
			alu_op=4'b1000;
			reg_write=1;
			pc_src=2'b0;
			wb_src=1;
			end
	
	
	2'b10:
			begin
			alu_op=4'b0001;
			reg_write=0;
			wb_src=0;
			if (instr[13]==1'b0)
				pc_src=2'b01;
			else if (instr[13]==1'b1 && instr[8]==1'b0  && zero==1)
				pc_src=2'b10;
			else if (instr[13]==1'b1 && instr[8]==1'b0  && zero==0)
				pc_src=2'b00;
			else if (instr[13]==1'b1 && instr[8]==1'b1 && zero==0)
				pc_src=2'b10;
			else if (instr[13]==1'b1 && instr[8]==1'b1 && zero==1)
				pc_src=2'b00;
			end
	
	
	
	2'b11: 
			begin
			alu_op=4'b1000;
			reg_write=0;
			wb_src=0;
			if (instr[12]==1'b0)
				pc_src=2'b11;
			else if (instr[12]==1'b1)
				pc_src=2'b00;
			end
			
	endcase
	end

endmodule

