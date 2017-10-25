INCLUDE "constantes.asm"
INCLUDE "variaveis.asm"
INCLUDE "cabecalho.asm"
INCLUDE "util.asm"
INCLUDE "tiles.asm"
INCLUDE "maps.asm"
INCLUDE "nave.asm"
INCLUDE "tiro.asm"

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

    ld	a,%11100100	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rOBP0],a	;load the palette

	;turn on LCD, BG0, OBJ0, etc
    ld  a,%11010011
    ldh [rLCDC],a

    call INICIA_NAVE
    ;call INICIA_TIRO
    call DMA_COPY
    call $FF80

LOOP::
	call WAIT_VBLANK
    call READ_JOYPAD
    call ATUALIZA_NAVE
    ;call ATUALIZA_TIRO
    call $FF80
    nop
	jp LOOP

