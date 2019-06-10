        
                        .Model Small
.Stack 64

.data

c1   db  0fh
upx1 dw  25
upy1 dw  22
lox1 dw  35
loy1 dw  122
 

upx2 dw  35
upy2 dw  102
lox2 dw  95
loy2 dw  122 

upx3 dw  85
upy3 dw  22
lox3 dw  95
loy3 dw  102

c2   db  4  
upx4 dw  55
upy4 dw  22
lox4 dw  65
loy4 dw  82 
;A coordinates
ax1  dw  115
ax2  dw  215
ya1  dw  22
ya2  dw  122  

ax3  dw  135
ax4  dw  195
ya3  dw  42
ya4  dw  122 

upx5 dw  155
upy5 dw  62
lox5 dw  175
loy5 dw  82 

upx6 dw  155
upy6 dw  102
lox6 dw  175
loy6 dw  141 


        x db 0
        y db 0 
        a db 0
        b db 0
        d db 3
   
            
.code

MAIN        PROC FAR
            MOV AX,@data
            mov ds,ax 
                            
                            
       Drawrec macro x,y,a,b,c  ;betala3 a=3ard b=tool 
         local loop1
         local loop2
       
         mov cx,x
  loop1: mov dx,y
        loop2: mov al,c
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
            
       endm Drawrec  
                                   
                            
                   Drawhoriz macro x1,x2,y,c 
        local loop1
        mov dx,y
        mov cx,x1
        mov si,x2
        inc si
 loop1: mov al,c
        mov ah,0ch
        int 10h
        inc cx
        cmp cx,si
        jnz loop1
        
       endm Drawhoriz
       
       
       Drawver macro y1,y2,x,c 
        local loop1
        mov cx,x
        mov dx,y1
        mov si,y2
        inc si
 loop1: mov al,c
        mov ah,0ch
        int 10h
        inc dx
        cmp si,dx
        jnz loop1
        
       endm Drawver 

        
          drawrival1 macro x,y
            mov ah,2
            mov dl,x
            mov dh,y
            int 10h
            mov ah,9
            mov bh,0
            mov al,2
            mov cx,1
            mov bl,04h
            int 10h
          endm drawrival1 
          drawrival2 macro x,y
            mov ah,2
            mov dl,x
            mov dh,y
            int 10h
            mov ah,9
            mov bh,0
            mov al,2
            mov cx,1
            mov bl,01h
            int 10h
          endm drawrival2 
          clearrival macro x,y
            mov ah,2
            mov dl,x
            mov dh,y
            int 10h
            mov ah,9
            mov bh,0
            mov al,9
            mov cx,1
            mov bl,0ffh
            int 10h
           endm clearrival
 move macro x,y,d
local endd
local up
local down
local left
local right
up: cmp d,0
   jne down
   cmp y,0
   je endd
   dec y
   jmp endd

down: cmp d,1
   jne left
   cmp y,24
   je endd
   inc y
   jmp endd
left: cmp d,2
   jne right
   cmp x,0
   je endd
   dec x
   jmp endd

right: cmp d,3
   jne endd
   cmp x,79
   je endd
   inc x
   jmp endd

endd: 
endm move	
    
        setdirection macro d
local check
local endd
local up
local down
local left
local right
check: mov ah,1
int 16h
jz endd
mov ah,0
int 16h
up: cmp ah,72
    jne down
    mov d,0
    jmp endd

down: cmp ah,80
    jne left
    mov d,1
    jmp endd

left: cmp ah,75
    jne right
    mov d,2
    jmp endd

right: cmp ah,77
    jne esca
    mov d,3
    jmp endd
esca: cmp al,27
    jne endd
    
    mov d,4
endd:
endm setdirection 
        
        
       ;code
            
         ;clearscreen
         mov ah,0
         mov al,3
         int 10h 
         
         ;video mode
         mov ah,0
         mov al,13h
         int 10h 
         
            
         ;Draw frame       
         Drawhoriz 5,315,2,6 
         Drawhoriz 5,315,1,6
         Drawver   2,82,5,6   
         Drawver   2,82,4,6
         Drawver   102,142,5,6
         Drawver   102,142,4,6
         Drawver   2,82,315,6
         Drawver   2,82,316,6                   
         Drawver   102,142,315,6
         Drawver   102,142,316,6
         Drawhoriz 5,315,142,6 
         Drawhoriz 5,315,143,6
          


         
         ;green background
;         Drawrec 6,3,314,141,48
          
         ;draw W            
         Drawrec upx1,upy1,lox1,loy1,c1             
         Drawrec upx2,upy2,lox2,loy2,c1
         Drawrec upx3,upy3,lox3,loy3,c1
         Drawrec upx4,upy4,lox4,loy4,c1 
         
         ;draw A
         Drawhoriz ax1,ax2,ya1,c1
         Drawver   ya1,ya2,ax1,c1   
         Drawver   ya1,ya2,ax2,c1
         Drawhoriz ax3,ax4,ya3,c1
         Drawver   ya3,ya4,ax3,c1   
         Drawver   ya3,ya4,ax4,c1
         Drawrec upx5,upy5,lox5,loy5,c1
         Drawrec upx6,upy6,lox6,loy6,c1                                        
            
         
         ;draw R 
         Drawhoriz 235,285,22,c1
         Drawver 22,122,235,c1
         Drawver 22,72,285,c1
         Drawver 82,122,285,c1
         Drawver 102,122,255,c1
         Drawver 102,122,265,c1
         Drawhoriz 255,265,102,c1
         Drawhoriz 255,285,82,c1
         Drawhoriz 255,285,72,c1
         
         Drawrec 255,42,265,52,c1
         Drawrec 256,73,285,81,c2
         Drawrec 305,22,314,82,c1
         Drawrec 305,102,314,122,c1
         
         
                                
         
     loop8: 
           clearrival a,b
           drawrival1 x,y
            
           setdirection d 
            mov al,d
            cmp al,4
            je l
            mov al,x
            mov bl,y 
            mov a,al
            mov b,bl
            move x,y,d   
            
           mov cx,9999  ;delay
           loop9: 
                  mov si,10
               loop10: dec si
                      jnz loop10
                  dec cx
                 jnz loop9 
      jmp loop8    

    l: mov ax,1
       

 
            
             
 

                    
                                       
            
                        
MAIN ENDP
END  MAIN
                        