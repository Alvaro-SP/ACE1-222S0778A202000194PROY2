;! █▀▀ █ █░░ █▀▀ █▀   ▄▀█ █▄░█ █▀▄   █▀█ █▀▀ █▀█ █▀█ █▀█ ▀█▀ █▀
;! █▀░ █ █▄▄ ██▄ ▄█   █▀█ █░▀█ █▄▀   █▀▄ ██▄ █▀▀ █▄█ █▀▄ ░█░ ▄█
;! ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
; * ☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻  ARCHIVOS  ☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻

getChar macro
    mov ah, 01h
    int 21h
endm

openFile macro file,handler
;macro para abrir un fichero
;param file = nombre del archivo
;param &handler = num del archivo
    mov ah,3dh
    mov al,010b
    lea dx,file
    int 21h
    mov handler, ax
endm

readFile macro handler,fileData,numBytes
;macro para leer en un fichero
;param handler = num del archivo
;param &fileData = variable donde se almacenara los bytes leidos
;param numBytes = num de bytes a leer
    mov ah,3fh
    mov bx, handler
    mov cx, numBytes
    lea dx, fileData
    int 21h
    MOV tamfile, ax
endm

writeFile macro handler,array,numBytes
;macro para escribir en un fichero
;param handler = num del archivo 
;param array = bytes a escribir
;param numBytes = num de bytes a escribir
    mov ah,40h
    mov bx,handler
    mov cx,numBytes
    lea dx,array
    int 21h
    ; jc errorWriting
endm

;macro para seguir escribiendo en una de terminada posicion del fichero 
seekEnd macro handler
    mov ah,42h
    mov al, 02h
    mov bx, handler
    mov cx, 0
    mov dx, 0
    int 21h
    ; jc errorAppending
endm
;macro para obtener la ruta dada por un usuario
;similar al de getTexto, la unica diferencia es el fin de cadena
getRuta macro array
    LOCAL getCadena, finCadena
    mov si,0    ;xor si,si

    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov array[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,00h
    mov array[si],al
endm

escribir MACRO handler, buff, numbytes
    PUSHA
    MOV ah, 40h
    MOV bx, handler
    MOV cx, numbytes
    lea dx, buff
    int 21h
    POPA
ENDM escribir
cerrar macro handler
    PUSHA
    mov ah,3eh
    mov bx, handler
    int 21h
    POPA
endm
crear macro buffer, handler

    mov ah,3ch ;función para crear fichero
    mov cx,00h ;fichero normal 
    lea dx,buffer ;carga la dirección de la variable buffer a dx
    int 21h
    mov handler, ax ;sino hubo error nos devuelve el handler 

endm
cleanBuffer macro buffer;?    limpiar un array
; buffer = array de bytes
; numBytes = numero de bytes a limpiar
; caracter = caracter con el que se va a limpiar
    LOCAL repeat
    PUSHA
    mov si,0
    mov cx,0
    mov cx,SIZEOF buffer
    repeat:
        mov buffer[si],'$'
        inc si
        loop repeat
    POPA
endm

; * ☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻ FECHA Y HORA ☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻☻
getTime macro
    mov ah, 2ch    ;get the current system time
    int 21h
    ;hour
    mov al, ch
    call convert
    mov hour[0],ah
    mov hour[1],al
    ;minutes
    mov al,cl
    call convert
    mov min[0],ah
    mov min[1],al
    ;seconds
    mov al, dh
    call convert
    mov sec[0],ah
    mov sec[1],al
endm

;Macro para obtener la fecha actual del sistema
getDate macro
    mov ah,2ah
    int 21h
    ;day
    mov al, dl 
    call convert
    mov dia[0], ah
    mov dia[1], al
    ;month
    mov al, dh
    call convert
    mov mes[0], ah
    mov mes[1], al
    ;year
    ;mov year, cx
endm


;* █░░ █▀█ █▀▀ █ █▄░█   ░░▄▀   █░░ █▀█ █▀▀ █▀█ █░█ ▀█▀
;* █▄▄ █▄█ █▄█ █ █░▀█   ▄▀░░   █▄▄ █▄█ █▄█ █▄█ █▄█ ░█░

getUSUARIOS macro
    openFile USERSTET, handler ;* Abro EL ARCHIVO DE USERS.tet
    readFile handler, buferdedatos, 1000
    cerrar handler
endm

login MACRO
    LOCAL ESUSERNORMAL,ERR,SALIR
    PUSHA
    STARTINT:
    PAINTTEXT txLOGIN , 0820H , GREEN
    PAINTTEXT txUSUARIO , 0F10h , LIGHT_BLUE
    PAINTTEXT txCONTRASENA , 1210H , LIGHT_BLUE
    ;* leo el NOMBRE DE USUARIO
    poscursor 15, 38
    getStr MYuserName
    ;* leo la CONTRASENA
    poscursor 18, 38
    getStrPASS MYuserPass

    ; ESELADMIN:
    ;     isequal MYuserName, ADMINCREDUSER, 13
    ;     cmp TEMP, 0
    ;     je ESUSERNORMAL
    ;     isequal MYuserPass, ADMINCREDPASS, 13
    ;     cmp TEMP, 0
    ;     JE ERR
        ; SESIONADMIN
    ESUSERNORMAL:
        BUSCARUSER
        cmp TEMP, 0
        je ERR
        JMP SALIR
        ; SESIONUSER
    ERR:
        COOLDOWN
        cleanBuffer MYuserName
        cleanBuffer MYuserPass


        poscursor 22, 30
        print error1
        readtext

    BLOQUEARYSALIR:
        BLOQUEAR
        JMP PRINCIPALMENULABEL
    SALIR:
    POPA
ENDM login
logup MACRO
    LOCAL buc, buct,sigo2, ERR2,ERR3,ERR4,ERR5,ERR6,ERR7,ERR8,ERR9, SALIDA
    PUSHA
    PAINTTEXT txLOGUP , 0820H , 0FF26H
    PAINTTEXT txUSUARIO , 0F10h , 0FF0FH
    PAINTTEXT txCONTRASENA , 1210H , 0FF0FH
    ;* ********************leo el NOMBRE DE USUARIO********************
    poscursor 15, 38
    getStr MYuserName
    ;? a.	No puede empezar por número
    ;? b.	la longitud debe validarse entre 8 y 15 caracteres *
    ;? c.	el nombre del usuario no debe existir
    ;? d.	los únicos caracteres especiales que pueden contener serán:
    ;? i.	guión
    ;? ii.	guion bajo
    ;? iii.	punto
    getLen MYuserName
    cmp TEMP, 8
    JL ERR4
    cmp TEMP, 15
    JG ERR4
    Xor dx, dx
    NOMBREUSADO
    CMP dx, 1
    JE ERR9
    
    MOV TEMP, 0
    ESNUMERO MYuserName[0]
    CMP TEMP, 1
    JE ERR3
    
    xor di, di
    buc:        ; * BUcle para saber si los caracteres son validos
        ESCHARPERMITIDO MYuserName[di]
        CMP dx, 0
        JE ERR2
        CMP MYuserName[di+1], "$"
        JE sigo2
        JNE buct
        buct:
            inc di
            JMP buc
    sigo2:
    ;* ******************** leo la CONTRASENA ********************
    poscursor 18, 38
    getStrPASS MYuserPass
    ;? 2.	se solicitará la contraseña para el usuario y se harán las siguientes validaciones:
    ;? a.	debe tener al menos 3 mayúsculas
    ;? b.	debe tener al menos 2 números
    ;? c.	debe tener al menos 2 caracteres especiales de los siguientes:
    ;? i.	Arroba (@)
    ;? ii.	Mayor que (>)
    ;? iii.	Numeral (#)
    ;? iv.	Más (+)
    ;? v.	asterisco (*)
    ;? d.	La longitud debe validarse entre 16 y 20 caracteres
    getLen MYuserPass
    cmp TEMP, 16
    JL ERR8
    cmp TEMP, 20
    JG ERR8

    MOV TEMP, 0
    CONTARMAYUSCULAS
    CMP TEMP, 3
    JL ERR5
    CONTARNUMEROS
    CMP TEMP, 2
    JL ERR6
    CONTARESPECIALES
    CMP TEMP, 2
    JL ERR7

    ;! AHORA SI GUARDO MI USUARIO NUEVO EL QUE SE VA A AGREGAR.
    SAVEUSERINFILE MyuserName, MyuserPass
    cleanBuffer MYuserName
    cleanBuffer MYuserPass
    JMP SALIDA

    ERR2:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error2
        readtext
        JMP PRINCIPALMENULABEL
    ERR3:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error3
        readtext
        JMP PRINCIPALMENULABEL
    ERR4:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error4
        readtext
        JMP PRINCIPALMENULABEL
    ERR5:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error5
        readtext
        JMP PRINCIPALMENULABEL
    ERR6:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error6
        readtext
        JMP PRINCIPALMENULABEL
    ERR7:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error7
        readtext
        JMP PRINCIPALMENULABEL
    ERR8:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error8
        readtext
        JMP PRINCIPALMENULABEL
    ERR9:
        poscursor 22, 30
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error9
        readtext
        JMP PRINCIPALMENULABEL
    SALIDA:
    POPA
ENDM logup

BUSCARUSER MACRO ;! IMPORTANTE BUSCAR EL USUARIO EN EL ARCHIVO
    LOCAL fin,limpiarycont,NOSEENCONTRO,REVISARNOMBRE,continuar,while,buscaand,sigoauxi,nextchariscategory,yahaynombre
    PUSHA
    getUSUARIOS
    mov dx, 0
    MOV SI, 0
    xor ax, ax;* flag for to say the status. 0 = getUser
    xor bx, bx
    xor cx, cx  ;* 1 = find the char of exit '\n' is my pivote
    while:   ;!  NAME,PASS&0%0  \10
        cmp si, tamfile
        je NOSEENCONTRO
        xor ah, ah
        mov al, buferdedatos[si]
        ;* COMPARAMOS CADA CARACTER DEL BUFFER
        CMP al, 10 ; ? si es FIN DE LINEA SALTA
        je limpiarycont
        cmp al, ','  ; ? si es COMA YA TENGO EL USER EN MYAUX
        je REVISARNOMBRE
        CMP TEMP, 2  ; ? si 2 el temp porque ya encontro el user
        JE buscaand
        JNE sigoauxi
        buscaand:
            CMP al, "&" ;? si es & EL SIGUIENTE ES LA CATEGORY
            JE nextchariscategory
        sigoauxi:
        mov MYauxUserName2[bx], al
        inc bx
        jmp continuar
        continuar:
            inc si
            jmp while
        nextchariscategory:
            getLen MYuserPass   ;! COMPARO MI CONTRASENA
            isequal MYuserPass, MYauxUserName2, TEMP
            print MyuserPass
            print saltolinea
            print MYauxUserName2
            JMP fin
        limpiarycont:
            xor bx, bx
            cleanBuffer MYuserName
            jmp continuar
        yahaynombre:
            mov TEMP, 2
            JMP continuar
    REVISARNOMBRE:
        getLen MYuserName
        isequal MYuserName, MYauxUserName2, TEMP
        cleanBuffer MYauxUserName2
        xor bx, bx
        xor cx, cx
        cmp TEMP, 1
        je yahaynombre
        jmp continuar
    NOSEENCONTRO:
        MOV TEMPDB, '2'
    fin:
        cleanBuffer buferdedatos
        cleanBuffer MYauxUserName
    POPA
ENDM
NOMBREUSADO MACRO
    LOCAL while, REVISARNOMBRE,CAMBIODESTATUS , cont,finalizooo
    getUSUARIOS
    mov dx, 0
    MOV SI, 0
    xor ax, ax
    xor bx, bx
    xor cx, cx  ;* flag for to say the status. 0 = getUser
                ;* 1 = find the char of exit '\n' is my pivote

    while:   ;!  NAME , PASS , 0 , 0
        cmp si, tamfile
        je finalizooo
        xor ah, ah
        mov al, buferdedatos[si]
        ;* COMPARAMOS CADA CARACTER DEL BUFFER
        cmp al, 10
        je REVISARNOMBRE  ; ? si es FIN DE LINEA ve el nombre
        cmp cx, 1    ;? flag para saltarse el resto de linea
        je cont
        cmp al, ','  ;? 
        je CAMBIODESTATUS
        mov MYauxUserName[bx], al
        inc bx
        jmp cont
        CAMBIODESTATUS:
            mov cx, 1
        cont:
            inc si
            jmp while
    

    REVISARNOMBRE:
        getLen MyuserName
        isequal MyuserName, MYauxUserName, TEMP
        cleanBuffer MYauxUserName
        xor bx, bx
        xor cx, cx
        cmp TEMP, 1
        je finalizooo
        jmp cont
    finalizooo:

        cleanBuffer MYauxUserName
        cleanBuffer buferdedatos
ENDM
SAVEUSERINFILE MACRO user, pass ;! GUARDAR EN EL ARCHIVO EL NUEVO USUARIO (NAME AND PASS)
    openFile USERSTET, handler ; open my file Users.tet
    getLen user  ;* take the length of my user
    seekEnd handler ;* update the cursor or the pointer in the file writing
    writeFile handler, user, TEMP ;* write THE USER AND THE PASS.
    MOV TEMPDB, ','
    writeFile handler, TEMPDB, 1
    getLen pass  ;* take the length of my pass
    writeFile handler, pass, TEMP ;* write THE USER AND THE PASS.
    MOV TEMPDB, '&'
    writeFile handler, TEMPDB, 1
    writeFile handler, CATEGORIA, 1
    MOV TEMPDB, '%'
    writeFile handler, TEMPDB, 1
    writeFile handler, BLOQUEO, 1
    writeFile handler, nuevalinea, 1         ;?==>    JUANITO,ABC123@@@,0,0,0  \n
    cerrar handler
    PAINTTEXT savedmessage , 2125H , 0FF30H
    readtext
ENDM

;* ------------------------TIPOS DE USERS--------------------------
PROMOVER MACRO
    ;* SI CATEGORY ES 1 --->mensaje "NO PUEDE PROMOVER YA ES UN ADMINISTRADOR EL USER"
    ;*SI CATEGORY ES 0 ---> 'USUARIO PROMOVIDO AHORA ES UN PRO ;v"
    LOCAL SOLOMESSAGE,PROMOVERFILE,SALIDA,erroruser
    PUSHA
    poscursor 6, 25
    print msgUSERTOPROMOVE
    poscursor 8, 30
    getStr MYauxUserName ;! pido el nombre a PROMOVER
    TOMARCATEGORIA MYauxUserName
    CMP TEMPDB, '1'
    JE SOLOMESSAGE
    JNE PROMOVERFILE
    SOLOMESSAGE:
        poscursor 22,30
        print msgyaesadmin
        JMP SALIDA
    PROMOVERFILE:
        CMP TEMPDB, '2'
        JE erroruser
        getUSUARIOS
        MOV SI, handler2
        Mov buferdedatos[SI], '1'
        crear USERSTET, handler
        getLen buferdedatos
        writeFile handler, buferdedatos, TEMP
        cerrar handler
        poscursor 22,30
        print msgpromovido
        JMP SALIDA
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
ENDM
DEGRADAR MACRO
    ;* SI CATEGORY ES 1 --->	USUARIO DEGRADADO AHORA ES UN ESCLAVO ;v"
    ;* SI CATEGORY ES 0 ---> 	mensaje "NO SE PUEDE DEGRADAR YA ES UN USUARIO NORMAL"
    LOCAL SOLOMESSAGE,DEGRADARFILE,SALIDA,erroruser
    PUSHA
    poscursor 6, 25
    print msgUSERTODEGRADE
    poscursor 8, 30
    getStr MYauxUserName ;! pido el nombre a DEGRADAR
    TOMARCATEGORIA MYauxUserName
    CMP TEMPDB, '0'
    JE SOLOMESSAGE
    JNE DEGRADARFILE
    SOLOMESSAGE:
        poscursor 22,30
        print msgyaesnormal
        JMP SALIDA
    DEGRADARFILE:
        CMP TEMPDB, '2'
        JE erroruser
        getUSUARIOS
        MOV SI, handler2
        Mov buferdedatos[SI], '0'
        crear USERSTET, handler
        getLen buferdedatos
        writeFile handler, buferdedatos, TEMP
        cerrar handler
        poscursor 22,30
        print msgdegradado
        JMP SALIDA
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
ENDM
DESBLOQUEAR MACRO
    ;* SI BLOQUEO ES 1 --->	cambio bloqueo a 0 
    ;* SI BLOQUEO ES 0 ---> 	mensaje el "USER ESTA DESBLOQUEADO"
    LOCAL SOLOMESSAGE,UNLOCKFILE,SALIDA,erroruser
    PUSHA
    getStr MYauxUserName ;! pido el nombre a UNLOCK
    TOMARBLOQUEO MYauxUserName
    CMP TEMPDB, '0'
    JE SOLOMESSAGE
    JNE UNLOCKFILE
    SOLOMESSAGE:
        poscursor 22,30
        print msgestaunlock
        JMP SALIDA
    UNLOCKFILE:
        CMP TEMPDB, '2'
        JE erroruser
        getUSUARIOS
        MOV SI, handler2
        Mov buferdedatos[SI], '0'
        crear USERSTET, handler
        getLen buferdedatos
        writeFile handler, buferdedatos, TEMP
        cerrar handler
        poscursor 22,30
        print msgdegradado
        JMP SALIDA
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
ENDM
BLOQUEAR MACRO
    ;* SI BLOQUEO ES 1 --->	cambio bloqueo a 0 
    ;* SI BLOQUEO ES 0 ---> 	mensaje el "USER ESTA DESBLOQUEADO"
    LOCAL SOLOMESSAGE,UNLOCKFILE,SALIDA,erroruser
    PUSHA
    TOMARBLOQUEO MYUserName
    CMP TEMPDB, '1'
    JE SOLOMESSAGE
    JNE UNLOCKFILE
    SOLOMESSAGE:
        poscursor 22,30
        print msgestalock
        JMP SALIDA
    UNLOCKFILE:
        CMP TEMPDB, '2'
        JE erroruser
        getUSUARIOS
        MOV SI, handler2
        Mov buferdedatos[SI], '1'
        crear USERSTET, handler
        getLen buferdedatos
        writeFile handler, buferdedatos, TEMP
        cerrar handler
        poscursor 22,30
        print msgbloqueado
        JMP SALIDA
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
ENDM

VALIDARTIPODEUSUARIO MACRO
    TOMARBLOQUEO MyuserName
    CMP TEMPDB, '1'
    JE ERRORUSUARIOBLOQUEADO

    TOMARCATEGORIA MyuserName
    CMP TEMPDB, '2'
    JE MOSTRARMENUADMIN
    CMP TEMPDB, '0'
    JE MOSTRARMENUNORMAL
    JE MOSTRARMENUUSERADMIN

ENDM
COOLDOWN MACRO

    TOMARBLOQUEO MyuserName
    INC cooldowncont
    DELAY 30000
    CMP cooldowncont, 3
    JE BLOQUEARYSALIR
    JMP STARTINT
ENDM
;! =========================TAKE DATA FROM THE USERS.TET==============================
TOMARCATEGORIA MACRO usr
    LOCAL fin,limpiarycont,NOSEENCONTRO,REVISARNOMBRE,continuar,while,buscaand,sigoauxi,nextchariscategory,yahaynombre
    PUSHA
    getUSUARIOS
    mov dx, 0
    MOV SI, 0
    xor ax, ax
    xor bx, bx
    xor cx, cx  ;* flag for to say the status. 0 = getUser
                ;* 1 = find the char of exit '\n' is my pivote

    while:   ;!  NAME,PASS&0%0  \10
        cmp si, tamfile
        je NOSEENCONTRO
        xor ah, ah
        mov al, buferdedatos[si]
        ;* COMPARAMOS CADA CARACTER DEL BUFFER
        CMP al, 10 ; ? si es FIN DE LINEA SALTA
        je limpiarycont
        cmp al, ','  ; ? si es COMA YA TENGO EL USER EN MYAUX
        je REVISARNOMBRE
        CMP TEMP, 2  ; ? si 2 el temp porque ya encontro el user
        JE buscaand
        JNE sigoauxi
        buscaand:
            CMP al, "&" ;? si es & EL SIGUIENTE ES LA CATEGORY
            JE nextchariscategory
        sigoauxi:
        mov MYauxUserName2[bx], al
        inc bx
        jmp continuar
        continuar:
            inc si
            jmp while
        nextchariscategory:
            mov al, buferdedatos[si+1]
            MOV TEMPDB, al   ;! TOMA SI ES 0 o SI ES 1
            inc si
            MOV handler2, si
            JMP fin
        limpiarycont:
            xor bx, bx
            cleanBuffer MYauxUserName2
            jmp continuar
        yahaynombre:
            mov TEMP, 2
            JMP continuar
    REVISARNOMBRE:
        getLen usr
        isequal usr, MYauxUserName2, TEMP
        cleanBuffer MYauxUserName2
        xor bx, bx
        xor cx, cx
        cmp TEMP, 1
        je yahaynombre
        jmp continuar
    NOSEENCONTRO:
        MOV TEMPDB, '2'
    fin:
        cleanBuffer buferdedatos
        cleanBuffer MYauxUserName
    POPA
ENDM
TOMARBLOQUEO MACRO usr
    LOCAL fin,limpiarycont,NOSEENCONTRO,REVISARNOMBRE,continuar,while,buscaand,sigoauxi,nextchariscategory,yahaynombre
    PUSHA
    getUSUARIOS
    mov dx, 0
    MOV SI, 0
    xor ax, ax
    xor bx, bx
    xor cx, cx  ;* flag for to say the status. 0 = getUser
                ;* 1 = find the char of exit '\n' is my pivote

    while:   ;!  NAME,PASS&0%0  \10
        cmp si, tamfile
        je NOSEENCONTRO
        xor ah, ah
        mov al, buferdedatos[si]
        ;* COMPARAMOS CADA CARACTER DEL BUFFER
        CMP al, 10 ; ? si es FIN DE LINEA SALTA
        je limpiarycont
        cmp al, ','  ; ? si es COMA YA TENGO EL USER EN MYAUX
        je REVISARNOMBRE
        CMP TEMP, 2  ; ? si 2 el temp porque ya encontro el user
        JE buscaand
        JNE sigoauxi
        buscaand:
            CMP al, "&" ;? si es & EL SIGUIENTE ES LA CATEGORY
            JE nextchariscategory
        sigoauxi:
        mov MYauxUserName2[bx], al
        inc bx
        jmp continuar
        continuar:
            inc si
            jmp while
        nextchariscategory:
            mov al, buferdedatos[si+3]
            MOV TEMPDB, al   ;! TOMA SI ES 0 o SI ES 1
            inc si
            inc si
            inc si
            MOV handler2, si
            JMP fin
        limpiarycont:
            xor bx, bx
            cleanBuffer MYauxUserName2
            jmp continuar
        yahaynombre:
            mov TEMP, 2
            JMP continuar
    REVISARNOMBRE:
        getLen usr
        isequal usr, MYauxUserName2, TEMP
        cleanBuffer MYauxUserName2
        xor bx, bx
        xor cx, cx
        cmp TEMP, 1
        je yahaynombre
        jmp continuar
    NOSEENCONTRO:
        MOV TEMPDB, '2'
    fin:
        cleanBuffer buferdedatos
        cleanBuffer MYauxUserName
    POPA
ENDM

;! =========================TAKE DATA FROM THE PUNT.TET==============================
getSCORES macro
    openFile punttet, handler ;* Abro EL ARCHIVO DE USERS.tet
    readFile handler, buferdedatos, 1000
    cerrar handler
endm
SAVESCOREINFILE MACRO;! GUARDAR EN EL ARCHIVO EL NUEVO USUARIO (NAME AND PASS)
    ; ?  NOMBRE_USER , SCORE &  TIME % ID
    ; ?  Alvaro , 20 &  80 % 1
    ; ?  Emanuel, 15 &  69 % 2
    openFile punttet, handler ; open my file punt.tet
    getLen MyuserName  ;* take the length of my user
    seekEnd handler ;* update the cursor or the pointer in the file writing
    writeFile handler, MyuserName, TEMP ;* write THE USER AND THE PASS.
    
    MOV TEMPDB, ',' ;! SCORE
    writeFile handler, TEMPDB, 1

    toString SCORE, Stringpuntos
    getLen Stringpuntos  ;* take the length of my    SCORE
    writeFile handler, Stringpuntos, TEMP ;* WRITE SCORE
    
    MOV TEMPDB, '&' ;! TIME IN SECS
    writeFile handler, TEMPDB, 1

    toString RESULTADOPREVIO, StringRESULTADOPREVIO
    getLen StringRESULTADOPREVIO  ;* take the length of my    SCORE
    writeFile handler, StringRESULTADOPREVIO, TEMP ;* WRITE SCORE
    
    MOV TEMPDB, '%' ;! COUNTER
    writeFile handler, TEMPDB, 1

    toString CONTADORUSERS, sTRINGCONTADORUSERS
    getLen sTRINGCONTADORUSERS  ;* take the length of my Counter
    writeFile handler, sTRINGCONTADORUSERS, TEMP
    INC CONTADORUSERS
    
    writeFile handler, nuevalinea, 1         ;?==>    JUANITO,ABC123@@@,0,0,0  \n
    cerrar handler
    PAINTTEXT savedmessage2, 2125H , 0FF30H
    readtext
ENDM


LOAD_ALLUSER MACRO ;! IMPORTANTE BUSCAR EL USUARIO EN EL ARCHIVO
   LOCAL while, sigoauxi, continuar, GUARDARSCORE, GUARDARtime, GUARDARID, limpiarycont
    PUSHA
    getSCORES          ; ?  NOMBRE_USER , SCORE &  TIME % ID
    mov dx, 0
    MOV SI, 0
    xor ax, ax;* flag for to say the status. 0 = getUser
    xor bx, bx
    xor cx, cx  ;* 1 = find the char of exit '\n' is my pivote
    MOV POS_ID, 0
    MOV POS_TIME, 0
    MOV POS_SCORE, 0
    cleanBuffer SCORES_LIST
    cleanBuffer TIMES_LIST
    cleanBuffer ID_LIST
    while:   ;!  NAME,PASS&0%0  \10
        cmp si, tamfile
        je fin
        xor ah, ah
        mov al, buferdedatos[si]
        ;* COMPARAMOS CADA CARACTER DEL BUFFER
        
        cmp al, ','  ; ? si es COMA BORRO
        JE limpiarycont

        CMP al, "&" ;? tendo SCORE
        JE GUARDARSCORE ;* salto

        CMP al, "%" ;? tendo TIEMPO
        JE GUARDARtime

        CMP al, 10 ; ? si es FIN DE LINEA TENGO ID
        JE GUARDARID
        JNE sigoauxi

        sigoauxi:
            mov MYauxUserName2[bx], al
            inc bx
            jmp continuar
            continuar:
                inc si
                jmp while
        GUARDARSCORE:
            ;! Aqui MyauxUserName2 tiene el SCORE
            toNumber MYauxUserName2 ;TEMP4
            ;* POSICIONO Y AGREGO A SCORES_LIST
            PUSH DI
            MOV DI, POS_SCORE
            MOV BX, TEMP4
            MOV SCORES_LIST[DI], BX
            INC POS_SCORE
            INC POS_SCORE
            POP DI
            jmp limpiarycont
        GUARDARtime:
            ;! Aqui MyauxUserName2 tiene el TIME
            toNumber MYauxUserName2;TEMP4
            ;* POSICIONO Y AGREGO A TIMES_LIST
            PUSH DI
            MOV DI, POS_TIME
            MOV BX, TEMP4
            MOV TIMES_LIST[DI], BX
            INC POS_TIME
            INC POS_TIME
            POP DI
            jmp limpiarycont
        GUARDARID:
            ;! Aqui MyauxUserName2 tiene el ID
            toNumber MYauxUserName2;TEMP4
            ;* POSICIONO Y AGREGO A ID_LIST
            PUSH DI
            MOV DI, POS_ID
            MOV BX, TEMP4
            MOV ID_LIST[DI], BX
            INC POS_ID
            INC POS_ID
            POP DI
            jmp limpiarycont
        limpiarycont:
            xor bx, bx
            cleanBuffer MYuserName
            jmp continuar
    fin:
        cleanBuffer buferdedatos
        cleanBuffer MYauxUserName
    POPA
ENDM

LOAD_CURRENT_USER MACRO ;! IMPORTANTE BUSCAR EL USUARIO EN EL ARCHIVO
    LOCAL REVISARNOMBRE,while, sigoauxi, continuar, GUARDARSCORE, GUARDARtime, GUARDARID, limpiarycont
    PUSHA
    getSCORES          ; ?  NOMBRE_USER , SCORE &  TIME % ID
    mov dx, 0
    MOV SI, 0
    xor ax, ax;* flag for to say the status. 0 = getUser
    xor bx, bx
    xor cx, cx  ;* 1 = find the char of exit '\n' is my pivote
    MOV POS_ID, 0
    MOV POS_TIME, 0
    MOV POS_SCORE, 0
    cleanBuffer SCORES_LIST
    cleanBuffer TIMES_LIST
    cleanBuffer ID_LIST
    while:   ;!  NAME,PASS&0%0  \10
        cmp si, tamfile
        je fin
        xor ah, ah
        mov al, buferdedatos[si]
        ;* COMPARAMOS CADA CARACTER DEL BUFFER
        
        cmp al, ','  ; ? si es COMA BORRO
        JE REVISARNOMBRE

        cmp TEMP, -1 ;! FILTRAR SOLO LOS QUE SON EL USUARIO ACTUAL
        JNE continuar

        CMP al, "&" ;? tendo SCORE
        JE GUARDARSCORE ;* salto

        CMP al, "%" ;? tendo TIEMPO
        JE GUARDARtime

        CMP al, 10 ; ? si es FIN DE LINEA TENGO ID
        JE GUARDARID
        JNE sigoauxi

        sigoauxi:
            mov MYauxUserName2[bx], al
            inc bx
            jmp continuar
            continuar:
                inc si
                jmp while
        GUARDARSCORE:
            ;! Aqui MyauxUserName2 tiene el SCORE
            toNumber MYauxUserName2 ;TEMP4
            ;* POSICIONO Y AGREGO A SCORES_LIST
            PUSH DI
            MOV DI, POS_SCORE
            MOV BX, TEMP4
            MOV SCORES_LIST[DI], BX
            INC POS_SCORE
            INC POS_SCORE
            POP DI
            jmp limpiarycont
        GUARDARtime:
            ;! Aqui MyauxUserName2 tiene el TIME
            toNumber MYauxUserName2;TEMP4
            ;* POSICIONO Y AGREGO A TIMES_LIST
            PUSH DI
            MOV DI, POS_TIME
            MOV BX, TEMP4
            MOV TIMES_LIST[DI], BX
            INC POS_TIME
            INC POS_TIME
            POP DI
            jmp limpiarycont
        GUARDARID:
            ;! Aqui MyauxUserName2 tiene el ID
            toNumber MYauxUserName2;TEMP4
            ;* POSICIONO Y AGREGO A ID_LIST
            PUSH DI
            MOV DI, POS_ID
            MOV BX, TEMP4
            MOV ID_LIST[DI], BX
            INC POS_ID
            INC POS_ID
            POP DI
            jmp limpiarycont
        limpiarycont:
            xor bx, bx
            cleanBuffer MYuserName
            jmp continuar
        REVISARNOMBRE:
            getLen MYuserName
            isequal MYuserName, MYauxUserName2, TEMP
            cleanBuffer MYauxUserName2
            xor bx, bx
            xor cx, cx
            cmp TEMP, 1
            je SIES
            jmp continuar
        SIES:
            MOV TEMP,-1
            JMP continuar
    fin:
        cleanBuffer buferdedatos
        cleanBuffer MYauxUserName
    POPA
ENDM


OBTAIN_USERNAME MACRO ID ;! RET MYuserNamePARATOP
    PUSHA
    
    POPA
ENDM
; logup MACRO
    ; PUSHA
    
    ; POPA
; ENDM
; logup MACRO
    ; PUSHA
    
    ; POPA
; ENDM
; logup MACRO
    ; PUSHA
    
    ; POPA
; ENDM
; logup MACRO
    ; PUSHA
    
    ; POPA
; ENDM
; logup MACRO
    ; PUSHA
    
    ; POPA
; ENDM


;* Universidad San Carlos de Guatemala Facultad de Ingeniería
;* Escuela de Ciencias y Sistemas
;* Arquitectura de Computadores y Ensambladores 1 Sección A

;* ALVARO EMMANUEL SOCOP PEREZ
;* 202000194

;* Tipo: Bubble Sort | Heap Sort | Quick Sort
;* Sentido: ASCENDENTE | DESCENDENTE
;* Fecha: 21/10/2022
;* Hora: 23:00

;* RANK    PLAYER      N       SCORE   TIME
;* 1       ALVARO              55      454
;* 2       EMMANUEL            554     987
;* NUM /t/t MyuserName  /t/t/t/t SCORE  /t TIME



