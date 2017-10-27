SECTION "RAM Vars",WRAM0[$C000]

;vblank stuffs
vblank_flag:           DB
vblank_count:          DB

joypad_down:           DB
joypad_pressed:        DB

tiro_direcao:          DB
atirando:              DB

nave_direcao:          DB

scroll_delay           DB
comecou                DB
efeito_delay           DB

inimigo_direcao        DB
inimigo_delay          DB
sprite_inimigo_fim_x   DB
sprite_inimigo_fim_y   DB

SECTION "OAM Vars",WRAM0[$C100]

sprite1_nave: DS 4
sprite2_nave: DS 4
sprite_tiro: DS 4
sprite_inimigo DS 4