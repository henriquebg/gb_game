SECTION "Nave",ROM0

INICIA_NAVE::
    ld a,80
    ld [sprite_nave],a
    ld a,72
    ld [sprite_nave+1],a
    ld a,$01
    ld [sprite_nave+2],a
    ld a,$00
    ld [sprite_nave+3],a
    ret

ATUALIZA_NAVE::
    ld  a,[joypad_down]
    call JOY_A
    jp  nz,CHECK_LEFT
    ld a,[atirando]
    cp $01
    jp  z,CHECK_LEFT
    ld a,$01
    ld [atirando],a
    ld a,[sprite_nave]
    ld [sprite_tiro],a
    ld a,[sprite_nave+1]
    ld [sprite_tiro+1],a
    ld a,$03
    ld [sprite_tiro+2],a
    ld a,$00
    ld [sprite_tiro+3],a
    ld a,[nave_direcao]
    ld [tiro_direcao],a
    ret

CHECK_LEFT::
    ld  a,[joypad_down]
    call JOY_LEFT
    jp  nz,CHECK_RIGHT
    ld a,[sprite_nave+1]
    dec a
    ld [sprite_nave+1],a
    ld a,$01
    ld [sprite_nave+2],a
    ld a,$20
    ld [sprite_nave+3],a
    ld a,$00
    ld [nave_direcao],a
    ret

CHECK_RIGHT::
    ld  a,[joypad_down]
    call JOY_RIGHT
    jp  nz,CHECK_UP
    ld a,[sprite_nave+1]
    inc a
    ld [sprite_nave+1],a
    ld a,$01
    ld [sprite_nave+2],a
    ld a,$00
    ld [sprite_nave+3],a
    ld a,$01
    ld [nave_direcao],a
    ret

CHECK_UP::
    ld  a,[joypad_down]
    call JOY_UP
    jp  nz,CHECK_DOWN
    ld a,[sprite_nave]
    dec a
    ld [sprite_nave],a
    ld a,$02
    ld [sprite_nave+2],a
    ld a,$00
    ld [sprite_nave+3],a
    ld a,$02
    ld [nave_direcao],a
    ret

CHECK_DOWN::
    ld  a,[joypad_down]
    call JOY_DOWN
    jp  nz,FIM_NAVE
    ld a,[sprite_nave]
    inc a
    ld [sprite_nave],a
    ld a,$02
    ld [sprite_nave+2],a
    ld a,$40
    ld [sprite_nave+3],a
    ld a,$03
    ld [nave_direcao],a

FIM_NAVE::
    ret