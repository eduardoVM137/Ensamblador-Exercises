


CURSOR MACRO FILA, COLUMNA
    MOV AH, 02H
    MOV DH, FILA
    MOV DL, COLUMNA
    MOV BH, 0H
    INT 10H
ENDM

