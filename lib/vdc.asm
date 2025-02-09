.const VDC            = $D600

.macro libVDCDisplayCharSet() {
    Display:
        ldx #18
        lda #$00
        jsr VDCWrite
        ldx #19
        lda #$00
        jsr VDCWrite
        ldx #31
        lda #$00
        jsr VDCWrite
    Fill80:
        adc #$01   
        jsr VDCWrite
        cmp #255
        bne Fill80    
}

.macro libVDCChangeCharSet() {
    ldx #18         //VDC Register 18 - Update VDC address (high byte)
    lda #$20        //High byte of Address $2000 - start of character generator data
    jsr VDCWrite    //Write to the VDC register
    inx             //VDC Register 19 - Update VDC address (low byte)
    lda #$00        //Low byte of address $2000 - start of character generator data
    jsr VDCWrite
    ldx #31         //Data register - holds data to be stored in RAM starting at $2000, in this case.
    ldy #0          //Index into our new character shape

Char_Loop:
    lda Sprite_Ship,y
    jsr VDCWrite

//    jsr VDCWrite    //A second write will advance the RAM address by 1 automatically by the VDC, thus making the char 2x the size
    iny             //Next byte; ie next row of character
    cpy #8          //Stop at 8 bytes
    bcc Char_Loop
}

VDCWrite:
    stx VDC
WaitVDC:
    bit VDC     // M7 -> N
    bpl WaitVDC // branch on N = 0
    sta VDC+1
    rts

#import "sprites80.asm"
