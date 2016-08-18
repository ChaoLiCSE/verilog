/**
 *
 * 4 element LRU list
 *
 **/
module lease_recently_used_4_elmt (input [1:0] index_i
											 ,input access
											 ,input update
											 ,input clk
											 ,input rst
												
											 ,output [1:0] index_o
			  								 );

	logic [1:0] lru_list [0:3];

	
	always_ff@(posedge clk) begin
			casex({rst, access, update})
				3'b1xx: begin	// reset
					lru_list[0] <= 0;
					lru_list[1] <= 0;
					lru_list[2] <= 0;
					lru_list[3] <= 0;
				end
				3'b010: begin	// access
					case(index_i)
						2'b00: begin
							lru_list[0] <= 0;
							lru_list[1] <= lru_list[1] + 1;
							lru_list[2] <= lru_list[2] + 1;
							lru_list[3] <= lru_list[3] + 1;
						end
						2'b01: begin
							lru_list[0] <= lru_list[0] + 1;
							lru_list[1] <= 0;
							lru_list[2] <= lru_list[2] + 1;
							lru_list[3] <= lru_list[3] + 1;
						end
						2'b10: begin
							lru_list[0] <= lru_list[0] + 1;
							lru_list[1] <= lru_list[1] + 1;
							lru_list[2] <= 0;
							lru_list[3] <= lru_list[3] + 1;
						end
						2'b11: begin
							lru_list[0] <= lru_list[0] + 1;
							lru_list[1] <= lru_list[1] + 1;
							lru_list[2] <= lru_list[2] + 1;
							lru_list[3] <= 0;
						end
					endcase
					
				end
				3'b001: begin	// update
					lru_list[index_i] <= 0;
				end
				default: begin
					lru_list[0] <= lru_list[0];
					lru_list[1] <= lru_list[1];
					lru_list[2] <= lru_list[2];
					lru_list[3] <= lru_list[3];
				end
			endcase
//		end
	
	end // always_comb
	
	wire [1:0] cmp1, cmp2;
	assign cmp1 = lru_list[0] > lru_list[1] ? 0 : 1;
	assign cmp2 = lru_list[2] > lru_list[3] ? 2 : 3;
	assign index_o = lru_list[cmp1] > lru_list[cmp2] ? cmp1 : cmp2;
	

endmodule 