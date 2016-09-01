/******************************************************************************
 *
 * Direct Mapped Cache Test bench
 *
 * Author: Chao (Jack) Li
 *
 *
 *****************************************************************************/

`timescale 1ps / 1ns

module DirectMapped_tb();

   parameter WIDTH = 32;
   parameter C = 16;
   parameter B = 4;
   parameter S = C/B;

   reg clk, rst, wen_i, hit_o;
   reg [WIDTH-1:0] address_i, data_i, data_o;

   DirectMapped #(.WIDTH(WIDTH)
                 ,.C(C)
                 //A = 1
                 ,.B(B)
                 ,.S(S)
                 )
                 dut (.clk(clk)
                     ,.rst(rst)
                     ,.wen_i(wen_i)
                     ,.address_i(address_i)
                     ,.data_i(data_i)
                  
                     ,.hit_o(hit_o)
                     ,.data_o(data_o)
                     );


   initial begin
      clk = 1'b0;
   end

   always begin
      #25 clk = ~clk;
   end


   initial begin
      rst       = 1;
      wen_i     = 0;
      address_i = 0;
      data_i    = 0;

      @(negedge clk);
      rst = 0;
      wen_i = 1;
      address_i  = 32'h0400_0000;      // write
      data_i = 11;

      @(negedge clk);
      address_i  = 32'h0400_0004;      // write
      data_i = 22;

      @(negedge clk);
      address_i  = 32'h0400_0008;      // write
      data_i = 33;

      @(negedge clk);
      address_i  = 32'h0400_000c;      // write
      data_i = 44;

      @(negedge clk);
      wen_i = 0;
      address_i  = 32'h0400_0000;      // hit
      
      @(negedge clk);
      address_i  = 32'hFFFF_0000;      // miss

      @(negedge clk);
      address_i  = 32'h0400_0004;      // hit
      
      @(negedge clk);
      address_i  = 32'hFFFF_0000;      // miss

      @(negedge clk);
      address_i  = 32'h0400_0008;      // hit
      
      @(negedge clk);
      address_i  = 32'hFFFF_0000;      // miss

      @(negedge clk);
      address_i  = 32'h0400_000c;      // hit
      
      @(negedge clk);

      //-----------------------------------------------------------------------
      @(negedge clk);
      wen_i = 1;
      address_i  = 32'h0400_0010;      // write
      data_i = 55;

      @(negedge clk);
      address_i  = 32'h0400_0018;      // write
      data_i = 66;


      @(negedge clk);
      wen_i = 0;
      address_i  = 32'h0400_0000;      // miss
      
      @(negedge clk);
      address_i  = 32'h0400_0010;      // hit

      @(negedge clk);
      address_i  = 32'h0400_0008;      // miss
      
      @(negedge clk);
      address_i  = 32'h0400_0018;      // hit

      //-----------------------------------------------------------------------
      @(negedge clk);
      rst = 1;

      @(negedge clk);
      $stop;
   end


endmodule 