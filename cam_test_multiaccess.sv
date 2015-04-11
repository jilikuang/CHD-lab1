/*==============================================
# Module Name        : cam_test_multiaccess
# Author             : Jie-Gang Kuang
# E-mail             : jk3735@columbia.edu
# Created Date       : 09/20/2014
# Last Modified Date : 09/21/2014
==============================================*/

module cam_test_multiaccess();

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

	// Simultanenous access
	// Access different addresses
	widx = 5'd7;
	wdata = 32'hbeefbeef;
	#1
	write = 1'b1;
	#2
	ridx = 5'd27;
	sdata = 32'hdeadbeef;
	read = 1'b1;
	search = 1'b1;
	widx = 5'd27;
	wdata = 32'hbcd9bcd9;
	#2
	$display("Simultaneous access test");
	$display("Read (%d) from %d: 0x%X (valid: %d)", read, ridx, out_rdata, out_rvalid);
	$display("Search (%d) for 0x%X: %d (valid: %d)", search, sdata, out_sidx, out_svalid);
	$display("Write (%d) to %d: 0x%X", write, widx, wdata);
	#2
	widx = 5'd11;
	wdata = 32'hdeadbeef;

	// Access the same address
	#2
	ridx = 5'd7;
	sdata = 32'hbeefbeef;
	widx = 5'd7;
	wdata = 32'h1234abcd;
	#2
	$display("Read (%d) from %d: 0x%X (valid: %d)", read, ridx, out_rdata, out_rvalid);
	$display("Search (%d) for 0x%X: %d (valid: %d)", search, sdata, out_sidx, out_svalid);
	$display("Write (%d) to %d: 0x%X", write, widx, wdata);
	#2

	read = 1'b0;
	write = 1'b0;
	search = 1'b0;

	// Test done
	$finish;
end

endmodule
