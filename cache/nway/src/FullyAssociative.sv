

module FullyAssociative #(parameter WIDTH = 32
                         ,parameter C = 1024
                         ,parameter B = 32
                         ,parameter A = C/B
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

   localparam VALID  = 1'b0;
   localparam DIRTY  = 1'b0;
   localparam INDEX  = 1'b0;
   localparam OFFSET = $clog2(B);
   localparam TAG    = WIDTH-OFFSET-INDEX;

   wire [$clog2(B):0] offset;
   wire [WIDTH-1:0] tag;


   assign tag    = address_i[WIDTH-1:TAG];
   assign offset = address_i[OFFSET-1:0];


   reg [VALID+DIRTY+TAG+B-1:0] cache [0:A];

   initial begin
      for(integer i = 0; i < A; i = i + 1) begin
         cache[i] <= 0;
      end 
   end 


   always_comb begin
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
         case({Wen_i,ren_i})
            case 2'b10: cache[offset] <= {1'b1, 1'b1, tag, data_i};
            case 2'b01: // TODO: LRU
            default: // do nothing
         endcase
      end
   end // always_ff






endmodule