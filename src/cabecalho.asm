;-------------
;	Cabeçalho
;-------------

SECTION	"Org $00",ROM0[$00]
RST_00::
	jp	$100

SECTION	"Org $08",ROM0[$08]
RST_08::
	jp	$100

SECTION	"Org $10",ROM0[$10]
RST_10::
	jp	$100

SECTION	"Org $18",ROM0[$18]
RST_18::
	jp	$100

SECTION	"Org $20",ROM0[$20]
RST_20::
	jp	$100

SECTION "Copy Data",ROM0[$28]
RST_28::
    jp	$100

SECTION	"Org $30",ROM0[$30]
RST_30::
	jp	$100

SECTION	"Org $38",ROM0[$38]
RST_38::
	jp	$100

SECTION	"V-Blank IRQ Vector",ROM0[$40]
VBL_VECT::
	reti
	
SECTION	"LCD IRQ Vector",ROM0[$48]
LCD_VECT::
	reti

SECTION	"Timer IRQ Vector",ROM0[$50]
TIMER_VECT::
	reti

SECTION	"Serial IRQ Vector",ROM0[$58]
SERIAL_VECT::
	reti

SECTION	"Joypad IRQ Vector",ROM0[$60]
JOYPAD_VECT::
	reti

; $0068 - $00FF: Free space.
DS $98
	
SECTION	"Start",ROM0[$100]
	nop
	jp	START

	; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
	DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	DB	"NAVINHA"
		;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
	DB	"    "
		;0123

	; $0143: Gameboy Color compatibility flag.    
	DB GBC_UNSUPPORTED

	; $0144 - $0145: "New" Licensee Code, a two character name.
	DB "OK"

	; $0146: Super Gameboy compatibility flag.
	DB SGB_UNSUPPORTED

	; $0147: Cartridge type. Either no ROM or MBC5 is recommended.
	DB CART_ROM_ONLY

	; $0148: Rom size.
	DB ROM_32K

	; $0149: Ram size.
	DB RAM_NONE

	; $014A: Destination code.
	DB DEST_INTERNATIONAL
	; $014B: Old licensee code.
	; $33 indicates new license code will be used.
	; $33 must be used for SGB games.
	DB $33
	; $014C: ROM version number
	DB $00
	; $014D: Header checksum.
	; Assembler needs to patch this.
	DB $00
	; $014E- $014F: Global checksum.
	; Assembler needs to patch this.
	DW 2