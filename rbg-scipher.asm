TITLE Final Project, substitution cipher

; Author: Jacob Vilevac
; Course/project ID Date: CS 271:1  3/17/2021
; Description: A program to encrypt and decrypt a secret message with the message and key passed on the stack

INCLUDE Irvine32.inc

.data

.code

main PROC	

	exit
main ENDP

; COMPUTE PROCEDURE
; This procedure takes the destination value and decides which of the three modes to go into, decoy, encrypt or decrypt
; recieves: dest in top of the stack
; returns: nothing
; preconditions: dest = 0, -1, or -2, (dest is top of the stack)
; registers changed: ebp, edx, eax
compute PROC
	mov		ebp, esp ; reset base pointer
	mov		edx, [ebp+4] ; store offset of dest
	mov		eax, [edx] ; get value stored in dest
	cmp		eax, 0
	je		modeDecoy
	cmp		eax, -1
	je		modeEncrypt
	cmp		eax, -2
	je		modeDecrypt

	modeDecoy:
		call	decoy
		jmp		computeEnd

	modeEncrypt:
		call	encrypt
		jmp		computeEnd

	modeDecrypt:
		call	decrypt
		jmp		computeEnd

	computeEnd:
	ret
compute ENDP


; DECOY PROCEDURE
; This procedure takes operand 1 and operand 2 from 2nd and 3rd from top of the stack, adds them and stores the result in refenced dest (top of stack)
; recieves: operand 1, operand 2, OFFSET dest. on the stack(from bottom to top of stack)
; returns: operand 1 + operand 2 in dest
; preconditions: operand 1 + operand 2 <= 65,536
; registers changed: ebp, eax (& ax), ebx (& bx), edx
decoy PROC
	mov		ebp, esp
	xor		eax, eax
	xor		ebx, ebx
	mov		edx, [ebp+8] ; dest (procedure adds 8 to stack)
	mov		ax, [ebp+12] ; operand 2 (dest added 4 to stack)
	mov		bx, [ebp+14] ; operand 1 (operand 2 added 2 to stack)

	add		ax, bx
	mov		[edx], ax

	ret
decoy ENDP

; ENCRYPT PROCEDURE
; This procedure takes the plain text byte string to be encrypted and the cypher key and encrypts the plain text and stores it in its original location
; recieves: plain text (2nd from top of stack), cypher key (3rd from top of stack)
; returns: encrypted plain text in its original locations
; preconditions: enryption key is 26 characters, plain text is 0 terminated
; registers changed: ebp, esi, ebx, eax (& al)
encrypt PROC
	mov		ebp, esp
	mov		esi, [ebp+12] ; plain text to be encrypted, start of plain text array is now stored in esi
	mov		ebx, [ebp+16] ; encryption key start now stored in ebx

	loopArray:
		xor		eax, eax
		mov		al, [esi] ; gets first character of byte string (+1 for each next char)
		cmp		byte ptr [esi], 0
		jz		endOfLoop

		cmp al, 97
		jl nonLetter
		cmp al, 122
		jg nonLetter

		letter:
			sub		al, 97d ; get base 0 of alphabet
			mov		eax, [ebx + 1 * eax] ; get corresponding cypher letter
			mov		[esi], al
		
		nonLetter:
			inc		esi
			jmp		loopArray

		; ECX now holds the length of our input string

	endOfLoop:
	ret
encrypt ENDP

; DECRYPT PROCEDURE
; This procedure takes the encrypted byte string, and the cypher key, and decrypts the encrypted text, replacing it with the decrypted text
; recieves: encrypted text (2nd from top of stack), cypher key (3rd from top of stack)
; returns: decrypted plain text in its original locations
; preconditions: decryption key is 26 characters, encrypted text is 0 terminated
; registers changed: ebp, esi, ebx, eax (& al, ah), ecx
decrypt PROC
	mov		ebp, esp
	mov		esi, [ebp+12] ; encrypted text to be converted
	mov		ebx, [ebp+16] ; encryption key start now stored in ebx

	; FOR ASCII
	; a = 97
	; z = 122

	mov ecx, 26

	loopArray:
		xor		eax, eax
		mov		al, [esi] ; gets first character of byte string (+1 for each next char)
		cmp		byte ptr [esi], 0 ; if we reach the 0 terminator, stop
		jz		endOfLoop

		cmp		al, 97 ; if ASCII is lower than lowercase a
		jl		nonLetter ; then its not a letter
		cmp		al, 122 ; if ASCII is higher than lowercase z
		jg		nonLetter ; then its not a letter


		letter:
			mov		ecx, 26 ; used to loop over cypher key

			cypherLoop:
				mov		ah, [ebx + 1 * ecx - 1] ; get letter from cypher key according to ecx (decrementing counter from 26 to 0)
				cmp		ah, al ; compare the current letter (al) in the encrypted text, with each letter in key (ah)
				je		match
				jmp		ignore
				ignore:
					loop	cypherLoop
			
			match:
			; ecx now holds the position where we found that letter
			; ecx also represents the offset from a, that the letter in they key relates to
			mov		eax, ecx
			add		eax, 96d
			mov		[esi], al
		
		nonLetter:
			inc		esi
			jmp loopArray
	endOfLoop:
	ret
decrypt ENDP 
END main