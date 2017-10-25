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

; MOVE_ESQUERDA::
;     ld a,[sprite_tiro+1]
;     cp $00
;     jp z,RESETA_TIRO
;     ld a,[sprite_tiro+1]
;     dec a
;     ld [sprite_tiro+1],a
;     ret

MOVE_DIREITA::
    ld a,[sprite_tiro+1]
    cp $A8
    jp z,RESETA_TIRO
    ld a,[sprite_tiro+1]
    inc a
    ld [sprite_tiro+1],a
    ret

; MOVE_CIMA::
;     ld a,[sprite_tiro]
;     cp $00
;     jp z,RESETA_TIRO
;     ld a,[sprite_tiro]
;     dec a
;     ld [sprite_tiro],a
;     ret

; MOVE_BAIXO::
;     ld a,[sprite_tiro]
;     cp $A0
;     jp z,RESETA_TIRO
;     ld a,[sprite_tiro]
;     inc a
;     ld [sprite_tiro],a
;     ret

RESETA_TIRO::
    ld a,$00
    ld [atirando],a
    ret

FIM_TIRO::
    ret