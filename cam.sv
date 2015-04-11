/*==============================================
# Module Name        : cam
# Author             : Sen Lin
# E-mail             : sl3773@columbia.edu
# Created Date       : 09/13/2014
# Last Modified Date : 09/13/2014
==============================================*/

module cam 
#(
  parameter ADDR_WIDTH=5,
  parameter DATA_WIDTH=32,
  parameter DEPTH     =(1<<ADDR_WIDTH),
  parameter SIZE      =(DATA_WIDTH*DEPTH)
 )

(
 input                        clk,
 input                        rst_n,
 input                        read_i,
 input       [ADDR_WIDTH-1:0] read_index_i,
 input                        write_i,
 input       [ADDR_WIDTH-1:0] write_index_i,
 input       [DATA_WIDTH-1:0] write_data_i,
 input                        search_i,
 input       [DATA_WIDTH-1:0] search_data_i,
 output logic                 read_valid_o, 
 output logic[DATA_WIDTH-1:0] read_value_o,
 output logic                 search_valid_o,
 output logic[ADDR_WIDTH-1:0] search_index_o
);


//Read_decoder
 wire        [DEPTH-1:0]      rd_en_o;
 cam_decoder #(.DATA_WIDTH(DATA_WIDTH),
               .ADDR_WIDTH(ADDR_WIDTH))
 cam_read_decoder(
              .en_i(read_i),
              .addr_i(read_index_i),
              .en_o(rd_en_o)
             );

//Write_decoder
 wire        [DEPTH-1:0]      wr_en_o;
 cam_decoder #(.DATA_WIDTH(DATA_WIDTH),
               .ADDR_WIDTH(ADDR_WIDTH))
 cam_write_decoder(
              .en_i(write_i),
              .addr_i(write_index_i),
              .en_o(wr_en_o)
             );

 //Ram
 wire        [SIZE-1:0]       data_o;
 wire        [DEPTH-1:0]      match_o;
 wire        [DEPTH-1:0]      written_o;

 generate
   for(genvar iter=0;iter<DEPTH;iter++) begin
     rws_ff #(.DATA_WIDTH(DATA_WIDTH))
     my_rws_ff(
              .clk,
              .rst_n,
              .wr_en_i(wr_en_o[iter]),
              .rd_en_i(rd_en_o[iter]),
              .data_i(write_data_i),
              .data_compare_i(search_data_i),
              .compare_en_i(search_i),
              .data_o(data_o[(iter+1)*DATA_WIDTH-1:iter*DATA_WIDTH]),
              .match_o(match_o[iter]),
              .written_o(written_o[iter])
             );
   end
 endgenerate

 //mux
 cam_mux #(.DATA_WIDTH(DATA_WIDTH),
           .ADDR_WIDTH(ADDR_WIDTH))
 my_cam_mux(.rd_addr_i(read_index_i),
            .data_i(data_o),
            .written_i(written_o),
            .match_i(match_o),
	    .read_en_i(read_i),
            .read_valid_o(read_valid_o),
            .read_value_o(read_value_o),
            .search_valid_o(search_valid_o),
            .search_index_o(search_index_o)
           );
endmodule
