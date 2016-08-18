`timescale 1ns / 1ps

module lease_recently_used_4_elmt_tb();


	reg clk;
	reg rst;
	
	reg access;
	reg update;
	
	reg [1:0] index_i;
	reg [1:0] index_o;
	
	
	 lease_recently_used_4_elmt dut (.clk(clk)
											  ,.rst(rst)
											  ,.index_i(index_i)
											  ,.access(access)
											  ,.update(update)
												  
											  ,.index_o(index_o)
											  );

	always begin
		#100 clk = ~clk;
	end
	
	initial begin
		access = 0;
		update = 0;
		clk	 = 0;
		rst 	 = 1;
		index_i = 0;
		
		@(negedge clk);
		rst = 0;
		
		@(negedge clk);
		index_i = 0;
		access  = 1;
		
		@(negedge clk);
		index_i = 1;
		access  = 1;

		@(negedge clk);
		index_i = 2;
		access  = 1;
		
		@(negedge clk);
		index_i = 3;
		access  = 1;
		//-----------------------------------------------------------------------
		
		@(negedge clk);
		index_i = 0;
		access  = 0;
		update  = 1;
		
		@(negedge clk);
		$stop;
	end
	

	








endmodule
