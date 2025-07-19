include irvine32.inc
include macros.inc
includelib kernel32.lib
Beep PROTO, 
    dwFreq:DWORD, 
    dwDuration:DWORD

.data


    ;instruction page
    instructions db "INSTRUCTIONS", 0
    controls1    db "CONTROLS:", 0
    controls2    db "W - Move Up", 0
    controls3    db "A - Move Left", 0
    controls4    db "S - Move Down", 0
    controls5    db "D - Move Right", 0
    controls6    db "P - Pause Game", 0
    controls7    db "X - Exit", 0
    objective1   db "OBJECTIVE:", 0
    objective2   db "Eat all dots (.) to increase score", 0
    objective3   db "Avoid ghosts (^) or lose lives", 0
    objective4   db "Complete all 3 levels to win", 0
    pressKey     db "Press any key to start...", 0

   

   ;file handling
    filename db "scores.txt", 0
    fileHandle HANDLE ?
    strNewLine db 0Dh, 0Ah, 0
    strScoreFormat db "Player: ", 0
    strScoreSeparator db ", Score: ", 0
    scoreBuffer db 16 dup(0)


    strPlayer db "Player: ", 0
    borderColor = cyan
    bgColor = blue                    ;ye background color ke liye
    pColor = brown
    depth = 3
    range = 4
    SegColor = red
    segsize = 10
    xPos byte 1
    yPos byte 2
    gx01 byte 1
    gy01 byte 25
    gx02 byte 118
    gy02 byte 14
    gx03 byte 118
    gy03 byte 2
    sx byte 5
    sy byte 3
    missUpdatee byte 0
    back byte 0
    fore byte 0
    borClr dd 0
    filClr dd 0 
    w byte ?
    l byte ?
    strScore db "Score: ", 0
    score dw 0
    inputchar db ?
    level byte 1
    lives byte 3
    Playername db 20 dup (0)
    nameSize db ?




   


    Level1  db "                                                                                                                        "
            db "************************************************************************************************************************"
            db "* .....................................................................................................................*"
            db "*.**************************************.**************************************.**************************************.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.*....................................*.*....................................*.*....................................*.*"
            db "*.**************************************.**************************************.**************************************.*"
            db "*......................................................................................................................*"
            db "************************************************************************************************************************"

    Level2  db "                                                                                                                        "
            db "************************************************************************************************************************"
	        db "*......................................................................................................................*"
	        db "*.***************************************.*******************.*******************.************************************.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.***************************************.*.................*.*.................*.************************************.*"
	        db "*.........................................*.................*.*.................*......................................*"
	        db "*.***************************************.*.................*.*.................*.************************************.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.*.....................................*.*.................*.*.................*.*..................................*.*"
	        db "*.***************************************.*******************.*******************.************************************.*"
	        db "*......................................................................................................................*"
	        db "*.***********************************************************.********************************************************.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.*.........................................................*.*......................................................*.*"
	        db "*.***********************************************************.********************************************************.*"
	        db "*......................................................................................................................*"
	        db "************************************************************************************************************************"

    level3 db "                                                                                                                        "
           db "************************************************************************************************************************"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "*......................................................................................................................*"
           db "************************************************************************************************************************"

.code
main PROC
    call gameName
    call ShowInstructions
    call WelcomeScreen
    call printBoundary

    call printBoardLevel1

    mov xpos, 1
    mov ypos, 2
    gameLoop:
		; draw score:
		mov dl,0
		mov dh,0
		call Gotoxy
		mov edx,OFFSET strScore
		call WriteString
		mov ax,score
		call WriteInt

        mov dl, 80       ; X-position (right side)
        mov dh, 0        ; Y-position (top)
        call Gotoxy
        mov edx, OFFSET strPlayer
        call WriteString
        mov edx, OFFSET Playername
        call WriteString

		; get user key input:
		call ReadChar
		mov inputChar,al

		; exit game if user types 'x':
		cmp inputChar,"x"
		je exitGame
        

        ;move walay button
		cmp inputChar,"w"
		je moveUp

		cmp inputChar,"s"
		je moveDown

		cmp inputChar,"a"
		je moveLeft

		cmp inputChar,"d"
		je moveRight

        cmp inputChar, "p"
        jne dontPause
        call pausedgame

        dontPause:
        jmp gameloop

		moveUp:
		call UpdatePlayer
        call PlayMoveSound
		dec yPos
		call calculatePos
        cmp level, 1
        je checkU1
        cmp level, 2
        je checkU2
        cmp level, 3
        je checkU3
        jmp exitGame 

        checkU1:
        cmp [level1 + edx], "."
        je correct
        cmp [level1 + edx], " "
        je possible
        jmp notPossibleUp

        checkU2:
        cmp [level2 + edx], "."
        je correct
        cmp [level2 + edx], " "
        je possible
        jmp notPossibleUp

        checkU3:
        cmp [level3 + edx], "."
        je correct
        cmp [level3 + edx], " "
        je possible

        notPossibleUp:
        inc yPos
        call DrawPlayer
        jmp gameLoop

		moveDown:
		call UpdatePlayer
        call PlayMoveSound
		inc yPos
        call calculatePos       
        cmp level, 1
        je checkD1
        cmp level, 2
        je checkD2
        cmp level, 3
        je checkD3
        jmp exitGame 

        checkD1:
        cmp [level1 + edx], "."
        je correct
        cmp [level1 + edx], " "
        je possible
        jmp notPossibleDn

        checkD2:
        cmp [level2 + edx], "."
        je correct
        cmp [level2 + edx], " "
        je possible
        jmp notPossibleDn

        checkD3:
        cmp [level3 + edx], "."
        je correct
        cmp [level3 + edx], " "
        je possible

        notPossibleDn:
        dec yPos
        call DrawPlayer
        jmp gameLoop

		moveLeft:
		call UpdatePlayer
        call PlayMoveSound
		dec xPos
		call calculatePos
        cmp level, 1
        je checkL1
        cmp level, 2
        je checkL2
        cmp level, 3
        je checkL3
        jmp exitGame

        checkL1:
        cmp [level1 + edx], "."
        je correct
        cmp [level1 + edx], " "
        je possible
        jmp notPossibleLf

        checkL2:
        cmp [level2 + edx], "."
        je correct
        cmp [level2 + edx], " "
        je possible
        jmp notPossibleLf

        checkL3:
        cmp [level3 + edx], "."
        je correct
        cmp [level3 + edx], " "
        je possible

        notPossibleLf:
        inc xPos
        call DrawPlayer
        jmp gameLoop

		moveRight:
		call UpdatePlayer
        call PlayMoveSound
		inc xPos
		call calculatePos
        cmp level, 1
        je checkR1
        cmp level, 2
        je checkR2
        cmp level, 3
        je checkR3
        jmp exitGame

        checkR1:
        cmp [level1 + edx], "."
        je correct
        cmp [level1 + edx], " "
        je possible
        jmp notPossibleRg

        checkR2:
        cmp [level2 + edx], "."
        je correct
        cmp [level2 + edx], " "
        je possible
        jmp notPossibleRg

        checkR3:
        cmp [level3 + edx], "."
        je correct
        cmp [level3 + edx], " "
        je possible

        notPossibleRg:
        dec xPos
        call DrawPlayer
        jmp gameLoop

        correct:
        inc score
        call PlayDotSound

        possible:
        call simulateGhost
        cmp level, 1
        je update1

        cmp level, 2
        je update2

        cmp level, 3
        je update3

        update1:
        mov [level1 + edx], " "
        jmp UpdateConsole

        update2:
        mov [level2 + edx], " "
        jmp UpdateConsole

        update3:
        mov [level3 + edx], " "
        jmp UpdateConsole

        UpdateConsole:
		call DrawPlayer
        cmp score, 100
        je level2_init
        cmp score, 200
        je level3_init
        cmp score, 300
        je exitGame

        call simulateGhost
        call checkGhostCollision
        cmp dl, 1
        je livelost
        call updateLives

        jmp gameLoop

        livelost:
            dec lives
            call PlayGhostCollisionSound
            mov xpos, 2
            mov ypos, 2
            cmp lives, 0
            je exitGame
            call updateLives
            jmp gameloop
        
        level2_init:
            inc level
            call PlayLevelUpSound
            call printBoundary
            call printBoardLevel2
            mov xpos, 1
            mov ypos, 2
            call drawplayer
            jmp gameloop

        level3_init:
            inc level
            call PlayLevelUpSound
            call printBoundary
            call printBoardLevel3
            mov xpos, 1
            mov ypos, 2
            mov eax, white + (black * 16)
            call settextcolor
            call drawplayer
            jmp gameloop


	jmp gameLoop

    exitGame::
        ;call clrscr
        ;exit

        ; Resetting colour of exit statment to black
        call PlayGameOverSound
        call SaveScoreToFile
        mov eax, white + (black * 16)
        call setTextColor
        call clrscr
        mov dl, 0
        mov dh, 0
        call gotoxy
        exit
    
main ENDP


ShowInstructions proc
    call ClrScr  ; Clear screen
    
    ; Print instructions line by line
    mov edx, OFFSET instructions
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET controls1
    call WriteString
    call Crlf
    
    mov edx, OFFSET controls2
    call WriteString
    call Crlf
    
    mov edx, OFFSET controls3
    call WriteString
    call Crlf
    
    mov edx, OFFSET controls4
    call WriteString
    call Crlf
    
    mov edx, OFFSET controls5
    call WriteString
    call Crlf
    
    mov edx, OFFSET controls6
    call WriteString
    call Crlf
    
    mov edx, OFFSET controls7
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET objective1
    call WriteString
    call Crlf
    
    mov edx, OFFSET objective2
    call WriteString
    call Crlf
    
    mov edx, OFFSET objective3
    call WriteString
    call Crlf
    
    mov edx, OFFSET objective4
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET pressKey
    call WriteString
    
    call ReadChar  ; Wait for key press
    ret
ShowInstructions endp

gameName proc
    ; Save registers (optional, but good practice)
    push eax
    push edx

    ; Clear screen and set background color
    call clrscr
    mov eax, yellow + (black * 16)  ; Yellow text on black background
    call setTextColor

    ; Position cursor and print title
    mov dl, 50          ; X-position (centered)
    mov dh, 10          ; Y-position (middle of screen)
    call Gotoxy
    mwrite "23i-2508's Coal Project"  ; Your desired text

    ; Wait for key press
    mov dl, 50          ; X-position for prompt
    mov dh, 12          ; Y-position below title
    call Gotoxy
    mwrite "Press any key to continue..."
    call ReadChar       ; Wait for input

    ; Restore registers
    pop edx
    pop eax
    ret
gameName endp

updateLives proc
    push eax
    mgotoxy 50, 0
    mwrite "Lives: "
    movzx eax, lives
    call writedec
    pop eax
    ret
updateLives endp

simulateGhost proc
    cmp level, 1
    je ghost1
    cmp level, 2
    je ghost2

    ghost3:
    call simulateGhost3

    ghost2:
    call simulateGhost2

    ghost1:
    call simulateGhost1
    call simulateGhost3
    
    ret
simulateGhost endp


simulateGhost1 proc
    push eax
    push ebx
    push ecx
    push edx

    mov eax, range
    call randomrange
    inc eax

    mov dl, 1
    call updateghost

    cmp eax, 1
    je moveUp
    cmp eax, 2
    je moveDn
    cmp eax, 3
    je moveRg
    cmp eax, 4
    je moveLt


    moveUp:
        dec gy01
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleUP:
        inc gy01
        jmp return

    moveDn:
        inc gy01
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleDN:
        dec gy01
        jmp return

    moveRg:
        inc gx01
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleRG:
        dec gx01
        jmp return

    moveLt:
        dec gx01
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleLT:
        inc gx01
        jmp return

    return:
    mov dl, 1
    call drawGhost
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
simulateGhost1 endp

simulateGhost2 proc
    push eax
    push ebx
    push ecx
    push edx

    mov eax, range
    call randomrange
    inc eax

    mov dl, 2
    call updateghost

    cmp eax, 1
    je moveUp
    cmp eax, 2
    je moveDn
    cmp eax, 3
    je moveRg
    cmp eax, 4
    je moveLt


    moveUp:
        dec gy02
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleUP:
        inc gy02
        call simulateGhost2
        jmp return

    moveDn:
        inc gy02
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleDN:
        dec gy02
        call simulateGhost2
        jmp return

    moveRg:
        inc gx02
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleRG:
        dec gx02
        call simulateGhost2
        jmp return

    moveLt:
        dec gx02
        call checkGhostPossible
        cmp cl, 1
        je return

        notPossibleLT:
        inc gx02
        call simulateGhost2
        jmp return

    return:
    mov dl, 2
    call drawGhost
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
simulateGhost2 endp

simulateGhost3 proc
    push eax
    push ebx
    push ecx
    push edx

    mov dl, 3
    call updateghost

    checkxg:
    mov dl, gx03
    cmp xpos, dl
    jl checkxl
    je checkyg

    ; ispossiblexg
    inc gx03
    mov dl, 3
    call checkGhostPossible
    cmp cl, 1
    je success
    dec gx03
    jmp checkyg

    checkxl:
    dec gx03
    mov dl, 3
    call checkGhostPossible
    cmp cl, 1
    je success
    inc gx03
    ; will automatticaly jump to checkyg

    checkyg:
    mov dh, gy03
    cmp ypos, dh
    jl checkyl
    
    ; ispossibleyg
    inc gy03                                        ; move down
    mov dl, 3
    call checkGhostPossible                         ; check can move at that position  for ghost 3
    cmp cl, 1
    je success
    dec gy03                                        ; if cannot move, then reterive
    jmp success                                 

    checkyl:
    dec gy03
    mov dl, 3
    call checkGhostPossible
    cmp cl, 1
    je success
    inc gy03
    ; will automatically go toward success.. either way we should not move opposite to player

    success:
    mov dl, 3
    call drawGhost
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
simulateGhost3 endp


checkGhostPossible proc
        cmp dl, 1
        je set1
        cmp dl, 2
        je set2
        cmp dl, 3
        je set3

        set1:
        mov cl, gx01
        mov ch, gy01
        jmp checkLevel

        set2:
        mov cl, gx02
        mov ch, gy02
        jmp checkLevel

        set3:
        mov cl, gx03
        mov ch, gy03
        jmp checkLevel

        checkLevel:
        cmp level, 1
        je check1

        cmp level, 2
        je check2

        cmp level, 3
        je check3

        check1:
            call calculatePosGhost
            cmp [level1 + edx], " "
            je possible
            cmp [level1 + edx], "."
            je possible
            jne notPossible

        check2:
            call calculatePosGhost
            cmp [level2 + edx], " "
            je possible
            cmp [level2 + edx], "."
            je possible
            jne notPossible
            
        check3:
            call calculatePosGhost
            cmp [level3 + edx], " "
            je possible
            cmp [level3 + edx], "."
            je possible
            jne notPossible

        notPossible:
            mov cl, 0
            ret

        possible:
            mov cl, 1
            ret
checkGhostPossible endp

checkGhostCollision proc
    mov dl, xpos
    mov dh, ypos

    checkx1:
    cmp dl, gx01
    je checky1
    jne checkx2

    checky1:
    cmp dh, gy01
    je collided

    checkx2:
    cmp dl, gx02
    je checky2
    jne checkx3

    checky2:
    cmp dh, gy02
    je collided

    checkx3:
    cmp dl, gx03
    je checky3
    jne notCollided

    checky3:
    cmp dh, gy03
    je collided

    notCollided:
    mov dl, 0
    ret

    Collided:
    mov dl, 1
    ret
checkGhostCollision endp

DrawPlayer PROC
	; draw player at (xPos,yPos):
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
    mov eax, pColor + (16 * bgColor)
    call settextcolor
	mov al,"C"                     ;ye pacman ka symbol hai
	call WriteChar
	ret
DrawPlayer ENDP

UpdatePlayer PROC
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
    mov eax, bordercolor + (16 * bgcolor)
	mov al," "
	call WriteChar
	ret
UpdatePlayer ENDP

DrawGhost PROC
    cmp dl, 1
    je set1
    cmp dl, 2
    je set2
    cmp dl, 3
    je set3

    set1:
    mov dl,gx01
	mov dh,gy01
    jmp GotoPos

    set2:
    mov dl, gx02
    mov dh, gy02
    jmp GotoPos

    set3:
    mov dl, gx03
    mov dh, gy03
    jmp GotoPos

    GotoPos:
	call Gotoxy
    mov eax, red + (bgColor * 16)
    call settextcolor
	mov al,"^"              ;ye ghost ka symbol hai
	call WriteChar
    mov eax, yellow + (bgColor * 16)
    call settextcolor
	ret
DrawGhost ENDP

UpdateGhost Proc
    push eax
    push ebx
    push ecx
    push edx

    cmp dl, 1
    je set1
    cmp dl, 2
    je set2
    cmp dl, 3
    je set3

    set1:
    mov dl,gx01
	mov dh,gy01
    jmp GotoPos

    set2:
    mov dl, gx02
    mov dh, gy02
    jmp GotoPos

    set3:
    mov dl, gx03
    mov dh, gy03
    jmp GotoPos

    GotoPos:
	call Gotoxy
    mov eax, white + (bgColor * 16)
    call settextcolor
    mov cl, dl
    mov ch, dh
    call calculatePosGhost
    cmp level, 1
    je update1
    cmp level, 2
    je update2
    cmp level, 3
    je update3
    ret

    update1:
	    mov al, [level1 + edx]
	    call WriteChar
        jmp return

    update2:
        mov al, [level2 + edx]
        call writechar
        jmp return

    update3:
        mov al, [level3 + edx]
        call writechar
        jmp return

    return:
    pop edx
    pop ecx
    pop ebx
    pop eax
	ret
UpdateGhost endp

calculatePos proc   ; xPos + (yPos * 120)
    push eax
    push ebx
    push ecx

    ; yPos * 120
    movzx eax, ypos
    mov   ebx, 120
    mul ebx
    mov edx, eax

    ; xpos + edx
    movzx ebx, xPos
    add edx, ebx

    pop ecx
    pop ebx
    pop eax
    ret
calculatePos endp

calculatePosGhost proc   ; xPos + (yPos * 120)
    push eax
    push ebx
    push ecx

    ; yPos * 120
    movzx eax, ch
    mov   ebx, 120
    mul ebx
    mov edx, eax

    ; xpos + edx
    movzx ebx, cl
    add edx, ebx

    pop ecx
    pop ebx
    pop eax
    ret
calculatePosGhost endp

pausedGame proc
    mov eax, yellow + (black * 16)
    call settextcolor
    mgotoxy 100, 0
    mwrite "Paused  :|"

    pauseLoop:
    call readchar
    cmp al, "p"
    je return
    cmp al, "P"
    je return
    cmp al, "x"
    je exitGame
    cmp al, "X"
    je exitGame
    jmp pauseLoop

    return:
    mov eax, white + (black * 16)
    call settextcolor
    mgotoxy 100, 0
    mwrite "Playing :)"
    ret
pausedGame endp

printBoardLevel3 proc
    comment&
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block first            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 5
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 19
    mov l, al

    ; Border colour
    mov eax, yellow + (yellow * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, Black + (Black * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block second           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 27
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 19
    mov l, al

    ; Border colour
    mov eax, yellow + (yellow * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, Black + (Black * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block third            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 21
    mov xPos, al
    
    ; Starting Y
    mov al, 10
    mov yPos, al

    ; Length and width
    mov al, 7
    mov w, al

    ; length
    mov al, 9
    mov l, al

    ; Border colour
    mov eax, yellow + (yellow * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, Black + (Black * 16)
    mov filClr, eax

    ;call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block fourth           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 5
    mov xPos, al
    
    ; Starting Y
    mov al, 19
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 38
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    ;call printRect
    &

    mov eax, SegColor + (bgColor * 16)
    call settextcolor

    mov ebx, depth

    print2:
    call printsegment1
    call printsegment2
    call printsegment4
    call printsegment5
    call printsegment7
    inc sy
    dec ebx
    cmp ebx, 0
    jg print2
    call gotonextdigit

    print3:
    call printsegment1
    call printsegment2
    call printsegment3
    call printsegment4
    call printsegment7
    inc sy
    dec ebx
    cmp ebx, 0
    jg print3
    call gotonextdigit

    print2_again:
    call printsegment1
    call printsegment2
    call printsegment4
    call printsegment5
    call printsegment7
    inc sy
    dec ebx
    cmp ebx, 0
    jg print2_again
    call gotonextdigit

    print5:
    call printsegment1
    call printsegment3
    call printsegment4
    call printsegment6
    call printsegment7
    inc sy
    dec ebx
    cmp ebx, 0
    jg print5
    call gotonextdigit

    print0:
    call printsegment1
    call printsegment2
    call printsegment3
    call printsegment4
    call printsegment5
    call printsegment6
    inc sy
    dec ebx
    cmp ebx, 0
    jg print0
    call gotonextdigit

    print8:
    call printsegment1
    call printsegment2
    call printsegment3
    call printsegment4
    call printsegment5
    call printsegment6
    call printsegment7
    inc sy
    dec ebx
    cmp ebx, 0
    jg print8
    call gotonextdigit

    ret
printBoardLevel3 endp


gotonextdigit proc
    sub sy, depth                       ; return sy to its position 
    mov dl, segsize
    add sx, dl
    add sx, dl
    mov ebx, depth
    ret
gotonextdigit endp

printsegment1 proc
    mov dl, sx
    mov dh, sy
    
    ; segment size
    mov cl, sx 
    add cl, segsize

    print:
       call printsegment
       
       inc dl
       cmp dl, cl
       jl print
       
    ret
printsegment1 endp

printsegment2 proc
    mov dl, sx
    add dl, segsize
    mov dh, sy
    mov cl, sy
    add cl, segsize

    print:
        call printsegment
        inc dh
        cmp dh, cl
        jl print

    ret
printsegment2 endp

printsegment3 proc
    mov dl, sx
    add dl, segsize
    mov dh, sy
    add dh, segsize
    mov cl, sy
    add cl, segsize
    add cl, segsize

    print:
        call printsegment
        inc dh
        cmp dh, cl
        jl print

    ret
printsegment3 endp

printsegment4 proc
    mov dl, sx
    mov dh, sy
    add dh, segsize
    add dh, segsize
    mov cl, sx
    add cl, segsize

    print:
        call printsegment
        inc dl
        cmp dl, cl
        jle print

    ret
printsegment4 endp

printsegment5 proc
    mov dl, sx
    mov dh, sy
    add dh, segsize
    mov cl, sy
    add cl, segsize
    add cl, segsize

    print:
        call printsegment
        inc dh
        cmp dh, cl
        jl print

    ret
printsegment5 endp

printsegment6 proc
    mov dl, sx
    mov dh, sy
    mov cl, sy
    add cl, segsize

    print:
        call printsegment
        inc dh
        cmp dh, cl
        jl print

    ret
printsegment6 endp

printsegment7 proc
    mov dl, sx
    mov dh, sy
    add dh, segsize
    mov cl, sx
    add cl, segsize

    print:
        call printsegment
        inc dl
        cmp dl, cl
        jle print

    ret
printsegment7 endp

printsegment proc
    call gotoxy
    mov al, "*"
    call writechar
    call updateLevel3
    ret
printsegment endp

updateLevel3 proc
    push ecx
    push edx
    cmp missUpdatee, 1
    je missUpdate

    mov cl, dl
    mov ch, dh
    call calculatePosGhost
    mov [level3 + edx], "*"
    missUpdate:
    pop edx
    pop ecx
    ret
updateLevel3 endp

printBoardLevel2 proc
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block first            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 2
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 38
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block second           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 2
    mov xPos, al
    
    ; Starting Y
    mov al, 10
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 38
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block third            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 2
    mov xPos, al
    
    ; Starting Y
    mov al, 17
    mov yPos, al

    ; Length and width
    mov al, 10
    mov w, al

    ; length
    mov al, 58
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block fourth           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 42
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 12
    mov w, al

    ; length
    mov al, 18
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block fifth            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 62
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al
    
    ; Length and width
    mov al, 12
    mov w, al

    ; length
    mov al, 18
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block sixth           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 82
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 35
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block seventh          ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 82
    mov xPos, al
    
    ; Starting Y
    mov al, 10
    mov yPos, al

    ; Length and width
    mov al, 5
    mov w, al

    ; length
    mov al, 35
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block eighth           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 62
    mov xPos, al
    
    ; Starting Y
    mov al, 17
    mov yPos, al

    ; Length and width
    mov al, 10
    mov w, al

    ; length
    mov al, 55
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ret
printBoardLevel2 endp

printBoardLevel1 proc
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block first            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 2
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 24
    mov w, al

    ; length
    mov al, 37
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block second           ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 41
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 24
    mov w, al

    ; length
    mov al, 37
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;            Block third            ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Coordinate
    ; X
    mov al, 80
    mov xPos, al
    
    ; Starting Y
    mov al, 3
    mov yPos, al

    ; Length and width
    mov al, 24
    mov w, al

    ; length
    mov al, 37
    mov l, al

    ; Border colour
    mov eax, borderColor + (borderColor * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, bgColor + (bgColor * 16)
    mov filClr, eax

    call printRect
    ret
printBoardLevel1 endp

printBoundary proc
    ; Coordinate
    ; X
    mov al, 0
    mov xPos, al
    
    ; Starting Y
    mov al, 1
    mov yPos, al

    ; Length and width
    mov al, 28
    mov w, al

    ; length
    mov al, 119
    mov l, al

    ; Border colour
    mov eax, cyan + (cyan * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, white + (blue * 16)
    mov filClr, eax

    call clrscr
    call printRect
    ret
printBoundary endp

WelcomeScreen proc
    ; Coordinate
    ; X
    mov al, 0
    mov xPos, al
    
    ; Starting Y
    mov al, 0
    mov yPos, al

    ; Length and width
    mov al, 29
    mov w, al

    ; length
    mov al, 119
    mov l, al

    ; Border colour
    mov eax, yellow + (yellow * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, yellow + (yellow * 16)
    mov filClr, eax

    call clrscr
    call printRect

    ; Coordinate
    ; X
    mov al, 40
    mov xPos, al
    
    ; Starting Y
    mov al, 10
    mov yPos, al

    ; Length and width
    mov al, 4
    mov w, al

    ; length
    mov al, 40
    mov l, al

    ; Border colour
    mov eax, white + (white * 16)
    mov borClr, eax

    ; Filled colour
    mov eax, black + (black * 16)
    mov filClr, eax

    call printRect

    mov eax, white + (black * 16)
    call settextColor
    mgotoxy 45, 12
    mwrite "Enter Name: "
    mreadstring Playername
    mov nameSize, al
    ret
WelcomeScreen endp

PrintRect proc
    ; Data taken... Now printing begins

    ;Setting Border Colour
    mov eax, borClr
    call setTextColor

    ; updating cursor info of terminal
    mov dl, xPos
    mov dh, yPos
    call gotoxy
    
    mov bl, dl
    add bl, l
    mov bh, dh
    add bh, w

    mov al, "*"
    call BorderPrint

    ; Adjustments for inner
    inc xPos
    inc yPos
    inc dh
    dec bl
    dec bh

    ; Setting Filler Colour
    mov eax, filClr
    call setTextColor

    ; dummy char
    mov al, "."

    In1:
        mov dl, xPos
        In2:
            call gotoxy
            call writeChar
            inc dl
            cmp dl, bl
            jle In2
        inc dh
        cmp dh, bh
        jle In1
        ret
PrintRect endp

BorderPrint proc
    bl1:
        call writechar
        inc dl
        call gotoxy
        cmp dl, bl
        jl bl1

    bl2:
        call writechar
        inc dh
        call gotoxy
        cmp dh, bh
        jl bl2

    bl3:
        call writechar
        dec dl
        call gotoxy
        cmp dl, xPos
        jg bl3


    bl4:
        call writechar
        dec dh
        call gotoxy
        cmp dh, yPos
        jg bl4
        ret
BorderPrint endp



; sounds procs

PlayMoveSound PROC
    INVOKE Beep, 800, 50    ; Medium pitch, short beep
    ret
PlayMoveSound ENDP

PlayDotSound PROC
    INVOKE Beep, 1200, 100   ; High pitch,  longer
    ret
PlayDotSound ENDP

PlayGhostCollisionSound PROC
    INVOKE Beep, 300, 500    ; Low tone
    ret
PlayGhostCollisionSound ENDP

PlayLevelUpSound PROC
    ; Victory melody (3 ascending tones)
    INVOKE Beep, 800, 100
    INVOKE Beep, 1000, 100
    INVOKE Beep, 1200, 100
    ret
PlayLevelUpSound ENDP

PlayGameOverSound PROC
    ; Descending "failure" tone
    INVOKE Beep, 600, 300
    INVOKE Beep, 400, 300
    INVOKE Beep, 200, 500
    ret
PlayGameOverSound ENDP

SaveScoreToFile PROC
    ; Create or open the file for appending
    mov edx, OFFSET filename
    call CreateOutputFile  
    mov fileHandle, eax
    
    ; Check for errors
    cmp eax, INVALID_HANDLE_VALUE
    je FileError
    
    ; Move file pointer to end (for appending)
    mov eax, fileHandle
    mov edx, 0
    mov ecx, FILE_END
    call SetFilePointer
    
    ; Write player name
    mov eax, fileHandle
    mov edx, OFFSET strScoreFormat
    mov ecx, LENGTHOF strScoreFormat - 1
    call WriteToFile
    
    mov eax, fileHandle
    mov edx, OFFSET Playername
    movzx ecx, nameSize
    call WriteToFile
    
    ; Write score separator
    mov eax, fileHandle
    mov edx, OFFSET strScoreSeparator
    mov ecx, LENGTHOF strScoreSeparator - 1
    call WriteToFile
    
    ; Convert score to string
    mov eax, 0
    mov ax, score
    mov edi, OFFSET scoreBuffer
    call ConvertIntToString
    
    ; Write the score string
    mov eax, fileHandle
    mov edx, OFFSET scoreBuffer
    mov ecx, 0
CountLength:
    cmp byte ptr [edx + ecx], 0
    je DoneCounting
    inc ecx
    jmp CountLength
DoneCounting:
    call WriteToFile
    
    ; Write new line
    mov eax, fileHandle
    mov edx, OFFSET strNewLine
    mov ecx, 2  ; Length of CRLF
    call WriteToFile
    
    ; Close the file
    mov eax, fileHandle
    call CloseFile
    ret
    
FileError:
    ; Handle file error if needed
    ret
SaveScoreToFile ENDP

ConvertIntToString PROC
    ; Input: EAX = integer value, EDI = pointer to buffer
    pushad
    mov ebx, 10
    xor ecx, ecx
    
    ; Handle zero case
    test eax, eax
    jnz NonZero
    mov byte ptr [edi], '0'
    mov byte ptr [edi+1], 0
    jmp Done
    
NonZero:
DivideLoop:
    xor edx, edx
    div ebx
    add dl, '0'
    push edx
    inc ecx
    test eax, eax
    jnz DivideLoop
    
    ; Pop digits in reverse order
    mov esi, edi
StoreLoop:
    pop eax
    mov [esi], al
    inc esi
    loop StoreLoop
    mov byte ptr [esi], 0
    
Done:
    popad
    ret
ConvertIntToString ENDP


END main

