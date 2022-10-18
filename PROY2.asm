
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
        tm2             DB   'F1. LOGIN$'
        tm3             DB   'F5. REGISTRAR$'
        tm4             DB   'F9. SALIR$'
        tAD1             DB   "------- MENU ADMINISTRADOR ------", "$"
        tAD2             DB   'F1. Desbloquear usuario$'
        tAD3             DB   'F2. Promover usuario$'
        tAD4             DB   'F3. Degradar usuario$'
        tAD5             DB   'F4. Bubble Sort$'
        tAD6             DB   'F5. Heap Sort$'
        tAD7             DB   'F6. Quick Sort$'
        tAD8             DB   'F10. Cerrar sesión$'
        
        tAD9             DB   "------- MENU USUARIO QUE ES ADMINISTRADOR ------", "$"
        tAD10             DB   'F2. Mostrar el top 10 general de puntuaciones$'
        tAD11             DB   'F3. Mostrar el top 10 de las puntuaciones del jugador$'
        tAD12             DB   'F7. JUGAR$'
        
        tu1             DB   "------- MENU USUARIO  ------", "$"
        tu4             DB   'F3. JUGAR$'
        tu2             DB   'F4. Mostrar el top 10 general de puntuaciones$'
        tu3             DB   'F5. Mostrar el top 10 de las puntuaciones del jugador$'

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
        savedmessage      DB   'USUARIO GUARDADO SATISFACTORIAMENTE :)', "$"
        msgyaesadmin DB 'NO PUEDE PROMOVER YA ES UN ADMINISTRADOR', "$"
        msgpromovido DB 'USUARIO PROMOVIDO AHORA ES UN PRO ;v', "$"
        msgdegradado DB 'USUARIO DEGRADADO AHORA ES UN ESCLAVO ;v', "$"
        msgbloqueado DB 'USUARIO BLOQUEADO POR INTENTOS FALLIDOS', "$"
        msgyaesnormal DB 'NO SE PUEDE DEGRADAR YA ES UN USUARIO NORMAL', "$"
        msgestaunlock DB 'EL USUARIO ESTA DESBLOQUEADO', "$"
        msgestalock DB 'EL USUARIO YA ESTA BLOQUEADO', "$"
        msgUSERTOPROMOVE DB 'DIGITE EL USUARIO A PROMOVER', "$"
        msgUSERTODEGRADE DB 'DIGITE EL USUARIO A DEGRADAR', "$"
        msgUSERTOUNLOCK DB 'DIGITE EL USUARIO A DESBLOQUEAR', "$"
        msguserguardado DB 'USUARIO GUARDADO SATISFACTORIAMENTE!', "$"
        msgsesioniniciadasatisf DB 'SESION INICIADA SATISFACTORIAMENTE!', "$"
        pause0 DB '------------------- PAUSA ---------------------', "$"
        pause1 DB 'ESC = para guardar SCORE y salir al MENU', "$"
        pause2 DB 'DEL = para continuar el JUEGO', "$"
            ;*--------------------------  ERRORES MESSAGES -----------------------------
            error1      db "ALERTA == credenciales incorrectas",10,'$'
            error2      db "ALERTA == Nombre de usuario tiene caracteres no permitidos.",10,'$'
            error3      db "ALERTA == Nombre de usuario no debe iniciar con NUMERO.",10,'$'
            error4      db "ALERTA == Nombre de Usuario sobrepasa limites revisar.",10,'$'
            error5      db "ALERTA == La contrasena debe tener al menos 3 MAYUSCULAS",10,'$'
            error6      db "ALERTA == La contrasena debe tener al menos 2 NUMEROS",10,'$'
            error7      db "ALERTA == La contrasena debe tener al menos 2 CARACTERES ESPECIALES",10,'$'
            error8      db "ALERTA == Contrasena tiene mal los limites revisar.",10,'$'
            error9      db "ALERTA == El nombre de usuario ya esta en USO",10,'$'
            error10      db "ALERTA ==NO SE ENCONTRO O INTENTA DESBLOQUEAR A ADMIN",10,'$'
            error11      db "ALERTA ==IMPOSIBLE INICIAR SESION, USUARIO BLOQUEADO",10,'$'
    ;* --------------------------  REPORTES -----------------------------
        Filenamejug1  db  'Rep.xml'
        handlerentrada dw ?
        handler     dw ?
        handler2     dw ?
        USERSTET  DB "users.tet",0
        REPSORTREP  DB "REPSORT.rep",0
        punttet  DB "punt.tet",0
        hour        db "00", "$"
        min         db "00", "$"
        sec         db "00", "$"
        mes         db "00", "$"
        dia         db "00", "$"
        SI_SIMULADO             DW ?
        SI_SIMULADO2             DW ?
        tamfile             DW 0
        TEMP             DW 0
        TEMP2             DW 0
        TEMP3             DW 0
        TEMPDB             Db "0$"
        nuevalinea       db 10,'$'
        cooldowncont       dw 0
    ;? ------------------------BUBBLESORT VARIABLES------------------------
        buferdedatos          db 1000 dup('$')
        listestadistic          dw 2000 dup('$')
        indexbbsort             DW 0000
        RESULTADOPRINT          dw 00h, '$'
        izq   DB "LEFT $"
        der   DB "RIGHT $"


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
        AREADEJUEGO         DW 256 DUP(0)
        PIEZASKIETAS         DW 256 DUP(0)
        INDEX           Dw ?
        INDEXtemp       Dw ?

        MYuserPass          db 20 dup ('$') ; ! USUARIO Y CONTRASENA
        MYuserName          db 15 dup ('$')
        MYauxUserName       db 15 dup ('$')
        MYauxUserName2      db 15 dup ('$')
        MYauxPass           db 20 dup ('$')

        CATEGORIA       DB "0$"
        BLOQUEO         DB "0$"

        Stringpuntos    DB 4 dup ('$')
        Stringnivel     DB "1$"
        ;! VELOCIDAD DEL JUEGO
        speed DW 1100
        timeaux DW 0
        FLAGSABERSIROTO     DW      0

        auxpX1      DW -1       ; * AUXILIARES PARA POSICION ANTERIOR (FRAMES PERDIDOS)
        auxpX2      DW -1
        auxpX3      DW -1
        auxpX4      DW -1
        auxpY1      DW -1
        auxpY2      DW -1
        auxpY3      DW -1
        auxpY4      DW -1

        BANDERATIESO        DW 0
        POSTOSET            DW 0
        POSXHANDLE          DW 0  ;* POSICION HORIZONTAL DE LA PIEZA
        TIPODEPIEZA         DW 0 ;* HANDLER DEL TIPO DE PIEZA
        NEXTPIECE           DW 0
        ROTACIONDEPIEZA     DW 0 ;* HANDLER DE LA ROTACION DE LA PIEZA
        FLAGMOVERIGHT       DW 0
        FLAGMOVELEFT        DW 0
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
        misdatos
        esperaenter  ;TODO: activar despues
        paint  0, 0, 800, 600, BLACK
        ; PAINTPOS 0,1, LIGHT_MAGENTA
        ; PAINTPOS 1,1, LIGHT_MAGENTA
        ; PAINTPOS 1,2, LIGHT_MAGENTA
        ; PAINTPOS 5,10, LIGHT_MAGENTA
        
        ; UPDATECUADRO 0,14
        INICIODELJUEGO
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
            paint  0, 0, 800, 600, BLACK
            logup
            PAINTTEXT msguserguardado , 2125H , 0FF30H
            readtext
            JMP PRINCIPALMENULABEL
        LOGGEAR:
            paint  0, 0, 800, 600, BLACK
            login

            VALIDARTIPODEUSUARIO
            PAINTTEXT msgsesioniniciadasatisf , 2125H , 0FF30H
            readtext
        ERRORUSUARIOBLOQUEADO:
            poscursor 22, 38
            cleanBuffer MYuserName
            cleanBuffer MYuserPass
            print error11
            readtext
            JMP Inicio
        MOSTRARMENUNORMAL:
            MENUUSUARIO
            JMP Inicio
        MOSTRARMENUUSERADMIN:
            MENUUSUARIOQUEESADMINISTRADOR
            JMP Inicio
        MOSTRARMENUADMIN:
            MENUADMINISTRADOR
            JMP Inicio
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

    ;?☻ ===================== MAIN JUEGO ======================= ☻
    INICIODELJUEGO_ PROC NEAR
        PINTARPANTALLADEJUEGO
        MOV DI, 0
        esperaenter
        RANDOMPIECE
        MOV SI, TEMP
        MOV NEXTPIECE, 3
        GENFIGURA:
            PINTARBLOQUESTIESOS
            MOV DI, 0
            ELIMINARFILAS ;! SCAN SI HAY FILAS RELLENITAS XD
            MOV ROTACIONDEPIEZA, 0
            MOV BANDERATIESO,0  ; * SET flag de figura quieta
            MOV SI, NEXTPIECE ;* paso a actual la pieza que era la siguiente
            MOV TIPODEPIEZA, SI
            ;! GENERO LA PIEZA Y GUARDO LA SIGUIENTE
            RANDOMPIECE ; * Genero la pieza siguiente para despues
            MOV SI, TEMP
            MOV NEXTPIECE, 3
            PINTARPIEZASIGUIENTE NEXTPIECE
            RANDOMPOSITION ;* Genero la posicion random de inicio

        whilee:
            MOV FLAGMOVELEFT,0
            MOV FLAGMOVERIGHT,0
            mov ah, 0Bh; * REVISAR SI TECLA FUE PRESIONADA
            int 21h
            cmp al, 0  ;* SI NO SE PRESIONA SIGUEWHILE
            je siguewhile
            moverbloque:
                xor ax, ax  ;* TOMO VALOR DE LA TECLA
                int 16h
                cmp al, 27  ;* ESC PARA PAUSAR
                je pauseGame
                cmp al, 32  ;* SPACE GIRAR PIEZA
                je ROTATEPIECE
                cmp ah, 4Bh  ;* MOVER IZQUIERDA
                je moveLeft
                cmp ah, 4Dh  ;* MOVER DERECHA
                je moveRight
                JMP siguewhile
            moveLeft:
                CMP POSXHANDLE, 0
                JE siguewhile  ;* si esta x=0 no puede moverse
                MOV FLAGMOVELEFT, 1
                jmp siguewhile

            moveRight:
                CMP POSXHANDLE, 7
                JE siguewhile  ;* si esta x=7 no puede moverse
                MOV FLAGMOVERIGHT, 1
                jmp siguewhile
            pauseGame:
                paint  0, 0, 800, 600, BLACK
                PAINTTEXT pause0 , 0B17H , WHITE
                PAINTTEXT pause1 , 2125H , 0FF30H
                PAINTTEXT pause2 , 2325H , 0FF30H
                pauseGame2:
                xor ax, ax  ;*ah = 0
                int 16h
                cmp al, 27  ;* ESC PARA GUARDAR PUNTOS Y MENU.
                JE GUARDAYMENU
                cmp ah, 83  ;* DEL PARA CONTINUAR
                JE  siguewhile
                jMP pauseGame2
            ROTATEPIECE:
                CMP ROTACIONDEPIEZA, 3
                JE RESTARTROTACION
                JNE INCROTACION
                RESTARTROTACION:
                    MOV ROTACIONDEPIEZA,0
                    JMP siguewhile
                INCROTACION:
                    INC ROTACIONDEPIEZA

            siguewhile: ; ? █▄▄▄█▄▄▄█▄▄▄█▄▄▄█ CREATE PIECE █▄▄▄█▄▄▄█▄▄▄█▄▄▄█
                UPDATEPIEZA  ;!UPDATE OF THE PIECE.
                CMP BANDERATIESO, 1  ;* SI ES 1 SIGUIENTE FIGURA
                JE GENFIGURA
                Delay speed
                INC DI
                inc timeaux
                mov dx, timeaux
                cmp dx, 50
                je nextLevel
                cmp dx, 15
                je nextLevel
                jmp whilee
            nextLevel:
                SUB speed, 0
                jmp whilee
            GUARDAYMENU:
                JMP SALIR

        SALIR:
        RET
    INICIODELJUEGO_ ENDP
    
    
    ;?☻ ▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀ CONTROL DE MATRICES FIGURAS ▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀ ☻
    UPDAPALITO_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        
        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        CMP auxpY4, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        
        ;! ██████████████ ROTACIONES ██████████████
        CMP ROTACIONDEPIEZA, 0
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 1
        JE POSICIONPIEZA1
        CMP ROTACIONDEPIEZA, 2
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 3
        JE POSICIONPIEZA1
        
        POSICIONPIEZA0:
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ VALIDAR LEFT RIGHT ▬▬▬▬▬▬▬▬▬▬▬▬
            CMP FLAGMOVERIGHT,1;! PRESIONO DERECHA
            JNE movleftlb
            JE VALIDARMOVERRIGHT
            VALIDARMOVERRIGHT:
                MOV FLAGMOVERIGHT,0
                mov CX, auxpX4
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpY4
                CMP TEMP, 0
                JE SIMOVRIGHT
                JNE movleftlb
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
                    mov CX, auxpX1
                    MOV TEMP2, CX
                    INC TEMP2
                    getAREADEJUEGO TEMP2, auxpY1
                    CMP TEMP, 0
                    JE SIMOVLEFT
                    JNE movleftlb
                    SIMOVLEFT:
                        DEC Xtemp
                        DEC POSXHANDLE
                        jmp sigoscan
                ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            sigoscan:
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|    ████████
            getAREADEJUEGO auxpX2, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY1    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX1, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            LIMPIARFRAMEANTERIOR
            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 1
            PAINTPOS auxpX1,auxpY1,LIGHT_GREEN

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 1
            PAINTPOS auxpX2,auxpY2,LIGHT_GREEN

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX3, CX
            MOV CX, Ytemp
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 1
            PAINTPOS auxpX3,auxpY3,LIGHT_GREEN

            MOV CX, Xtemp
            ADD CX, 3
            MOV auxpX4, CX
            MOV CX, Ytemp
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 1
            PAINTPOS auxpX4,auxpY4,LIGHT_GREEN
             JMP SALIRZ
        POSICIONPIEZA1:
            LEFTRIGHT_DECUATRO auxpX1,auxpY1,auxpX2,auxpY2,auxpX3,auxpY3,auxpX4, auxpY4
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY4                   ;!|//!    ██
            MOV TEMP2, CX
            INC TEMP2                           ;!|//!    ██
            getAREADEJUEGO auxpX4, TEMP2        ;!|//!    ██
            CMP TEMP, 0                         ;!|//!    ██
            JNE SEQUEDAKIETO;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            LIMPIARFRAMEANTERIOR
            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 1
            PAINTPOS auxpX1,auxpY1,LIGHT_GREEN

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 1
            PAINTPOS auxpX2,auxpY2,LIGHT_GREEN

            MOV CX, Xtemp
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 1
            PAINTPOS auxpX3,auxpY3,LIGHT_GREEN

            MOV CX, Xtemp
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 3
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 1
            PAINTPOS auxpX4,auxpY4,LIGHT_GREEN
             JMP SALIRZ
        JMP SALIRZ
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDAPALITO_ ENDP
    UPDATECUADRO_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        
        CMP auxpY2, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ VALIDAR LEFT RIGHT ▬▬▬▬▬▬▬▬▬▬▬▬
        CMP FLAGMOVERIGHT,1;! PRESIONO DERECHA
        JNE movleftlb
        JE VALIDARMOVERRIGHT
        VALIDARMOVERRIGHT:
            MOV FLAGMOVERIGHT,0
            MOV CX, auxpX3
            mov TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpY3
            CMP TEMP, 0
            JE SIMOVRIGHT1
            JNE movleftlb
            SIMOVRIGHT1:
                MOV CX, auxpX4
                mov TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpY3
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
            mov CX, auxpX4
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpY4
            CMP TEMP, 0
            JE SIMOVLEFT1
            JNE sigoscan
            SIMOVLEFT1:
                mov CX, auxpX4
                MOV TEMP2, CX
                INC TEMP2
                getAREADEJUEGO TEMP2, auxpY4
                CMP TEMP, 0
                JE SIMOVLEFT
                JNE sigoscan
            SIMOVLEFT:
                DEC Xtemp
                DEC POSXHANDLE
                jmp sigoscan
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
        
        sigoscan:

        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
        MOV CX, auxpY2                      ;!|//!      ████
        MOV TEMP2, CX                       ;!|//!      ████
        INC TEMP2                           ;!|
        getAREADEJUEGO auxpX2, TEMP2        ;!|
        CMP TEMP, 0                         ;!|
        JNE SEQUEDAKIETO                    ;!|
        MOV CX, auxpY4                      ;!|
        MOV TEMP2, CX
        INC TEMP2                           ;!|
        getAREADEJUEGO auxpX4, TEMP2        ;!|
        CMP TEMP, 0                         ;!|
        JNE SEQUEDAKIETO;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
        
        LIMPIARFRAMEANTERIOR
        MOV CX, Xtemp
        MOV auxpX1, CX
        MOV CX, Ytemp
        MOV auxpY1, CX
        setAREADEJUEGO auxpX1, auxpY1, 2
        PAINTPOS auxpX1,auxpY1,LIGHT_CYAN

        MOV CX, Xtemp
        MOV auxpX2, CX
        MOV CX, Ytemp
        ADD CX, 1
        MOV auxpY2, CX
        setAREADEJUEGO auxpX2, auxpY2, 2
        PAINTPOS auxpX2,auxpY2,LIGHT_CYAN

        MOV CX, Xtemp
        ADD CX, 1
        MOV auxpX3, CX
        MOV CX, Ytemp
        MOV auxpY3, CX
        setAREADEJUEGO auxpX3, auxpY3, 2
        PAINTPOS auxpX3,auxpY3,LIGHT_CYAN

        MOV CX, Xtemp
        ADD CX, 1
        MOV auxpX4, CX
        MOV CX, Ytemp
        ADD CX, 1
        MOV auxpY4, CX
        setAREADEJUEGO auxpX4, auxpY4, 2
        PAINTPOS auxpX4,auxpY4,LIGHT_CYAN
        JMP SALIRZ
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATECUADRO_ ENDP
    UPDATETE_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        
        ;! ██████████████ ROTACIONES ██████████████
        CMP ROTACIONDEPIEZA, 0
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 1
        JE POSICIONPIEZA1
        CMP ROTACIONDEPIEZA, 2
        JE POSICIONPIEZA2
        CMP ROTACIONDEPIEZA, 3
        JE POSICIONPIEZA3
        
        POSICIONPIEZA0:
            CMP auxpX1, -1
            JE CONTINUA1
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX1,auxpY1,auxpX4,auxpY4, auxpX1,auxpY1,auxpX2,auxpY2

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2
            MOV TEMP2, CX        ;! ----------  ;!|//!      ██
            INC TEMP2                           ;!|//!    ██████
            getAREADEJUEGO auxpX2, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            LIMPIARFRAMEANTERIOR

            CONTINUA1:
            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 3
            PAINTPOS auxpX1,auxpY1,LIGHT_RED

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 3
            PAINTPOS auxpX2,auxpY2,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 3
            PAINTPOS auxpX3,auxpY3,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 3
            PAINTPOS auxpX4,auxpY4,LIGHT_RED
            JMP SALIRZ
        POSICIONPIEZA1:
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY3, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX2,auxpY2,auxpX3,auxpY3
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY3
            MOV TEMP2, CX                       ;!|    ██
            INC TEMP2                           ;!|    ████
            getAREADEJUEGO auxpX3, TEMP2        ;!|    ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            MOV CX, auxpY4                   ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 3
            PAINTPOS auxpX1,auxpY1,LIGHT_RED

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 3
            PAINTPOS auxpX2,auxpY2,LIGHT_RED

            MOV CX, Xtemp
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 3
            PAINTPOS auxpX3,auxpY3,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 3
            PAINTPOS auxpX4,auxpY4,LIGHT_RED
             JMP SALIRZ
        POSICIONPIEZA2:
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX3,auxpY3,auxpX4,auxpY4,  auxpX1,auxpY1,auxpX4,auxpY4
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY1    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|//!    ██████
            getAREADEJUEGO auxpX1, TEMP2        ;!|//!      ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 3
            PAINTPOS auxpX1,auxpY1,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 3
            PAINTPOS auxpX2,auxpY2,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX3, CX
            MOV CX, Ytemp
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 3
            PAINTPOS auxpX3,auxpY3,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 3
            PAINTPOS auxpX4,auxpY4,LIGHT_RED
             JMP SALIRZ
        POSICIONPIEZA3:
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX2,auxpY2,auxpX4,auxpY4
            
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2
            MOV TEMP2, CX        ;! ----------  ;!|//!      ██
            INC TEMP2                           ;!|//!    ████
            getAREADEJUEGO auxpX2, TEMP2        ;!|//!      ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 3
            PAINTPOS auxpX1,auxpY1,LIGHT_RED

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 3
            PAINTPOS auxpX2,auxpY2,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 3
            PAINTPOS auxpX3,auxpY3,LIGHT_RED

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 3
            PAINTPOS auxpX4,auxpY4,LIGHT_RED
             JMP SALIRZ

        

        JMP SALIRZ
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATETE_ ENDP
    UPDATEELE1_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        
        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        CMP auxpY4, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        
        ;! ██████████████ ROTACIONES ██████████████
        CMP ROTACIONDEPIEZA, 0
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 1
        JE POSICIONPIEZA1
        CMP ROTACIONDEPIEZA, 2
        JE POSICIONPIEZA2
        CMP ROTACIONDEPIEZA, 3
        JE POSICIONPIEZA3
        
        POSICIONPIEZA0:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX2,auxpY2,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY1   
            MOV TEMP2, CX        ;! ----------  ;!|//!    ████
            INC TEMP2                           ;!|//!      ██
            getAREADEJUEGO auxpX1, TEMP2        ;!|         ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 4
            PAINTPOS auxpX1,auxpY1,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp            
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 4
            PAINTPOS auxpX2,auxpY2,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 4
            PAINTPOS auxpX3,auxpY3,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4,4
            PAINTPOS auxpX4,auxpY4,LIGHT_MAGENTA
             JMP SALIRZ
        POSICIONPIEZA1:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX1,auxpY1,auxpX4,auxpY4, auxpX1,auxpY1,auxpX2,auxpY2

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2    ;! ----------  ;!|//!       ██
            MOV TEMP2, CX                       ;!|//!    ██████
            INC TEMP2    
            getAREADEJUEGO auxpX2, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 4
            PAINTPOS auxpX1,auxpY1,LIGHT_MAGENTA

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 4
            PAINTPOS auxpX2,auxpY2,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3,4
            PAINTPOS auxpX3,auxpY3,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4,4
            PAINTPOS auxpX4,auxpY4,LIGHT_MAGENTA
             JMP SALIRZ
        POSICIONPIEZA2:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX2,auxpY2,auxpX1,auxpY1,auxpX4,auxpY4,auxpX1,auxpY1,auxpX2,auxpY2,auxpX3,auxpY3
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|//!    ██
            getAREADEJUEGO auxpX3, TEMP2        ;!|//!    ██
            CMP TEMP, 0                         ;!|//!    ████
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 4
            PAINTPOS auxpX1,auxpY1,LIGHT_MAGENTA

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2,4
            PAINTPOS auxpX2,auxpY2,LIGHT_MAGENTA

            MOV CX, Xtemp
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3,4
            PAINTPOS auxpX3,auxpY3,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4,4
            PAINTPOS auxpX4,auxpY4,LIGHT_MAGENTA
             JMP SALIRZ
        POSICIONPIEZA3:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX3,auxpY3,auxpX4,auxpY4, auxpX1,auxpY1,auxpX4,auxpY4

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2    ;! ----------  ;!|//!    ██████
            MOV TEMP2, CX                        ;!|//!    ██
            INC TEMP2    
            getAREADEJUEGO auxpX2, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 4
            PAINTPOS auxpX1,auxpY1,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 4
            PAINTPOS auxpX2,auxpY2,LIGHT_MAGENTA

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX3, CX
            MOV CX, Ytemp
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 4
            PAINTPOS auxpX3,auxpY3,LIGHT_MAGENTA

            MOV CX, Xtemp
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 4
            PAINTPOS auxpX4,auxpY4,LIGHT_MAGENTA
             JMP SALIRZ
        JMP SALIRZ
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATEELE1_ ENDP
    UPDATEELE2_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        CMP auxpY4, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        
        
        ;! ██████████████ ROTACIONES ██████████████
        CMP ROTACIONDEPIEZA, 0
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 1
        JE POSICIONPIEZA1
        CMP ROTACIONDEPIEZA, 2
        JE POSICIONPIEZA2
        CMP ROTACIONDEPIEZA, 3
        JE POSICIONPIEZA3
        
        POSICIONPIEZA0:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX2,auxpY2,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY1
            MOV TEMP2, CX      ;! ----------    ;!|       ████
            INC TEMP2                           ;!|         ██
            getAREADEJUEGO auxpX1, TEMP2        ;!|         ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1,5
            PAINTPOS auxpX1,auxpY1,YELLOW

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2,5
            PAINTPOS auxpX2,auxpY2,YELLOW

            MOV CX, Xtemp
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3,5
            PAINTPOS auxpX3,auxpY3,YELLOW

            MOV CX, Xtemp
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4,5
            PAINTPOS auxpX4,auxpY4,YELLOW
             JMP SALIRZ
        POSICIONPIEZA1:
            
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX3,auxpY3,auxpX4,auxpY4, auxpX1,auxpY1,auxpX4,auxpY4

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|//!    ██████
            getAREADEJUEGO auxpX2, TEMP2        ;!|//!        ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY1    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX1, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 5
            PAINTPOS auxpX1,auxpY1,YELLOW

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2,5
            PAINTPOS auxpX2,auxpY2,YELLOW

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX3, CX
            MOV CX, Ytemp
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3,5
            PAINTPOS auxpX3,auxpY3,YELLOW

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4,5
            PAINTPOS auxpX4,auxpY4,YELLOW
             JMP SALIRZ
        POSICIONPIEZA2:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX2,auxpY2,auxpX1,auxpY1,auxpX4,auxpY4,auxpX1,auxpY1,auxpX2,auxpY2,auxpX3,auxpY3

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|//!    ██
            getAREADEJUEGO auxpX3, TEMP2        ;!|//!    ██
            CMP TEMP, 0                         ;!|//!  ████
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1,5
            PAINTPOS auxpX1,auxpY1,YELLOW

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2,5
            PAINTPOS auxpX2,auxpY2,YELLOW

            MOV CX, Xtemp
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 5
            PAINTPOS auxpX3,auxpY3,YELLOW

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4,5
            PAINTPOS auxpX4,auxpY4,YELLOW
             JMP SALIRZ
        POSICIONPIEZA3:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX1,auxpY1,auxpX4,auxpY4, auxpX1,auxpY1,auxpX2,auxpY2

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!| //!    ██
            getAREADEJUEGO auxpX2, TEMP2        ;!  //!    ██████
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 5
            PAINTPOS auxpX1,auxpY1,YELLOW

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 5
            PAINTPOS auxpX2,auxpY2,YELLOW

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 5
            PAINTPOS auxpX3,auxpY3,YELLOW

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 5
            PAINTPOS auxpX4,auxpY4,YELLOW
             JMP SALIRZ
        JMP SALIRZ
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATEELE2_ ENDP
    UPDATEZETA1_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        
        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        CMP auxpY4, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        
        ;! ██████████████ ROTACIONES ██████████████
        CMP ROTACIONDEPIEZA, 0
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 1
        JE POSICIONPIEZA1
        CMP ROTACIONDEPIEZA, 2
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 3
        JE POSICIONPIEZA1
        
        POSICIONPIEZA0:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX2,auxpY2,auxpX4,auxpY4, auxpX1,auxpY1,auxpX3,auxpY3

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2
            MOV TEMP2, CX        ;! ----------  ;!|//!    ████
            INC TEMP2                           ;!|//!  ████
            getAREADEJUEGO auxpX2, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 6
            PAINTPOS auxpX1,auxpY1,LIGHT_GRAY

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 6
            PAINTPOS auxpX2,auxpY2,LIGHT_GRAY

            MOV CX, Xtemp
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 6
            PAINTPOS auxpX3,auxpY3,LIGHT_GRAY

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 6
            PAINTPOS auxpX4,auxpY4,LIGHT_GRAY
            JMP SALIRZ
        POSICIONPIEZA1:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX2,auxpY2,auxpX4,auxpY4
            
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2
            MOV TEMP2, CX        ;! ----------  ;!|//!    ██
            INC TEMP2                           ;!|//!    ████
            getAREADEJUEGO auxpX2, TEMP2        ;!|//!      ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4       ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 6
            PAINTPOS auxpX1,auxpY1,LIGHT_GRAY

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 6
            PAINTPOS auxpX2,auxpY2,LIGHT_GRAY

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 6
            PAINTPOS auxpX3,auxpY3,LIGHT_GRAY

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 6
            PAINTPOS auxpX4,auxpY4,LIGHT_GRAY
             JMP SALIRZ
        
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATEZETA1_ ENDP
    UPDATEZETA2_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 5 = X
        
        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        CMP auxpY4, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        
        ;! ██████████████ ROTACIONES ██████████████
        CMP ROTACIONDEPIEZA, 0
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 1
        JE POSICIONPIEZA1
        CMP ROTACIONDEPIEZA, 2
        JE POSICIONPIEZA0
        CMP ROTACIONDEPIEZA, 3
        JE POSICIONPIEZA1
        
        POSICIONPIEZA0:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS auxpX2,auxpY2,auxpX4,auxpY4, auxpX1,auxpY1,auxpX3,auxpY3

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY1
            MOV TEMP2, CX        ;! ----------  ;!|//!    ████
            INC TEMP2                           ;!|//!      ████
            getAREADEJUEGO auxpX1, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY3    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX3, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 7
            PAINTPOS auxpX1,auxpY1,BROWN

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX2, CX
            MOV CX, Ytemp
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 7
            PAINTPOS auxpX2,auxpY2,BROWN

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 7
            PAINTPOS auxpX3,auxpY3,BROWN

            MOV CX, Xtemp
            ADD CX, 2
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 7
            PAINTPOS auxpX4,auxpY4,BROWN
             JMP SALIRZ
        POSICIONPIEZA1:
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX2,auxpY2,auxpX4,auxpY4
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY3 
            MOV TEMP2, CX        ;! ----------  ;!|//!      ██
            INC TEMP2                           ;!|//!    ████
            getAREADEJUEGO auxpX3, TEMP2        ;!|//!    ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            LIMPIARFRAMEANTERIOR

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX1, CX
            MOV CX, Ytemp
            MOV auxpY1, CX
            setAREADEJUEGO auxpX1, auxpY1, 7
            PAINTPOS auxpX1,auxpY1,BROWN

            MOV CX, Xtemp
            MOV auxpX2, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY2, CX
            setAREADEJUEGO auxpX2, auxpY2, 7
            PAINTPOS auxpX2,auxpY2,BROWN

            MOV CX, Xtemp
            ADD CX, 1
            MOV auxpX3, CX
            MOV CX, Ytemp
            ADD CX, 1
            MOV auxpY3, CX
            setAREADEJUEGO auxpX3, auxpY3, 7
            PAINTPOS auxpX3,auxpY3,BROWN

            MOV CX, Xtemp
            MOV auxpX4, CX
            MOV CX, Ytemp
            ADD CX, 2
            MOV auxpY4, CX
            setAREADEJUEGO auxpX4, auxpY4, 7
            PAINTPOS auxpX4,auxpY4,BROWN
             JMP SALIRZ
        
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATEZETA2_ ENDP
    UPDATEESPECIAL_ PROC NEAR
        ;* SIEMPRE INICIARAN EN LA FILA 0 = Y
        ;* VARIAR COLUMNA DE 0 A 7 = X
        
        CMP auxpY1, 15  ;* sI LLEGO AL FONDO
        JE SEQUEDAKIETO
        ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ VALIDAR LEFT RIGHT ▬▬▬▬▬▬▬▬▬▬▬▬
        CMP FLAGMOVERIGHT,1;! PRESIONO DERECHA
        JNE movleftlb
        JE VALIDARMOVERRIGHT
        VALIDARMOVERRIGHT:

            POSX_IS 7
            CMP TEMP2, 1
            JE sigoscan


            MOV FLAGMOVERIGHT,0
            MOV CX, auxpX1
            mov TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpY1
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
            mov CX, auxpX1
            MOV TEMP2, CX
            INC TEMP2
            getAREADEJUEGO TEMP2, auxpY1
            CMP TEMP, 0
            JE SIMOVLEFT
            JNE sigoscan
            SIMOVLEFT:
                DEC Xtemp
                DEC POSXHANDLE
                jmp sigoscan
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
        
        sigoscan:

        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
        ESCANEODECOLUMNA
        CMP TEMP2, 1
        JE SEQUEDAKIETO
        
        LIMPIARFRAMEANTERIORESPECIAL

        MOV CX, Xtemp
        MOV auxpX1, CX
        MOV CX, Ytemp
        MOV auxpY1, CX
        setAREADEJUEGO auxpX1, auxpY1, 8
        PAINTPOS auxpX1,auxpY1,WHITE

        JMP SALIRZ
        SEQUEDAKIETO:
            RESETAUXSBLOQUES ;! PARA QUE NO SE BORRE Y QUEDE ALLI EN 
            MOV BANDERATIESO,1          ;! LA MATRIZ PLASMADOS
        SALIRZ:
        RET
    UPDATEESPECIAL_ ENDP
    ;?☻ ▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀▀▄▀
    
    ;?☻ ============= VALIDACIONES DEL JUEGO ========== ☻
    ELIMINARFILAS_ PROC NEAR
        MOV SI, 0
        FORI:
            CMP SI, 16
            JE SALIR
            VALIDARFILALLENA SI
            CMP TEMP,1
            JE CORRERFILALABEL
            JNE SALTAR
            CORRERFILALABEL:
                CORRERFILA
            SALTAR:
                inc si
                JMP FORI
        SALIR:
        RET
    ELIMINARFILAS_ ENDP
    VALIDARFILALLENA_ PROC NEAR
        MOV TEMP2, 0
        MOV DI, 0
        FORJ:
            CMP DI, 8
            JE VALIDAR
            getAREADEJUEGO di, TEMP3
            CMP TEMP,0
            JE SUMONO ;* si hay cero no sumo
            SUMOSI:
                INC TEMP2
            SUMONO:
                inc DI
                JMP FORJ
        VALIDAR:
            CMP TEMP2, 8
            JE SIESTALLENO
            JNE NOSTALLENO
            SIESTALLENO:
                MOV TEMP,1
                JMP SALIR
            NOSTALLENO:
                MOV TEMP, 0
        SALIR:
        RET
    VALIDARFILALLENA_ ENDP
    CORRERFILA_ PROC NEAR
        MOV SI, 14  ; ! FILAS
        FORI:
            MOV DI, 0   ;! COLUMNAS
            CMP SI, -1
            JE SALIR

                FORJ:
                    CMP DI, 8
                    JE SALIR2
                    ;* TOMO VALOR de fila anterior y paso a fila actual
                    MOV TEMP2, SI
                    INC TEMP2

                    getAREADEJUEGO DI, SI
                    setAREADEJUEGO DI, TEMP2, TEMP ; !set dato en la fila posterior
                    PINTARUNIT  DI,TEMP2, TEMP
                    SALTAR2:
                        inc DI
                        JMP FORJ
                SALIR2:
            SALTAR:
                dec si
                JMP FORI
        SALIR:
        RET
    CORRERFILA_ ENDP
    ESCANEODECOLUMNA_ PROC NEAR
        ;* POSXHANDLE ES CONSTANTE AKI   === auxpX1
        ;? RECORRO DESDE auxpY1 hasta 15
        MOV DI, auxpY1
        MOV TEMP2,0
        FORJ:
            CMP DI, 16
            JE VALIDAR
            INC DI
            getAREADEJUEGO auxpX1, DI
            CMP TEMP,0
            JE AUMENTVACIO ;* si hay cero no sumo
            JMP FORJ
            AUMENTVACIO:
                INC TEMP2
            JMP FORJ
        VALIDAR:
            CMP TEMP2, 0 ;* SI ES 0 SE QUEDA KIETO
            JE SIESTALLENO
            JNE NOESTALLENO
            NOESTALLENO:
                MOV TEMP2,0
                JMP SALIR
            SIESTALLENO:
                MOV TEMP2,1
        SALIR:
        RET
    ESCANEODECOLUMNA_ ENDP
    PINTARBLOQUESTIESOS_ PROC NEAR
        MOV SI, 0  ; ! FILAS
        FORI:
            MOV DI, 0   ;! COLUMNAS
            CMP SI, 16
            JE SALIR
                FORJ:
                    CMP DI, 8
                    JE SALIR2
                    getAREADEJUEGO DI, SI
                    PINTARUNIT DI, SI, TEMP
                    SALTAR2:
                        inc DI
                        JMP FORJ
                SALIR2:
            SALTAR:
                INC SI
                JMP FORI
        SALIR:
        RET
    PINTARBLOQUESTIESOS_ endp










    ;?☻ ===================== MENUS  ======================= ☻
    MENUADMINISTRADOR_ PROC NEAR
        Inicio:
            paint  0, 0, 800, 600, BLACK ;*LIMPIA TODO MODO VIDEO:V
            PAINTTEXT tAD1 , 0620H , LIGHT_GREEN ; ! SETEO LOS TEXTOS
            PAINTTEXT tAD2 , 0910h , 0FF0FH
            PAINTTEXT tAD3 , 0B10H , 0FF0FH
            PAINTTEXT tAD4 , 0D10H , 0FF0FH
            PAINTTEXT tAD5 , 0F10h , 0FF0FH
            PAINTTEXT tAD6 , 1110H , 0FF0FH
            PAINTTEXT tAD7 , 1310H , 0FF0FH
            PAINTTEXT tAD8 , 1510H , 0FF0FH
            MOV AH, 0 ;Wait for keystroke and read
            INT 16H
            CMP AH,3BH     ;* si tecla es F1
            JE DESBLOQUEARLB     ;*           SE VA A DESBLOQUEAR
            CMP AH,3CH     ;* si tecla es F2
            JE PROMOVERLB   ;*           SE VA A PROMOVER
            CMP AH,3DH     ;* si tecla es F3
            JE DegradarLB   ;*           SE VA A Degradar
            CMP AH,3EH     ;* si tecla es F4
            JE BubbleSortLB   ;*           SE VA A Bubble Sort
            CMP AH,3FH     ;* si tecla es F5
            JE HeapSortLB   ;*           SE VA A Heap Sort
            CMP AH,40H     ;* si tecla es F6
            JE QuickSortLB   ;*           SE VA A Quick Sort
            CMP AH,44H     ;* si tecla es F10
            JE FIN   ;*           SE VA A CERRAR
            JNE Inicio
        DESBLOQUEARLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            DESBLOQUEAR
            JMP Inicio
        PROMOVERLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            PROMOVER
            JMP Inicio
        DegradarLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            DEGRADAR
            JMP Inicio
        BubbleSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            BUBBLESORT
            JMP Inicio
        HeapSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            HEAPSORT
            JMP Inicio
        QuickSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            QUICKSORT
            JMP Inicio
        FIN:
        RET
    MENUADMINISTRADOR_ ENDP
    MENUUSUARIOQUEESADMINISTRADOR_ PROC NEAR
        Inicio:
            paint  0, 0, 800, 600, BLACK ;*LIMPIA TODO MODO VIDEO:V
            PAINTTEXT tAD1 , 0620H , LIGHT_GREEN ; ! SETEO LOS TEXTOS
            PAINTTEXT tAD2 , 0910h , 0FF0FH
            PAINTTEXT tAD10 , 0B10H , 0FF0FH
            PAINTTEXT tAD11 , 0D10H , 0FF0FH
            PAINTTEXT tAD5 , 0F10h , 0FF0FH
            PAINTTEXT tAD6 , 1110H , 0FF0FH
            PAINTTEXT tAD7 , 1310H , 0FF0FH
            PAINTTEXT tAD12 , 1510H , 0FF0FH
            PAINTTEXT tAD8 , 1710H , 0FF0FH
            MOV AH, 0 ;Wait for keystroke and read
            INT 16H
            CMP AH,3BH     ;* si tecla es F1
            JE DESBLOQUEARLB     ;*           SE VA A DESBLOQUEAR
            CMP AH,3CH     ;* si tecla es F2
            JE TOPGEN   ;*           SE VA A TOP 10 GENERAL
            CMP AH,3DH     ;* si tecla es F3
            JE TOPUSER   ;*           SE VA A TOP 10 DEL USER
            CMP AH,3EH     ;* si tecla es F4
            JE BubbleSortLB   ;*           SE VA A Bubble Sort
            CMP AH,3FH     ;* si tecla es F5
            JE HeapSortLB   ;*           SE VA A Heap Sort
            CMP AH,40H     ;* si tecla es F6
            JE QuickSortLB   ;*           SE VA A Quick Sort
            CMP AH,41H     ;* si tecla es F7
            JE JUGARRRR   ;*           SE VA A JUGARRRR
            CMP AH,44H     ;* si tecla es F10
            JE FIN   ;*           SE VA A CERRAR
            JNE Inicio
        DESBLOQUEARLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            DESBLOQUEAR
            JMP Inicio
        TOPGEN:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            TOP10GENERAL
            JMP Inicio
        TOPUSER:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            TOP10USUARIO
            JMP Inicio
        BubbleSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            BUBBLESORT
            JMP Inicio
        HeapSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            HEAPSORT
            JMP Inicio
        QuickSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            QUICKSORT
            JMP Inicio
        JUGARRRR:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            INICIODELJUEGO
            JMP Inicio
        FIN:
        RET
    MENUUSUARIOQUEESADMINISTRADOR_ ENDP
    MENUUSUARIO_ PROC NEAR
        Inicio:
            paint  0, 0, 800, 600, BLACK ;*LIMPIA TODO MODO VIDEO:V
            PAINTTEXT tu1 , 0620H , LIGHT_GREEN ; ! SETEO LOS TEXTOS
            PAINTTEXT MYuserName , 0910h , 0FF0FH
            PAINTTEXT tu4 , 0B10H , 0FF0FH
            PAINTTEXT tu2 , 0D10H , 0FF0FH
            PAINTTEXT tu3 , 0F10h , 0FF0FH
            PAINTTEXT tAD8 , 1110H , 0FF0FH
            MOV AH, 0 ;Wait for keystroke and read
            INT 16H
            CMP AH,3DH     ;* si tecla es F3
            JE JUGARRRR   ;*           SE VA A JUGARRR RRRR
            CMP AH,3EH     ;* si tecla es F4
            JE TOPGEN   ;*           SE VA A TOP 10 GENERAL
            CMP AH,3FH     ;* si tecla es F5
            JE TOPUSER   ;*           SE VA A TOP 10 USER
            CMP AH,44H     ;* si tecla es F10
            JE FIN   ;*           SE VA A CERRAR
            JNE Inicio
        TOPGEN:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            TOP10GENERAL
            JMP Inicio
        TOPUSER:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            TOP10USUARIO
            JMP Inicio
        JUGARRRR:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            INICIODELJUEGO
            JMP Inicio
        FIN:
        RET
    MENUUSUARIO_ ENDP
    
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
        MOV BX, POSTOSET
        Mov AREADEJUEGO[SI],BX; finalmente movemos el dato.  Es importante lo de word ptr para indicar el tamaño
        ; printnum RESULTADOPRINT, AX
        ; print RESULTADOPRINT
        ; print saltolinea
        RET
    setAREADEJUEGO_ ENDP
    getAREADEJUEGO_ PROC NEAR
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
        MOV DI, AREADEJUEGO[SI]
        MOV TEMP, DI
        RET
    getAREADEJUEGO_ ENDP
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
        PAINTTEXT tb2 , 1010h , 0FF0FH
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
        DRAW_RECTANGLE 468,144,664, 144+18, CYAN    ;! MARCO ARRIBA
        DRAW_RECTANGLE 468,144,468+18, 500, CYAN    ;! MARCO IZQUIERDA
        DRAW_RECTANGLE 468,500-18,656, 500, CYAN    ;! MARCO ABAJO
        DRAW_RECTANGLE 664-18,144,664, 500, CYAN    ;! MARCO DERECHA
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
        DRAW_RECTANGLE  486, 162, 646, 482, BLUE
        PINTARCUADRO 684,162
        PINTARPALITO 720, 72
        PINTARTE 710,216
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
    ; UPDATEZETA2_ PROC FAR
    ;     RET
    ; UPDATEZETA2_ ENDP
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

    HEAPSORT_ PROC NEAR
        ;*    /* sorts the given array of n size */
        ;*    void heapsort(int* arr, int n)
        ;*    {
        ;*        // build the binary max heap
        ;*        for (int i = n / 2 - 1; i >= 0; i--)
        ;*        {
        ;*            heapify(arr, n, i);
        ;*        }
        ;*        // sort the max heap
        ;*        for (int i = n - 1; i >= 0; i--)
        ;*        {
        ;*            // swap the root node and the last leaf node
        ;*            int temp = arr[i];
        ;*            arr[i] = arr[0];
        ;*            arr[0] = temp;
        ;*            // again heapify the max heap from the root
        ;*            heapify(arr, i, 0);
        ;*        }
        ;*    }
        RET
    HEAPSORT_ ENDP
    
    HEAPIFY_ PROC NEAR
        ;*    void heapify(int* arr, int n, int i)
        ;*    {
        ;*        // store largest as the root element
        ;*        int largest = i;
        ;*        int left = 2 * i + 1;
        ;*        int right  = 2 * i + 2;
        ;*        // now check whether the right and left right is larger than the root or not
        ;*        if (left < n && arr[left] > arr[largest])
        ;*        {
        ;*            largest = left;
        ;*        }
        ;*        if (right < n && arr[right] > arr[largest])
        ;*        {
        ;*            largest = right;
        ;*        }
        ;*        // if the root is smaller than the children then swap it with the largest children's value
        ;*        if (largest != i)
        ;*        {
        ;*            int temp = arr[i];
        ;*            arr[i] = arr[largest];
        ;*            arr[largest] = temp;
        ;*            // again heapify that side of the heap where the root has gone
        ;*            heapify(arr, n, largest);
        ;*        }
        ;*    }
        RET
    HEAPIFY_ ENDP


    QUICKSORT_ PROC NEAR
        RET
    QUICKSORT_ ENDP
    ;!  █▀█ █▀▀ █▀█ █▀█ █▀█ ▀█▀ █▀
    ;!  █▀▄ ██▄ █▀▀ █▄█ █▀▄ ░█░ ▄█☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻ GENERACION DE REPORTES
    ;! TOP TEN
    TOP10GENERAL_ PROC NEAR
        RET
    TOP10GENERAL_ ENDP
    TOP10USUARIO_ PROC NEAR
        RET
    TOP10USUARIO_ ENDP
    ; TOP10GENERAL_ PROC NEAR
    ;     RET
    ; TOP10GENERAL_ ENDP
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



;! ANEXOS
;*  HEAPSORT     Algorithm      BASE:

;*    /* sorts the given array of n size */
;*    void heapsort(int* arr, int n)
;*    {
;*        // build the binary max heap
;*        for (int i = n / 2 - 1; i >= 0; i--)
;*        {
;*            heapify(arr, n, i);
;*        }
;*        // sort the max heap
;*        for (int i = n - 1; i >= 0; i--)
;*        {
;*            // swap the root node and the last leaf node
;*            int temp = arr[i];
;*            arr[i] = arr[0];
;*            arr[0] = temp;
;*            // again heapify the max heap from the root
;*            heapify(arr, i, 0);
;*        }
;*    }
;*    /* heapify the subtree with root i */
;*    void heapify(int* arr, int n, int i)
;*    {
;*        // store largest as the root element
;*        int largest = i;
;*        int left = 2 * i + 1;
;*        int right  = 2 * i + 2;
;*        // now check whether the right and left right is larger than the root or not
;*        if (left < n && arr[left] > arr[largest])
;*        {
;*            largest = left;
;*        }
;*        if (right < n && arr[right] > arr[largest])
;*        {
;*            largest = right;
;*        }
;*        // if the root is smaller than the children then swap it with the largest children's value
;*        if (largest != i)
;*        {
;*            int temp = arr[i];
;*            arr[i] = arr[largest];
;*            arr[largest] = temp;
;*            // again heapify that side of the heap where the root has gone
;*            heapify(arr, n, largest);
;*        }
;*    }



; A:
; MOV AH, 00h  ; interrupcion para jalar el tiempo en el sistema
;             INT 1AH      ; CX:DX  toma numeros del reloj desde medianoche
;             mov  ax, dx
;             xor  dx, dx
;             mov  cx, 6
;             div  cx       ;DX tiene la divicion en mi caso - de 0 a 5
;             add  dl, '0'  ; DL TIENE EL VALOR ENTRE 0 Y 5
;             mov ah,2h
;             int 21h    
;             JMP A