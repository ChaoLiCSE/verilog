

module LFSR (input clk
            ,input rst
            ,input [18:0] seed

            ,output reg [18:0] out);




   genvar gen_i;
   generate
      parameter [4:0] i = gen_i;
      for(gen_i = 0; gen_i < 19; gen_i = gen_i + 1) begin
         Register #(.WIDTH(1)
                   )
                   dreg (.clk(clk)
                        ,.rst(rst)
                        ,.data_i(seed[i])
                        ,.data_o(out[i])
                        );
      end
   endgenerate




endmodule 