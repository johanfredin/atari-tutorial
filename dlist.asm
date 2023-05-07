* ----------------------------------------- *
* Proc setup screen                         *
* Sets up the display list for the screen   *
* ----------------------------------------- *
.proc setup_screen
blank8 = $70                ; 8 blank lines 
lms = $40                   ; LMS = Load Memory Scan
jvb = $41                   ; Jump While Vertical blank 
antic2 = 2                  ; Antic mode 2
antic5 = 5                  ; Antic mode 5

    mwa #dlist SDLSTL       ; (mwa=move word) load in the first byte of our dlist into A reg and then the second
    rts

dlist
    .byte blank8, blank8, blank8                             ; 24(8*3) blank lines
    .byte antic5 + lms, <screen, >screen                     ; < = left shift, > = right shift
    .byte antic5, antic5, antic5, antic5, antic5, antic5
    .byte antic5, antic5, antic5, antic5, antic5
    .byte jvb, <dlist, >dlist

    .endp


