.macro PRINT msg, len
	movq $1, %rax
	movq $1, %rdi
	leaq \msg(%rip), %rsi
	movq $\len, %rdx
	syscall
.endm
	
.macro READ input, len
	movq $0, %rax
	movq $0, %rdi
	leaq \input(%rip), %rsi
	movq $\len, %rdx
	syscall
.endm
	
.macro TRIM_NL input, jump
	leaq \input(%rip), %r10
	dec %r8
	movb (%r10,%r8,1), %r9b
	
	cmpb $0x0A, %r9b
	jne \jump
	
	movb $0, (%r10,%r8,1)
.endm
	
.macro RESTART_CHECK buf, dumb_jump
	lea \buf(%rip), %r10
	cmpb $'y', (%r10)
	je restart
	cmpb $'Y', (%r10)
	je restart
	cmpb $'n', (%r10)
	je exit
	cmpb $'N', (%r10)
	je exit
	jmp \dumb_jump
.endm
	
.macro EXIT code=0
	movq $60, %rax
	movq $\code, %rdi
	syscall
.endm
	
.macro CLS
	PRINT cls_msg, cls_len
.endm
	
.section .data
options_msg:
	.align 8
	.asciz "Who do you want info about?\n1. Frodo\n2. Sam\n3. Gandalf\n4. Big eye man\n5. Bilbo\n6. Gollum\n"
	options_len = . - options_msg
frodo_msg:
	.align 8
	.asciz "Frodo.\nShort man. Furry feet (Secretly a furry). Looks 50 and 12. Short Irish bloke.\n"
	frodo_len = . - frodo_msg
sam_msg:
	.align 8
	.asciz "Sam (AKA. Fat Dude).\nAlso of the Short man genus, accompanied by the furry feet. Is blonde and has maybe had a few too many breakfastses. Also a short Irish bloke.\n"
	sam_len = . - sam_msg
gandalf_msg:
	.align 8
	.asciz "Gandalf.\nNOT a short man, a big... Normal sized man I think, he likes to play around and say 'YOU SHALL NOT PASS!!' I'm pretty sure, also I think his beard looks pretty cool.\n"
	gandalf_len = . - gandalf_msg
sauron_msg:
	.align 8
	.asciz "Sauron.\nBIG EYE MAN. he's just this big plague infested eye, his name is SIIICCK though. I don't know what an eye can do though, I feel like it would just self destruct.\n"
	sauron_len = . - sauron_msg
bilbo_msg:
	.align 8
	.asciz "Bilbo.\nDumbass name; \"ooo my name is Bilbo\", man SHUT UP!!! I don't even know what he looks like, like an old greasy man I think. And he has some ring that he probably stole.\n"
	bilbo_len = . - bilbo_msg
gollum_msg:
	.align 8
	.asciz "Gollum.\nHim and Dobby scared the shit out of me when I was younger. He looks like if a pug became human: Slimy as hell and MASSIVE eyes.\nAh also, his game sucks\n"
	gollum_len = . - gollum_msg
idiot_msg:
	.align 8
	.asciz "TYPE ONE OF THE GOD DAMN NUMBERS!!!!!!\n"
	idiot_len = . - idiot_msg
	
nice_restart_msg:
	.align 8
	.asciz "Do you wish to be enlightened once more? (y/n): "
	nice_restart_len = . - nice_restart_msg
idiot_restart_msg:
	.align 8
	.asciz "God DAMN it, wanna try again you absolute idiot?! (y/n): "
	idiot_restart_len = . - idiot_restart_msg
	
cls_msg:
	.align 8
	.asciz "\033[H\033[2J"
	cls_len = . - cls_msg
	
.section .bss
	.lcomm options_input, 16       #
	.lcomm nice_restart_input, 16  # IF THE USER OVERFLOWS IT, THEY'RE FAULT
	.lcomm idiot_restart_input, 16 #
	
.section .text
print_options:
	PRINT options_msg, options_len
	
	ret
	
get_options:
	READ options_input, 16
	movq %rax, %r8
	
	ret
	
trim_options_nl:
	TRIM_NL options_input, call_check_options
	
call_check_options:
	call check_options
	
	ret
	
check_options:
	cmpb $'1', (%r10)
	je frodo_call
	
	cmpb $'2', (%r10)
	je sam_call
	
	cmpb $'3', (%r10)
	je gandalf_call
	
	cmpb $'4', (%r10)
	je sauron_call
	
	cmpb $'5', (%r10)
	je bilbo_call
	
	cmpb $'6', (%r10)
	je gollum_call
	
	jmp idiot_call
	
frodo_call:
	call frodo_stuff
	ret
	
sam_call:
	call sam_stuff
	ret
	
gandalf_call:
	call gandalf_stuff
	ret
	
sauron_call:
	call sauron_stuff
	ret
	
bilbo_call:
	call bilbo_stuff
	ret
	
gollum_call:
	call gollum_stuff
	ret
	
idiot_call:
	call idiot_stuff
	ret
	
frodo_stuff:
	PRINT frodo_msg, frodo_len
	ret
	
sam_stuff:
	PRINT sam_msg, sam_len
	ret
	
gandalf_stuff:
	PRINT gandalf_msg, gandalf_len
	ret
	
sauron_stuff:
	PRINT sauron_msg, sauron_len
	ret
	
bilbo_stuff:
	PRINT bilbo_msg, bilbo_len
	ret
	
gollum_stuff:
	PRINT gollum_msg, gollum_len
	ret
	
idiot_stuff:
	PRINT idiot_msg, idiot_len

	call idiot_restart_stuff
	
nice_restart_stuff:
	PRINT nice_restart_msg, nice_restart_len
	
	READ nice_restart_input, 16
	movq %rax, %r8 # For length when trimming newline
	
	ret
nice_trim_restart_nl:
	TRIM_NL nice_restart_input, nice_finished 
	
nice_finished:
	jmp nice_restart_check
	
idiot_restart_stuff:
	PRINT idiot_restart_msg, idiot_restart_len
	
	READ idiot_restart_input, 16
	movq %rax, %r8 # for length when trimming newline
	
	call idiot_trim_restart_nl
	
idiot_trim_restart_nl:
	TRIM_NL idiot_restart_input, idiot_finished
	
idiot_finished:
	jmp idiot_restart_check
	
	.globl _start
_start:
loop:
	CLS
	call print_options
	
	call get_options
	call trim_options_nl
	
	call nice_restart_stuff
	call nice_trim_restart_nl
	
nice_restart_check:
	RESTART_CHECK nice_restart_input, nice_dumbass
idiot_restart_check:
	RESTART_CHECK idiot_restart_input, idiot_dumbass
	
nice_dumbass:
	call nice_restart_stuff
	call nice_trim_restart_nl
	jmp nice_restart_check
idiot_dumbass:
	call idiot_restart_stuff
	call idiot_trim_restart_nl
	jmp idiot_restart_check
	
restart:
	jmp loop
	
exit:
	EXIT 0
	
