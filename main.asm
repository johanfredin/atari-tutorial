; EdVenture - following youtube tutorial https://www.youtube.com/watch?v=whhTuBpkcrY&list=PL7IgmhqRiwzFrYkkmF2PuxODsAVTSYeZL
; None of this code is mine

 org $2000

SAVMSC = $0058 ; Screen memory adddress

 ldy #0             ;# = the litteral value 
loop
 lda hello, y       ; will load the letter H into accumulator
 sta (SAVMSC), y
 iny                ; inc y
 cpy #12            ; compare value in y register with abolute value 12
 bne loop           ; keep looping if y != 12
 


 jmp *             ; endless loop


; Data
hello
    .byte "HELLO ATARI!"
