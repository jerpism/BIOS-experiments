; Bootable FizzBuzz 
; Doesn't do anything else and is likely an unelegant solution
; but nonetheless a functioning one

; Will run off the screen so setting MAX_NUM
; to something lower like 25 might be preferable

; assemble with `nasm -f bin -o fizzbuzz.o fizzbuzz.asm`
; the number we should count up to 
%define MAX_NUM 100

; How many lines to display per page
%define MAX_LINES 25

[org 0x7c00]
    ; set up stack at just below what we load
    ; and segment registers to 0
    cli
    mov     bp, 0x7c00
    xor     ax, ax
    mov     ds, ax
    mov     es, ax
    mov     ss, ax  
    mov     sp, bp
    sti

    jmp     setmode

setmode:
    mov     ah, 0x00    ; set video mode
    mov     al, 0x02    ; 80x25 greyscale
    int     0x10

fizzbuzz:
    mov     cx, 0       ; counter initialize

    .loop:
    add     cx, 1       
    cmp     cx, MAX_NUM ; got to the end?
    jg      .end        ; yes, we're done

    call    check_page  ; see if we're good to print on this page
                        ; or if we need to move to a new one

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
    jmp kbin   ; go to reading keyboard, unnecessary for now since it falls right in


; Will block and wait for key to be read in
; Program doesn't do anything else at the moment so this is fine
;
; PGUP to go to previous page
; PGDN to go to next page
;
; Note that there's currently nothing limiting going past
; the last page if PGDN is pressed
kbin:
    mov     ah, 0x00    ; read key
    int     0x16        

    cmp     ah, 0x49    ; pgup code?
    je      .pgup       ; go handle that

    cmp     ah, 0x51    ; pgdn scan code?
    jne     kbin        ; no, skip back up
                        ; otherwise fall thru

    .pgdn:
    mov     ah, 0x0f    ; get video mode
    int     0x10

    mov     al, bh      ; get current page n to AL
    add     al, 1       ; we'll want page n+1
    mov     ah, 0x05    ; and set the current one
    int     0x10        ; to that page
    jmp kbin            ; wait for next key

    .pgup:
    mov     ah, 0x0f    ; get video mode
    int     0x10

    mov     al, bh      ; get current page n to AL
    sub     al, 1       ; we'll want page n-1
    mov     ah, 0x05    ; and set the current one
    int     0x10        ; to that page
    jmp kbin            ; wait for next key


; Checks counter to see if we're
; good to keep using the current page
; or if we should move one ahead.

; Uses value in CX to determine this
; Change macro MAX_LINES as desired
check_page:
    cmp     cx, MAX_LINES   ; if cx < MAX_LINES
    jb      .below_maxl     ; just return

    push    ax
    push    bx
    push    dx

    mov     ax, cx          ; set up division
    mov     bx, MAX_LINES

    div     bx              ; ax % MAX_LINES
    test    dx, dx          ; == 0?
    jnz     .end            ; no, just return

    mov     ah, 0x0f        ; otherwise get video mode
    int     0x10

    mov     al, bh          ; get page # to AL for our call
    add     al, 1           ; and we'll want n+1 

    mov     ah, 0x05        ; and set it as our active
    int     0x10            ; display page

    .end:
    pop     dx
    pop     bx
    pop     ax
    .below_maxl:
    ret
    

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
