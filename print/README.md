# This directory contains things that print things.

Please do note that the code here is unlikely to be optimal or even ``good'' but it works for my personal needs for now. 

`print_str.asm` contains a subroutine for printing out a NUL-terminated string pointed to by `BX`.

`print_hex.asm` contains a subroutine for printing out a hexadecimal value stored in `DX`, only works for 16 bit values.

`print_num.asm` contains a subroutine for printing out the value stored in `CX` as an unsigned integer.
