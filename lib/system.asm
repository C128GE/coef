.macro BasicUpstart128(address) {
    .pc = $1c01 "C128 Basic"
    .word upstartEnd
    .word 10 // line num
    .byte $9e // sys
    .text toIntString(address)
    .byte 0
upstartEnd:
    .word 0 // 2 zeros signals the end of the program
    .pc = $1c0e "End of BASIC program"
}    