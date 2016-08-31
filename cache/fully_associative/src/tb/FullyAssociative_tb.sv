/**
 *
 * Fully Associative Cache Test bench
 *
 *    C = ABS
 *       C = 32
 *       A = C/B = 32/4 = 8
 *       B = 4 bytes
 *       S = 1
 *
 *       offset = lg(B) = 2 bits
 *       index  = lg(S) = 0 bits
 *       tag    = 32 - offset - index = 30 bits
 *
 * 
 *       valid  dirty   tag             cache line
 *      +------+-------+---------------+------------------------------------+  
 *    0 |      |       |               |                                    |  
 *      +------+-------+---------------+------------------------------------+  
 *
 *
 * Author: Chao (Jack) Li
 *
 *
 **/
 
`timescale 1ns / 1ps 

module FullyAssociative_tb();

   parameter WIDTH = 32;
   parameter C = 16;
   parameter B = 4;
   parameter A = C/B;
   
   reg clk, rst, wen_i, ren_i, hit_o;
   reg [WIDTH-1:0] address_i, data_i, data_o;
   

   FullyAssociative #(.WIDTH(WIDTH)
                     ,.C(C)
                     ,.B(B)
                     ,.A(A)
                     //S = 1
                     )
                     dut (.clk(clk)
                         ,.rst(rst)
                         ,.address_i(address_i)
                         ,.data_i(data_i)
                         ,.wen_i(wen_i)
                         ,.ren_i(ren_i)

                         ,.hit_o(hit_o)
                         ,.data_o(data_o)
                         );
   
   initial begin
      clk = 1'b0;
   end
   
   always begin
      #10 clk = ~clk;
   end
   
   initial begin
      rst = 1'b1;
      ren_i = 1'b0;
      wen_i = 1'b0;

      @(negedge clk);
      rst = 1'b0;

      @(negedge clk);
      wen_i = 1'b1;
      address_i = 32'h0400_0000;       // write
      data_i    = 32'd11;

      @(negedge clk);
      address_i = 32'h0400_0004;       // write
      data_i    = 32'd22;

      @(negedge clk);
      address_i = 32'h0400_0008;       // write
      data_i    = 32'd33;

      @(negedge clk);
      address_i = 32'h0400_000c;       // write
      data_i    = 32'd44;

      @(negedge clk);
      address_i = 32'h0400_0010;       // replacement write of 11
      data_i    = 32'd55;

      @(negedge clk);

      @(negedge clk);
      wen_i = 1'b0;
      ren_i = 1'b1;
      address_i = 32'h0400_0000;       // miss
      
      @(negedge clk);
      address_i = 32'h0400_0004;       // hit

      @(negedge clk);
      address_i = 32'h0400_0008;       // hit

      @(negedge clk);
      address_i = 32'h0400_000c;       // hit

      @(negedge clk);
      address_i = 32'h0400_0010;       // hit


      //-----------------------------------------------------------------------
      @(negedge clk);
      rst = 1'b1;

      @(negedge clk);
      rst   = 1'b0;
      wen_i = 1'b1;
      ren_i = 1'b0;
      address_i = 32'h0400_0000;       // write
      data_i    = 32'd111;

      @(negedge clk);
      address_i = 32'h0400_0004;       // write
      data_i    = 32'd222;

      @(negedge clk);
      address_i = 32'h0400_0008;       // write
      data_i    = 32'd333;

      @(negedge clk);
      address_i = 32'h0400_000c;       // write
      data_i    = 32'd444;


      @(negedge clk);
      wen_i = 1'b0;
      ren_i = 1'b1;
      address_i = 32'h0400_0000;       // hit
      
      @(negedge clk);
      address_i = 32'h0400_0008;       // hit

      @(negedge clk);
      wen_i = 1'b1;
      ren_i = 1'b0;
      address_i = 32'h0400_0010;       // replacement write of 222
      data_i    = 32'd555;

      @(negedge clk);
      address_i = 32'h0400_0014;       // replacement write of 444
      data_i    = 32'd666;

      @(negedge clk);
      wen_i = 1'b0;
      ren_i = 1'b1;
      address_i = 32'h0400_0000;       // hit
      
      @(negedge clk);
      address_i = 32'h0400_0004;       // miss

      @(negedge clk);
      address_i = 32'h0400_0008;       // hit

      @(negedge clk);
      address_i = 32'h0400_000c;       // miss

      @(negedge clk);
      address_i = 32'h0400_0010;       // hit

       @(negedge clk);
      address_i = 32'h0400_0014;       // hit


      @(negedge clk);
      $stop;
   end
   
endmodule 