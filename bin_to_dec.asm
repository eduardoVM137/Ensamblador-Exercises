code segment
assume cs:code, ds:code, ss:code
org 100h

IMPRIME_NUMERO MACRO ;interno 6A
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

LEER_VALORES MACRO ;interno
    LEER_OTRA_VEZ:           ; Etiqueta para comenzar la lectura nuevamente
        LEA DX, ASCII       
        MOV AH, 0AH          
        INT 21H          

        ; Aqui comienza la validacion
        MOV SI, OFFSET ASCII+2   
        MOV CL, [SI-1]           ; Carga la longitud de la cadena en CL

    VALIDAR_CADENA:             
        CMP CL, 0                ; Verifica si ya se validaron todos los caracteres
        JE VALIDO                ; Si CL es 0, la cadena es v?lida

        MOV AL, [SI]            
        CMP AL, '0'              
        JE CARACTER_VALIDO       
        CMP AL, '1'              
        JE CARACTER_VALIDO      
        ; Si no es ni '0' ni '1', muestra el mensaje de error y vuelve a leer
        MOV DX, OFFSET MENSAJE_ERROR ; Carga la direcci?n del mensaje de error en DX
        MOV AH, 09H                  
        INT 21H                      ; Interrupci?n de DOS para mostrar el mensaje
        JMP LEER_OTRA_VEZ            ; Vuelve a leer

    CARACTER_VALIDO:
        INC SI                       ; Incrementa SI para ir al siguiente caracter
        DEC CL                       ; Decrementa CL
        JMP VALIDAR_CADENA           ; Vuelve a validar

    VALIDO:
    ; Continuar si la cadena es valida
        JMP VALORES_VALIDADOS  
ENDM

LIMPIA MACRO ; externo
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH ; Las coordenadas de DX representan la esquina inferior derecha de la pantalla
    INT 10H       ; Limpia la pantalla en el modo de texto
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
            CURSOR 2,0

            LEA DX, Ingrese_Valor
            MOV AH, 9
            INT 21H

            LEER_VALORES
            VALORES_VALIDADOS:
            ; Normalizaci?n a 16 d?gitos
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

                ; Inicializar variables para conversi?n
                mov decimal, 0
                mov base, 2
                mov posicion, 1

                ; Conversi?n de binario a decimal
                MOV CX, 16
                MOV SI, 15
                CICLO:
                    MOV ax, posicion
                    mov bl, [binario + si]
                    mov bh, 0
                    mul bx
                    add decimal, ax
                    mov ax, base
                    mul posicion
                    mov posicion, ax
                    dec si
                    loop CICLO

                mov dx, 0d14h
                LIMPIA
                CURSOR 2,0

                
                lea dx, Resultado
                mov ah, 9
                int 21h
             
                CURSOR 18,0
                IMPRIME_NUMERO 
                ; Bucle para volver a solicitar un valor
                lea dx, mensaje_continuar
                mov ah, 9
                int 21h

                ; Leer la tecla presionada
                mov ah, 0
                int 16h
                cmp al, 13 ; Comprobar si es Enter (c?digo ASCII 13)
                jne no_enter ; Si no es Enter, salta a no_enter

                ; Reiniciar variables
                mov [ASCII + 1], 0
                mov [binario + 15], 0
                mov decimal, 0
                jmp inicio ; Salto incondicional largo a 'inicio'

        no_enter:
            ; Finalizar el programa si no se presion? Enter
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

INCLUDE C:\ACH\mac.asm
code ends
end main

