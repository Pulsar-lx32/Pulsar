	.file	"11_run_custom_intrinsics.c"
	.text
	.globl	test_pulsar_custom_isa          # -- Begin function test_pulsar_custom_isa
	.type	test_pulsar_custom_isa,@function
test_pulsar_custom_isa:                 # @test_pulsar_custom_isa
# %bb.0:
	addi	x2, x2, -16
	addi	x11, x0, 3
	lx.sensor	x11, x11
	addi	x12, x2, 12
	sw	x11, 0(x12)
	lx.matrix	x12, x0
	addi	x11, x2, 8
	sw	x12, 0(x11)
	addi	x12, x0, 42
	lx.delta	x13, x12
	addi	x14, x2, 4
	sw	x13, 0(x14)
	lx.chord	x12, x12
	addi	x13, x2, 0
	sw	x12, 0(x13)
	addi	x12, x0, 10
	lx.wait	x12
	lw	x11, 0(x11)
	lx.report	x11
	addi	x2, x2, 16
	jalr	x0, 0(x1)
.Lfunc_end0:
	.size	test_pulsar_custom_isa, .Lfunc_end0-test_pulsar_custom_isa
                                        # -- End function
	.globl	main                            # -- Begin function main
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	x2, x2, -4
	sw	x1, 0(x2)
	jal	x1, <expr>
	addi	x10, x0, 0
	lw	x1, 0(x2)
	addi	x2, x2, 4
	jalr	x0, 0(x1)
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.ident	"clang version 23.0.0git (https://github.com/Axel84727/llvm-project-lx32.git 1124aa5a463f0d88df752564ca79023d0f690e60)"
	.section	".note.GNU-stack","",@progbits
