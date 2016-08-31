`timescale 1ns / 1ps

`define H 32'h0000_0048
`define E 32'h0000_0045
`define L 32'h0000_004C
`define O 32'h0000_004F
`define W 32'h0000_0057
`define R 32'h0000_0052
`define D 32'h0000_0044
`define G 32'h0000_0067
`define B 32'h0000_0062
`define Y 32'h0000_0079

`define EXCLA 32'h0000_0021
`define SPACE 32'h0000_002C

fourway_cache_tb();


   reg [31:0]  address;
   reg [127:0] data_i;

   reg clk, rst, ren, wen, hit;

   reg [31:0] data_o

   fourway_cache cache(.address_i(address)
                      ,.data_i(data_i)
                      ,.ren_i(ren)
                      ,.wen_i(wen)
                      ,.clk(clk)
                      ,.rst(rst)

                      ,.hit_o(hit)
                      ,.data_o(data_o));


   initial begin
      clk = 1'b0;
   end

   always begin
      #10 clk = ~clk;
   end


   initial begin

      ren = 1'b0;
      wen = 1'b0;
      rst = 1'b1;
      address = 32'h0000_0000;
      data_i  = 128'd0000;
      @(negedge clk);


      ren = 1'b1;
      rst = 1'b0;
      @(negedge clk);      // assert hit := 0

      ren = 1'b0;
      wen = 1'b1;
      address 32'd0;
      data_i = {`H, `E , `L, `L};


      $stop;
   end







endmodule