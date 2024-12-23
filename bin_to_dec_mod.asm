code segment
assume cs:code, ds:code, ss:code
org 100h
; Proc Externo


; Proc Interno
LEER_VALORES_Y_VALIDACION PROC near
     
    LEER_OTRA_VEZ:           ; Etiqueta para comenzar la lectura nuevamente
        LEA DX, ASCII        ;
        MOV AH, 0AH          
        INT 21H             

        ; Aqui comienza la validacion
        MOV SI, OFFSET ASCII+2   
        MOV CL, [SI-1]           ; Carga la longitud de la cadena en CL

        VALIDAR_CADENA:           ; Etiqueta para comenzar la validacion de la cadena
        CMP CL, 0                ; Verifica si ya se validaron todos los caracteres
        JE VALIDO                ; Si CL es 0, la cadena es v?lida

        MOV AL, [SI]             ; Carga el caracter actual en AL y compara si es 0 o 1
        CMP AL, '0'              
        JE CARACTER_VALIDO       
        CMP AL, '1'             
        JE CARACTER_VALIDO       
        ; Si no es ni '0' ni '1', muestra el mensaje de error y vuelve a leer
        MOV DX, OFFSET MENSAJE_ERROR ;
        MOV AH, 09H                  
        INT 21H                      ; Interrupcion para mostrar el mensaje
        JMP LEER_OTRA_VEZ            ; Vuelve a leer

    CARACTER_VALIDO:
        INC SI                       ; Incrementa SI para ir al siguiente caracter
        DEC CL                      
        JMP VALIDAR_CADENA           ; Vuelve a validar el siguiente car?cter

    VALIDO:
        RET
LEER_VALORES_Y_VALIDACION ENDP

; Proc Interno
Normalizacion PROC near
        MOV BH, 0
        MOV BL, [ASCII + 1]
        MOV CX, BX
        MOV SI, 15
    RELLLENA:
        MOV AL, [ASCII + BX + 1]
        SUB AL, 30H
        MOV [BINARIO + SI], AL
        DEC BX
        DEC SI
        LOOP RELLLENA
        RET
Normalizacion ENDP


; Macros 
MOSTRAR_RESULTADO MACRO
  lea dx, Resultado
    mov ah, 9
    int 21h
    mov dx, 0
    mov ax, DECIMAL
    mov bx, 10
    mov cx, 0
    bucle:
        div bx
        push dx
        sub dx, dx
        inc cx
        cmp ax, 0
        jne bucle
    bucle2:
        mov ah, 2
        pop dx
        add dl, 48d
        int 21h
        loop bucle2
ENDM

LIMPIA MACRO
    MOV AX, 0600H
    MOV BH, 07
    MOV CX, 0000
    MOV DX, 184FH
    INT 10H
ENDM

CURSOR_INICIO MACRO
    MOV AH, 02
    MOV DH, 2 ; Fila 20 (0 base)
    MOV DL, 0  ; Columna 0
    MOV BH, 0 
    INT 10H
ENDM
CURSOR_ENTER MACRO
    MOV AH, 02
    MOV DH, 18 ; Fila 20 (0 base)
    MOV DL, 0  ; Columna 0
    MOV BH, 0  
    INT 10H
ENDM

    main proc
        mov ax, cs
        mov ds, ax
        mov es, ax

        inicio:
            LIMPIA
            xor ax, ax
            mov di, offset binario
            mov cx, 16
            rep stosb
            mov [decimal], ax
            MOV DX, 0B14H
            
            CURSOR_INICIO

            LEA DX, Ingrese_Valor
            MOV AH, 9
            INT 21H

            CALL   LEER_VALORES_Y_VALIDACION
            
            VALORES_VALIDADOS:
                        CALL    Normalizacion
                        CALL    Conversion
                        CURSOR_INICIO
                        LIMPIA
                        MOSTRAR_RESULTADO 
                        CURSOR_ENTER
                        ; Bucle para volver a solicitar un valor O ENTER
                        lea dx, mensaje_continuar
                        mov ah, 9
                        int 21h

                        ; Leer la tecla presionada
                        mov ah, 0
                        int 16h
                        cmp al, 13 ; Comprobar si es Enter (codigo ASCII 13)
                        jne no_enter ; Si no es Enter, salta a no_enter

                        ; Reiniciar variables
                        mov [ASCII + 1], 0
                        mov [binario + 15], 0
                        mov decimal, 0
                        jmp inicio ; Salto incondicional largo a 'inicio'

                        no_enter:
                        ; Finalizar el programa si no se presiono Enter
                            mov ah, 04ch
                            mov al, 0
                            int 21h
    main endp

Ingrese_Valor db 'Teclee un valor en BINARIO: $'
mensaje_continuar db 'Presiona Enter para continuar o cualquier otra tecla para salir.$'
ascii db 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
binario db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
decimal dw 0
Resultado db 'El valor en decimal es: $'
base dw 2
posicion dw 1 
MENSAJE_ERROR DB 'Error: Solo se permiten los caracteres 0 y 1(Escribe alguno para continuar)..$'


INCLUDE C:\ACH\conv.asm
code ends
end main
