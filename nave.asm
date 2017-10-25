SECTION "Nave",ROM0

INICIA_NAVE::
    ld a,80
    ld [sprite1_nave],a
    ld a,24
    ld [sprite1_nave+1],a
    ld a,$00
    ld [sprite1_nave+2],a
    ld a,$00
    ld [sprite1_nave+3],a
    ld a,88
    ld [sprite2_nave],a
    ld a,24
    ld [sprite2_nave+1],a
    ld a,$01
    ld [sprite2_nave+2],a
    ld a,$00
    ld [sprite2_nave+3],a
    ret

ATUALIZA_NAVE::
    ld  a,[joypad_down]
    call JOY_A
    jp  nz,CHECK_UP
    ld a,[atirando]
    cp $01
    jp  z,CHECK_UP
    ld a,$01
    ld [atirando],a
    ld a,[sprite1_nave]
    ld [sprite_tiro],a
    ld a,[sprite1_nave+1]
    ld [sprite_tiro+1],a
    ld a,$03
    ld [sprite_tiro+2],a
    ld a,$00
    ld [sprite_tiro+3],a
    ld a,[nave_direcao]
    ld [tiro_direcao],a
    jp CHECK_UP
    ret

CHECK_UP::
    ld  a,[joypad_down]
    call JOY_UP
    jp  nz,CHECK_DOWN
    ld a,[sprite1_nave]
    dec a
    ld [sprite1_nave],a
    ld a,[sprite2_nave]
    dec a
    ld [sprite2_nave],a
    ret

CHECK_DOWN::
    ld  a,[joypad_down]
    call JOY_DOWN
    jp  nz,FIM_NAVE
    ld a,[sprite1_nave]
    inc a
    ld [sprite1_nave],a
    ld a,[sprite2_nave]
    inc a
    ld [sprite2_nave],a
    ret

FIM_NAVE::
    ret