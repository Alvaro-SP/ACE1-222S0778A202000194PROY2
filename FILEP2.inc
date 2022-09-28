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
    ; jc errorOpening
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
    ; jc errorReading
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
    mov handler,ax
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
