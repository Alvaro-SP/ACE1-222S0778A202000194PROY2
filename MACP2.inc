
;!                ░█▀▄▀█ ─█▀▀█ ░█▀▀█ ░█▀▀█ ░█▀▀▀█ ░█▀▀▀█
;!                ░█░█░█ ░█▄▄█ ░█─── ░█▄▄▀ ░█──░█ ─▀▀▀▄▄
;!                ░█──░█ ░█─░█ ░█▄▄█ ░█─░█ ░█▄▄▄█ ░█▄▄▄█
;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            ;! ▀▀▀▀▀▀▀▀▀▀  MENU  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀
OPCIONDEMENU MACRO
    PUSHA
    CALL OPCIONDEMENU_
    POPA
ENDM OPCIONDEMENU
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
;*========================= MENU PRINCIPAL ===================================
menu MACRO                                                     ;? ▬▬▬▬▬ MENU
    PUSHA
    CALL menu_
    POPA
ENDM menu

GENERARHTML1 MACRO                                                     ;? ▬▬▬▬▬ MENU
    PUSHA
    CALL GENERARHTML1_
    POPA
ENDM GENERARHTML1
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
println macro texto
    mov ah, 09
    mov dx, offset texto
    int 21h
    print saltolinea
ENDM println
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

;* =======================ARRAYS=======================
RESETNUMSTEMPS MACRO
    MOV num1_fill, 0H       ;!RESETEO FLAGS DE NUMERO DERECHO
    MOV num1_int, 0H
    MOV num1_int_abs, 0H
    MOV num1_dot, 0H
    MOV num1_dot_, 0H
    MOV num1_sign, 1H
    MOV num1_pow, 1H
    MOV num1_dot_detect, 0xFF

    MOV num2_fill, 0H       ;!RESETEO FLAGS DE NUMERO IZQUIERDO
    MOV num2_int, 0H
    MOV num2_int_abs, 0H
    MOV num2_dot, 0H
    MOV num2_dot_, 0H
    MOV num2_sign, 1H
    MOV num2_pow, 1H
    MOV num2_dot_detect, 0xFF  ;! NO fue necesario pero igual lo agrego
    
    MOV res_int, 0H;! Reset  FLAGS DE result
    MOV res_int1, 0H
    MOV res_dot, 0H
    MOV res_pow, 1H
    
    ; Reset operator
    MOV op, 0H   
ENDM

quitarespacios MACRO destino, auxiliar
    LOCAL inicio,concat,SALIR,NOHAYESPACIOBLANCO
    mov si, 0
    mov di, 0
    inicio:
        cmp auxiliar[si], "$"
        JNE concat
        JE SALIR
    concat:
        cmp auxiliar[si],27 ;! osea si hay espacios en blanco no agregar
        JNE NOHAYESPACIOBLANCO
        JE inicio
    NOHAYESPACIOBLANCO:
        MOV AL, auxiliar[si]
        MOV destino[di], AL
        inc di
    SALIR:
ENDM

ANALIZARYCALCULAR MACRO                           ;? ▬▬▬ ENTER
    PUSHA
    CALL ANALIZARYCALCULAR_
    POPA
ENDM ANALIZARYCALCULAR
ANALIZARYCALCULAR2 MACRO                           ;? ▬▬▬ ENTER
    PUSHA
    CALL ANALIZARYCALCULAR2_
    POPA
ENDM ANALIZARYCALCULAR2
ANALIZARYCALCULAR3 MACRO                           ;? ▬▬▬ ENTER
    PUSHA
    CALL ANALIZARYCALCULAR3_
    POPA
ENDM ANALIZARYCALCULAR3
SUMA MACRO NUMIZQTEMP ,NUMDERTEMP                                                ;? ▬▬▬ SUMA
    PUSHA
    MOV AX, NUMDERTEMP
    MOV NUMDER, AX
    MOV AX, NUMIZQTEMP
    MOV NUMIZQ, AX
    CALL SUMA_
    POPA
ENDM SUMA
RESTA MACRO   NUMIZQTEMP ,NUMDERTEMP                                                ;? ▬▬▬ RESTA
    PUSHA
    MOV AX, NUMDERTEMP
    MOV NUMDER, AX
    MOV AX, NUMIZQTEMP
    MOV NUMIZQ, AX
    CALL RESTA_
    POPA
ENDM RESTA
MULTI MACRO   NUMIZQTEMP ,NUMDERTEMP                                                ;? ▬▬▬ MULTI
    PUSHA
    MOV AX, NUMDERTEMP
    MOV NUMDER, AX
    MOV AX, NUMIZQTEMP
    MOV NUMIZQ, AX
    CALL MULTI_
    POPA
ENDM MULTI
DIVI MACRO NUMIZQTEMP ,NUMDERTEMP                                                 ;? ▬▬▬ DIVI
    PUSHA
    MOV AX, NUMDERTEMP
    MOV NUMDER, AX
    MOV AX, NUMIZQTEMP
    MOV NUMIZQ, AX
    CALL DIVI_
    POPA
ENDM DIVI
POTENCIA MACRO  NUMIZQTEMP ,NUMDERTEMP                                            ;? ▬▬▬ POTENCIA
    PUSHA
    MOV AX, NUMDERTEMP
    MOV NUMDER, AX
    MOV AX, NUMIZQTEMP
    MOV NUMIZQ, AX
    CALL POTENCIA_
    POPA
ENDM POTENCIA

;! PARSEO NUMERO DE STR A DECIMAL.
parser MACRO  ;RESULTADO EN PARSEDNUM
    PUSHA
    CALL parser_
    POPA
ENDM parser
ANALIZARARCHIVOENTRADA MACRO ;RESULTADO EN PARSEDNUM
    PUSHA
    CALL ANALIZARARCHIVOENTRADA_
    POPA
ENDM ANALIZARARCHIVOENTRADA




ESNUMERO MACRO CHARS
    PUSHA
    MOV AL, CHARS
    MOV CHARNUM, AL
    CALL ESNUMERO_
    POPA
ENDM ESNUMERO
ADDTOSTATISTICSLIST MACRO
    ; PUSHA
    CALL ADDTOSTATISTICSLIST_
    ; POPA
ENDM ADDTOSTATISTICSLIST

ESOP MACRO CHARS
    MOV AL, CHARS
    MOV CHARNUM, AL
    CALL ESOP_
ENDM ESOP
ESLETRA MACRO CHARS
    PUSHA
    MOV AL, CHARS
    MOV CHARNUM, AL
    CALL ESLETRA_
    POPA
ENDM ESLETRA
ESOP2 MACRO CHARS
    PUSHA
    MOV AX, CHARS
    MOV CHAR, AX
    CALL ESOP2_
    POPA
ENDM ESOP2
resetflagop MACRO CHAR
    MOV flagsuma, '0'
    MOV flagresta, '0'
    MOV flagmulti, '0'
    MOV flagdivi, '0'
    MOV flagpot, '0'
ENDM resetflagop
;! CLASIFICAR TIPO DE OPERADOR PARA PRECEDENCIA
CLASIFYDIGITS MACRO CHAR
    PUSHA
    CALL CLASIFYDIGITS_
    POPA
ENDM CLASIFYDIGITS

;macro para convertir int a string 
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
;macro para convertir un string (si se le puede llmar de esta manera) a un ascii (caracter)
intToString MACRO number, output
    LOCAL beginConv,EndConv
    PUSHA
    mov        AX, 0
    mov        bx, 0
    mov        cx, 0
    mov        bx, 10    ;este 10 sirve como tempiliar para unir los numeros a uno solo por unidades, decenas etc
    mov        si, 0

    beginConv:  
        mov        CL, number[si] ;mueve el valor del numero en la poscion SI al registro cl
        cmp        CL, 30h ;compara si ya termino de leer el string 
        jl         EndConv 
        cmp        CL, 39h ;compara si ya termino de leer el string 
        jg         EndConv
        inc        si ;incrementa si
        sub        cl, 30h ;compara si ya termino de leer el string
        mul        bx ;realiza la multiplicacion para la conversion
        add        ax, cx ;suma ax y cx 
        JMP        beginConv ;se va a finalizar la conversion 
    EndConv:    
        mov        output, ax ;mueve a salida el registro ax

    POPA
ENDM

FIBONACCI MACRO
    ; PUSHA
    CALL FIBONACCI_
    ; POPA
ENDM FIBONACCI
ESFIBONACCI MACRO
    PUSHA
    CALL ESFIBONACCI_
    POPA
ENDM ESFIBONACCI
MEDIA MACRO TAM;* ESTADISTICA
    ; PUSHA
    MOV AX, TAM
    MOV TAMANODEARRAY, AX
    CALL MEDIA_
    ; POPA
ENDM MEDIA
MEDIANA MACRO ;* ESTADISTICA
    ; PUSHA
    CALL MEDIANA_
    ; POPA
ENDM MEDIANA
MODA MACRO ;* ESTADISTICA
    PUSHA
    CALL MODA_
    POPA
ENDM MODA

IMPARES MACRO;* ESTADISTICA
    PUSHA
    CALL IMPARES_
    POPA
ENDM IMPARES
LUCASLUCAS MACRO ;* ESTADISTICA
    PUSHA
    CALL LUCASLUCAS_
    POPA
ENDM LUCASLUCAS
LUCASLUCAS MACRO ;* ESTADISTICA
    PUSHA
    CALL LUCASLUCAS_
    POPA
ENDM LUCASLUCAS
ESIMPAR MACRO ;* ESTADISTICA
    PUSHA
    CALL ESIMPAR_
    POPA
ENDM ESIMPAR
ESLUCAS MACRO ;* ESTADISTICA
    PUSHA
    CALL ESLUCAS_
    POPA
ENDM ESLUCAS
ESPAR MACRO ;* ESTADISTICA
    PUSHA
    CALL ESPAR_
    POPA
ENDM ESPAR
AGREGAROPERACIONESXML MACRO ;* ESTADISTICA
    PUSHA
    CALL AGREGAROPERACIONESXML_
    POPA
ENDM AGREGAROPERACIONESXML

BUBBLESORT MACRO
    PUSHA
    CALL BUBBLESORT_
    POPA
ENDM BUBBLESORT
getProm MACRO
    LOCAL While, endWhile
    mov   si,0
    mov   ax, 0
    While:
        mov   ax, listValues[si]
        add   ax, mediaAns
        mov   mediaAns, ax
        inc   si
        inc   si
        cmp   si, counterValue
        je    endWhile
        jmp   While
    endWhile:
        mov   bx, 0
        mov   ax, 0
        mov   ax, counterValue
        mov   bx, 2
        cwd
        idiv  bx

        mov   bx, ax
        mov   ax, mediaAns
        cwd
        idiv  bx
        mov   mediaAns, ax
ENDM

PRINTMENU MACRO
    PUSHA
    CALL PRINTMENU_
    POPA
ENDM

RESET MACRO
    cleanBuffer file
    cleanBuffer fileData
    cleanBuffer buffXML
    cleanBuffer buffInfo
    cleanBuffer listNumbers
    cleanBuffer listValues
    MOV CONTADORNumbers, 0
    MOV CONTADORValues, 0
    MOV REGRESOALMENU,'1'
    MOV INDEXlistestadistic, 0
    MOV INDEXRESULTADOSFINALES, 0
ENDM RESET
BUSCAROPERACIONCONID MACRO
    PUSHA
        CALL BUSCAROPERACIONCONID_
    POPA
ENDM BUSCAROPERACIONCONID



