onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Robo_TB_Tiago/DUV/clock
add wave -noupdate /Robo_TB_Tiago/DUV/advance
add wave -noupdate /Robo_TB_Tiago/DUV/state
add wave -noupdate /Robo_TB_Tiago/DUV/future_state
add wave -noupdate /Robo_TB_Tiago/DUV/turn
add wave -noupdate /Robo_TB_Tiago/DUV/head
add wave -noupdate /Robo_TB_Tiago/DUV/left
add wave -noupdate -radix decimal /Robo_TB_Tiago/Linha_Robo
add wave -noupdate -radix decimal /Robo_TB_Tiago/Coluna_Robo
add wave -noupdate /Robo_TB_Tiago/DUV/under
add wave -noupdate /Robo_TB_Tiago/barrier
add wave -noupdate /Robo_TB_Tiago/dado_celula
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7097 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1239 ns} {2198 ns}
