/**
 *
 * Fully Associative Cache
 *
 *    C = ABS
 *       C = 1KB
 *       A = C/B = 1024/4 = 256
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
 **/

module FullyAssociative #(parameter WIDTH = 32
                          parameter C = 1024
                          parameter B = 4
                          parameter A = C/B
                          //        S = 1
                         )

                         (input clk
                         ,input rst
                         ,input [WIDTH:0] address_i
                         ,input [WIDTH:0] data_i
                         ,input wen_i
                         ,input ren_i

                         ,output hit_o
                         ,output [WIDTH-1:0] data_o
                         );

   const reg VALID = 1'b1;
   const reg DIRTY = 1'b1;
   const reg INDEX = 1'b0;
   const [WIDTH-1:0] OFFSET = $clog2(B);
   const [WIDTH-1:0] TAG    = WIDTH-OFFSET-INDEX;

   wire [$clog2(B)-1:0] offset;
   wire [WIDTH-1:0] tag;


   assign tag    = address_i[WIDTH-1:TAG];
   assign offset = address_i[OFFSET-1:0];


   reg [VALID+DIRTY+TAG+B-1:0] cache [0:A];
   reg [$clog2(A)-1:0] lru_list [0:A];
   wire [$clog2(A)-1:0] lru;
   
   assign lru = 
   
   initial begin
      for(integer i = 0; i < A; i = i + 1) begin
         cache[i] = 0;
         lru_list[i] = i;
      end 
   end 


   always_comb(*) begin
      for(integer i = 0; i < A; i = i + 1) begin
         if(cache[i][TAG-1:0] == tag) begin
            hit_o = 1'b1;
            break;
         end
      end
      hit_o = 1'b0;
   end


   always_ff@(posedge clk) begin
      if(rst) begin
         for(integer i = 0; i < A; i = i + 1) begin
            cache[i] <= 0;
         end
      end 
      else begin
         case({wen_i, ren_i})
            2'b10: cache[lru] <= {1'b1, 1'b1, tag, data_i};
            2'b01: 
               if(hit_o) begin
               
               end
               else begin
                  cache[
               end
            default:
         endcase;
      end
   end // always_ff






endmodule