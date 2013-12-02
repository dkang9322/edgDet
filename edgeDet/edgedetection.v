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
    input reset,
    input clock,
    input [23:0] rgb,
    input hcount,
    output [23:0] edgeoutputsel,
    output select
    );


	wire [7:0] grayout;
	wire [71:0] matrixout;
	wire swi = 0;
	wire [7:0] edgeoutputsobel;

	rgb2gray converter(clock,rgb,grayout);
	shiftregister shifter(clock,hcount,grayout,matrixout);
	
	sobel edgedetect(clock,matrixout[71:64],matrixout[63:56],
		matrixout[55:48],matrixout[47:40],matrixout[39:32],
		matrixout[31:24],matrixout[23:16],matrixout[15:8],
		matrixout[7:0],swi,edgeoutputsobel);
	selectbit selector(clock,edgeoutputsobel,edgeoutputsel,select);
	

endmodule
