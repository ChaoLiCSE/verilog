/**
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
 * 
 *      valid   dirty  tag             cacheline     
 *      +------+-------+---------------+------------------------------------+
 *    0 |      |       |               |                                    | 
 *      +------+-------+---------------+------------------------------------+
 *
 *
 **/

typedef struct packed {
   reg valid;
   reg dirty;
   reg [23:0] tag;
   reg [127:0] cacheline;
} set_s;


module fourway_cache (input [32:0] address_i
                     ,input [128:0] new_cacheline_i
                     ,input ren_i
                     ,input wen_i
                     ,input rst
                     ,input clk

                     ,output hit_o
                     ,output [32:0] data_o
                     );

   //--------------------------------------------------------------------------
   // set up LRU table
   //--------------------------------------------------------------------------
   reg [3:0] set_index_i;
   reg [1:0] arr_index_i, arr_index_o;

   lru_table lru (.set_index_i(set_index_i)     // set index
                 ,.arr_index_i(arr_index_i)     // 1 of the 4 array index
                 ,.clk(clk)
                 ,.rst(rst)
                 ,.access(ren_i)
                 ,.update(wen_i)
                 ,.arr_index_o(arr_index_o));   // 1 of the 4 array index

   //--------------------------------------------------------------------------
   // set up cashe
   //--------------------------------------------------------------------------
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
		end
	end
	
	wire [23:0] tag;
	wire [3:0] index;
	wire [3:0] offset;
		
	assign offset  = address_i[3:0];
	assign index 	= address_i[7:4];
	assign tag 		= address_i[31:8];
	
   //--------------------------------------------------------------------------
   // determine cashe hit or miss
   //--------------------------------------------------------------------------
	wire sel0, sel1, sel2, sel3;
	assign sel0 = array0[index].tag == tag & array0[index].valid;
	assign sel1 = array1[index].tag == tag & array1[index].valid;
	assign sel2 = array2[index].tag == tag & array2[index].valid;
	assign sel3 = array3[index].tag == tag & array3[index].valid;
	
	assign hit_o = sel0 | sel1 |  sel2 | sel3;
	
   //--------------------------------------------------------------------------
   // select data from one of the 4-way associative array
   //--------------------------------------------------------------------------
	assign data_o = sel0 ? array0[index].cacheline :
						 sel1 ? array1[index].cacheline :
						 sel2 ? array2[index].cacheline :
						 sel0 ? array0[index].cacheline : 32'hxxxx_xxxx;
						 
                   
   //--------------------------------------------------------------------------
   // update LRU table, update cashe (if necessary)
   //--------------------------------------------------------------------------
   always_ff @(posedge clk) begin
      if(rst) begin
         for(int i = 0; i < 16; i = i + 1) begin
            array0[i] <= 0;
            array1[i] <= 0;
            array2[i] <= 0;
            array3[i] <= 0;
         end
      end 
      else begin
         // update lease recently used table
         set_index_i <= index;
         case({sel3, sel2, sel1, sel0})
            4'b0001: arr_index_i <= 2'b00;
            4'b0010: arr_index_i <= 2'b01;
            4'b0100: arr_index_i <= 2'b10;
            4'b1000: arr_index_i <= 2'b11;
            default: arr_index_i <= 2'bxx;
         endcase
         
         // update cache line
         if(wen_i) begin
            case(arr_index_o) // lease recent used index
               2'b00: array0[index].cacheline <= new_cacheline_i;
               2'b01: array1[index].cacheline <= new_cacheline_i;
               2'b10: array2[index].cacheline <= new_cacheline_i;
               2'b11: array3[index].cacheline <= new_cacheline_i;
            endcase
         end

      end // else
   end  // always_ff

endmodule // four_way_cache