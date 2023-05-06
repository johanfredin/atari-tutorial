; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL
; None of this code is mine

 org $2000                                                  ; origin line, tells the assembler where our program will live in memory

SDLSTL = $0230                                              ; Starting address for our display list (dlist)
CHBAS = $02f4                                               ; Character base register

; colors
COLOR0 = $02c4                                              ; Color for %01
COLOR1 = $02c5                                              ; Color for %10
COLOR2 = $02c6                                              ; Color for %11 (normal)
COLOR3 = $02c7                                              ; Color for %11 (inverse)
COLOR4 = $02c8                                              ; Color for %00 (background)


charset = $3c00                                             ; allocate space for character set, there are 4 pages and each is 256 bytes in size, 
                                                            ; we will put it right before our screen memory
screen = $4000                                              ; screen buffer
blank8 = $70                                                ; 8 blank lines 
lms = $40                                                   ; LMS = Load Memory Scan
jvb = $41                                                   ; Jump While Vertical blank 

antic2 = 2                                                 ; Antic mode 2
antic5 = 5                                                 ; Antic mode 5

; Each color corresponds to a position in the ntsc pallete
clr_med_gray = $06
clr_lt_gray  = $0a
clr_green    = $c2
clr_brown    = $22
clr_black    = $00

; Loads our display list
    mwa #dlist SDLSTL                                      ; (mwa=move word) load in the first byte of our dlist into A reg and then the second

; Set up character set    
    mva #>charset CHBAS                                    ; (mva=move byte) move the high byte of charset into CHBAS address

    ldx #0
loop     
    mva chars,x charset+8,x 
    inx
    cpx #16
    bne loop

; change colors
    mva #clr_med_gray COLOR0
    mva #clr_lt_gray COLOR1
    mva #clr_green COLOR2
    mva #clr_brown COLOR3
    mva #clr_black COLOR4

    ldy #0
loop2
    mva scene,y screen,y                                ; same as lda scene, y sta screen, y
    iny
    cpy #4                                              ; the amount of bytes in our scene
    bne loop2

    jmp *

; Display list
dlist
    .byte blank8, blank8, blank8                             ; 24(8*3) blank lines
    .byte antic5 + lms, <screen, >screen                     ; < = left shift, > = right shift
    .byte antic5, antic5, antic5, antic5, antic5, antic5
    .byte antic5, antic5, antic5, antic5, antic5
    .byte jvb, <dlist, >dlist

scene
    .byte 1, 2, 129, 130

chars
; left half of a ball
    .byte %00000000
    .byte %00000001
    .byte %00000110
    .byte %00011011
    .byte %00011011
    .byte %00000110
    .byte %00000001
    .byte %00000000
; right half of a ball
    .byte %00000000
    .byte %01000000
    .byte %10010000
    .byte %11100100
    .byte %11100100
    .byte %10010000
    .byte %01000000
    .byte %00000000
 