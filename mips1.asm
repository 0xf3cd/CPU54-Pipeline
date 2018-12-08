nop
addi $10, $0, 0x1000
addi $11, $0, 0x0CBD
addi $12, $0, 0x5678
addi $13, $0, 0x789A
addi $14, $0, 0x192D
addi $15, $0, 0x0A98
addi $16, $0, 0x4321
lui $17, 0x1001
nop
nop
nop
nop
nop
ori $17, $17, 0x0000
lui $18, 0x18CD
nop
nop
nop
nop
nop
ori $18, $18, 0xabcd
nop
nop
nop
nop
nop
sw $18, 0xf04($17)
#sw $12, 0x4($10)
#sw $13, 0x8($10)
#sw $14, 0xB($10)
#sw $15, 0x10($10)
#sw $16, 0x14($10)
