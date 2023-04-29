; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL
; None of this code is mine

 org $2000                                                  ; origin line, tells the assembler where our program will live in memory

SAVMSC = $0058                                              ; Screen memory adress. The lowest adddress of the screen memory, corresponding to the upper left corner
                                                            ; of the screen (where the value at this addresss will be displayed)
SDLSTL = $0230                                              ; Starting address for our display list (dlist)

screen = $4000                                              ; screen buffer
blank8 = $70                                                ; 8 blank lines 
lms = $40                                                   ; LMS = Load Memory Scan
jvb = $41                                                   ; Jump While Vertical blank 

antic2 = $2                                                 ; Antic mode 2
antic3 = $3                                                 ; Antic mode 3
antic4 = $4                                                 ; Antic mode 4
antic5 = $5                                                 ; Antic mode 5
antic6 = $6                                                 ; Antic mode 6
antic7 = $7                                                 ; Antic mode 7


; Loads our display list
    lda #<dlist                                             ; load in the first byte of our dlist into a reg
    sta SDLSTL
    lda #>dlist
    sta SDLSTL+1


; Main loop
    ldy #0                                                  ;# = the litteral value 
loop
    lda hello, y                                            ; will load the letter H into accumulator
    sta screen, y
    iny                                                     ; inc y
    cpy #12                                                 ; compare value in y register with abolute value 12
    bne loop                                                ; keep looping if y != 12
 
    jmp *                                                   ; endless loop


; Display list
dlist
    .byte blank8, blank8, blank8                             ; 24(8*3) blank lines
    .byte antic5 + lms, <screen, >screen                     ; < = left shift, > = right shift
    .byte antic5, antic5, antic5, antic5, antic5, antic5
    .byte antic5, antic5, antic5, antic5, antic5
    .byte jvb <dlist, >dlist

; Data
hello
    .byte "HELLO ATARI!"
 