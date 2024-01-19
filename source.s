# Aux
# matrix[line][column] = line * matrixColumns + column
##

.data
    matrix: .space 1600
    auxMatrix: .space 1600

    currentLineIndex: .space 4
    currentColumnIndex: .space 4
    matrixLines: .space 4
    matrixColumns: .space 4
    dimensiuneTotala: .space 4
    numberOfAliveCells: .space 4
    numberOfEvolutions: .space 4
    currentEvolution: .space 4
    sumaVecini: .space 4
    cerinta: .space 4
    sir: .space 60
    lungimeSir: .space 4
    lungimeBitiSir: .space 4

    puteri: .long 1, 2, 4, 8, 16, 32, 64, 128

    inputString: .asciz "%s"
    outputHexadecimal: .asciz "%02X"
    inputStream: .asciz "%ld"
    outputDigit: .asciz "%ld "
    hexaPrefix: .asciz "0x"
    newline: .asciz "\n"
    outputChar: .asciz "%c"

    initialConfigInfo: .asciz "Initial state of your configuration is:\n"
    afterEvolutionsInfo: .asciz "Your configuration state after %ld evolutions is:\n"
    encryptionText: .asciz "Encryption of \"%s\" using current system configuration is "
    decryptionText: .asciz "Decryption of \"%s\" using current system configuration is "

.text

print_matrix: # (lines, columns, *matrix)
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl %edi
    pushl %ebx
    movl 16(%ebp), %edi
    movl $0, -4(%ebp) # currentLine
    movl $0, -8(%ebp) # currentColumn
    pm_loop_lines:
        movl -4(%ebp), %eax
        cmp 8(%ebp), %eax
        je pm_exit_loop_lines

        pm_loop_columns:
            movl -8(%ebp), %eax
            cmp 12(%ebp), %eax
            je pm_exit_loop_columns

            pushl 12(%ebp)
            pushl -8(%ebp)
            pushl -4(%ebp)
            call getPositionInMatrix
            addl $12, %esp

            movl (%edi, %eax, 4), %ecx
            
            pushl %ecx
            pushl $outputDigit
            call printf
            addl $8, %esp
            pushl $0
            call fflush
            popl %eax

            incl -8(%ebp)
            jmp pm_loop_columns
        pm_exit_loop_columns:

        movl $4, %eax
        movl $1, %ebx
        movl $newline, %ecx
        movl $2, %edx
        int $0x80

        movl $0, -8(%ebp)
        incl -4(%ebp)
        jmp pm_loop_lines
    pm_exit_loop_lines:
    
    addl $8, %esp
    popl %edi
    popl %ebx
    popl %ebp
    ret

# convert(hexa):
# 0000 adresa
# 0004 hexa
convert:
    xorl %eax, %eax
    movl 4(%esp), %eax 
    cmp $0x39, %eax
    jg from_letter
    subl $0x30, %eax
    ret
    from_letter:
        subl $0x37, %eax
    ret

# complete_matrix(lungime, &matrix_size, *matrix)
# 0000 adr retur
# 0004 lungime
# 0008 matrix_size
# 0012 matrix
complete_matrix:
    xorl %ecx, %ecx
    movl 4(%esp), %eax
    movl 8(%esp), %ebx
    movl 12(%esp), %edi

    movl 0(%ebx), %ebx

    cm_loop:
        cmp %ecx, %eax
        je cm_end_loop

        movl (%edi, %ecx, 4), %edx
        movl %edx, (%edi, %ebx, 4)
        
        incl %ebx
        incl %ecx
        jmp cm_loop
    cm_end_loop:

    movl %ebx, %eax
    movl 8(%esp), %ebx
    movl %eax, 0(%ebx)
    ret
###### END FUNC

# take_8_bits(*puteri, *matrix, poz_start, &rezultat)
# 0000 adr retur
# 0004 puteri
# 0008 matrix
# 0012 poz_start
# 0016 rezultat
take_8_bits:
    movl 12(%esp), %eax # poz_start
    xorl %edx, %edx
    movl $0, %ecx

    t8b_loop:
        cmp $8, %edx
        je t8b_end_loop

        movl 8(%esp), %edi # matrix
        movl (%edi, %eax, 4), %ebx
        cmp $0, %ebx
        je t8b_continue

        # daca ebx=1 atunci rezultat+=puteri[8-edx-1]
        movl 4(%esp), %edi # puteri
        movl $8, %ebx
        subl %edx, %ebx
        decl %ebx
        movl (%edi, %ebx, 4), %ebx
        addl %ebx, %ecx

        t8b_continue:

        incl %eax
        incl %edx
        jmp t8b_loop
    t8b_end_loop:

    movl 16(%esp), %eax # rezultat
    movl %ecx, 0(%eax)

    ret
####### END FUNC

# getPositionInMatrix(line, column, totalColumns)
# matrix[line][column] = line*totalColumns + column
## stack:
## 0004 | line
## 0008 | column
## 0012 | totalColumns
getPositionInMatrix:
    xorl %edx, %edx
    movl 4(%esp), %eax
    mull 12(%esp)
    addl 8(%esp), %eax
    ret

.global main
main:
    ############## Citim input-ul de la tastatura ###########

    ## Citim dimensiunea matricei: linii, coloane

        # Citim liniile
        pushl $matrixLines
        pushl $inputStream
        call scanf
        addl $8, %esp
        # Citim coloanele
        pushl $matrixColumns
        pushl $inputStream
        call scanf
        addl $8, %esp
    
    xor %edx, %edx
    movl matrixLines, %eax
    mull matrixColumns
    movl %eax, dimensiuneTotala

    ###############
     # INFO: Matricea va fi bordata -> adaugam +2 la numarul total de linii & coloane
    
    movl matrixLines, %eax
    addl $2, %eax
    movl %eax, matrixLines
    movl matrixColumns, %eax
    addl $2, %eax
    movl %eax, matrixColumns

    ## Citim numarul de celule vii
        pushl $numberOfAliveCells
        pushl $inputStream
        call scanf
        addl $8, %esp
    ##############
    xor %ecx, %ecx
loop_read_alive_cells:
    cmp numberOfAliveCells, %ecx
    je exit_loop_read_alive_cells
    ## Citim coordonatele celulelor vii
        pusha
        ## Coordonata X -> linia
            pushl $currentLineIndex
            pushl $inputStream
            call scanf
            addl $8, %esp
        ## Coordonata Y -> coloana
            pushl $currentColumnIndex
            pushl $inputStream
            call scanf
            addl $8, %esp
        popa
        ## Le adaugam pe stiva si setam celula vie in matrice
        
        # Actualizam coordonatele astfel incat sa fie asezate conform bordarii (matricea extinsa)
            incl currentLineIndex
            incl currentColumnIndex
        ##

        lea matrix, %edi
        
        pushl matrixColumns
        pushl currentColumnIndex
        pushl currentLineIndex
        call getPositionInMatrix # rezultatul este in %eax
        addl $12, %esp

        movl $1, (%edi, %eax, 4)

        lea auxMatrix, %edi
        movl $1, (%edi, %eax, 4)

    ###############
    inc %ecx
    jmp loop_read_alive_cells
exit_loop_read_alive_cells:

    # Citim numarul k -> evolutiile
    pushl $numberOfEvolutions
    pushl $inputStream
    call scanf
    addl $8, %esp
    ##

    # Citim tipul cerintei (0/1)
    pushl $cerinta
    pushl $inputStream
    call scanf
    addl $8, %esp
    ##

    # Citim sirul de caractere
    pushl $sir
    pushl $inputString
    call scanf
    addl $8, %esp
    ##

    pushl $sir
    call strlen
    addl $4, %esp
    movl %eax, lungimeSir

    ### END INPUT READ ###

    pushl $initialConfigInfo
    call printf
    popl %eax

    pushl $matrix
    pushl matrixColumns
    pushl matrixLines
    call print_matrix
    addl $12, %esp

    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80
    
    movl $0, currentEvolution
    xor %ecx, %ecx
loop_evolutions:
    movl numberOfEvolutions, %eax
    cmp currentEvolution, %eax
    je end_loop_evolutions

    movl $1, currentLineIndex
    movl $1, currentColumnIndex

    # parcurg matricea
    evo_loop_lines:
        movl matrixLines, %eax
        dec %eax
        cmp currentLineIndex, %eax
        je end_evo_loop_lines

        # parcurg matricea
        evo_loop_columns:
            movl matrixColumns, %eax
            dec %eax
            cmp currentColumnIndex, %eax
            je end_evo_loop_columns
            
            lea matrix, %edi
            movl $0, sumaVecini
            
            # Vecinul (l-1, c)
            movl currentLineIndex, %eax
            dec %eax

            pushl matrixColumns
            pushl currentColumnIndex
            pushl %eax
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l-1, c+1)
            movl currentLineIndex, %eax
            dec %eax
            movl currentColumnIndex, %ebx
            inc %ebx
            
            pushl matrixColumns
            pushl %ebx
            pushl %eax
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l, c+1)
            movl currentColumnIndex, %eax
            inc %eax
            
            pushl matrixColumns
            pushl %eax
            pushl currentLineIndex
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l+1, c+1)
            movl currentLineIndex, %eax
            inc %eax
            movl currentColumnIndex, %ebx
            inc %ebx
            
            pushl matrixColumns
            pushl %ebx
            pushl %eax
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l+1, c)
            movl currentLineIndex, %eax
            inc %eax
            
            pushl matrixColumns
            pushl currentColumnIndex
            pushl %eax
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l+1, c-1)
            movl currentLineIndex, %eax
            inc %eax
            movl currentColumnIndex, %ebx
            dec %ebx

            pushl matrixColumns
            pushl %ebx
            pushl %eax
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l, c-1)
            movl currentColumnIndex, %eax
            dec %eax

            pushl matrixColumns
            pushl %eax
            pushl currentLineIndex
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            # Vecinul (l-1, c-1)
            movl currentLineIndex, %eax
            dec %eax
            movl currentColumnIndex, %ebx
            dec %ebx
            
            pushl matrixColumns
            pushl %ebx
            pushl %eax
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %eax
            addl %eax, sumaVecini
            ##

            pushl matrixColumns
            pushl currentColumnIndex
            pushl currentLineIndex
            call getPositionInMatrix # eax = matrix[currentLineIndex][currentColumnIndex]
            addl $12, %esp
            movl (%edi, %eax, 4), %ebx

            cmp $1, %ebx
            je criterii_celula_vie
            jmp criterii_celula_moarta

            criterii_celula_vie:
                movl sumaVecini, %ecx

                cmp $2, %ecx
                jl criteriu_subpopulare
                cmp $3, %ecx
                jg criteriu_ultrapopulare
                jmp exit_criterii

                criteriu_subpopulare:
                criteriu_ultrapopulare:
                    lea auxMatrix, %edi
                    movl $0, (%edi, %eax, 4)

                    jmp exit_criterii
            
            criterii_celula_moarta:
                movl sumaVecini, %ecx
                cmp $3, %ecx
                je criteriu_creare
                jmp exit_criterii

                criteriu_creare:
                    lea auxMatrix, %edi
                    movl $1, (%edi, %eax, 4)

                    jmp exit_criterii

            exit_criterii:

            incl currentColumnIndex
            jmp evo_loop_columns
        end_evo_loop_columns:

        movl $1, currentColumnIndex
        incl currentLineIndex
        jmp evo_loop_lines
    end_evo_loop_lines:

    movl $1, currentLineIndex
    movl $1, currentColumnIndex

    loop_lines_copy_matrix:
        movl matrixLines, %eax
        dec %eax
        cmp currentLineIndex, %eax
        je end_loop_lines_copy_matrix

        loop_cols_copy_matrix:
            movl matrixColumns, %eax
            dec %eax
            cmp currentColumnIndex, %eax
            je end_loop_cols_copy_matrix

            lea auxMatrix, %edi
            pushl matrixColumns
            pushl currentColumnIndex
            pushl currentLineIndex
            call getPositionInMatrix
            addl $12, %esp
            movl (%edi, %eax, 4), %ebx

            lea matrix, %edi
            movl %ebx, (%edi, %eax, 4)

            incl currentColumnIndex
            jmp loop_cols_copy_matrix
        end_loop_cols_copy_matrix:

        movl $1, currentColumnIndex
        incl currentLineIndex
        jmp loop_lines_copy_matrix
    end_loop_lines_copy_matrix:

    incl currentEvolution
    jmp loop_evolutions
end_loop_evolutions:
    xorl %edx, %edx
    movl matrixColumns, %eax
    mull matrixLines
    movl %eax, dimensiuneTotala # dimensiuneTotala = toate elemente din matrix inclusiv cele cu care a fost bordata

    pushl numberOfEvolutions
    pushl $afterEvolutionsInfo
    call printf
    addl $8, %esp

    pushl $matrix
    pushl matrixColumns
    pushl matrixLines
    call print_matrix
    addl $12, %esp

    movl cerinta, %eax
    cmp $0, %eax
    je cerinta_zero
    jmp cerinta_unu

########### Aici rezolv cerinta 0 => CRIPTARE
cerinta_zero:
    xorl %edx, %edx
    movl lungimeSir, %eax
    movl $8, %ebx
    mull %ebx
    movl %eax, lungimeBitiSir

    movl lungimeBitiSir, %eax
    subl %eax, dimensiuneTotala
    
    test %eax, %eax
    jns cerinta_zero_prep

# complete_matrix(lungime, &matrix_size, *matrix)
    pushl $matrix
    pushl $dimensiuneTotala
    pushl %eax
    call complete_matrix
    addl $12, %esp

cerinta_zero_prep:
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

    pushl $sir
    pushl $encryptionText
    call printf
    addl $8, %esp

    ## afisez pe ecran 0x
    pushl $hexaPrefix
    pushl $inputString
    call printf
    addl $8, %esp
    pushl $0
    call fflush
    popl %eax
    ##

    xorl %ecx, %ecx
rezolva_cerinta_zero:
    cmp lungimeSir, %ecx
    je exit_cerinta_zero

    xorl %edx, %edx
    movl $8, %eax
    mull %ecx

    movl $0, sumaVecini

    # take_8_bits(*puteri, *matrix, poz_start, &rezultat)
    pusha
        pushl $sumaVecini
        pushl %eax
        pushl $matrix
        pushl $puteri
        call take_8_bits
        addl $16, %esp
    popa

    xorl %eax, %eax
    lea sir, %edi
    movb (%edi, %ecx, 1), %al
    xorb sumaVecini, %al

    pusha
        pushl %eax
        pushl $outputHexadecimal
        call printf
        addl $8, %esp
        pushl $0
        call fflush
        popl %eax
    popa

    incl %ecx
    jmp rezolva_cerinta_zero
exit_cerinta_zero:
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

    jmp exit_program
#########################################


########### Aici rezolv cerinta 1 => DECRIPTARE

cerinta_unu:
    movl lungimeSir, %eax
    subl $2, %eax
    movl $4, %ebx
    mull %ebx
    movl %eax, lungimeBitiSir

    movl lungimeBitiSir, %eax
    subl %eax, dimensiuneTotala
    jns cerinta_zero_prep

    pushl $matrix
    pushl $dimensiuneTotala
    pushl %eax
    call complete_matrix
    addl $12, %esp

cerinta_unu_prep:
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

    pushl $sir
    pushl $decryptionText
    call printf
    addl $8, %esp

    movl $2, %ecx
    movl $0, numberOfEvolutions
rezolva_cerinta_unu:
    cmp lungimeSir, %ecx
    je exit_cerinta_unu

    xorl %eax, %eax
    xorl %edx, %edx
    movl $8, %eax
    movl numberOfEvolutions, %ebx
    mull %ebx

    movl $0, sumaVecini # sumaVecini va retine reprezentarea in baza 10 a celor 8 biti - nu mai declar alta variabila

    # take_8_bits(*puteri, *matrix, poz_start, &rezultat)
    pusha
        pushl $sumaVecini
        pushl %eax
        pushl $matrix
        pushl $puteri
        call take_8_bits
        addl $16, %esp
    popa

    xorl %eax, %eax

    lea sir, %edi
    movb (%edi, %ecx, 1), %al

    pushl %eax
    call convert
    addl $4, %esp
    shll $4, %eax

    movl %eax, %ebx

    incl %ecx
    movb (%edi, %ecx, 1), %al
    pushl %eax
    call convert
    addl $4, %esp

    or %ebx, %eax
    xor sumaVecini, %eax

    pusha
    pushl %eax
    pushl $outputChar
    call printf
    addl $8, %esp
    pushl $0
    call fflush
    addl $4, %esp
    popa

    incl numberOfEvolutions
    incl %ecx
    jmp rezolva_cerinta_unu
exit_cerinta_unu:

    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

exit_program:
    pushl $0
    call fflush
    popl %eax

    movl $1, %eax
    xor %ebx, %ebx
    int $0x80