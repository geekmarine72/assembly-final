TITLE Final Project, substitution cipher

; Author: Jacob Vilevac
; Course/project ID Date: CS 271:1  3/17/2021
; Description: A program to encrypt and decrypt a secret message with the message and key passed on the stack

INCLUDE Irvine32.inc

.data
; decoy test
operand1		word	40
operand2		word	-26
decoyDest		dword	0

; encrypt test
encryptKey		BYTE "efbcdghijklmnopqrstuvwxyza"
plainText		BYTE "the contents of this message will be a mystery.",0
encryptDest		DWORD -1

; decrypt test
				     ;abcdefghijklmnopqrstuvwxyz
decryptKey		BYTE "efbcdghijklmnopqrstuvwxyza"
cipherText		BYTE "uid bpoudout pg uijt ndttehd xjmm fd e nztudsz.",0
decryptDest		DWORD -2

.code
main PROC	
	; Test decoy compute
	push	operand1
	push	operand2
	push	OFFSET decoyDest

	call	compute
	mov		eax, decoyDest
	call	WriteInt
	call	Crlf

	; Test encrypt compute
	push	OFFSET encryptKey
	push	OFFSET plainText
	push	OFFSET encryptDest
	call	compute
	mov		edx, OFFSET plainText
	call	WriteString
	call	Crlf
	
	; Test decrypt compute
	push	OFFSET decryptKey
	push	OFFSET cipherText
	push	OFFSET decryptDest
	call	compute
	mov		edx, OFFSET cipherText
	call	WriteString
	call	Crlf

	exit
main ENDP

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
		cmp		byte ptr [esi], 0
		jz		endOfLoop

		cmp		al, 97
		jl		nonLetter
		cmp		al, 122
		jg		nonLetter


		letter:
			mov		ecx, 26

			cypherLoop:
				mov		ah, [ebx + 1 * ecx - 1] ; get letter from cypher key according to ecx (decrementing counter from 26 to 0)
				cmp		ah, al
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