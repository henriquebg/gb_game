SECTION "Utilitarios",ROM0
WAIT_VBLANK::
	ldh	a,[rLY]		;get current scanline
	cp	$91			;Are we in v-blank yet?
	jr	nz,WAIT_VBLANK	;if A-91 != 0 then loop
	ret				;done

;DMA_COPY::
;  ld a,$C1   ;3 bytes, 16 cycles
;  ldh [rDMA],a               ;2 bytes, 12 cycles - note the "LDH", not LD
;  ld a,40                    ;2 bytes, 8 cycles
;DMA_COPY_LOOP::
;  dec a                      ;1 byte, 4 cycles
;  jr nz,DMA_COPY_LOOP                ;2 bytes, 12 cycles if it jumps, 8 if it doesn't
;  ret                        ;1 byte, 16 cycles.

DMA_COPY:
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
  ld  bc,$A0
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
	ld	bc,3*16	;we have 9 tiles and each tile takes 16 bytes
LOAD_TILES_LOOP::
	ld	a,[hl+]	;get a byte from our tiles, and increment.
	ld	[de],a	;put that byte in VRAM and
	inc	de		;increment.
	dec	bc		;bc=bc-1.
	ld	a,b		;if b or c != 0,
	or	c		;
	jr	nz,LOAD_TILES_LOOP	;then loop.
	ret			;done

LOAD_MAP::
	ld	hl,MAP0	;our little map
	ld	de,_SCRN0	;where our map goes
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