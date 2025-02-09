.const VDC            = $D600

.macro libVDCDisplayCharSet() {
    Display:
        ldx #18         //VDC Register 18 - Tell VDC to update a VDC address (high byte)
        lda #$00        //High byte of Address $0000 - start of screen RAM (80 column mode) - Position (0,0)
        jsr VDCWrite    //Write to the VDC register
        ldx #19         //VDC Register 19 - Tell VDC to update a VDC address (low byte)
        lda #$00        //Low byte of address $0000 - start of screen RAM (80 column mode) - Position (0,0)
        jsr VDCWrite    //Write to the VDC register
        ldx #31         //Data register - holds data to be stored in VDC RAM starting at $0000 (start of screen), in this case.
        lda #$00        //First character of the character set
        jsr VDCWrite    //Write to the VDC register, then point to next screen position (0,1) - done automatically by the VDC
    Fill80:
        adc #$01        //Next character in the character set
        jsr VDCWrite    //Write character to screen, and then point to next screen position (done automatically by the VDC)
        cmp #255        //Stop at 255 characters
        bne Fill80      //Loop back to Fill80    
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

.macro libVDCPositionChar(char,x,y) {
    .var screenAddr = $0000

    .eval screenAddr = screenAddr + (y * 80) + x
    ldx #18             //VDC Register 18 - Update VDC address (high byte)
    lda #>screenAddr    //High byte of screen address
    jsr VDCWrite        //Write to the VDC register
    ldx #19             //VDC Register 19 - Update VDC address (low byte)
    lda #<screenAddr    //Low byte of screen address
    jsr VDCWrite        //Write to the VDC register
    ldx #31             //Data register - holds data to be stored in VDC RAM set by registers 18 and 19.
    lda #char           //Character to be displayed
    jsr VDCWrite
}

.macro libVDCClearPos(x,y) {
    .var screenAddr = $0000

    .eval screenAddr = screenAddr + (y * 80) + x
    ldx #18             //VDC Register 18 - Update VDC address (high byte)
    lda #>screenAddr    //High byte of screen address
    jsr VDCWrite        //Write to the VDC register
    ldx #19             //VDC Register 19 - Update VDC address (low byte)
    lda #<screenAddr    //Low byte of screen address
    jsr VDCWrite        //Write to the VDC register
    ldx #31             //Data register - holds data to be stored in VDC RAM set by registers 18 and 19.
    lda #32             //The space character
    jsr VDCWrite
    
}

.macro libVDCCharMoveRel(char,x,y,xoff,yoff) { 

    libVDCClearPos(x,y)
    libVDCPositionChar(char,x+xoff,y+yoff)
      
}



VDCWrite:
    stx VDC
WaitVDC:
    bit VDC     // M7 -> N
    bpl WaitVDC // branch on N = 0
    sta VDC+1
    rts

#import "sprites80.asm"
