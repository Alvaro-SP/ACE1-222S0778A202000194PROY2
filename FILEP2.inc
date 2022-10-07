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
    LOCAL ESELADMIN,ESUSERNORMAL,ERR
    PUSHA
    PAINTTEXT txLOGIN , 0820H , GREEN
    PAINTTEXT txUSUARIO , 0F10h , LIGHT_BLUE
    PAINTTEXT txCONTRASENA , 1210H , LIGHT_BLUE
    ;* leo el NOMBRE DE USUARIO
    poscursor 15, 38
    getStr MYuserName
    ;* leo la CONTRASENA
    poscursor 15, 38
    getStr MYuserPass

    ESELADMIN:
        isequal MYuserName, ADMINCREDUSER, 13
        cmp TEMP, 0
        je ESUSERNORMAL
        isequal MYuserPass, ADMINCREDPASS, 13
        cmp TEMP, 0
        JE ERR
        ; SESIONADMIN
    ESUSERNORMAL:
        BUSCARUSER
        cmp dx, 0
        je ERR
        ; SESIONUSER
    ERR:
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error1
        readtext
        JMP PRINCIPALMENULABEL
    POPA
ENDM login
logup MACRO
    LOCAL buc, buct,sigo2, ERR2,ERR3,ERR4,ERR5,ERR6,ERR7,ERR8,ERR9, SALIDA
    PUSHA
    PAINTTEXT txLOGUP , 0820H , 0FF26H
    PAINTTEXT txUSUARIO , 0F10h , 0FF0FH
    PAINTTEXT txCONTRASENA , 1210H , 0FF0FH
    ;* leo el NOMBRE DE USUARIO
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
    
    xor dx, dx
    ESNUMERO MYuserName[0]
    CMP dx, 1
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
    ;* leo la CONTRASENA
    
    poscursor 17, 38
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

    xor dx, dx
    CONTARMAYUSCULAS
    CMP dx, 1
    JE ERR5
    CONTARNUMEROS
    CMP dx, 1
    JE ERR6
    CONTARESPECIALES
    CMP dx, 1
    JE ERR7

    ;! AHORA SI GUARDO MI USUARIO NUEVO EL QUE SE VA A AGREGAR.
    SAVEUSERINFILE MyuserName, MyuserPass
    cleanBuffer MYuserName
    cleanBuffer MYuserPass
    JMP SALIDA

    ERR2:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error2
        readtext
        JMP PRINCIPALMENULABEL
    ERR3:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error3
        readtext
        JMP PRINCIPALMENULABEL
    ERR4:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error4
        readtext
        JMP PRINCIPALMENULABEL
    ERR5:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error5
        readtext
        JMP PRINCIPALMENULABEL
    ERR6:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error6
        readtext
        JMP PRINCIPALMENULABEL
    ERR7:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error7
        readtext
        JMP PRINCIPALMENULABEL
    ERR8:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error8
        readtext
        JMP PRINCIPALMENULABEL
    ERR9:
        poscursor 22, 38
        cleanBuffer MYuserName
        cleanBuffer MYuserPass
        print error9
        readtext
        JMP PRINCIPALMENULABEL
    SALIDA:
    POPA
ENDM logup

BUSCARUSER MACRO ;! IMPORTANTE BUSCAR EL USUARIO EN EL ARCHIVO
    PUSHA
    getUSUARIOS

    POPA
ENDM BUSCARUSER
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
    writeFile handler, coma, 1
    getLen pass  ;* take the length of my pass
    writeFile handler, pass, TEMP ;* write THE USER AND THE PASS.
    writeFile handler, coma, 1
    writeFile handler, CATEGORIA, 1
    writeFile handler, coma, 1
    writeFile handler, BLOQUEO, 1
    writeFile handler, nuevalinea, 1         ;?==>    JUANITO,ABC123@@@,0,0,0  \n
    cerrar handler
    PAINTTEXT savedmessage , 2125H , 0FF30H
    readtext
ENDM SAVEUSERINFILE

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
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
ENDM
DEGRADAR MACRO
    ;* SI CATEGORY ES 1 --->	USUARIO DEGRADADO AHORA ES UN ESCLAVO ;v"
    ;* SI CATEGORY ES 0 ---> 	mensaje "NO SE PUEDE DEGRADAR YA ES UN USUARIO NORMAL"
    LOCAL SOLOMESSAGE,DEGRADARFILE,SALIDA
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
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
ENDM
DESBLOQUEAR MACRO
    ;* SI BLOQUEO ES 1 --->	cambio bloqueo a 0 
    ;* SI BLOQUEO ES 0 ---> 	mensaje el "USER ESTA DESBLOQUEADO"
    LOCAL SOLOMESSAGE,UNLOCKFILE,SALIDA
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
    erroruser:
        print error10
    SALIDA:
        cleanBuffer MYauxUserName
    POPA
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
        print usr
        print MYauxUserName2
        print saltolinea
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
        print usr
        print MYauxUserName2
        print saltolinea
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
; logup MACRO
    ; PUSHA
    
    ; POPA
; ENDM






