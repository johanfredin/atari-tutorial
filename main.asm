; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL
; None of this code is mine

    org $2000                                                  ; origin line, tells the assembler where our program will live in memory

charset = $3c00                                             ; allocate space for character set, there are 4 pages and each is 256 bytes in size, 
                                                            ; we will put it right before our screen memory
screen = $4000                                              ; screen buffer

    setup_screen()
    setup_colors()
    load_gfx()
    display_map()

    jmp *

    
    icl 'hardware.asm'
    icl 'dlist.asm'
    icl 'gfx.asm'

* ----------------------------------------- *
* Proc setup colors                         *
* Sets up colors                            *
* ----------------------------------------- *
.proc setup_colors
clr_med_gray = $06
clr_lt_gray  = $0a
clr_green    = $c2
clr_brown    = $22
clr_black    = $00

    mva #clr_med_gray COLOR0    ; %01
    mva #clr_lt_gray COLOR1     ; %10
    mva #clr_green COLOR2       ; %11
    mva #clr_brown COLOR3       ; %11 (inverse)
    mva #clr_black COLOR4       ; %00

    rts
    .endp


* ----------------------------------------- *
* Proc: load_gfx                            *
* Loads graphics into character set         *
* ----------------------------------------- *   
.proc load_gfx
    mva #>charset CHBAS                                    ; (mva=move byte) move the high byte of charset into CHBAS address
    ldx #0
loop     
    mva gfx,x charset,x 
    mva gfx+8,x charset+8,x 
    mva gfx+16,x charset+16,x 
    mva gfx+32,x charset+32,x 

    inx
    cpx #128
    bne loop
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
