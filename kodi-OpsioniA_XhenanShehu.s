# FINAL

.data
    array: .space 20
    n: .word 0 #numri i antareve ne array
    newLine: .asciiz "\n"
    MSG1: .asciiz "Jep numrin e antareve te vektorit(max 5): "
    MSG2: .asciiz "\n Jep antaret nje nga nje: \n"
.text
    .globl main
    main:

        la $a0, array           #adresa e array load ne a0
        lw $a1, n               #vlera e n load ne a1

        jal popullovektorin     #thirret funksioni popullovektorin

        move $t0, $v1           #vlera e kthyer nga funksioni zhvendoset ne t0
        la $a1, n               #adresa e N ruhet ne a1
        sw $t0, 0($a1)          #rruhet vlera e N ne ate adres

        la $a0, array           #load adresa e array pas mbushjes
        lw $a1, n               #load vlera n pas ndryshimit

        jal unazaKalimit        #thirret funksioni unaza kalimit

        li $v0, 10              #mbyllet programit
        syscall 

#----------------------------POPULLOVEKTORIN-------------------------------------

popullovektorin:
    move $s0, $a0       #ruaje adresen e array ne S0, dergohet si parameter

    li $v0, 4           #Kemi me printu String
    la $a0, MSG1        #adresa e mesazhit qe kemi me printu
    syscall             #shfaqe ne ekran

    li $v0 , 5          #merr nga inputi numrin e antareve
    syscall
    move $s1, $v0       #|n| ruaje inputin ne S1
    move $v1, $s1       #|n| ruaje edhe ne v1 per me return 

    li $v0, 4           #Kemi me printu String
    la $a0, MSG2        #adresa e mesazhit qe kemi me printu
    syscall             #shfaqe ne ekran

    li $s2,1            #| i |  deklarohet counteri i

    ForLoop:            #Starting Loop
        
        bgt		$s2, $s1, endLoop	# if $s2 > $t1 then endLoop
            
            li $v0, 5           #marrim inpute integer
            syscall     
            sw $v0, 0($s0)      #ruajme inputin ne array
            addi $s0, $s0, 4    #Qasja e anetarit perkates ne array
            addi $s2, $s2, 1    #|i++| rritet counteri
            j ForLoop           #kce nforloop
    endLoop:
        jr $ra                  #kthehu ne main loqk

#-------------------------------UNAZAKALIMIT-----------------------------------------

    unazaKalimit:
        addi $sp, $sp, -4            #rezervojme hapsire ne stack per nje antar
        sw $ra,  0($sp)              #e ruajme addresen e mainit ne Stack

        move $s0, $a0                #|int a| ruaje adresen e array ne S0
        move $s1, $a1                #|int n| ruaje adresen e numrit te antareve ne S1
        addi $s1, $s1, -1            #|n-1| p nuk e merr parasysh antarin e fundit
        
        li $t0, 0                    #|p=0| counteri

        forLoop2:
            slt $s5,$t0,$s1          #krahason p < n-1 
            beq $s5,$zero, endLoop2  #krahason $s5 == 0, if true target endLoop2

            sll $t5,$t0,2           #shift left per 2 per me u kriju shumfishi 4shit
            add $t5, $s0, $t5       #Krijohet adresa e antarit perkates   
            lw $t1, 0($t5)          #|a[p]| ju qasemi antarit perkates
            move $s7, $t1           # e zhvendosim a[p] ne nje regjister tjeter
           
            move $t2, $t0           #|loc|  deklarohet loc
            move $a2, $t0           #|p| dergohet si parameter tek funksioni tjeter 

            jal unazaVlerave        # thirret funksioni

            move $t9, $s7           #|t9| deklarohet vlera temp dhe behet temp = a[p]

            sll $t5,$t0,2           #shift left per 2 per me u kriju shumfishi 4shit  
            add $t5, $s0, $t5       #Krijohet adresa e antarit perkates 
            sw $t1, 0($t5)          #|a[p]| vlera minimale rruhet tek a[p]=min
    
            sll $t4,$t2,2           #shift left per 2 per me u kriju shumfishi 4shit
            add $t5, $s0, $t4       #Krijohet adresa e antarit perkates
            sw $t9, 0($t5)          #| a[loc] | rruhet vlera temp ne antarin e a[loc]=temp
            
            addi $t0, $t0, 1        #| i++ | rritet counteri per 1
            j forLoop2              #kce ne for

    endLoop2:
        la $a0, array               #lexohet adresa e arrayt
        move $s0, $a0               #zhvendoset adresa ne $s0
        lw $t0, n                   #| n |merret numri i antareve dhe rruhet ne t0

        li $t1,1                    #| i=1 |  counteri
        
        forLoop4:                   #loopa me printu vektorin
            bgt $t1,$t0,endLoop4    #if $t1 > $t0 target endLoop4   
            
            li $v0, 1               #Tregojme qe kemi me printu int
            lw $a0, 0($s0)          #marrim antarin nga array
            syscall                 #display

            addi $s0, $s0, 4        #e ndryshojme antarin e arrayt duke shkuar tjetri
            addi $t1, $t1, 1        #e rrisim counterin per1
        
            li $v0, 4               #Tregojme qe kemi me printu string
            la $a0, newLine         #printojm newLine
            syscall                 #display
            
            j forLoop4              #kce ne loop
        endLoop4:   
            lw $ra, 0($sp)              #load adresen e mainit nga stacku
            addi $sp,$sp,4              #kthehet stacku ne gjendjen e meparshme
            jr $ra                      #kce n'main

#-------------------------------UNAZAVLERAVE-----------------------------------------

    unazaVlerave: 
        move $s2, $a0               #|array| adresa e array na vjen si parameter e ruajm ne s2
        move $s3, $a1               #|n| n na vjen si parameter e ruajm ne s3 
        move $s4, $a2               #|p| p na vjen si parameter e ruajm ne s4 

        addi $t4, $s4, 1            #|k| vlera e k eshte p+1 ruhet ne t4
    forLoop3:
        slt $t5,$t4,$s3             #krahason k < n
        beq $t5,$zero,endLoop3

        sll $t7,$t4,2               #shift left per 2 per me u kriju shumfishi 4shit
        add $t7, $s0, $t7           #Krijohet adresa e antarit perkates  
        lw $t8, 0($t7)              #a[k*4]
        
        slt $s5,$t8,$t1             #krahason a[k] < min
        beq $s5, $zero, else
            addi $t1, $t8, 0        # min = a[k]
            addi $t2, $t4, 0        # loc = k
        else:   
            addi $t4, $t4, 1            #rritet counteri per 1
            j forLoop3                  #kce ne forLoop
    endLoop3:
        jr $ra                      #kthehu te funskioni paraprak