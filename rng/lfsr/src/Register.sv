module Register #(parameter WIDTH = 32
                 )
                 (input clk
                 ,input rst
                 ,input  [WIDTH-1:0] data_i
                 ,output reg [WIDTH-1:0] data_o
                 );


   always_ff@(posedge clk) begin
      if(rst) begin
         data_o <= 0;
      end
      else begin
         data_o <= data_i;
      end
   end // always_ff


endmodule 