#9 Seg 7段数码管待写入数据
#10 一直为0x10010000

#sw 804
#   Seg

addi $11, $0, 0xffffffff
addi $10, $0, 0x10010000

update:
sw   $11, 0x804($10)
addi $9, $0, 0x000fedcb

wait:
addi $9, $9, -1
bne  $9, $0, wait

addi $11, $11, -1
j    update