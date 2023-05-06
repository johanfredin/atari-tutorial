; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL
; None of this code is mine

 org $2000                                                  ; origin line, tells the assembler where our program will live in memory

SDLSTL = $0230                                              ; Starting address for our display list (dlist)
CHBAS = $02f4                                               ; Character base register
 
charset = $3c00                                             ; allocate space for character set, there are 4 pages and each is 256 bytes in size, 
                                                            ; we will put it right before our screen memory
screen = $4000                                              ; screen buffer
blank8 = $70                                                ; 8 blank lines 
lms = $40                                                   ; LMS = Load Memory Scan
jvb = $41                                                   ; Jump While Vertical blank 

antic2 = 2                                                 ; Antic mode 2
antic5 = 5                                                 ; Antic mode 5


; Loads our display list
    mwa #dlist SDLSTL                                      ; (mwa=move word) load in the first byte of our dlist into A reg and then the second

; Set up character set    
    mva #>charset CHBAS                                    ; (mva=move byte) move the high byte of charset into CHBAS address

    ldy #0
print     
    mva chars,y  charset,y 
    iny
    cpy #8
    bne print

    jmp *

; Display list
dlist
    .byte blank8, blank8, blank8                             ; 24(8*3) blank lines
    .byte antic2 + lms, <screen, >screen                     ; < = left shift, > = right shift
    .byte antic5, antic5, antic5, antic5, antic5, antic5
    .byte antic5, antic5, antic5, antic5, antic5
    .byte jvb <dlist, >dlist

chars
    .byte %00000001
    .byte %00000010
    .byte %00000100
    .byte %00001000
    .byte %00010000
    .byte %00100000
    .byte %01000000
    .byte %10000000
 