`timescale 1ns/1ns

module Robo_TB;

parameter N = 2'b00, S = 2'b01, L = 2'b10, O = 2'b11;

reg clock, reset, head, left, under, barrier;
wire advance, turn;

reg [1:2] Mapa [1:9][1:10]; // linha 0 reservada para posicao do robo e quantidade de movimentos
reg [1:20] Linha_Mapa;
reg [1:5] Linha_Robo;
reg [1:5] Coluna_Robo;
reg [1:2] Orientacao_Robo; 
reg [1:8] Qtd_Movimentos;
reg [1:48] String_Orientacao_Robo;
reg [1:2] dado_celula;
integer i;
integer j;
integer k;

Robo DUV (.clock(clock), .reset(reset), .head(head), .left(left), .barrier(barrier), .under(under), .advance(advance), .turn(turn), .collect(collect));

always
	#50 clock = !clock;

initial
begin
	clock = 0;
	reset = 1;
	head = 0;
	left = 0;
	under = 1;
	barrier = 0;

	$readmemb("/home/palomasilvaarizesantos/Documentos/ufba/lab-i/robo-coletor/mapa.txt", Mapa);
	Linha_Mapa = {Mapa[1][1], Mapa[1][2], Mapa[1][3], Mapa[1][4], Mapa[1][5], Mapa[1][6], Mapa[1][7], Mapa[1][8], Mapa[1][9], Mapa[1][10]};
	Linha_Robo = 3'b100;
	Coluna_Robo = 3'b011;
	Orientacao_Robo = N;
	Qtd_Movimentos = Linha_Mapa[13:20];
	$display ("Linha = %d Coluna = %d Orientacao = %s Movimentos = %d", Linha_Robo, Coluna_Robo, String_Orientacao_Robo, Qtd_Movimentos);

	for (j = 1; j <= 9; j = j + 1) begin
      		for (k = 1; k <= 10; k = k + 1) begin
        		$display("Mapa[%0d][%0d] = %0b", j, k, Mapa[j][k]);
      		end
    	end
	
	if (Situacoes_Anomalas(1)) $stop;

	#100 @ (negedge clock) reset = 0; // sincroniza com borda de descida

	for (i = 0; i < Qtd_Movimentos; i = i + 1)
	begin
		@ (negedge clock);
		Define_Sensores;
		$display ("H = %b L = %b", head, left);
		@ (negedge clock);
		Atualiza_Posicao_Robo;
		case (Orientacao_Robo)
			N: String_Orientacao_Robo = "Norte";
			S: String_Orientacao_Robo = "Sul  ";
			L: String_Orientacao_Robo = "Leste";
			O: String_Orientacao_Robo = "Oeste";
		endcase
		$display ("Linha = %d Coluna = %d Orientacao = %s", Linha_Robo, Coluna_Robo, String_Orientacao_Robo);
		if (Situacoes_Anomalas(1)) $stop;
	end

	#50 $stop;
end

function Situacoes_Anomalas (input X);
begin
	Situacoes_Anomalas = 0;
	if ( (Linha_Robo < 1) || (Linha_Robo > 20) || (Coluna_Robo < 1) || (Coluna_Robo > 20) )
		Situacoes_Anomalas = 1;
	//else
	//begin
		//Linha_Mapa = Mapa[Linha_Robo];
		//if (Mapa[Linha_Robo][Coluna_Robo] != 2'b11)
		//	Situacoes_Anomalas = 1;
	//end
end
endfunction

task Define_Sensores;
begin
	case (Orientacao_Robo)
		N:	begin
				// definicao de head
				if (Linha_Robo == 1)
					head = 1;
				else
				begin
                    dado_celula = Mapa[Linha_Robo - 1][Coluna_Robo];
					if(dado_celula == 2'b01)
                        head = 1;
                    else 
                        head = 0;
				end

				// definicao de left
				if (Coluna_Robo == 1)
					left = 1;
				else
				begin
		            dado_celula = Mapa[Linha_Robo][Coluna_Robo - 1];
					if(dado_celula == 2'b01)
                        left = 1;
                    else
                        left = 0;
				end

                // definicao de barrier
				if (Linha_Robo == 1)
					barrier = 0;
				else
				begin
                    dado_celula = Mapa[Linha_Robo - 1][Coluna_Robo];
					if(dado_celula == 2'b10)
                        barrier = 1;
                    else 
                        barrier = 0;
			    end

                // definicao de under
				if (Linha_Robo == 1)
					under = 0;
				else
				begin
					//Linha_Mapa = Mapa[Linha_Robo];
                   dado_celula = Mapa[Linha_Robo][Coluna_Robo];
					if(dado_celula == 2'b11)
                        under = 1;
                    else 
                        under = 0;
				end
			end
		//S:	begin
				// definicao de head
				//if (Linha_Robo == 20)
				//	head = 1;
				//else
				//begin
					//Linha_Mapa = Mapa[Linha_Robo + 1];
				//	head = Linha_Mapa[Coluna_Robo];
				//end
				// definicao de left
				//if (Coluna_Robo == 20)
				//	left = 1;
				//else
				//begin
				//	Linha_Mapa = Mapa[Linha_Robo];
				//	left = Linha_Mapa[Coluna_Robo + 1];
			//	//end
		//	end
		//L:	begin
				// definicao de head
		//		if (Coluna_Robo == 20)
		//			head = 1;
			//	else
			//	begin
			//		Linha_Mapa = Mapa[Linha_Robo];
			//		head = Linha_Mapa[Coluna_Robo + 1];
				//end
				// definicao de left
				//if (Linha_Robo == 1)
				//	left = 1;
				//else
				//begin
				//	Linha_Mapa = Mapa[Linha_Robo - 1];
				//	left = Linha_Mapa[Coluna_Robo];
				//end
		//	end
		//O:	begin
				// definicao de head
				//if (Coluna_Robo == 1)
				//	head = 1;
				//else
				//begin
				//	Linha_Mapa = Mapa[Linha_Robo];
				//	head = Linha_Mapa[Coluna_Robo - 1];
				//end
				// definicao de left
				//if (Linha_Robo == 20)
				//	left = 1;
				//else
				//begin
				//	Linha_Mapa = Mapa[Linha_Robo + 1];
				//	left = Linha_Mapa[Coluna_Robo];
				//end
			//end
	endcase
end
endtask

task Atualiza_Posicao_Robo;
begin
	case (Orientacao_Robo)
		N:	begin
				// definicao de orientacao / linha / coluna
				if (advance)
				begin
					Linha_Robo = Linha_Robo - 1;
				end
				else
				if (turn)
				begin
					Orientacao_Robo = O;
				end
			end
		S:	begin
				// definicao de orientacao / linha / coluna
				if (advance)
				begin
					Linha_Robo = Linha_Robo + 1;
				end
				else
				if (turn)
				begin
					Orientacao_Robo = L;
				end
			end
		L:	begin
				// definicao de orientacao / linha / coluna
				if (advance)
				begin
					Coluna_Robo = Coluna_Robo + 1;
				end
				else
				if (turn)
				begin
					Orientacao_Robo = N;
				end
			end
		O:	begin
				// definicao de orientacao / linha / coluna
				if (advance)
				begin
					Coluna_Robo = Coluna_Robo - 1;
				end
				else
				if (turn)
				begin
					Orientacao_Robo = S;
				end
			end
	endcase
end
endtask

endmodule