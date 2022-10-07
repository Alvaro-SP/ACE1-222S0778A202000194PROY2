
;!                ░█▀▄▀█ ─█▀▀█ ░█▀▀█ ░█▀▀█ ░█▀▀▀█ ░█▀▀▀█
;!                ░█░█░█ ░█▄▄█ ░█─── ░█▄▄▀ ░█──░█ ─▀▀▀▄▄
;!                ░█──░█ ░█─░█ ░█▄▄█ ░█─░█ ░█▄▄▄█ ░█▄▄▄█
;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            ;! ▀▀▀▀▀▀▀▀▀▀  MENU  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀

PAINTTEXT MACRO MYMESSAGE , LOCATION,COLOR                            ;? ▬▬▬▬▬ IMPRIMIR
    LOCAL buc, BUCTEMP, sigo
    PUSHA
    MOV DX,LOCATION
    MOV SI, COLOR
    MOV AX,1301H
    mov cl, 1
    MOV di,0
    MOV BP, OFFSET MYMESSAGE
    MOV BX,BP
    buc:
        cmp MYMESSAGE[di+1], '$'
        JE sigo
        JNE BUCTEMP
        BUCTEMP:
            inc di
            inc cl
            JMP buc
    sigo:
    MOV CH,00H
    MOV BX,SI
    INT 10H
    CALL  PAINTTEXT_
    POPA
ENDM PAINTTEXT
misdatos MACRO                                                     ;? ▬▬▬▬▬ DATOS
    PUSHA
    CALL misdatos_
    POPA
ENDM misdatos
;*========================= VIDEO ===================================
esperatecla MACRO
    PUSHA
    CALL esperatecla_
    POPA
ENDM  esperatecla

paint	MACRO	CORNER1X, CORNER1Y, CORNER2X, CORNER2Y, COLOR ;? ▬▬▬▬▬ MENU DIBUJAR EN PANTALLA 
    PUSHA
    PUSH AX
    MOV AX, CORNER1X
    MOV X1, AX
    MOV AX, CORNER1Y
    MOV Y1, AX
    MOV AX, CORNER2X
    MOV X2, AX
    MOV AX, CORNER2Y
    MOV Y2, AX
    POP AX
    MOV AL, COLOR
    CALL paint_
    POPA
ENDM	paint
esperaenter MACRO                                                  ;? ▬▬▬▬▬ ENTER
    PUSHA
    mov ax, 00
    mov ah, 01h
    int 21h
    POPA
ENDM esperaenter

enterclick MACRO                                                  ;? ▬▬▬ ENTER
    PUSHA
    CALL enterclick_
    POPA
ENDM enterclick
menu MACRO                                                     ;? ▬▬▬▬▬ MENU
    PUSHA
    CALL menu_
    POPA
ENDM menu
;* ========================= CONSOLA ===================================
limpiar MACRO                                                     ;? ▬▬▬▬▬ LIMPIAR
    mov ah, 00h
    mov al, 03h
    int 10h
ENDM limpiar
readtext MACRO                                            ;? ▬▬▬▬▬ LEER DE CONSOLA
    PUSHA
    CALL readtext_
    POPA
ENDM readtext
print macro texto
    PUSHA
    mov ah, 09
    mov dx, offset texto
    int 21h
    POPA
ENDM print
;*  ----- convert an 'int' to 'string'-----
toString macro num,buffer
    PUSHA
    LOCAL divide,getD,clr
    xor si, si
    xor bx, bx
    xor cx, cx
    mov bl, 10
    mov ax, num
    jmp divide
    clr:
        xor ah,ah
    divide:
        div bl
        inc cx
        push ax
        cmp al, 0
        je getD
        jmp clr
    getD:
        pop ax
        add ah,48
        mov buffer[si],ah
        inc si
        loop getD
        mov ah, 24h
        mov buffer[si],ah
    POPA
endm
; POSICIONAR CURSOR
poscursor MACRO POSXTEMP, POSYTEMP
    ; PUSHA
    MOV AL, POSXTEMP
    MOV POSX, AL
    MOV AL, POSYTEMP
    MOV POSY, AL
    CALL poscursor_
    ; POPA
ENDM poscursor
printnum MACRO array, seek
    LOCAL Split, RepleaSplit, StringAnalizado, EndAnalisis, Minus,SIGO,ADDMINUS
    
    PUSH  SI
    PUSH  CX
    MOV   si, 0
    MOV   CX, 0
    MOV   BX, 0
    MOV   DX, 0
    MOV   bx, 0ah
    MOV   ax, seek
    
    CMP overflow, 00H
    JNE ADDMINUS
    JE sigo
    ADDMINUS:
        MOV overflow, 00H
        MOV   array[si], 2dh
        MOV numberF[SI], '-'
        INC   si
    SIGO:

    ; test  AX, 8000H
    ; jnz   Minus
        JMP   Split
    ; Minus:
    ;     neg   AX
    ;     MOV   array[si], 2dh
    ;     INC   si
    ;     JMP   Split
    RepleaSplit:                                                                 	;
        MOV   dx, 0
    Split:
        div   bx
        INC   CX
        PUSH  DX
        CMP   AX, 00h
        JE    StringAnalizado
        JMP   RepleaSplit
    StringAnalizado:
        POP   AX
        add   ax, 30h
        MOV   array[si], ax
        mov    al, BYTE PTR array[si]
        MOV numberF[SI], AL
        INC   si
        LOOP  StringAnalizado
        MOV   ax, 24h
        MOV   array[si], ax
        mov    al, BYTE PTR array[si]
        MOV numberF[SI], AL
    EndAnalisis:
        POP   CX
        POP   SI

ENDM printnum
;! ▀▀▀▀▀▀▀▀▀▀  REPORTES  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀
concatenarHTML macro destino, fuente
    LOCAL LeerCaracter,FinCadena
    PUSHA
    MOV si, SI_SIMULADO
    xor di, di
    LeerCaracter:
        mov al, fuente[di]
        cmp al, 36
            je FinCadena
        mov destino[si], al
        inc si
        inc di
        jmp LeerCaracter
    FinCadena:
        MOV SI_SIMULADO, si
    POPA
endm concatenarHTML

;! ▀▀▀▀▀▀▀▀▀▀  METODOS DE ORDENAMIENTO  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀
BUBBLESORT MACRO index
    PUSHA
    CALL BUBBLESORT_
    POPA
ENDM BUBBLESORT

delay MACRO fuera, dentro
    LOCAL uno,dos,tres
    PUSHA
    MOV SI, fuera
    dos:
        DEC SI
        JZ tres
        MOV DI, dentro
    uno:
        DEC DI
        JNZ uno
        JMP dos
    tres:
    POPA
ENDM delay

DRAW_RECTANGLE	MACRO	CORNER1X, CORNER1Y, CORNER2X, CORNER2Y, COLOR
	PUSHA
	PUSH AX
	MOV AX, CORNER1X
	MOV X1, AX
	MOV AX, CORNER1Y
	MOV Y1, AX
	MOV AX, CORNER2X
	MOV X2, AX
	MOV AX, CORNER2Y
	MOV Y2, AX
	POP AX
	MOV AL, COLOR
	CALL DRAW_RECTANGLE_
	POPA
ENDM	DRAW_RECTANGLE

PINTARPANTALLADEJUEGO MACRO
    PUSHA
    CALL PINTARPANTALLADEJUEGO_
    POPA
ENDM PINTARPANTALLADEJUEGO
PINTARCUADRO MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTARCUADRO_
    POPA
ENDM PINTARCUADRO
PINTARPALITO MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTARPALITO_
    POPA
ENDM PINTARPALITO
PINTARTE MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTARTE_
    POPA
ENDM PINTARTE
PINTAR1ELE MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTAR1ELE_
    POPA
ENDM PINTAR1ELE
PINTAR2ELE MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTAR2ELE_
    POPA
ENDM PINTAR2ELE
PINTAR1ZETA MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTAR1ZETA_
    POPA
ENDM PINTAR1ZETA
PINTAR2ZETA MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTAR2ZETA_
    POPA
ENDM PINTAR2ZETA
PAINTSQUARE MACRO X,Y, col
    PUSHA
    MOV AX, X
    MOV Xtempauxaux,AX
    MOV AX, Y
    MOV Ytempauxaux, AX
    MOV AL, col
    MOV coloraux, AL
    CALL PAINTSQUARE_
    POPA
ENDM PAINTSQUARE
setAREADEJUEGO MACRO X,y
    PUSHA
    MOV AX, X
    MOV setPOSX,AXamueblado de sala
    MOV AX, Y
    MOV setPOSY, AX
    CALL setAREADEJUEGO_
    POPA
ENDM setAREADEJUEGO

;*========================= CREDENTIALS AND LOGIN ===================================
printdolar MACRO 
    PUSHA
    MOV AH, 09H
    mov al, "$"
    int 10h
    POPA
ENDM printdolar
capturateclaf MACRO
    PUSHA
    mov ah, 00h
    int 16h
    MOV keypress, AH
    POPA
ENDM capturateclaf
MENUPRINCIPAL MACRO
    PUSHA
    CALL MENUPRINCIPAL_
    POPA
ENDM MENUPRINCIPAL
getLen macro var ; OBTENER LONGITUD DE UN BYTE :V
    LOCAL wh, fin
    xor si,si
    wh:
        cmp var[si],24h
        je fin
        inc si
        jmp wh
    fin:
endm getLen

getStr macro array
    LOCAL getcad, endcad
    PUSHA
    xor si,si
    getcad:
        mov ah, 01h
        int 21h
        cmp al,0dh
        je endcad
        mov array[si],al
        inc si
        jmp getcad
    endcad:
    mov al,24h
    mov array[si],al
    POPA
endm
printdolar MACRO
    mov AH, 02H
    mov DL , '$'
    INT 21H
ENDM
getStrPASS macro array
    LOCAL getcad, endcad
    PUSHA
    xor si,si
    getcad:
        mov ah, 01h
        int 21h
        ; poscursor x,Y
        ; printdolar

        cmp al,0dh
        je endcad
        mov array[si],al
        inc si
        jmp getcad
    endcad:
    mov al,24h
    mov array[si],al
    POPA
endm

;! MACRO PARA COMPARAR 2 STRINGS
isequal macro STRING1, STRING2, length
LOCAL whi, fin, continue, neq, equal
    xor di, di
    xor bx, bx
    xor dx, dx
    whi:
        cmp di, length
        je equal
        mov bh, STRING1[di]
        mov bl, STRING2[di]
        cmp bh, bl
        je continue
        jmp neq
        continue:
            inc di
            jmp whi
    neq:
        mov dx, 0
        jmp fin
    equal:
        mov dx, 1

    fin:
endm isequal
ESNUMERO macro CHARNUM ; ! PA SABER SI ES NUMNERO GUARDO DX
    LOCAL SALIR,NOESNUMERO,ESUNNUMERO
    cmp CHARNUM, 48
    JE ESUNNUMERO
    cmp CHARNUM, 49
    JE ESUNNUMERO
    cmp CHARNUM, 50
    JE ESUNNUMERO
    cmp CHARNUM, 51
    JE ESUNNUMERO
    cmp CHARNUM, 52
    JE ESUNNUMERO
    cmp CHARNUM, 53
    JE ESUNNUMERO
    cmp CHARNUM, 54
    JE ESUNNUMERO
    cmp CHARNUM, 55
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 57
    JNE NOESNUMERO
    JE ESUNNUMERO
    ESUNNUMERO:
        MOV dx, 1
        JMP SALIR
    NOESNUMERO:
        MOV dx, 0
        JMP SALIR
    SALIR:
    RET
ENDM ESNUMERO

ESCHARPERMITIDO macro CHARNUM ; ! PA SABER SI ES NUMNERO GUARDO DX
    LOCAL SALIR,NOESNUMERO,ESUNNUMERO
    cmp CHARNUM, 48
    JE ESUNNUMERO
    cmp CHARNUM, 49
    JE ESUNNUMERO
    cmp CHARNUM, 50
    JE ESUNNUMERO
    cmp CHARNUM, 51
    JE ESUNNUMERO
    cmp CHARNUM, 52
    JE ESUNNUMERO
    cmp CHARNUM, 53
    JE ESUNNUMERO
    cmp CHARNUM, 54
    JE ESUNNUMERO
    cmp CHARNUM, 55
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO

    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 65
    JE ESUNNUMERO
    cmp CHARNUM, 66
    JE ESUNNUMERO
    cmp CHARNUM, 67
    JE ESUNNUMERO
    cmp CHARNUM, 68
    JE ESUNNUMERO
    cmp CHARNUM, 69
    JE ESUNNUMERO
    cmp CHARNUM, 70
    JE ESUNNUMERO
    cmp CHARNUM, 71
    JE ESUNNUMERO
    cmp CHARNUM, 72
    JE ESUNNUMERO
    cmp CHARNUM, 73
    JE ESUNNUMERO
    cmp CHARNUM, 74
    JE ESUNNUMERO
    cmp CHARNUM, 75
    JE ESUNNUMERO
    cmp CHARNUM, 76
    JE ESUNNUMERO
    cmp CHARNUM, 77
    JE ESUNNUMERO
    cmp CHARNUM, 78
    JE ESUNNUMERO
    cmp CHARNUM, 79
    JE ESUNNUMERO
    cmp CHARNUM, 80
    JE ESUNNUMERO
    cmp CHARNUM, 81
    JE ESUNNUMERO
    cmp CHARNUM, 82
    JE ESUNNUMERO
    cmp CHARNUM, 83
    JE ESUNNUMERO
    cmp CHARNUM, 84
    JE ESUNNUMERO
    cmp CHARNUM, 85
    JE ESUNNUMERO
    cmp CHARNUM, 86
    JE ESUNNUMERO
    cmp CHARNUM, 87
    JE ESUNNUMERO
    cmp CHARNUM, 88
    JE ESUNNUMERO
    cmp CHARNUM, 89
    JE ESUNNUMERO
    cmp CHARNUM, 90
    JE ESUNNUMERO

    cmp CHARNUM, 97
    JE ESUNNUMERO
    cmp CHARNUM, 98
    JE ESUNNUMERO
    cmp CHARNUM, 99
    JE ESUNNUMERO
    cmp CHARNUM, 100
    JE ESUNNUMERO
    cmp CHARNUM, 101
    JE ESUNNUMERO
    cmp CHARNUM, 102
    JE ESUNNUMERO
    cmp CHARNUM, 103
    JE ESUNNUMERO
    cmp CHARNUM, 104
    JE ESUNNUMERO
    cmp CHARNUM, 105
    JE ESUNNUMERO
    cmp CHARNUM, 106
    JE ESUNNUMERO
    cmp CHARNUM, 107
    JE ESUNNUMERO
    cmp CHARNUM, 108
    JE ESUNNUMERO
    cmp CHARNUM, 109
    JE ESUNNUMERO
    cmp CHARNUM, 110
    JE ESUNNUMERO
    cmp CHARNUM, 111
    JE ESUNNUMERO
    cmp CHARNUM, 112
    JE ESUNNUMERO
    cmp CHARNUM, 113
    JE ESUNNUMERO
    cmp CHARNUM, 114
    JE ESUNNUMERO
    cmp CHARNUM, 115
    JE ESUNNUMERO
    cmp CHARNUM, 116
    JE ESUNNUMERO
    cmp CHARNUM, 117
    JE ESUNNUMERO
    cmp CHARNUM, 118
    JE ESUNNUMERO
    cmp CHARNUM, 119
    JE ESUNNUMERO
    cmp CHARNUM, 120
    JE ESUNNUMERO
    cmp CHARNUM, 121
    JE ESUNNUMERO
    cmp CHARNUM, 122

    JE ESUNNUMERO
    cmp CHARNUM, 45
    JE ESUNNUMERO
    cmp CHARNUM, 95
    JE ESUNNUMERO
    cmp CHARNUM, 46
    JE ESUNNUMERO

    cmp CHARNUM, 57
    JNE NOESNUMERO
    JE ESUNNUMERO
    ESUNNUMERO:
        MOV dx, 1
        JMP SALIR
    NOESNUMERO:
        MOV dx, 0
        JMP SALIR
    SALIR:
    RET
ENDM ESCHARPERMITIDO

ESMAYUS macro CHARNUM ; ! PA SABER SI ES MAYUSCULA
    LOCAL SALIR,NOESNUMERO,ESUNNUMERO
    cmp CHARNUM, 65
    JE ESUNNUMERO
    cmp CHARNUM, 66
    JE ESUNNUMERO
    cmp CHARNUM, 67
    JE ESUNNUMERO
    cmp CHARNUM, 68
    JE ESUNNUMERO
    cmp CHARNUM, 69
    JE ESUNNUMERO
    cmp CHARNUM, 70
    JE ESUNNUMERO
    cmp CHARNUM, 71
    JE ESUNNUMERO
    cmp CHARNUM, 72
    JE ESUNNUMERO
    cmp CHARNUM, 73
    JE ESUNNUMERO
    cmp CHARNUM, 74
    JE ESUNNUMERO
    cmp CHARNUM, 75
    JE ESUNNUMERO
    cmp CHARNUM, 76
    JE ESUNNUMERO
    cmp CHARNUM, 77
    JE ESUNNUMERO
    cmp CHARNUM, 78
    JE ESUNNUMERO
    cmp CHARNUM, 79
    JE ESUNNUMERO
    cmp CHARNUM, 80
    JE ESUNNUMERO
    cmp CHARNUM, 81
    JE ESUNNUMERO
    cmp CHARNUM, 82
    JE ESUNNUMERO
    cmp CHARNUM, 83
    JE ESUNNUMERO
    cmp CHARNUM, 84
    JE ESUNNUMERO
    cmp CHARNUM, 85
    JE ESUNNUMERO
    cmp CHARNUM, 86
    JE ESUNNUMERO
    cmp CHARNUM, 87
    JE ESUNNUMERO
    cmp CHARNUM, 88
    JE ESUNNUMERO
    cmp CHARNUM, 89
    JE ESUNNUMERO
    cmp CHARNUM, 90
    JNE NOESNUMERO
    JE ESUNNUMERO
    ESUNNUMERO:
        INC TEMP
        JMP SALIR
    NOESNUMERO:
        JMP SALIR
    SALIR:
    RET
ENDM
ESNUMERO macro CHARNUM ; ! PA SABER SI ES NUMERO
    LOCAL SALIR,NOESNUMERO,ESUNNUMERO
    cmp CHARNUM, 48
    JE ESUNNUMERO
    cmp CHARNUM, 49
    JE ESUNNUMERO
    cmp CHARNUM, 50
    JE ESUNNUMERO
    cmp CHARNUM, 51
    JE ESUNNUMERO
    cmp CHARNUM, 52
    JE ESUNNUMERO
    cmp CHARNUM, 53
    JE ESUNNUMERO
    cmp CHARNUM, 54
    JE ESUNNUMERO
    cmp CHARNUM, 55
    JE ESUNNUMERO
    cmp CHARNUM, 56
    JE ESUNNUMERO
    cmp CHARNUM, 57
    JNE NOESNUMERO
    JE ESUNNUMERO
    ESUNNUMERO:
        INC TEMP
        JMP SALIR
    NOESNUMERO:
        JMP SALIR
    SALIR:
    RET
ENDM
ESESPECIAL macro CHARNUM ; ! PA SABER SI ES ESPECIAL
    LOCAL SALIR,NOESNUMERO,ESUNNUMERO
    cmp CHARNUM, 64
    JE ESUNNUMERO
    cmp CHARNUM, 62
    JE ESUNNUMERO
    cmp CHARNUM, 35
    JE ESUNNUMERO
    cmp CHARNUM, 43
    JE ESUNNUMERO
    cmp CHARNUM, 42
    JNE NOESNUMERO
    JE ESUNNUMERO
    ESUNNUMERO:
        INC TEMP
        JMP SALIR
    NOESNUMERO:
        JMP SALIR
    SALIR:
ENDM
CONTARMAYUSCULAS macro
    LOCAL buc, sigo, buct,MAYUS,SALIR
    MOV TEMP,0
    buc:
        ESMAYUS MYuserPass[di]
        CMP MYuserPass[di+1], "$"
        JE sigo
        buct:
            inc di
            JMP buc
    sigo:
        CMP TEMP, 3
        JL MAYUS ;SI TIENE MENOS DE 3 MAYUSCULAS
        JMP SALIR
    MAYUS:
        MOV dx, 1
    SALIR:
ENDM
CONTARNUMEROS macro
    LOCAL buc, sigo, buct,MAYUS,SALIR
    MOV TEMP,0
    buc:
        ESNUMERO MYuserPass[di]
        CMP MYuserPass[di+1], "$"
        JE sigo
        buct:
            inc di
            JMP buc
    sigo:
        CMP TEMP, 2
        JL MAYUS ;SI TIENE MENOS DE 3 MAYUSCULAS
        JMP SALIR
    MAYUS:
        MOV dx, 1
    SALIR:
ENDM
CONTARESPECIALES macro
    LOCAL buc, sigo, buct,MAYUS,SALIR
    MOV TEMP,0
    buc:
        ESESPECIAL MYuserPass[di]
        CMP MYuserPass[di+1], "$"
        JE sigo
        buct:
            inc di
            JMP buc
    sigo:
        CMP TEMP, 2
        JL MAYUS ;SI TIENE MENOS DE 3 MAYUSCULAS
        JMP SALIR
    MAYUS:
        MOV dx, 1
    SALIR:
ENDM


