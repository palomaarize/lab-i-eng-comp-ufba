module top (
    input clock,
    input reset,
    input head,
    input left,
    input barrier,
    input under,
    output [7:0] vga_red,
    output [7:0] vga_green,
    output [7:0] vga_blue,
    output hsync,
    output vsync
);

wire advance, turn, collect;
wire [2:0] state;

// Instanciando o módulo Robo
Robo robo (
    .advance(advance),
    .turn(turn),
    .collect(collect),
    .head(head),
    .left(left),
    .barrier(barrier),
    .under(under),
    .clock(clock),
    .reset(reset)
);

// Atribuindo o estado atual do robô para ser usado no módulo VGA
assign state = robo.state;

// Instanciando o módulo VGA
vga vga_display (
    .clock(clock),
    .reset(reset),
    .state(state),
    .vga_red(vga_red),
    .vga_green(vga_green),
    .vga_blue(vga_blue),
    .hsync(hsync),
    .vsync(vsync)
);

endmodule