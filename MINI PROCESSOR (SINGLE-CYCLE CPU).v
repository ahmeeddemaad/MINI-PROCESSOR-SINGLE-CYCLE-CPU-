module mini_processor(
input clk,reset,serial_in,
output [5:0] pc_out,
output [15:0] instr,
output zero,
output reg_write
);

wire [15:0]instr_wire=instr[15:0];
wire       zero_wire;
wire [5:0] pc_out_wire;
wire [3:0] instr_op_wire;
wire [1:0] rd_addr1_wire= (instr[15:14]==2'b00)? instr[7:6] : instr[12:11] ;
wire [1:0] rd_addr2_wire= (instr[15:14]==2'b00)? instr[5:4] : instr[10:9];
wire [1:0] wr_addr_wire= (instr[15:14]==2'b00)? instr[9:8] : instr[13:12] ;
wire [1:0] pc_src_wire;
wire [5:0] instr_target_wire = instr[5:0];
wire [7:0] rd_data1_a ;
wire [7:0] rd_data2_b;
wire [7:0] immediate = instr[11:4];
wire [7:0] alu_result_wire;
wire       wb_src_wire;
wire [7:0] write_back_wire;

assign pc_out = pc_out_wire;
assign zero = zero_wire;
assign write_back_wire = (wb_src_wire == 0) ? alu_result_wire : immediate;

Program_Counter pc_inst(.clk(clk), .reset(reset) , .pc_out(pc_out_wire) , .target(instr_target_wire) , 
.pc_src(pc_src_wire) );


Instruction_Memory imem_inst( .addr(pc_out_wire) , .instr(instr) );


Register_File rg_inst(.clk(clk), .rst(reset) , .wr_data(write_back_wire) , .wr_addr(wr_addr_wire) ,
 .wr_en(reg_write) , .rd_addr1(rd_addr1_wire) , .rd_addr2(rd_addr2_wire), .rd_data1(rd_data1_a),
.rd_data2(rd_data2_b) );


ALU alu_inst(.a(rd_data1_a), .b(rd_data2_b), .opcode(instr_op_wire) , .serial_in(serial_in) , 
.zero(zero_wire) , .result(alu_result_wire) );



Control_Unit cu_inst( .instr(instr_wire), .zero(zero_wire) , .reg_write(reg_write) ,
 .pc_src(pc_src_wire) , .alu_op(instr_op_wire) , .wb_src(wb_src_wire)  );


endmodule		