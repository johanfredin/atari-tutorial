SDLSTL = $0230   ; Starting address for our display list (dlist)
CHBAS = $02f4    ; Character base register

; colors
COLOR0 = $02c4    ; Color for %01
COLOR1 = $02c5    ; Color for %10
COLOR2 = $02c6    ; Color for %11 (normal)
COLOR3 = $02c7    ; Color for %11 (inverse)
COLOR4 = $02c8    ; Color for %00 (background)
PCOLR0 = $02c0    ; Color for player missile 0
PCOLR1 = $02c1    ; Color for player missile 1
PCOLR2 = $02c2    ; Color for player missile 2
PCOLR3 = $02c3    ; Color for player missile 3

GRACTL = $D01D    ; Enable/Disable PMG
PMBASE = $d407    ; Player misilie graphics base adress
GRPRIOR = $026f   ; PMG priority
SDMCTL = $022f    ; PM resolution 46 ($2E) = double line resolution 
HPOSP0 = $d000    ; Horizontal postiion of player 0  
HPOSP1 = $d001    ; Horizontal postiion of player 1
HPOSP2 = $d002    ; Horizontal postiion of player 2
HPOSP3 = $d003    ; Horizontal postiion of player 3