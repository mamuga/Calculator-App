ORG 100h

jmp start 
MSG: DB '1-ADD',0DH,0AH,'2-SUBTRACT',0DH,0AH,'3-MULTIPLY',0DH,0AH,'4-DIVIDE',0DH,0AH,'$'; first string displays options in the calculator
MSG2:DB 0DH,0AH, 'Enter First number: $'; second string requests for first number
MSG3:DB 0DH,0AH, 'Enter Second number: $'; third string requests for second number
MSG4:DB 0DH,0AH, 'choice not within options above $'; fourth string alerts user when wrong option is made
MSG5:DB 0DH,0AH,'Result: $'; fifth string shows results
MSG6:DB 0DH,0AH, 'Thank you for using the calculator! press any key....: $'; string after the output of a result

Start: ; label for start 

       MOV AH,09;print
       MOV DX, OFFSET MSG; msg is offset into the dx register
       INT 21H; do it
       MOV AH, 0; ah register is set to zero
       INT 16H; reads a keyboard press 
       CMP AL, 31H; 31H represents 1 in hexadecimal
       JE ADDITION; value is compared with the cmp instruction and if equal to 31h instruction jumps to label addition
       CMP al,32H;32h represents 2 in hexadecimal
       JE SUBTRACTION; value is compared with the cmp instruction and if equal to 32h instruction jumps to label subtraction
       CMP AL, 33H;33h represents 3 in hexadecimal
       JE MULTIPLICATION; value is compared with the cmp instruction and if equal to 33h jumps to label multiplication
       CMP al,34H;34h represents 4 in hexadecimal 
       JE DIVISION; value is compared with the cmp instruction and if equal to 34h jumps to label division
       mov ah, 09; print
       mov dx, offset msg4; message 4 is moved into the dx register
       int 21H; do it
       mov ah,0; ah register is set to 0
       int 16h; reads a keyboard press
       jmp start; instruction jumps to start
       
  ADDITION: ; label addition
           MOV AH, 09H; print
           MOV DX, OFFSET MSG2 ; message 2 is moved into the dx register
           INT 21H; do it
           MOV CX, 0; counter of the digits is set to zero
           CALL INPUTNO ; code operation jumps to label inputno
           PUSH DX;
           MOV AH,9;
           MOV DX, OFFSET MSG3; message 3 is moved to dx register
           INT 21H; do it
           MOV CX,0; number counter is set to zero
           CALL INPUTNO; instruction moves to inputno procedure 
           POP BX; first number input is put into bx 
           ADD DX, BX; contents of dx are added to bx
           PUSH DX; dx is put in the stack
           MOV AH,09H; print
           MOV DX,OFFSET MSG5; message 5 is moved to dx register
           INT 21H; do it
           POP DX; to view msg 5
           MOV CX,10000; represents maximum no calculator can calculate
           CALL VIEW;
           JMP EXIT;
  
     EXIT: MOV DX, OFFSET MSG6;
           MOV AH, 09H; print
           INT 21H; do it
           MOV AH,0; 
           INT 16H;
           RET;
       
     
           
  VIEW:    MOV AX, DX;
           MOV DX,0;
           DIV CX; ax is divided by 10000
           CALL VIEWNO;
           MOV BX,DX;
           MOV DX,0; 
           MOV AX, CX;
           MOV CX,10;
           DIV CX
           MOV DX,BX
           MOV CX,AX;
           CMP AX,0;
           JNE VIEW
           RET
           
      
         
           
           
  
  INPUTNO: 
           MOV AH,0; ah register is set to 0
           INT 16H; reads keyed in input
           MOV DX,0; register we will add the values after each iteration
           MOV BX, 1; initial value popped from stack will be multiplied by 1 then 10 and so on...  
           CMP AL, 0DH; compares if input is enter and if so, user is done inputting 
           JE FORMNO; after user presses enter code jumps to this label
           SUB AX,30H; converts numbers in al reg from ascii to decimal
           CALL VIEWNO; will make the no keyed visible on display screen
           MOV AH,0; ah register set to zero
           PUSH AX; ax is put in stack
           INC CX; value of counter is incremented by one
           JMP INPUTNO; instruction jumps to label inputno until enter is keyed 
              
             
       ;each no is stored in the stack separately
       ;code below gives numbers keyed in their place value 
  FORMNO: 
          POP AX; last value entered in the stack will be removed first
          PUSH DX; dx register is put in stack 
          MUL BX; contents of ax which is value of user input are multiplied to bx
          POP DX; dx contents are removed from stack
          ADD DX, AX; contents of dx are added to ax
          MOV AX, BX; contents of ax are moved into bx 
          MOV BX,10; value 10 is moved into ax
          PUSH DX; dx contents are moved to stack
          MUL BX; ax register is multiplied by bx(10)
          POP DX; contents of dx register are retrieved from stack
          MOV BX, AX; contents of ax are moved into bx
          DEC CX; counter is decremented by 1
          CMP CX,0; value of counter is compared to zero
          JNE FORMNO; if counter value not equal to zero it jumps back to formno label
          RET; if equal to zero exits from label code
     
 ; the code below viewno is to view the key press     
  VIEWNO: 
          PUSH AX; current values of ax are put in the stack 
          PUSH DX; current values of dx are put in the stack
          MOV DX,AX; contents of ax are moved to dx
          ADD DL, 30H; converts contents of dl to ascii
          MOV AH,2; viewing a number or value of a register
          INT 21H; do it
          POP DX; contents of dx are removed form stack 
          POP AX; contents of ax are removed from stack
          RET
                  
  
  SUBTRACTION:
           
           MOV AH, 09H; print
           MOV DX, OFFSET MSG2; message 2 is moved into the dx register
           INT 21H; do it
           MOV CX, 0; counter of the digits is set to zero
           CALL INPUTNO; code operation jumps to label inputno
           PUSH DX;
           MOV AH,9;
           MOV DX, OFFSET MSG3; message 3 is moved to dx register
           INT 21H; do it
           MOV CX,0; number counter is set to zero
           CALL INPUTNO; instruction moves to inputno procedure 
           POP BX; first number input  is put into bx 
           SUB BX, DX; contents of dx are subtracted from bx
           MOV DX, BX; contents in bx are moved to dx
           PUSH DX; dx is put in the stack
           MOV AH,09H; print
           MOV DX, OFFSET MSG5; message 5 is moved to dx register
           INT 21H; do it
           POP DX; to view msg 5
           MOV CX,10000; represents maximum no calculator can calculate
           CALL VIEW;
           JMP EXIT;   
                  
  
  
  MULTIPLICATION:
                  MOV AH, 09H; print
                  MOV DX, OFFSET MSG2; message 2 is moved to the dx register
                  INT 21H; do it
                  MOV CX, 0; counter of the digits is set to zero
                  CALL INPUTNO; instruction moves to inputno procedure 
                  PUSH DX; first number input is put into bx 
                  MOV AH, 9; 
                  MOV DX, OFFSET MSG3; message 3 is moved to dx register
                  INT 21H; do it
                  MOV CX,0; counter of the digits is set to zero
                  CALL INPUTNO; instruction moves to inputno procedure 
                  POP BX; first number input is put into bx 
                  MOV AX, DX; contents of dx are moved to ax
                  MUL BX; contents in bx are multiplied
                  MOV DX, AX; contents of ax are moved to dx
                  PUSH DX; first number input is put into bx 
                  MOV AH,09H; print
                  MOV DX, OFFSET MSG5; message 5 is moved to dx register
                  INT 21H; do it
                  POP DX; to view msg 5
                  MOV CX,10000; represents maximum no calculator can calculate
                  CALL VIEW; 
                  JMP EXIT;
   
  
  DIVISION:       
                  MOV AH, 09H; print
                  MOV DX, OFFSET MSG2; message 2 is moved into the dx register
                  INT 21H; do it
                  MOV CX, 0; counter of the digits is set to zero
                  CALL INPUTNO; code operation jumps to label input no.
                  PUSH DX;
                  MOV AH,9;
                  MOV DX, OFFSET MSG3; message 3 is moved to dx register
                  INT 21H; do it
                  MOV CX,0; number counter is set to zero
                  CALL INPUTNO; instruction moves to inputno procedure 
                  POP BX; first number input is put into bx 
                  MOV AX, BX; contents of bx are moved to ax
                  MOV CX, DX; contents of dx are moved to cx
                  MOV DX,0; number is set to zero
                  DIV CX; contents in cx are divided
                  MOV DX, AX; contents in ax are moved to dx
                  PUSH DX; 
                  MOV AH,09H; print
                  MOV DX, OFFSET MSG5; message 5 is moved to dx register
                  INT 21H; do it
                  POP DX; to view msg 5
                  MOV CX,10000; represents maximum no calculator can calculate
                  CALL VIEW;
                  JMP EXIT;       
    
      
ret
