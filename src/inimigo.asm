SECTION "Inimigo",ROM0

INICIA_INIMIGO::
    ld b,%01111100
    call NUMERO_RANDOMICO
    ld [sprite_inimigo],a
    sub $08
    ld [sprite_inimigo_fim_y],a
    ld a,$B0
    ld [sprite_inimigo+1],a
    sub $08
    ld [sprite_inimigo_fim_x],a
    ld a,$1A
    ld [sprite_inimigo+2],a
    ld a,$00
    ld [sprite_inimigo+3],a
    ld b,%00000001
    call NUMERO_RANDOMICO
    ld [inimigo_direcao],a
    ld a,$02
    ld [inimigo_delay],a
    ret

ATUALIZA_INIMIGO::   
    ld a,[sprite_inimigo]
    cp _BORDA_INFERIOR_OFFSET
    jp z,MUDA_DIRECAO_CIMA
    cp _BORDA_SUPERIOR
    jp z,MUDA_DIRECAO_BAIXO
    jp MOVE_INIMIGO
    ret

MUDA_DIRECAO_CIMA::
    ld a,$01
    ld [inimigo_direcao],a
    jp MOVE_INIMIGO
    ret

MUDA_DIRECAO_BAIXO::
    ld a,$00
    ld [inimigo_direcao],a
    jp MOVE_INIMIGO
    ret

MOVE_INIMIGO::
    ld a,[inimigo_direcao]
    cp $00
    jp z,MOVE_BAIXO
    cp $01
    jp z,MOVE_CIMA
    ret

MOVE_BAIXO::
    ld a,[sprite_inimigo]
    add a,$01
    ld [sprite_inimigo],a
    sub $08
    ld [sprite_inimigo_fim_y],a
    ld a,[inimigo_delay]
    cp $00
    jp nz,FIM_INIMIGO
    ld a,$04
    ld [inimigo_delay],a
    ld a,[sprite_inimigo+1]
    sub a,$01
    ld [sprite_inimigo+1],a
    sub $08
    ld [sprite_inimigo_fim_x],a
    ret

MOVE_CIMA::
    ld a,[sprite_inimigo]
    sub a,$01
    ld [sprite_inimigo],a
    sub $08
    ld [sprite_inimigo_fim_y],a
    ld a,[inimigo_delay]
    cp $00
    jp nz,FIM_INIMIGO
    ld a,$04
    ld [inimigo_delay],a
    ld a,[sprite_inimigo+1]
    sub a,$01
    ld [sprite_inimigo+1],a
    sub $08
    ld [sprite_inimigo_fim_x],a
    ret

FIM_INIMIGO::
    ld a,[inimigo_delay]
    dec a
    ld [inimigo_delay],a
    ret


