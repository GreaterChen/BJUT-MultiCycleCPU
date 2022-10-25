ori $1,$0,1
bgtz $1,CON1
j CON2
CON1:ori $2,$0,1
CON2:subu $3,$0,$1
bgtz $3,CON3
j CON4
CON3:ori $4,$0,1
CON4: