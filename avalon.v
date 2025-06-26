module avalon (
    input wire clk,
    input wire resetn,
    output reg valid,
    input wire ready,
    output reg [7:0] data
);


parameter S0 = 1'b0, 
          S1 = 1'b1; 


reg [7:0] data_to_send [0:2];
initial begin
    data_to_send[0] = 8'd4;
    data_to_send[1] = 8'd5;
    data_to_send[2] = 8'd6;
end

reg [2:0] counter;

reg [1:0] state_machine;

always @(posedge clk, negedge resetn)begin
    if(~resetn) begin
        counter <= 0;
        valid  <= 0;
        data <= 8'bxxxxxxxx;
        state_machine <= S0;
    end
    else
        case (state_machine)
            S0: begin
                data <= 8'bxxxxxxxx;
                valid <= 0;
                counter <= counter;
               
                if(ready && (counter < 3))begin
                    state_machine <= S1;
                    data <= data_to_send[counter];
                    valid <= 1;
                    counter <= counter + 1;
                end
                else begin
                    state_machine <= S0;
                end
            end
            S1: begin
                data <= data_to_send[counter];
                valid <= 1;
                counter <= counter + 1;
               
                if (ready && (counter < 3))begin
                    state_machine <= S1; 
                end
                else  begin
                    state_machine <= S0; 
                    data <= 8'bxxxxxxxx;
                    valid <= 0;
                    counter <= counter;
                end
            end
        endcase
end

endmodule




