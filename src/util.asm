SECTION "Utilitarios",ROM0
WAIT_VBLANK::
	ldh	a,[rLY]		;get current scanline
	cp	$91			;Are we in v-blank yet?
	jr	nz,WAIT_VBLANK	;if A-91 != 0 then loop
	ret				;done

DMA_COPY::
  ; load de with the HRAM destination address
  ld  de,$FF80

  ; whats this? read on..
  call COPY_DATA

  ; the amount of data we want to copy into HRAM, $000D which is 13 bytes
  DB  $00,$0D

  ; this is the above DMA subroutine hand assembled, which is 13 bytes long
  DB  $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
  ret

CLEAR_MAP::
	ld	hl,_SCRN0		;loads the address of the bg map ($9800) into HL
	ld	bc,1024		;since we have 32x32 tiles, we'll need a counter so we can clear all of them
	ld	a,0			;load 0 into A (since our tile 0 is blank)
CLEAR_MAP_LOOP::
	ld	[hl+],a		;load A into HL, then increment HL (the HL+)
	dec	bc			;decrement our counter
	ld	a,b			;load B into A
	or	c			;if B or C != 0
	jr	nz,CLEAR_MAP_LOOP	;then loop
	ret			

CLEAR_OAM::
  ld  hl,_OAMRAM
  ld  bc,$A0
CLEAR_OAM_LOOP::
  ld  a,$0
  ld  [hli],a
  dec bc
  ld  a,b
  or  c
  jr  nz,CLEAR_OAM_LOOP
  ret

CLEAR_RAM::
  ld  hl,$C100
  ld  bc,$0FFF
CLEAR_RAM_LOOP::
  ld  a,$0
  ld  [hli],a
  dec bc
  ld  a,b
  or  c
  jr  nz,CLEAR_RAM_LOOP
  ret

COPY_DATA::
  ; pop return address off stack into hl
  pop hl
  push bc

  ; here we get the number of bytes to copy
  ; hl contains the address of the bytes following the "rst $28" call

  ; put first byte into b ($00 in this context)
  ld  a,[hli]
  ld  b,a

  ; put second byte into c ($0D in this context)
  ld  a,[hli]
  ld  c,a

  ; bc now contains $000D
  ; hl now points to the first byte of our assembled subroutine (which is $F5)
  ; begin copying data
COPY_DATA_LOOP::
  
  ; load a byte of data into a
  ld  a,[hli]

  ; store the byte in de, our destination ($FF80 in this context)
  ld  [de],a
  
  ; go to the next destination byte, decrease counter
  inc de
  dec bc

  ; check if counter is zero, if not repeat loop
  ld  a,b
  or  c
  jr  nz,COPY_DATA_LOOP
  
  ; all done, return home
  pop bc
  jp  hl
  reti

LOAD_TILES::
	ld	hl,TILES
	ld	de,_VRAM
	ld	bc,_NUM_TILES*16	;we have 9 tiles and each tile takes 16 bytes
LOAD_TILES_LOOP::
	ld	a,[hl+]	;get a byte from our tiles, and increment.
	ld	[de],a	;put that byte in VRAM and
	inc	de		;increment.
	dec	bc		;bc=bc-1.
	ld	a,b		;if b or c != 0,
	or	c		;
	jr	nz,LOAD_TILES_LOOP	;then loop.
	ret			;done

;Map adress should be loaded previously into hl -> ld hl,MAP
;Background number should be loaded into de -> ld	de,_SCRN0 or ld	de,_SCRN1
LOAD_MAP::
  ld bc,1024		;since we are only loading 1024 tiles
LOAD_MAP_LOOP::
	ld	a,[hl+]	;get a byte of the map and inc hl
	ld	[de],a	;put the byte at de
	inc	de		;duh...
	dec	bc		;bc=bc-1.
	ld	a,b		;if b or c != 0,
	or	c		
	jr	nz,LOAD_MAP_LOOP	;and of the counter != 0 then loop
	ret		;done

READ_JOYPAD::
  ;select dpad
  ld  a,%00100000

  ;takes a few cycles to get accurate reading
  ld  [rP1],a
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  
  ;complement a
  cpl

  ;select dpad buttons
  and %00001111
  swap a
  ld  b,a

  ;select other buttons
  ld  a,%00010000

  ;a few cycles later..
  ld  [rP1],a  
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  cpl
  and %00001111
  or  b
  
  ;you get the idea
  ld  b,a
  ld  a,[joypad_down]
  cpl
  and b
  ld  [joypad_pressed],a
  ld  a,b
  ld  [joypad_down],a
  ret

JOY_RIGHT::
  and %00010000
  cp  %00010000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret

JOY_LEFT::
  and %00100000
  cp  %00100000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_UP::
  and %01000000
  cp  %01000000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_DOWN::
  and %10000000
  cp  %10000000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_A::
  and %00000001
  cp  %00000001
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_B::
  and %00000010
  cp  %00000010
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_SELECT::
  and %00000100
  cp  %00000100
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_START::
  and %00001000
  cp  %00001000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_FALSE::
  ld  a,$0
  ret

SCROLL_BACKGROUND::
  ld a,[scroll_delay]
  dec a
  cp $00
  jp nz,PULA_SCROLL
  ld a,_SCROLL_DELAY
  ld [scroll_delay],a
  ld a,[rSCX]
  inc a
  ld [rSCX], a
  ret

PULA_SCROLL::
  ld [scroll_delay],a
  ret

;O registro c precisa ser carregado previamente $08 ~ 1s, $04 ~ 0.5s $0F ~ 2s... 
ESPERA1S::
ESPERA_LOOP_EXT2::
    ld b,$64
ESPERA_LOOP_EXT1::
    ld a,$FA
ESPERA_LOOP_INT::
    dec a
    jp nz,ESPERA_LOOP_INT
    dec b
    ld a,b
    jp nz,ESPERA_LOOP_EXT1
    dec c
    ld a,c
    jp nz,ESPERA_LOOP_EXT2
    ret
  
FADE_IN::
  ld	a,%01000000
	ldh	[rBGP],a
  ld	a,%00010000
	ldh	[rOBP0],a
  ld c,$04
  call ESPERA1S
  ld	a,%10010000
	ldh	[rBGP],a
  ld	a,%00010000
	ldh	[rOBP0],a
  ld c,$04
  call ESPERA1S
  ld	a,%11100100
	ldh	[rBGP],a
  ld	a,%00100111
	ldh	[rOBP0],a
  ld c,$04
  call ESPERA1S
  ret

;Gera um número randômico a partir do scroll_x. O registro b precisa ser
;previamente carregado com uma máscara.
;Ex:
;ld b,%00011111 resultará em um número entre 0 e 32
;ld b,%01111110 resultará em um número entre 2 e 128
;ld b,%11111100 resultará em um número entre 4 e 255
NUMERO_RANDOMICO::
  ld a,[rSCX]
  and b
  ret