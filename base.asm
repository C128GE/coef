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
    libSetBorderColour(BLACK)
    libSetBgColour0(BLACK)
    libFillScreen(VIC_BANK1_SCREEN,'a')

    libVDCChangeCharSet()
    libVDCDisplayCharSet()

    lda #$00 // @ character
    sta VIC_BANK1_SCREEN


gameLoop:
    libWaitRaster(255)
    jmp gameLoop





