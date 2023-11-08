	.file	"fir.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/ubuntu/SoC/lab4-2/testbench/counter_la_fir" "fir.c"
	.globl	taps
	.data
	.align	2
	.type	taps, @object
	.size	taps, 44
taps:
	.word	0
	.word	-10
	.word	-9
	.word	23
	.word	56
	.word	63
	.word	56
	.word	23
	.word	-9
	.word	-10
	.word	0
	.globl	outputsignal
	.bss
	.align	2
	.type	outputsignal, @object
	.size	outputsignal, 44
outputsignal:
	.zero	44
	.text
	.align	2
	.type	flush_cpu_icache, @function
flush_cpu_icache:
.LFB21:
	.file 1 "../../firmware/system.h"
	.loc 1 15 1
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,12(sp)
	.cfi_offset 8, -4
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 1 26 1
	nop
	lw	s0,12(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE21:
	.size	flush_cpu_icache, .-flush_cpu_icache
	.align	2
	.type	flush_cpu_dcache, @function
flush_cpu_dcache:
.LFB22:
	.loc 1 29 1
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,12(sp)
	.cfi_offset 8, -4
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 1 33 1
	nop
	lw	s0,12(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE22:
	.size	flush_cpu_dcache, .-flush_cpu_dcache
	.section	.mprjram,"ax",@progbits
	.align	2
	.globl	initfir
	.type	initfir, @function
initfir:
.LFB316:
	.file 2 "fir.c"
	.loc 2 11 61
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,12(sp)
	.cfi_offset 8, -4
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 2 14 5
	nop
	.loc 2 15 1
	lw	s0,12(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE316:
	.size	initfir, .-initfir
	.align	2
	.globl	fir
	.type	fir, @function
fir:
.LFB317:
	.loc 2 17 57
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sw	ra,44(sp)
	sw	s0,40(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	.loc 2 18 5
	call	initfir
	.loc 2 21 9
	li	a5,805306368
	lw	a5,0(a5)
	.loc 2 21 42
	andi	a5,a5,4
	.loc 2 21 7
	beq	a5,zero,.L6
.LBB2:
	.loc 2 22 7
	li	a5,805306368
	addi	a5,a5,16
	.loc 2 22 40
	li	a4,600
	sw	a4,0(a5)
	.loc 2 23 25
	li	a5,805306368
	addi	a5,a5,64
	sw	a5,-20(s0)
.LBB3:
	.loc 2 24 18
	sw	zero,-24(s0)
	.loc 2 24 9
	j	.L7
.L8:
	.loc 2 25 29 discriminator 3
	lui	a5,%hi(taps)
	addi	a4,a5,%lo(taps)
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 25 23 discriminator 3
	lw	a5,-20(s0)
	sw	a4,0(a5)
	.loc 2 26 21 discriminator 3
	lw	a5,-20(s0)
	addi	a5,a5,4
	sw	a5,-20(s0)
	.loc 2 24 30 discriminator 3
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L7:
	.loc 2 24 24 discriminator 1
	lw	a4,-24(s0)
	li	a5,10
	ble	a4,a5,.L8
.L6:
.LBE3:
.LBE2:
	.loc 2 29 6
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 29 39
	li	a4,-1421803520
	sw	a4,0(a5)
.LBB4:
	.loc 2 30 13
	sw	zero,-28(s0)
	.loc 2 30 5
	j	.L9
.L11:
	.loc 2 31 54
	nop
.L10:
	.loc 2 31 11
	li	a5,805306368
	lw	a5,0(a5)
	.loc 2 31 44
	andi	a5,a5,4
	.loc 2 31 8
	beq	a5,zero,.L11
	.loc 2 32 3
	li	a5,805306368
	.loc 2 32 36
	li	a4,1
	sw	a4,0(a5)
.LBB5:
	.loc 2 33 10
	li	a5,1
	sw	a5,-32(s0)
	.loc 2 33 2
	j	.L12
.L13:
	.loc 2 34 7 discriminator 3
	li	a5,805306368
	addi	a5,a5,128
	.loc 2 34 40 discriminator 3
	lw	a4,-32(s0)
	sw	a4,0(a5)
	.loc 2 35 43 discriminator 3
	li	a5,805306368
	addi	a5,a5,132
	lw	a4,0(a5)
	.loc 2 35 7 discriminator 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 35 76 discriminator 3
	slli	a4,a4,16
	.loc 2 35 40 discriminator 3
	sw	a4,0(a5)
	.loc 2 33 22 discriminator 3
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L12:
	.loc 2 33 16 discriminator 1
	lw	a4,-32(s0)
	li	a5,74
	ble	a4,a5,.L13
.LBE5:
.LBB6:
	.loc 2 37 10
	li	a5,75
	sw	a5,-36(s0)
	.loc 2 37 2
	j	.L14
.L15:
	.loc 2 38 7 discriminator 3
	li	a5,805306368
	addi	a5,a5,128
	.loc 2 38 40 discriminator 3
	lw	a4,-36(s0)
	sw	a4,0(a5)
	.loc 2 39 43 discriminator 3
	li	a5,805306368
	addi	a5,a5,132
	lw	a4,0(a5)
	.loc 2 39 7 discriminator 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 39 76 discriminator 3
	slli	a4,a4,16
	.loc 2 39 40 discriminator 3
	sw	a4,0(a5)
	.loc 2 37 24 discriminator 3
	lw	a5,-36(s0)
	addi	a5,a5,-1
	sw	a5,-36(s0)
.L14:
	.loc 2 37 17 discriminator 1
	lw	a4,-36(s0)
	li	a5,-74
	bge	a4,a5,.L15
.LBE6:
.LBB7:
	.loc 2 41 10
	li	a5,-75
	sw	a5,-40(s0)
	.loc 2 41 2
	j	.L16
.L17:
	.loc 2 42 7 discriminator 3
	li	a5,805306368
	addi	a5,a5,128
	.loc 2 42 40 discriminator 3
	lw	a4,-40(s0)
	sw	a4,0(a5)
	.loc 2 43 43 discriminator 3
	li	a5,805306368
	addi	a5,a5,132
	lw	a4,0(a5)
	.loc 2 43 7 discriminator 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 43 76 discriminator 3
	slli	a4,a4,16
	.loc 2 43 40 discriminator 3
	sw	a4,0(a5)
	.loc 2 41 24 discriminator 3
	lw	a5,-40(s0)
	addi	a5,a5,1
	sw	a5,-40(s0)
.L16:
	.loc 2 41 18 discriminator 1
	lw	a4,-40(s0)
	li	a5,74
	ble	a4,a5,.L17
.LBE7:
.LBB8:
	.loc 2 45 10
	li	a5,75
	sw	a5,-44(s0)
	.loc 2 45 2
	j	.L18
.L19:
	.loc 2 46 7 discriminator 3
	li	a5,805306368
	addi	a5,a5,128
	.loc 2 46 40 discriminator 3
	lw	a4,-44(s0)
	sw	a4,0(a5)
	.loc 2 47 43 discriminator 3
	li	a5,805306368
	addi	a5,a5,132
	lw	a4,0(a5)
	.loc 2 47 7 discriminator 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 47 76 discriminator 3
	slli	a4,a4,16
	.loc 2 47 40 discriminator 3
	sw	a4,0(a5)
	.loc 2 45 24 discriminator 3
	lw	a5,-44(s0)
	addi	a5,a5,-1
	sw	a5,-44(s0)
.L18:
	.loc 2 45 17 discriminator 1
	lw	a4,-44(s0)
	li	a5,-74
	bge	a4,a5,.L19
.LBE8:
.LBB9:
	.loc 2 49 10
	li	a5,-75
	sw	a5,-48(s0)
	.loc 2 49 2
	j	.L20
.L21:
	.loc 2 50 7 discriminator 3
	li	a5,805306368
	addi	a5,a5,128
	.loc 2 50 40 discriminator 3
	lw	a4,-48(s0)
	sw	a4,0(a5)
	.loc 2 51 43 discriminator 3
	li	a5,805306368
	addi	a5,a5,132
	lw	a4,0(a5)
	.loc 2 51 7 discriminator 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 51 76 discriminator 3
	slli	a4,a4,16
	.loc 2 51 40 discriminator 3
	sw	a4,0(a5)
	.loc 2 49 24 discriminator 3
	lw	a5,-48(s0)
	addi	a5,a5,1
	sw	a5,-48(s0)
.L20:
	.loc 2 49 18 discriminator 1
	lw	a5,-48(s0)
	ble	a5,zero,.L21
.LBE9:
	.loc 2 53 7
	j	.L22
.L23:
	.loc 2 53 53
	nop
.L22:
	.loc 2 53 11
	li	a5,805306368
	lw	a5,0(a5)
	.loc 2 53 44
	andi	a5,a5,2
	.loc 2 53 8
	beq	a5,zero,.L23
	.loc 2 30 24 discriminator 2
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L9:
	.loc 2 30 19 discriminator 1
	lw	a4,-28(s0)
	li	a5,2
	ble	a4,a5,.L10
.LBE4:
	.loc 2 58 12
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	.loc 2 59 1
	mv	a0,a5
	lw	ra,44(sp)
	.cfi_restore 1
	lw	s0,40(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE317:
	.size	fir, .-fir
	.text
.Letext0:
	.file 3 "fir.h"
	.file 4 "/opt/riscv/lib/gcc/riscv32-unknown-elf/12.1.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x1d4
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x8
	.4byte	.LASF16
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL0
	.4byte	0
	.4byte	.Ldebug_line0
	.byte	0x9
	.4byte	0x3d
	.4byte	0x36
	.byte	0xa
	.4byte	0x36
	.byte	0xa
	.byte	0
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF2
	.byte	0xb
	.byte	0x4
	.byte	0x5
	.string	"int"
	.byte	0x5
	.4byte	.LASF3
	.byte	0x6
	.4byte	0x26
	.byte	0x5
	.byte	0x3
	.4byte	taps
	.byte	0x5
	.4byte	.LASF4
	.byte	0x9
	.4byte	0x26
	.byte	0x5
	.byte	0x3
	.4byte	outputsignal
	.byte	0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF5
	.byte	0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF6
	.byte	0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF7
	.byte	0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF8
	.byte	0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF9
	.byte	0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF10
	.byte	0xc
	.4byte	.LASF17
	.byte	0x4
	.byte	0x34
	.byte	0x1b
	.4byte	0x9f
	.byte	0xd
	.4byte	0x8e
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF11
	.byte	0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF12
	.byte	0xe
	.string	"fir"
	.byte	0x2
	.byte	0x11
	.byte	0x33
	.4byte	0x19b
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.byte	0x1
	.byte	0x9c
	.4byte	0x19b
	.byte	0xf
	.4byte	.LASF18
	.byte	0x2
	.byte	0x14
	.byte	0x9
	.4byte	0x3d
	.byte	0x3
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.4byte	0x106
	.byte	0x10
	.4byte	.LASF13
	.byte	0x2
	.byte	0x17
	.byte	0x19
	.4byte	0x1a0
	.byte	0x2
	.byte	0x91
	.byte	0x6c
	.byte	0x4
	.4byte	.LBB3
	.4byte	.LBE3-.LBB3
	.byte	0x2
	.string	"i"
	.byte	0x18
	.byte	0x12
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0
	.byte	0
	.byte	0x4
	.4byte	.LBB4
	.4byte	.LBE4-.LBB4
	.byte	0x2
	.string	"j"
	.byte	0x1e
	.byte	0xd
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x64
	.byte	0x3
	.4byte	.LBB5
	.4byte	.LBE5-.LBB5
	.4byte	0x135
	.byte	0x2
	.string	"i"
	.byte	0x21
	.byte	0xa
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0
	.byte	0x3
	.4byte	.LBB6
	.4byte	.LBE6-.LBB6
	.4byte	0x14f
	.byte	0x2
	.string	"i"
	.byte	0x25
	.byte	0xa
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x5c
	.byte	0
	.byte	0x3
	.4byte	.LBB7
	.4byte	.LBE7-.LBB7
	.4byte	0x169
	.byte	0x2
	.string	"i"
	.byte	0x29
	.byte	0xa
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0
	.byte	0x3
	.4byte	.LBB8
	.4byte	.LBE8-.LBB8
	.4byte	0x183
	.byte	0x2
	.string	"i"
	.byte	0x2d
	.byte	0xa
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x54
	.byte	0
	.byte	0x4
	.4byte	.LBB9
	.4byte	.LBE9-.LBB9
	.byte	0x2
	.string	"i"
	.byte	0x31
	.byte	0xa
	.4byte	0x3d
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0
	.byte	0
	.byte	0
	.byte	0x6
	.4byte	0x3d
	.byte	0x6
	.4byte	0x9a
	.byte	0x11
	.4byte	.LASF19
	.byte	0x2
	.byte	0xb
	.byte	0x33
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.byte	0x1
	.byte	0x9c
	.byte	0x7
	.4byte	.LASF14
	.byte	0x1c
	.4byte	.LFB22
	.4byte	.LFE22-.LFB22
	.byte	0x1
	.byte	0x9c
	.byte	0x7
	.4byte	.LASF15
	.byte	0xe
	.4byte	.LFB21
	.4byte	.LFE21-.LFB21
	.byte	0x1
	.byte	0x9c
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.byte	0x1
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0xe
	.byte	0
	.byte	0
	.byte	0x2
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0x21
	.byte	0x2
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0x3
	.byte	0xb
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x4
	.byte	0xb
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0
	.byte	0
	.byte	0x5
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x3
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0x19
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0x6
	.byte	0xf
	.byte	0
	.byte	0xb
	.byte	0x21
	.byte	0x4
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x7
	.byte	0x2e
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0x25
	.byte	0x27
	.byte	0x19
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0x8
	.byte	0x11
	.byte	0x1
	.byte	0x25
	.byte	0xe
	.byte	0x13
	.byte	0xb
	.byte	0x3
	.byte	0x1f
	.byte	0x1b
	.byte	0x1f
	.byte	0x55
	.byte	0x17
	.byte	0x11
	.byte	0x1
	.byte	0x10
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0x9
	.byte	0x1
	.byte	0x1
	.byte	0x49
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xa
	.byte	0x21
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0x2f
	.byte	0xb
	.byte	0
	.byte	0
	.byte	0xb
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0
	.byte	0
	.byte	0xc
	.byte	0x16
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xd
	.byte	0x35
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xe
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7c
	.byte	0x19
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xf
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x10
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0x11
	.byte	0x2e
	.byte	0
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.4byte	0
	.4byte	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.LLRL0:
	.byte	0x6
	.4byte	.Ltext0
	.4byte	.Letext0
	.byte	0x6
	.4byte	.LFB316
	.4byte	.LFE316
	.byte	0x6
	.4byte	.LFB317
	.4byte	.LFE317
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF19:
	.string	"initfir"
.LASF14:
	.string	"flush_cpu_dcache"
.LASF9:
	.string	"unsigned char"
.LASF11:
	.string	"long unsigned int"
.LASF10:
	.string	"short unsigned int"
.LASF16:
	.string	"GNU C17 12.1.0 -mabi=ilp32 -mtune=rocket -misa-spec=2.2 -march=rv32i -g -ffreestanding"
.LASF18:
	.string	"test"
.LASF2:
	.string	"unsigned int"
.LASF3:
	.string	"taps"
.LASF12:
	.string	"long long unsigned int"
.LASF15:
	.string	"flush_cpu_icache"
.LASF4:
	.string	"outputsignal"
.LASF8:
	.string	"long long int"
.LASF13:
	.string	"tap_addr"
.LASF6:
	.string	"short int"
.LASF17:
	.string	"uint32_t"
.LASF7:
	.string	"long int"
.LASF5:
	.string	"signed char"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/ubuntu/SoC/lab4-2/testbench/counter_la_fir"
.LASF0:
	.string	"fir.c"
	.ident	"GCC: (g1ea978e3066) 12.1.0"
