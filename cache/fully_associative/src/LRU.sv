module LRU #(parameter SIZE = 32
            )
            (input rst
            ,input [$clog2(SIZE)-1:0] index_i
            
            ,output {$clog2(SIZE)-1:0] index_o
            );

            
   reg [$clog2(SIZE)-1:0] lru [0:SIZE-1];
   
   
   initial begin
      for(integer i = 0; i < SIZE; i = i + 1) begin
         lru[i] = i;
      end
   end
   
   





endmodule 