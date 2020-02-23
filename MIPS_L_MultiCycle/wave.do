onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/clk
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/rst
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/RFWr
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/DMWr
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/PCWr
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/IRWr
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/EXTOp
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/ALUOp
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/NPCOp
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/GPRSel
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/WDSel
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/ASel
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/BSel
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/Zero
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/PC
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/NPC
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/im_dout
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/dm_dout
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/dm_dout_r
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/DR_out
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/instr
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/rs
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/rt
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/rd
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/shamt
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/Op
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/Funct
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/Imm16
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/Imm32
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/IMM
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/A3
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/WD
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/RD1
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/RD1_r
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/RD2
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/RD2_r
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/A
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/B
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/C
add wave -noupdate -radix hexadecimal /mips_tb/U_MIPS/C_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8245 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 175
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
WaveRestoreZoom {9289 ns} {10248 ns}
