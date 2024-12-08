//===============================================================================
// $D000-$DFFF - VIC-II Registers (1K)

.const SP0X            = $D000
.const SP0Y            = $D001
.const MSIGX           = $D010
.const RASTER          = $D012
.const SPENA           = $D015
.const SCROLX          = $D016
.const VMCSB           = $0A2C //$D018 on C64
.const SPBGPR          = $D01B
.const SPMC            = $D01C
.const SPSPCL          = $D01E
.const EXTCOL          = $D020 //Border colour
.const BGCOL0          = $D021
.const BGCOL1          = $D022
.const BGCOL2          = $D023
.const BGCOL3          = $D024
.const SPMC0           = $D025
.const SPMC1           = $D026
.const SP0COL          = $D027
.const FRELO1          = $D400 
.const FREHI1          = $D401 
.const PWLO1           = $D402 
.const PWHI1           = $D403 
.const VCREG1          = $D404 
.const ATDCY1          = $D405 
.const SUREL1          = $D406 
.const FRELO2          = $D407 
.const FREHI2          = $D408 
.const PWLO2           = $D409 
.const PWHI2           = $D40A 
.const VCREG2          = $D40B 
.const ATDCY2          = $D40C 
.const SUREL2          = $D40D 
.const FRELO3          = $D40E 
.const FREHI3          = $D40F 
.const PWLO3           = $D410 
.const PWHI3           = $D411 
.const VCREG3          = $D412 
.const ATDCY3          = $D413 
.const SUREL3          = $D414 
.const SIGVOL          = $D418      
.const COLORRAM        = $D800
.const CIAPRA          = $DC00
.const CIAPRB          = $DC01
.const CI2PRA          = $DD00 // VIC Bank Register


//===============================================================================
// $0400-$07FF - Default location of screen ram (1K)
.const DEFAULT_SCREEN = $0400
.const VIC_BANK1_SCREEN = $4400

.macro libSetBorderColour(border) {
    lda #border
    sta EXTCOL
}

.macro libSetBgColour0(bgColour0) {
    lda #bgColour0
    sta BGCOL0    
}

.macro libFillScreen (screen_location, value) {
        lda #value
        ldx #250
loop:   dex
        sta screen_location,x
        sta screen_location+250,x 
        sta screen_location+500,x
        sta screen_location+750,x 
        bne loop
}

.macro libWaitRaster(line) {
loop:   lda #line
        cmp RASTER
        bne loop
}

.macro libSetVICBank(bank) {
    .var bank_code=%11

    .if(bank==0) {
        .eval bank_code=%11 
    }
    .if(bank==1) {
        .eval bank_code=%10
    }
    .if(bank==2) {
        .eval bank_code=%01
    }
    .if(bank==3) {
        .eval bank_code=%00
    }

    lda CI2PRA  // VIC Bank Register
    and #$FC // clear bits 0 and 1
    ora #bank_code // last 2 bits set bank number - 11,10,01,00 respectively
    sta CI2PRA
}

