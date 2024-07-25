module vga (
    input clock,
    input reset,
    input [2:0] state,          // Estado atual do robô
    output reg [7:0] vga_red,   // Saídas VGA para a cor vermelha
    output reg [7:0] vga_green, // Saídas VGA para a cor verde
    output reg [7:0] vga_blue,  // Saídas VGA para a cor azul
    output hsync,               // Sincronização horizontal
    output vsync                // Sincronização vertical
);

`include "definitions.v"

// Parâmetros para resolução e sincronização VGA
parameter H_DISPLAY = 640;
parameter H_FRONT = 16;
parameter H_SYNC = 96;
parameter H_BACK = 48;
parameter V_DISPLAY = 480;
parameter V_FRONT = 10;
parameter V_SYNC = 2;
parameter V_BACK = 33;

reg [10:0] h_counter = 0;
reg [9:0] v_counter = 0;

// Contadores de sincronização horizontal e vertical
always @(posedge clock) begin
    if (reset) begin
        h_counter <= 0;
        v_counter <= 0;
    end else begin
        if (h_counter < H_DISPLAY + H_FRONT + H_SYNC + H_BACK - 1) begin
            h_counter <= h_counter + 1;
        end else begin
            h_counter <= 0;
            if (v_counter < V_DISPLAY + V_FRONT + V_SYNC + V_BACK - 1) begin
                v_counter <= v_counter + 1;
            end else begin
                v_counter <= 0;
            end
        end
    end
end

// Geração dos sinais de sincronização
assign hsync = (h_counter >= H_DISPLAY + H_FRONT && h_counter < H_DISPLAY + H_FRONT + H_SYNC) ? 0 : 1;
assign vsync = (v_counter >= V_DISPLAY + V_FRONT && v_counter < V_DISPLAY + V_FRONT + V_SYNC) ? 0 : 1;

// Geração das cores VGA com base no estado do robô
always @(*) begin
    if (h_counter < H_DISPLAY && v_counter < V_DISPLAY) begin
        case (state)
            `STAND_BY: begin
                vga_red = 8'hFF; // Branco
                vga_green = 8'hFF;
                vga_blue = 8'hFF;
            end
            `COLLECT_TRASH: begin
                vga_red = 8'h00; // Azul
                vga_green = 8'h00;
                vga_blue = 8'hFF;
            end
            `FOLLOW_THE_WALL: begin
                vga_red = 8'h00; // Verde
                vga_green = 8'hFF;
                vga_blue = 8'h00;
            end
            `SEARCH_THE_WALL: begin
                vga_red = 8'hFF; // Vermelho
                vga_green = 8'h00;
                vga_blue = 8'h00;
            end
            `TURN_90: begin
                vga_red = 8'hFF; // Amarelo
                vga_green = 8'hFF;
                vga_blue = 8'h00;
            end
            default: begin
                vga_red = 8'h00; // Preto
                vga_green = 8'h00;
                vga_blue = 8'h00;
            end
        endcase
    end else begin
        vga_red = 8'h00; // Preto fora da área visível
        vga_green = 8'h00;
        vga_blue = 8'h00;
    end
end

endmodule