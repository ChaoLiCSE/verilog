/******************************************************************************
 *
 * Least Recent Used Testbench
 *
 * Author: Chao (Jack) Li 
 *
 *****************************************************************************/
`timescale 1ns / 1ps 

module LRU_tb();

   parameter LENGTH = 8;
   
   reg clk, rst, access;

   reg [$clog2(LENGTH)-1:0] index_i, index_o;
   
   LRU #(.LENGTH(LENGTH)
        )
        dut (.clk(clk)
            ,.rst(rst)
            ,.access(access)
            ,.index_i(index_i)
            ,.index_o(index_o)
            );

           
   initial begin
      clk = 0;
   end
   
   always begin
      #10 clk = ~clk;
   end


   initial begin
      rst = 1;
      
      @(negedge clk);
      rst = 0;
      
      @(negedge clk);
      access  = 1;
      index_i = 7;
      
      @(negedge clk);
      index_i = 6;
      
      @(negedge clk);
      index_i = 5;
      
      @(negedge clk);
      index_i = 4;
      
      @(negedge clk);
      index_i = 3;
      
      @(negedge clk);
      rst = 1;
      
      @(negedge clk);
      rst = 0;

      @(negedge clk);
      index_i = 2;
      
      @(negedge clk);
      index_i = 1;
      
      @(negedge clk);
      index_i = 0;
      
      @(negedge clk);
      index_i = 7;

      @(negedge clk);
     
      $stop;
   
   end
   
endmodule 