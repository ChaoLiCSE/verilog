/******************************************************************************
 *
 * Least Recent Used
 *    Generate an array of n-length, each index holds a time stamp value with 
 *    0 to be the mimimum value.
 *    
 *    Returns the index of the maximum value in the array.
 *
 * Author: Chao (Jack) Li 
 *
 *****************************************************************************/

module LRU #(parameter LENGTH = 32
            )
            (input clk
            ,input rst
            ,input access
            ,input [$clog2(LENGTH)-1:0] index_i
            ,output [$clog2(LENGTH)-1:0] index_o
            );

   reg [$clog2(LENGTH)-1:0] lru [0:LENGTH-1];
   
   wire [$clog2(LENGTH)-1:0] value[0:LENGTH-2];
   wire [$clog2(LENGTH)-1:0] index[0:LENGTH-2];
   
   genvar gen_i, gen_j;
   // set up generate-array, compare each pair in lru array
   generate
      for(gen_i = 0; gen_i < LENGTH; gen_i = gen_i + 2) begin : loop1
         // truncates the width to remove warning signs
         parameter [$clog2(LENGTH)-1:0] i = gen_i;
         parameter [$clog2(LENGTH)-1:0] i_plus1 = gen_i + 1;
         Compare  #(.VALUE_WIDTH($clog2(LENGTH))
                   ,.INDEX_WIDTH($clog2(LENGTH))
                   )
                   cmp1(.value_A_i(lru[i])
                       ,.value_B_i(lru[i_plus1])
                       ,.index_A_i(i)
                       ,.index_B_i(i_plus1)
                       ,.value_out_o(value[i/2])
                       ,.index_out_o(index[i/2])
                       );
      end
   endgenerate 

   // for each level, compare each pair in generate-array and write back result
   // back to generate-array
   generate
      // for each level
      for(gen_i = 1; gen_i < $clog2(LENGTH); gen_i = gen_i + 1) begin : loop2_1
         parameter param_r = LENGTH - (LENGTH >> (gen_i-1));  // offset of read 
         parameter param_w = LENGTH - (LENGTH >> gen_i);      // offset of write
         parameter param_s = (LENGTH >> gen_i); // amount to generate
         // generate lg(LENGTH) of Compare module
         for(gen_j = 0; gen_j < param_s; gen_j = gen_j + 2) begin : loop2_2
            parameter [$clog2(LENGTH)-1:0] j = gen_j;
            parameter [$clog2(LENGTH)-1:0] j_plus1 = gen_j+1;
            Compare #(.VALUE_WIDTH($clog2(LENGTH))
                     ,.INDEX_WIDTH($clog2(LENGTH))
                     )
                      cmp2(.value_A_i(value[param_r + j])
                          ,.value_B_i(value[param_r + j_plus1])
                          ,.index_A_i(index[param_r + j])
                          ,.index_B_i(index[param_r + j_plus1])
                          ,.value_out_o(value[param_w + (j/2)])
                          ,.index_out_o(index[param_w + (j/2)])
                          );
         end
      end
   endgenerate

   assign index_o = index[LENGTH-2];   // least recent used index

   always_ff@(posedge clk) begin
      if(rst) begin
         for(integer i = 0; i < LENGTH; i = i + 1) begin
            lru[i] <= i;
         end
      end
      else begin
         // increment each time stamp by 1, set access index's time stamp to 0
         if(access) begin
            for(integer i = 0; i < LENGTH; i = i + 1) begin
               if(index_i == i) begin
                  lru[index_i] <= 0;
               end
               else begin  // check for potential overflow
                  if(lru[i] != {$clog2(LENGTH){1'b1}}) begin
                     lru[i] <= lru[i] + 1;
                  end
               end
            end // for()
         end // if(access)
      end   
   end // always_ff

endmodule 