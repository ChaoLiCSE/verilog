/******************************************************************************
 *
 * Direct Mapped Cache
 *
 *    C = ABS
 *       C = 128
 *       A = 1
 *       B = 4 bytes
 *       S = C/B = 32
 *
 *       offset = lg(B) = 2 bits
 *       index  = lg(S) = 5 bits
 *       tag    = 32 - offset - index = 25 bits
 *
 * 
 *    S   valid  dirty   tag             cache line
 *   --- +------+-------+--------------+--------------------------------------+  
 *    0  |      |       |              |                                      |  
 *       +------+-------+--------------+--------------------------------------+ 
 *    1  |      |       |              |                                      |  
 *       +------+-------+--------------+--------------------------------------+ 
 *    2  |      |       |              |                                      |  
 *       +------+-------+--------------+--------------------------------------+
 *    .  |      |       |              |                                      |             
 *    .  |      |       |              |                                      |
 *    .  |      |       |              |                                      |
 *       +------+-------+--------------+--------------------------------------+
 *    n  |      |       |              |                                      |  
 *       +------+-------+--------------+--------------------------------------+
 *
 * Author: Chao (Jack) Li
 *
 *
 *****************************************************************************/

module DirectMapped #(parameter WIDTH = 32
                     ,parameter C = 128
                     //         A = 1
                     ,parameter B = 4
                     ,parameter S = C/B
                     )
                     (input clk
                     ,input rst
                     ,input wen_i
                     ,input [WIDTH-1:0] address_i
                     ,input [B*8-1:0] data_i
                     
                     ,output hit_o
                     ,output [WIDTH-1:0] data_o
                     );

   localparam WIDTH_VALID   = 1'b1;
   localparam WIDTH_DIRTY   = 1'b1;
   localparam WIDTH_OFFSET = $clog2(B);
   localparam WIDTH_INDEX  = $clog2(S);
   localparam WIDTH_TAG    = WIDTH - WIDTH_OFFSET - WIDTH_INDEX;
   localparam WIDTH_ROW    = WIDTH_VALID + WIDTH_DIRTY + WIDTH_TAG + B*8;

   localparam OFFSET_DATA_LSB = 0;
   localparam OFFSET_DATA_MSB = B*8-1; 
   localparam OFFSET_TAG_LSB  = B*8;
   localparam OFFSET_TAG_MSB  = B*8+WIDTH_TAG-1;
   localparam OFFSET_DIRTY    = WIDTH_ROW-2;
   localparam OFFSET_VALID    = WIDTH_ROW-1;

   reg [WIDTH_ROW-1:0] cache [0:S-1];

   wire [WIDTH_OFFSET-1:0] offset;
   wire [WIDTH_INDEX-1:0]  index;
   wire [WIDTH_TAG-1:0]    tag;

   assign offset = address_i[WIDTH_OFFSET-1:0];
   assign index  = address_i[WIDTH_INDEX+WIDTH_OFFSET-1:WIDTH_OFFSET];
   assign tag    = address_i[WIDTH-WIDTH_INDEX+WIDTH_OFFSET-1:WIDTH_INDEX+WIDTH_OFFSET];


   assign hit_o  = cache[index][OFFSET_TAG_MSB:OFFSET_TAG_LSB] == tag ? 1 : 0;

   // A = offset>>2         := get displace 0, 1, 2, 3, etc
   // B = 1<<$clog(WIDTH)   := get size of word, 32, 64, 128, etc
   // cache[index] << A * B := get n-th word in cacheline 
   assign data_o = cache[index] << ((offset>>2)*(1<<$clog2(WIDTH)));

   always_ff @(posedge clk) begin
      if(rst) begin
         for(integer i = 0; i < S; i = i + 1) begin
            cache[i] <= 0;
         end
      end
      else begin
         if(wen_i) begin
            cache[index] <= {1'b1, 1'b1, tag, data_i};
         end
      end
   end // always_ff

endmodule 