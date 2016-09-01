/******************************************************************************
 *
 * Fully Associative Cache
 *
 *    C = ABS
 *       C = 128
 *       A = C/B = 128/4 = 32
 *       B = 4 bytes
 *       S = 1
 *
 *       offset = lg(B) = 2 bits
 *       index  = lg(S) = 0 bits
 *       tag    = 32 - offset - index = 30 bits
 *
 * 
 *       valid  dirty   tag             cache line
 *      +------+-------+---------------+--------------------------------------+  
 *    0 |      |       |               |                                      |  
 *      +------+-------+---------------+--------------------------------------+ 
 *      \__________________________________   ________________________________/
 *                                         \ /
 *                                          |
 *                                          |
 *    A    0     1     2     3              v                 n-2   n-1    n 
 *      +-----+-----+-----+-----+--------+-----+------------+-----+-----+-----+  
 *      |     |     |     |     | . . . .|     |. . . . . . |     |     |     |  
 *      +-----+-----+-----+-----+--------+-----+------------+-----+-----+-----+  
 *
 * Author: Chao (Jack) Li
 *
 *
 *****************************************************************************/

module FullyAssociative #(parameter WIDTH = 32
                         ,parameter C = 128     // bytes
                         ,parameter B = 4       // bytes
                         ,parameter A = C/B     // n-way
                          //        S = 1       // 1 set
                         )

                         (input clk
                         ,input rst
                         ,input [WIDTH-1:0] address_i
                         ,input [B*8-1:0] data_i
                         ,input wen_i
                         ,input ren_i

                         ,output reg hit_o
                         ,output [WIDTH-1:0] data_o
                         );


   localparam WIDTH_VALID   = 1'b1;
   localparam WIDTH_DIRTY   = 1'b1;
   localparam WIDTH_OFFSET = $clog2(B);
   localparam WIDTH_INDEX  = 1'b0;
   localparam WIDTH_TAG    = WIDTH - WIDTH_OFFSET - WIDTH_INDEX;
   localparam WIDTH_ROW    = WIDTH_VALID + WIDTH_DIRTY + WIDTH_TAG + B*8;

   localparam OFFSET_DATA_LSB = 0;
   localparam OFFSET_DATA_MSB = B*8-1; 
   localparam OFFSET_TAG_LSB  = B*8;
   localparam OFFSET_TAG_MSB  = B*8+WIDTH_TAG-1;
   localparam OFFSET_DIRTY    = WIDTH_ROW-2;
   localparam OFFSET_VALID    = WIDTH_ROW-1;


   reg [WIDTH_ROW-1:0] cache [0:A-1];

   wire [WIDTH_TAG-1:0]    tag;
   wire [WIDTH_OFFSET-1:0] offset;

   assign offset = address_i[WIDTH_OFFSET-1:0];
   assign tag    = address_i[WIDTH-1:WIDTH_OFFSET];

   reg [$clog2(A)-1:0] hit_index;

   // compare each tag in parallel
   always_comb begin 
      hit_o     = 1'b0;
      hit_index = 1'b0;
      for(integer i = 0; i < A; i = i + 1) begin
         if(cache[i][OFFSET_TAG_MSB:OFFSET_TAG_LSB] == tag) begin
            hit_o = 1'b1;
            hit_index = i;
            break;
         end
      end
   end
   
   reg [$clog2(A)-1:0] lru_index_i;
   reg [$clog2(A)-1:0] lru_index_o;

   wire lru_access_i;
   assign lru_access_i = ren_i & hit_o | wen_i;

   LRU #(.LENGTH(A)
        )
        lru (.clk(clk)
            ,.rst(rst)
            ,.access(lru_access_i)
            ,.index_i(lru_index_i)
            ,.index_o(lru_index_o)
            );

   // A = offset>>2       := get displace 0, 1, 2, 3,... etc
   // B = 1<<$clog(WIDTH) := get size of word, 32, 64, 128, etc
   // cache[hit_index] << A * B get n-th word in cacheline 
   assign data_o = cache[hit_index] << ((offset>>2)*(1<<$clog2(WIDTH)));

   assign lru_index_i = rst ? 0
                            : ren_i ? hit_index 
                                    : lru_index_o; 

   always_ff @(posedge clk) begin
      if(rst) begin
         for(integer i = 0; i < A; i = i + 1) begin
            cache[i] <= 0;
         end
      end
      else begin
         if(wen_i && !hit_o) begin
            cache[lru_index_o] <= {1'b1, 1'b1, tag, data_i};
         end
      end
   end // always_ff

endmodule