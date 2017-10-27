INCLUDE "constantes.asm"
INCLUDE "variaveis.asm"
INCLUDE "cabecalho.asm"
INCLUDE "util.asm"
INCLUDE "tiles.asm"
INCLUDE "maps.asm"
INCLUDE "nave.asm"
INCLUDE "tiro.asm"
INCLUDE "inimigo.asm"

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
	
    ld	a,%00000000	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rBGP],a	;load the palette

    ld	a,%00000000	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rOBP0],a	;load the palette

	;turn on LCD, BG0, OBJ0, etc
    ld  a,%11010011
    ldh [rLCDC],a

    call INICIA_NAVE
    call INICIA_TIRO
    call INICIA_INIMIGO
    ld a,_SCROLL_DELAY
    ld [scroll_delay],a
    ld a,$04
    ld [efeito_delay],a
    ld a,$00
    ld [comecou],a
    call DMA_COPY
    ei

LOOP::
	call WAIT_VBLANK
    call READ_JOYPAD
    ld a,[comecou]
    cp $01
    jp z,COMECA_JOGO
    ld  a,[joypad_down]
    call JOY_START
    jp nz,LOOP
    call REPOSICIONA_NAVE
    call ANIMACAO_EFEITO
    ld a,$01
    ld [comecou],a
    ld c,$08
    call ESPERA1S
    nop
	jp LOOP

COMECA_JOGO::
    call ATUALIZA_NAVE
    call ATUALIZA_TIRO
    call ATUALIZA_INIMIGO
    call $FF80
    call SCROLL_BACKGROUND
    nop
    jp LOOP


