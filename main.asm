INCLUDE "hardware.inc"
INCLUDE "cabecalho.asm"
INCLUDE "variaveis.asm"
INCLUDE "util.asm"
INCLUDE "tiles.asm"
INCLUDE "maps.asm"

;****************************************************************************************************************************************************
;*	Program Start
;****************************************************************************************************************************************************

SECTION "Inicio",ROM0[$0150]
START::
	di			;disable interrupts
	ld	sp,$FFFE	;set the stack to $FFFE
	call WAIT_VBLANK	;wait for v-blank

	ld	a,0		;
	ldh	[rLCDC],a	;turn off LCD 

    call CLEAR_MAP
    call CLEAR_OAM
    call CLEAR_RAM
    call LOAD_TILES
    call LOAD_MAP
	
    ld	a,%11100100	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rBGP],a	;load the palette

	ld	a,%10010001		;  =$91 
	ldh	[rLCDC],a	;turn on the LCD, BG, etc

    ld a,24
    ld [sprite_nave],a
    ld a,32
    ld [sprite_nave+1],a
    ld a,$01
    ld [sprite_nave+2],a
    ld a,$00
    ld [sprite_nave+3],a

    call DMA_COPY

Loop::
	call WAIT_VBLANK
    ld a,[sprite_nave]
    inc a
    ld [sprite_nave],a
    call $FF80
	nop
	jp Loop

