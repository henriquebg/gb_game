SECTION "Nave",ROM0

INICIA_NAVE::
    ld a,$F0
    ld [sprite1_nave],a
    ld a,$0F
    ld [sprite1_nave+1],a
    ld a,$00
    ld [sprite1_nave+2],a
    ld a,$00
    ld [sprite1_nave+3],a
    ld a,$F0
    ld [sprite2_nave],a
    ld a,$0F
    ld [sprite2_nave+1],a
    ld a,$01
    ld [sprite2_nave+2],a
    ld a,$00
    ld [sprite2_nave+3],a
    ret

REPOSICIONA_NAVE::
    ld a,$50
    ld [sprite1_nave],a
    ld a,$58
    ld [sprite2_nave],a
    call $FF80
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
    inc a
    ld [sprite_tiro],a
    ld a,[sprite1_nave+1]
    ld [sprite_tiro+1],a
    jp CHECK_UP
    ret

CHECK_UP::
    ld  a,[joypad_down]
    call JOY_UP
    jp  nz,CHECK_DOWN
    ld a,[sprite1_nave]
    dec a
    cp _BORDA_SUPERIOR
    jp c,CHECK_DOWN
    ld [sprite1_nave],a
    ld a,[sprite2_nave]
    dec a
    ld [sprite2_nave],a
    jp CHECK_RIGHT
    ret

CHECK_DOWN::
    ld  a,[joypad_down]
    call JOY_DOWN
    jp  nz,CHECK_RIGHT
    ld a,[sprite1_nave]
    inc a
    cp _BORDA_INFERIOR
    jp nc,CHECK_RIGHT
    ld [sprite1_nave],a
    ld a,[sprite2_nave]
    inc a
    ld [sprite2_nave],a
    jp CHECK_RIGHT
    ret

CHECK_RIGHT::
    ld  a,[joypad_down]
    call JOY_RIGHT
    jp  nz,CHECK_LEFT
    ld a,[sprite1_nave+1]
    inc a
    cp _BORDA_DIREITA
    jp nc,CHECK_LEFT
    ld [sprite1_nave+1],a
    ld a,[sprite2_nave+1]
    inc a
    ld [sprite2_nave+1],a
    ret

CHECK_LEFT::
    ld  a,[joypad_down]
    call JOY_LEFT
    jp  nz,FIM_NAVE
    ld a,[sprite1_nave+1]
    dec a
    cp _BORDA_ESQUERDA
    jp c,FIM_NAVE
    ld [sprite1_nave+1],a
    ld a,[sprite2_nave+1]
    dec a
    ld [sprite2_nave+1],a
    ret

FIM_NAVE::
    ret