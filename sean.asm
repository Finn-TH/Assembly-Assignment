;------------------------------------------------------------------------------------------------------------------


				;CSLT Assignment Code AKISH EZEK SEAN TP068726

;------------------------------------------------------------------------------------------------------------------





.model small
.stack 100h
.data


;------------------------------------------------------------------------------------------------------------------

;User Input Msg
User_input                db 13, 10, 'Please Enter your choice: $'

;Declaring a variable line of asterisks -------------------------------------------------
asterisk_line db 13, 10, '*********************************************************','$'



;------------------------------------------------------------------------------------------------------------------

; Main Menu design

Main_menu   db 13, '-------------[ SEANS COFFEESHOP INVENTORY ]---------------',13,10
       db                                                                      ,13, 10
       db     'AKISH EZEK SEAN		                                      ',13, 10
       db     'TP068726					                      ',13, 10
       db                                                                      ,13, 10

       db     '-------------------[ SYSTEM OVERVIEW ]--------------------',13,10
       db     '1. View Inventory                                         ',13,10
       db     '2. Restock Inventory                                      ',13,10
       db     '3. Conduct Sale                                           ',13,10
       db     '4. Urgent Item Stocks & Sales Figures			 ',13,10
       db     '5. Exit                                                   ',13,10
       db     '----------------------------------------------------------',13,10
       db     '$'


;------------------------------------------------------------------------------------------------------------------


;Inventory Info Summary

Inventory_tldr db 13,'-----------[ SEANS COFFEESHOP INVENTORY INFO ]-----------',13,10
	     db     '---------------------------------------------------------',13,10
             db                                                           , 13, 10
	     db    'ID', 9,'Items',9, 'Stock',9,'Price US',9,'Items Sold', '$'



;------------------------------------------------------------------------------------------------------------------


;User Choices within Summary Menu 

Inventory_choice            db                                                           , 13, 10
                            db 13,'---------------------------------------------------------', 13, 10
                            db 'ITEMS ARE COLOR CODED WITH REGARDS TO RESTOCKING PRIORITY'    , 13, 10
                            db '---------------------------------------------------------', 13, 10, 10
                            db '1. Return to Main Menu'                                  , 13, 10
                            db                                                           , 13, 10
                            db 'Input your selection: $' 


;------------------------------------------------------------------------------------------------------------------




;Banner Design for Item Restocks

Item_restockbanner  	db 13, '---------------------------------------------------------' , 13, 10
		        db 13,'               REPLENISHING ITEM STOCK           '        , 13, 10
		        db '---------------------------------------------------------' , 13, 10
		        db 'Select Item ID:',' $'

    

;------------------------------------------------------------------------------------------------------------------

;Message Design for Item Restock
    Restock_amountmsg               db 13, 10, 'Input the quantity for restocking (range: 1-9): $'
    
;Restock Success msg  
    Restock_successmsg            db 13, 10, 'Item has been restocked successfully!', 13, 10, '$'







;------------------------------------------------------------------------------------------------------------------


;Banner Design for Item Sale

 Item_salebanner     	db '----------------------------------------------------', 13, 10
			db 9, 9, 32, 32, 'CONDUCT ITEM SALE', 13, 10
			db '----------------------------------------------------', 13, 10
			db 'Select Item ID: $'


    ;Select number of Items to sell

    Item_numofsale        db 13, 10, 'Specify the number of items to sell (choose a number between 1 and 9): $'
    
;Success Message

    Sale_successmsg       db 13, 10, 'Sale Success. Thank You For Shopping With Us!', 13, 10, '$'
    
;Fail Message

    Sale_failmsg          db 13, 10, 'Sale Fail. Insufficient Stock To Process Order!', 13, 10, '$'



;------------------------------------------------------------------------------------------------------------------


CategBanner 	db 13,  '---------------------------------------------------------------------', 13, 10
             	db 	'1. Sales Figures        	      		      ', 13, 10
             	db 	'2. View Urgent Items		                      ', 13, 10
        	db	'3. Return to Main Menu                               ', 13, 10
		db 	'---------------------------------------------------------------------', 13, 10
		db   	'                  Input Your Selection		      ', 13, 10
		db 	'---------------------------------------------------------------------', 13, 10
		db	'$'



CategItemsBanner 	db 13,	'-------------------------CATEGORIZE ITEMS----------------------------', 13, 10
                      	db    	'-----------------------------INVENTORY-------------------------------', 13, 10
		      	db	'$'


DisplayItemProps 	db 13, 'ID', 9, 'Item', 9, 'Price(RM)', 9, 'Amount Sold', 9, 'Total Profit', 13, 10
               		db '---------------------------------------------------------------------$'

;------------------------------------------------------------------------------------------------------------------



;Item Properties Defined

;Item number 1	       ;TLDR for Item Properties
Item1 dw 0             ;Item ID = 0
      db 'Cappu     '  ;Item Name = Cappu
      dw 4             ;Current Stock = 4
      dw 15            ;Item Price = 15
      dw 2             ;Priority Level Based off Stock
      dw 10, "$"       ;No of Items Sold


;------------------------------------------------------------------------------------------------------------------


;Item number 2 
Item2 dw 1
      db 'Acano     '  ;Item Name
      dw 10
      dw 15
      dw 5
      dw 20, "$"


;------------------------------------------------------------------------------------------------------------------


;Item number 3 
Item3 dw 2
      db 'Latte     '  ;Item Name
      dw 20
      dw 15
      dw 5
      dw 30, "$"


;------------------------------------------------------------------------------------------------------------------


;Item number 4 
Item4 dw 3
      db 'Tea       '  ;Item Name
      dw 2
      dw 10
      dw 1
      dw 40, "$"


;------------------------------------------------------------------------------------------------------------------


;Item number 5 
Item5 dw 4
      db 'Choc      '  ;Item Name
      dw 7
      dw 12 
      dw 3
      dw 50, "$"



;------------------------------------------------------------------------------------------------------------------


.code

;Macro Function. Print Item


DisplayItem Macro Item
	call PrintNline
	mov bp, 0
	lea si, Item
	
	mov ax, [si]

	call StringtoIntConv	

	call PrintTab
	mov dx, offset Item+2
	add dx, bp
	call PrintString
		
	mov ax, [si+12]
	call LowstockCheck
	
	
	mov ax, [si+12]
	call StringtoIntConv

	call PrintTab
	mov ax, [si+14]
	call StringtoIntConv
	
	call PrintTab
	
	
	call PrintTab
	mov ax, [si+18]
	call StringtoIntConv
EndM


;------------------------------------------------------------------------------------------------------------------


;Macro Function, Restock Item 

Restock Macro Item
	lea dx, Restock_amountmsg  ; Load Restockmsg into DX
	mov ah, 09h            ; Write String Function
	int 21h                ; Display Msg
	mov ah, 01h            ; Read Character
	int 21h                ; Read Character from User

	sub al, 30h            ; Convert the ASCII digit 
	sub ax, 256            ; Subtract 256 For Restock Amount (ASCI Formula)
	mov cx, ax   
	
	lea si, Item      ; Load the offset of the "inventory" array into SI
	       
	add cx, [si + 12]           ; Update Stock via Amount
	mov word ptr [si+12], cx
	call PrintLine
	lea dx, Restock_successmsg  
	mov ah, 09h           
	int 21h 
	call PrintNline
	call PrintLine
	
	call PrintNline
	call InventoryMenu
	
EndM


;------------------------------------------------------------------------------------------------------------------

SalesFigures Macro item
    call PrintNline
    mov bp, 0
    lea si, item

    mov ax, [si]
    call StringtoIntConv
    call PrintTab

    mov dx, offset item+2
    add dx, bp
    call PrintString
    call PrintTab

    mov ax, [si+14]
    call StringtoIntConv
    call PrintTab
    call PrintTab

    mov ax, [si+18]
    call StringtoIntConv
    call PrintTab
    call PrintTab

    mov cx, [si+14]
    mov ax, [si+18]
    mul cx
    call StringtoIntConv
EndM




;------------------------------------------------------------------------------------------------------------------




;Macro Function, Proccess Sale

ConductSale Macro Item
	lea dx, Item_numofsale     ; Load Item_numofsale into DX
	mov ah, 09h                 ; Set AH to 09h, indicating the DOS "Write String" function
	int 21h                     ; Display Msg
	mov ah, 01h                 ; Read Character
	int 21h  

	sub al, 30h                 ; Convert the ASCII 
	sub ax, 256
	mov cx, ax                  ; Store Sell Amount in the CX 

	lea si, Item
	mov ax, [si]
	

	mov bx, [si+12]                ; Load Current in BX
	sub bx, cx                  ; Subtract the Sell Amount

	call CMPwZero	
	mov word ptr [si+12], bx       ; Store Updated Value
	SaleSuccess Item          
EndM


;------------------------------------------------------------------------------------------------------------------


;Macro Function, Sale Success Msg

SaleSuccess Macro Item       
	call ClearOutput
	lea si, Item          ; Load Sales array into SI
	       
	mov ax, [si+18]            ; Load Current Sales Quantity 
	add cx, ax              ; Add Sell quantity
	mov word ptr [si+18], cx   ; Store Updated Value in Array
	call PrintNline
        call PrintLine
	lea dx, Sale_successmsg
	mov ah, 09h
	int 21h

	call PrintNline
        call PrintLine
        call PrintNline
        call Items
        call Userinputchoice
		
EndM



;------------------------------------------------------------------------------------------------------------------


;;Macro Function, Sale Fail Msg ( Ran out of Stock )


SaleReset Macro
    call ClearOutput
    mov bx, [si+12]
    mov word ptr [si+12], bx
    call PrintNline
    call PrintLine
    lea dx, Sale_failmsg
    mov ah, 09h
    int 21h 
   
    call PrintNline
    call Items
    call Userinputchoice
    ret

EndM


;------------------------------------------------------------------------------------------------------------------

LStockM Macro			;Displaying Low Stock Items  
	call ClearOutput

	mov ah,09h
	lea dx, Inventory_tldr		;Display all the items
	int 21h 

	mov bp, 0			;If hoodie stock is lower than 5, display
	lea si, Item1
	mov ax, [si+12]
	cmp ax, 5
	jg next1
	DisplayItem Item1
next1:
	lea si, Item2			;If t-Shirt stock is lower than 5, display
	mov ax, [si+12]
	cmp ax,5
	jg next2
	DisplayItem Item2
next2:
	lea si, Item3			;If sweater stock is lower than 5, display
	mov ax, [si+12]
	cmp ax, 5
	jg next3
	DisplayItem Item3
next3:
	lea si, Item4			;If trouser stock is lower than 5, display
	mov ax, [si+12]
	cmp ax, 5
	jg next4
	DisplayItem Item4
next4:
	lea si, Item5			;If jeans stock is lower than 5, display
	mov ax, [si+12]
	cmp ax, 5
	jg last
	DisplayItem Item5
	call LowStockC			
last:
	call LowStockC		;Display filtered items
	ret
EndM


;------------------------------------------------------------------------------------------------------------------


MAIN PROC
	mov ax, @data          ; Load Data in AX
	mov ds, ax             ; Move AX to DS
	call ClearOutput
	lea dx, Main_menu           ; Load MainMenu in DX
	mov ah, 09h            ; Write String Function
	int 21h                ; Display Menu 

	lea dx,  User_input  ; Load UserInput in DX
	mov ah, 09h          ; Write String Function
	int 21h 
	
	; Read single character from keyboard

	mov ah, 01h

	; Read character

	int 21h
	

	; Compare character in al with '1'

; Run Function per Input Choice 1-5

	cmp al, '1'
	je InventoryMenu
	
	cmp al, '2'
	je RestockMenu
	

	cmp al, '3'
	je SalesMenu


        cmp al, '4'
	je CategScreen


	cmp al, '5'
	je Exit

	jmp main


;------------------------------------------------------------------------------------------------------------------


;1st choice to display inventory and perform desired option 
InventoryMenu:
	call ClearOutput
	call Items
	call Userinputchoice
	ret


;2nd choice to restock
RestockMenu:
	call ClearOutput
	call Items
	call RestockBanner
	ret


;3rd choice to process sales
SalesMenu:
	call ClearOutput
	call Items
	call SalesBanner
	ret

;4th choice to categorize items
CategScreen:				;If user chooses to categorize items
	call ClearOutput
	call CategItems
	call CategMenu
	ret



;5th choice to exit
Exit:
	call ClearOutput
        call ExitSys
        ret


;------------------------------------------------------------------------------------------------------------------


;Exit Program Function

ExitSys:
        call PrintLine   ;Calls the draw line function
        mov ah,4ch       ;Function to exit the program
        int 21h 


;PrintLine Function

PrintLine:
        lea dx, asterisk_line
        mov ah, 09h            ;String Output
        int 21h                ;DOS
        ret                    ;Return Function


;Clear Output Function

ClearOutput:
        mov ah, 06h     ;Scroll Up function
        mov al, 0       ;Clear all
        mov bh, 07h
        mov cx,0
        mov dx, 184Fh
        int 10h         ;BIOS Interrupt
        ret


;------------------------------------------------------------------------------------------------------------------


Userinputchoice:


    lea dx, Inventory_choice
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1' ; Compare Input With '1'
    je skip_invalid_input1 ; I = 1 = Main

    cmp al, '0'
    je Exit

    jmp InventoryMenu     ; If None, Return
    ret	

skip_invalid_input1:
    jmp main


;------------------------------------------------------------------------------------------------------------------

RestockBanner:
	lea dx, Item_restockbanner
	mov ah, 09h
	int 21h

	mov ah, 01h
	int 21h

	cmp al, '0'
	je RS1

	cmp al, '1'
	je RS2

	cmp al, '2'
	je RS3

	cmp al, '3'
	je RS4

	cmp al, '4'
	je RS5

	jmp main
	
	ret




RS1:
	call Restock1
	ret

RS2:
	call Restock2
	ret

RS3:
	call Restock3
	ret

RS4:
	call Restock4
	ret
RS5:
	call Restock5
	ret


Restock1:
	Restock Item1
	ret

Restock2:
	Restock Item2
	ret

Restock3:
	Restock Item3
	ret 

Restock4:
	Restock Item4
	ret

Restock5:
	Restock Item5
	ret


;------------------------------------------------------------------------------------------------------------------


SalesBanner:
	lea dx, Item_salebanner
	mov ah, 09h
	int 21h

	mov ah, 01h
	int 21h
	cmp al, '0'
	je SI1

	cmp al, '1'
 	je SI2

	cmp al, '2'
 	je SI3

	cmp al, '3'
	je SI4

	cmp al, '4'
	je SI5

	jmp main
	ret


SI1:
	call ItemSale1
	ret

SI2:
	call ItemSale2
	ret

SI3:
	call ItemSale3
	ret
SI4:
	call ItemSale4
	ret
SI5:
	call ItemSale5
	ret

ItemSale1:
	ConductSale Item1	
	ret

ItemSale2:
	ConductSale item2
	ret

ItemSale3:
	ConductSale item3
	ret

ItemSale4:
	ConductSale item4	
	ret

ItemSale5:
	ConductSale item5
	ret


CMPwZero:
	cmp bx, 0
	js ResetStock
	ret

ResetStock:
	SaleReset
	ret



;------------------------------------------------------------------------------------------------------------------




CategItems:  ; Items for Category Function
    	mov ah, 09h
    	lea dx, CategItemsBanner
    	int 21h
	
    	mov ah, 09h
    	lea dx, DisplayItemProps
    	int 21h

	SalesFigures Item1
    	SalesFigures Item2
    	SalesFigures Item3
    	SalesFigures Item4
    	SalesFigures Item5
	
    	call PrintNline
    	ret



CategMenu:
    	mov ah, 09h
    	lea dx, CategBanner
    	int 21h

    	mov ah, 01h
    	int 21h

    	cmp al, '1'
    	je CategInv

    	cmp al, '2'
    	je ItemStockL

    	cmp al, '3'
    	je skip_invalid_input2

    	jmp CategScreen

	skip_invalid_input2:
    	jmp main

	ret



CategInv:			;Unfilter items - display all items
	call ClearOutput
	call CategItems
	call CategMenu
	ret





LowStockC:
    	call Printline
    	mov ah, 09h
    	lea dx, CategBanner
    	int 21h

    	mov ah, 01h
   	 int 21h

    	cmp al, '1'
    	je CategInv

    	cmp al, '2'
    	je ItemStockL

    	cmp al, '3'
    	je skip_invalid_input3

    	jmp ItemStockL

	skip_invalid_input3:
    	jmp main

	ret



ItemStockL:				;Call macro to filter items with stock less than 5
	LStockM
	ret

;------------------------------------------------------------------------------------------------------------------



Items:  
	lea dx, Inventory_tldr
	mov ah,09h
	int 21h  
	DisplayItem Item1
	DisplayItem Item2
	DisplayItem Item3
	DisplayItem Item4
	DisplayItem Item5
	call PrintNline
	ret

;------------------------------------------------------------------------------------------------------------------


;Function to print a new line

PrintNline:

        mov dl, 0ah     ;ASCII value
        mov ah, 02
        int 21h
        ret


;------------------------------------------------------------------------------------------------------------------


;Stock < 5 Function

LowstockCheck:
        mov bx, ax
        cmp bx, 5
        jle StatusRed
        jmp StatusGreen
	ret

;------------------------------------------------------------------------------------------------------------------


StatusRed:

	mov dl, [bx]
        mov ah, 09h
        mov al, dl
        mov bl, 04h   ;Red Color 
        or bl, 80h    ; Blink Attribute
	mov cx,2
	int 10h
	ret

;------------------------------------------------------------------------------------------------------------------


StatusGreen:

	mov dl, [bx]
        mov ah, 09h
        mov al, dl
        mov bl, 02h ; Green Color 
        mov cx,2
	int 10h
	ret


;------------------------------------------------------------------------------------------------------------------


;String to Int Conversion Function

StringtoIntConv:
        push bx    ; Save Bx on the stack
        mov bx, 10  ;Set BX to 10 
        xor cx, cx  ; Clear cx counter

        convert_loop:
           xor dx, dx        ;Clear DX High byte
           div bx            ;Divide Byte 
           add dl, '0'       ;Convert To ASCII
           push dx
           inc cx
           cmp ax, 0
           jne convert_loop

        print_int:           
             pop dx
             mov ah, 02
             int 21h
             dec cx
             cmp cx, 0
             jne print_int
             pop bx
             ret


;------------------------------------------------------------------------------------------------------------------



;Print String Function

PrintString:
        push ax
        push bx
        push cx
        mov bx, dx
        mov cx, 10
        string_loop:
                mov dl, [bx]
                int 21h
                inc bx
                loop string_loop
        string_done:
        pop cx
        pop bx
        pop ax
        ret


;------------------------------------------------------------------------------------------------------------------


 ;Print Tab Character Function

PrintTab:
        mov dl,09      ; ASCII Character
        mov ah,02
        int 21h
        ret




;------------------------------------------------------------------------------------------------------------------




MAIN ENDP
END MAIN