`timescale 1ns / 1ps
module tb();

reg clk = 0;
reg resetn = 0;
reg ready = 0;
wire valid;
wire [7:0] data;

reg ready_atrasado;
reg invalid = 0;
reg dados_arquivo [0:9];
reg [7:0] check_data = 8'd4;

avalon av(
    .clk(clk),
    .resetn(resetn),
    .valid(valid),
    .ready(ready),
    .data(data)
);

always #1 clk = ~clk;

integer i;
initial begin
    $dumpfile("saida.vcd");
    $dumpvars(0, tb);
    $readmemb("teste.txt", dados_arquivo);
    // $monitor("ready=%b, valid=%b, data=%h", ready, valid, data);
    resetn = 0;
    #2;
    resetn = 1;

    for (i=0; i<10; i=i+1) begin
        ready = dados_arquivo[i];
        #2;
    end

    $finish;
end

always @(posedge clk) begin
    ready_atrasado <= ready;
    if (valid == 1'b1 && ready_atrasado == 1'b0) begin
        $display("Erro no protocolo no: valid em nivel alto e ready em nivel baixo.");
    end

end

always @(posedge clk) begin
    if (valid == 1'b1) begin
        if (data == check_data)
            check_data <= check_data + 1;
        else begin
            $display("Erro no dado: dado esperado %h, dado recebido %h", check_data, data);
            check_data <= check_data + 1;
        end
    end
end

endmodule