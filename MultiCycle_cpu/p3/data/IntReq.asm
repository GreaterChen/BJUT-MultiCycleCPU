lw $10,0($2)
lw $11,0($3)
beq $10,$11,con1

sw $10,0($3)
sw $10,4($3)

beq $0,$0,return

con1:lw $12,4($3)
addiu $12,$12,1
sw $12,4($3)

return:ori $13,$0,1000
sw $13,4($1)
ori $13,$0,9
sw $13,0($1)
eret
