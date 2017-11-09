	.globl matrix_prod
matrix_prod:
	pushq	%rbx				# push value in callee saved register %rbx onto stack
	movl	%ecx, %ebx			# move n into dummy register %rbx
	xorl	%ecx, %ecx			# set i to zero
	xorl	%r8d, %r8d			# set j to zero

loopi:
	cmpl	%ecx, %ebx			# for i = 0
	je		endloop				# i < n

loopj:
	cmpl	%r8d, %ebx			# for j = 0
	je		resetloop			# j < n

	pushq	%rdi                # preserve function values
	pushq	%rsi
	pushq	%rdx
	pushq	%rcx
	pushq	%r8

	movl	%ebx, %edx			# arg3 = n
	call	dot_prod			# call dot_prod

	movq	%rax, %rdi			# arg1 = return value of dot_prod
	movq	$17, %rsi			# arg2 = 17
	call	mod					# call mod

	popq	%r8					# restore function values
	popq	%rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi

	movq	%rax, (%rdx,%r8)	# append return value of mod() to C[i][j]

	incl	%r8d				# j++
	jmp		loopj				# restart loop j

resetloop:
	xorl	%r8d, %r8d			# reset j back to 0
	incl	%ecx				# i++
	leal	4(%edx), %edx		# point to C[i]
	jmp		loopi				# restart loop i

endloop:
	popq	%rbx				# pop original value of %rbx back into %rbx
	ret

/* LEGEND:
rdi = 1st arg = *A
rsi = 2nd arg = *B
rdx = 3rd arg = *C
rcx = 4th arg = n
r8 = 5th arg
r9 = 6th arg
rax = return value

void matrix_prod(void *A, void *B, void *C, int n);
long dot_prod(void *A, void *B, int n, int i, int j);
unsigned char mod(long x, unsigned char m);
*/
