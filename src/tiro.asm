SECTION "Tiro",ROM0

INICIA_TIRO::
    ld a,$00
    ld [atirando],a
    ld a,$01
    ld [tiro_direcao],a
    ld a,$F0
    ld [sprite_tiro],a
    ld a,$0F
    ld [sprite_tiro+1],a
    ld a,$19
    ld [sprite_tiro+2],a
    ld a,$00
    ld [sprite_tiro+3],a
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
    cp _BORDA_DIREITA_OFFSET
    jp nc,RESETA_TIRO
    ld a,[sprite_tiro+1]
    add a,$04
    ld [sprite_tiro+1],a
    ld b,a
    ld a,[sprite_inimigo_fim_x]
    cp b
    jp nc,FIM_TIRO
    ld a,[sprite_inimigo+1]
    cp b
    jp c,FIM_TIRO
    ld a,[sprite_tiro]
    ld b,a
    ld a,[sprite_inimigo_fim_y]
    cp b
    jp nc,FIM_TIRO
    ld a,[sprite_inimigo]
    cp b
    jp c,FIM_TIRO
    call INICIA_TIRO
    call INICIA_INIMIGO
    ret

RESETA_TIRO::
    ld a,$00
    ld [atirando],a
    ret

FIM_TIRO::
    ret