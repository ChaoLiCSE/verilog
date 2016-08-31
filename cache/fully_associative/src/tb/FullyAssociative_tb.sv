module FullyAssociative_tb();


   reg clk, rst, wen, ren, hit;
   
   reg [31:0] address_i, data_i, data_o

   FullyAssociative cache (.clk(clk)
                          ,.rst(rst)
                          ,.address_i(address_i)
                          ,.data_i(data_i)
                          ,.wen_i(wen)
                          ,.ren_i(ren)

                          ,.hit_o(hit)
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
      
      @(negedge clk);
      
      address_i = 32'b00400_0000;
      data_i    = 32'b00400_1234;
      wen       =  1'b1;
   
      $stop;
   end
   
   
   
endmodule 