SECTION "Tiro",ROM0

INICIA_TIRO::
    ld a,$00
    ld [atirando],a
    ld a,$01
    ld [tiro_direcao],a
    ret

ATUALIZA_TIRO::
    ld a,[atirando]
    cp $01
    jp nz,FIM_TIRO
    ld a,[tiro_direcao]
    cp $01
    jp z,MOVE_DIREITA
    ret

MOVE_DIREITA::
    ld a,[sprite_tiro+1]
    cp $A8
    jp nc,RESETA_TIRO
    ld a,[sprite_tiro+1]
    add a,$02
    ld [sprite_tiro+1],a
    ret

RESETA_TIRO::
    ld a,$00
    ld [atirando],a
    ret

FIM_TIRO::
    ret