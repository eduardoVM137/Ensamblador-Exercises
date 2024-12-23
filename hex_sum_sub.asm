. MODEL SMALL 
.STACK 100H 
 
.DATA 
    x DW ? 
    y DW ? 
    z DW ? 
    Resultado DB '    $'      
    msjInicio DB 'Suma y Resta de simple precision: W <--- X + Y + 24 ? Z $' 
    EntradaX DB 'Ingrese valor hexadecimal(Mayus) para X: $' 
    EntradaY DB 'Ingrese valor hexadecimal (Mayus para Y: $' 
    EntradaZ DB 'Ingrese valor hexadecimal (Mayus para Z: $' 
    mensaje_continuar db 'Presiona Enter para continuar o cualquier otra tecla para salir.$' 
     msjResultado db 'El valor de W es: $' 
    inputBuffer DB 5 DUP('$')  
 
.CODE 
 
LIMPIA MACRO 
    MOV AX, 0600H 
    MOV BH, 07 
    MOV CX, 0000 
    MOV DX, 184FH 
    INT 10H 
     
    MOV AH, 02 
    MOV DH, 1 ; Fila 1 
    MOV DL, 0  ; Columna 0 
    MOV BH, 0  
    INT 10H 
    ; Imprime titulo 
    lea dx, msjInicio  
    mov ah, 9 
    int 21h 
     
    MOV AH, 02 
    MOV DH, 3 ; Fila 3 
    MOV DL, 0  ; Columna 0 
    MOV BH, 0  
    INT 10H 
ENDM 
CURSOR_ENTER MACRO 
    MOV AH, 02 
    MOV DH, 18 ; Fila 18 
    MOV DL, 0  ; Columna 0 
    MOV BH, 0   
    INT 10H 
ENDM 
MAIN PROC 
    MOV AX, @DATA 
    MOV DS, AX 
     
  inicio: 
  LIMPIA 
        ; leer X del usuario 
         LEA DX, EntradaX 
        MOV AH, 09h 
        INT 21h 
        CALL Leer_Numero 
        MOV x, AX 
    LIMPIA 
        ; leer Y del usuario 
        LEA DX, EntradaY 
        MOV AH, 09h 
        INT 21h 
        CALL Leer_Numero 
        MOV y, AX 
    LIMPIA 
        ;leer Z del usuario 
        LEA DX, EntradaZ 
        MOV AH, 09h 
        INT 21h 
        CALL Leer_Numero 
        MOV z, AX 
                 
    LIMPIA         
                 
        ; Realiza la operacion x + y + 24 - z y guarda el resultado en number 
        MOV AX, x       ; Carga el valor de x en AX 
        ADD AX, y       ; Suma el valor de y a AX 
        ADD AX, 24H      ; Suma 24 a AX 
        SUB AX, z       ; Resta el valor de z de AX 
 
        CALL Numero_A_Letra 
        ; Imprime la cadena hexadecimal 
        MOV AH, 09H 
        LEA DX, msjResultado 
        INT 21H 
         
        MOV AH, 09H 
        LEA DX, Resultado 
        INT 21H 
         
         
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
    mov x, 0 
    mov y, 0 
    mov z, 0 
    jmp inicio ; Salto a 'inicio' 
 
    no_enter: 
    ; Finalizar el programa si no se presiono Enter 
        mov ah, 04ch 
        mov al, 0 
        int 21h 
     
    ; Termina el programa 
    MOV AX, 4C00H 
    INT 21H 
MAIN ENDP 
 
Leer_Numero PROC 
        MOV CX, 4          ; Contador para 4 digitos 
        MOV BX, 0          ; Aquí se almacenara el numero 
        MOV DI, 0           
 
        Leer_Sig_Digito: 
        MOV AH, 01h 
        INT 21h            ; Leer un caracter en AL 
        CALL Convertir_Hex 
        SHL BX, 4 
        ADD BX, AX 
        INC DI 
        LOOP Leer_Sig_Digito 
 
        MOV AX, BX         ; Mover el resultado a AX 
        RET 
 
Leer_Numero ENDP 
 
Convertir_Hex PROC 
    SUB AL, '0'        ; Convertir ASCII a numero 
    CMP AL, 9 
    JA Convertit_Letra 
    JMP Fin 
 
    Convertit_Letra: 
    SUB AL, 7          
    Fin: 
    MOV AH, 0          ; Asegurarse de que AH es 0 
    RET 
 
Convertir_Hex ENDP 
 
Numero_A_Letra PROC 
        PUSH BX                ; Guarda registros en la pila 
        PUSH CX              
        PUSH DX            
 
        MOV CX, 4           ; Inicializa el contador para 4 d?gitos 
        MOV BX, AX         
        LEA DI, Resultado + 3  ; Apunta al final de la cadena, justo antes del '$' 
        Ciclo_Convertir: 
        MOV DX, BX           
        AND DX, 0Fh          
        OR DL, 30h          ; Convierte el digito a su caracter ASCII 
        CMP DL, '9'         ; Verifica si es mayor que '9' 
        JA  EsLetra        ; Ajusta si es una letra A-F 
        JMP Short Digito 
    EsLetra: 
    ADD DL, 7           ; caracter ASCII correspondiente para A-F 
    Digito: 
    MOV [DI], DL        ; Almacena el caracter en la cadena 
        DEC DI              
        SHR BX, 4          
        LOOP Ciclo_Convertir    ; Repite el proceso para el siguiente digito 
 
        POP DX              ; Restaura Registros 
        POP CX               
        POP BX               
        RET 
Numero_A_Letra ENDP 
 
END MAIN 