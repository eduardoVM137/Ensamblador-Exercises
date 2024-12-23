.model small
.stack 100h
.data
msg db 'Ingrese un Caracter:$ ' ; Mensaje que se muestra al usuario.
aux db ?,'$' ; Variable auxiliar para almacenar el car?cter ingresado.

.code
main proc
    mov ax,@data
    mov ds,ax

    lea dx, msg ; Cargar el mensaje en dx.
    mov ah, 9h
    int 21h ; Imprimir el mensaje.

    mov ah, 1h
    int 21h ; Leer un car?cter del usuario.
    
    mov bl, al ; Almacenar el car?cter ingresado en bl.

    mov ax, 0h
    mov al, bl
    mov cx, 0h
    mov cl, 4h
    shr al, cl ; Obtener los primeros cuatro bits del car?cter.
    and al, 0Fh ; Limpiar los bits restantes.
    cmp al, 0Ah
    jl hex_digit
    add al, 7h

hex_digit:
    add al, 30h ; Convertir el valor a su representaci?n ASCII.
    mov dl, al ; Cargar el valor en dl.
    mov ah, 2h
    int 21h ; Imprimir el valor hexadecimal.

    mov ax, 0h
    mov al, bl
    and al, 0Fh ; Obtener los ?ltimos cuatro bits del car?cter.
    cmp al, 0Ah
    jl hex_digit2
    add al, 7h

hex_digit2:
    add al, 30h ; Convertir el valor a su representaci?n ASCII.
    mov dl, al ; Cargar el valor en dl.
    mov ah, 2h
    int 21h ; Imprimir el valor hexadecimal.

exit:
    mov ah,4ch
    int 21h

main endp

end main







