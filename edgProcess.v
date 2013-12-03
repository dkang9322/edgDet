module edgProc(reset, clk,
	       hcount, vcount, // Not used in processing for now
	       two_pixel_vals, // Data Input to be processed
	       write_addr, //Data Address to write in ZBT bank 1
	       two_proc_pixs, // Processed Pixel
	       proc_pix_addr
	       /*
	       switch_vals, // switches to choose num_shifts
	       switch_sels, // switches to choose HSV
	       change //Button to re-write color
		*/
	       );
   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   input [35:0] two_pixel_vals;
   input [18:0] write_addr; 
   output [35:0] two_proc_pixs;
   output [18:0] proc_pix_addr;


   wire [35:0] 	 two_proc_pixs;
   
   reg [18:0] 	 proc_pix_addr;

   // Note actually delay is half of DELAY
   parameter DELAY = 2;
   parameter OLDEST_IND = DELAY - 1;
   parameter DELAY_A = DELAY + 3 * 91;
   parameter OLDEST_IND_A = DELAY_A - 1;
   
   integer 	 i; // Delay for Address
   integer 	 j; // Delay for Data
   
   

   /*parameter ADD_DEL = 19 * DELAY - 1;
   parameter DAT_DEL = 36 * DELAY - 1;*/
   

   reg [18:0] addr_del [OLDEST_IND:0];
   reg [35:0] dat_del  [OLDEST_IND_A:0];

   edgWrapper edg_abstr(reset, clk, dat_del[OLDEST_IND],
			two_proc_pixs, hcount);
   
   
   always @(posedge clk)
     /* Appropriate Delaying via for_loop, unsure of performance*/ 
     begin
	// Address Delay
	for (i=1;i<DELAY;i=i+1)
	  begin
	     addr_del[i] <= addr_del[i-1];
	  end
	// Data Delay
	dat_del[1] <= dat_del[0];
	
	/* Note: Order of execution doesn't matter, its hardware*/
	dat_del[0] <= two_pixel_vals;
	addr_del[0] <= write_addr;

	// Outputting address
	proc_pix_addr <= addr_del[OLDEST_IND_A];
     end
   
endmodule // pixProc

/* Previous Attempt To Delay*/
/* Arrays can only be written index by index */
/*
 dat_del[OLDEST_IND:0] <= {dat_del[OLDEST_IND-1:0], two_pixel_vals};
 
 // Let's see what happens if we delay write_addr by more than appropriate
 addr_del[OLDEST_IND:0] <= {addr_del[OLDEST_IND-1:0], write_addr};

 */

