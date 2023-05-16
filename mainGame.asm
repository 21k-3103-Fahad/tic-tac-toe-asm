INCLUDE Irvine32.inc
.data
    
   playerMark BYTE 'X'
   cpuMark BYTE 'O'
   board BYTE '1','2','3','4','5','6','7','8','9'

   welcome BYTE "WELCOME TO TIC TAC TOE! ",0
   promptPlayer1 BYTE "Enter corresponding number (Mark X): ",0
   promptPlayer2 BYTE "Enter corresponding number (Mark 0): ",0
   incorrectPrompt BYTE "INVALID OPTION ENTERED. TRY AGAIN.",0
   playComp BYTE "Press 1 to play against CPU",0
   playP2 BYTE "Press 2 to play against another Player",0

   playerWins BYTE "Player 1 wins!",0
   compWins BYTE "Player 2 wins!",0
   drawMessage BYTE "It's a draw",0

.code
main PROC
     lea edx, welcome
     call WriteString
     call crlf

    game_select:
     lea edx, playComp
     call WriteString
     call crlf

     lea edx, playP2
     call WriteString
     call crlf

     call ReadChar
     cmp al, '1'
     je compGame
     cmp al, '2'
     je P2game
     lea edx, incorrectPrompt
     jmp game_select
    
    compGame:
         mov ecx, 20   ;idk how to create an infinite while loop
         L:
            call printBoard
            call updateBoardPlayer
            call cpu_turn
            call checkDraw
         Loop L
    
    P2game:
       mov ecx, 20   ;idk how to create an infinite while loop
         LP:
            call printBoard
            call updateBoardPlayer
            call updateBoardPlayer2
            call checkDraw
         Loop LP

  game_definitely_over::   ;when the game is definitely over
exit
main ENDP



printBoard PROC uses eax ebx ecx edx  ;prints the board
  call Clrscr
  mov esi, OFFSET board
  mov ecx, 3
  L:

    push ecx    ;printing logic 
    mov ecx, 3

    L2:
      mov eax, [esi]
      call WriteChar
      add esi, 1
      Loop L2
    pop ecx
    call crlf
    Loop L
  ret
 printBoard ENDP

 updateBoardPlayer PROC uses eax ebx ecx edx
    ;updates values as per player instruction
    proc_start:
    lea edx, promptPlayer1
    call WriteString
    call ReadInt

    ;out of bounds checks
    cmp eax, 1   
    jl incorrect_index

    cmp eax, 9
    jg incorrect_index
    jmp valid_index

    cmp board[eax - 1], 'X'
    je incorrect_index

    cmp board[eax - 1], 'O'
    je incorrect_index
    jmp valid_index

    incorrect_index:         ;for example player enters 10 or something (Player is dumb)
       lea edx, incorrectPrompt
       call WriteString
       call crlf             ;because we keep it CLEANN
       call crlf
       jmp proc_start 
    
    valid_index: 
      ;if all is well and good,we update obviously
      mov ecx, eax
      mov eax, OFFSET board   ;Changing index value
      add eax, ecx            ;jump to the index
      sub eax, 1              ;sub 1 because that's how arrays work

      ;checking if the indices aren't already taken
      cmp BYTE PTR [eax], 'X'
      je incorrect_index

      cmp BYTE PTR [eax], 'O'
      je incorrect_index

      mov ebx, 'X'            ;move what to move
      mov [eax], bl           ;this done bruh
      call printBoard

      ;checking if it got the Player winnin'
      mov ebx, 0  ;basically our index number
      ;checking rows
      L:
        push ebx
        mov al, board[ebx]
        cmp al, 'X'
        jne L2
        
        add ebx, 1
        mov al, board[ebx]
        cmp al, 'X'
        jne L2

        add ebx, 1
        mov al, board[ebx]
        cmp al, 'X'
        jne L2
        jmp playerWin

        L2:   ;for switching rows
          pop ebx
          add ebx, 3
          cmp ebx, 9  ;check if it has checked all the rows
          jl L
     
     ;checking columns
     mov ebx, 0
     L3:
        push ebx
        mov al, board[ebx]
        cmp al, 'X'
        jne L4
        
        add ebx, 3
        mov al, board[ebx]
        cmp al, 'X'
        jne L4

        add ebx, 3
        mov al, board[ebx]
        cmp al, 'X'
        jne L4
        jmp playerWin

        L4:  ;for switching columns
          pop ebx     ;reverts to start index, moves to next col(LOGIC)
          inc ebx
          cmp ebx, 3
          jl L3

     ;checking left-to-right diagonal 
     mov ebx, 0
     L5:
       mov al, board[ebx]
       cmp al, 'X'
       jne L6

       add ebx, 4
       mov al, board[ebx]
       cmp al, 'X'
       jne L6

       add ebx, 4
       mov al, board[ebx]
       cmp al, 'X'
       jne L6
       jmp playerWin

     
     L6:
       ;checking right-to-left diagonal
       mov ebx, 2
       L7:
          mov al, board[ebx]
          cmp al, 'X'
          jne L8

          add ebx, 2
          mov al, board[ebx]
          cmp al, 'X'
          jne L8

          add ebx, 2
          mov al, board[ebx]
          cmp al, 'X'
          jne L8
          jmp playerWin

    playerWin:
        lea edx, playerWins
        call WriteString
        call ExitProcess

     L8:
      ret
    updateBoardPlayer ENDP

updateBoardPlayer2 PROC
 ;updates values as per player instruction
    proc_start:
    lea edx, promptPlayer2
    call WriteString
    call ReadInt

    ;out of bounds checks
    cmp eax, 1   
    jl incorrect_index

    cmp eax, 9
    jg incorrect_index
    jmp valid_index

    cmp board[eax - 1], 'X'
    je incorrect_index

    cmp board[eax - 1], 'O'
    je incorrect_index
    jmp valid_index

    incorrect_index:         ;for example player enters 10 or something (Player is dumb)
       lea edx, incorrectPrompt
       call WriteString
       call crlf             ;because we keep it CLEANN
       call crlf
       jmp proc_start 
    
    valid_index: 
      ;if all is well and good,we update obviously
      mov ecx, eax
      mov eax, OFFSET board   ;Changing index value
      add eax, ecx            ;jump to the index
      sub eax, 1              ;sub 1 because that's how arrays work

      ;checking if the indices aren't already taken
      cmp BYTE PTR [eax], 'X'
      je incorrect_index

      cmp BYTE PTR [eax], 'O'
      je incorrect_index

      mov ebx, 'O'            ;move what to move
      mov [eax], bl           ;this done bruh
      call printBoard
      call check_cpu_win      ;re-using because no need to 
      ret
updateBoardPlayer2 ENDP

check_cpu_win PROC uses ebx edx
    mov ebx, 0  ;basically our index number
      ;checking rows
      L:
        push ebx
        mov al, board[ebx]
        cmp al, 'O'
        jne L2
        
        add ebx, 1
        mov al, board[ebx]
        cmp al, 'O'
        jne L2

        add ebx, 1
        mov al, board[ebx]
        cmp al, 'O'
        jne L2
        jmp compWin

        L2:   ;for switching rows
          pop ebx
          add ebx, 3
          cmp ebx, 9  ;check if it has checked all the rows
          jl L
     
     ;checking columns
     mov ebx, 0
     L3:
        push ebx
        mov al, board[ebx]
        cmp al, 'O'
        jne L4
        
        add ebx, 3
        mov al, board[ebx]
        cmp al, 'O'
        jne L4

        add ebx, 3
        mov al, board[ebx]
        cmp al, 'O'
        jne L4
        jmp compWin

        L4:  ;for switching columns
          pop ebx     ;reverts to start index, moves to next col(LOGIC)
          inc ebx
          cmp ebx, 3
          jl L3

     ;checking left-to-right diagonal 
     mov ebx, 0
     L5:
       mov al, board[ebx]
       cmp al, 'O'
       jne L6

       add ebx, 4
       mov al, board[ebx]
       cmp al, 'O'
       jne L6

       add ebx, 4
       mov al, board[ebx]
       cmp al, 'O'
       jne L6
       jmp compWin

     
     L6:
       ;checking right-to-left diagonal
       mov ebx, 2
       L7:
          mov al, board[ebx]
          cmp al, 'O'
          jne L8

          add ebx, 2
          mov al, board[ebx]
          cmp al, 'O'
          jne L8

          add ebx, 2
          mov al, board[ebx]
          cmp al, 'O'
          jne L8
          jmp compWin

    compWin:
        lea edx, compWins
        call WriteString
        call exitProcess

    L8:
ret
check_cpu_win ENDP


cpu_turn PROC   ;non-AI based version
    L:
      call Randomize
      mov eax, 9
      call RandomRange
      call Randomize
      cmp board[eax], 'X'
      je L

      cmp board[eax], 'O'
      je L

      mov ecx, eax
      mov eax, OFFSET board   ;Changing index value
      add eax, ecx            ;jump to the index

      mov ebx, 'O'
      mov [eax], bl

      call printBoard
      call check_cpu_win
ret
cpu_turn ENDP

checkDraw PROC USES ebx
;the way the logic works is that simply doesn't check for patterns
;just that the board is full
  mov ebx, 0
  mov al, board[ebx]

  cmp al, '1'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '2'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '3'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '4'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '5'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '6'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '7'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '8'
  jne L
  inc ebx

  mov al, board[ebx]
  cmp al, '9'
  jne L

  lea edx, drawMessage
  call WriteString

   L:    
ret
checkDraw ENDP

END main