module var7
(
    input  clock,
    input  reset_n,
    input  enable,
    input  [1:0]a,
    output reg [1:0]y
);

    parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
	 parameter [1:0] A0 = 2'b00, A1 = 2'b01, A2 = 2'b10, A3 = 2'b11;
	 parameter [1:0] Y0 = 2'b00, Y1 = 2'b01, Y2 = 2'b10, Y3 = 2'b11;

    reg [1:0] state, next_state;

    // State register

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            state <= S0;
        else if (enable)
            state <= next_state;

    // Next state logic

    always @*
        case (state)
        
        S0:
            case (a)

				A0:
					next_state = S1;
				A1:
					next_state = S2;
				A2:
					next_state = S3;
				A3:
					next_state = S1;
					
				default:
				
					next_state = S0;
					
				endcase
        S1:
            case (a)

				A0:
					next_state = S1;
				A1:
					next_state = S2;
				A2:
					next_state = S2;
				A3:
					next_state = S0;
					
				default:
				
					next_state = S0;
					
				endcase

        S2:
            case (a)

				A0:
					next_state = S1;
				A1:
					next_state = S3;
				A2:
					next_state = S1;
				A3:
					next_state = S2;
					
				default:
				
					next_state = S0;
					
				endcase

        S3:
            case (a)

				A0:
					next_state = S3;
				A1:
					next_state = S2;
				A2:
					next_state = S3;
				A3:
					next_state = S2;
					
				default:
				
					next_state = S0;
					
				endcase

        default:

            next_state = S0;

        endcase

    // Output logic based on input and current state

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            y <= Y0;
        else if (enable)
        begin
			  case (state)
			  
			  S0:
					case (a)

					A0:
						y <= Y2;
					A1:
						y <= Y0;
					A2:
						y <= Y2;
					A3:
						y <= Y0;
						
					default:
					
						y <= Y0;
						
					endcase
			  S1:
					case (a)

					A0:
						y <= Y1;
					A1:
						y <= Y2;
					A2:
						y <= Y0;
					A3:
						y <= Y0;
						
					default:
					
						y <= Y0;
						
					endcase
			  S2:
					case (a)

					A0:
						y <= Y3;
					A1:
						y <= Y2;
					A2:
						y <= Y0;
					A3:
						y <= Y2;
						
					default:
					
						y <= Y0;
						
					endcase
			  S3:
					case (a)

					A0:
						y <= Y3;
					A1:
						y <= Y1;
					A2:
						y <= Y0;
					A3:
						y <= Y3;
						
					default:
					
						y <= Y0;
						
					endcase

			  default:

					y <= Y0;

			  endcase
        end
    end

endmodule