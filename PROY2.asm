
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
        ingpath         db "Ingrese la ruta path del archivo:", 10, 13, "$"
        EXITO           db "EXITO. ARCHIVO GUARDADO CON EXITO CARPETA BIN", 10, 13, "$"
        overflow        db 00h
        numberF         dB ?
        txLOGIN         DB "LOGIN$"
        txLOGUP         DB "REGISTRAR USUARIO$"
        txUSUARIO       DB "USUARIO: $"
        txCONTRASENA    DB "CONTRASENA: $"
        ADMINCREDUSER   DB "202000194AADM"
        ADMINCREDPASS   DB "491000202"
        savedmessage    DB   'USUARIO GUARDADO SATISFACTORIAMENTE :)', "$"
        savedmessage2    DB   'PUNTOS GUARDADOS SATISFACTORIAMENTE :)', "$"
        msgyaesadmin    DB 'NO PUEDE PROMOVER YA ES UN ADMINISTRADOR', "$"
        msgpromovido    DB 'USUARIO PROMOVIDO AHORA ES UN PRO ;v', "$"
        msgdegradado    DB 'USUARIO DEGRADADO AHORA ES UN ESCLAVO ;v', "$"
        msgbloqueado    DB 'USUARIO BLOQUEADO POR INTENTOS FALLIDOS', "$"
        msgyaesnormal   DB 'NO SE PUEDE DEGRADAR YA ES UN USUARIO NORMAL', "$"
        msgestaunlock   DB 'EL USUARIO ESTA DESBLOQUEADO', "$"
        msgestalock     DB 'EL USUARIO YA ESTA BLOQUEADO', "$"
        msgUSERTOPROMOVE DB 'DIGITE EL USUARIO A PROMOVER', "$"
        msgUSERTODEGRADE DB 'DIGITE EL USUARIO A DEGRADAR', "$"
        msgUSERTOUNLOCK     DB 'DIGITE EL USUARIO A DESBLOQUEAR', "$"
        msguserguardado     DB 'USUARIO GUARDADO SATISFACTORIAMENTE!', "$"
        msgsesioniniciadasatisf DB 'SESION INICIADA SATISFACTORIAMENTE!', "$"
        msgFIGSIGUIENTE DB 'FIGURA SIGUIENTE', "$"
        pause0          DB '------------------- PAUSA ---------------------', "$"
        BORRAR          DB '                                               ', "$"
        pause1          DB 'ESC = para guardar SCORE y salir al MENU', "$"
        pause2          DB 'DEL = para continuar el JUEGO', "$"
        msgUSUARIO          DB 'USUARIO : ', "$"
        msgSENTIDO          DB 'SENTIDO : ', "$"
        msgMETRICA          DB 'METRICA : ', "$"
        msgVELOCIDAD          DB 'VELOCIDAD : ', "$"
        msgSENTIDOP        DB '(1 = ASC, 0 = DESC) ', "$"
        msgMETRICAP        DB '(T = TIEMPO, P = PUNTEO) ', "$"
        msgVELOCIDADP          DB 'Rango desde 0 ', "$"
        msgNIVEL          DB 'NIVEL : ', "$"
        msgPUNTEO          DB 'PUNTEO : ', "$"
        msgTIEMPO          DB 'TIEMPO : ', "$"
        numtopten          DB 'No.', "$"
        usrtopten          DB 'USUARIO ', "$"
        puntostopten          DB 'PUNTUACION ', "$"
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
        Filenamejug1      db  'Rep.xml'
        handlerentrada    dw ?
        handler           dw ?
        handler2          dw ?
        USERSTET          DB "users.tet",0
        REPSORTREP        DB "REPSORT.rep",0
        punttet           DB "punt.tet",0
        hour              db "00", "$"
        min               db "00", "$"
        sec               db "00", "$"
        mes               db "00", "$"
        dia               db "00", "$"
        CERON               db "0", "$"
        SI_SIMULADO       DW 0
        DI_SIMULADO       DW 0
        SI_SIMULADO2      DW 0
        DI_SIMULADO2      DW 0
        tamfile           DW 0
        TEMP              DW 0
        TEMP2             DW 0
        TEMP3             DW 0
        TEMP4             DW 0
        PIVOTAZO             DW 0
        TEMPDB            Db "0$"
        dospuntos         Db ":$"
        TEMPDB2           DB  4 dup ('$')
        nuevalinea        db 10,'$'
        cooldowncont      dw 0
    ;? ------------------------BUBBLESORT VARIABLES------------------------
        buferdedatos          db 1000 dup('$')
        listestadistic          dw 2000 dup('$')
        indexbbsort             DW 0000
        RESULTADOPRINT          dw 00h, '$'
        izq   DB 0
        der   DB 0
        titlebb          DB '-*-*-*-*-*-*-*-*-*-* BUBBLE SORT -*-*-*-*-*-*-*-*-*-*', "$"
        titleqs          DB '-*-*-*-*-*-*-*-*-*-* QUICK SORT -*-*-*-*-*-*-*-*-*-* ', "$"
        titlehs          DB '-*-*-*-*-*-*-*-*-*-* HEAP SORT -*-*-*-*-*-*-*-*-*-* ', "$"
        titletopuser     DB '-*-*-*-*-*-*-*-*-* TOP 10 USUARIO -*-*-*-*-*-*-*-*-* ', "$"
        titletopgeneral  DB '-*-*-*-*-*-*-*-*-* TOP 10 GENERAL -*-*-*-*-*-*-*-*-* ', "$"
        strSENTIDO          DB      "0$"
        strMETRICA          DB      "T$"
        FLECHA              DB      "<-$"
        strVELOCIDAD        DB      4 dup ('$')
        intVELODIDAD        DW      0
        NN        DW      0
        bci        DW      0
        JOTA2        DW      0
        JOTA3        DW      0
        II        DW      0
        ELE        DW      0
        ERE        DW      0
        LARGEST        DW      0

    ;!-------------------------- VAR DEL JUEGO --------------------------
        Xtemp               DW      ?
        Ytemp               DW      ?
        X2temp              DW      ?
        Y2temp              DW      ?
        Xaux1               DW      ?    ;* posiciones de paint
        Yaux1               DW      ?
        Xaux2               DW      ?
        Yaux2               DW      ?
        Xtempauxaux         DW      ?
        Ytempauxaux         DW      ?
        setPOSX             DW      ? ;* PARA COORDENADAS EN MATRICES
        setPOSY             DW      ?
        coloraux            DB      ? ;* coloar auxiliar cuadro
        AREADEJUEGO         DW 560 DUP(0)
        SCORES_LIST         DW 500 dup('$') ;* GUARDA LOS PUNTAJES GENERALES
        TIMES_LIST          DW 500 dup('$') ;* GUARDA LOS PUNTAJES GENERALES
        ID_LIST             DW 500 dup('$') ;* GUARDA ID PARA DESPUES TOMAR EL PUNTEO DEL USER
        POS_ID              DW 0
        POS_TIME            DW 0
        POS_SCORE           DW 0
        
        INDEXX              Dw ?
        INDEXX2              Dw ?
        INDEXX3              Dw ?
        INDEX               Dw ?
        INDEXtemp           Dw ?

        MYuserPass          db 20 dup ('$') ; ! USUARIO Y CONTRASENA
        MYuserName          db 15 dup ('$')
        MYauxUserName       db 15 dup ('$')
        MYauxUserName2      db 15 dup ('$')
        MYauxPass           db 20 dup ('$')
        sTRINGCONTADORUSERS           db 6 dup ('$')
        CONTADORUSERS           DW 1
        CATEGORIA            DB      "0$"
        BLOQUEO              DB      "0$"
        SCORE                DW      0
        Stringpuntos         DB      4 dup ('$')
        RESULTADOPREVIO      DW     0
        StringRESULTADOPREVIO  DB      4 dup ('$')
        NIVEL                DW      1
        Stringnivel          DB      "1$"
        ;! VELOCIDAD DEL JUEGO
        speed                DW      1000
        timeaux              DW      0
        FLAG_SABER_SIROTO    DW      0
        SIPINTO              DW      0
        DESDEDONDE_CORRER    DW      0

        auxpX1               DW -1       ; * AUXILIARES PARA POSICION ANTERIOR (FRAMES PERDIDOS)
        auxpX2               DW -1
        auxpX3               DW -1
        auxpX4               DW -1
        auxpY1               DW -1
        auxpY2               DW -1
        auxpY3               DW -1
        auxpY4               DW -1
        pivot                DW 0
        BANDERATIESO        DW 0
        POSTOSET            DW 0
        POSXHANDLE          DW 0  ;* POSICION HORIZONTAL DE LA PIEZA
        TIPODEPIEZA         DW 0 ;* HANDLER DEL TIPO DE PIEZA
        NEXTPIECE           DW 0
        ROTACIONDEPIEZA     DW 0 ;* HANDLER DE LA ROTACION DE LA PIEZA
        FLAGMOVERIGHT       DW 0
        FLAGMOVELEFT        DW 0
        TEMPAUXI        DW 0
        NUMIZQ          dw 00h  ;! numero izquierdo ya parseado
        NUMDER          dw 00h  ;! numero derecho ya parseado
        lowmin          dw 0
        highmax         dw 0
        lowminAUX         dw 0
        highmaxAUX         dw 0
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
        ; TOP10GENERAL
        ; readtext
        paint  0, 0, 800, 600, BLACK
        MOV SCORES_LIST[0], 10
        MOV SCORES_LIST[2], 20
        MOV SCORES_LIST[4], 5
        MOV SCORES_LIST[6], 16
        MOV SCORES_LIST[8], 2
        MOV SCORES_LIST[10], 7
        MOV SCORES_LIST[12], 6
        MOV SCORES_LIST[14], 1
        MOV POS_SCORE, 16
        HEAPSORTASC1
        readtext
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
        MOV NIVEL, 1
        MOV SCORE, 0
        MOV speed, 1000
        MOV timeaux, 0
        PINTARPANTALLADEJUEGO

        MOV DI, 0
        esperaenter
        INICIOTIEMPO ;* SETEO EL TIEMPO DE INICIO EL CUAL CORRERA MIN, SEC, CENTISEC
        RANDOMPIECE
        MOV SI, TEMP
        MOV NEXTPIECE, 4
        GENFIGURA:
            PINTARBLOQUESTIESOS
            MOV DI, 0
            
            MOV ROTACIONDEPIEZA, 0
            MOV BANDERATIESO,0  ; * SET flag de figura quieta
            MOV SI, NEXTPIECE ;* paso a actual la pieza que era la siguiente
            MOV TIPODEPIEZA, SI
            ;! GENERO LA PIEZA Y GUARDO LA SIGUIENTE
            RANDOMPIECE ; * Genero la pieza siguiente para despues
            MOV SI, TEMP
            MOV NEXTPIECE, 4
            PINTARPIEZASIGUIENTE NEXTPIECE
            RANDOMPOSITION ;* Genero la posicion random de inicio

        whilee:
            MOSTRARTIEMPO
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
                PAINTTEXT pause0 , 0408H , WHITE
                PAINTTEXT pause1 , 2108H , LIGHT_GREEN
                PAINTTEXT pause2 , 2308H , LIGHT_GREEN
                pauseGame2:
                xor ax, ax  ;*ah = 0
                int 16h
                cmp al, 27  ;* ESC PARA GUARDAR PUNTOS Y MENU.
                JE GUARDAYMENU
                cmp ah, 83  ;* DEL PARA CONTINUAR
                JE  siguewhilePRE
                jMP pauseGame2
                siguewhilePRE:
                    PAINTTEXT BORRAR , 0408H , WHITE
                    PAINTTEXT BORRAR , 2108H , WHITE
                    PAINTTEXT BORRAR , 2308H , WHITE
                    JMP siguewhile
            ROTATEPIECE:
                MOV FLAG_SABER_SIROTO, 1
                CMP ROTACIONDEPIEZA, 3
                JE RESTARTROTACION
                JNE INCROTACION
                RESTARTROTACION:
                    MOV ROTACIONDEPIEZA,0
                    JMP siguewhile
                INCROTACION:
                    INC ROTACIONDEPIEZA

            siguewhile: ; ? █▄▄▄█▄▄▄█▄▄▄█▄▄▄█ CREATE PIECE █▄▄▄█▄▄▄█▄▄▄█▄▄▄█
                ELIMINARFILAS ;! SCAN SI HAY FILAS RELLENITAS XD
                UPDATEPIEZA  ;!UPDATE OF THE PIECE.
                CMP BANDERATIESO, 1  ;* SI ES 1 SIGUIENTE FIGURA
                JE GENFIGURA
                Delay speed
                INC DI
                CMP NIVEL, 3
                JE SOLOSIGO
                inc timeaux
                mov dx, timeaux
                cmp dx, 50
                je nextLevel
                cmp dx, 100
                je nextLevel
                SOLOSIGO:
                jmp whilee
            nextLevel:
                INC NIVEL
                ; * IMPRIMIR NIVEL
                poscursor 17,18
                toString NIVEL, Stringnivel
                print Stringnivel
                SUB speed, 300
                jmp whilee
            GUARDAYMENU:
                TIEMPO_GUARDAR
                SAVESCOREINFILE
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
            CMP auxpX1, -1
            JE CONTINUA0
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
            CONTINUA0:
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
            CMP auxpX1, -1
            JE CONTINUA1
            LEFTRIGHT_DECUATRO auxpX1,auxpY1,auxpX2,auxpY2,auxpX3,auxpY3,auxpX4, auxpY4
            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY4                   ;!|//!    ██
            MOV TEMP2, CX
            INC TEMP2                           ;!|//!    ██
            getAREADEJUEGO auxpX4, TEMP2        ;!|//!    ██
            CMP TEMP, 0                         ;!|//!    ██
            JNE SEQUEDAKIETO;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
            LIMPIARFRAMEANTERIOR
            CONTINUA1:
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
        CMP auxpX1, -1
        JE CONTINUA0
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
        CONTINUA0:
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
            JE CONTINUA0
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA00
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX1,auxpY1,auxpX4,auxpY4, auxpX1,auxpY1,auxpX2,auxpY2

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
            CONTINUA00:
            LIMPIARFRAMEANTERIOR

            CONTINUA0:
            MOV FLAG_SABER_SIROTO,0
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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA11
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
            CONTINUA11:
            LIMPIARFRAMEANTERIOR

            CONTINUA1:
            MOV FLAG_SABER_SIROTO,0
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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA22
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX3,auxpY3,auxpX4,auxpY4,  auxpX1,auxpY1,auxpX4,auxpY4
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
            CONTINUA22:
            LIMPIARFRAMEANTERIOR
            CONTINUA2:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA33
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
            CONTINUA33:
            LIMPIARFRAMEANTERIOR
            CONTINUA3:
            MOV FLAG_SABER_SIROTO,0
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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA00
            CMP auxpX1, -1
            JE CONTINUA0
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
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

            CONTINUA00:
            LIMPIARFRAMEANTERIOR

            CONTINUA0:
            MOV FLAG_SABER_SIROTO,0
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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA11
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY3, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX1,auxpY1,auxpX4,auxpY4, auxpX1,auxpY1,auxpX2,auxpY2

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

            CONTINUA11:
            LIMPIARFRAMEANTERIOR

            CONTINUA1:
            MOV FLAG_SABER_SIROTO,0
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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA22
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY3, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
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

            CONTINUA22:
            LIMPIARFRAMEANTERIOR
            CONTINUA2:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA33
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX3,auxpY3,auxpX4,auxpY4, auxpX1,auxpY1,auxpX4,auxpY4

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

            CONTINUA33:
            LIMPIARFRAMEANTERIOR
            CONTINUA3:
            MOV FLAG_SABER_SIROTO,0

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
            JE CONTINUA0
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA00
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DETRES auxpX2,auxpY2,auxpX3,auxpY3,auxpX4,auxpY4,auxpX1,auxpY1,auxpX3,auxpY3,auxpX4,auxpY4

            ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
            MOV CX, auxpY2
            MOV TEMP2, CX      ;! ----------    ;!|         ████
            INC TEMP2                           ;!|         ██
            getAREADEJUEGO auxpX2, TEMP2        ;!|         ██
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|

            MOV CX, auxpY4    ;! ----------  ;!|
            MOV TEMP2, CX
            INC TEMP2                           ;!|
            getAREADEJUEGO auxpX4, TEMP2        ;!|
            CMP TEMP, 0                         ;!|
            JNE SEQUEDAKIETO                    ;!|
            ;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

            CONTINUA00:
            LIMPIARFRAMEANTERIOR

            CONTINUA0:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA11
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX3,auxpY3,auxpX4,auxpY4, auxpX1,auxpY1,auxpX4,auxpY4

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

            CONTINUA11:
            LIMPIARFRAMEANTERIOR

            CONTINUA1:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA22
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY3, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
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

            CONTINUA22:
            LIMPIARFRAMEANTERIOR
            CONTINUA2:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA33
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX1,auxpY1,auxpX4,auxpY4, auxpX1,auxpY1,auxpX2,auxpY2

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

            CONTINUA33:
            LIMPIARFRAMEANTERIOR
            CONTINUA3:
            MOV FLAG_SABER_SIROTO,0


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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA00
            CMP auxpX1, -1
            JE CONTINUA0
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX2,auxpY2,auxpX4,auxpY4, auxpX1,auxpY1,auxpX3,auxpY3

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

            CONTINUA00:
            LIMPIARFRAMEANTERIOR

            CONTINUA0:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA11
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
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

            CONTINUA11:
            LIMPIARFRAMEANTERIOR

            CONTINUA1:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA00
            CMP auxpX1, -1
            JE CONTINUA0
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
            ;* VALIDO SI HAY QUE MOVER A LOS LADOS.
            LEFTRIGHT_DEDOS5 auxpX2,auxpY2,auxpX4,auxpY4, auxpX1,auxpY1,auxpX3,auxpY3

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

            CONTINUA00:
            LIMPIARFRAMEANTERIOR

            CONTINUA0:
            MOV FLAG_SABER_SIROTO,0

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
            CMP FLAG_SABER_SIROTO, 1
            JE CONTINUA11
            ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
            CMP auxpY4, 15  ;* sI LLEGO AL FONDO
            JE SEQUEDAKIETO
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

            CONTINUA11:
            LIMPIARFRAMEANTERIOR

            CONTINUA1:
            MOV FLAG_SABER_SIROTO,0

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
        CMP auxpX1, -1
        JE CONTINUA0
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

        
        LIMPIARFRAMEANTERIORESPECIAL
        CONTINUA0:
        ;! ESCANEO POSICIONES MAS ABAJO PARA VER SI SEQUEDA MODO TIESO
        ;! ▬▬▬▬▬▬▬▬▬▬▬ SCAN ABAJO ▬▬▬▬▬▬▬▬▬▬▬
        ESCANEODECOLUMNA
        CMP TEMP2, 1
        JE SEQUEDAKIETO
        MOV CX, Xtemp
        MOV auxpX1, CX
        MOV CX, Ytemp
        MOV auxpY1, CX
        getAREADEJUEGO auxpX1, auxpY1
        CMP TEMP, 0
        JNE SALTONOESCERO
        MOV SIPINTO,1
        setAREADEJUEGO auxpX1, auxpY1, 8
        PAINTPOS auxpX1,auxpY1,WHITE
        SALTONOESCERO:
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
                ; * IMPRIMIR SCORE
                INC SCORE
                poscursor 19,18
                toString SCORE, Stringpuntos
                print Stringpuntos
                MOV DESDEDONDE_CORRER, SI
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
        MOV SI, DESDEDONDE_CORRER  ; ! FILAS
        FORI:
            MOV DI, 0   ;! COLUMNAS
            CMP SI, 1
            JE SALIR

                FORJ:
                    CMP DI, 8
                    JE SALIR2
                    ;* TOMO VALOR de fila anterior y paso a fila actual
                    MOV TEMP2, SI
                    DEC TEMP2


                    getAREADEJUEGO DI, TEMP2
                    setAREADEJUEGO DI, SI, TEMP ; !set dato en la fila posterior
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
            OPTIONS_BUBBLESORT
            JMP Inicio
        HeapSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            OPTIONS_HEAPSORT
            JMP Inicio
        QuickSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            OPTIONS_QUICKSORT
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
            TOP10PERSONAL
            JMP Inicio
        BubbleSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            OPTIONS_BUBBLESORT
            JMP Inicio
        HeapSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            OPTIONS_HEAPSORT
            JMP Inicio
        QuickSortLB:
            paint  0, 0, 800, 600, GREEN
            paint  0, 0, 800, 600, BLACK
            OPTIONS_QUICKSORT
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
            TOP10PERSONAL
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
        PAINTTEXT msgFIGSIGUIENTE , 182AH , 0FF26H
        PAINTTEXT msgUSUARIO, 0F08H , LIGHT_GREEN
        PAINTTEXT msgNIVEL  , 1108H , LIGHT_GREEN
        PAINTTEXT msgPUNTEO , 1308H , LIGHT_GREEN
        PAINTTEXT msgTIEMPO , 1508H , LIGHT_GREEN
        ; * IMPRIMIR SCORE
        poscursor 19,18
        toString SCORE, Stringpuntos
        print Stringpuntos
        ; * IMPRIMIR NIVEL
        poscursor 17,18
        toString NIVEL, Stringnivel
        print Stringnivel
        ; * IMPRIMIR USUARIO
        poscursor 15,18
        print MYuserName
        ;* TEIMMPO
        poscursor 21,18
        print CERON
        print dospuntos
        print CERON
        print dospuntos
        print CERON
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
    

    ;! I CAN USE AX FOR THE LEFT NUMBER
    ;! I GONNA USE BX FOR THE RIGHT NUMBER
    ;?☻ ===================== SUMA ======================= ☻
    SUMA_ PROC NEAR
        MOV CX, NUMIZQ
        MOV BX, NUMDER
        MOV AX,CX   ;copy NUMIZQ to AX from CX
        MOV DX,00h
        ADD AX,BX   ;adding with NUMDER and guardo resultado en AX
        ADC AX,DX   ;adding CF (carry) to AX guardo resultado en AX
        MOV RESULTADOPREVIO, AX
        ; printnum RESULTADOPRINT, RESULTADOPREVIO
        ; print RESULTADOPRINT
        RET
    SUMA_ ENDP
    ;?☻ ===================== RESTA ======================= ☻
    RESTA_ PROC NEAR
        MOV CX, NUMIZQ
        MOV BX, NUMDER
        MOV AX,CX ;copy NUMIZQ to AX from CX
        SUB AX,BX ;subtracting NUMDER from NUMIZQ and 
        JC SOBREFLU; storing the result in AX 
        JNC SALIR
        SOBREFLU:
            NEG AX
            MOV overflow,01h

            MOV RESULTADOPREVIO, AX
            RET
        SALIR:
        MOV RESULTADOPREVIO, AX
        RET
    RESTA_ ENDP
    ;?☻ ===================== MULTIPLICACION ======================= ☻
    MULTI_ PROC NEAR
        MOV CX, NUMIZQ
        MOV BX, NUMDER
        MOV AX,CX           ;copy NUMIZQ to AX from CX
        MOV DX,00H          ;moving 00h in DX
        MUL BX              ;multiplying NUMIZQ by NUMDER and storing the result in AX
        MOV RESULTADOPREVIO, AX
        RET
    MULTI_ ENDP
    ;?☻ ===================== DIVISION ======================= ☻
    DIVI_ PROC NEAR
        MOV CX, NUMIZQ
        MOV BX, NUMDER
        MOV AX,CX           ;copy NUMIZQ to AX from CX
        MOV DX,00H          ;moving 00h in DX 
        ADD BX,DX
        DIV BX              ;dividing NUMIZQ by NUMDER and storing the result in AX
        MOV RESULTADOPREVIO, AX
        RET
    DIVI_ ENDP









    ;*        ████████████████████████████████ ████████████████████████████████████
    ;*        █▄─▄▄─█─▄▄▄▄█─▄─▄─██▀▄─██▄─▄▄▀█▄─▄█─▄▄▄▄█─▄─▄─█▄─▄█─▄▄▄─██▀▄─██─▄▄▄▄█
    ;*        ██─▄█▀█▄▄▄▄─███─████─▀─███─██─██─██▄▄▄▄─███─████─██─███▀██─▀─██▄▄▄▄─█
    ;*        ▀▄▄▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀

    ;?☻ ===================== MENUS PARAMETROS ======================= ☻
    OPTIONS_BUBBLESORT_ PROC NEAR
        PAINTTEXT titlebb , 0816H , LIGHT_CYAN
        PAINTTEXT msgUSUARIO ,   1110h , LIGHT_GREEN
        PAINTTEXT msgSENTIDO ,   1310H , LIGHT_GREEN
        PAINTTEXT msgMETRICA ,   1510H , LIGHT_GREEN
        PAINTTEXT msgVELOCIDAD , 1710H , LIGHT_GREEN

        PAINTTEXT msgSENTIDOP ,   132BH , YELLOW
        PAINTTEXT msgMETRICAP ,   152BH , YELLOW
        PAINTTEXT msgVELOCIDADP , 172BH , YELLOW
        poscursor 17, 32
        print MyuserName
        ;* leo el SENTIDO
        poscursor 19, 32
        getStr strSENTIDO ;(1 = ASC, 0 = DESC)
        ;* leo la METRICA
        poscursor 21, 32
        getStr strMETRICA   ; (T = TIEMPO, P = PUNTEO)
        ;* leo la VELOCIDAD
        poscursor 23, 32
        getStr strVELOCIDAD
        toNumber strVELOCIDAD ;TEMP4
        MOV SI, TEMP4
        MULTI SI, 500
        MOV SI, RESULTADOPREVIO
        MOV intVELODIDAD, si

        CMP strSENTIDO, '1'; 1 = ASC
        JE ST1
        JNE ST2
        ST1:
            CMP strMETRICA, 'T';T = TIEMPO
            JE ASC_TIME
            JNE ASC_SCORE
        ST2:
            CMP strMETRICA, 'T';T = TIEMPO
            JE DESC_SCORE
            JNE DESC_SCORE
        ASC_TIME:
            BUBBLESORTASC2
            JMP SALIR
        DESC_TIME:
            BUBBLESORTDESC2
            JMP SALIR
        ASC_SCORE:
            BUBBLESORTASC1
            JMP SALIR
        DESC_SCORE:
            BUBBLESORTDESC1
            JMP SALIR
        SALIR:
        RET
    OPTIONS_BUBBLESORT_ ENDP
    OPTIONS_HEAPSORT_ PROC NEAR
        PAINTTEXT titlehs , 0816H , LIGHT_CYAN
        PAINTTEXT msgUSUARIO ,   1110h , LIGHT_GREEN
        PAINTTEXT msgSENTIDO ,   1310H , LIGHT_GREEN
        PAINTTEXT msgMETRICA ,   1510H , LIGHT_GREEN
        PAINTTEXT msgVELOCIDAD , 1710H , LIGHT_GREEN

        PAINTTEXT msgSENTIDOP ,   132BH , YELLOW
        PAINTTEXT msgMETRICAP ,   152BH , YELLOW
        PAINTTEXT msgVELOCIDADP , 172BH , YELLOW
        poscursor 17, 32
        print MyuserName
        ;* leo el SENTIDO
        poscursor 19, 32
        getStr strSENTIDO ;(1 = ASC, 0 = DESC)
        ;* leo la METRICA
        poscursor 21, 32
        getStr strMETRICA   ; (T = TIEMPO, P = PUNTEO)
        ;* leo la VELOCIDAD
        poscursor 23, 32
        getStr strVELOCIDAD
        toNumber strVELOCIDAD ;TEMP4
        MOV SI, TEMP4
        MOV intVELODIDAD, si

        CMP strSENTIDO, '1'; 1 = ASC
        JE ST1
        JNE ST2
        ST1:
            CMP strMETRICA, 'T';T = TIEMPO
            JE ASC_TIME
            JNE ASC_SCORE
        ST2:
            CMP strMETRICA, 'T';T = TIEMPO
            JE DESC_SCORE
            JNE DESC_SCORE
        ASC_TIME:
            HEAPSORTASC1
            JMP SALIR
        DESC_TIME:
            HEAPSORTDESC1
            JMP SALIR
        ASC_SCORE:
            HEAPSORTASC1
            JMP SALIR
        DESC_SCORE:
            HEAPSORTDESC1
            JMP SALIR
        SALIR:
        RET
    OPTIONS_HEAPSORT_ ENDP
    OPTIONS_QUICKSORT_ PROC NEAR
        PAINTTEXT titleqs , 0816H , LIGHT_CYAN
        PAINTTEXT msgUSUARIO ,   1110h , LIGHT_GREEN
        PAINTTEXT msgSENTIDO ,   1310H , LIGHT_GREEN
        PAINTTEXT msgMETRICA ,   1510H , LIGHT_GREEN
        PAINTTEXT msgVELOCIDAD , 1710H , LIGHT_GREEN

        PAINTTEXT msgSENTIDOP ,   132BH , YELLOW
        PAINTTEXT msgMETRICAP ,   152BH , YELLOW
        PAINTTEXT msgVELOCIDADP , 172BH , YELLOW
        poscursor 17, 32
        print MyuserName
        ;* leo el SENTIDO
        poscursor 19, 32
        getStr strSENTIDO ;(1 = ASC, 0 = DESC)
        ;* leo la METRICA
        poscursor 21, 32
        getStr strMETRICA   ; (T = TIEMPO, P = PUNTEO)
        ;* leo la VELOCIDAD
        poscursor 23, 32
        getStr strVELOCIDAD
        toNumber strVELOCIDAD ;TEMP4
        MOV SI, TEMP4
        MOV intVELODIDAD, si

        CMP strSENTIDO, '1'; 1 = ASC
        JE ST1
        JNE ST2
        ST1:
            CMP strMETRICA, 'T';T = TIEMPO
            JE ASC_TIME
            JNE ASC_SCORE
        ST2:
            CMP strMETRICA, 'T';T = TIEMPO
            JE DESC_SCORE
            JNE DESC_SCORE
        ASC_TIME:
            BUBBLESORTASC2
            JMP SALIR
        DESC_TIME:
            BUBBLESORTDESC2
            JMP SALIR
        ASC_SCORE:
            QUICKSORTASC1
            JMP SALIR
        DESC_SCORE:
            QUICKSORTDESC1
            JMP SALIR
        SALIR:
        RET
    OPTIONS_QUICKSORT_ ENDP

    BUBBLESORTASC1_ PROC NEAR ;! ASCENDENTE BUBBLESORT SCORE
        MOV intVELODIDAD, 1000
        MOV CX, POS_SCORE
        DEC CX
        DEC CX
        DEC CX
        DEC CX
        MOV SI, -2
        MOV DI, -2
        ILOOP:       ;* for i in range(0,len(list1)-1):
            INC SI
            INC SI
            clearScreen
            GRAPH_SORT
            DELAY2 500
            JLOOP:  ;* for j in range(len(list1)-1)
                
                INC DI
                INC DI
                CONDITION:          ;*if(list1[j]>list1[j+1]):
                    MOV AX, SCORES_LIST[DI]
                    MOV BX, SCORES_LIST[DI+2]
                    CMP AX,BX
                    JA MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV PIVOTAZO, DI
                        ;! SWAP DE LA LISTA
                        MOV AX, SCORES_LIST[DI]
                        MOV BX, SCORES_LIST[DI+2]
                        MOV SCORES_LIST[DI], BX
                        MOV SCORES_LIST[DI+2], AX  ;*list1[j+1] = temp

                        ;! MISMOS MOVIMIENTOS PARA EL ID
                        MOV AX, ID_LIST[DI]
                        MOV BX, ID_LIST[DI+2]
                        MOV ID_LIST[DI], BX
                        MOV ID_LIST[DI+2], AX

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
            clearScreen
            GRAPH_SORT
        RET
    BUBBLESORTASC1_ ENDP
    BUBBLESORTDESC1_ PROC NEAR   ;! DESCENDENTE BUBBLESORT SCORE
        MOV intVELODIDAD, 1000
        MOV CX, POS_SCORE
        DEC CX
        DEC CX
        DEC CX
        DEC CX
        MOV SI, -2
        MOV DI, -2
        ILOOP:       ;* for i in range(0,len(list1)-1):
            INC SI
            INC SI
            clearScreen
            GRAPH_SORT
            DELAY2 500
            JLOOP:  ;* for j in range(len(list1)-1)
                
                INC DI
                INC DI
                CONDITION:          ;*if(list1[j]>list1[j+1]):
                    MOV AX, SCORES_LIST[DI]
                    MOV BX, SCORES_LIST[DI+2]
                    CMP AX,BX
                    JB MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV PIVOTAZO, DI
                        ;! SWAP DE LA LISTA
                        MOV AX, SCORES_LIST[DI]
                        MOV BX, SCORES_LIST[DI+2]
                        MOV SCORES_LIST[DI], BX
                        MOV SCORES_LIST[DI+2], AX  ;*list1[j+1] = temp

                        ;! MISMOS MOVIMIENTOS PARA EL ID
                        MOV AX, ID_LIST[DI]
                        MOV BX, ID_LIST[DI+2]
                        MOV ID_LIST[DI], BX
                        MOV ID_LIST[DI+2], AX

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
            clearScreen
            GRAPH_SORT
        RET
    BUBBLESORTDESC1_ ENDP
    BUBBLESORTASC2_ PROC NEAR   ;! ASCENDENTE BUBBLESORT TIEMPO
        MOV intVELODIDAD, 1000
        MOV CX, POS_TIME
        DEC CX
        DEC CX
        DEC CX
        DEC CX
        MOV SI, -2
        MOV DI, -2
        ILOOP:       ;* for i in range(0,len(list1)-1):
            INC SI
            INC SI
            clearScreen
            GRAPH_SORT2
            DELAY2 500
            JLOOP:  ;* for j in range(len(list1)-1)
                
                INC DI
                INC DI
                CONDITION:          ;*if(list1[j]>list1[j+1]):
                    MOV AX, TIMES_LIST[DI]
                    MOV BX, TIMES_LIST[DI+2]
                    CMP AX,BX
                    JA MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV PIVOTAZO, DI
                        ;! SWAP DE LA LISTA
                        MOV AX, TIMES_LIST[DI]
                        MOV BX, TIMES_LIST[DI+2]
                        MOV TIMES_LIST[DI], BX
                        MOV TIMES_LIST[DI+2], AX  ;*list1[j+1] = temp

                        ;! MISMOS MOVIMIENTOS PARA EL ID
                        MOV AX, ID_LIST[DI]
                        MOV BX, ID_LIST[DI+2]
                        MOV ID_LIST[DI], BX
                        MOV ID_LIST[DI+2], AX

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
            clearScreen
            GRAPH_SORT
        RET
    BUBBLESORTASC2_ ENDP
    BUBBLESORTDESC2_ PROC NEAR   ;! DESCENDENTE BUBBLESORT TIEMPO
        MOV intVELODIDAD, 1000
        MOV CX, POS_TIME
        DEC CX
        DEC CX
        DEC CX
        DEC CX
        MOV SI, -2
        MOV DI, -2
        ILOOP:       ;* for i in range(0,len(list1)-1):
            INC SI
            INC SI
            clearScreen
            GRAPH_SORT2
            DELAY2 500
            JLOOP:  ;* for j in range(len(list1)-1)
                
                INC DI
                INC DI
                CONDITION:          ;*if(list1[j]>list1[j+1]):
                    MOV AX, TIMES_LIST[DI]
                    MOV BX, TIMES_LIST[DI+2]
                    CMP AX,BX
                    JB MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV PIVOTAZO, DI
                        ;! SWAP DE LA LISTA
                        MOV AX, TIMES_LIST[DI]
                        MOV BX, TIMES_LIST[DI+2]
                        MOV TIMES_LIST[DI], BX
                        MOV TIMES_LIST[DI+2], AX  ;*list1[j+1] = temp

                        ;! MISMOS MOVIMIENTOS PARA EL ID
                        MOV AX, ID_LIST[DI]
                        MOV BX, ID_LIST[DI+2]
                        MOV ID_LIST[DI], BX
                        MOV ID_LIST[DI+2], AX

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
            clearScreen
            GRAPH_SORT
        RET
    BUBBLESORTDESC2_ ENDP
    
    
    QUICKSORTASC1_ PROC NEAR   ;! ASCENDENTE QUICKSORT SCORE
        
        ; POP highmax  ;? MAX
        ; MOV BX, highmax
        ; POP lowmin  ;? MIN
        ; MOV AX, lowmin
        ; CMP AX,BX       ;* p if low < high:
        ; Jb MAYORQUE  ;! JB para top ten
        ; JMP SALIR
        ; MAYORQUE:
            
        ;     ;* partition(array, low, high)
        ;     partqs1ASC
        ;     ;* quickSort(array, low, pi - 1)
        ;     MOV AX, PIVOT
        ;     SUB AX, 2
        ;     MOV highmax, AX
        ;     PUSH lowmin
        ;     PUSH highmax
        ;     CALL QUICKSORTASC1_
            
        ;     ;* quickSort(array, pi + 1, high)
        ;     MOV AX, PIVOT
        ;     ADD AX, 2
        ;     MOV lowmin, AX
        ;     PUSH lowmin
        ;     PUSH highmax
        ;     CALL QUICKSORTASC1_
            
        ; SALIR:
        MOV intVELODIDAD, 1000
        mov si, sp
        mov lowmin, 0
        mov ax, POS_SCORE
        sub ax, 2
        mov highmax, ax
        push lowmin
        push highmax

        whileZ:
            clearScreen
            GRAPH_SORT
            DELAY2 1000
            cmp sp, si
            je fin
            pop highmax
            pop lowmin
            partqs1ASC
            mov bx, pivot
            dec bx
            dec bx
            cmp bx, lowmin
            jle fin0
            push lowmin
            push bx

        fin0:
            mov bx, pivot
            inc bx
            inc bx
            cmp bx, highmax
            jge fin1
            push bx
            push highmax
        fin1:
            jmp whileZ

        fin:
            
        RET
    QUICKSORTASC1_ ENDP
    QUICKSORTDESC1_ PROC NEAR   ;! DESCENDENTE QUICKSORT SCORE

        RET
    QUICKSORTDESC1_ ENDP
    QUICKSORTASC2_ PROC NEAR   ;! ASCENDENTE QUICKSORT TIEMPO

        RET
    QUICKSORTASC2_ ENDP
    QUICKSORTDESC2_ PROC NEAR   ;! DESCENDENTE QUICKSORT TIEMPO

        RET
    QUICKSORTDESC2_ ENDP
    ; TRYING THREE
    HEAPSORTASC1_ PROC NEAR
        MOV AX, 0
        MOV DI, 2
        ;BULIDMAXHEAP
        
        FOR1111: ;*  for i in range(n - 2, 0, -2):
            clearScreen
            GRAPH_SORT
            DELAY2 500
            CMP DI,POS_SCORE
            JE SALIRFOR
            ;* ----------------------------------
            mov AX, SCORES_LIST[0]
            MOV SI, POS_SCORE
            RESTA SI, DI
            MOV SI, RESULTADOPREVIO
            MOV BX, SCORES_LIST[SI]
            MOV SCORES_LIST[0], BX
            MOV SCORES_LIST[SI], AX

            MOV SI, POS_SCORE
            RESTA SI, DI
            MOV SI, RESULTADOPREVIO
            HEAPIFY 0, SI
            ;* ----------------------------------
            INC DI
            INC DI
            JMP FOR1111
        SALIRFOR:
            BUBBLESORTASC1
            clearScreen
            GRAPH_SORT
            DELAY2 500
        ; ;*  # swap value of first indexed with last indexed
            ; mov CX, SCORES_LIST[DI];*  arr[0], arr[i] = arr[i], arr[0]
            ; mov AX, SCORES_LIST[0]
            ; mov SCORES_LIST[0], CX
            ; mov SCORES_LIST[DI], AX
            ; ;*  # maintaining heap property after each swapping
            ; ;*  j, index = 0, 0
            ; MOV INDEXX, 0
            ; MOV JOTA, 0
            ; ;*  while True:
            ; WHILETRUE:
            ;     ;*      index = 2 * j + 2
            ;     MULTI JOTA, 2
            ;     INC RESULTADOPREVIO
            ;     INC RESULTADOPREVIO
            ;     MOV AX, RESULTADOPREVIO
            ;     MOV INDEXX, AX
            ;     ;*      # if left child is smaller than
            ;     ;*      # right child point index variable to right child
            ;     ;*      if (index < (i - 2) and arr[index] < arr[index +2]):
            ;     MOV AX, INDEX
            ;     MOV BX, DI
            ;     DEC BX
            ;     DEC BX
            ;     CMP AX, BX
            ;     JB ANDJB
            ;     JMP IF22
            ;     ANDJB:
            ;         MOV SI, INDEXX
            ;         MOV AX, SCORES_LIST[SI]
            ;         INC SI
            ;         INC SI
            ;         MOV BX, SCORES_LIST[SI]
            ;         CMP AX, BX
            ;         JB SIESAND1
            ;         JMP IF22
            ;         SIESAND1:
            ;             ;*          index += 2
            ;             INC INDEXX
            ;             INC INDEXX
            ;     ;*# if parent is smaller than child then swapping parent with child having higher value
            ;     IF22:    ;* if index < i and arr[j] < arr[index]:
            ;         MOV AX, INDEXX
            ;         MOV BX, DI
            ;         CMP AX, BX
            ;         JB ANDJB2
            ;         JMP IF3
            ;         ANDJB2:
            ;             MOV SI, JOTA
            ;             MOV AX, SCORES_LIST[SI]
            ;             MOV SI, INDEXX
            ;             MOV BX, SCORES_LIST[SI]
            ;             CMP AX, BX
            ;             JB SIESAND2
            ;             JMP IF3
            ;             SIESAND2:
            ;                 MOV BX, INDEXX
            ;                 mov CX, SCORES_LIST[BX] ;* arr[j], arr[index] = arr[index], arr[j]
            ;                 MOV BX, JOTA
            ;                 mov AX, SCORES_LIST[BX]
            ;                 MOV BX, JOTA
            ;                 mov SCORES_LIST[BX], CX
            ;                 MOV BX, INDEXX
            ;                 mov SCORES_LIST[BX], AX
            ;     IF3:
            ;     ;*      j = index
            ;     MOV CX, INDEXX
            ;     MOV JOTA, CX
            ;     ;*      if index >= i:
            ;     MOV AX, INDEXX
            ;     CMP AX, DI
            ;     JA SALLLL   ;* BREAK
            ;     JMP WHILETRUE
            ;     SALLLL:

            
        RET
    HEAPSORTASC1_ ENDP
    BULIDMAXHEAP_ PROC NEAR
        MOV DI, 0
        MOV SI, POS_SCORE
        DIVI SI, 2
        MOV DI, RESULTADOPREVIO
        MOV BX, POS_SCORE
        FOR1:
            CMP DI, -2
            JE SALIR

            HEAPIFY DI, BX

            DEC DI
            DEC DI
            JMP FOR1
        SALIR:

        RET
    BULIDMAXHEAP_ ENDP
    HEAPIFY_ PROC NEAR ; * SOLO PASO N
        FOR1:
            MOV SI, II
            MULTI SI, 2
            MOV SI, RESULTADOPREVIO
            INC SI
            INC SI
            MOV DI, SI
            mov BX, NN
            ;* *************
            CMP BX, DI
            JAE SALGOPRRO
            MOV bci, DI
            MOV AX, DI
            INC AX
            INC AX
            MOV BX, NN
            CMP AX, BX
            JB IF222
            JMP IF3
            IF222:
                MOV AX, SCORES_LIST[DI]
                MOV SI, DI
                INC SI
                INC SI
                MOV BX,  SCORES_LIST[SI]
                CMP AX, BX
                JB SIADDBCI
                JMP IF3
                SIADDBCI:
                    MOV SI, DI
                    INC SI
                    INC SI
                    MOV bci, SI
            IF3:
            MOV SI, II
            MOV AX, SCORES_LIST[SI]
            MOV SI, bci
            MOV BX, SCORES_LIST[SI]
            CMP AX, BX
            JB HAGOSWAP
            JMP SALGOPRRO
            HAGOSWAP:
                MOV SI, II
                MOV BX, SCORES_LIST[SI]
                MOV SI, bci
                MOV AX, SCORES_LIST[SI]

                MOV SI, II
                mov SCORES_LIST[SI], AX
                MOV SI, bci
                MOV SCORES_LIST[SI], BX
            MOV SI, bci
            MOV II, SI
            
            JMP FOR1
        SALGOPRRO:

        ;* for i in range(2,n,2):
        ; FOR1:
        ;     clearScreen
        ;     GRAPH_SORT
        ;     DELAY2 500
        ;     MOV SI, DI
        ;     CMP DI, POS_SCORE
        ;     JE SALIRFOR
        ;     ;* if arr[i] > arr[int((i - 1) / 2)*2]:
        ;     MOV SI, DI
        ;     MOV AX, SCORES_LIST[SI]
        ;     MOV SI, DI
        ;     ; DEC SI
        ;     DEC SI
        ;     DIVI SI,2
        ;     MULTI RESULTADOPREVIO,2
        ;     MOV SI, RESULTADOPREVIO
        ;     MOV BX, SCORES_LIST[SI]
        ;     CMP BX, AX
        ;     JB ANDJB2
        ;     JMP PRESAL
        ;     ANDJB2:
        ;         ;*        j = i
        ;         MOV JOTA, DI
        ;         ;*        while arr[j] > arr[int((j - 1) / 2)*2]:
        ;         WHILEZ:
        ;             MOV SI, JOTA
        ;             MOV AX, SCORES_LIST[SI]
        ;             DEC SI
        ;             ; DEC SI
        ;             DIVI SI,2
        ;             MULTI RESULTADOPREVIO,2
        ;             MOV SI, RESULTADOPREVIO
        ;             MOV BX, SCORES_LIST[SI]
        ;             CMP  BX,AX
        ;             JBE SIGOWHILE
        ;             JMP PRESAL
        ;             SIGOWHILE:
        ;                 ;*(arr[j],arr[int((j - 1) / 2)*2]) = (arr[int((j - 1) / 2)*2],arr[j])
        ;                 mov SI, JOTA
        ;                 ; DEC SI
        ;                 DEC SI
        ;                 DIVI SI, 2
        ;                 MULTI RESULTADOPREVIO,2
        ;                 MOV SI, RESULTADOPREVIO
        ;                 MOV AX, SCORES_LIST[SI]
        ;                 MOV SI, JOTA
        ;                 MOV BX, SCORES_LIST[SI]


        ;                 MOV SI, JOTA
        ;                 MOV SCORES_LIST[SI], AX
        ;                 mov SI, JOTA
        ;                 ; DEC SI
        ;                 DEC SI
        ;                 DIVI SI, 2
        ;                 MULTI RESULTADOPREVIO,2
        ;                 MOV SI, RESULTADOPREVIO
        ;                 MOV  SCORES_LIST[SI], BX

        ;                 ;* j = int((j - 1) / 2) *2
        ;                 mov SI, JOTA
        ;                 ; DEC SI
        ;                 DEC SI
        ;                 DIVI SI, 2
        ;                 MULTI RESULTADOPREVIO,2
        ;                 MOV SI, RESULTADOPREVIO
        ;                 MOV JOTA, SI

                       
        ;                 JMP WHILEZ

        ;     PRESAL:
        ;     INC DI
        ;     INC DI
        ;     JMP FOR1
        ; SALIRFOR:
        RET
    HEAPIFY_ ENDP
    
    HEAPSORTDESC1_ PROC NEAR   ;! DESCENDENTE HEAPSORT SCORE

        RET
    HEAPSORTDESC1_ ENDP
    HEAPSORTASC2_ PROC NEAR   ;! ASCENDENTE HEAPSORT TIEMPO

        RET
    HEAPSORTASC2_ ENDP
    HEAPSORTDESC2_ PROC NEAR   ;! DESCENDENTE HEAPSORT TIEMPO

        RET
    HEAPSORTDESC2_ ENDP
    
    ;! NO SIRVIO F
    ; HEAPSORTASC1ZZZ_ PROC NEAR   ;! ASCENDENTE HEAPSORT SCORE
    ;     ;* for i in range(n // 2 - 1, -1, -1):
    ;     MOV DI, POS_SCORE
    ;     DIVI DI, 2
    ;     DEC RESULTADOPREVIO
    ;     DEC RESULTADOPREVIO
    ;     MOV DI, RESULTADOPREVIO
    ;     FOR1:
    ;         clearScreen
    ;         GRAPH_SORT
    ;         DELAY2 500
    ;         CMP DI, -2
    ;         JE EXITFOR1
    ;         ;*  heapify(arr, n, i)
    ;         PUSH POS_SCORE
    ;         PUSH DI
    ;         HEAPIFY POS_SCORE, DI

    ;         DEC DI
    ;         DEC DI
    ;         JMP FOR1
    ;     EXITFOR1:
    ;     ;* for i in range(n - 1, 0, -1):
    ;     MOV DI, POS_SCORE
    ;     DEC DI
    ;     FOR2:
    ;         clearScreen
    ;         GRAPH_SORT
    ;         DELAY2 500
    ;         CMP DI, 0
    ;         JE EXITFOR2
    ;         ;*     (arr[i], arr[0]) = (arr[0], arr[i])  # swap
    ;         mov CX, SCORES_LIST[0]
    ;         mov AX, SCORES_LIST[DI]
    ;         mov SCORES_LIST[0], AX
    ;         mov SCORES_LIST[DI], CX
    ;         ;*     heapify(arr, i, 0)
    ;         HEAPIFY DI, 0

    ;         DEC DI
    ;         DEC DI
    ;         JMP FOR2
    ;     EXITFOR2:
    ;         clearScreen
    ;         GRAPH_SORT
    ;         DELAY2 1000
    ;     RET
    ; HEAPSORTASC1ZZZ_ ENDP
    ; HEAPIFYZZZ_ PROC NEAR ;*   def heapify(arr, n, i):
    ;     ;*   largest = i  # Initialize largest as root
    ;     POP II
    ;     POP NN
    ;     MOV AX, II
    ;     MOV LARGEST, AX
    ;     ;*   l = 2 * i + 1      # left = 2*i + 1
    ;     MULTI II, 2
    ;     MOV BX, RESULTADOPREVIO
    ;     INC BX
    ;     INC BX
    ;     MOV ELE, BX
    ;     ;*   r = 2 * i + 2      # right = 2*i + 2
    ;     MULTI II, 2
    ;     ADD RESULTADOPREVIO, 2
    ;     MOV BX, RESULTADOPREVIO
    ;     MOV ERE, BX
    ;     ;*   if l < n and arr[i] < arr[l]:
    ;     MOV AX, ELE
    ;     MOV BX, NN
    ;     CMP AX, BX
    ;     JB ANDJB
    ;     JMP IF222
    ;     ANDJB:
    ;         MOV DI, II
    ;         MOV SI, ELE
    ;         MOV AX, SCORES_LIST[DI]
    ;         MOV BX, SCORES_LIST[SI]
    ;         CMP AX, BX
    ;         JB SIESAND1
    ;         JMP IF222
    ;         SIESAND1:
    ;             ;*       largest = l
    ;             MOV AX, ELE
    ;             MOV LARGEST, AX

    ;     ;*   if r < n and arr[largest] < arr[r]:
    ;     IF222:
    ;         MOV AX, ERE
    ;         MOV BX, NN
    ;         CMP AX, BX
    ;         JB ANDJB2
    ;         JMP IF3
    ;         ANDJB2:
    ;             MOV DI, LARGEST
    ;             MOV SI, ERE
    ;             MOV AX, SCORES_LIST[DI]
    ;             MOV BX, SCORES_LIST[SI]
    ;             CMP AX, BX
    ;             JB SIESAND2
    ;             JMP IF3
    ;             SIESAND2:
    ;                 ;*       largest = r
    ;                 MOV AX, ERE
    ;                 MOV LARGEST, AX

    ;     ;*   if largest != i:
    ;     IF3:
    ;         MOV AX, LARGEST
    ;         MOV BX, II
    ;         JNE NOEQUAL
    ;         JMP EXIT
    ;         NOEQUAL:
    ;             ;*(arr[i],arr[largest])=(arr[largest],arr[i])  # swap
    ;             MOV DI, LARGEST
    ;             MOV SI, II
    ;             mov CX, SCORES_LIST[DI]
    ;             mov AX, SCORES_LIST[SI]
    ;             mov SCORES_LIST[SI], CX
    ;             mov SCORES_LIST[DI], AX
    ;             ;*   heapify(arr, n, largest)
    ;             HEAPIFY NN, LARGEST

    ;     EXIT:
    ;     RET
    ; HEAPIFYZZZ_ ENDP

    GRAPH_SORT_ PROC NEAR
        XOR SI, SI
        MOV DI, -1
        xor cx, cx
        xor BX, BX
        whileZ:
            CMP POS_SCORE, SI
            JE salir
            MOV BX, SCORES_LIST[SI]
            MULTI BX, 25
            MOV BX, RESULTADOPREVIO
            RESTA 750, BX
            MOV BX, RESULTADOPREVIO
            MOV Xaux1, BX

            mov Xaux2, 750
            
            MOV BX, SI
            INC BX
            MULTI BX, 24
            MOV BX, RESULTADOPREVIO
            MOV Yaux1, BX

            ADD BX, 25
            MOV Yaux2, BX
            DRAW_RECTANGLE Xaux1,Yaux1,Xaux2,Yaux2, YELLOW

            MOV BX, SCORES_LIST[SI]
            MOV RESULTADOPREVIO, BX
            toString RESULTADOPREVIO, Stringpuntos
            ADD DI, 3
            MOV DX, DI
            poscursor  dl, 95
            print Stringpuntos
            CMP SI, PIVOTAZO
            JE A
            JNE B
                A:
                    MOV DX, DI
                    poscursor  dl, 97
                    print FLECHA
            B:
            INC SI
            INC SI
            JMP whileZ
        salir:
        RET
    GRAPH_SORT_ ENDP
    GRAPH_SORT2_ PROC NEAR
        XOR SI, SI
        MOV DI, -1
        xor cx, cx
        xor BX, BX
        whileZ:
            CMP POS_TIME, SI
            JE salir
            MOV BX, TIMES_LIST[SI]
            MULTI BX, 3
            MOV BX, RESULTADOPREVIO
            RESTA 750, BX
            MOV BX, RESULTADOPREVIO
            MOV Xaux1, BX

            mov Xaux2, 750
            
            MOV BX, SI
            INC BX
            MULTI BX, 24
            MOV BX, RESULTADOPREVIO
            MOV Yaux1, BX

            ADD BX, 25
            MOV Yaux2, BX
            DRAW_RECTANGLE Xaux1,Yaux1,Xaux2,Yaux2, LIGHT_GREEN

            MOV BX, TIMES_LIST[SI]
            MOV RESULTADOPREVIO, BX
            toString RESULTADOPREVIO, Stringpuntos
            ADD DI, 3
            MOV DX, DI
            poscursor  dl, 95
            print Stringpuntos
            CMP SI, PIVOTAZO
            JE A
            JNE B
                A:
                    MOV DX, DI
                    poscursor  dl, 97
                    print FLECHA
            B:
            INC SI
            INC SI
            JMP whileZ
        salir:
        RET
    GRAPH_SORT2_ ENDP
    
    ;!  █▀█ █▀▀ █▀█ █▀█ █▀█ ▀█▀ █▀
    ;!  █▀▄ ██▄ █▀▀ █▄█ █▀▄ ░█░ ▄█☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻ GENERACION DE REPORTES
    ;! TOP TEN
    TOP10GENERAL_ PROC NEAR
        paint  0, 0, 800, 600, BLACK
        ; BUBBLESORTASCTOP1
        PAINTTEXT titletopgeneral , 0516H , LIGHT_CYAN
        PAINTTEXT numtopten , 0708H , LIGHT_MAGENTA
        PAINTTEXT usrtopten , 071CH , LIGHT_MAGENTA
        PAINTTEXT puntostopten , 0746H , LIGHT_MAGENTA
        readtext
        MOV CX, 10 ;*  y
        MOV SI, 0
        CICLO10:
            MOV DX, 8 ; *  x
            CMP SI, 20
            JE EXIT
            poscursor cl, dl
            MOV RESULTADOPREVIO, SI
            INC RESULTADOPREVIO
            toString RESULTADOPREVIO, Stringpuntos
            print Stringpuntos
            ADD DX, 10
            poscursor cl, dl
            print MyuserName

            ADD DX, 25
            poscursor cl, dl
            MOV DI, SCORES_LIST[SI]
            MOV RESULTADOPREVIO, DI
            toString RESULTADOPREVIO, Stringpuntos
            print Stringpuntos

            ADD CX, 2
            ADD SI, 2
            JMP CICLO10
        EXIT:
        RET
    TOP10GENERAL_ ENDP
    TOP10PERSONAL_ PROC NEAR
        paint  0, 0, 800, 600, BLACK
        BUBBLESORTASCTOP2
        PAINTTEXT titletopuser , 0816H , LIGHT_CYAN
        MOV SI, 1
        CICLO10:
            CMP SI, 11
            JE EXIT


            JMP CICLO10
        EXIT:
        RET
    TOP10PERSONAL_ ENDP
    BUBBLESORTASCTOP1_ PROC NEAR
        MOV intVELODIDAD, 1000
        MOV CX, POS_SCORE
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
                    MOV AX, SCORES_LIST[DI]
                    MOV BX, SCORES_LIST[DI+2]
                    CMP AX,BX
                    JB MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV PIVOTAZO, DI
                        ;! SWAP DE LA LISTA
                        MOV AX, SCORES_LIST[DI]
                        MOV BX, SCORES_LIST[DI+2]
                        MOV SCORES_LIST[DI], BX
                        MOV SCORES_LIST[DI+2], AX  ;*list1[j+1] = temp

                        ;! MISMOS MOVIMIENTOS PARA EL ID
                        MOV AX, ID_LIST[DI]
                        MOV BX, ID_LIST[DI+2]
                        MOV ID_LIST[DI], BX
                        MOV ID_LIST[DI+2], AX
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
    BUBBLESORTASCTOP1_ ENDP
    BUBBLESORTASCTOP2_ PROC NEAR
        MOV intVELODIDAD, 1000
        MOV CX, POS_TIME
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
                    MOV AX, TIMES_LIST[DI]
                    MOV BX, TIMES_LIST[DI+2]
                    CMP AX,BX
                    JB MAYORQUE  ;! JB para top ten
                    JMP JLOOP_
                    MAYORQUE:
                        MOV PIVOTAZO, DI
                        ;! SWAP DE LA LISTA
                        MOV AX, TIMES_LIST[DI]
                        MOV BX, TIMES_LIST[DI+2]
                        MOV TIMES_LIST[DI], BX
                        MOV TIMES_LIST[DI+2], AX  ;*list1[j+1] = temp

                        ;! MISMOS MOVIMIENTOS PARA EL ID
                        MOV AX, ID_LIST[DI]
                        MOV BX, ID_LIST[DI+2]
                        MOV ID_LIST[DI], BX
                        MOV ID_LIST[DI+2], AX
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
    BUBBLESORTASCTOP2_ ENDP
    
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