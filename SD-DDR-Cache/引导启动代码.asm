# DON'T USE $0 $1 
# $10 Keep 0x10010000
addi $10, $0, 0x10010000
wait_SD_init:

addi $11, $0, 10000000
trap:
addi $11, $11, -1
bne $11, $0, trap


lw $2, 0x4014($10)
sw $2, 0x4050($10)
sw $2, 0x4054($10)

beq $2, $0, nook

j ok

nook:
#reset
addi $5, $0, 0x00000004
sw $5, 0x4010($10)
sw $0, 0x4010($10)

j wait_SD_init

ok:
sw $0, 0x400C($10)
addi $2, $0, 1
sw $2, 0x4010($10)

wait_read:
lw $2, 0x4014($10)
sw $2, 0x4050($10)
sw $2, 0x4054($10)

andi $2, $2, 0x00000001
beq $2, $0, wait_read

# read ok
sw $0, 0x4010($10)

addi $2, $0, 0x12345678
sw $2, 0x4050($10)
sw $2, 0x4054($10)

addi $2, $0, 0x00000080 # sd addr end 
addi $3, $0, 0 # sd addr and alse ddr2 buffer addr
addi $11, $0, 1
addi $12, $0, 0x00000003
andi $20, $0, 0
ddr2_pre:
sw $3, 0x4018($10)
lw $4, 0x4058($10) # 32bits from sd 
sw $4, 0x401C($10) # save into ddr2 data 
sw $3, 0x4020($10) # ddr2 write addr 
sw $11, 0x4024($10)
sw $0, 0x4024($10) # write into ddr2 buffer 

andi $5, $3, 0x00000003
beq $5, $12, write_into_ddr2 
j end_write_into_ddr2

write_into_ddr2:
sw $20, 0x4028($10)
addi $6, $0, 2
sw $6, 0x402C($10)

wait_ddr2_write_end:
lw $7, 0x4030($10)
bne $7, $6, wait_ddr2_write_end

sw $0, 0x402C($10)
addi $20, $20, 1

end_write_into_ddr2:
addi $3, $3, 1

bne $3, $2, ddr2_pre

addi $2, $0, 0x23456789
sw $2, 0x4050($10)
sw $2, 0x4054($10)

ddr2_ok:
addi $22, $0, 4
addi $21, $0, 1
addi $20, $0, 0 # inst addr
addi $2, $0, 0 # 00000 - 11111
addi $23, $0, 0x20

out_ddr:
sw $2, 0x4028($10)
addi $4, $0, 1
sw $4, 0x402C($10)
wait_out_ddr:
lw $5, 0x4030($10)
bne $5, $4, wait_out_ddr
sw $0, 0x402C($10)
# read ok

addi $3, $0, 0 # 00 - 11

write_imem:
sw $3, 0x4034($10)
sw $20, 0x4038($10)
sw $21, 0x403C($10)
sw $0, 0x403C($10)

addi $20, $20, 4
addi $3, $3, 1
bne $3, $22, write_imem

addi $2, $2, 1
bne $2, $23, out_ddr

nop
nop
nop
