; Prints out a NUL-terminated string
; pointed to by bx
print_str:
    push ax

    mov ah, 0x0e     ; bios print

    .print_loop:
    mov al, [bx]
    test al, al      ; hit a NUL?
    jz .end_print    ; we did, end print

    int 0x10         ; print out character
    add bx, 1        ; point to next one
    jmp .print_loop   
    
    .end_print:
    pop ax ; restore ax after call

    ret
