/**
 *
 * Least Recently Used Table
 *    Keeps track of a list of set index 0...16. In each one of the set, it
 *    consist of 4 arrays.
 *
 *      0        1        2        3
 *      +--------+--------+--------+--------+
 *    0 |        |        |        |        | 
 *      +--------+--------+--------+--------+
 *    1 |        |        |        |        |
 *      +--------+--------+--------+--------+
 *    2 |        |        |        |        |
 *          .         .         .       .
 *          .         .         .       .
 *          .         .         .       .
 *      +--------+--------+--------+--------+
 *   15 |        |        |        |        |
 *      +--------+--------+--------+--------+
 **/

module lru_table (input [3:0] set_index_i
                 ,input [1:0] arr_index_i
                 ,input       clk
                 ,input       rst
                 ,input       access
                 ,input       update


                 ,output [1:0] arr_index_o);



   reg [1:0] index_o [0:15];
   reg       access_list [0:15];
   reg       update_list [0:15];

   lru_4_emlt lru00(.index_i(arr_index_i), .access(access_list[0]), .update(update_list[0]), .clk(clk), .rst(rst), .index_o(index_o[0]));
   lru_4_emlt lru01(.index_i(arr_index_i), .access(access_list[1]), .update(update_list[1]), .clk(clk), .rst(rst), .index_o(index_o[1]));
   lru_4_emlt lru02(.index_i(arr_index_i), .access(access_list[2]), .update(update_list[2]), .clk(clk), .rst(rst), .index_o(index_o[2]));
   lru_4_emlt lru03(.index_i(arr_index_i), .access(access_list[3]), .update(update_list[3]), .clk(clk), .rst(rst), .index_o(index_o[3]));
   lru_4_emlt lru04(.index_i(arr_index_i), .access(access_list[4]), .update(update_list[4]), .clk(clk), .rst(rst), .index_o(index_o[4]));
   lru_4_emlt lru05(.index_i(arr_index_i), .access(access_list[5]), .update(update_list[5]), .clk(clk), .rst(rst), .index_o(index_o[5]));
   lru_4_emlt lru06(.index_i(arr_index_i), .access(access_list[6]), .update(update_list[6]), .clk(clk), .rst(rst), .index_o(index_o[6]));
   lru_4_emlt lru07(.index_i(arr_index_i), .access(access_list[7]), .update(update_list[7]), .clk(clk), .rst(rst), .index_o(index_o[7]));
   lru_4_emlt lru08(.index_i(arr_index_i), .access(access_list[8]), .update(update_list[8]), .clk(clk), .rst(rst), .index_o(index_o[8]));
   lru_4_emlt lru09(.index_i(arr_index_i), .access(access_list[9]), .update(update_list[9]), .clk(clk), .rst(rst), .index_o(index_o[9]));
   lru_4_emlt lru10(.index_i(arr_index_i), .access(access_list[10]), .update(update_list[10]), .clk(clk), .rst(rst), .index_o(index_o[10]));
   lru_4_emlt lru11(.index_i(arr_index_i), .access(access_list[11]), .update(update_list[11]), .clk(clk), .rst(rst), .index_o(index_o[11]));
   lru_4_emlt lru12(.index_i(arr_index_i), .access(access_list[12]), .update(update_list[12]), .clk(clk), .rst(rst), .index_o(index_o[12]));
   lru_4_emlt lru13(.index_i(arr_index_i), .access(access_list[13]), .update(update_list[13]), .clk(clk), .rst(rst), .index_o(index_o[13]));
   lru_4_emlt lru14(.index_i(arr_index_i), .access(access_list[14]), .update(update_list[14]), .clk(clk), .rst(rst), .index_o(index_o[14]));
   lru_4_emlt lru15(.index_i(arr_index_i), .access(access_list[15]), .update(update_list[15]), .clk(clk), .rst(rst), .index_o(index_o[15]));


   always_ff@(posedge clk) begin
      for(integer i = 0; i < 16; i = i + 1) begin
         if(i != set_index_i) begin
            access_list[i] <= 0;
            update_list[i] <= 0;
         end
         else begin
            access_list[i] <= access;
            update_list[i] <= update;
         end
      end // for-loop

      arr_index_o <= index_o[set_index_i];
   end // always_ff

endmodule



