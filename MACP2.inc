
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
    LOCAL divide,getD,clr
    PUSHA
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
TOP10GENERAL MACRO index
    PUSHA
    CALL TOP10GENERAL_
    POPA
ENDM TOP10GENERAL
TOP10USUARIO MACRO index
    PUSHA
    CALL TOP10USUARIO_
    POPA
ENDM TOP10USUARIO
;! ▀▀▀▀▀▀▀▀▀▀  METODOS DE ORDENAMIENTO  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀
BUBBLESORT MACRO index
    PUSHA
    CALL BUBBLESORT_
    POPA
ENDM BUBBLESORT
HEAPSORT MACRO index
    PUSHA
    CALL HEAPSORT_
    POPA
ENDM HEAPSORT
QUICKSORT MACRO index
    PUSHA
    CALL QUICKSORT_
    POPA
ENDM QUICKSORT

;! ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;! ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  EL JUEGO  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
INICIODELJUEGO MACRO
    PUSHA
    CALL INICIODELJUEGO_
    POPA
ENDM
delay MACRO fuera
    LOCAL uno,dos,tres
    PUSHA
    MOV SI, fuera
    dos:
        DEC SI
        JZ tres
        MOV DI, fuera
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
JMPPRINCIPALMENULABEL MACRO
    JMP PRINCIPALMENULABEL
ENDM JMPPRINCIPALMENULABEL
PINTARCUADRO MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL PINTARCUADRO_
    POPA
ENDM PINTARCUADRO
PAINTPOS MACRO X,Y, col
    PUSHA
    MOV AX, X
    MOV BX, 20
    MUL BX
    ADD AX, 486
    MOV Xtempauxaux,AX
    MOV AX, Y
    MOV BX, 20
    MUL BX
    ADD AX, 162
    MOV Ytempauxaux, AX
    MOV AL, col
    MOV coloraux, AL
    CALL PAINTSQUARE_
    POPA
ENDM PAINTPOS
PINTARUNIT MACRO X,Y, col   ;! PINTAR CIERTA POSICION VIDEO
    CMP col, 0
    JE PL8
    CMP col, 1
    JE PL1
    CMP col, 2
    JE PL2
    CMP col, 3
    JE PL3
    CMP col, 4
    JE PL4
    CMP col, 5
    JE PL5
    CMP col, 6
    JE PL6
    CMP col, 7
    JNE PL88
    JE PL7
    PL8:
        PAINTPOS X,Y, WHITE
        JMP SALIDA
    PL1:
        PAINTPOS X,Y, LIGHT_GREEN
        JMP SALIDA
    PL2:
        PAINTPOS X,Y, LIGHT_CYAN
        JMP SALIDA
    PL3:
        PAINTPOS X,Y, LIGHT_RED
        JMP SALIDA
    PL4:
        PAINTPOS X,Y, MAGENTA
        JMP SALIDA
    PL5:
        PAINTPOS X,Y, YELLOW
        JMP SALIDA
    PL6:
        PAINTPOS X,Y, LIGHT_GRAY
        JMP SALIDA
    PL7:
        PAINTPOS X,Y, BROWN
        JMP SALIDA
    PL88:
        PAINTPOS X,Y, BLUE
    SALIDA:
ENDM
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
setAREADEJUEGO MACRO X,y, col
    PUSHA
    MOV AX, X
    MOV setPOSX,AX
    MOV AX, Y
    MOV setPOSY, AX
    MOV AX, col
    MOV POSTOSET, AX
    CALL setAREADEJUEGO_
    POPA
ENDM setAREADEJUEGO
getAREADEJUEGO MACRO X,y
    PUSHA
    MOV AX, X
    MOV setPOSX,AX
    MOV AX, Y
    MOV setPOSY, AX
    CALL getAREADEJUEGO_
    POPA
ENDM getAREADEJUEGO
UPDATECUADRO MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATECUADRO_
    POPA
ENDM
UPDATETE MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATETE_
    POPA
ENDM
UPDAPALITO MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDAPALITO_
    POPA
ENDM
UPDATEELE1 MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATEELE1_
    POPA
ENDM
UPDATEELE2 MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATEELE2_
    POPA
ENDM
UPDATEZETA1 MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATEZETA1_
    POPA
ENDM
UPDATEZETA2 MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATEZETA2_
    POPA
ENDM
UPDATEESPECIAL MACRO X,Y
    PUSHA
    MOV AX, X
    MOV Xtemp,AX
    MOV AX, Y
    MOV Ytemp, AX
    CALL UPDATEESPECIAL_
    POPA
ENDM
LIMPIARFRAMEANTERIOR MACRO
    setAREADEJUEGO auxpX1,auxpY1,0 ;* LIMPIO ANTERIOR
    setAREADEJUEGO auxpX2,auxpY2,0
    setAREADEJUEGO auxpX3,auxpY3,0
    setAREADEJUEGO auxpX4,auxpY4,0
    PAINTPOS auxpX1,auxpY1,BLUE ;* LIMPIO ANTERIOR
    PAINTPOS auxpX2,auxpY2,BLUE
    PAINTPOS auxpX3,auxpY3,BLUE
    PAINTPOS auxpX4,auxpY4,BLUE
ENDM
LIMPIARFRAMEANTERIORESPECIAL MACRO
    LOCAL SAJJ, SALIR

    getAREADEJUEGO Xtemp,Ytemp
    CMP TEMP, 0
    JE SAJJ
    JMP SALIR
    SAJJ:
        setAREADEJUEGO auxpX1,auxpY1,0 ;* LIMPIO ANTERIOR
        PAINTPOS auxpX1,auxpY1,BLUE ;* LIMPIO ANTERIOR
    SALIR:
ENDM
RESETAUXSBLOQUES MACRO
    MOV auxpX1,0
    MOV auxpX2,0
    MOV auxpX3,0
    MOV auxpX4,0
    MOV auxpY1,0
    MOV auxpY2,0
    MOV auxpY3,0
    MOV auxpY4,0
ENDM
RANDOMPOSITION MACRO
    LOCAL CERO, UNO, DOS, TRES, CUATRO, CINCO,SEIS, SIETE,UNOA, DOSA, TRESA, CUATROA, CINCOA,SEISA, SIETEA, SALIR
    PUSHA
    MOV AH, 00h  ; interrupcion para jalar el tiempo en el sistema
    INT 1AH      ; CX:DX  toma numeros del reloj desde medianoche
    mov  ax, dx         ;! RANDOM
    xor  dx, dx
    mov  cx, 5
    div  cx       ;DX tiene la divicion en mi caso - de 0 a 5
    add  dl, '0'  ; DL TIENE EL VALOR ENTRE 0 Y 5
    CMP DL, '0'
    JE CERO
    JNE UNO
    CERO:
        MOV POSXHANDLE, 0
        JMP SALIR
    UNO:
    CMP DL, '1'
    JE UNOA
    JNE DOS
    UNOA:
        MOV POSXHANDLE, 1
        JMP SALIR
    DOS:
    CMP DL, '2'
    JE DOSA
    JNE TRES
    DOSA:
        MOV POSXHANDLE, 2
        JMP SALIR
    TRES:
    CMP DL, '3'
    JE TRESA
    JNE CUATRO
    TRESA:
        MOV POSXHANDLE, 3
        JMP SALIR
    CUATRO:
    CMP DL, '4'
    JE CUATROA
    JNE CINCO
    CUATROA:
        MOV POSXHANDLE, 4
        JMP SALIR
    CINCO:
        MOV POSXHANDLE, 5
        JMP SALIR
    SALIR:
    POPA
ENDM
RANDOMPIECE MACRO
    LOCAL CERO, UNO, DOS, TRES, CUATRO, CINCO,SEIS, SIETE,UNOA, DOSA, TRESA, CUATROA, CINCOA,SEISA, SIETEA, SALIR
    PUSHA
    MOV AH, 00h  ; interrupcion para jalar el tiempo en el sistema
    INT 1AH      ; CX:DX  toma numeros del reloj desde medianoche
    mov  ax, dx         ;! RANDOM
    xor  dx, dx
    mov  cx, 7
    div  cx       ;DX tiene la divicion en mi caso - de 0 a 5
    add  dl, '0'  ; DL TIENE EL VALOR ENTRE 0 Y 5
    CMP DL, '0'
    JE CERO
    JNE UNO
    CERO:
        MOV TEMP, 0
        JMP SALIR
    UNO:
    CMP DL, '1'
    JNE DOS
    JE UNOA
    UNOA:
        MOV TEMP, 1
        JMP SALIR
    DOS:
    CMP DL, '2'
    JNE TRES
    JE DOSA
    DOSA:
        MOV TEMP, 2
        JMP SALIR
    TRES:
    CMP DL, '3'
    JNE CUATRO
    JE TRESA
    TRESA:
        MOV TEMP, 3
        JMP SALIR
    CUATRO:
    CMP DL, '4'
    JNE CINCO
    JE CUATROA
    CUATROA:
        MOV TEMP, 4
        JMP SALIR
    CINCO:
    CMP DL, '5'
    JNE SEIS
    JE CINCOA
    CINCOA:
        MOV TEMP, 5
        JMP SALIR
    SEIS:
    CMP DL, '6'
    JNE SIETE
    JE SEISA
    SEISA:
        MOV TEMP, 6
        JMP SALIR
    SIETE:
    CMP DL, '7'
    JE SIETEA
    SIETEA:
        MOV TEMP, 7
        JMP SALIR
    SALIR:
    POPA
ENDM
UPDATEPIEZA MACRO
    LOCAL GENP0,GENP1,GENP2,GENP3,GENP4,GENP5,GENP6,GENP7,SALIDA
    CMP TIPODEPIEZA, 0
    JE GENP0
    CMP TIPODEPIEZA, 1
    JE GENP1
    CMP TIPODEPIEZA, 2
    JE GENP2
    CMP TIPODEPIEZA, 3
    JE GENP3
    CMP TIPODEPIEZA, 4
    JE GENP4
    CMP TIPODEPIEZA, 5
    JE GENP5
    CMP TIPODEPIEZA, 6
    JE GENP6
    CMP TIPODEPIEZA, 7
    JE GENP7
    GENP0:
        UPDATEESPECIAL POSXHANDLE, DI
        JMP SALIDA
    GENP1:
        UPDAPALITO POSXHANDLE, DI
        JMP SALIDA
    GENP2:
        UPDATECUADRO POSXHANDLE, DI
        JMP SALIDA
    GENP3:
        UPDATETE POSXHANDLE, DI
        JMP SALIDA
    GENP4:
        UPDATEELE1 POSXHANDLE, DI
        JMP SALIDA
    GENP5:
        UPDATEELE2 POSXHANDLE, DI
        JMP SALIDA
    GENP6:
        UPDATEZETA1 POSXHANDLE, DI
        JMP SALIDA
    GENP7:
        UPDATEZETA2 POSXHANDLE, DI
        JMP SALIDA
    SALIDA:
ENDM

ELIMINARFILAS MACRO
    PUSHA
    CALL ELIMINARFILAS_
    POPA
ENDM
VALIDARFILALLENA MACRO POS
    PUSHA
    MOV SI, POS
    MOV TEMP3, SI
    CALL VALIDARFILALLENA_
    POPA
ENDM
CORRERFILA MACRO
    PUSHA
    CALL CORRERFILA_
    POPA
ENDM
LEFTRIGHT_DEDOS MACRO auxpX1env,auxpX2env,auxpX1env2,auxpX2env2,auxpX1envA,auxpX2envA,auxpX1env2A,auxpX2env2A
    LOCAL movleftlb,VALIDARMOVERRIGHT,SIMOVRIGHT1,SIMOVRIGHT,sigoscan,VALIDARMOVERLEFT,SIMOVLEFT1,SIMOVLEFT

    ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ VALIDAR LEFT RIGHT ▬▬▬▬▬▬▬▬▬▬▬▬
    CMP FLAGMOVERIGHT,1;! PRESIONO DERECHA
    JNE movleftlb
    JE VALIDARMOVERRIGHT
    VALIDARMOVERRIGHT:
        MOV FLAGMOVERIGHT,0
        mov CX, auxpX1env
        MOV TEMP2, CX
        INC TEMP2
        getAREADEJUEGO TEMP2, auxpX2env
        CMP TEMP, 0
        JE SIMOVRIGHT1
        JNE sigoscan
        SIMOVRIGHT1:
            mov CX, auxpX1env2
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpX2env2
            CMP TEMP, 0
            JE SIMOVRIGHT
            JNE sigoscan
        SIMOVRIGHT:
            INC Xtemp
            INC POSXHANDLE
            jmp sigoscan

    movleftlb:      ; ! PRESIONO IZQUIERDA
        CMP FLAGMOVELEFT,1
        JNE sigoscan
        JE VALIDARMOVERLEFT
        VALIDARMOVERLEFT:
            MOV FLAGMOVELEFT,0
            mov CX, auxpX1envA
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpX2envA
            CMP TEMP, 0
            JE SIMOVLEFT1
            JNE sigoscan
            SIMOVLEFT1:
                mov CX, auxpX1env2A
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpX2env2A
                CMP TEMP, 0
                JE SIMOVLEFT
                JNE sigoscan
            SIMOVLEFT:
                DEC Xtemp
                DEC POSXHANDLE
                jmp sigoscan
        ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
    
    sigoscan:
ENDM
LEFTRIGHT_DECUATRO MACRO auxpX1env,auxpX2env,auxpX1env2,auxpX2env2,auxpX1env3,auxpX2env3,auxpX1env4,auxpX2env4
    LOCAL SIMOVRIGHT0,SIMOVLEFT0, movleftlb,VALIDARMOVERRIGHT,SIMOVRIGHT1,SIMOVRIGHT,sigoscan,VALIDARMOVERLEFT,SIMOVLEFT1,SIMOVLEFT,SIMOVLEFTM1,SIMOVRIGHTM1

    ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ VALIDAR LEFT RIGHT ▬▬▬▬▬▬▬▬▬▬▬▬
    CMP FLAGMOVERIGHT,1;! PRESIONO DERECHA
    JNE movleftlb
    JE VALIDARMOVERRIGHT
    VALIDARMOVERRIGHT:
        MOV FLAGMOVERIGHT,0
        mov CX, auxpX1env
        MOV TEMP2, CX
        INC TEMP2
        getAREADEJUEGO TEMP2, auxpX2env
        CMP TEMP, 0
        JE SIMOVRIGHT1
        JNE sigoscan
        SIMOVRIGHT1:
            mov CX, auxpX1env2
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpX2env2
            CMP TEMP, 0
            JE SIMOVRIGHT0
            JNE sigoscan
            SIMOVRIGHT0:
                mov CX, auxpX1env3
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpX2env3
                CMP TEMP, 0
                JE SIMOVRIGHTM1
                JNE sigoscan
                SIMOVRIGHTM1:
                    mov CX, auxpX1env4
                    MOV TEMP2, CX
                    INC TEMP2
                    getAREADEJUEGO TEMP2, auxpX2env4
                    CMP TEMP, 0
                    JE SIMOVRIGHT
                    JNE sigoscan
        SIMOVRIGHT:
            INC Xtemp
            INC POSXHANDLE
            jmp sigoscan

    movleftlb:      ; ! PRESIONO IZQUIERDA
        CMP FLAGMOVELEFT,1
        JNE sigoscan
        JE VALIDARMOVERLEFT
        VALIDARMOVERLEFT:
            MOV FLAGMOVELEFT,0
            mov CX, auxpX1env
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpX2env
            CMP TEMP, 0
            JE SIMOVLEFT1
            JNE sigoscan
            SIMOVLEFT1:
                mov CX, auxpX1env2
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpX2env2
                CMP TEMP, 0
                JE SIMOVLEFT0
                JNE sigoscan
                SIMOVLEFT0:
                    mov CX, auxpX1env3
                    MOV TEMP2, CX
                    INC TEMP2
                    getAREADEJUEGO TEMP2, auxpX2env3
                    CMP TEMP, 0
                    JE SIMOVLEFTM1
                    JNE sigoscan
                    SIMOVLEFTM1:
                        mov CX, auxpX1env4
                        MOV TEMP2, CX
                        INC TEMP2
                        getAREADEJUEGO TEMP2, auxpX2env4
                        CMP TEMP, 0
                        JE SIMOVLEFT
                        JNE sigoscan
            SIMOVLEFT:
                DEC Xtemp
                DEC POSXHANDLE
                jmp sigoscan
        ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
    
    sigoscan:
ENDM
LEFTRIGHT_DETRES MACRO auxpX1env,auxpX2env,auxpX1env2,auxpX2env2,auxpX1env3,auxpX2env3,auxpX1envA,auxpX2envA,auxpX1env2A,auxpX2env2A,auxpX1env3A,auxpX2env3A
    LOCAL SIMOVRIGHT0,SIMOVLEFT0, movleftlb,VALIDARMOVERRIGHT,SIMOVRIGHT1,SIMOVRIGHT,sigoscan,VALIDARMOVERLEFT,SIMOVLEFT1,SIMOVLEFT

    ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ VALIDAR LEFT RIGHT ▬▬▬▬▬▬▬▬▬▬▬▬
    CMP FLAGMOVERIGHT,1;! PRESIONO DERECHA
    JNE movleftlb
    JE VALIDARMOVERRIGHT
    VALIDARMOVERRIGHT:
        MOV FLAGMOVERIGHT,0
        mov CX, auxpX1env
        MOV TEMP2, CX
        INC TEMP2
        getAREADEJUEGO TEMP2, auxpX2env
        CMP TEMP, 0
        JE SIMOVRIGHT1
        JNE sigoscan
        SIMOVRIGHT1:
            mov CX, auxpX1env2
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpX2env2
            CMP TEMP, 0
            JE SIMOVRIGHT0
            JNE sigoscan
            SIMOVRIGHT0:
                mov CX, auxpX1env3
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpX2env3
                CMP TEMP, 0
                JE SIMOVRIGHT
                JNE sigoscan
        SIMOVRIGHT:
            INC Xtemp
            INC POSXHANDLE
            jmp sigoscan

    movleftlb:      ; ! PRESIONO IZQUIERDA
        CMP FLAGMOVELEFT,1
        JNE sigoscan
        JE VALIDARMOVERLEFT
        VALIDARMOVERLEFT:
            MOV FLAGMOVELEFT,0
            mov CX, auxpX1envA
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpX2envA
            CMP TEMP, 0
            JE SIMOVLEFT1
            JNE sigoscan
            SIMOVLEFT1:
                mov CX, auxpX1env2A
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpX2env2A
                CMP TEMP, 0
                JE SIMOVLEFT0
                JNE sigoscan
                SIMOVLEFT0:
                    mov CX, auxpX1env3A
                    MOV TEMP2, CX
                    INC TEMP2
                    getAREADEJUEGO TEMP2, auxpX2env3A
                    CMP TEMP, 0
                    JE SIMOVLEFT
                    JNE sigoscan
            SIMOVLEFT:
                DEC Xtemp
                DEC POSXHANDLE
                jmp sigoscan
        ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
    sigoscan:
ENDM

POSX_IS MACRO tope
    LOCAL T1, T2, SALIDA
    PUSHA
    MOV DI, tope
    CMP POSXHANDLE, DI ;llega al tope TEMP2==1
    JE T1
    MOV TEMP2, 0
    JMP SALIDA
    T1:
        MOV TEMP2, 1
    SALIDA:
    POPA
ENDM
ESCANEODECOLUMNA MACRO tope
    PUSHA
    CALL ESCANEODECOLUMNA_
    POPA
ENDM
PINTARPIEZASIGUIENTE MACRO PIEZA
    LOCAL P1,P2,P3,P4,P5,P6,P7,SALIDA
    DRAW_RECTANGLE  355, 414, 440, 522, BLUE
    CMP PIEZA, 1
    JE P1
    CMP PIEZA, 2
    JE P2
    CMP PIEZA, 3
    JE P3
    CMP PIEZA, 4
    JE P4
    CMP PIEZA, 5
    JE P5
    CMP PIEZA, 6
    JE P6
    CMP PIEZA, 7
    JE P7
    P1:
        PINTARPALITO 360,450
        JMP SALIDA
    P2:
        PINTARCUADRO 360, 450+18
        JMP SALIDA
    P3:
        PINTARTE 360, 450
        JMP SALIDA
    P4:
        PINTAR1ELE  360,450+18
        JMP SALIDA
    P5:
        PINTAR2ELE 360, 450+18
        JMP SALIDA
    P6:
        PINTAR1ZETA 360, 450
        JMP SALIDA
    P7:
        PINTAR2ZETA 360, 450
        JMP SALIDA
    SALIDA:
ENDM

;*========================= CREDENTIALS AND LOGIN ===================================
printdolar MACRO 
    PUSHA
    MOV AH, 09H
    mov al, "$"
    int 10h
    POPA
ENDM printdolar

MENUADMINISTRADOR MACRO
    PUSHA
    CALL MENUADMINISTRADOR_
    POPA
ENDM MENUADMINISTRADOR
MENUUSUARIOQUEESADMINISTRADOR MACRO
    PUSHA
    CALL MENUUSUARIOQUEESADMINISTRADOR_
    POPA
ENDM MENUUSUARIOQUEESADMINISTRADOR
MENUUSUARIO MACRO
    PUSHA
    CALL MENUUSUARIO_
    POPA
ENDM MENUUSUARIO
getLen macro var ; OBTENER LONGITUD DE UN BYTE :V
    LOCAL wh, endfinfin
    PUSHA
    MOV TEMP, 0
    XOR SI, SI
    wh:
        cmp var[SI],24h
        je endfinfin
        inc TEMP
        inc SI
        jmp wh
    endfinfin:
    POPA
endm

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
    MOV TEMPDB,0
    getcad:
        mov ah, 01h
        int 21h
        
        cmp al,0dh
        je endcad
        mov array[si],al
        inc si
        ;TODO: ACTIVAR--------------
        ; mov ah, 02h ; FUNCION PARA COLOCAR EL CURSOR
        ; mov dh, 18 ; 12 FILA
        ; mov dl, 38 ; 12 COLUMNA
        ; ADD DL, TEMPDB
        ; INC TEMPDB
        ; INT 10h
        ; mov AH, 02H
        ; mov DL , '$'
        ; INT 21H
        ;TODO --------------
        jmp getcad
    endcad:
    mov al,24h
    mov array[si],al
    POPA
endm

;! MACRO PARA COMPARAR 2 STRINGS
isequal macro STRING1, STRING2, length
    LOCAL whi, finalitoo, continue, neq, equal
    PUSHA
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
        mov TEMP, 0
        jmp finalitoo
    equal:
        mov TEMP, 1

    finalitoo:
    POPA
endm isequal
ESNUMERO macro CHARNUM ; ! PA SABER SI ES NUMNERO GUARDO DX
    LOCAL eeeeeeee,NOESNUMERO,ESUNNUMERO
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
    eeeeeeee:
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
    LOCAL buc,  buct,SALIR
    MOV TEMP,0
    XOR di, di
    buc:
        CMP MYuserPass[di+1], "$"
        JE SALIR
        ESMAYUS MYuserPass[di]
        buct:
            inc di
            JMP buc
    SALIR:
ENDM
CONTARNUMEROS macro
    LOCAL buc, sigo, buct,MAYUS,SALIR
    MOV TEMP,0
    XOR di, di
    buc:
        ESNUMERO MYuserPass[di]
        CMP MYuserPass[di+1], "$"
        JE SALIR
        buct:
            inc di
            JMP buc

    SALIR:
ENDM
CONTARESPECIALES macro
    LOCAL buc, sigo, buct,MAYUS,SALIR
    MOV TEMP,0
    XOR di, di
    buc:
        ESESPECIAL MYuserPass[di]
        CMP MYuserPass[di+1], "$"
        JE SALIR
        buct:
            inc di
            JMP buc

    SALIR:
ENDM


