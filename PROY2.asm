
;TODO █░█░█ █▀▀ █░░ █▀▀ █▀█ █▀▄▀█ █▀▀   █▀▄▀█ █▄█   █▀█ █▀█ ▄▀█ █▀▀ ▀█▀ █ █▀▀ █▀▀   █░█
;TODO ▀▄▀▄▀ ██▄ █▄▄ █▄▄ █▄█ █░▀░█ ██▄   █░▀░█ ░█░   █▀▀ █▀▄ █▀█ █▄▄ ░█░ █ █▄▄ ██▄   ▀▀█

INCLUDE FILEP2.inc
INCLUDE MACP2.inc
.MODEL SMALL
.386
.STACK 4096
.DATA

    ;*--------------------------  MIS_DATOS -----------------------------
        tb1             DB   'HOLA! BIENVENIDO A MI TETRIS  !!!!!!   ', "$"
        tb2             DB   'Universidad de San Carlos de Guatemala', "$"
        tb3             DB   'Facultad de Ingenieria', "$"
        tb4             DB   'Escuela de Ciencias y Sistemas', "$"
        tb5             DB   'Seccion A', "$"
        tb6             DB   'ALVARO EMMANUEL SOCOP PEREZ', "$"
        tb7             DB   '202000194', "$"
        pressenter      DB   'ENTER: Para continuar...', "$"
        ;*--------------------------     MENU    -----------------------------
        ; tm1             DB   29,'------- MENU PRINCIPAL ------'
        tm1             DB   "------- MENU PRINCIPAL ------", "$"
        tm2             DB   'F1. LOGIN     $'
        tm3             DB   'F5. REGISTRAR$'
        tm4             DB   'F9. SALIR$'
        tm1c             DB   '------- MENU PRINCIPAL ------',10, 13, "$"
        tm2c             DB   '         F1. LOGIN',10, 13, "$"
        tm3c             DB   '         F5. REGISTRAR',10, 13, "$"
        tm4c             DB   '         F9. SALIR',10, 13, "$"
        
    ;*----------- COORDENADAS PARA EL CURSOR  PARAMETROS DIBUJAR MODO VIDEO-----------------------------
        BLACK               EQU  00H
        POSX            DB  ?
        POSY            DB  ?
        saltolinea      DB " ",10, 13, "$"
        txtmayor      DB " > ", "$"
        X1              DW  ?
        X2              DW  ?
        Y1              DW  ?
        Y2              DW  ?
        POSAUXINOMBRE              DW  ?
        KEY_PRESSED                     DB  ?
        keypress          DB ?
        keypresstempY          DB ?
        keypresstempX          DB ?
        temprintvid          DB ?
    ;*--------------------------  MENSAJES -----------------------------
        ingpath db "Ingrese la ruta path del archivo:", 10, 13, "$"
        EXITO db "EXITO. ARCHIVO GUARDADO CON EXITO CARPETA BIN", 10, 13, "$"
        overflow db 00h
        numberF       dB ?
        txLOGIN     DB "LOGIN$"
        txLOGUP     DB "REGISTRAR USUARIO$"
        txUSUARIO   DB "USUARIO: $"
        txCONTRASENA      DB "CONTRASENA: $"
        ADMINCREDUSER   DB "202000194AADM"
        ADMINCREDPASS   DB "491000202"
        
            ;*--------------------------  ERRORES MESSAGES -----------------------------
            error1      db "ALERTA == credenciales incorrectas",10,'$'
            error2      db "ALERTA == Nombre de usuario tiene caracteres no permitidos.",10,'$'
            error3      db "ALERTA == Nombre de usuario no debe iniciar con NUMERO.",10,'$'
            error4      db "ALERTA == Nombre de Usuario sobrepasa limites revisar.",10,'$'
            error5      db "ALERTA == La contrasena debe tener al menos 3 MAYUSCULAS",10,'$'
    ;* --------------------------  REPORTES -----------------------------
        Filenamejug1  db  'Rep.xml'
        handlerentrada dw ?
        handler     dw ?
        USERSTET  DB "C:\MASM\MASM611\BIN\users.tet",0
        REPSORTREP  DB "C:\MASM\MASM611\BIN\REPSORT.REP",0
        punttet  DB "C:\MASM\MASM611\BIN\punt.tet",0
        hour        db "00", "$"
        min         db "00", "$"
        sec         db "00", "$"
        mes         db "00", "$"
        dia         db "00", "$"
        SI_SIMULADO             DW ?
        SI_SIMULADO2             DW ?
    ;? ------------------------BUBBLESORT VARIABLES------------------------
        buferdedatos          dw 2000 dup('$')
        listestadistic          dw 2000 dup('$')
        indexbbsort             DW 0000
        RESULTADOPRINT          dw 00h, '$'


    ;!-------------------------- VAR DEL JUEGO --------------------------
        Xtemp               DW      ?
        Ytemp               DW      ?
        X2temp              DW      ?
        Y2temp              DW      ?
        Xaux1              DW      ?    ;* posiciones de paint
        Yaux1              DW      ?
        Xaux2              DW      ?
        Yaux2              DW      ?
        Xtempauxaux              DW      ?
        Ytempauxaux              DW      ?
        setPOSX              DW      ? ;* PARA COORDENADAS EN MATRICES
        setPOSY              DW      ?
        coloraux           DB      ? ;* coloar auxiliar cuadro
        AREADEJUEGO         DW 256 DUP(00)
        PIEZASKIETAS         DW 256 DUP(0)
        INDEX           Dw ?
        INDEXtemp       Dw ?

        MYuserPass    db 20 dup ('$') ; 
        MYuserName    db 15 dup ('$')
        ;? --------------------------   COLORES   --------------------------
        GREEN               EQU  02H
        BLUE                EQU  01H
        GREEN               EQU  02H
        CYAN                EQU  03H
        RED                 EQU  04H
        MAGENTA             EQU  05H
        BROWN               EQU  06H
        LIGHT_GRAY          EQU  07H
        DARK_GRAY           EQU  08H
        LIGHT_BLUE          EQU  09H
        LIGHT_GREEN         EQU  0AH
        LIGHT_CYAN          EQU  0BH
        LIGHT_RED           EQU  0CH
        LIGHT_MAGENTA       EQU  0DH
        YELLOW              EQU  0EH
        WHITE               EQU  0FH
;!████████████████████████████ SEGMENTO DE CODIGO ████████████████████████████
.CODE

    main PROC FAR ; MAINMAIN
        MOV AX, @DATA
        MOV DS, AX
        MOV ES, AX
        limpiar
        ; setAREADEJUEGO 0,5
        ; CALL recorrerm1_
                ; misdatos
                ; esperaenter  ;TODO: activar despues
        PRINCIPALMENULABEL:
        ;! MENUPRINCIPAL
        Inicio:
            paint  0, 0, 800, 600, BLACK ;*LIMPIA TODO MODO VIDEO:V
            
            menu
            MOV AH, 0 ;Wait for keystroke and read
            INT 16H
            CMP AH,3BH    ; si tecla es F1
            JE LOGGEAR     ; SI SI ES SE VA A INICIARJUEGO
            CMP AH,3FH    ; si tecla es F5
            JE REGISTRAR     ; SI SI ES SE VA A INICIARJUEGO
            JNE Inicio
        REGISTRAR:
            paint  0, 0, 800, 600, GREEN
            logup

        LOGGEAR:
            paint  0, 0, 800, 600, BLACK
            login
            PINTARPANTALLADEJUEGO
        SALIR:
        FIN:
        
        ; MOV Xtemp,540
        ; MOV Ytemp, 540+16
        ; MOV X2temp,144
        ; MOV Y2temp,144+16
        ; DRAW_RECTANGLE  Xtemp,X2temp,Ytemp,Y2temp,GREEN ;* CorX, CorY, Cor2X, Cor2Y
        ; delay 5000, 1000
        ; DRAW_RECTANGLE  455,292,473,310,BLACK
        ; DRAW_RECTANGLE  455,292+18,473,310+18,GREEN
        ; delay 5000, 1000
        ; DRAW_RECTANGLE  455,292+18,473,310+18,BLACK
        ; DRAW_RECTANGLE  455,292+18+18,473,310+18+18,GREEN
                ; ;*PRUEBA BUBBLE SORT
                        ; MOV listestadistic[0], 88
                        ; MOV listestadistic[2], 2
                        ; MOV listestadistic[4], 88
                        ; MOV listestadistic[6], 8
                        ; MOV listestadistic[8], 8
                        ; MOV listestadistic[10], 9
                        ; MOV listestadistic[12], 80
                        ; MOV listestadistic[14], 0

                        ; MOV indexbbsort,16

                        ; BUBBLESORT
                        ; MOV AX,listestadistic[0]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[2]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[4]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[6]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[8]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[10]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[12]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; MOV AX,listestadistic[14]
                        ; printnum RESULTADOPRINT, AX
                        ; print RESULTADOPRINT
                        ; print saltolinea
                        ; readtext


        
        SALIDADEUNA:
            mov ax, 4c00h
            int 21h
            HLT ; para decirle al CPU que se estara ejecutando varias veces (detiene CPU hasta sig interrupcion)
            RET
    main    ENDP
    
    
    MENUPRINCIPAL_ PROC NEAR
    RET
    MENUPRINCIPAL_ ENDP
   
    ;?☻ =====================   ======================= ☻
    ; BUSCARUSER_ PROC FAR
    ;     RET
    ; BUSCARUSER_ ENDP
    ; BUSCARUSER_ PROC FAR
    ;     RET
    ; BUSCARUSER_ ENDP
    ; BUSCARUSER_ PROC FAR
    ;     RET
    ; BUSCARUSER_ ENDP
    ; BUSCARUSER_ PROC FAR
    ;     RET
    ; BUSCARUSER_ ENDP
    ; BUSCARUSER_ PROC FAR
    ;     RET
    ; BUSCARUSER_ ENDP
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;?☻ ===================== MATRIZ AREA DE JUEGO ======================= ☻
    setAREADEJUEGO_ PROC NEAR
        ;! POSICION AL = Y     AX = X
        MOV AX, 2
        MOV BX, setPOSX
        MUL BX
        MOV setPOSX, BX

        mov AX, setPOSY   ; indice externo a accesar
        mov BX, 16  ; tamaño de cada arreglo almacenado en el primer nivel de la matriz
        mul BX      ; nos deja la respuesta en el ax.  Ocupamos que la dirección sea en 16 bits
        mov BX, setPOSX
        add AX, BX   ; sumamos el indice interno a la cantidad de celdas acumulada
        mov si, AX  ; Movemos la dirección al puntero SI
        Mov AREADEJUEGO[SI],1 ; finalmente movemos el dato.  Es importante lo de word ptr para indicar el tamaño
        printnum RESULTADOPRINT, AX
        print RESULTADOPRINT
        print saltolinea
        RET
    setAREADEJUEGO_ ENDP
    ;?☻ ===================== RECORRER MATRIZ AREA DE JUEGO ======================= ☻
    recorrerm1_ PROC NEAR
        mov si, 00
        mov di, 00
        MOV INDEX, 0
        paintfila:
            cmp si, 16
            jne printelcuadro
            je imprimirsaltolinea

        printelcuadro:
            mov INDEXtemp, si
            mov si, INDEX           ;* mostrar lo que hay en la matriz
            mov AX, AREADEJUEGO[si]
            printnum RESULTADOPRINT, AX
            print numberF
            mov si, INDEXtemp
            INC si
            INC si
            INC index      ;* AUMENTO EL INDICE PRINCIPAL
            INC index      ;* AUMENTO EL INDICE PRINCIPAL
            
            JMP paintfila

        imprimirsaltolinea:
            mov si, 00
            INC di
            print saltolinea
            cmp di, 16
            jne printelcuadro
            je exit
        exit:
        RET
    recorrerm1_ ENDP
    ;?☻ ===================== CONCATENAR TEXTO ENTRADA ======================= ☻
    readtext_ PROC NEAR
        xor di , di
        Leer:
            mov ax, 00
            mov ah, 01h
            int 21h
            cmp al, 08
            JE DELQUITAR
            JNE SEGUIR
            DELQUITAR:
                dec di
                mov keypress[di],"$"
            SEGUIR:
            cmp al, 13
            jne Concatenar
            je Salir
        Concatenar:
            mov keypress[di], al
            mov keypress[di + 1], "$"
            inc di
            jmp Leer
        Salir:
        RET
    readtext_ ENDP

    ;?☻ ===================== POSICIONAR EL CURSOR ======================= ☻
    poscursor_ PROC NEAR
        ; FUNCION COLOCAR CURSOR
        mov ah, 02h ; FUNCION PARA COLOCAR EL CURSOR
        mov dh, POSX ; 12 FILA
        mov dl, POSY ; 12 COLUMNA
        INT 10h
        RET
    poscursor_ ENDP
    ;? ☻ ===================== METODO MOSTRAR DATOS ======================= ☻
    misdatos_     PROC NEAR
        MOV AX,4F02H           ;SETEAMOS EL MODO VIDEO INT 10   800*600
        MOV BX,103H
        INT 10H
        ; imprimo el texto de inicio
        PAINTTEXT tb1 , 0820H , 0FF22H
        PAINTTEXT tb2 , 0F10h , 0FF0FH
        PAINTTEXT tb3 , 1210H , 0FF0FH
        PAINTTEXT tb4 , 1410H , 0FF0FH
        PAINTTEXT tb5 , 1610H , 0FF0FH
        PAINTTEXT tb6 , 1810H , 0FF0FH
        PAINTTEXT tb7 , 1A10H , 0FF0FH
        PAINTTEXT pressenter , 2125H , 0FF30H
        RET
    misdatos_     ENDP
    ;?☻ ===================== METODO MOSTRAR DATOS ======================= ☻
    menu_     PROC NEAR
        PAINTTEXT tm1 , 0820H , 0FF26H
        PAINTTEXT tm2 , 0F10h , 0FF0FH
        PAINTTEXT tm3 , 1210H , 0FF0FH
        PAINTTEXT tm4 , 1410H , 0FF0FH
        RET
    menu_     ENDP
    ;?☻ ===================== METODO IMPRIMIR ======================= ☻
    ; PAINTTEXT_    PROC NEAR
    ;     MOV AX,1301H
    ;     MOV BX,BP
    ;     MOV CL,[BX]
    ;     MOV CH,00H
    ;     ADD BP,1H
    ;     MOV BX,SI
    ;     INT 10H
    ;     RET
    ; PAINTTEXT_    ENDP
    PAINTTEXT_    PROC NEAR
        
        RET

    PAINTTEXT_    ENDP
    ;?☻ ===================== PRESIONAR TECLAS ======================= ☻
    enterclick_    PROC    NEAR
        esperar:
            esperatecla
            MOV AH , keypress
            CMP AH, 1CH
        JNE esperar
        RET
    enterclick_    ENDP
    esperatecla_  PROC   NEAR
        MOV keypress, AH
        RET
    esperatecla_ ENDP
    ;?☻ ===================== DIBUJAR EN PANTALLA ======================= ☻
    paint_   PROC  NEAR
        ;PARAMETERS
        ; X1, Y1, X2, Y2, AL = COLOR
        INC X2
        INC Y2  ;TO STOP AT X2 + 1, Y2 + 1
        MOV DX, Y1
        MOV AH, 0CH   ;AH = 0C FOR INT, AL = COLOR
        DRAW_ALL_RECTANGLE_ROWS:
        MOV CX, X1
            DRAW_RECTANGE_ROW:
                INT 10H
                INC CX
                CMP CX, X2
            JNZ DRAW_RECTANGE_ROW
        INC DX
        CMP DX, Y2
        JNZ DRAW_ALL_RECTANGLE_ROWS
        RET
    paint_ ENDP
    DRAW_RECTANGLE_   PROC  NEAR    
        ;PARAMETERS
        ; X1, Y1, X2, Y2, AL = COLOR
        INC X2
        INC Y2  ;TO STOP AT X2 + 1, Y2 + 1
        MOV DX, Y1
        MOV AH, 0CH   ;AH = 0C FOR INT, AL = COLOR
        DRAW_ALL_RECTANGLE_ROWS:
        MOV CX, X1
            DRAW_RECTANGE_ROW:
                INT 10H
                INC CX
                CMP CX, X2
            JNZ DRAW_RECTANGE_ROW
        INC DX
        CMP DX, Y2
        JNZ DRAW_ALL_RECTANGLE_ROWS
        RET
    DRAW_RECTANGLE_ ENDP
    PINTARPANTALLADEJUEGO_ PROC NEAR
        DRAW_RECTANGLE 468,144,656, 144+18, CYAN
        DRAW_RECTANGLE 468,144,468+18, 484, CYAN
        DRAW_RECTANGLE 468,484-18,656, 484, CYAN
        DRAW_RECTANGLE 656-18,144,656, 484, CYAN
        ;PINTAR TITULO
        DRAW_RECTANGLE 144+18,108+36,144+36, 108+36+18, WHITE
        DRAW_RECTANGLE 54,108,324, 108+18, WHITE
        DRAW_RECTANGLE  90,108+18,90+18, 216, WHITE             ; PALABRA TETRIS
        DRAW_RECTANGLE  144,108+18,144+18, 216, WHITE
        DRAW_RECTANGLE  144,216-18,198, 216, WHITE
        DRAW_RECTANGLE  144+18,216-18,144+36, 216-18, WHITE
        DRAW_RECTANGLE  216,108+18,216+18, 216, WHITE
        DRAW_RECTANGLE  270,108+18,270+18, 216, WHITE
        DRAW_RECTANGLE  270+18,108+36,270+36, 108+36+18, WHITE
        DRAW_RECTANGLE  270+36,108+18,270+36+18, 108+36, WHITE
        DRAW_RECTANGLE  270+36,108+36+18,270+36+18, 216, WHITE
        DRAW_RECTANGLE  342,108,342+18, 216, WHITE
        DRAW_RECTANGLE  378,108,414, 108+18, WHITE
        DRAW_RECTANGLE  378,108+18,378+18, 108+18+18, WHITE
        DRAW_RECTANGLE  378,108+36,414, 108+36+18, WHITE
        DRAW_RECTANGLE  414-18,108+(18*3),414, 216, WHITE
        DRAW_RECTANGLE  378,216-18,414,216, WHITE
        DRAW_RECTANGLE  486, 162, 638, 466, BLUE
        PINTARCUADRO 684,162
        PINTARPALITO 720, 72
        PINTARTE 720,216
        PINTAR1ELE 666, 288
        PINTAR2ELE 756, 360
        PINTAR1ZETA 680, 450
        PINTAR2ZETA 720, 522
        RET
    PINTARPANTALLADEJUEGO_ ENDP
    PINTARCUADRO_ PROC NEAR;! CUADRADO
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_CYAN
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_CYAN
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_CYAN
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1,LIGHT_CYAN
        RET
    PINTARCUADRO_ ENDP
    
    PINTARPALITO_ PROC NEAR;! PALITO
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        RET
    PINTARPALITO_ ENDP
    PINTARPALITO2_ PROC NEAR;! PALITO2
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GREEN
        RET
    PINTARPALITO2_ ENDP
    PINTARTE_ PROC NEAR;! TE
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_RED
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_RED
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_RED
        MOV CX, Xtemp
        ADD CX, 40
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_RED
        RET
    PINTARTE_ ENDP
    PINTAR1ELE_ PROC NEAR;! ELE1
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, MAGENTA
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, MAGENTA
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, MAGENTA
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, MAGENTA
        RET
    PINTAR1ELE_ ENDP
    PINTAR2ELE_ PROC NEAR;! ELE2
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, YELLOW
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, YELLOW
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, YELLOW
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, YELLOW
        RET
    PINTAR2ELE_ ENDP
    PINTAR1ZETA_ PROC NEAR;! ELE1
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GRAY
        MOV CX, Xtemp
        ADD CX, 40
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GRAY
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GRAY
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, LIGHT_GRAY
        RET
    PINTAR1ZETA_ ENDP
    PINTAR2ZETA_ PROC NEAR;! ELE2
        MOV CX, Xtemp
        MOV Xaux1, CX
        MOV CX, Ytemp
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, BROWN
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, BROWN
        MOV CX, Xtemp
        ADD CX, 20
        MOV Xaux1, CX
        MOV CX, Ytemp
        ADD CX, 20
        MOV Yaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, BROWN
        MOV CX, Xtemp
        ADD CX, 40
        MOV Xaux1, CX
        PAINTSQUARE  Xaux1,Yaux1, BROWN
        RET
    PINTAR2ZETA_ ENDP

    PAINTSQUARE_ PROC NEAR          ;! -----------PINTAR UN CUADRO 18*18-----------
        MOV CX, Xtempauxaux
        MOV Xaux1, CX
        ADD CX, 18
        MOV Xaux2, CX

        MOV CX, Ytempauxaux
        MOV Yaux1, CX
        ADD CX, 18
        MOV Yaux2, CX
        DRAW_RECTANGLE  Xaux1,Yaux1,Xaux2,Yaux2, coloraux
        RET
    PAINTSQUARE_ ENDP
    
    ;*        ████████████████████████████████ ████████████████████████████████████
    ;*        █▄─▄▄─█─▄▄▄▄█─▄─▄─██▀▄─██▄─▄▄▀█▄─▄█─▄▄▄▄█─▄─▄─█▄─▄█─▄▄▄─██▀▄─██─▄▄▄▄█
    ;*        ██─▄█▀█▄▄▄▄─███─████─▀─███─██─██─██▄▄▄▄─███─████─██─███▀██─▀─██▄▄▄▄─█
    ;*        ▀▄▄▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀


    BUBBLESORT_ PROC NEAR
        MOV CX, indexbbsort
        DEC CX
        DEC CX
        DEC CX
        DEC CX
        MOV SI, -2
        MOV DI, -2
        ILOOP:       ;* for i in range(0,len(list1)-1):
            INC SI
            INC SI
            JLOOP:  ;* for j in range(len(list1)-1)
                INC DI
                INC DI
                CONDITION:          ;*if(list1[j]>list1[j+1]):
                    MOV AX, listestadistic[DI]
                    MOV BX, listestadistic[DI+2]
                    CMP AX,BX
                    Ja MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV AX, listestadistic[DI]
                        MOV BX, listestadistic[DI+2]
                        MOV listestadistic[DI], BX
                        MOV listestadistic[DI+2], AX  ;*list1[j+1] = temp
                        JMP JLOOP_
        JLOOP_:
            CMP DI, CX
            JNE JLOOP
            JE ILOOPS_
        ILOOPS_:
            MOV DI,-2
            cmp SI, CX
            JNE ILOOP
            JE SALIR
        SALIR:
        RET
    BUBBLESORT_ ENDP

    
    ;!  █▀█ █▀▀ █▀█ █▀█ █▀█ ▀█▀ █▀
    ;!  █▀▄ ██▄ █▀▀ █▄█ █▀▄ ░█░ ▄█☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻ GENERACION DE REPORTES

    GENERARHTML1_ PROC NEAR
        MOV SI_SIMULADO,0
        MOV SI_SIMULADO2,0
        getDate
        getTime
        ; concatenarHTML buffInfo, reportecxml
        ; crear Filenamejug1, handlerentrada
        ; escribir  handlerentrada, buffInfo, SIZEOF buffInfo
        ; cerrar handlerentrada
        RET
    GENERARHTML1_ ENDP
    convert proc
        aam
        add ax, 3030h
        ret
    convert endp
end     MAIN
;*  ░█████╗░██╗░░░░░██╗░░░██╗░█████╗░██████╗░░█████╗░    ░██████╗░█████╗░░█████╗░░█████╗░██████╗░
;*  ██╔══██╗██║░░░░░██║░░░██║██╔══██╗██╔══██╗██╔══██╗    ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗
;*  ███████║██║░░░░░╚██╗░██╔╝███████║██████╔╝██║░░██║    ╚█████╗░██║░░██║██║░░╚═╝██║░░██║██████╔╝
;*  ██╔══██║██║░░░░░░╚████╔╝░██╔══██║██╔══██╗██║░░██║    ░╚═══██╗██║░░██║██║░░██╗██║░░██║██╔═══╝░
;*  ██║░░██║███████╗░░╚██╔╝░░██║░░██║██║░░██║╚█████╔╝    ██████╔╝╚█████╔╝╚█████╔╝╚█████╔╝██║░░░░░
;*  ╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░    ╚═════╝░░╚════╝░░╚════╝░░╚════╝░╚═╝░░░░░
