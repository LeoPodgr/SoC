module alu_1
(
    input        MAX10_CLK1_50,
	input  [1:0] KEY,
    input  [9:0] SW,
    output [9:0] LEDR
);
    //wires
    wire [3:0] x_bus, y_bus;
    wire       load_x, load_y;
    wire       clock;
    wire       reset;
    
    assign clock = MAX10_CLK1_50;
    assign reset = KEY[1];
    
    //register for the arguments
    register_1 #(.WIDTH(4)) x_register
    (
        .clock   (clock  ),
        .reset   (reset  ),
        .load    (load_x ),
        .data_in (SW[4:1]),
        .data_out(x_bus  )
    );

    register_1 #(.WIDTH(4)) y_register
    (
        .clock   (clock  ),
        .reset   (reset  ),
        .load    (load_y ),
        .data_in (SW[4:1]),
        .data_out(y_bus  )
    );
    
    //argument selector
    assign load_x =  SW[0] & ~KEY[0] ? 1'b1 : 1'b0;
    assign load_y = ~SW[0] & ~KEY[0] ? 1'b1 : 1'b0;

    //alu
    alu
    #(
        .WIDTH(4),
        .SHIFT(2)
    )
    i_alu
    (
        .x        ( x_bus     ),
        .y        ( y_bus     ),
        .shamt    ( SW[6:5]   ),
        .operation( SW[9:8]   ),
        .zero     ( LEDR[9]   ),
        .result   ( LEDR[3:0] )
);
    
    assign LEDR[8:4] = 0;
    
endmodule



//ALU commands
`define ALU_AND 2'b00
`define ALU_ADD 2'b01
`define ALU_SLL 2'b10
`define ALU_SLT 2'b11

module alu
#(
    parameter WIDTH = 4,
    parameter SHIFT = 2
)
(
    input      [WIDTH - 1:0] x, y,
    input      [SHIFT - 1:0] shamt,
    input      [ 1:0]        operation,
    output                   zero,
    output reg [WIDTH - 1:0] result
);

    always @ (*) begin
        case (operation)
            `ALU_AND : result = x & y; 
            `ALU_ADD : result = x + y;
            `ALU_SLL : result = y << shamt;
            `ALU_SLT : result = (x < y) ? 1 : 0;
        endcase
    end

    //Flags
    assign zero      = (result == 0);

endmodule



module register_1
# (
    parameter WIDTH = 8
)
(
    input                      clock,
    input                      reset,
    input                      load,
    input 	   [ WIDTH - 1:0 ] data_in,
    output reg [ WIDTH - 1:0 ] data_out
);

	always @ ( posedge clock, negedge reset )
		if ( ~reset )
            data_out <= { WIDTH { 1'b0 } };
        else if ( load )
            data_out <= data_in;
endmodule