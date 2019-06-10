;Hussein Mohamed Hesham Hosny 1141308
;Mohamed Nour el Din Ibrahim 1142034
;Mohamed Osama Hussein 1142032
;Youssra Hussein Ibrahim 1142072


;When the welcome screen appears press any key


;=================================================================DRAWREC========================================================================================
Drawrec     MACRO   x,y,a,b,c  ;betala3 a=width of rectangle, b=height of rectangle, c=color
            local loop1
            local loop2
       
            mov cx,x
            loop1: mov dx,y
                loop2: 
                    mov al,c
                    mov ah,0ch
                    int 10h
                    inc dx
                    mov bx,b
                    inc bx  
                    cmp dx,bx
                jnz loop2      
            inc cx
            mov bx,a
            inc bx
            cmp cx,bx
            jnz loop1
            
ENDM Drawrec  

;=================================================================DRAWHORIZ======================================================================================       
Drawhoriz   MACRO   x1,x2,y,c 
            local loop1
            
            mov dx,y
            mov cx,x1
            mov si,x2
            inc si
            loop1:
                mov al,c
                mov ah,0ch
                int 10h
                inc cx
                cmp cx,si
            jnz loop1
        
ENDM    Drawhoriz
       
;=================================================================DRAWVER======================================================================================       
Drawver     MACRO   y1,y2,x,c 
            local loop1
            mov cx,x
            mov dx,y1
            mov si,y2
            inc si
            loop1:
                mov al,c
                mov ah,0ch
                int 10h
                inc dx
                cmp si,dx
            jnz loop1
        
ENDM    Drawver
  
;=================================================================SETDIRECTION====================================================================================
setdirection macro d,d2
local check
local endd
local up
local down
local left
local right
local up2
local down2
local left2
local right2
check: mov ah,1
int 16h
jz endd
mov ah,0
int 16h
up: cmp ah,72
    jne down
    mov d2,0
    jmp endd

down: cmp ah,80
    jne left
    mov d2,2
    jmp endd

left: cmp ah,75
    jne right
    mov d2,3
    jmp endd

right: cmp ah,77
    jne up2
    mov d2,1
    jmp endd
    
    
up2: cmp al,'w'
    jne down2
    mov d,0
    jmp endd

down2: cmp al,'s'
    jne left2
    mov d,2
    jmp endd

left2: cmp al,'a'
    jne right2
    mov d,3
    jmp endd

right2: cmp al,'d'
    jne esca
    mov d,1
    jmp endd
esca: cmp al,27
    jne endd
    
    mov d,4
    mov d2,4
endd:
endm setdirection 
;=================================================================DRAWRIVAL=======================================================================================
DrawRival MACRO x_center,y_center,rad,colour,dir ,mouth,x_value,y_value,decision,extra         ;up down left right    0 close  1 open
    local start
    local drawcircle
    local sover
    local endd
    local condition1
    local condition2
    local DRight1
    local DLeft1
    local DUp1
    local DDown1
    local DDone1
    local openmouth
    local closemouth

    start:
        mov bx, x_value
        sub decision, bx

    drawcircle:
        mov al,colour
        mov ah,0ch

        ;;;;;;;;;;;;;;;;;;Right 3
        cmp mouth,00
        je DRight1
        cmp dir,1
        je DUp1

        DRight1:
            mov cx, x_value ;Octonant 1
            add cx, x_center ;( x_value + x_center,  y_value + y_center)
            mov dx, y_value;;;;;;;;;;;
            add dx, y_center;;;;;;;;;;;;;
            int 10h

            mov cx, x_value ;Octonant 8
            add cx, x_center ;( x_value + x_center,  -y_value + y_center)
            mov dx, y_value
            neg dx
            add dx, y_center
            int 10h
            
        ;;;;;;;;;;;;;;;;;;Up 0
        cmp mouth,0
        je DUp1
        cmp dir,0
        je DLeft1

        DUp1:
            mov cx, y_value ;Octonant 7
            add cx, x_center ;( y_value + x_center,  -x_value + y_center)
            mov dx, x_value
            neg dx
            add dx, y_center
            int 10h

            mov cx, y_value ;Octonant 6
            neg cx
            add cx, x_center ;( -y_value + x_center,  -x_value + y_center)
            int 10h
            mov dx, x_value
            neg dx
            add dx, y_center
            
        ;;;;;;;;;;;;;;;;;;Left 2
        cmp mouth,0
        je DLeft1
        cmp dir,3
        je DDown1

        DLeft1:
            mov cx, x_value ;Octonant 4
            neg cx
            add cx, x_center ;( -x_value + x_center,  y_value + y_center)
            mov dx, y_value;;;;;;;;;;;;;;;;;
            add dx, y_center;;;;;;;;;;;;;;;;
            int 10h

            mov cx, x_value ;Octonant 5
            neg cx
            add cx, x_center ;( -x_value + x_center,  -y_value + y_center)
            mov dx, y_value
            neg dx
            add dx, y_center
            int 10h
            
        ;;;;;;;;;;;;;;;;;;Down 1
        cmp mouth,00
        je DDown1
        cmp dir,2
        je DDone1

        DDown1:
            mov cx, y_value ;Octonant 2
            add cx, x_center ;( y_value + x_center,  x_value + y_center)
            mov dx, x_value
            add dx, y_center
            int 10h

            mov cx, y_value ;Octonant 3
            neg cx
            add cx, x_center ;( -y_value + x_center,  x_value + y_center)
            mov dx, x_value;;;;;;;;;;;;;;
            add dx, y_center;;;;;;;;;;;;;;;;
            int 10h

        ;;;;;;;;;;;;;;;;;;DDone1
        DDone1:
            inc y_value
            
    ;;;;;;;;;;;;;;;;;;
    condition1:
        cmp decision,0
        jg condition2
        mov cx, y_value
        mov ax, 2
        imul cx
        add cx, 1
        inc cx
        add decision, cx
        mov bx, y_value
        mov dx, x_value
        cmp bx, dx
        jg sover
        jmp drawcircle

    ;;;;;;;;;;;;;;;;;;
    condition2:
        dec x_value
        mov cx, y_value
        sub cx, x_value
        mov ax, 2
        imul cx
        inc cx
        add decision, cx
        mov bx, y_value
        mov dx, x_value
        cmp bx, dx
        jg sover
        jmp drawcircle

    ;;;;;;;;;;;;;;;;;;      
    sover:
        mov ax,rad
        dec ax
        mov rad,ax
        cmp rad,00
        jl endd
        mov x_value ,ax
        mov ax,00
        mov y_value,ax
        mov ax,1 
        mov decision,ax
        jmp start
        
    ;;;;;;;;;;;;;;;;;;
    endd:
        mov ax,extra
        mov rad,ax 
        mov x_value,ax
        mov ax,00
        mov y_value,ax
        mov ax,1 
        mov decision,ax
        cmp mouth,0 
        je openmouth
        mov mouth,0 
        jmp closemouth
        openmouth:
        mov mouth,1 
    closemouth:

ENDM DrawRival

;================================================================CLEARRIVAL=======================================================================================
ClearRival  MACRO   x1,y1,x_center ,y_center,rad,x_value,y_value,extra,circ_colour,decision,radr1

            ;Initializing circle variables to draw a black circle over rival
            mov al,0
            mov circ_colour,al
            mov ax,x1
            mov bx,y1
            mov x_center,ax
            mov y_center,bx
            mov ax,radr1 
            mov rad,ax
            mov extra,ax
            mov x_value,ax
            mov ax,0
            mov y_value,ax
            mov ax,1
            mov decision,ax
            ;;;;;;;;;;;;;;;;;;;
            
            call DrawCircle             
        
ENDM ClearRival

;================================================================WRITESCORES=======================================================================================
WriteScores MACRO   score1,score2,remf



        ;;16 17 18
        
        mov dl,18
        mov dh,18
        mov ah,2
        int 10h
        
        
        mov ax,score1
        mov dl,10d
        div dl
        add ah,48d
        
        mov dl,ah
        ;mov al,ah
        mov ah,0
        push ax
        
        mov ah,2 
        int 21h
        
        mov dl,17
        mov dh,18
        mov ah,2
        int 10h
        
        pop ax
        
        mov dl,10d
        div dl
        add ah,48d
        
        mov dl,ah
        ;mov al,ah
        mov ah,0
        push ax
        
        mov ah,2 
        int 21h
        
        
        mov dl,16
        mov dh,18
        mov ah,2
        int 10h
        
        pop ax
        
        mov dl,10d
        div dl
        add ah,48d
        
        mov dl,ah
        ;mov al,ah
        ;mov ah,0
        
        mov ah,2 
        int 21h

        ;;;;;;;;;;;;;;;;;;;;
        mov dl,38
        mov dh,18
        mov ah,2
        int 10h
        
        
        mov ax,score2
        mov dl,10d
        div dl
        add ah,48d
        
        mov dl,ah
        ;mov al,ah
        mov ah,0
        push ax
        
        mov ah,2 
        int 21h
        
        mov dl,37
        mov dh,18
        mov ah,2
        int 10h
        
        pop ax
        
        mov dl,10d
        div dl
        add ah,48d
        
        mov dl,ah
        ;mov al,ah
        mov ah,0
        push ax
        
        mov ah,2 
        int 21h
        
        
        mov dl,36
        mov dh,18
        mov ah,2
        int 10h
        
        pop ax
        
        mov dl,10d
        div dl
        add ah,48d
        
        mov dl,ah
        ;mov al,ah
        ;mov ah,0
        
        mov ah,2 
        int 21h
        
        ;;;;;;;;;;;;;;;;;;;;
        mov dl,38
        mov dh,19
        mov ah,2
        int 10h
        
        
        ; mov ax,remf
        ; mov dl,10d
        ; div dl
        ; add ah,48d
        
        ; mov dl,ah

        ; mov ah,0
        ; push ax
        
        ; mov ah,2 
        ; int 21h
        
        ; mov dl,37
        ; mov dh,19
        ; mov ah,2
        ; int 10h
        
        ; pop ax
        
        ; mov dl,10d
        ; div dl
        ; add ah,48d
        
        ; mov dl,ah

        ; mov ah,0
        ; push ax
        
        ; mov ah,2 
        ; int 21h
        
        
        ; mov dl,36
        ; mov dh,19
        ; mov ah,2
        ; int 10h
        
        ; pop ax
        
        ; mov dl,10d
        ; div dl
        ; add ah,48d
        
        ; mov dl,ah

        
        ; mov ah,2 
        ; int 21h
                
        
ENDM WriteScores

;======================================================================MOVE======================================================================================
Move    MACRO   x1,y1,dr11,foodcolour,supercoincolour,rival2colour,beastcolour,score1,status1,status2,xe1,ye1,score2,x1init,y1init,x2init,y2init,lives1,lives2,x2,y2,remf
        local   up
        local   down
        local   right
        local   left
        local   check1
        local   check2
        local   foodl
        local   scoinl
        local   beastl
        local   killother
        local   otherisbeast
        local   endd
        local   endd2
        local   norm
        local   enddir2
        local   over

        up: 
        cmp     dr11,0
        jne     down
        mov     di,y1
        sub     di,10
        mov     ax,x1
        mov     bx,di 
        mov     xe1,ax
        mov     ye1,bx
        jmp     check1
        
        ;;;;;;;;        
        down: 
        cmp     dr11,2
        jne     right
        mov     di,y1
        add     di,10
        mov     ax,x1
        mov     bx,di 
        mov     xe1,ax
        mov     ye1,bx
        jmp     check1
        
        ;;;;;;;;
        right: 
        cmp     dr11,1
        jne     left
        mov     di,x1
        add     di,10
        mov     ax,di
        mov     bx,y1
        mov     xe1,ax
        mov     ye1,bx
        jmp     check1
        
        ;;;;;;;;
        left: 
        cmp     dr11,3
        jne     over 
        mov     di,x1
        sub     di,10
        mov     ax,di
        mov     bx,y1
        mov     xe1,ax
        mov     ye1,bx
        jmp     check1
        
        ;;;;;;;;
        over: 
        cmp     dr11,4
        jne     check1 
        mov     ax,x1
        mov     bx,y1
        mov     xe1,ax
        mov     ye1,bx
        jmp     enddir2
        
        check1:
        cmp     xe1,325
        jne     check2
        sub     xe1,320
        jmp     enddir2
        check2:
        mov     ax,5
        sub     ax,10 
        cmp     ax,xe1
        jne     enddir2
        mov     ax,315d
        mov     xe1,ax
        
        
        ;;;;;;;;;;;;;;;;;;;
        enddir2:
        
        mov     ah,0dh
        mov     bh,0
        mov     cx,xe1
        mov     dx,ye1
        int     10h
        cmp     al,foodcolour
        je      foodl
        cmp     al,supercoincolour
        je      scoinl
        cmp     al,rival2colour
        je      beastl
        cmp     al,beastcolour
        je      beastl
        cmp     al,0
        je      endd
        jmp     endd2
        
        foodl:
        inc     score1
        dec     remf
        jmp     endd
        
        scoinl:
        cmp     status2,1
        je  norm 
        mov     status1,1
        jmp     endd
        
                norm:
                mov     status2,0
                jmp     endd
        
        beastl:
        cmp     status1,1
        jne     otherisbeast
        killother:
        dec     lives2
        mov     ax,x2init
        mov     bx,y2init
        mov     x2,ax
        mov     y2,bx
        mov     ax,0
        mov     score2,ax
        mov     status1,0
        jmp     endd
        
                otherisbeast:
                cmp     status2,1
                jne     endd
                dec     lives1
                mov     ax,x1init
                mov     bx,y1init
                mov     x1,ax
                mov     y1,bx
                mov     xe1,ax
                mov     ye1,bx
                mov     status2,0
                mov     ax,0
                mov     score1,ax
                jmp     endd2
                
        endd:
        mov     ax,xe1
        mov     bx,ye1
        mov     x1,ax
        mov     y1,bx
        
        
        endd2:




ENDM Move
;===============================================================ENDOFMACROS======================================================================================

 
 
 .MODEL Small
.STACK 64

.DATA
 
    AStatus  db     0   ;Application Status     1->Ongoing      2->Player1 won      3->Player2 won
 
    mes1     db     'First player name: $'
    mes2     db     10,13,'Second player name: $'
    mes3     db     10,13,'Press any key to continue $'
    Entr     db     10,13, '$'
    name1    db     16,?,16 dup('$')
    name2    db     16,?,16 dup('$')
    mes4     db     10,13,'To start chatting press F1 $'
    mes5     db     10,13,'To start the Eating Warrior game press F2 $'
    mes6     db     10,13,'To end the program press ESC $' 
    
    INST1    db     '                               INSTRUCTIONS' ,'$'
    INST2    db     10,13,'1) You should eat as much food (White coins) as you can', '$'
    INST3    db     10,13,'2)If you eat the super coin (Red Coin) you turn into a beast','$'
    INST4    db     10,13,'3) The beast can eat his rival','$'
    INST5    db     10,13,'4)If you are eaten your score turns to zero again','$'
    INST6    db     10,13,'5)The game ends when the food ends and the player with the higher score wins','$'
    INST7    db     10,13,'6) Player1 is Yellow (play with W,A,S,D)','$'
    INST8    db     10,13, '7)Player2 is Green (Play with the 4 arrows)','$'
    INST9    db     10,13, '8)The beast color is Red', '$'
    INST10   db     10,13,'Press any key to continue','$'
    
    wonmsg   db     'WON!',' ',14,' ',15,'$'
    mesg        db  'To end game now press ESC','$'
    
    ;;;;;;;;;;;;;;;;;;;;;;
    ;COORDINATES
    
    ;W coordinates
    upx1    dw  25
    upy1    dw  22
    lox1    dw  35
    loy1    dw  122
 
    upx2    dw  35
    upy2    dw  102
    lox2    dw  95
    loy2    dw  122 

    upx3    dw  85
    upy3    dw  22
    lox3    dw  95
    loy3    dw  102
 
    upx4    dw  55
    upy4    dw  22
    lox4    dw  65
    loy4    dw  82 
    
    ;A coordinates
    upx5    dw  155
    upy5    dw  62
    lox5    dw  175
    loy5    dw  82 

    upx6    dw  155
    upy6    dw  102
    lox6    dw  175
    loy6    dw  141 
    
    ax1     dw  115
    ax2     dw  215
    ya1     dw  22
    ya2     dw  122  

    ax3     dw  135
    ax4     dw  195
    ya3     dw  42
    ya4     dw  122 

    ;R coordinates
    ax5     dw  235
    ax6     dw  285
    
    ya5     dw  22
    ya6     dw  122
    
    ya7     dw  72
    ax7     dw  255
    
    ya8     dw  82
    ax8     dw  255
    
    ax9     dw  265
    ya9     dw  102
    
    ya10    dw  122

    fx      dw  0
    fy      dw  0

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;COLOURS
    
    rival1colour    db  2Ch
    rival2colour    db  2Eh
    beastcolour     db  27h;68h;5Dh
    foodcolour      db  1fh
    supercoincolour db  0Ch
    
    ;BORDER AND MAZE COLOURS 
    c1  db  0fh
    c2  db  34h
    c3  db  37h;2Dh;28h
    c4  db  44h
    c5  db  0Dh
    c6  db  0Ah 
    c7  db  2Ch
    c8  db  2Eh
    c9  db  27h
    c10 db  0Ch 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;RIVALS INFORMATION
    ;scoretodie dw  500d

    ;RIVAL_1
    x1      dw  145d
    y1      dw  132d
    dr11    db  3  
    dr21    db  3 ;Left=2
    xval1   dw  7 
    yval1   dw  0 
    radr1   dw  7
    extra1  dw  7   ;carries rad 
    dec1    dw  1   ;always beginning at 1 
    mouth1  db  1 
    score1  dw  0
    lives1  db  3 
    status1 db  0   ;0--->Normal   1--->Beast
    x1init  dw  145d
    y1init  dw  132d
    ye1     dw  0
    xe1     dw  0
    curcol1 db  2Ch 
    r1name  db  'Player1        '
    
    ;RIVAL_2
    x2      dw  185d
    y2      dw  132d
    dr12    db  1
    dr22    db  1 
    xval2   dw  7 
    yval2   dw  0 
    radr2   dw  7
    extra2  dw  7   ;carries rad 
    dec2    dw  1   ;always beginning at 1 
    mouth2  db  0 
    score2  dw  0
    lives2  db  3 
    status2 db  0   ;0--->Normal   1--->Beast
    x2init  dw  185d
    y2init  dw  132d
    ye2     dw  0
    xe2     dw  0
    curcol2 db  2Eh
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Clear variables
    clx1    dw  0
    cly1    dw  0
    clx2    dw  0
    cly2    dw  0
    clxc1   dw  0
    clyc1   dw  0
    clxc2   dw  0
    clyc2   dw  0
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;DrawCircle variables
    x_center    dw  145d
    y_center    dw  132d
    x_value     dw  3
    y_value     dw  0 
    rad         dw  3
    extra       dw  3   ;carries rad
    decision    dw  1
    circ_colour db  4   
    
    ;DrawFood variables
    endxf   dw  315 
    endyf   dw  142 
    fcount  dw  0;;;193;;C1
    radf    dw  2
    remf    dw  0   ;remaining food
    
    ;SuperCoin Positions
    scoinx1 dw  295
    scoiny1 dw  92  
    scoinx2 dw  275
    scoiny2 dw  32
    scoinx3 dw  45  
    scoiny3 dw  92 
    
    
    ;Border Running variables
    bbx1        dw  10
    bby1        dw  10
    bbx2        dw  310
    bby2        dw  10
    bbx3        dw  310
    bby3        dw  190
    bbx4        dw  10
    bby4        dw  190
    
    atbor   db  0
              
.CODE

MAIN        PROC FAR
        MOV AX,@data
        mov DS,AX
        
        call WelcomeScreen  ;Draws "THE EATING WARRIOR" as a welcome screen
        
        ;Wait for a key press to view the firstscreen
        mov ah,0
        int 16h
        
        call FirstScreen
        
        ;wait for a key press to view the main menu
        mov ah,0
        int 16h 
       
        call MainMenu
        
        ;Scan code of F1=59, F2=60, ESC=1  ; wait for the user to enter his choice 
        mov ah,0   ; AH:scancode,AL:ASCII
        int 16h 
        
        cmp ah,59   ; if the user entered F1 Chatting should start
        jz Chatting
        
        cmp ah,1  ; if the user entered ESC the program should end
        jz Escape
        
        call InstructionScreen
        
        mov ah,0  
        int 16h 
        
        call InitializeGameScreen
        
        
        loop8: 
        
            
            call PlayRound
            
            mov ax,remf
            mov bx,0
            cmp ax,0
            jne ongoing
            
            mov ax,score1
            mov bx,score2
            cmp ax,bx
            jg  player1won
            mov ah,3
            jmp GameOver
            
            player1won:
            mov ah,2
            
            GameOver:
            mov AStatus,ah
            jmp enddmain
            
           
            ongoing:
            
            mov al,dr11
            cmp al,4
            je enddmain
            
            mov al,dr12
            cmp al,4
            je enddmain  
            
            mov cx,10000  ;delay 3500h,10
            loop9: 
                mov si,10
                loop10: 
                dec si
                jnz loop10
                dec cx
                jnz loop9 
            jmp loop8 
            
            
            
            
            
            
            
        enddmain:
            call CheckWinner
        Chatting:
            jmp exit  ; in this phase there is no chatting therefore the game interface should not appear
         
        Escape:
            jmp exit  ; if ESC is pressed the program ends  
exit:           
 mov ah,00
 int 16h
 mov ah,04ch
 mov al,00 ;end program normally
 int 21h
 
 HLT
MAIN ENDP 



;===============================================================PROCEDURES======================================================================================

WelcomeScreen   proc near   ;This Procedure Draws "THE EATING WARRIOR" as a welcome screen

       ;clearscreen
        mov ah,0
        mov al,3
        int 10h
        
        ;video mode
        mov ah,0
        mov al,13h
        int 10h 

;DRAW THE 
        
;Draw T
Drawhoriz 80,120,23,c2
Drawver 23,65,100,c2

;Draw H
Drawver 23,65,130,c5
Drawver 23,65,170,c5
Drawhoriz 130,170,42,c5

;Draw E
Drawhoriz 180,220,23,c3
Drawhoriz 180,220,42,c3
Drawhoriz 180,220,65,c3 
Drawver 23,65,180,c3

;Draw EATING 

;Draw E
Drawhoriz 40,70,75,c1
Drawhoriz 40,70,97,c1
Drawhoriz 40,70,120,c1
Drawver 75,120,40,c1  

;Draw A
Drawhoriz 80,110,75,c2
Drawhoriz 80,110,97,c2
Drawver 75,120,80,c2
Drawver 75,120,110,c2

;Draw T
Drawhoriz 120,150,75,c3
Drawver 75,120,135,c3

;Draw I
Drawhoriz 160,190,75,c4
Drawhoriz 160,190,120,c4
Drawver 75,120,175,c4

;Draw N
Drawver 75,120,200,c5
Drawver 75,120,220,c5
Drawver 75,120,240,c5
Drawhoriz 200,220,75,c5
Drawhoriz 220,240,120,c5  

;Draw G
Drawhoriz 250,290,75,c7
Drawhoriz 270,290,97,c7
Drawhoriz 250,290,120,c7
Drawver 75,120,250,c7
Drawver 97,120,290,c7

;Draw WARRIOR

;Draw W
Drawver 130,175,23,c2
Drawver 130,175,51,c2
Drawver 152,175,37,c2
Drawhoriz 23,51,175,c2 

;DrawA
Drawhoriz 60,90,130,c9
Drawhoriz 60,90,152,c9
Drawver 130,175,60,c9
Drawver 130,175,90,c9

;Draw R

Drawhoriz 100,130,130,c10
Drawver 130,175,100,c10
Drawver 130,150,130,c10
Drawver 155,175,130,c10
Drawhoriz 100,110,175,c10
Drawhoriz 115,130,175,c10


Drawver 135,145,110,c10
Drawver 135,145,115,c10
Drawhoriz 110,115,135,c10
Drawhoriz 110,115,145,c10

Drawhoriz 110,130,150,c10
Drawhoriz 110,130,155,c10
Drawver 150,155,110,c10

Drawver 160,175,110,c10
Drawver 160,175,115,c10
Drawhoriz 110,115,160,c10


;Draw R

Drawhoriz 140,170,130,c3
Drawver 130,175,140,c3
Drawver 130,150,170,c3 
Drawver 155,175,170,c3
Drawhoriz 140,150,175,c3
Drawhoriz 155,170,175,c3

Drawver 135,145,150,c3
Drawver 135,145,155,c3
Drawhoriz 150,155,135,c3
Drawhoriz 150,155,145,c3

Drawhoriz 150,170,150,c3
Drawhoriz 150,170,155,c3
Drawver 150,155,150,c3

Drawver 160,175,150,c3
Drawver 160,175,155,c3
Drawhoriz 150,155,160,c3
;Draw I
Drawhoriz 180,210,130,c5
Drawhoriz 180,210,175,c5
DrawVer 130,175,195,c5

;Draw O
Drawhoriz 220,250,130,c2
Drawhoriz 220,250,175,c2
Drawver 130,175,220,c2
Drawver 130,175,250,c2

;Draw R
Drawhoriz 260,290,130,c9
Drawver 130,175,260,c9
Drawver 130,150,290,c9 
Drawver 155,175,290,c9
Drawhoriz 260,270,175,c9
Drawhoriz 275,290,175,c9

Drawver 135,145,270,c9
Drawver 135,145,275,c9
Drawhoriz 270,275,135,c9
Drawhoriz 270,275,145,c9

Drawhoriz 270,290,150,c9
Drawhoriz 270,290,155,c9
Drawver 150,155,270,c9

Drawver 160,175,270,c9
Drawver 160,175,275,c9
Drawhoriz 270,275,160,c9

;DrawBorder
; Drawhoriz 0,319,0,c6
; Drawhoriz 0,319,199,c6
; Drawver 0,199,0,c6
; Drawver 0,199,319,c6


; Drawhoriz 19,299,19,c6
; Drawhoriz 19,299,179,c6
; Drawver 19,179,19,c6
; Drawver 19,179,299,c6 




            mov ax,10
            mov bx,10
            mov cx,310
            mov dx,190
            mov x1,ax
            mov y1,bx
            mov x2,cx
            mov y2,dx
            mov al,1
            mov bl,3
            mov dr21,al
            mov dr11,al
            mov dr22,bl
            mov dr12,bl
            mov al,rival1colour
            mov curcol1,al
            mov al,rival2colour
            mov curcol2,al


            loop81:
            mov ax,x1
            mov bx,y1
            mov cx,x2
            mov dx,y2
            mov clxc1,ax
            mov clyc1,bx
            mov clxc2,cx
            mov clyc2,dx
            
            
            Move x1,y1,dr21,foodcolour,supercoincolour,rival2colour,beastcolour,score1,status1,status2,xe1,ye1,score2,x1init,y1init,x2init,y2init,lives1,lives2,x2,y2,remf
            
            ;mov    ah,0    ;1->expected coordinates = actual coordinates       0->Not equal
            mov     cx,x1
            mov     dx,y1
            
            cmp     cx,bbx1
            jne     bcheck11
            cmp     dx,bby1
            jne     bcheck11
            mov al,1
            mov atbor,al
                        jmp     endcmpeq1e

                        
            bcheck11:
            cmp     cx,bbx2
            jne     bcheck21
            cmp     dx,bby2
            jne     bcheck21
            mov al,1
            mov atbor,al
            jmp     endcmpeq1e
            
            bcheck21:

            cmp     cx,bbx3
            jne     bcheck31
            cmp     dx,bby3
            jne     bcheck31
            mov al,1
            mov atbor,al
            jmp     endcmpeq1e
            
            bcheck31:
            
            cmp     cx,bbx4
            jne     endcmpeq1e
            cmp     dx,bby4
            jne     endcmpeq1e
            mov al,1
            mov atbor,al

            
            
        

        
            endcmpeq1e:
            mov al,atbor
            cmp al,0
            jne     invaliddir1e
            
            validdir1e:
            mov     bl,dr21
            mov     dr11,bl 
            jmp     endmov1e
            
            invaliddir1e:
            inc dr21
            mov al,dr21
            cmp al,3
            jg  subdir
            jmp esubdir
            
                subdir:
                mov cl,4
                sub al,cl
                mov dr21,al
                esubdir:
                
                ; Move  x1,y1,dr21,foodcolour,supercoincolour,rival2colour,beastcolour,score1,status1,status2,xe1,ye1,score2,x1init,y1init,x2init,y2init,lives1,lives2,x2,y2,remf
                
            endmov1e:

                
            ClearRival  clxc1,clyc1,x_center ,y_center,rad,x_value,y_value,extra,circ_colour,decision,radr1

            DrawRival   x1,y1,radr1,curcol1,dr21,mouth1,xval1,yval1,dec1,extra1
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            
            Move x2,y2,dr22,foodcolour,supercoincolour,rival1colour,beastcolour,score2,status2,status1,xe2,ye2,score1,x2init,y2init,x1init,y1init,lives2,lives1,x1,y1,remf
            
                        mov     cx,x2
            mov     dx,y2
            
            cmp     cx,bbx1
            jne     bcheck12
            cmp     dx,bby1
            jne     bcheck12
            mov al,1
            mov atbor,al
                        jmp     endcmpeq2e

                        
            bcheck12:
            cmp     cx,bbx2
            jne     bcheck22
            cmp     dx,bby2
            jne     bcheck22
            mov al,1
            mov atbor,al
            jmp     endcmpeq2e
            
            bcheck22:

            cmp     cx,bbx3
            jne     bcheck32
            cmp     dx,bby3
            jne     bcheck32
            mov al,1
            mov atbor,al
            jmp     endcmpeq2e
            
            bcheck32:
            
            cmp     cx,bbx4
            jne     endcmpeq2e
            cmp     dx,bby4
            jne     endcmpeq2e
            mov al,1
            mov atbor,al

            
            
        
            endcmpeq2e:
            mov al,atbor
            cmp al,0
            jne invaliddir2e
            
            validdir2e:
            mov     bl,dr22
            mov     dr12,bl 
            jmp     endmov2e
            
            invaliddir2e:
            
            mov al,0
            mov atbor,al
            mov al,dr22
            inc al
            ; mov al,dr22
            cmp al,3
            jg  subdir2
            mov dr22,al
            jmp esubdir2
            
                subdir2:
                mov cl,4
                ;mov al,dr22;;;
                sub al,cl
                mov dr22,al
                esubdir2:
                

            ; Move x2,y2,dr22,foodcolour,supercoincolour,rival1colour,beastcolour,score2,status2,status1,xe2,ye2,score1,x2init,y2init,x1init,y1init,lives2,lives1,x1,y1,remf
            
            endmov2e:
            ClearRival  clxc2,clyc2,x_center ,y_center,rad,x_value,y_value,extra,circ_colour,decision,radr2
            DrawRival   x2,y2,radr2,curcol2,dr22,mouth2,xval2,yval2,dec2,extra2

            
            
            
            mov ah,1
            int 16h
            jnz enddy   
            
            
            mov cx,10000;03500h  ;delay
            loop91: 
                mov si,10
                loop101: 
                dec si
                jnz loop101
                dec cx
                jnz loop91 
            jmp loop81

                enddy:
                            mov ah,0
            int 16h     

ret
WelcomeScreen endp

;=====================================================================================================================================================
FirstScreen PROC NEAR
       
       ;clearscreen
        mov ah,0
        mov al,3
        int 10h
        
        ;text mode
        mov ah,0
        mov al,03h
        int 10h 
        
        ;move the cursor to the middle of the screen and start displaying the message
        mov ah,2
        mov dl,0
        mov dh,12
        int 10h
        
        mov ah,9
        mov dx,offset mes1
        int 21h
        
        mov ah,0Ah
        mov dx,offset name1
        int 21h
        
        mov ah,9
        mov dx,offset mes2
        int 21h
        
        mov ah,0Ah
        mov dx,offset name2
        int 21h
        
        mov ah,9
        mov dx,offset mes3
        int 21h
ret     
FirstScreen ENDP
;=====================================================================================================================================================

MainMenu PROC NEAR

       ;clearscreen
        mov ah,0
        mov al,3
        int 10h
        
       ;text mode
        mov ah,0
        mov al,03h
        int 10h 
        
        ;move the cursor to the middle of the screen and start displaying the message
        mov ah,2
        mov dl,0
        mov dh,12
        int 10h
        
        mov ah,9
        mov dx,offset mes4
        int 21h           
        
        mov ah,9
        mov dx,offset mes5
        int 21h  
        
        mov ah,9
        mov dx,offset mes6
        int 21h
ret
MainMenu ENDP       
;=====================================================================================================================================================
InstructionScreen PROC NEAR

       ;clearscreen
        mov ah,0
        mov al,3
        int 10h 

        ;text mode
        mov ah,0
        mov al,03h
        int 10h
        
        ;move the cursor to the middle of the screen and start displaying the instructions
        mov ah,2
        mov dl,0
        mov dh,0
        int 10h
        
        mov ah,9
        mov dx, offset INST1
        int 21h
        
        mov ah,9
        mov dx, offset INST2
        int 21h
        
        mov ah,9
        mov dx, offset INST3
        int 21h
        
        mov ah,9
        mov dx, offset INST4
        int 21h
        
        mov ah,9
        mov dx, offset INST5
        int 21h
        
        mov ah,9
        mov dx, offset INST6
        int 21h
        
        mov ah,9
        mov dx, offset INST7
        int 21h
        
        mov ah,9
        mov dx, offset INST8
        int 21h
        
        mov ah,9
        mov dx, offset INST9
        int 21h
        
        mov ah,9
        mov dx, offset INST10
        int 21h
        
        
ret
InstructionScreen ENDP
;=====================================================================================================================================================

InitializeGameScreen    PROC    NEAR

            mov ax,145
            mov bx,132
            mov cx,185
            mov dx,132
            mov x1,ax
            mov y1,bx
            mov x2,cx
            mov y2,dx
            mov al,3
            mov bl,1
            mov dr21,al
            mov dr11,al
            mov dr22,bl
            mov dr12,bl
            mov al,rival1colour
            mov curcol1,al
            mov al,rival2colour
            mov curcol2,al
            
            
            
;clearscreen
        mov ah,0
        mov al,3
        int 10h 

        ;video mode
        mov ah,0
        mov al,13h
        int 10h 

;;;;0->16 the game  17->24 chat and info
        call DrawMaze
        call DrawFood
        
        mov ax,3
        mov x_value,ax
        mov rad,ax
        mov extra,ax
        mov ax,1
        mov decision,ax
        
        mov al,supercoincolour
        mov circ_colour,al
        
        mov ax,scoinx1
        mov bx,scoiny1
        mov x_center,ax
        mov y_center,bx
        
        call DrawCircle
        dec  fcount
        
        mov ax,scoinx2
        mov bx,scoiny2
        mov x_center,ax
        mov y_center,bx
        
        call DrawCircle
        dec  fcount
        
        mov ax,scoinx3
        mov bx,scoiny3
        mov x_center,ax
        mov y_center,bx
        
        call DrawCircle
        dec  fcount
        
        mov ax,fcount
        mov remf,ax
        
        ;Displaying the names
        mov ah,2
        mov dl,0
        mov dh,18
        int 10h
        
        mov ah,9
        mov dx,offset name1+2
        int 21h
        
        mov ah,2
        mov dl,20
        mov dh,18
        int 10h
        
        mov ah,9
        mov dx,offset name2+2
        int 21h
        
        ;;;;;;;;;;
        mov ah,2
        mov dl,0
        mov dh,23
        int 10h
        
        mov ah,9
        mov dx, offset mesg
        int 21h

RET
InitializeGameScreen    ENDP
;=====================================================================================================================================================
CheckWinner PROC    NEAR
            ;clearscreen
            mov ah,0
            mov al,3
            int 10h
            
            ;video mode
            mov ah,0
            mov al,13h
            int 10h 
            
            

            
            mov cl,AStatus
            cmp cl,2
            je WritePlayer1
            
            
            mov bx,offset name2+1
            mov al,DS:[bx]
            add al,4
            mov cl,40
            sub cl,al
            xchg cl,al
            mov cl,2
            mov ah,0
            div cl
            mov ah,0
            push ax
            mov dl,al
            
            mov ah,2
            ;mov dl,10
            mov dh,8
            int 10h
            
            
            mov ah,9
            mov dx,offset name2+2
            int 21h
            jmp WriteWon
            
            WritePlayer1:
            mov bx,offset name1+1
            mov al,DS:[bx]
            add al,4
            mov cl,40
            sub cl,al
            xchg cl,al
            mov cl,2
            mov ah,0
            div cl
            mov ah,0
            push ax
            mov dl,al
            
            mov ah,2
            ;mov dl,10
            mov dh,8
            int 10h
            
            
            
            mov ah,9
            mov dx,offset name1+2
            int 21h
            
            WriteWon:
            pop ax
            mov cl,37
            sub cl,al
            mov dl,cl
            
            
            mov ah,2
            ;mov dl,28
            mov dh,8
            int 10h
            
            
            mov ah,9
            mov dx,offset wonmsg
            int 21h


RET
CheckWinner ENDP
;=====================================================================================================================================================

PlayRound   PROC    NEAR

            mov ax,x1
            mov bx,y1
            mov cx,x2
            mov dx,y2
            mov clxc1,ax
            mov clyc1,bx
            mov clxc2,cx
            mov clyc2,dx
            
            
            setdirection dr21,dr22
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            Move x1,y1,dr21,foodcolour,supercoincolour,rival2colour,beastcolour,score1,status1,status2,xe1,ye1,score2,x1init,y1init,x2init,y2init,lives1,lives2,x2,y2,remf
            
            mov     ah,0    ;1->expected coordinates = actual coordinates       0->Not equal
            mov     cx,xe1
            mov     dx,ye1
            cmp     cx,x1
            jne     endcmpeq1
        
            cmp     dx,y1
            jne     endcmpeq1
            mov     ah,1
        
            endcmpeq1:
            cmp     ah,1
            jne     invaliddir1
            
            validdir1:
            mov     bl,dr21
            mov     dr11,bl 
            jmp     endmov1
            
            invaliddir1:
            Move    x1,y1,dr11,foodcolour,supercoincolour,rival2colour,beastcolour,score1,status1,status2,xe1,ye1,score2,x1init,y1init,x2init,y2init,lives1,lives2,x2,y2,remf
            
            endmov1:
            cmp status1,1
            jne notbeast1
            mov al,beastcolour
            mov curcol1,al
            jmp endbeast
            notbeast1:
            mov al,rival1colour
            mov curcol1,al
            
            
            endbeast:
                        ; Clrr  clxc1,clyc1,clx1,cly1,clx2,cly2
            ClearRival  clxc1,clyc1,x_center ,y_center,rad,x_value,y_value,extra,circ_colour,decision,radr1

            DrawRival   x1,y1,radr1,curcol1,dr11,mouth1,xval1,yval1,dec1,extra1
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            
            Move x2,y2,dr22,foodcolour,supercoincolour,rival1colour,beastcolour,score2,status2,status1,xe2,ye2,score1,x2init,y2init,x1init,y1init,lives2,lives1,x1,y1,remf
            
            mov     ah,0;1->exp=coordinates
            mov     cx,xe2
            mov     dx,ye2
            cmp     cx,x2
            jne     endcmpeq2
        
            cmp     dx,y2
            jne     endcmpeq2
            mov     ah,1
        
            endcmpeq2:
            cmp     ah,1
            jne     invaliddir2
            
            validdir2:
            mov     bl,dr22
            mov     dr12,bl 
            jmp     endmov2
            
            invaliddir2:
            Move x2,y2,dr12,foodcolour,supercoincolour,rival1colour,beastcolour,score2,status2,status1,xe2,ye2,score1,x2init,y2init,x1init,y1init,lives2,lives1,x1,y1,remf
            
            endmov2:
            
            cmp status2,1
            jne notbeast2
            mov al,beastcolour
            mov curcol2,al
            jmp endbeast2
            notbeast2:
            mov al,rival2colour
            mov curcol2,al
            endbeast2:
            
            ClearRival  clxc2,clyc2,x_center ,y_center,rad,x_value,y_value,extra,circ_colour,decision,radr2
            DrawRival   x2,y2,radr2,curcol2,dr12,mouth2,xval2,yval2,dec2,extra2
            WriteScores score1,score2,remf
            
            

RET
PlayRound   ENDP
;=====================================================================================================================================================

DrawCircle  proc   near
            
        startcs:
            mov bx, x_value
            sub decision, bx

        drawcircless:
            mov al,circ_colour ;colour goes in al
            mov ah,0ch

            ;Octonant 1
            mov cx, x_value
            add cx, x_center ;( x_value + x_center,  y_value + y_center)
            mov dx, y_value
            add dx, y_center
            int 10h

            ;Octonant 4
            mov cx, x_value 
            neg cx
            add cx, x_center ;( -x_value + x_center,  y_value + y_center)
            int 10h
            
            ;Octonant 2
            mov cx, y_value 
            add cx, x_center ;( y_value + x_center,  x_value + y_center)
            mov dx, x_value
            add dx, y_center
            int 10h
            
            ;Octonant 3
            mov cx, y_value 
            neg cx
            add cx, x_center ;( -y_value + x_center,  x_value + y_center)
            mov dx, x_value
            add dx, y_center
            int 10h

            ;Octonant 7
            mov cx, x_value 
            add cx, x_center ;( x_value + x_center,  -y_value + y_center)
            mov dx, y_value
            neg dx
            add dx, y_center
            int 10h

            ;Octonant 5
            mov cx, x_value
            neg cx
            add cx, x_center ;( -x_value + x_center,  -y_value + y_center)
            int 10h
            
            ;Octonant 8
            mov cx, y_value
            add cx, x_center ;( y_value + x_center,  -x_value + y_center)
            mov dx, x_value
            neg dx
            add dx, y_center
            int 10h

            ;Octonant 6
            mov cx, y_value 
            neg cx
            add cx, x_center ;( -y_value + x_center,  -x_value + y_center)
            int 10h

            ;;;;;;;;;;;;
            inc y_value

        condition1:
            cmp     decision,0
            jg      condition2
            mov     cx, y_value
            mov     ax, 2
            imul    cx
            add     cx, 1
            inc     cx
            add     decision, cx
            mov     bx, y_value
            mov     dx, x_value
            cmp     bx, dx
            jg      sover
            jmp     drawcircless

        condition2:
            dec     x_value
            mov     cx, y_value
            sub     cx, x_value
            mov     ax, 2
            imul    cx
            inc     cx
            add     decision, cx
            mov     bx, y_value
            mov     dx, x_value
            cmp     bx, dx
            jg      sover
            jmp     drawcircless

        sover:
            mov     ax,rad
            dec     ax
            mov     rad,ax
            cmp     rad,00
            jl      endd
            mov     x_value ,ax
            mov     ax,00
            mov     y_value,ax
            mov     ax,1 
            mov     decision,ax
            jmp     startcs

        endd:

            mov     ax,extra
            mov     rad,ax 
            mov     x_value,ax
            mov     ax,00
            mov     y_value,ax
            mov     ax,1 
            mov     decision,ax
ret
DrawCircle endp 
 ;=====================================================================================================================================================


DrawFood    proc near
    mov ah,foodcolour
    mov circ_colour,ah
    
    mov ax,radf
    mov rad,ax
    mov extra,ax
    mov x_value,ax
    
    
    mov fcount,0 
    mov x_center,5
    
    loop1f:
        mov y_center,2
        add x_center,10
        mov ax ,x_center
        cmp ax,endxf
        jge enddf
        loop2f:     
            add y_center,10
            mov ax, y_center
            cmp ax,endyf
            jge loop1f
            mov cx,x_center
            mov dx,y_center
            mov bh,0
            mov ah,0Dh 
            int 10h 
            cmp al,0 
            jne loop2f
            ; call DrawCircle   ;x_center ,y_center,rad,x_value,y_value,extra,colour,decision
            mov al,foodcolour
            mov ah,0Ch
            int 10h
            
            inc fcount
            jmp loop2f
        
    enddf:
            dec fcount
            dec fcount
            ;The initial positions of the rivals


ret
DrawFood endp
;=====================================================================================================================================================

DrawMaze    proc     near   

      
         Drawhoriz 5,315,2,c5
         Drawhoriz 5,315,1,c5
         Drawver   2,82,5,c5  
         Drawver   2,82,4,c5
         Drawver   102,142,5,c5
         Drawver   102,142,4,c5
         Drawver   2,82,315,c5
         Drawver   2,82,316,c5                   
         Drawver   102,142,315,c5
         Drawver   102,142,316,c5
         Drawhoriz 5,315,142,c5
         Drawhoriz 5,315,143,c5
          


         
         ;if wanted background 
         ;Drawrec 6,3,314,141,colour
          
         ;draw W            
         Drawrec upx1,upy1,lox1,loy1,c2 ;1             
         Drawrec upx2,upy2,lox2,loy2,c2  ;1
         Drawrec upx3,upy3,lox3,loy3,c2  ;1
         Drawrec upx4,upy4,lox4,loy4,c6
         
         ;draw A
         Drawhoriz ax1,ax2,ya1,c2
         Drawver   ya1,ya2,ax1,c2   
         Drawver   ya1,ya2,ax2,c2
         Drawhoriz ax3,ax4,ya3,c2
         Drawver   ya3,ya4,ax3,c2   
         Drawver   ya3,ya4,ax4,c2
         Drawrec upx5,upy5,lox5,loy5,c6;c4->14d
         Drawrec upx6,upy6,lox6,loy6,c5                                         
            
         
         ;draw R 
         Drawhoriz 235,285,22,c2
         Drawver 22,122,235,c2
         Drawver 22,72,285,c2
         Drawver 82,122,285,c2
         Drawver 102,122,255,c2
         Drawver 102,122,265,c2
         Drawver 72,82,255,c2
         Drawhoriz 255,265,102,c2
         Drawhoriz 255,285,82,c2
         Drawhoriz 255,285,72,c2
         
         Drawrec 255,42,265,52,c6
         Drawrec 256,73,285,81,c4
         Drawrec 305,22,314,82,c3
         Drawrec 305,102,314,122,c3
         Drawrec 256,103,264,122,c4;;;;;;;;;;

         
ret
DrawMaze endp
 ;=====================================================================================================================================================
        
                        

END  MAIN
                        