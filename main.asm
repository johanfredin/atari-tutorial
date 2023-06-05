; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL

    org $2000                                  ; origin line, tells the assembler where our program will live in memory

map     = $3000 ; map memory location
charset = $4000 ; allocate space for character set, there are 4 pages and each is 256 bytes in size, 
pmg     = $5000 ; Player Missile Data
canvas  = $6000 ; screen buffer

    setup_screen()
    setup_colors()
    mva #>charset CHBAS 
    clear_pgm()
    load_pmg()
    setup_pmg_system()
    copy_map_to_canvas()

    jmp *
    
    icl 'hardware.asm'
    icl 'dlist.asm'
    icl 'gfx.asm'
    icl 'pmgdata.asm'
    icl 'map.asm'

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
* Proc: copy_map_to_canvas                  *
* Copies map to canvas with interpolation   *
* ----------------------------------------- *
.proc copy_map_to_canvas
map_ptr = $92               ; zero page location (faster instructions )
                            ; locations $92 - $CA (146 - 202) are reserved
                            ; for the 8K BASIC ROM on the real machine, but 
                            ; we dont care about that so we can just write over it
canvas_ptr = $94
    mwa #map map_ptr
    mwa #canvas canvas_ptr

    ldy #0
loop
    lda (map_ptr), y        ; () = indirect reference meaning whatever map_ptr is pointing to, grab it. same as pointer dereferencing in c (i think)
    asl 
    sta (canvas_ptr), y
    inc canvas_ptr          ; inc = increments a zero page pointer by 1
    bne next                ; bne without a cmp before means branch if != 0
    inc canvas_ptr + 1
next
    add #1                  ; macro that does clc and adc #1
    sta (canvas_ptr), y
    iny
    bne loop
    inc map_ptr + 1
    inc canvas_ptr + 1
    lda map_ptr + 1
    cmp #>(map + $1000)     ; make sure we dont go out of our 4k memory bounds
    bne loop    
    rts
    .endp