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

	;turn on LCD, BG0, OBJ0, etc
    ld  a,%11010011
    ldh [rLCDC],a

    ld a,80
    ld [sprite_nave],a
    ld a,72
    ld [sprite_nave+1],a
    ld a,$01
    ld [sprite_nave+2],a
    ld a,$00
    ld [sprite_nave+3],a

    call DMA_COPY
    call $FF80

LOOP::
	call WAIT_VBLANK
    call READ_JOYPAD
    
    ld  a,[joypad_down]
    call JOY_LEFT
    jr  nz,CHECK_RIGHT
    ld a,[sprite_nave+1]
    dec a
    ld [sprite_nave+1],a

CHECK_RIGHT::
    ld  a,[joypad_down]
    call JOY_RIGHT
    jr  nz,CHECK_UP
    ld a,[sprite_nave+1]
    inc a
    ld [sprite_nave+1],a

CHECK_UP::
    ld  a,[joypad_down]
    call JOY_UP
    jr  nz,CHECK_DOWN
    ld a,[sprite_nave]
    dec a
    ld [sprite_nave],a

CHECK_DOWN::
    ld  a,[joypad_down]
    call JOY_DOWN
    jr  nz,CONTINUE
    ld a,[sprite_nave]
    inc a
    ld [sprite_nave],a

CONTINUE::
    call $FF80
	nop
	jp LOOP

