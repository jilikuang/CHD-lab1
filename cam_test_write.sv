/*==============================================
# Module Name        : cam_test_write
# Author             : Jie-Gang Kuang
# E-mail             : jk3735@columbia.edu
# Created Date       : 09/18/2014
# Last Modified Date : 09/20/2014
==============================================*/

module cam_test_write();

reg clk = 1'b1;
reg rst = 1'b1;

reg        read   = '0;
reg [4:0]  ridx   = '0;
reg        write  = '0;
reg [4:0]  widx   = '0;
reg [31:0] wdata  = '0;
reg        search = '0;
reg [31:0] sdata  = '0;

wire        out_rvalid;
wire [31:0] out_rdata;
wire        out_svalid;
wire [4:0]  out_sidx;

// Instantiate the CAM
cam lab1cam (
	.clk(clk), .rst_n(rst),
	.read_i(read), .read_index_i(ridx),
	.write_i(write), .write_index_i(widx), .write_data_i(wdata),
	.search_i(search), .search_data_i(sdata),
	.read_valid_o(out_rvalid), .read_value_o(out_rdata),
	.search_valid_o(out_svalid), .search_index_o(out_sidx)
);

// Generate clock
always begin
	#1 clk = ~clk;
end

initial begin
	$vcdpluson;

	// Reset
	#1 rst = ~rst;
	#1 rst = ~rst;

	// Writing function test
	// Write to an unwritten address
	widx = 5'd13;
	wdata = 32'hbeefbeef;
	#1
	write = 1'b1;
	#1
	$display("Writing function test");
	$display("Write (%d) to %d: 0x%X", write, widx, wdata);
	#1
	// Write to another unwritten address
	widx = 5'd27;
	wdata = 32'hcafecafe;
	#1
	$display("Write (%d) to %d: 0x%X", write, widx, wdata);
	#1
	// Write to an written address
	widx = 5'd13;
	wdata = 32'hdeadbeef;
	#1
	$display("Write (%d) to %d: 0x%X", write, widx, wdata);
	#1
	write = 1'b0;
	// Reset test
	#1 rst = ~rst;
	#1 rst = ~rst;

	// Test done
	$finish;
end

endmodule
