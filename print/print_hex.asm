; dx contains raw hex value to be converted to ASCII
print_char:
    mov ah, 0x0e
    int 0x10
    ret

print_hex:
    push bx
    push cx

    ; Print out "0x" prefix
    mov al, '0'
    call print_char
    mov al, 'x'
    call print_char

    mov cl, 16      ; only deals with 16 bit values

    .convloop:
    mov bx, 0xF000  ; Make a mask of 4 most significant bits
    rol bx, cl      ; and roll it to where we want it.
    sub cl, 4       ; Only needs to be rolled all the way around once.
    and bx, dx      ; Mask out our 4 bits and shift them to 
    shr bx, cl      ; 4 least significant bits in bx.

    cmp bx, 9       ; See if our value is <= 9 and if so 
    jle .add_digit  ; just add 0x30 to convert it to an ASCII number.
    add bl, 0x7     ; Otherwise first add 0x7 and then 0x30 to get the correct letter.

    .add_digit:
    add bl, 0x30    ; convert decimal value to ascii

    mov al, bl
    call print_char

    test cl, cl     ; cl > 0?
    jnz .convloop   ; do next 4 bits

    pop cx
    pop bx

    ret
