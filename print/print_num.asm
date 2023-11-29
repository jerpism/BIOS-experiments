; prints out value as decimal in ASCII
; cx contains unsigned number to print
print_num:
    push    ax          ; need ax for printing always

    test    cx, cx      ; see if we just have a 0
    jz      .print_zero ; we do, just print it out

    push    bx          ; otherwise save other 
    push    cx          ; registers as well
    push    dx

    mov     ax, cx

    ; set up counter and divisor
    mov     bx, 10      ; divisor
    mov     cl, 0       ; counter

    .div_loop:
    xor     dx, dx      ; clear dx for remainder
    div     bx          ; ax / 10
    push    dx          ; push remainder to stack
    add     cl, 1       ; increment counter
    test    ax, ax      ; all done?
    jnz     .div_loop   ; no, go again


    .print_loop:
    test    cl, cl      ; any digits left to print?
    jz      .end        ; no, all done

    pop     ax          ; pop digit off stack
    mov     ah, 0x0e    ; set print code
    sub     cl, 1       ; decrement counter accordingly

    add     al, '0'     ; convert to ASCII value
    int     0x10        ; print out
    jmp    .print_loop  ; do next one

    .print_zero:
    mov     ah, 0x0e    ; just print out a 0
    mov     al, '0'     
    int     0x10
    pop     ax          ; restore ax
    ret                 ; and return

    .end:
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
