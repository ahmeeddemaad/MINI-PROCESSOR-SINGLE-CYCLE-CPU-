`timescale 1ns/1ps
module MINI_PROCESSOR_tb;

reg clk,reset,serial_in;
wire [5:0] pc_out;
wire [15:0] instr;
wire zero,reg_write;

mini_processor uut (
.clk(clk) , .reset(reset), 
.serial_in(serial_in), .pc_out(pc_out),
.instr(instr), .zero(zero) ,
.reg_write(reg_write)
);
always #100 clk = ~clk;

initial 
	begin
	clk=0;
	reset=1;
	serial_in=0;
	@(negedge clk) reset=0;
	
	#250 reset=1;
	#60 reset=0;
	
	#2000;
	$display("HALT CHECK: PC = %d", pc_out);
	#100;
	$display("HALT CHECK: PC = %d", pc_out);
	
    $finish;
	
	end
	
initial
	begin
		$monitor("Time=%0t | Reset=%b | PC=%d | Instr=%b | Zero=%b | RegWrite=%b | R0=%d R1=%d R2=%d R3=%d",
             $time, reset, pc_out, instr, zero, reg_write,
             uut.rg_inst.registers[0],
             uut.rg_inst.registers[1],
             uut.rg_inst.registers[2],
             uut.rg_inst.registers[3]);
	end
	
endmodule
