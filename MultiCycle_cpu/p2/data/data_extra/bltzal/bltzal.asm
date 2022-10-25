ori $1,$0,1
bltzal $1,con1
ori $2,$0,1
con1:subu $3,$0,$1
bltzal $3,con3
ori $4,$0,1
con3:bltzal $0,con4
ori $5,$0,1
con4: