TITLE FILL THIS IN

; This program adds and subtracts 32-bit integers
; and stores the sum in a variable.

INCLUDE Irvine32.inc

.data
; decoy test
operand1	word  46
operand2	word -20
decoyDest	dword 0

; encrypt test
encryptKey	BYTE "filthisin"
plainText		BYTE "file this in",0
encryptDest	DWORD -1

; decrypt test
decryptKey	BYTE "filthisin"
cipherText		BYTE "file this in",0
decryptDest	DWORD -1

.code
main PROC	
	; Test decoy compute
	push operand1
	push operand2
	push OFFSET decoyDest
	call	compute
	mov eax, decoyDest
	call WriteInt

	; Test encrypt compute
	push	OFFSET encryptKey
	push OFFSET plainText
	push	OFFSET encryptDest
	call compute
	mov edx, OFFSET plainText
	call WriteString
	
	; Test decrypt compute
	push	OFFSET decryptKey
	push OFFSET cipherText
	push	OFFSET decryptDest
	call compute
	mov edx, OFFSET cipherText
	call WriteString

	exit
main ENDP

compute PROC

; https://stackoverflow.com/questions/16622296/looping-and-processing-string-byte-by-byte-in-masm-assembly maybe useful
; https://stackoverflow.com/questions/23015804/assembly-pass-byte-array-with-a-procedure answer may also be useful
; https://www.daniweb.com/programming/software-development/threads/453727/changing-spaces-to-underscore see the lodsb which is used to loop through a byte array 
; https://c9x.me/x86/html/file_module_x86_id_160.html is details about lodsb

; get the value of the address of the top item on the stack (DEST) and get it's value is 0 call decoy, if -1 call encrypt if -2 call decrypt. We will replace in place the plain text / cipher text
alphabet	BYTE "abcdefghijklmnopqrstuvwxyz"
; pushes the pointer to the alphabet array on the stack?
push OFFSET alphabet

compute ENDP

decoy PROC

; Adds the values and returns the sum 

decoy ENDP

encrypt PROC
; pops the array pointer for the plaintext from stack ?

; loops through the plaintext position by position 
;	at each position, push pointer location onto stack?
;	calls getCipherChar?
;	repeats for the length of the plaintext
; returns the ciphertxt
encrypt ENDP

decrypt PROC
; pops the array pointer for the ciphertext from stack 
; pushes the pointer to the alphabet array on the stack
; 
; loops through the ciphertext position by position 
;	at each position,push pointer location onto stack?
;	calls getPlainChar?
;	repeats for the length of the ciphertext
; returns the plaintext
decrypt ENDP 

getCipherChar PROC
; called by encrypt procedure
; pop char off stack 
; pop alphabet off stack
; pop key off stack
; get offset from alphabet array of char 
; get char from key (key offset + char offset)
; return cipherchar
getCipherChar ENDP

getPlainChar PROC
; called by decrypt procedure
; pop char off stack 
; pop alphabet off stack
; pop key off stack
; get offset from key array of char 
; get char from alphabet array (alphabet array offset + char offset)
; return plaintextchar
getPlainChar ENDP





END main