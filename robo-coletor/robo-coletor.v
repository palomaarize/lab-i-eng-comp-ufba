module Robo (  
	output reg advance, turn, collect,
	input head, left, barrier, under, clock, reset
);

`include "definitions.v"


    reg [2:0] state = `STATE_FETCH; 
    reg [2:0] future_state = `STAND_BY;
    reg  under_reset = 1'b0;


    always @(posedge clock) begin
        if(reset) begin
            state <= `STAND_BY;
            under_reset <= `ACTIVE;
        end
        else begin
            state <= future_state;
            under_reset <= ~`ACTIVE;
        end
    end

    always @(*) begin
        case (state)
            `STAND_BY: begin
                if(head == 1'b1 && left == 1'b0 && under == 1'b1 && barrier == 1'b0 && under_reset == 1'b1)
                begin
                    turn = `ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `STAND_BY;
                end

                if(head == 1'b0 && under == 1'b1 && barrier == 1'b1 && under_reset == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = `ACTIVE;
                    future_state = `COLLECT_TRASH;
                end

                if(head == 1'b0 && left == 1'b1 && under == 1'b1 && barrier == 1'b0 && under_reset == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `FOLLOW_THE_WALL;
                end
                
                if(head == 1'b0 && left == 1'b0 && under == 1'b1 && barrier == 1'b0 && under_reset == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `SEARCH_THE_WALL;
                end
            end

            `COLLECT_TRASH: begin
                if(under == 1'b0 && barrier == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = `ACTIVE;
                    future_state = `COLLECT_TRASH;
                end
                
                if(head == 1'b0 && left == 1'b0 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `SEARCH_THE_WALL;
                end

                if(head == 1'b0 && left == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `FOLLOW_THE_WALL;
                end                
            end

            `FOLLOW_THE_WALL: begin
                if(under == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `STAND_BY;
                end
                
                if(head == 1'b0 && left == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `FOLLOW_THE_WALL;
                end

                if(under == 1'b0 && barrier == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = `ACTIVE;
                    future_state = `COLLECT_TRASH;
                end

                if(head == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = `ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `SEARCH_THE_WALL;
                end

                if(head == 1'b0 && left == 1'b0 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = `ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `SEARCH_THE_WALL;
                end
            end

            `SEARCH_THE_WALL: begin
                if(head == 1'b0 && left == 1'b0 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `SEARCH_THE_WALL;
                end

                if(under == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `STAND_BY;
                end

                if(head == 1'b0 && left == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `FOLLOW_THE_WALL;
                end

                if(head == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = `ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `TURN_90;
                end

                if(head == 1'b0 && under == 1'b0 && barrier == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = `ACTIVE;
                    future_state = `COLLECT_TRASH;
                end
            end

            `TURN_90: begin
                if(head == 1'b0 && left == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = ~`ACTIVE;
                    advance = `ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `FOLLOW_THE_WALL;
                end

                if(head == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = `ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `TURN_90;
                end

                if(head == 1'b1 && under == 1'b0 && barrier == 1'b0)
                begin
                    turn = `ACTIVE;
                    advance = ~`ACTIVE;
                    collect = ~`ACTIVE;
                    future_state = `TURN_90;
                end

                if(under == 1'b0 && barrier == 1'b1)
                begin
                    turn = ~`ACTIVE;
                    advance = ~`ACTIVE;
                    collect = `ACTIVE;
                    future_state = `COLLECT_TRASH;
                end
            end
            default: begin
                turn = ~`ACTIVE;
                advance = ~`ACTIVE;
                collect = ~`ACTIVE;
                future_state = `STAND_BY;
            end
        endcase
    end
endmodule