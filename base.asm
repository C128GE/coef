#import "lib\system.asm"
#import "lib\vic2.asm"
#import "lib\mmu.asm"
#import "lib\vdc.asm"

//===============================================================================
// Memory map
// $1C01 - $3FFF = Game Code (9K, if needed)
// VIC BANK 1 ($4000 - $7FFF) - BASIC LO ROM switched out to be RAM (using MMU config 16)
//  $4000 - $43FF = Unused
//  $4400 - $47FF = Screen RAM (1K)
//  $5F20 - $6FFF = Map Data (4.2K) 
//  $7000 - $77FF = Sprite Data (2K)
//  $7800 - $7FFF = Character Data (2K) 

BasicUpstart128(gameInit)


gameInit:

    libMMUSetBankConf(16) // RAM0, no basic rom, all ram exept for IO, kernal
    libSetVICBank(1)   // VIC Bank 1 - $4000 - $7FFF
    libSetBorderColour(BLUE)
    libSetBgColour0(WHITE)
    libFillScreen(VIC_BANK1_SCREEN,'a')

    libMMUSetBankConf(15)   
    jsr $CD2E           // Switch to 80 column screen

    ldx #18         //VDC Register 18 - Update VDC address (high byte)
    lda #$20        //High byte of Address $2000 - start of character generator data
    jsr VDCWrite    //Write to the VDC register
    ldx #19         //VDC Register 19 - Update VDC address (low byte)
    lda #$00        //Low byte of address $2000 - start of character generator data
    jsr VDCWrite
    

gameLoop:
    libWaitRaster(255)
    jmp gameLoop

//Define a character pattern (e.g., a small ship)
Character_Shape:
    .byte %00111100  // ####
    .byte %01000010  // #    #
    .byte %10100101  // # #  # #
    .byte %10111101  // # #### #
    .byte %10000001  // #      #
    .byte %01000010  //  #    #
    .byte %00111100  //   ####
    .byte %00000000  // (blank row)

VDCWrite:
    stx VDC
WaitVDC:
    bit VDC     // M7 -> N
    bpl WaitVDC // branch on N = 0
    sta VDC+1
    rts
