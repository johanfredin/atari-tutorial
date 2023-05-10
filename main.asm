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
    sta pmg_p0,x    
    sta pmg_p1,x
    sta pmg_p2,x
    sta pmg_p3,x
    dex
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
* Proc: display map                         *
* Displays the current map                  *
* ----------------------------------------- *
.proc display_map
    ldy #0
loop
    mva map,y screen,y
    mva map+40,y screen+40,y
    mva map+80,y screen+80,y
    mva map+120,y screen+120,y
    mva map+160,y screen+160,y
    mva map+200,y screen+200,y
    mva map+240,y screen+240,y
    mva map+280,y screen+280,y
    mva map+320,y screen+320,y
    mva map+360,y screen+360,y
    mva map+400,y screen+400,y
    mva map+440,y screen+440,y
    iny
    cpy #40                                             ; the amount of bytes in our scene
    bne loop
    rts
map
    .byte 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3, 2, 3, 6, 7, 2, 3, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3, 4, 5,10,11, 4, 5, 2, 3
    .byte 2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 2, 3, 4, 5, 4, 5, 4, 5, 2, 3
    .byte 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3
    .endp
