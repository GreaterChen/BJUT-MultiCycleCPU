ori $1,$0,0x7f00 	
ori $2,$0,0x7f10	
ori $3,$0,0x7f20	

lw $4,0($2)
sw $4,0($3)
sw $4,4($3)

ori $5,$0,0x0401
mtc0 $5,$12
ori $5,$0,0x0108
mtc0 $5,$15
mfc0 $6,$15

ori $7,$0,1000
sw $7,4($1)
ori $7,$0,9
sw $7,0($1)
loop:j loop
