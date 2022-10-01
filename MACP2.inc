
;!                ░█▀▄▀█ ─█▀▀█ ░█▀▀█ ░█▀▀█ ░█▀▀▀█ ░█▀▀▀█
;!                ░█░█░█ ░█▄▄█ ░█─── ░█▄▄▀ ░█──░█ ─▀▀▀▄▄
;!                ░█──░█ ░█─░█ ░█▄▄█ ░█─░█ ░█▄▄▄█ ░█▄▄▄█
;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            ;! ▀▀▀▀▀▀▀▀▀▀  MENU  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀

PAINTTEXT MACRO MYMESSAGE , LOCATION,COLOR                            ;? ▬▬▬▬▬ IMPRIMIR
    PUSHA
    MOV DX,LOCATION
    MOV BP, OFFSET MYMESSAGE
    MOV SI, COLOR
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