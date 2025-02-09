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

    // 40 column display
    libSetVICBank(1)   // VIC Bank 1 - $4000 - $7FFF
    libSetBorderColour(BLACK)
    libSetBgColour0(BLACK)
    libFillScreen(VIC_BANK1_SCREEN,'a')

    // 80 column display
    libVDCChangeCharSet()
    libVDCDisplayCharSet()

    // 40 column display - test
    lda #$00 // @ character
    sta VIC_BANK1_SCREEN

    // 80 column display - test
    libVDCPositionChar(0,0,15) // Display @ character at position 0,15
//    libVDCClearPos(15,15)       // Clear @ character at position 15,15
    
    libWaitTimer(1)   
    libVDCCharMoveRel(0,0,15,1,1) // Move @ character from 0,15 to 1,16
    libWaitTimer(1)   
    libVDCCharMoveRel(0,1,16,1,1) // Move @ character from 1,16 to 2,17    
    libWaitTimer(1)   
    libVDCCharMoveRel(0,2,17,1,1) // Move @ character from 2,17 to 3,18    
    libWaitTimer(1)   
    libVDCCharMoveRel(0,3,18,1,1) // Move @ character from 3,18 to 4,19
    libWaitTimer(1)   
    libVDCCharMoveRel(0,4,19,1,1) // Move @ character from 4,19 to 5,20  

gameLoop:
    libWaitRaster(255)
    jmp gameLoop





