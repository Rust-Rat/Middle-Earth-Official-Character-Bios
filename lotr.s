.section .data

start_msg:
	.asciz "Who do you want info about?\n1. Frodo\n2. Fat dude\n3. Gandalf\n4. Big eye man\n"
	start_len = . - start_msg
frodo_msg:
	.asciz "Frodo.\nShort man. Furry feet (Secretly a furry). Looks 50 and 12. Short Irish bloke.\n"
	frodo_len = . - frodo_msg
fatguy_msg:
	.asciz "Fat Dude.\nAlso of the Short man genus, accompanied by the furry feet. Is blonde and has maybe had a few too many breakfastses. Also a short Irish bloke.\n"
	fatguy_len = . - fatguy_msg
gandalf_msg:
	.asciz "Gandalf.\nNOT a short man, a big... Normal sized man I think, he likes to play around and say 'YOU SHALL NOT PASS!!!!' I'm pretty sure, also I think his beard looks pretty cool.\n"
	gandalf_len = . - gandalf_msg
sauron_msg:
	.asciz "Sauron.\nBIG EYE MAN. he's just this big plague infested eye, his name is SIIICCK though. Idk what an eye can do though, I feel like it would just self destruct.\n"
	sauron_len = . - sauron_msg
idiot_msg:
	.asciz "TYPE ONE OF THE GOD DAMN NUMBERS!!!!!!\n"
	idiot_len = . - idiot_msg

restart_msg:
	.asciz "\nDo you wish to be enlightened again? (y/n): "
	restart_len = . - restart_msg

cls_msg:
	.asciz "\033[H\033[2J"
	cls_len = . - cls_msg

.section .bss
	.lcomm input, 16
	.lcomm restart_input, 16

.section .text

print_options:
	call cls
	
	movq $1, %rax
	movq $1, %rdi
	lea start_msg(%rip), %rsi
	movq $start_len, %rdx
	syscall
	
	ret

get_options:
	movq $0, %rax
	movq $0, %rdi
	lea input(%rip), %rsi
	movq $16, %rdx
	syscall

	ret

trim_nl_input:
	lea input(%rip), %r10
	movq %rax, %r8 # len of 'input'
	dec %r8       # dec by 1 bc last is '\n'
	
	movb (%r10,%r8,1), %r9b
	cmpb $0x0A, %r9b
	jne input_return
	movb $0, (%r10,%r8,1)
	dec %r8
	
input_return:
	ret

trim_nl_restart:
	lea restart_input(%rip), %r10
	movq %rax, %r8
	dec %r8
	
	movb (%r10,%r8,1), %r9b
	cmpb $0x0A, %r9b
	jne restart_return
	movb $0, (%r10,%r8,1)

restart_return:
	ret

compare_everything:
	call cls
	
	cmpb $'1', (%r10)
	je frodo_info
	
	cmpb $'2', (%r10)
	je fatguy_info
	
	cmpb $'3', (%r10)
        je gandalf_info

	cmpb $'4', (%r10)
        je sauron_info
	
	jmp idiot_info

frodo_info:
	movq $1, %rax
	movq $1, %rdi
	lea frodo_msg(%rip), %rsi
	movq $frodo_len, %rdx
	syscall
	
	ret

fatguy_info:
	movq $1, %rax
        movq $1, %rdi
        lea fatguy_msg(%rip), %rsi
        movq $fatguy_len, %rdx
        syscall
	
	ret

gandalf_info:
	movq $1, %rax
        movq $1, %rdi
        lea gandalf_msg(%rip), %rsi
        movq $gandalf_len, %rdx
        syscall

	ret

sauron_info:
	movq $1, %rax
        movq $1, %rdi
        lea sauron_msg(%rip), %rsi
        movq $sauron_len, %rdx
        syscall

	ret

idiot_info:
	movq $1, %rax
        movq $1, %rdi
        lea idiot_msg(%rip), %rsi
        movq $idiot_len, %rdx
        syscall
	
	ret

cls:
	movq $1, %rax
	movq $1, %rdi
	lea cls_msg(%rip), %rsi
	movq $cls_len, %rdx
	syscall
	
	ret

restart_check:
	movq $1, %rax
	movq $1, %rdi
	lea restart_msg(%rip), %rsi
	movq $restart_len, %rdx
	syscall
	
	movq $0, %rax
	movq $0, %rdi
	lea restart_input(%rip), %rsi
	movq $16, %rdx
	syscall
	
	ret
exit:
	movq $60, %rax
	xorq %rdi, %rdi
	syscall


	.globl _start
_start:
loop:
	call print_options
	call get_options
	
	call trim_nl_input
	call compare_everything
	
	call restart_check
	call trim_nl_restart
	
	lea restart_input(%rip), %r10
	cmpb $'y', (%r10)
	je loop
	cmpb $'Y', (%r10)
	je loop
	
	call exit
