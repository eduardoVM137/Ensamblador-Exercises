.MODEL SMALL
.STACK 100H

.DATA
    basePrice DW 5            ; Costo base de la llamada
    additionalMinuteCost DW 3 ; Costo por minuto adicional
    duration DW ?             ; Duración de la llamada
    cost DW ?                 ; Costo total de la llamada
    msg1 DB 'Ingrese la duración de la llamada en minutos: $'
    msg2 DB 'El costo de la llamada es: $'

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar mensaje para pedir duración de la llamada
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    ; Leer duración de la llamada desde el teclado
    MOV AH, 01H
    INT 21H
    SUB AL, '0'               ; Convertir de ASCII a número
    MOV BL, AL
    MOV duration, BX          ; Guardar la duración

    ; Calcular el costo de la llamada
    CMP BL, 3
    JLE BASE_RATE             ; Si la duración es <= 3 minutos, usa tarifa base
    SUB BL, 3
    MOV AX, additionalMinuteCost
    MUL BL                    ; Multiplica el costo adicional por los minutos extra
    ADD AX, basePrice         ; Suma la tarifa base al costo total
    JMP DISPLAY_COST

BASE_RATE:
    MOV AX, basePrice         ; Si es <= 3 minutos, usa tarifa base

DISPLAY_COST:
    MOV cost, AX              ; Guarda el costo calculado

    ; Mostrar el costo de la llamada
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    MOV AX, cost
    CALL PrintNum             ; Llama a la función para imprimir el número

    ; Terminar programa
    MOV AX, 4C00H
    INT 21H

; Procedimiento para imprimir un número
PrintNum PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX                ; Limpia CX, contará los dígitos
    MOV BX, 10                ; Divisor

NEXT_DIGIT:
    XOR DX, DX                ; Limpia DX para la instrucción DIV
    DIV BX                    ; Divide AX entre 10, residuo en DX
    PUSH DX                   ; Almacena el residuo en la pila
    INC CX                    ; Incrementa el contador de dígitos
    CMP AX, 0
    JNE NEXT_DIGIT            ; Si AX no es 0, continúa procesando dígitos

PRINT_DIGIT:
    POP DX                    ; Recupera un dígito de la pila
    ADD DL, '0'               ; Convierte el dígito a su representación ASCII
    MOV AH, 02H
    INT 21H                   ; Interrupción para imprimir el carácter
    LOOP PRINT_DIGIT          ; Repite para todos los dígitos

    ; Restaurar registros
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNum ENDP

END START
