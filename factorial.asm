; Programa de cálculo de factorial utilizando TASM
; Entrada: Número en hexadecimal o decimal
; Salida: Factorial del número

.MODEL SMALL
.STACK 100H
.DATA
    Numero DW ?                ; Almacena el número ingresado
    Factorial DW 1             ; Variable para almacenar el factorial
    Mensaje DB 'El factorial es: $' ; Mensaje a mostrar
    Mensaje_Ingreso DB 'Ingrese un número: $' ; Solicitud al usuario
.CODE
MAIN PROC
    MOV AX, @DATA              ; Configuración inicial del segmento de datos
    MOV DS, AX

    ; Solicitar el número al usuario
    LEA DX, Mensaje_Ingreso    ; Mostrar mensaje de ingreso
    MOV AH, 09H
    INT 21H

    ; Leer número ingresado
    MOV AH, 01H               ; Leer un carácter
    INT 21H
    SUB AL, '0'               ; Convertir ASCII a valor numérico
    MOV Numero, AX            ; Almacenar en la variable

    ; Calcular el factorial
    MOV CX, Numero            ; Configurar contador
    MOV AX, 1                 ; Inicializar factorial en 1
FactorialLoop:
    MUL CX                    ; AX = AX * CX
    LOOP FactorialLoop        ; Decrementa CX y repite hasta CX = 0
    MOV Factorial, AX         ; Almacenar resultado en Factorial

    ; Mostrar el resultado
    LEA DX, Mensaje           ; Imprimir mensaje
    MOV AH, 09H
    INT 21H

    ; Convertir el número a formato ASCII para imprimir
    MOV AX, Factorial         ; Cargar factorial calculado
    CALL Imprimir_Numero      ; Llamar a rutina para imprimir número

    ; Terminar el programa
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Rutina para imprimir un número en pantalla
Imprimir_Numero PROC
    PUSH AX                   ; Guardar registros
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX                ; Limpia CX para usarlo como contador
    MOV BX, 10                ; Base decimal
ImprimirLoop:
    XOR DX, DX                ; Limpia DX
    DIV BX                    ; Divide AX entre 10, el residuo queda en DX
    PUSH DX                   ; Almacenar el dígito en la pila
    INC CX                    ; Incrementar contador de dígitos
    CMP AX, 0
    JNE ImprimirLoop          ; Repetir mientras AX > 0

    ; Imprimir los dígitos en orden correcto
ImprimirDígitos:
    POP DX                    ; Recuperar dígito
    ADD DL, '0'               ; Convertir a ASCII
    MOV AH, 02H               ; Imprimir carácter
    INT 21H
    LOOP ImprimirDígitos      ; Repetir hasta que CX = 0

    POP DX                    ; Restaurar registros
    POP CX
    POP BX
    POP AX
    RET
Imprimir_Numero ENDP
END MAIN
