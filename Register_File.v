module Register_File(
input clk,rst,wr_en,
input [1:0] wr_addr, //rd
input [7:0] wr_data,
input [1:0] rd_addr1, //rs1
input [1:0] rd_addr2, //rs2
output [7:0] rd_data1, // value of rs1
output [7:0] rd_data2  // value of rs2
); 
reg [7:0] registers [3:0]; 
integer i; 
assign rd_data1 = registers[rd_addr1];   
assign rd_data2 = registers[rd_addr2];  
always @ (posedge clk)
    begin
        if(rst)
            begin
            for(i=0;i<4;i=i+1)
            registers[i]<=8'b0;
            end
        
        else if (wr_en)
            registers[wr_addr] <= wr_data;   
                            
      end
endmodule
