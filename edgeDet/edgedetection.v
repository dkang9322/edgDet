`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:14 11/26/2013 
// Design Name: 
// Module Name:    edgedetection 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module edgedetection(
    input 	  reset,
    input 	  clock,
    input [23:0]  rgb, // This corresponds to the lower_pixels in ZBT [ZBT[17:0]]
    input [23:0]  rgb1, // This corresponds to the higher_pixels in ZBT
    input [10:0]  hcount,
    output [23:0] edgeoutputsel,
    output 	  select
    );


   wire [7:0] 	  grayout, grayout1;
   wire [7:0] 	  sr_grayout;
   

   wire [71:0] 	   matrixout;
   wire 	   swi = 0;
   wire [7:0] 	   edgeoutputsobel;


   /* Making sure that we take in two pixels at a time
     Includes Muxing to shift_register*/
   rgb2gray converter(clock,rgb,grayout);
   rgb2gray converter2(clock, rgb1, grayout1);

   assign sr_grayout = hcount[0] ? grayout : grayout1;


   
   /* Seeing whether grayscale image is being computed */
   /*assign edgeoutputsel={sr_grayout, sr_grayout, sr_grayout};*/


   /* Stage ii Debugging */   
   /* Want to output the last element of row3 to get one pixel
    value. This is to see the appropriate amount of latency */
   /*
   assign select = 1;
   shiftregister #(.cols(640)) shifter(clock,hcount,sr_grayout,matrixout);
   // With cols = 13, should see approximately double the distance
   wire [7:0] 	   shifted_gs = matrixout[23:16];
   
   assign edgeoutputsel = {shifted_gs, shifted_gs, shifted_gs};
   */

   /* Actual Full Implementation */

   shiftregister shifter(clock,hcount,sr_grayout,matrixout);
   
   sobel edgedetect(clock,matrixout[71:64],matrixout[63:56],
		    matrixout[55:48],matrixout[47:40],matrixout[39:32],
		    matrixout[31:24],matrixout[23:16],matrixout[15:8],
		    matrixout[7:0],swi,edgeoutputsobel);
   selectbit selector(clock,edgeoutputsobel,edgeoutputsel,select);


   

endmodule
