SECTION "RAM Vars",WRAM0[$C000]

;vblank stuffs
vblank_flag:    DB
vblank_count:   DB

joypad_down:    DB
joypad_pressed: DB

SECTION "OAM Vars",WRAM0[$C100]

sprite_nave: DS 4