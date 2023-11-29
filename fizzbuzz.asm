; Bootable FizzBuzz 
; Doesn't do anything else and is likely an unelegant solution
; but nonetheless a functioning one

; Will run off the screen so setting MAX_NUM
; to something lower like 25 might be preferable

; assemble with `nasm -f bin -o fizzbuzz.o fizzbuzz.asm`
%define MAX_NUM 100

[org 0x7c00]
    ; set up stack at just below what we load
    ; and all segment registers to 0
    mov     bp, 0x7c00
    xor     ax, ax
    mov     ds, ax
    mov     es, ax
    mov     ss, ax  
    mov     sp, bp

    jmp     fizzbuzz

fizzbuzz:
    mov     cx, 0       ; counter initialize

    .loop:
    add     cx, 1       
    cmp     cx, MAX_NUM ; print out to this number
    jg      .end        ; done


    mov     ax, cx      ; counter value to ax for div
    xor     dx, dx      ; clear dx
    mov     bx, 15      ; set divisor

    div     bx          ; cx % 15 
    test    dx, dx      ; == 0?
    jz      .fizzbuzz   

    mov     ax, cx      ; counter value to ax for div
    xor     dx, dx      ; clear dx
    mov     bx, 3       ; set divisor

    div     bx          ; cx % 3
    test    dx, dx      ; == 0?
    jz     .fizz   

    mov     ax, cx      ; set up div
    xor     dx, dx      ; clear dx
    mov     bx, 5       ; set divisor

    div     bx          ; cx % 5
    test    dx, dx      ; == 0?
    jz     .buzz

    call    print_num   ; neither, print out number
    jmp     .crlf       ; and put newline after


    .buzz:
    mov     bx, BUZZ_MSG
    call    print_str
    jmp     .crlf

    .fizzbuzz:
    mov     bx, FIZZBUZZ_MSG
    call    print_str
    jmp     .crlf

    .fizz:
    mov     bx, FIZZ_MSG
    call    print_str
    ; fall thru since most common
    ; saves a few jumps

    .crlf:
    mov     bx, CR_LF
    call    print_str

    jmp     .loop


    .end:

    jmp $   ; just sit here forever


; use NUL terminated strings
FIZZ_MSG:       db "Fizz", 0
BUZZ_MSG:       db "Buzz", 0
FIZZBUZZ_MSG:   db "FizzBuzz", 0
CR_LF:          db 0x0d, 0x0a, 0


; Needs these for printing out anything
%include "./print/print_str.asm"
%include "./print/print_num.asm"

times 510-($-$$) db 0   ; pad out to 510B 
dw 0xaa55               ; BIOS magic
