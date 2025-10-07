.section .data
options_msg:
	.asciz "Who do you want info about?\n1. Frodo\n2. Sam\n3. Gandalf\n4. Big eye man\n5. Bilbo\n6. Gollum\n"
	options_len = . - options_msg
frodo_msg:
	.asciz "Frodo.\nShort man. Furry feet (Secretly a furry). Looks 50 and 12. Short Irish bloke.\n"
	frodo_len = . - frodo_msg
sam_msg:
	.asciz "Sam (AKA. Fat Dude).\nAlso of the Short man genus, accompanied by the furry feet. Is blonde and has maybe had a few too many breakfastses. Also a short Irish bloke.\n"
        sam_len = . - sam_msg
gandalf_msg:
	.asciz "Gandalf.\nNOT a short man, a big... Normal sized man I think, he likes to play around and say 'YOU SHALL NOT PASS!!' I'm pretty sure, also I think his beard looks pretty cool.\n"
	gandalf_len = . - gandalf_msg
sauron_msg:
	.asciz "Sauron.\nBIG EYE MAN. he's just this big plague infested eye, his name is SIIICCK though. I don't know what an eye can do though, I feel like it would just self destruct.\n"
	sauron_len = . - sauron_msg
bilbo_msg:
	.asciz "Bilbo.\nDumbass name; \"ooo my name is Bilbo\", man SHUT UP!!! I don't even know what he looks like, like an old greasy man I think. And he has some ring that he probably stole.\n"
	bilbo_len = . - bilbo_msg
gollum_msg:
	.asciz "Gollum.\nHim and Dobby scared the shit out of me when I was younger. He looks like if a pug became human: Slimy as hell and MASSIVE eyes.\nAh also, his game sucks\n"
	gollum_len = . - gollum_msg
idiot_msg:
	.asciz "TYPE ONE OF THE GOD DAMN NUMBERS!!!!!!\n"
	idiot_len = . - idiot_msg

nice_restart_msg:
	.asciz "Do you wish to be enlightened once more? (y/n): "
	nice_restart_len = . - nice_restart_msg
idiot_restart_msg:
	.asciz "God DAMN it, wanna try again you absolute idiot?! (y/n): "
	idiot_restart_len = . - idiot_restart_msg

cls_msg:
	.asciz "\033[H\033[2J"
	cls_len = . - cls_msg

.section .bss
	.lcomm options_input, 16
	.lcomm nice_restart_input, 16
	.lcomm idiot_restart_input, 16

.section .text
print_options:
	movq $1, %rax
	movq $1, %rdi
	lea options_msg(%rip), %rsi
	movq $options_len, %rdx
	syscall

	ret

get_options:
	movq $0, %rax
	movq $0, %rdi
	lea options_input(%rip), %rsi
	movq $16, %rdx
	syscall
	movq %rax, %r8 # len for trim_options_nl

	ret

trim_options_nl:
	lea options_input(%rip), %r10
	dec %r8
	
	movb (%r10,%r8,1), %r9b
	cmpb $0x0A, %r9b
	je call_check_options
	
	movb $0, %r9b
	dec %r8
	jmp call_check_options

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
	movq $1, %rax
	movq $1, %rdi
	lea frodo_msg(%rip), %rsi
	movq $frodo_len, %rdx
	syscall

	ret

sam_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea sam_msg(%rip), %rsi
	movq $sam_len, %rdx
	syscall
	
	ret

gandalf_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea gandalf_msg(%rip), %rsi
	movq $gandalf_len, %rdx
	syscall

	ret

sauron_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea sauron_msg(%rip), %rsi
	movq $sauron_len, %rdx
	syscall

	ret
bilbo_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea bilbo_msg(%rip), %rsi
	movq $bilbo_len, %rdx
	syscall

	ret

gollum_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea gollum_msg(%rip), %rsi
	movq $gollum_len, %rdx
	syscall

	ret

idiot_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea idiot_msg(%rip), %rsi
	movq $idiot_len, %rdx
	syscall

	call idiot_restart_stuff

nice_restart_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea nice_restart_msg(%rip), %rsi
	movq $nice_restart_len, %rdx
	syscall

	movq $0, %rax
	movq $0, %rdi

	lea nice_restart_input(%rip), %rsi
	movq $16, %rdx
	syscall
	movq %rax, %r8

	ret
nice_trim_restart_nl:
	lea nice_restart_input(%rip), %r10
	dec %r8 # r8 = \0; - 1 r8 = last_char
	
	movb (%r10,%r8,1), %r9b
	cmpb $0x0A, %r9b
	jne nice_finished
	
	movb $0, %r9b

nice_finished:
	jmp nice_restart_check
	ret

idiot_restart_stuff:
	movq $1, %rax
	movq $1, %rdi
	lea idiot_restart_msg(%rip), %rsi
	movq $idiot_restart_len, %rdx
	syscall
	
	movq $0, %rax
	movq $0, %rdi
	lea idiot_restart_input(%rip), %rsi
	movq $16, %rdx
	syscall
	movq %rax, %r8

	call idiot_trim_restart_nl
	ret

idiot_trim_restart_nl:
	lea idiot_restart_input(%rip), %r10
	dec %r8

	movb (%r10,%r8,1), %r9b
	cmpb $0x0A, %r9b
	jmp idiot_finished

	movb $0, %r9b
	
idiot_finished:
	jmp idiot_restart_check
	ret
	
cls:
	movq $1, %rax
	movq $1, %rdi
	lea cls_msg(%rip), %rsi
	mov $cls_len, %rdx
	syscall

	ret
end:
	movq $60, %rax
	xorq %rdi, %rdi
	syscall

	.globl _start
_start:
loop:
	call cls
	call print_options
	
	call get_options
	call trim_options_nl

	call nice_restart_stuff
	call nice_trim_restart_nl

nice_restart_check:
	lea nice_restart_input(%rip), %r10
	cmpb $'y', (%r10)
	je restart
	cmpb $'Y', (%r10)
	je restart
	
	cmpb $'n', (%r10)
	je exit
	cmpb $'N', (%r10)
	je exit

	jmp nice_dumbass

idiot_restart_check:
	lea idiot_restart_input(%rip), %r10
        cmpb $'y', (%r10)
        je restart
        cmpb $'Y', (%r10)
        je restart

        cmpb $'n', (%r10)
        je exit
        cmpb $'N', (%r10)
        je exit

        jmp idiot_dumbass

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
	call end

