; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL

    org $2000                                  ; origin line, tells the assembler where our program will live in memory

screen  = $4000 ; screen buffer
charset = $5000 ; allocate space for character set, there are 4 pages and each is 256 bytes in size, 
pmg     = $6000 ; Player Missile Data

    setup_screen()
    setup_colors()
    mva #>charset CHBAS 
    clear_pgm()
    load_pmg()
    setup_pmg_system()
    display_map()

    jmp *
    
    icl 'hardware.asm'
    icl 'dlist.asm'
    icl 'gfx.asm'
    icl 'pmgdata.asm'

* ----------------------------------------- *
* Proc setup colors                         *
* Sets up colors                            *
* ----------------------------------------- *
.proc setup_colors
med_gray = $06
lt_gray  = $0a
green    = $c2
brown    = $22
black    = $00
peach    = $2c
blue     = $80

   ; Character set colors
    mva #med_gray COLOR0    ; %01
    mva #lt_gray COLOR1     ; %10
    mva #green COLOR2       ; %11
    mva #brown COLOR3       ; %11 (inverse)
    mva #black COLOR4       ; %00
    
    ; Player Misile Colors
    mva #brown PCOLR0
    mva #peach PCOLR1
    mva #blue PCOLR2
    mva #black PCOLR3
    rts
    .endp


* ----------------------------------------- *
* Proc: clear_pmg                           *
* Clears memory for player missile gfx      *
* ----------------------------------------- *
.proc clear_pgm
pmg_p0 = pmg + $200
pmg_p1 = pmg + $280
pmg_p2 = pmg + $300
pmg_p3 = pmg + $380

    ldx #$80
    lda #0
loop
    dex
    sta pmg_p0,x    
    sta pmg_p1,x
    sta pmg_p2,x
    sta pmg_p3,x
    bne loop        ; in this case bne would be true if x == 0
    rts
    .endp

* ----------------------------------------- *
* Proc: load_pmg                            *
* load player missile gfx                   *
* ----------------------------------------- *
.proc load_pmg
pmg_p0 = pmg + $200
pmg_p1 = pmg + $280
pmg_p2 = pmg + $300
pmg_p3 = pmg + $380

    ldx #0
loop
    ; +8=second color byte, +16=third color byte etc
    mva pmgdata+0,x  pmg_p0+64,x    
    mva pmgdata+8,x  pmg_p1+64,x
    mva pmgdata+16,x pmg_p2+64,x
    mva pmgdata+24,x pmg_p3+64,x
    inx
    cpx #8
    bne loop
    rts
    .endp

* ----------------------------------------- *
* Proc: setup_pmg_system                    *
* Sets up the player misile graphics system *
* ----------------------------------------- *
.proc setup_pmg_system
    mva #>pmg PMBASE
    mva #46 SDMCTL  ; Single line resolution
    mva #3 GRACTL   ; Enable PMG
    mva #1 GRPRIOR  ; Give players priority
    lda #120        ; the screen position of player 
    sta HPOSP0    
    sta HPOSP1
    sta HPOSP2
    sta HPOSP3
    rts
    .endp

* ----------------------------------------- *
* Macro: blit_row                           *
* Copies one line of map to screen          *
* ----------------------------------------- *
.macro blit_row map, screen
    ldx #0
    ldy #0
loop
    lda :map,x
    asl                 ; asl = (arithmetic shift left) shift left 1 step e.g multiplying by 2
    sta :screen,y 
    iny
    clc
    adc #1
    sta :screen,y
    iny
    inx
    cpx #20
    bne loop
    .endm 

* ----------------------------------------- *
* Proc: display map                         *
* Displays the current map                  *
* ----------------------------------------- *
.proc display_map
    blit_row map, screen
    blit_row map+20, screen+40
    blit_row map+40, screen+80
    blit_row map+60, screen+120
    blit_row map+80, screen+160
    blit_row map+100, screen+200
    blit_row map+120, screen+240
    blit_row map+140, screen+280
    blit_row map+160, screen+320
    blit_row map+180, screen+360
    blit_row map+200, screen+400
    blit_row map+220, screen+440
    rts
map
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1
    .byte 1, 2, 2, 3, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 3, 2, 2, 2, 1, 2, 2, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 3, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 3, 1, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 5, 2, 1
    .byte 1, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 1
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .endp
