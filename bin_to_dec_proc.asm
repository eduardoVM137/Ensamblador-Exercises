
; Declaraci?n del procedimiento Conversion.
Conversion PROC near
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
    
    RET
Conversion ENDP
