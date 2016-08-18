/******************************************************************************
 *
 * Simple 4-way cache
 *    C = ABS
 *       C = 1KB
 *       A = 4
 *       B = 16B (4 words)
 *       S = (1024)/(4*16) = 16
 *
 *       offset = lg(B) = 4 bits
 *       index  = lg(S) = 4 bits
 *       tag    = 32 - offset - index = 24 bits
 *
 *****************************************************************************/

typedef struct packed {
   reg valid;
   reg dirty;
   reg [23:0] tag;
   reg [127:0] cacheline;
} set_s;

module four_way_cache(input [32:0] address_i
                     ,input [128:0] new_cacheline_i
                     ,input wen_i

                     ,output hit_o
                     ,output [32:0] data_o
                     );

   set_s array0 [0:15];
   set_s array1 [0:15];
   set_s array2 [0:15];
   set_s array3 [0:15];

	initial begin
		for(int i = 0; i < 16; i = i + 1) begin
			array0[i] = 0;
			array1[i] = 0;
			array2[i] = 0;
			array3[i] = 0;
			
			array0[i].dirty = 1'b1;
			array1[i].dirty = 1'b1;
			array2[i].dirty = 1'b1;
			array3[i].dirty = 1'b1;
		end
	end
	
	wire [23:0] tag;
	wire [3:0] index;
	wire [3:0] offset;
		
	assign offset  = address_i[3:0];
	assign index 	= address_i[7:4];
	assign tag 		= address_i[31:8];
	
	
	wire sel0, sel1, sel2, sel3;
	assign sel0 = array0[index].tag == tag & array0[index].valid;
	assign sel1 = array1[index].tag == tag & array1[index].valid;
	assign sel2 = array2[index].tag == tag & array2[index].valid;
	assign sel3 = array3[index].tag == tag & array3[index].valid;
	
	assign hit_o = sel0 | sel1 |  sel2 | sel3;
	
	assign data_o = sel0 ? array0[index].cacheline :
						 sel1 ? array1[index].cacheline :
						 sel2 ? array2[index].cacheline :
						 sel0 ? array0[index].cacheline : 32'hxxxx_xxxx;
						 
	always_ff begin
		if(wen_i) begin
			array
	
	
	end
	
	
endmodule // four_way_cache