/******************************************************************************
 *
 * Compare
 *      Compares A and B, returns the larger of the two values
 *
 * Author: Chao (Jack) Li 
 *
 *****************************************************************************/
 
module Compare #(parameter VALUE_WIDTH = 32
                ,parameter INDEX_WIDTH = 32
                )
                (input [VALUE_WIDTH-1:0] value_A_i
                ,input [VALUE_WIDTH-1:0] value_B_i
                
                ,input [INDEX_WIDTH-1:0] index_A_i
                ,input [INDEX_WIDTH-1:0] index_B_i
                
                ,output [VALUE_WIDTH-1:0] value_out_o
                ,output [INDEX_WIDTH-1:0] index_out_o
                );
                
            
   assign value_out_o = value_A_i > value_B_i ? value_A_i : value_B_i;
   assign index_out_o = value_A_i > value_B_i ? index_A_i : index_B_i;
                
endmodule 