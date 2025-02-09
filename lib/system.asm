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

.macro libWaitTimer(time) {
    // 1.023 MHz = 1,023,000 Cycles per second
    // 1 cycle = 1/1.023 MHz = 0.977 microseconds
    // 1 NOP = 2 cycles = 1.954 microseconds
    // 1/2 NOP = 1 cycle = 0.977 microseconds
    // 1/2 NOP * 1000000 = 1 second
    // 1 NOP * 500000 = 1 second
    // 1 NOP * 500000 * time = time seconds
    // 79 x 79 x 79 = 493039 loops

.for (var i = 0; i < time; i++) {
    ldx #40 // 2 cycles
loop1: // loop 79 times
    dex // 2 cycles
    beq end // 3 cycles
    ldy #40 // 2 cycles
loop2: // loop 79 times for each loop1
    dey // 2 cycles
    beq loop1 // 3 cycles
    lda #40 // 2 cycles
loop3: // loop 79 times for each loop2
    sbc #1 // 2 cycles
    beq loop2 // 3 cycles
    jmp loop3 // 3 cycles
end:
}    
}
