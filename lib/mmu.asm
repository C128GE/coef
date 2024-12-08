.const MMUCR		= $ff00 	// MMU bank configuration register

/*----------------------------------------------------------
 Banking, RAM configurations

 bits:
 0:   $d000-$dfff (i/o block, ram or rom)
 1:   $4000-$7fff (lower basic rom)
 2-3: $8000-$bfff (upper basic rom, monitor, internal/external ROM)
 4-5: $c000-$ffff (char ROM, kernal, internal/external ROM, RAM)
 6:   select RAM block

 Setting a bit means RAM, clearing means ROM.
 Use the BASIC Bank configuration numbers.

 Syntax:		:SetBankConfiguration(number)
----------------------------------------------------------*/
.macro libMMUSetBankConf(id) {
	.if(id==0) {
		lda #%00111111 	// no roms, RAM 0
	}
	.if(id==1) {
		lda #%01111111 	// no roms, RAM 1
	}
	.if(id==12) {
		lda #%00000110 	// internal function ROM, Kernal and IO, RAM 0
	}
	.if(id==14) {
		lda #%00000001 	// all roms, char ROM, RAM 0
	}
	.if(id==15) {
		lda #%00000000  // all roms, RAM 0. default setting.
	}
	.if(id==16) { //Custom RAM bank config (not defined in books)
		lda #%00001110  // IO, kernal, RAM0. No basic,48K RAM.
	}
	sta MMUCR
}
