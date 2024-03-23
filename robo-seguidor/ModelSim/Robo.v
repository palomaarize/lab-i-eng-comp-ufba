module Robo (  
	output reg avancar, girar, q, nq,
	input head, left, clock, reset, preset
);

  always @(posedge clock or posedge reset or posedge preset)
    begin
      nq <= ~q;
      if(reset)
      begin
        q <= 1'b0;
        nq <= 1'b1;
      end
      else if(preset)
      begin
        q <= 1'b1;
        nq <= 1'b0;
      end
      case(q)
          1'b0: // state 0
            begin
              if(head == 1'b1)
                begin
                  girar <= 1'b1;
                  avancar <= 1'b0;
                  q <= 1'b0;
                end
              else if(head == 1'b0 && left== 1'b1)
                begin
                  avancar <= 1'b1;
                  girar <= 1'b0;
                  q <= 1'b0;
                end
              else
                begin
                  avancar <= 1'b1;
                  girar <= 1'b0;
                  q <= 1'b1;
                end
            end
          1'b1: // state 1
            begin
              if(head == 1'b0 && left== 1'b0)
                begin
                  girar <= 1'b0;
                  avancar <= 1'b1;
                  q <= 1'b1;
                end
              else if(head == 1'b0 && left== 1'b1)
                begin
                  avancar <= 1'b1;
                  girar <= 1'b0;
                  q <= 1'b0;
                end
              else
                begin
                  avancar <= 1'b0;
                  girar <= 1'b1;
                  q <= 1'b0;
                end
            end
            default:
              begin
                avancar <= 1'b0;
                girar <= 1'b1;
                q <= 1'b0;
                nq <= 1'b1;
              end
        endcase
     end
endmodule
