org 0x7C00 ; baslangicta osin hangi adreste oldugunu soyluyoruz, bizim kodumuzun calculate olacagi offsett 7000 diyoruz

;directive ler nasil compile edecegini soyler translate edilmez.
;instruction lar ise cpunun execute edecegi dile donusturur
%define ENDL 0x0D, 0x0A

bits 16 ; bits directive i asmbler a kac bit olacagini belirtiyoruz
;cpu hep 16 bitte baslar, burda belirttihimiz sadece os  in durumunu belirler x86 mimarisinde durum bu sekilde

start:
	jmp main 




; prints a string to the screen
;Params: 
;    - ds:si to string

puts:
	; save regusters we will modify
	push si
	push ax
	push bx
.loop:   
; LODSB,LODSW,LODSD these instructions load a byte/word/double-word from DS:SI into AL/AX/EAX then increment SI ny number of bytes loaded.
; or(destionation, source) performs bitwise OR between source and destination, stores result in destination.
	lodsb ; load next character in al 
	or al, al  ; verify if next characters is null
	jz .done ; Jz destionation jumpst to destination if zero flag is set.
	mov ah, 0x0E
	int 0x10
	jmp .loop



; EXAMPLES of BIOS interrupts
; INT 10h - Video
; INT 11h - Equipment Check
; INT 12h - Memory Size
; INT 13h - Disk I/O
; INT 14h - Serial Communications
; INT 15h - Cassette
; INT 16h - Keyboard I/O
; AH = 00H -- Set Video Mode
; AH = 10h -- Set Cursor Shape
; AH = 02h -- Set Cursor Position
; AH = 03h -- Get Cursor Position and Shape
; AH = 0Eh -- Write Character in TTY Mode

; print a charachter to the creen in TTY mode.
; AH = 0e
; AL = ASCII character to write
; BH = page number (text modes)
; Bl = foreground pixel color (graphics mode)
; return nothing

.done: 
	pop ax
	pop si
	ret


main:
	;setup data segments
	mov ax, 0 ; cant write to ds/es directly
	mov ds, ax
	mov es, ax

	; setup stack

	mov ss, ax
	mov sp, 0x7C00 ;stack grows downwords from where we are loaded in memory
	; print message
	mov si, msg_hello
	call puts

 	hlt ; burda cpu nun execute olmasini durduruyoruz

.halt:
 	jmp .halt ; jump bir location veriyor bize c deki goto komutu gibi
 	

msg_hello: db 'SELAMLAR!' , ENDL , 0


times 510-($-$$) db 0  ;db = define byte(s) olarak geciyor, times= verilen zamana gore instruction u tekrar eder
; $ = special symbol which is equal to the memory of the current line 
; $$ = special symbol which is equal to the memory offset of the beginning of the current section 
; $ - $$  gives the size of our program so fer (in bytes)

dw 0AA55h ; define word(s) writes given words 2 byte value, encoded in little endian 

;memory segmentation 
	; CS- currently running code segment
	; DB- data segment
	; SS - stack segment
	; ES,FS,GS - exta(data) segments

; segment: [base + index * scale + displacement]
; All fields are optinal:
	; segment: CS,DS,ES,FS,GS,SS(DS if unspecified)
	; base: (16 bits) BP/BX
		   ;(32/64 bits) any general purpose register
	; index: (16 bits) SI/DI
		   ; (32/64 bits) any general purpose register
	;scale: (32/64 bits only) 1,2,4 or 8 
	;displacement: a (signed) constant value

; +============================
; referencuing a memory location
; var: dw 100
; mov ax, var          copy offset to ax
; mov ax, [var]        copy memory contents
; MOV(destination,source)
;copies data from source (register,memory reference,constant) to destination(register of memory reference)

