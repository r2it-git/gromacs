;#
;# $Id$
;#
;# Gromacs 4.0                         Copyright (c) 1991-2003 
;# David van der Spoel, Erik Lindahl
;#
;# This program is free software; you can redistribute it and/or
;# modify it under the terms of the GNU General Public License
;# as published by the Free Software Foundation; either version 2
;# of the License, or (at your option) any later version.
;#
;# To help us fund GROMACS development, we humbly ask that you cite
;# the research papers on the package. Check out http://www.gromacs.org
;# 
;# And Hey:
;# Gnomes, ROck Monsters And Chili Sauce
;#

;# These files require GNU binutils 2.10 or later, since we
;# use intel syntax for portability, or a recent version 
;# of NASM that understands Extended 3DNow and SSE2 instructions.
;# (NASM is normally only used with MS Visual C++).
;# Since NASM and gnu as disagree on some definitions and use 
;# completely different preprocessing options I have to introduce a
;# trick: NASM uses ';' for comments, while gnu as uses '#' on x86.
;# Gnu as treats ';' as a line break, i.e. ignores it. This is the
;# reason why all comments need both symbols...
;# The source is written for GNU as, with intel syntax. When you use
;# NASM we redefine a couple of things. The false if-statement around 
;# the following code is seen by GNU as, but NASM doesn't see it, so 
;# the code inside is read by NASM but not gcc.

; .if 0    # block below only read by NASM
%define .section	section
%define .long		dd
%define .align		align
%define .globl		global
;# NASM only wants 'dword', not 'dword ptr'.
%define ptr
.equiv          .equiv                  2
   %1 equ %2
%endmacro
; .endif                   # End of NASM-specific block
; .intel_syntax noprefix   # Line only read by gnu as


	
.globl nb_kernel312_x86_64_sse2
.globl _nb_kernel312_x86_64_sse2
nb_kernel312_x86_64_sse2:	
_nb_kernel312_x86_64_sse2:	
;#	Room for return address and rbp (16 bytes)
.equiv          nb312_fshift,           16
.equiv          nb312_gid,              24
.equiv          nb312_pos,              32
.equiv          nb312_faction,          40
.equiv          nb312_charge,           48
.equiv          nb312_p_facel,          56
.equiv          nb312_argkrf,           64
.equiv          nb312_argcrf,           72
.equiv          nb312_Vc,               80
.equiv          nb312_type,             88
.equiv          nb312_p_ntype,          96
.equiv          nb312_vdwparam,         104
.equiv          nb312_Vvdw,             112
.equiv          nb312_p_tabscale,       120
.equiv          nb312_VFtab,            128
.equiv          nb312_invsqrta,         136
.equiv          nb312_dvda,             144
.equiv          nb312_p_gbtabscale,     152
.equiv          nb312_GBtab,            160
.equiv          nb312_p_nthreads,       168
.equiv          nb312_count,            176
.equiv          nb312_mtx,              184
.equiv          nb312_outeriter,        192
.equiv          nb312_inneriter,        200
.equiv          nb312_work,             208
	;# stack offsets for local variables  
	;# bottom of stack is cache-aligned for sse2 use 
.equiv          nb312_ixO,              0
.equiv          nb312_iyO,              16
.equiv          nb312_izO,              32
.equiv          nb312_ixH1,             48
.equiv          nb312_iyH1,             64
.equiv          nb312_izH1,             80
.equiv          nb312_ixH2,             96
.equiv          nb312_iyH2,             112
.equiv          nb312_izH2,             128
.equiv          nb312_jxO,              144
.equiv          nb312_jyO,              160
.equiv          nb312_jzO,              176
.equiv          nb312_jxH1,             192
.equiv          nb312_jyH1,             208
.equiv          nb312_jzH1,             224
.equiv          nb312_jxH2,             240
.equiv          nb312_jyH2,             256
.equiv          nb312_jzH2,             272
.equiv          nb312_dxOO,             288
.equiv          nb312_dyOO,             304
.equiv          nb312_dzOO,             320
.equiv          nb312_dxOH1,            336
.equiv          nb312_dyOH1,            352
.equiv          nb312_dzOH1,            368
.equiv          nb312_dxOH2,            384
.equiv          nb312_dyOH2,            400
.equiv          nb312_dzOH2,            416
.equiv          nb312_dxH1O,            432
.equiv          nb312_dyH1O,            448
.equiv          nb312_dzH1O,            464
.equiv          nb312_dxH1H1,           480
.equiv          nb312_dyH1H1,           496
.equiv          nb312_dzH1H1,           512
.equiv          nb312_dxH1H2,           528
.equiv          nb312_dyH1H2,           544
.equiv          nb312_dzH1H2,           560
.equiv          nb312_dxH2O,            576
.equiv          nb312_dyH2O,            592
.equiv          nb312_dzH2O,            608
.equiv          nb312_dxH2H1,           624
.equiv          nb312_dyH2H1,           640
.equiv          nb312_dzH2H1,           656
.equiv          nb312_dxH2H2,           672
.equiv          nb312_dyH2H2,           688
.equiv          nb312_dzH2H2,           704
.equiv          nb312_qqOO,             720
.equiv          nb312_qqOH,             736
.equiv          nb312_qqHH,             752
.equiv          nb312_two,              768
.equiv          nb312_tsc,              784
.equiv          nb312_c6,               800
.equiv          nb312_c12,              816
.equiv          nb312_six,              832
.equiv          nb312_twelve,           848
.equiv          nb312_vctot,            864
.equiv          nb312_Vvdwtot,          880
.equiv          nb312_fixO,             896
.equiv          nb312_fiyO,             912
.equiv          nb312_fizO,             928
.equiv          nb312_fixH1,            944
.equiv          nb312_fiyH1,            960
.equiv          nb312_fizH1,            976
.equiv          nb312_fixH2,            992
.equiv          nb312_fiyH2,            1008
.equiv          nb312_fizH2,            1024
.equiv          nb312_fjxO,             1040
.equiv          nb312_fjyO,             1056
.equiv          nb312_fjzO,             1072
.equiv          nb312_fjxH1,            1088
.equiv          nb312_fjyH1,            1104
.equiv          nb312_fjzH1,            1120
.equiv          nb312_fjxH2,            1136
.equiv          nb312_fjyH2,            1152
.equiv          nb312_fjzH2,            1168
.equiv          nb312_half,             1184
.equiv          nb312_three,            1200
.equiv          nb312_rsqOO,            1216
.equiv          nb312_rsqOH1,           1232
.equiv          nb312_rsqOH2,           1248
.equiv          nb312_rsqH1O,           1264
.equiv          nb312_rsqH1H1,          1280
.equiv          nb312_rsqH1H2,          1296
.equiv          nb312_rsqH2O,           1312
.equiv          nb312_rsqH2H1,          1328
.equiv          nb312_rsqH2H2,          1344
.equiv          nb312_rinvOO,           1360
.equiv          nb312_rinvOH1,          1376
.equiv          nb312_rinvOH2,          1392
.equiv          nb312_rinvH1O,          1408
.equiv          nb312_rinvH1H1,         1424
.equiv          nb312_rinvH1H2,         1440
.equiv          nb312_rinvH2O,          1456
.equiv          nb312_rinvH2H1,         1472
.equiv          nb312_rinvH2H2,         1488
.equiv          nb312_fstmp,            1504
.equiv          nb312_is3,              1520
.equiv          nb312_ii3,              1524
.equiv          nb312_nri,              1528
.equiv          nb312_iinr,             1536
.equiv          nb312_jindex,           1544
.equiv          nb312_jjnr,             1552
.equiv          nb312_shift,            1560
.equiv          nb312_shiftvec,         1568
.equiv          nb312_facel,            1576
.equiv          nb312_innerjjnr,        1584
.equiv          nb312_innerk,           1592
.equiv          nb312_n,                1596
.equiv          nb312_nn1,              1600
.equiv          nb312_nouter,           1604
.equiv          nb312_ninner,           1608
	push rbp
	mov  rbp, rsp
	push rbx	
	femms
	sub rsp, 1624		;# local variable stack space (n*16+8)

	;# zero 32-bit iteration counters
	mov eax, 0
	mov [rsp + nb312_nouter], eax
	mov [rsp + nb312_ninner], eax

	mov edi, [rdi]
	mov [rsp + nb312_nri], edi
	mov [rsp + nb312_iinr], rsi
	mov [rsp + nb312_jindex], rdx
	mov [rsp + nb312_jjnr], rcx
	mov [rsp + nb312_shift], r8
	mov [rsp + nb312_shiftvec], r9
	mov rsi, [rbp + nb312_p_facel]
	movsd xmm0, [rsi]
	movsd [rsp + nb312_facel], xmm0

	mov rax, [rbp + nb312_p_tabscale]
	movsd xmm3, [rax]
	shufpd xmm3, xmm3, 0
	movapd [rsp + nb312_tsc], xmm3

	;# create constant floating-point factors on stack
	mov eax, 0x00000000     ;# lower half of double half IEEE (hex)
	mov ebx, 0x3fe00000
	mov [rsp + nb312_half], eax
	mov [rsp + nb312_half + 4], ebx
	movsd xmm1, [rsp + nb312_half]
	shufpd xmm1, xmm1, 0    ;# splat to all elements
	movapd xmm3, xmm1
	addpd  xmm3, xmm3       ;# one
	movapd xmm2, xmm3
	addpd  xmm2, xmm2       ;# two
	addpd  xmm3, xmm2	;# three
	movapd xmm4, xmm3
	addpd  xmm4, xmm4       ;# six
	movapd xmm5, xmm4
	addpd  xmm5, xmm5       ;# twelve
	movapd [rsp + nb312_half], xmm1
	movapd [rsp + nb312_two], xmm2
	movapd [rsp + nb312_three], xmm3
	movapd [rsp + nb312_six], xmm4
	movapd [rsp + nb312_twelve], xmm5

	;# assume we have at least one i particle - start directly 
	mov   rcx, [rsp + nb312_iinr]       ;# rcx = pointer into iinr[] 	
	mov   ebx, [rcx]	    ;# ebx =ii 

	mov   rdx, [rbp + nb312_charge]
	movsd xmm3, [rdx + rbx*8]	
	movsd xmm4, xmm3	
	movsd xmm5, [rdx + rbx*8 + 8]	
	mov rsi, [rbp + nb312_p_facel]
	movsd xmm0, [rsi]
	movsd xmm6, [rsp + nb312_facel]
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm5
	mulsd  xmm5, xmm5
	mulsd  xmm3, xmm6
	mulsd  xmm4, xmm6
	mulsd  xmm5, xmm6
	shufpd xmm3, xmm3, 0
	shufpd xmm4, xmm4, 0
	shufpd xmm5, xmm5, 0
	movapd [rsp + nb312_qqOO], xmm3
	movapd [rsp + nb312_qqOH], xmm4
	movapd [rsp + nb312_qqHH], xmm5
	
	xorpd xmm0, xmm0
	mov   rdx, [rbp + nb312_type]
	mov   ecx, [rdx + rbx*4]
	shl   ecx, 1
	mov   edx, ecx
	mov rdi, [rbp + nb312_p_ntype]
	imul  ecx, [rdi]      ;# rcx = ntia = 2*ntype*type[ii0] 
	add   edx, ecx
	mov   rax, [rbp + nb312_vdwparam]
	movlpd xmm0, [rax + rdx*8] 
	movlpd xmm1, [rax + rdx*8 + 8] 
	shufpd xmm0, xmm0, 0
	shufpd xmm1, xmm1, 0
	movapd [rsp + nb312_c6], xmm0
	movapd [rsp + nb312_c12], xmm1

.nb312_threadloop:
        mov   rsi, [rbp + nb312_count]          ;# pointer to sync counter
        mov   eax, [rsi]
.nb312_spinlock:
        mov   ebx, eax                          ;# ebx=*count=nn0
        add   ebx, 1                           ;# ebx=nn1=nn0+10
        lock cmpxchg [rsi], ebx                 ;# write nn1 to *counter,
                                                ;# if it hasnt changed.
                                                ;# or reread *counter to eax.
        pause                                   ;# -> better p4 performance
        jnz .nb312_spinlock

        ;# if(nn1>nri) nn1=nri
        mov ecx, [rsp + nb312_nri]
        mov edx, ecx
        sub ecx, ebx
        cmovle ebx, edx                         ;# if(nn1>nri) nn1=nri
        ;# Cleared the spinlock if we got here.
        ;# eax contains nn0, ebx contains nn1.
        mov [rsp + nb312_n], eax
        mov [rsp + nb312_nn1], ebx
        sub ebx, eax                            ;# calc number of outer lists
	mov esi, eax				;# copy n to esi
        jg  .nb312_outerstart
        jmp .nb312_end

.nb312_outerstart:
	;# ebx contains number of outer iterations
	add ebx, [rsp + nb312_nouter]
	mov [rsp + nb312_nouter], ebx

.nb312_outer:
	mov   rax, [rsp + nb312_shift]      ;# rax = pointer into shift[] 
	mov   ebx, [rax + rsi*4]		;# rbx=shift[n] 
	
	lea   rbx, [rbx + rbx*2]    ;# rbx=3*is 
	mov   [rsp + nb312_is3],ebx    	;# store is3 

	mov   rax, [rsp + nb312_shiftvec]   ;# rax = base of shiftvec[] 

	movsd xmm0, [rax + rbx*8]
	movsd xmm1, [rax + rbx*8 + 8]
	movsd xmm2, [rax + rbx*8 + 16] 

	mov   rcx, [rsp + nb312_iinr]       ;# rcx = pointer into iinr[] 	
	mov   ebx, [rcx + rsi*4]	    ;# ebx =ii 

	lea   rbx, [rbx + rbx*2]	;# rbx = 3*ii=ii3 
	mov   rax, [rbp + nb312_pos]    ;# rax = base of pos[]  
	mov   [rsp + nb312_ii3], ebx	
	
	movapd xmm3, xmm0
	movapd xmm4, xmm1
	movapd xmm5, xmm2
	addsd xmm3, [rax + rbx*8]
	addsd xmm4, [rax + rbx*8 + 8]
	addsd xmm5, [rax + rbx*8 + 16]		
	shufpd xmm3, xmm3, 0
	shufpd xmm4, xmm4, 0
	shufpd xmm5, xmm5, 0
	movapd [rsp + nb312_ixO], xmm3
	movapd [rsp + nb312_iyO], xmm4
	movapd [rsp + nb312_izO], xmm5

	movsd xmm3, xmm0
	movsd xmm4, xmm1
	movsd xmm5, xmm2
	addsd xmm0, [rax + rbx*8 + 24]
	addsd xmm1, [rax + rbx*8 + 32]
	addsd xmm2, [rax + rbx*8 + 40]		
	addsd xmm3, [rax + rbx*8 + 48]
	addsd xmm4, [rax + rbx*8 + 56]
	addsd xmm5, [rax + rbx*8 + 64]		

	shufpd xmm0, xmm0, 0
	shufpd xmm1, xmm1, 0
	shufpd xmm2, xmm2, 0
	shufpd xmm3, xmm3, 0
	shufpd xmm4, xmm4, 0
	shufpd xmm5, xmm5, 0
	movapd [rsp + nb312_ixH1], xmm0
	movapd [rsp + nb312_iyH1], xmm1
	movapd [rsp + nb312_izH1], xmm2
	movapd [rsp + nb312_ixH2], xmm3
	movapd [rsp + nb312_iyH2], xmm4
	movapd [rsp + nb312_izH2], xmm5

	;# clear vctot and i forces 
	xorpd xmm4, xmm4
	movapd [rsp + nb312_vctot], xmm4
	movapd [rsp + nb312_Vvdwtot], xmm4
	movapd [rsp + nb312_fixO], xmm4
	movapd [rsp + nb312_fiyO], xmm4
	movapd [rsp + nb312_fizO], xmm4
	movapd [rsp + nb312_fixH1], xmm4
	movapd [rsp + nb312_fiyH1], xmm4
	movapd [rsp + nb312_fizH1], xmm4
	movapd [rsp + nb312_fixH2], xmm4
	movapd [rsp + nb312_fiyH2], xmm4
	movapd [rsp + nb312_fizH2], xmm4
	
	mov   rax, [rsp + nb312_jindex]
	mov   ecx, [rax + rsi*4]	     ;# jindex[n] 
	mov   edx, [rax + rsi*4 + 4]	     ;# jindex[n+1] 
	sub   edx, ecx               ;# number of innerloop atoms 

	mov   rsi, [rbp + nb312_pos]
	mov   rdi, [rbp + nb312_faction]	
	mov   rax, [rsp + nb312_jjnr]
	shl   ecx, 2
	add   rax, rcx
	mov   [rsp + nb312_innerjjnr], rax     ;# pointer to jjnr[nj0] 
	mov   ecx, edx
	sub   edx,  2
	add   ecx, [rsp + nb312_ninner]
	mov   [rsp + nb312_ninner], ecx
	add   edx, 0
	mov   [rsp + nb312_innerk], edx    ;# number of innerloop atoms 
	jge   .nb312_unroll_loop
	jmp   .nb312_checksingle
.nb312_unroll_loop:	
	;# twice unrolled innerloop here 
	mov   rdx, [rsp + nb312_innerjjnr]     ;# pointer to jjnr[k] 
	mov   eax, [rdx]	
	mov   ebx, [rdx + 4] 
	
	add qword ptr [rsp + nb312_innerjjnr], 8 ;# advance pointer (unrolled 2) 

	mov rsi, [rbp + nb312_pos]       ;# base of pos[] 

	lea   rax, [rax + rax*2]     ;# replace jnr with j3 
	lea   rbx, [rbx + rbx*2]	
	
	;# move j coordinates to local temp variables 
	movlpd xmm2, [rsi + rax*8]
	movlpd xmm3, [rsi + rax*8 + 8]
	movlpd xmm4, [rsi + rax*8 + 16]
	movlpd xmm5, [rsi + rax*8 + 24]
	movlpd xmm6, [rsi + rax*8 + 32]
	movlpd xmm7, [rsi + rax*8 + 40]
	movhpd xmm2, [rsi + rbx*8]
	movhpd xmm3, [rsi + rbx*8 + 8]
	movhpd xmm4, [rsi + rbx*8 + 16]
	movhpd xmm5, [rsi + rbx*8 + 24]
	movhpd xmm6, [rsi + rbx*8 + 32]
	movhpd xmm7, [rsi + rbx*8 + 40]
	movapd 	[rsp + nb312_jxO], xmm2
	movapd 	[rsp + nb312_jyO], xmm3
	movapd 	[rsp + nb312_jzO], xmm4
	movapd 	[rsp + nb312_jxH1], xmm5
	movapd 	[rsp + nb312_jyH1], xmm6
	movapd 	[rsp + nb312_jzH1], xmm7
	movlpd xmm2, [rsi + rax*8 + 48]
	movlpd xmm3, [rsi + rax*8 + 56]
	movlpd xmm4, [rsi + rax*8 + 64]
	movhpd xmm2, [rsi + rbx*8 + 48]
	movhpd xmm3, [rsi + rbx*8 + 56]
	movhpd xmm4, [rsi + rbx*8 + 64]
	movapd 	[rsp + nb312_jxH2], xmm2
	movapd 	[rsp + nb312_jyH2], xmm3
	movapd 	[rsp + nb312_jzH2], xmm4
	
	movapd xmm0, [rsp + nb312_ixO]
	movapd xmm1, [rsp + nb312_iyO]
	movapd xmm2, [rsp + nb312_izO]
	movapd xmm3, [rsp + nb312_ixO]
	movapd xmm4, [rsp + nb312_iyO]
	movapd xmm5, [rsp + nb312_izO]
	subpd  xmm0, [rsp + nb312_jxO]
	subpd  xmm1, [rsp + nb312_jyO]
	subpd  xmm2, [rsp + nb312_jzO]
	subpd  xmm3, [rsp + nb312_jxH1]
	subpd  xmm4, [rsp + nb312_jyH1]
	subpd  xmm5, [rsp + nb312_jzH1]
	movapd [rsp + nb312_dxOO], xmm0
	movapd [rsp + nb312_dyOO], xmm1
	movapd [rsp + nb312_dzOO], xmm2
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	movapd [rsp + nb312_dxOH1], xmm3
	movapd [rsp + nb312_dyOH1], xmm4
	movapd [rsp + nb312_dzOH1], xmm5
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm3, xmm4
	addpd  xmm3, xmm5
	movapd [rsp + nb312_rsqOO], xmm0
	movapd [rsp + nb312_rsqOH1], xmm3

	movapd xmm0, [rsp + nb312_ixO]
	movapd xmm1, [rsp + nb312_iyO]
	movapd xmm2, [rsp + nb312_izO]
	movapd xmm3, [rsp + nb312_ixH1]
	movapd xmm4, [rsp + nb312_iyH1]
	movapd xmm5, [rsp + nb312_izH1]
	subpd  xmm0, [rsp + nb312_jxH2]
	subpd  xmm1, [rsp + nb312_jyH2]
	subpd  xmm2, [rsp + nb312_jzH2]
	subpd  xmm3, [rsp + nb312_jxO]
	subpd  xmm4, [rsp + nb312_jyO]
	subpd  xmm5, [rsp + nb312_jzO]
	movapd [rsp + nb312_dxOH2], xmm0
	movapd [rsp + nb312_dyOH2], xmm1
	movapd [rsp + nb312_dzOH2], xmm2
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	movapd [rsp + nb312_dxH1O], xmm3
	movapd [rsp + nb312_dyH1O], xmm4
	movapd [rsp + nb312_dzH1O], xmm5
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm3, xmm4
	addpd  xmm3, xmm5
	movapd [rsp + nb312_rsqOH2], xmm0
	movapd [rsp + nb312_rsqH1O], xmm3

	movapd xmm0, [rsp + nb312_ixH1]
	movapd xmm1, [rsp + nb312_iyH1]
	movapd xmm2, [rsp + nb312_izH1]
	movapd xmm3, [rsp + nb312_ixH1]
	movapd xmm4, [rsp + nb312_iyH1]
	movapd xmm5, [rsp + nb312_izH1]
	subpd  xmm0, [rsp + nb312_jxH1]
	subpd  xmm1, [rsp + nb312_jyH1]
	subpd  xmm2, [rsp + nb312_jzH1]
	subpd  xmm3, [rsp + nb312_jxH2]
	subpd  xmm4, [rsp + nb312_jyH2]
	subpd  xmm5, [rsp + nb312_jzH2]
	movapd [rsp + nb312_dxH1H1], xmm0
	movapd [rsp + nb312_dyH1H1], xmm1
	movapd [rsp + nb312_dzH1H1], xmm2
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	movapd [rsp + nb312_dxH1H2], xmm3
	movapd [rsp + nb312_dyH1H2], xmm4
	movapd [rsp + nb312_dzH1H2], xmm5
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm3, xmm4
	addpd  xmm3, xmm5
	movapd [rsp + nb312_rsqH1H1], xmm0
	movapd [rsp + nb312_rsqH1H2], xmm3

	movapd xmm0, [rsp + nb312_ixH2]
	movapd xmm1, [rsp + nb312_iyH2]
	movapd xmm2, [rsp + nb312_izH2]
	movapd xmm3, [rsp + nb312_ixH2]
	movapd xmm4, [rsp + nb312_iyH2]
	movapd xmm5, [rsp + nb312_izH2]
	subpd  xmm0, [rsp + nb312_jxO]
	subpd  xmm1, [rsp + nb312_jyO]
	subpd  xmm2, [rsp + nb312_jzO]
	subpd  xmm3, [rsp + nb312_jxH1]
	subpd  xmm4, [rsp + nb312_jyH1]
	subpd  xmm5, [rsp + nb312_jzH1]
	movapd [rsp + nb312_dxH2O], xmm0
	movapd [rsp + nb312_dyH2O], xmm1
	movapd [rsp + nb312_dzH2O], xmm2
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	movapd [rsp + nb312_dxH2H1], xmm3
	movapd [rsp + nb312_dyH2H1], xmm4
	movapd [rsp + nb312_dzH2H1], xmm5
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm4, xmm3
	addpd  xmm4, xmm5
	movapd [rsp + nb312_rsqH2O], xmm0
	movapd [rsp + nb312_rsqH2H1], xmm4

	movapd xmm0, [rsp + nb312_ixH2]
	movapd xmm1, [rsp + nb312_iyH2]
	movapd xmm2, [rsp + nb312_izH2]
	subpd  xmm0, [rsp + nb312_jxH2]
	subpd  xmm1, [rsp + nb312_jyH2]
	subpd  xmm2, [rsp + nb312_jzH2]
	movapd [rsp + nb312_dxH2H2], xmm0
	movapd [rsp + nb312_dyH2H2], xmm1
	movapd [rsp + nb312_dzH2H2], xmm2
	mulpd xmm0, xmm0
	mulpd xmm1, xmm1
	mulpd xmm2, xmm2
	addpd xmm0, xmm1
	addpd xmm0, xmm2
	movapd [rsp + nb312_rsqH2H2], xmm0
	
	;# start doing invsqrt use rsq values in xmm0, xmm4 
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312_half] ;# iter1 
	mulpd   xmm7, [rsp + nb312_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvH2H2], xmm1
	movapd [rsp + nb312_rinvH2H1], xmm5

	movapd xmm0, [rsp + nb312_rsqOO]
	movapd xmm4, [rsp + nb312_rsqOH1]	
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312_half] ;# iter1 of  
	mulpd   xmm7, [rsp + nb312_half] ;# iter1 of  

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312_half] ;# rinv
	movapd [rsp + nb312_rinvOO], xmm1
	movapd [rsp + nb312_rinvOH1], xmm5

	movapd xmm0, [rsp + nb312_rsqOH2]
	movapd xmm4, [rsp + nb312_rsqH1O]	
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312_half] ;# iter1 
	mulpd   xmm7, [rsp + nb312_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvOH2], xmm1
	movapd [rsp + nb312_rinvH1O], xmm5

	movapd xmm0, [rsp + nb312_rsqH1H1]
	movapd xmm4, [rsp + nb312_rsqH1H2]	
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312_half] ;# iter1a 
	mulpd   xmm7, [rsp + nb312_half] ;# iter1b 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvH1H1], xmm1
	movapd [rsp + nb312_rinvH1H2], xmm5

	movapd xmm0, [rsp + nb312_rsqH2O]
	cvtpd2ps xmm1, xmm0	
	rsqrtps xmm1, xmm1
	cvtps2pd xmm1, xmm1
	
	movapd  xmm2, xmm1	;# copy of luA 
	mulpd   xmm1, xmm1	;# luA*luA 
	movapd  xmm3, [rsp + nb312_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm3, [rsp + nb312_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	mulpd   xmm3, xmm3	;# luA*luA 
	movapd  xmm1, [rsp + nb312_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm1, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvH2O], xmm1
	
	;# start with OO interaction 
	movapd xmm0, [rsp + nb312_rinvOO]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqOO] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]

	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	movd mm0, eax	
	movd mm1, ebx
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOO]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 
    ;# increment vcoul - then we can get rid of mm5 
    ;# update vctot 
    addpd  xmm5, [rsp + nb312_vctot]
	xorpd  xmm2, xmm2
    movapd [rsp + nb312_vctot], xmm5
	mulpd  xmm3, [rsp + nb312_tsc]

	;# start doing lj 
	movapd xmm2, xmm0
	mulpd  xmm2, xmm2
	movapd xmm1, xmm2
	mulpd  xmm1, xmm2
	mulpd  xmm1, xmm2	;# xmm1=rinvsix 
	movapd xmm2, xmm1
	mulpd  xmm2, xmm2	;# xmm2=rinvtwelve 
	mulpd  xmm1, [rsp + nb312_c6]
	mulpd  xmm2, [rsp + nb312_c12]
	movapd xmm4, xmm2
	subpd  xmm4, xmm1
	addpd  xmm4, [rsp + nb312_Vvdwtot]
	mulpd  xmm1, [rsp + nb312_six]
	mulpd  xmm2, [rsp + nb312_twelve]
	movapd [rsp + nb312_Vvdwtot], xmm4
	subpd  xmm2, xmm1
	mulpd  xmm2, xmm0

	subpd  xmm2, xmm3
	mulpd  xmm0, xmm2
	
	movapd xmm1, xmm0
	movapd xmm2, xmm0		

	xorpd xmm3, xmm3
	movapd xmm4, xmm3
	movapd xmm5, xmm3
	mulpd xmm0, [rsp + nb312_dxOO]
	mulpd xmm1, [rsp + nb312_dyOO]
	mulpd xmm2, [rsp + nb312_dzOO]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixO]
	addpd xmm1, [rsp + nb312_fiyO]
	addpd xmm2, [rsp + nb312_fizO]
	movapd [rsp + nb312_fjxO], xmm3
	movapd [rsp + nb312_fjyO], xmm4
	movapd [rsp + nb312_fjzO], xmm5
	movapd [rsp + nb312_fixO], xmm0
	movapd [rsp + nb312_fiyO], xmm1
	movapd [rsp + nb312_fizO], xmm2

	;# O-H1 interaction 
	movapd xmm0, [rsp + nb312_rinvOH1]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqOH1] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]

	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	xorpd xmm3, xmm3
	movapd xmm4, xmm3
	movapd xmm5, xmm3
	mulpd xmm0, [rsp + nb312_dxOH1]
	mulpd xmm1, [rsp + nb312_dyOH1]
	mulpd xmm2, [rsp + nb312_dzOH1]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixO]
	addpd xmm1, [rsp + nb312_fiyO]
	addpd xmm2, [rsp + nb312_fizO]
	movapd [rsp + nb312_fjxH1], xmm3
	movapd [rsp + nb312_fjyH1], xmm4
	movapd [rsp + nb312_fjzH1], xmm5
	movapd [rsp + nb312_fixO], xmm0
	movapd [rsp + nb312_fiyO], xmm1
	movapd [rsp + nb312_fizO], xmm2

	;# O-H2 interaction  
	movapd xmm0, [rsp + nb312_rinvOH2]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqOH2] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]
	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	xorpd xmm3, xmm3
	movapd xmm4, xmm3
	movapd xmm5, xmm3
	mulpd xmm0, [rsp + nb312_dxOH2]
	mulpd xmm1, [rsp + nb312_dyOH2]
	mulpd xmm2, [rsp + nb312_dzOH2]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixO]
	addpd xmm1, [rsp + nb312_fiyO]
	addpd xmm2, [rsp + nb312_fizO]
	movapd [rsp + nb312_fjxH2], xmm3
	movapd [rsp + nb312_fjyH2], xmm4
	movapd [rsp + nb312_fjzH2], xmm5
	movapd [rsp + nb312_fixO], xmm0
	movapd [rsp + nb312_fiyO], xmm1
	movapd [rsp + nb312_fizO], xmm2

	;# H1-O interaction 
	movapd xmm0, [rsp + nb312_rinvH1O]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqH1O] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]
	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxO]
	movapd xmm4, [rsp + nb312_fjyO]
	movapd xmm5, [rsp + nb312_fjzO]
	mulpd xmm0, [rsp + nb312_dxH1O]
	mulpd xmm1, [rsp + nb312_dyH1O]
	mulpd xmm2, [rsp + nb312_dzH1O]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixH1]
	addpd xmm1, [rsp + nb312_fiyH1]
	addpd xmm2, [rsp + nb312_fizH1]
	movapd [rsp + nb312_fjxO], xmm3
	movapd [rsp + nb312_fjyO], xmm4
	movapd [rsp + nb312_fjzO], xmm5
	movapd [rsp + nb312_fixH1], xmm0
	movapd [rsp + nb312_fiyH1], xmm1
	movapd [rsp + nb312_fizH1], xmm2

	;# H1-H1 interaction 
	movapd xmm0, [rsp + nb312_rinvH1H1]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqH1H1] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH1]
	movapd xmm4, [rsp + nb312_fjyH1]
	movapd xmm5, [rsp + nb312_fjzH1]
	mulpd xmm0, [rsp + nb312_dxH1H1]
	mulpd xmm1, [rsp + nb312_dyH1H1]
	mulpd xmm2, [rsp + nb312_dzH1H1]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixH1]
	addpd xmm1, [rsp + nb312_fiyH1]
	addpd xmm2, [rsp + nb312_fizH1]
	movapd [rsp + nb312_fjxH1], xmm3
	movapd [rsp + nb312_fjyH1], xmm4
	movapd [rsp + nb312_fjzH1], xmm5
	movapd [rsp + nb312_fixH1], xmm0
	movapd [rsp + nb312_fiyH1], xmm1
	movapd [rsp + nb312_fizH1], xmm2

	;# H1-H2 interaction 
	movapd xmm0, [rsp + nb312_rinvH1H2]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqH1H2] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH2]
	movapd xmm4, [rsp + nb312_fjyH2]
	movapd xmm5, [rsp + nb312_fjzH2]
	mulpd xmm0, [rsp + nb312_dxH1H2]
	mulpd xmm1, [rsp + nb312_dyH1H2]
	mulpd xmm2, [rsp + nb312_dzH1H2]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixH1]
	addpd xmm1, [rsp + nb312_fiyH1]
	addpd xmm2, [rsp + nb312_fizH1]
	movapd [rsp + nb312_fjxH2], xmm3
	movapd [rsp + nb312_fjyH2], xmm4
	movapd [rsp + nb312_fjzH2], xmm5
	movapd [rsp + nb312_fixH1], xmm0
	movapd [rsp + nb312_fiyH1], xmm1
	movapd [rsp + nb312_fizH1], xmm2

	;# H2-O interaction 
	movapd xmm0, [rsp + nb312_rinvH2O]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqH2O] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1

	movapd xmm3, [rsp + nb312_fjxO]
	movapd xmm4, [rsp + nb312_fjyO]
	movapd xmm5, [rsp + nb312_fjzO]
	mulpd xmm0, [rsp + nb312_dxH2O]
	mulpd xmm1, [rsp + nb312_dyH2O]
	mulpd xmm2, [rsp + nb312_dzH2O]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixH2]
	addpd xmm1, [rsp + nb312_fiyH2]
	addpd xmm2, [rsp + nb312_fizH2]
	movapd [rsp + nb312_fjxO], xmm3
	movapd [rsp + nb312_fjyO], xmm4
	movapd [rsp + nb312_fjzO], xmm5
	movapd [rsp + nb312_fixH2], xmm0
	movapd [rsp + nb312_fiyH2], xmm1
	movapd [rsp + nb312_fizH2], xmm2

	;# H2-H1 interaction 
	movapd xmm0, [rsp + nb312_rinvH2H1]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqH2H1] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH1]
	movapd xmm4, [rsp + nb312_fjyH1]
	movapd xmm5, [rsp + nb312_fjzH1]
	mulpd xmm0, [rsp + nb312_dxH2H1]
	mulpd xmm1, [rsp + nb312_dyH2H1]
	mulpd xmm2, [rsp + nb312_dzH2H1]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixH2]
	addpd xmm1, [rsp + nb312_fiyH2]
	addpd xmm2, [rsp + nb312_fizH2]
	movapd [rsp + nb312_fjxH1], xmm3
	movapd [rsp + nb312_fjyH1], xmm4
	movapd [rsp + nb312_fjzH1], xmm5
	movapd [rsp + nb312_fixH2], xmm0
	movapd [rsp + nb312_fiyH2], xmm1
	movapd [rsp + nb312_fizH2], xmm2

	;# H2-H2 interaction 
	movapd xmm0, [rsp + nb312_rinvH2H2]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312_rsqH2H2] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312_tsc]	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	mulpd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addpd  xmm7, xmm6
	addpd  xmm7, xmm5 ;# xmm7=FF 
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulpd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 
	
    addpd  xmm5, [rsp + nb312_vctot]
    movapd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulpd  xmm3,  [rsp + nb312_tsc]
	mulpd  xmm3, xmm0
	subpd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH2]
	movapd xmm4, [rsp + nb312_fjyH2]
	movapd xmm5, [rsp + nb312_fjzH2]
	mulpd xmm0, [rsp + nb312_dxH2H2]
	mulpd xmm1, [rsp + nb312_dyH2H2]
	mulpd xmm2, [rsp + nb312_dzH2H2]
	subpd xmm3, xmm0
	subpd xmm4, xmm1
	subpd xmm5, xmm2
	addpd xmm0, [rsp + nb312_fixH2]
	addpd xmm1, [rsp + nb312_fiyH2]
	addpd xmm2, [rsp + nb312_fizH2]
	movapd [rsp + nb312_fjxH2], xmm3
	movapd [rsp + nb312_fjyH2], xmm4
	movapd [rsp + nb312_fjzH2], xmm5
	movapd [rsp + nb312_fixH2], xmm0
	movapd [rsp + nb312_fiyH2], xmm1
	movapd [rsp + nb312_fizH2], xmm2

	mov rdi, [rbp + nb312_faction]

	movd eax, mm0
	movd ebx, mm1
	
	;# Did all interactions - now update j forces 
	movlpd xmm0, [rdi + rax*8]
	movlpd xmm1, [rdi + rax*8 + 8]
	movlpd xmm2, [rdi + rax*8 + 16]
	movlpd xmm3, [rdi + rax*8 + 24]
	movlpd xmm4, [rdi + rax*8 + 32]
	movlpd xmm5, [rdi + rax*8 + 40]
	movlpd xmm6, [rdi + rax*8 + 48]
	movlpd xmm7, [rdi + rax*8 + 56]
	movhpd xmm0, [rdi + rbx*8]
	movhpd xmm1, [rdi + rbx*8 + 8]
	movhpd xmm2, [rdi + rbx*8 + 16]
	movhpd xmm3, [rdi + rbx*8 + 24]
	movhpd xmm4, [rdi + rbx*8 + 32]
	movhpd xmm5, [rdi + rbx*8 + 40]
	movhpd xmm6, [rdi + rbx*8 + 48]
	movhpd xmm7, [rdi + rbx*8 + 56]
	addpd xmm0, [rsp + nb312_fjxO]
	addpd xmm1, [rsp + nb312_fjyO]
	addpd xmm2, [rsp + nb312_fjzO]
	addpd xmm3, [rsp + nb312_fjxH1]
	addpd xmm4, [rsp + nb312_fjyH1]
	addpd xmm5, [rsp + nb312_fjzH1]
	addpd xmm6, [rsp + nb312_fjxH2]
	addpd xmm7, [rsp + nb312_fjyH2]
	movlpd [rdi + rax*8], xmm0
	movlpd [rdi + rax*8 + 8], xmm1
	movlpd [rdi + rax*8 + 16], xmm2
	movlpd [rdi + rax*8 + 24], xmm3
	movlpd [rdi + rax*8 + 32], xmm4
	movlpd [rdi + rax*8 + 40], xmm5
	movlpd [rdi + rax*8 + 48], xmm6
	movlpd [rdi + rax*8 + 56], xmm7
	movhpd [rdi + rbx*8], xmm0
	movhpd [rdi + rbx*8 + 8], xmm1
	movhpd [rdi + rbx*8 + 16], xmm2
	movhpd [rdi + rbx*8 + 24], xmm3
	movhpd [rdi + rbx*8 + 32], xmm4
	movhpd [rdi + rbx*8 + 40], xmm5
	movhpd [rdi + rbx*8 + 48], xmm6
	movhpd [rdi + rbx*8 + 56], xmm7
	
	movlpd xmm0, [rdi + rax*8 + 64]
	movhpd xmm0, [rdi + rbx*8 + 64]
	addpd xmm0, [rsp + nb312_fjzH2]
	movlpd [rdi + rax*8 + 64], xmm0
	movhpd [rdi + rbx*8 + 64], xmm0

	;# should we do one more iteration? 
	sub dword ptr [rsp + nb312_innerk],  2
	jl    .nb312_checksingle
	jmp   .nb312_unroll_loop
.nb312_checksingle:
	mov   edx, [rsp + nb312_innerk]
	and   edx, 1
	jnz   .nb312_dosingle
	jmp   .nb312_updateouterdata
.nb312_dosingle:
	mov   rdx, [rsp + nb312_innerjjnr]     ;# pointer to jjnr[k] 
	mov   eax, [rdx]

	mov rsi, [rbp + nb312_pos]
	lea   rax, [rax + rax*2]  

	;# fetch j coordinates 
	movlpd xmm2, [rsi + rax*8]
	movlpd xmm3, [rsi + rax*8 + 8]
	movlpd xmm4, [rsi + rax*8 + 16]
	movlpd xmm5, [rsi + rax*8 + 24]
	movlpd xmm6, [rsi + rax*8 + 32]
	movlpd xmm7, [rsi + rax*8 + 40]
	movapd 	[rsp + nb312_jxO], xmm2
	movapd 	[rsp + nb312_jyO], xmm3
	movapd 	[rsp + nb312_jzO], xmm4
	movapd 	[rsp + nb312_jxH1], xmm5
	movapd 	[rsp + nb312_jyH1], xmm6
	movapd 	[rsp + nb312_jzH1], xmm7
	movlpd xmm2, [rsi + rax*8 + 48]
	movlpd xmm3, [rsi + rax*8 + 56]
	movlpd xmm4, [rsi + rax*8 + 64]
	movapd 	[rsp + nb312_jxH2], xmm2
	movapd 	[rsp + nb312_jyH2], xmm3
	movapd 	[rsp + nb312_jzH2], xmm4
	
	movapd xmm0, [rsp + nb312_ixO]
	movapd xmm1, [rsp + nb312_iyO]
	movapd xmm2, [rsp + nb312_izO]
	movapd xmm3, [rsp + nb312_ixO]
	movapd xmm4, [rsp + nb312_iyO]
	movapd xmm5, [rsp + nb312_izO]
	subsd  xmm0, [rsp + nb312_jxO]
	subsd  xmm1, [rsp + nb312_jyO]
	subsd  xmm2, [rsp + nb312_jzO]
	subsd  xmm3, [rsp + nb312_jxH1]
	subsd  xmm4, [rsp + nb312_jyH1]
	subsd  xmm5, [rsp + nb312_jzH1]
	movapd [rsp + nb312_dxOO], xmm0
	movapd [rsp + nb312_dyOO], xmm1
	movapd [rsp + nb312_dzOO], xmm2
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	movapd [rsp + nb312_dxOH1], xmm3
	movapd [rsp + nb312_dyOH1], xmm4
	movapd [rsp + nb312_dzOH1], xmm5
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm3, xmm4
	addsd  xmm3, xmm5
	movapd [rsp + nb312_rsqOO], xmm0
	movapd [rsp + nb312_rsqOH1], xmm3

	movapd xmm0, [rsp + nb312_ixO]
	movapd xmm1, [rsp + nb312_iyO]
	movapd xmm2, [rsp + nb312_izO]
	movapd xmm3, [rsp + nb312_ixH1]
	movapd xmm4, [rsp + nb312_iyH1]
	movapd xmm5, [rsp + nb312_izH1]
	subsd  xmm0, [rsp + nb312_jxH2]
	subsd  xmm1, [rsp + nb312_jyH2]
	subsd  xmm2, [rsp + nb312_jzH2]
	subsd  xmm3, [rsp + nb312_jxO]
	subsd  xmm4, [rsp + nb312_jyO]
	subsd  xmm5, [rsp + nb312_jzO]
	movapd [rsp + nb312_dxOH2], xmm0
	movapd [rsp + nb312_dyOH2], xmm1
	movapd [rsp + nb312_dzOH2], xmm2
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	movapd [rsp + nb312_dxH1O], xmm3
	movapd [rsp + nb312_dyH1O], xmm4
	movapd [rsp + nb312_dzH1O], xmm5
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm3, xmm4
	addsd  xmm3, xmm5
	movapd [rsp + nb312_rsqOH2], xmm0
	movapd [rsp + nb312_rsqH1O], xmm3

	movapd xmm0, [rsp + nb312_ixH1]
	movapd xmm1, [rsp + nb312_iyH1]
	movapd xmm2, [rsp + nb312_izH1]
	movapd xmm3, [rsp + nb312_ixH1]
	movapd xmm4, [rsp + nb312_iyH1]
	movapd xmm5, [rsp + nb312_izH1]
	subsd  xmm0, [rsp + nb312_jxH1]
	subsd  xmm1, [rsp + nb312_jyH1]
	subsd  xmm2, [rsp + nb312_jzH1]
	subsd  xmm3, [rsp + nb312_jxH2]
	subsd  xmm4, [rsp + nb312_jyH2]
	subsd  xmm5, [rsp + nb312_jzH2]
	movapd [rsp + nb312_dxH1H1], xmm0
	movapd [rsp + nb312_dyH1H1], xmm1
	movapd [rsp + nb312_dzH1H1], xmm2
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	movapd [rsp + nb312_dxH1H2], xmm3
	movapd [rsp + nb312_dyH1H2], xmm4
	movapd [rsp + nb312_dzH1H2], xmm5
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm3, xmm4
	addsd  xmm3, xmm5
	movapd [rsp + nb312_rsqH1H1], xmm0
	movapd [rsp + nb312_rsqH1H2], xmm3

	movapd xmm0, [rsp + nb312_ixH2]
	movapd xmm1, [rsp + nb312_iyH2]
	movapd xmm2, [rsp + nb312_izH2]
	movapd xmm3, [rsp + nb312_ixH2]
	movapd xmm4, [rsp + nb312_iyH2]
	movapd xmm5, [rsp + nb312_izH2]
	subsd  xmm0, [rsp + nb312_jxO]
	subsd  xmm1, [rsp + nb312_jyO]
	subsd  xmm2, [rsp + nb312_jzO]
	subsd  xmm3, [rsp + nb312_jxH1]
	subsd  xmm4, [rsp + nb312_jyH1]
	subsd  xmm5, [rsp + nb312_jzH1]
	movapd [rsp + nb312_dxH2O], xmm0
	movapd [rsp + nb312_dyH2O], xmm1
	movapd [rsp + nb312_dzH2O], xmm2
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	movapd [rsp + nb312_dxH2H1], xmm3
	movapd [rsp + nb312_dyH2H1], xmm4
	movapd [rsp + nb312_dzH2H1], xmm5
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm4, xmm3
	addsd  xmm4, xmm5
	movapd [rsp + nb312_rsqH2O], xmm0
	movapd [rsp + nb312_rsqH2H1], xmm4

	movapd xmm0, [rsp + nb312_ixH2]
	movapd xmm1, [rsp + nb312_iyH2]
	movapd xmm2, [rsp + nb312_izH2]
	subsd  xmm0, [rsp + nb312_jxH2]
	subsd  xmm1, [rsp + nb312_jyH2]
	subsd  xmm2, [rsp + nb312_jzH2]
	movapd [rsp + nb312_dxH2H2], xmm0
	movapd [rsp + nb312_dyH2H2], xmm1
	movapd [rsp + nb312_dzH2H2], xmm2
	mulsd xmm0, xmm0
	mulsd xmm1, xmm1
	mulsd xmm2, xmm2
	addsd xmm0, xmm1
	addsd xmm0, xmm2
	movapd [rsp + nb312_rsqH2H2], xmm0
	
	;# start doing invsqrt use rsq values in xmm0, xmm4 
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312_half] ;# iter1 
	mulsd   xmm7, [rsp + nb312_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvH2H2], xmm1
	movapd [rsp + nb312_rinvH2H1], xmm5

	movapd xmm0, [rsp + nb312_rsqOO]
	movapd xmm4, [rsp + nb312_rsqOH1]	
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312_half] ;# iter1 of  
	mulsd   xmm7, [rsp + nb312_half] ;# iter1 of  

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312_half] ;# rinv
	movapd [rsp + nb312_rinvOO], xmm1
	movapd [rsp + nb312_rinvOH1], xmm5

	movapd xmm0, [rsp + nb312_rsqOH2]
	movapd xmm4, [rsp + nb312_rsqH1O]	
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312_half] ;# iter1 
	mulsd   xmm7, [rsp + nb312_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvOH2], xmm1
	movapd [rsp + nb312_rinvH1O], xmm5

	movapd xmm0, [rsp + nb312_rsqH1H1]
	movapd xmm4, [rsp + nb312_rsqH1H2]	
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312_half] ;# iter1a 
	mulsd   xmm7, [rsp + nb312_half] ;# iter1b 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvH1H1], xmm1
	movapd [rsp + nb312_rinvH1H2], xmm5

	movapd xmm0, [rsp + nb312_rsqH2O]
	cvtsd2ss xmm1, xmm0	
	rsqrtss xmm1, xmm1
	cvtss2sd xmm1, xmm1
	
	movapd  xmm2, xmm1	;# copy of luA 
	mulsd   xmm1, xmm1	;# luA*luA 
	movapd  xmm3, [rsp + nb312_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm3, [rsp + nb312_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	mulsd   xmm3, xmm3	;# luA*luA 
	movapd  xmm1, [rsp + nb312_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm1, [rsp + nb312_half] ;# rinv 
	movapd [rsp + nb312_rinvH2O], xmm1
	
	;# start with OO interaction 
	movapd xmm0, [rsp + nb312_rinvOO]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqOO] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]

	movd mm0, eax	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1  

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1  
	unpckhpd xmm7, xmm3	;# H1  
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOO]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 
    ;# increment vcoul - then we can get rid of mm5 
    ;# update vctot 
    addsd  xmm5, [rsp + nb312_vctot]
	xorpd  xmm2, xmm2
    movlpd [rsp + nb312_vctot], xmm5
	mulsd  xmm3, [rsp + nb312_tsc]

	;# start doing lj 
	movapd xmm2, xmm0
	mulsd  xmm2, xmm2
	movapd xmm1, xmm2
	mulsd  xmm1, xmm2
	mulsd  xmm1, xmm2	;# xmm1=rinvsix 
	movapd xmm2, xmm1
	mulsd  xmm2, xmm2	;# xmm2=rinvtwelve 
	mulsd  xmm1, [rsp + nb312_c6]
	mulsd  xmm2, [rsp + nb312_c12]
	movapd xmm4, xmm2
	subsd  xmm4, xmm1
	addsd  xmm4, [rsp + nb312_Vvdwtot]
	mulsd  xmm1, [rsp + nb312_six]
	mulsd  xmm2, [rsp + nb312_twelve]
	movlpd [rsp + nb312_Vvdwtot], xmm4
	subsd  xmm2, xmm1
	mulsd  xmm2, xmm0

	subsd  xmm2, xmm3
	mulsd  xmm0, xmm2
	
	movapd xmm1, xmm0
	movapd xmm2, xmm0		

	xorpd xmm3, xmm3
	movapd xmm4, xmm3
	movapd xmm5, xmm3
	mulpd xmm0, [rsp + nb312_dxOO]
	mulpd xmm1, [rsp + nb312_dyOO]
	mulpd xmm2, [rsp + nb312_dzOO]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixO]
	addsd xmm1, [rsp + nb312_fiyO]
	addsd xmm2, [rsp + nb312_fizO]
	movlpd [rsp + nb312_fjxO], xmm3
	movlpd [rsp + nb312_fjyO], xmm4
	movlpd [rsp + nb312_fjzO], xmm5
	movlpd [rsp + nb312_fixO], xmm0
	movlpd [rsp + nb312_fiyO], xmm1
	movlpd [rsp + nb312_fizO], xmm2

	;# O-H1 interaction 
	movapd xmm0, [rsp + nb312_rinvOH1]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqOH1] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]

	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1  
	unpckhpd xmm5, xmm3	;# F1  

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	xorpd xmm3, xmm3
	movapd xmm4, xmm3
	movapd xmm5, xmm3
	mulsd xmm0, [rsp + nb312_dxOH1]
	mulsd xmm1, [rsp + nb312_dyOH1]
	mulsd xmm2, [rsp + nb312_dzOH1]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixO]
	addsd xmm1, [rsp + nb312_fiyO]
	addsd xmm2, [rsp + nb312_fizO]
	movlpd [rsp + nb312_fjxH1], xmm3
	movlpd [rsp + nb312_fjyH1], xmm4
	movlpd [rsp + nb312_fjzH1], xmm5
	movlpd [rsp + nb312_fixO], xmm0
	movlpd [rsp + nb312_fiyO], xmm1
	movlpd [rsp + nb312_fizO], xmm2

	;# O-H2 interaction  
	movapd xmm0, [rsp + nb312_rinvOH2]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqOH2] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]
	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	xorpd xmm3, xmm3
	movapd xmm4, xmm3
	movapd xmm5, xmm3
	mulsd xmm0, [rsp + nb312_dxOH2]
	mulsd xmm1, [rsp + nb312_dyOH2]
	mulsd xmm2, [rsp + nb312_dzOH2]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixO]
	addsd xmm1, [rsp + nb312_fiyO]
	addsd xmm2, [rsp + nb312_fizO]
	movlpd [rsp + nb312_fjxH2], xmm3
	movlpd [rsp + nb312_fjyH2], xmm4
	movlpd [rsp + nb312_fjzH2], xmm5
	movlpd [rsp + nb312_fixO], xmm0
	movlpd [rsp + nb312_fiyO], xmm1
	movlpd [rsp + nb312_fizO], xmm2

	;# H1-O interaction 
	movapd xmm0, [rsp + nb312_rinvH1O]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqH1O] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]
	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxO]
	movapd xmm4, [rsp + nb312_fjyO]
	movapd xmm5, [rsp + nb312_fjzO]
	mulsd xmm0, [rsp + nb312_dxH1O]
	mulsd xmm1, [rsp + nb312_dyH1O]
	mulsd xmm2, [rsp + nb312_dzH1O]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixH1]
	addsd xmm1, [rsp + nb312_fiyH1]
	addsd xmm2, [rsp + nb312_fizH1]
	movlpd [rsp + nb312_fjxO], xmm3
	movlpd [rsp + nb312_fjyO], xmm4
	movlpd [rsp + nb312_fjzO], xmm5
	movlpd [rsp + nb312_fixH1], xmm0
	movlpd [rsp + nb312_fiyH1], xmm1
	movlpd [rsp + nb312_fizH1], xmm2

	;# H1-H1 interaction 
	movapd xmm0, [rsp + nb312_rinvH1H1]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqH1H1] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH1]
	movapd xmm4, [rsp + nb312_fjyH1]
	movapd xmm5, [rsp + nb312_fjzH1]
	mulsd xmm0, [rsp + nb312_dxH1H1]
	mulsd xmm1, [rsp + nb312_dyH1H1]
	mulsd xmm2, [rsp + nb312_dzH1H1]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixH1]
	addsd xmm1, [rsp + nb312_fiyH1]
	addsd xmm2, [rsp + nb312_fizH1]
	movlpd [rsp + nb312_fjxH1], xmm3
	movlpd [rsp + nb312_fjyH1], xmm4
	movlpd [rsp + nb312_fjzH1], xmm5
	movlpd [rsp + nb312_fixH1], xmm0
	movlpd [rsp + nb312_fiyH1], xmm1
	movlpd [rsp + nb312_fizH1], xmm2

	;# H1-H2 interaction 
	movapd xmm0, [rsp + nb312_rinvH1H2]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqH1H2] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH2]
	movapd xmm4, [rsp + nb312_fjyH2]
	movapd xmm5, [rsp + nb312_fjzH2]
	mulsd xmm0, [rsp + nb312_dxH1H2]
	mulsd xmm1, [rsp + nb312_dyH1H2]
	mulsd xmm2, [rsp + nb312_dzH1H2]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixH1]
	addsd xmm1, [rsp + nb312_fiyH1]
	addsd xmm2, [rsp + nb312_fizH1]
	movlpd [rsp + nb312_fjxH2], xmm3
	movlpd [rsp + nb312_fjyH2], xmm4
	movlpd [rsp + nb312_fjzH2], xmm5
	movlpd [rsp + nb312_fixH1], xmm0
	movlpd [rsp + nb312_fiyH1], xmm1
	movlpd [rsp + nb312_fizH1], xmm2

	;# H2-O interaction 
	movapd xmm0, [rsp + nb312_rinvH2O]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqH2O] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqOH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1

	movapd xmm3, [rsp + nb312_fjxO]
	movapd xmm4, [rsp + nb312_fjyO]
	movapd xmm5, [rsp + nb312_fjzO]
	mulsd xmm0, [rsp + nb312_dxH2O]
	mulsd xmm1, [rsp + nb312_dyH2O]
	mulsd xmm2, [rsp + nb312_dzH2O]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixH2]
	addsd xmm1, [rsp + nb312_fiyH2]
	addsd xmm2, [rsp + nb312_fizH2]
	movlpd [rsp + nb312_fjxO], xmm3
	movlpd [rsp + nb312_fjyO], xmm4
	movlpd [rsp + nb312_fjzO], xmm5
	movlpd [rsp + nb312_fixH2], xmm0
	movlpd [rsp + nb312_fiyH2], xmm1
	movlpd [rsp + nb312_fizH2], xmm2

	;# H2-H1 interaction 
	movapd xmm0, [rsp + nb312_rinvH2H1]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqH2H1] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH1]
	movapd xmm4, [rsp + nb312_fjyH1]
	movapd xmm5, [rsp + nb312_fjzH1]
	mulsd xmm0, [rsp + nb312_dxH2H1]
	mulsd xmm1, [rsp + nb312_dyH2H1]
	mulsd xmm2, [rsp + nb312_dzH2H1]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixH2]
	addsd xmm1, [rsp + nb312_fiyH2]
	addsd xmm2, [rsp + nb312_fizH2]
	movlpd [rsp + nb312_fjxH1], xmm3
	movlpd [rsp + nb312_fjyH1], xmm4
	movlpd [rsp + nb312_fjzH1], xmm5
	movlpd [rsp + nb312_fixH2], xmm0
	movlpd [rsp + nb312_fiyH2], xmm1
	movlpd [rsp + nb312_fizH2], xmm2

	;# H2-H2 interaction 
	movapd xmm0, [rsp + nb312_rinvH2H2]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312_rsqH2H2] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312_tsc]	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	mulsd  xmm7, [rsp + nb312_two]	;# two*Heps2 
	movapd xmm3, [rsp + nb312_qqHH]
	addsd  xmm7, xmm6
	addsd  xmm7, xmm5 ;# xmm7=FF 
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
	mulsd  xmm3, xmm7 ;# fijC=FF*qq 
    ;# at this point mm5 contains vcoul and xmm3 fijC 

    addsd  xmm5, [rsp + nb312_vctot]
    movlpd [rsp + nb312_vctot], xmm5
	xorpd  xmm1, xmm1
	mulsd  xmm3,  [rsp + nb312_tsc]
	mulsd  xmm3, xmm0
	subsd  xmm1, xmm3

	movapd xmm0, xmm1
	movapd xmm2, xmm1
	
	movapd xmm3, [rsp + nb312_fjxH2]
	movapd xmm4, [rsp + nb312_fjyH2]
	movapd xmm5, [rsp + nb312_fjzH2]
	mulsd xmm0, [rsp + nb312_dxH2H2]
	mulsd xmm1, [rsp + nb312_dyH2H2]
	mulsd xmm2, [rsp + nb312_dzH2H2]
	subsd xmm3, xmm0
	subsd xmm4, xmm1
	subsd xmm5, xmm2
	addsd xmm0, [rsp + nb312_fixH2]
	addsd xmm1, [rsp + nb312_fiyH2]
	addsd xmm2, [rsp + nb312_fizH2]
	movlpd [rsp + nb312_fjxH2], xmm3
	movlpd [rsp + nb312_fjyH2], xmm4
	movlpd [rsp + nb312_fjzH2], xmm5
	movlpd [rsp + nb312_fixH2], xmm0
	movlpd [rsp + nb312_fiyH2], xmm1
	movlpd [rsp + nb312_fizH2], xmm2

	mov rdi, [rbp + nb312_faction]

	movd eax, mm0
	
	;# Did all interactions - now update j forces 
	movlpd xmm0, [rdi + rax*8]
	movlpd xmm1, [rdi + rax*8 + 8]
	movlpd xmm2, [rdi + rax*8 + 16]
	movlpd xmm3, [rdi + rax*8 + 24]
	movlpd xmm4, [rdi + rax*8 + 32]
	movlpd xmm5, [rdi + rax*8 + 40]
	movlpd xmm6, [rdi + rax*8 + 48]
	movlpd xmm7, [rdi + rax*8 + 56]
	addsd xmm0, [rsp + nb312_fjxO]
	addsd xmm1, [rsp + nb312_fjyO]
	addsd xmm2, [rsp + nb312_fjzO]
	addsd xmm3, [rsp + nb312_fjxH1]
	addsd xmm4, [rsp + nb312_fjyH1]
	addsd xmm5, [rsp + nb312_fjzH1]
	addsd xmm6, [rsp + nb312_fjxH2]
	addsd xmm7, [rsp + nb312_fjyH2]
	movlpd [rdi + rax*8], xmm0
	movlpd [rdi + rax*8 + 8], xmm1
	movlpd [rdi + rax*8 + 16], xmm2
	movlpd [rdi + rax*8 + 24], xmm3
	movlpd [rdi + rax*8 + 32], xmm4
	movlpd [rdi + rax*8 + 40], xmm5
	movlpd [rdi + rax*8 + 48], xmm6
	movlpd [rdi + rax*8 + 56], xmm7

	movlpd xmm0, [rdi + rax*8 + 64]
	addsd xmm0, [rsp + nb312_fjzH2]
	movlpd [rdi + rax*8 + 64], xmm0
	
.nb312_updateouterdata:
	mov   ecx, [rsp + nb312_ii3]
	mov   rdi, [rbp + nb312_faction]
	mov   rsi, [rbp + nb312_fshift]
	mov   edx, [rsp + nb312_is3]

	;# accumulate  Oi forces in xmm0, xmm1, xmm2 
	movapd xmm0, [rsp + nb312_fixO]
	movapd xmm1, [rsp + nb312_fiyO]
	movapd xmm2, [rsp + nb312_fizO]

	movhlps xmm3, xmm0
	movhlps xmm4, xmm1
	movhlps xmm5, xmm2
	addsd  xmm0, xmm3
	addsd  xmm1, xmm4
	addsd  xmm2, xmm5 ;# sum is in low xmm0-xmm2 

	movapd xmm3, xmm0	
	movapd xmm4, xmm1	
	movapd xmm5, xmm2	

	;# increment i force 
	movsd  xmm3, [rdi + rcx*8]
	movsd  xmm4, [rdi + rcx*8 + 8]
	movsd  xmm5, [rdi + rcx*8 + 16]
	addsd  xmm3, xmm0
	addsd  xmm4, xmm1
	addsd  xmm5, xmm2
	movsd  [rdi + rcx*8],     xmm3
	movsd  [rdi + rcx*8 + 8], xmm4
	movsd  [rdi + rcx*8 + 16], xmm5

	;# accumulate force in xmm6/xmm7 for fshift 
	movapd xmm6, xmm0
	movsd xmm7, xmm2
	unpcklpd xmm6, xmm1

	;# accumulate H1i forces in xmm0, xmm1, xmm2 
	movapd xmm0, [rsp + nb312_fixH1]
	movapd xmm1, [rsp + nb312_fiyH1]
	movapd xmm2, [rsp + nb312_fizH1]

	movhlps xmm3, xmm0
	movhlps xmm4, xmm1
	movhlps xmm5, xmm2
	addsd  xmm0, xmm3
	addsd  xmm1, xmm4
	addsd  xmm2, xmm5 ;# sum is in low xmm0-xmm2 

	;# increment i force 
	movsd  xmm3, [rdi + rcx*8 + 24]
	movsd  xmm4, [rdi + rcx*8 + 32]
	movsd  xmm5, [rdi + rcx*8 + 40]
	addsd  xmm3, xmm0
	addsd  xmm4, xmm1
	addsd  xmm5, xmm2
	movsd  [rdi + rcx*8 + 24], xmm3
	movsd  [rdi + rcx*8 + 32], xmm4
	movsd  [rdi + rcx*8 + 40], xmm5

	;# accumulate force in xmm6/xmm7 for fshift 
	addsd xmm7, xmm2
	unpcklpd xmm0, xmm1
	addpd xmm6, xmm0

	;# accumulate H2i forces in xmm0, xmm1, xmm2 
	movapd xmm0, [rsp + nb312_fixH2]
	movapd xmm1, [rsp + nb312_fiyH2]
	movapd xmm2, [rsp + nb312_fizH2]

	movhlps xmm3, xmm0
	movhlps xmm4, xmm1
	movhlps xmm5, xmm2
	addsd  xmm0, xmm3
	addsd  xmm1, xmm4
	addsd  xmm2, xmm5 ;# sum is in low xmm0-xmm2 

	movapd xmm3, xmm0	
	movapd xmm4, xmm1	
	movapd xmm5, xmm2	

	;# increment i force 
	movsd  xmm3, [rdi + rcx*8 + 48]
	movsd  xmm4, [rdi + rcx*8 + 56]
	movsd  xmm5, [rdi + rcx*8 + 64]
	addsd  xmm3, xmm0
	addsd  xmm4, xmm1
	addsd  xmm5, xmm2
	movsd  [rdi + rcx*8 + 48], xmm3
	movsd  [rdi + rcx*8 + 56], xmm4
	movsd  [rdi + rcx*8 + 64], xmm5

	;# accumulate force in xmm6/xmm7 for fshift 
	addsd xmm7, xmm2
	unpcklpd xmm0, xmm1
	addpd xmm6, xmm0

	;# increment fshift force 
	movlpd xmm3, [rsi + rdx*8]
	movhpd xmm3, [rsi + rdx*8 + 8]
	movsd  xmm4, [rsi + rdx*8 + 16]
	addpd  xmm3, xmm6
	addsd  xmm4, xmm7
	movlpd [rsi + rdx*8],      xmm3
	movhpd [rsi + rdx*8 + 8],  xmm3
	movsd  [rsi + rdx*8 + 16], xmm4

	;# get n from stack
	mov esi, [rsp + nb312_n]
        ;# get group index for i particle 
        mov   rdx, [rbp + nb312_gid]      	;# base of gid[]
        mov   edx, [rdx + rsi*4]		;# ggid=gid[n]

	;# accumulate total potential energy and update it 
	movapd xmm7, [rsp + nb312_vctot]
	;# accumulate 
	movhlps xmm6, xmm7
	addsd  xmm7, xmm6	;# low xmm7 has the sum now 
        
	;# add earlier value from mem 
	mov   rax, [rbp + nb312_Vc]
	addsd xmm7, [rax + rdx*8] 
	;# move back to mem 
	movsd [rax + rdx*8], xmm7 
	
	;# accumulate total lj energy and update it 
	movapd xmm7, [rsp + nb312_Vvdwtot]
	;# accumulate 
	movhlps xmm6, xmm7
	addsd  xmm7, xmm6	;# low xmm7 has the sum now 

	;# add earlier value from mem 
	mov   rax, [rbp + nb312_Vvdw]
	addsd xmm7, [rax + rdx*8] 
	;# move back to mem 
	movsd [rax + rdx*8], xmm7 
	
        ;# finish if last 
        mov ecx, [rsp + nb312_nn1]
	;# esi already loaded with n
	inc esi
        sub ecx, esi
        jecxz .nb312_outerend

        ;# not last, iterate outer loop once more!  
        mov [rsp + nb312_n], esi
        jmp .nb312_outer
.nb312_outerend:
        ;# check if more outer neighborlists remain
        mov   ecx, [rsp + nb312_nri]
	;# esi already loaded with n above
        sub   ecx, esi
        jecxz .nb312_end
        ;# non-zero, do one more workunit
        jmp   .nb312_threadloop
.nb312_end:
	mov eax, [rsp + nb312_nouter]
	mov ebx, [rsp + nb312_ninner]
	mov rcx, [rbp + nb312_outeriter]
	mov rdx, [rbp + nb312_inneriter]
	mov [rcx], eax
	mov [rdx], ebx

	add rsp, 1624
	femms

	pop rbx
	pop	rbp
	ret



	
.globl nb_kernel312nf_x86_64_sse2
.globl _nb_kernel312nf_x86_64_sse2
nb_kernel312nf_x86_64_sse2:	
_nb_kernel312nf_x86_64_sse2:	
;#	Room for return address and rbp (16 bytes)
.equiv          nb312nf_fshift,         16
.equiv          nb312nf_gid,            24
.equiv          nb312nf_pos,            32
.equiv          nb312nf_faction,        40
.equiv          nb312nf_charge,         48
.equiv          nb312nf_p_facel,        56
.equiv          nb312nf_argkrf,         64
.equiv          nb312nf_argcrf,         72
.equiv          nb312nf_Vc,             80
.equiv          nb312nf_type,           88
.equiv          nb312nf_p_ntype,        96
.equiv          nb312nf_vdwparam,       104
.equiv          nb312nf_Vvdw,           112
.equiv          nb312nf_p_tabscale,     120
.equiv          nb312nf_VFtab,          128
.equiv          nb312nf_invsqrta,       136
.equiv          nb312nf_dvda,           144
.equiv          nb312nf_p_gbtabscale,   152
.equiv          nb312nf_GBtab,          160
.equiv          nb312nf_p_nthreads,     168
.equiv          nb312nf_count,          176
.equiv          nb312nf_mtx,            184
.equiv          nb312nf_outeriter,      192
.equiv          nb312nf_inneriter,      200
.equiv          nb312nf_work,           208
	;# stack offsets for local variables  
	;# bottom of stack is cache-aligned for sse use 
.equiv          nb312nf_ixO,            0
.equiv          nb312nf_iyO,            16
.equiv          nb312nf_izO,            32
.equiv          nb312nf_ixH1,           48
.equiv          nb312nf_iyH1,           64
.equiv          nb312nf_izH1,           80
.equiv          nb312nf_ixH2,           96
.equiv          nb312nf_iyH2,           112
.equiv          nb312nf_izH2,           128
.equiv          nb312nf_jxO,            144
.equiv          nb312nf_jyO,            160
.equiv          nb312nf_jzO,            176
.equiv          nb312nf_jxH1,           192
.equiv          nb312nf_jyH1,           208
.equiv          nb312nf_jzH1,           224
.equiv          nb312nf_jxH2,           240
.equiv          nb312nf_jyH2,           256
.equiv          nb312nf_jzH2,           272
.equiv          nb312nf_qqOO,           288
.equiv          nb312nf_qqOH,           304
.equiv          nb312nf_qqHH,           320
.equiv          nb312nf_tsc,            336
.equiv          nb312nf_c6,             352
.equiv          nb312nf_c12,            368
.equiv          nb312nf_vctot,          384
.equiv          nb312nf_Vvdwtot,        400
.equiv          nb312nf_half,           416
.equiv          nb312nf_three,          432
.equiv          nb312nf_rsqOO,          448
.equiv          nb312nf_rsqOH1,         464
.equiv          nb312nf_rsqOH2,         480
.equiv          nb312nf_rsqH1O,         496
.equiv          nb312nf_rsqH1H1,        512
.equiv          nb312nf_rsqH1H2,        528
.equiv          nb312nf_rsqH2O,         544
.equiv          nb312nf_rsqH2H1,        560
.equiv          nb312nf_rsqH2H2,        576
.equiv          nb312nf_rinvOO,         592
.equiv          nb312nf_rinvOH1,        608
.equiv          nb312nf_rinvOH2,        624
.equiv          nb312nf_rinvH1O,        640
.equiv          nb312nf_rinvH1H1,       656
.equiv          nb312nf_rinvH1H2,       672
.equiv          nb312nf_rinvH2O,        688
.equiv          nb312nf_rinvH2H1,       704
.equiv          nb312nf_rinvH2H2,       720
.equiv          nb312nf_is3,            736
.equiv          nb312nf_ii3,            740
.equiv          nb312nf_nri,            744
.equiv          nb312nf_iinr,           752
.equiv          nb312nf_jindex,         760
.equiv          nb312nf_jjnr,           768
.equiv          nb312nf_shift,          776
.equiv          nb312nf_shiftvec,       784
.equiv          nb312nf_facel,          792
.equiv          nb312nf_innerjjnr,      800
.equiv          nb312nf_innerk,         808
.equiv          nb312nf_n,              812
.equiv          nb312nf_nn1,            816
.equiv          nb312nf_nouter,         820
.equiv          nb312nf_ninner,         824
	push rbp
	mov  rbp, rsp
	push rbx
	femms
	sub rsp, 840		;# local variable stack space (n*16+8)

	;# zero 32-bit iteration counters
	mov eax, 0
	mov [rsp + nb312nf_nouter], eax
	mov [rsp + nb312nf_ninner], eax

	mov edi, [rdi]
	mov [rsp + nb312nf_nri], edi
	mov [rsp + nb312nf_iinr], rsi
	mov [rsp + nb312nf_jindex], rdx
	mov [rsp + nb312nf_jjnr], rcx
	mov [rsp + nb312nf_shift], r8
	mov [rsp + nb312nf_shiftvec], r9
	mov rsi, [rbp + nb312nf_p_facel]
	movsd xmm0, [rsi]
	movsd [rsp + nb312nf_facel], xmm0

	mov rax, [rbp + nb312nf_p_tabscale]
	movsd xmm3, [rax]
	shufpd xmm3, xmm3, 0
	movapd [rsp + nb312nf_tsc], xmm3

	;# create constant floating-point factors on stack
	mov eax, 0x00000000     ;# lower half of double half IEEE (hex)
	mov ebx, 0x3fe00000
	mov [rsp + nb312nf_half], eax
	mov [rsp + nb312nf_half + 4], ebx
	movsd xmm1, [rsp + nb312nf_half]
	shufpd xmm1, xmm1, 0    ;# splat to all elements
	movapd xmm3, xmm1
	addpd  xmm3, xmm3       ;# one
	movapd xmm2, xmm3
	addpd  xmm2, xmm2       ;# two
	addpd  xmm3, xmm2	;# three
	movapd [rsp + nb312nf_half], xmm1
	movapd [rsp + nb312nf_three], xmm3

	;# assume we have at least one i particle - start directly 
	mov   rcx, [rsp + nb312nf_iinr]       ;# rcx = pointer into iinr[] 	
	mov   ebx, [rcx]	    ;# ebx =ii 

	mov   rdx, [rbp + nb312nf_charge]
	movsd xmm3, [rdx + rbx*8]	
	movsd xmm4, xmm3	
	movsd xmm5, [rdx + rbx*8 + 8]	
	mov rsi, [rbp + nb312nf_p_facel]
	movsd xmm0, [rsi]
	movsd xmm6, [rsp + nb312nf_facel]
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm5
	mulsd  xmm5, xmm5
	mulsd  xmm3, xmm6
	mulsd  xmm4, xmm6
	mulsd  xmm5, xmm6
	shufpd xmm3, xmm3, 0
	shufpd xmm4, xmm4, 0
	shufpd xmm5, xmm5, 0
	movapd [rsp + nb312nf_qqOO], xmm3
	movapd [rsp + nb312nf_qqOH], xmm4
	movapd [rsp + nb312nf_qqHH], xmm5
	
	xorpd xmm0, xmm0
	mov   rdx, [rbp + nb312nf_type]
	mov   ecx, [rdx + rbx*4]
	shl   ecx, 1
	mov   edx, ecx
	mov rdi, [rbp + nb312nf_p_ntype]
	imul  ecx, [rdi]      ;# rcx = ntia = 2*ntype*type[ii0] 
	add   edx, ecx
	mov   rax, [rbp + nb312nf_vdwparam]
	movlpd xmm0, [rax + rdx*8] 
	movlpd xmm1, [rax + rdx*8 + 8] 
	shufpd xmm0, xmm0, 0
	shufpd xmm1, xmm1, 0
	movapd [rsp + nb312nf_c6], xmm0
	movapd [rsp + nb312nf_c12], xmm1

.nb312nf_threadloop:
        mov   rsi, [rbp + nb312nf_count]        ;# pointer to sync counter
        mov   eax, [rsi]
.nb312nf_spinlock:
        mov   ebx, eax                          ;# ebx=*count=nn0
        add   ebx, 1                           	;# ebx=nn1=nn0+10
        lock cmpxchg [rsi], ebx                 ;# write nn1 to *counter,
                                                ;# if it hasnt changed.
                                                ;# or reread *counter to eax.
        pause                                   ;# -> better p4 performance
        jnz .nb312nf_spinlock

        ;# if(nn1>nri) nn1=nri
        mov ecx, [rsp + nb312nf_nri]
        mov edx, ecx
        sub ecx, ebx
        cmovle ebx, edx                         ;# if(nn1>nri) nn1=nri
        ;# Cleared the spinlock if we got here.
        ;# eax contains nn0, ebx contains nn1.
        mov [rsp + nb312nf_n], eax
        mov [rsp + nb312nf_nn1], ebx
        sub ebx, eax                            ;# calc number of outer lists
	mov esi, eax				;# copy n to esi
        jg  .nb312nf_outerstart
        jmp .nb312nf_end

.nb312nf_outerstart:
	;# ebx contains number of outer iterations
	add ebx, [rsp + nb312nf_nouter]
	mov [rsp + nb312nf_nouter], ebx

.nb312nf_outer:
	mov   rax, [rsp + nb312nf_shift]      ;# rax = pointer into shift[] 
	mov   ebx, [rax+rsi*4]		;# rbx=shift[n] 
	
	lea   rbx, [rbx + rbx*2]    ;# rbx=3*is 

	mov   rax, [rsp + nb312nf_shiftvec]   ;# rax = base of shiftvec[] 

	movsd xmm0, [rax + rbx*8]
	movsd xmm1, [rax + rbx*8 + 8]
	movsd xmm2, [rax + rbx*8 + 16] 

	mov   rcx, [rsp + nb312nf_iinr]       ;# rcx = pointer into iinr[] 	
	mov   ebx, [rcx+rsi*4]	    ;# ebx =ii 

	lea   rbx, [rbx + rbx*2]	;# rbx = 3*ii=ii3 
	mov   rax, [rbp + nb312nf_pos]    ;# rax = base of pos[]  
	mov   [rsp + nb312nf_ii3], ebx	
	
	movapd xmm3, xmm0
	movapd xmm4, xmm1
	movapd xmm5, xmm2
	addsd xmm3, [rax + rbx*8]
	addsd xmm4, [rax + rbx*8 + 8]
	addsd xmm5, [rax + rbx*8 + 16]		
	shufpd xmm3, xmm3, 0
	shufpd xmm4, xmm4, 0
	shufpd xmm5, xmm5, 0
	movapd [rsp + nb312nf_ixO], xmm3
	movapd [rsp + nb312nf_iyO], xmm4
	movapd [rsp + nb312nf_izO], xmm5

	movsd xmm3, xmm0
	movsd xmm4, xmm1
	movsd xmm5, xmm2
	addsd xmm0, [rax + rbx*8 + 24]
	addsd xmm1, [rax + rbx*8 + 32]
	addsd xmm2, [rax + rbx*8 + 40]		
	addsd xmm3, [rax + rbx*8 + 48]
	addsd xmm4, [rax + rbx*8 + 56]
	addsd xmm5, [rax + rbx*8 + 64]		

	shufpd xmm0, xmm0, 0
	shufpd xmm1, xmm1, 0
	shufpd xmm2, xmm2, 0
	shufpd xmm3, xmm3, 0
	shufpd xmm4, xmm4, 0
	shufpd xmm5, xmm5, 0
	movapd [rsp + nb312nf_ixH1], xmm0
	movapd [rsp + nb312nf_iyH1], xmm1
	movapd [rsp + nb312nf_izH1], xmm2
	movapd [rsp + nb312nf_ixH2], xmm3
	movapd [rsp + nb312nf_iyH2], xmm4
	movapd [rsp + nb312nf_izH2], xmm5

	;# clear vctot 
	xorpd xmm4, xmm4
	movapd [rsp + nb312nf_vctot], xmm4
	movapd [rsp + nb312nf_Vvdwtot], xmm4
	
	mov   rax, [rsp + nb312nf_jindex]
	mov   ecx, [rax +rsi*4]	     ;# jindex[n] 
	mov   edx, [rax +rsi*4 + 4]	     ;# jindex[n+1] 
	sub   edx, ecx               ;# number of innerloop atoms 

	mov   rsi, [rbp + nb312nf_pos]
	mov   rax, [rsp + nb312nf_jjnr]
	shl   ecx, 2
	add   rax, rcx
	mov   [rsp + nb312nf_innerjjnr], rax     ;# pointer to jjnr[nj0] 
	mov   ecx, edx
	sub   edx,  2
	add   ecx, [rsp + nb312nf_ninner]
	mov   [rsp + nb312nf_ninner], ecx
	add   edx, 0
	mov   [rsp + nb312nf_innerk], edx    ;# number of innerloop atoms 
	jge   .nb312nf_unroll_loop
	jmp   .nb312nf_checksingle
.nb312nf_unroll_loop:	
	;# twice unrolled innerloop here 
	mov   rdx, [rsp + nb312nf_innerjjnr]     ;# pointer to jjnr[k] 
	mov   eax, [rdx]	
	mov   ebx, [rdx + 4] 
	
	add qword ptr [rsp + nb312nf_innerjjnr], 8 ;# advance pointer (unrolled 2) 

	mov rsi, [rbp + nb312nf_pos]       ;# base of pos[] 

	lea   rax, [rax + rax*2]     ;# replace jnr with j3 
	lea   rbx, [rbx + rbx*2]	
	
	;# move j coordinates to local temp variables 
	movlpd xmm2, [rsi + rax*8]
	movlpd xmm3, [rsi + rax*8 + 8]
	movlpd xmm4, [rsi + rax*8 + 16]
	movlpd xmm5, [rsi + rax*8 + 24]
	movlpd xmm6, [rsi + rax*8 + 32]
	movlpd xmm7, [rsi + rax*8 + 40]
	movhpd xmm2, [rsi + rbx*8]
	movhpd xmm3, [rsi + rbx*8 + 8]
	movhpd xmm4, [rsi + rbx*8 + 16]
	movhpd xmm5, [rsi + rbx*8 + 24]
	movhpd xmm6, [rsi + rbx*8 + 32]
	movhpd xmm7, [rsi + rbx*8 + 40]
	movapd 	[rsp + nb312nf_jxO], xmm2
	movapd 	[rsp + nb312nf_jyO], xmm3
	movapd 	[rsp + nb312nf_jzO], xmm4
	movapd 	[rsp + nb312nf_jxH1], xmm5
	movapd 	[rsp + nb312nf_jyH1], xmm6
	movapd 	[rsp + nb312nf_jzH1], xmm7
	movlpd xmm2, [rsi + rax*8 + 48]
	movlpd xmm3, [rsi + rax*8 + 56]
	movlpd xmm4, [rsi + rax*8 + 64]
	movhpd xmm2, [rsi + rbx*8 + 48]
	movhpd xmm3, [rsi + rbx*8 + 56]
	movhpd xmm4, [rsi + rbx*8 + 64]
	movapd 	[rsp + nb312nf_jxH2], xmm2
	movapd 	[rsp + nb312nf_jyH2], xmm3
	movapd 	[rsp + nb312nf_jzH2], xmm4
	
	movapd xmm0, [rsp + nb312nf_ixO]
	movapd xmm1, [rsp + nb312nf_iyO]
	movapd xmm2, [rsp + nb312nf_izO]
	movapd xmm3, [rsp + nb312nf_ixO]
	movapd xmm4, [rsp + nb312nf_iyO]
	movapd xmm5, [rsp + nb312nf_izO]
	subpd  xmm0, [rsp + nb312nf_jxO]
	subpd  xmm1, [rsp + nb312nf_jyO]
	subpd  xmm2, [rsp + nb312nf_jzO]
	subpd  xmm3, [rsp + nb312nf_jxH1]
	subpd  xmm4, [rsp + nb312nf_jyH1]
	subpd  xmm5, [rsp + nb312nf_jzH1]
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm3, xmm4
	addpd  xmm3, xmm5
	movapd [rsp + nb312nf_rsqOO], xmm0
	movapd [rsp + nb312nf_rsqOH1], xmm3

	movapd xmm0, [rsp + nb312nf_ixO]
	movapd xmm1, [rsp + nb312nf_iyO]
	movapd xmm2, [rsp + nb312nf_izO]
	movapd xmm3, [rsp + nb312nf_ixH1]
	movapd xmm4, [rsp + nb312nf_iyH1]
	movapd xmm5, [rsp + nb312nf_izH1]
	subpd  xmm0, [rsp + nb312nf_jxH2]
	subpd  xmm1, [rsp + nb312nf_jyH2]
	subpd  xmm2, [rsp + nb312nf_jzH2]
	subpd  xmm3, [rsp + nb312nf_jxO]
	subpd  xmm4, [rsp + nb312nf_jyO]
	subpd  xmm5, [rsp + nb312nf_jzO]
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm3, xmm4
	addpd  xmm3, xmm5
	movapd [rsp + nb312nf_rsqOH2], xmm0
	movapd [rsp + nb312nf_rsqH1O], xmm3

	movapd xmm0, [rsp + nb312nf_ixH1]
	movapd xmm1, [rsp + nb312nf_iyH1]
	movapd xmm2, [rsp + nb312nf_izH1]
	movapd xmm3, [rsp + nb312nf_ixH1]
	movapd xmm4, [rsp + nb312nf_iyH1]
	movapd xmm5, [rsp + nb312nf_izH1]
	subpd  xmm0, [rsp + nb312nf_jxH1]
	subpd  xmm1, [rsp + nb312nf_jyH1]
	subpd  xmm2, [rsp + nb312nf_jzH1]
	subpd  xmm3, [rsp + nb312nf_jxH2]
	subpd  xmm4, [rsp + nb312nf_jyH2]
	subpd  xmm5, [rsp + nb312nf_jzH2]
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm3, xmm4
	addpd  xmm3, xmm5
	movapd [rsp + nb312nf_rsqH1H1], xmm0
	movapd [rsp + nb312nf_rsqH1H2], xmm3

	movapd xmm0, [rsp + nb312nf_ixH2]
	movapd xmm1, [rsp + nb312nf_iyH2]
	movapd xmm2, [rsp + nb312nf_izH2]
	movapd xmm3, [rsp + nb312nf_ixH2]
	movapd xmm4, [rsp + nb312nf_iyH2]
	movapd xmm5, [rsp + nb312nf_izH2]
	subpd  xmm0, [rsp + nb312nf_jxO]
	subpd  xmm1, [rsp + nb312nf_jyO]
	subpd  xmm2, [rsp + nb312nf_jzO]
	subpd  xmm3, [rsp + nb312nf_jxH1]
	subpd  xmm4, [rsp + nb312nf_jyH1]
	subpd  xmm5, [rsp + nb312nf_jzH1]
	mulpd  xmm0, xmm0
	mulpd  xmm1, xmm1
	mulpd  xmm2, xmm2
	mulpd  xmm3, xmm3
	mulpd  xmm4, xmm4
	mulpd  xmm5, xmm5
	addpd  xmm0, xmm1
	addpd  xmm0, xmm2
	addpd  xmm4, xmm3
	addpd  xmm4, xmm5
	movapd [rsp + nb312nf_rsqH2O], xmm0
	movapd [rsp + nb312nf_rsqH2H1], xmm4

	movapd xmm0, [rsp + nb312nf_ixH2]
	movapd xmm1, [rsp + nb312nf_iyH2]
	movapd xmm2, [rsp + nb312nf_izH2]
	subpd  xmm0, [rsp + nb312nf_jxH2]
	subpd  xmm1, [rsp + nb312nf_jyH2]
	subpd  xmm2, [rsp + nb312nf_jzH2]
	mulpd xmm0, xmm0
	mulpd xmm1, xmm1
	mulpd xmm2, xmm2
	addpd xmm0, xmm1
	addpd xmm0, xmm2
	movapd [rsp + nb312nf_rsqH2H2], xmm0
	
	;# start doing invsqrt use rsq values in xmm0, xmm4 
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312nf_half] ;# iter1 
	mulpd   xmm7, [rsp + nb312nf_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvH2H2], xmm1
	movapd [rsp + nb312nf_rinvH2H1], xmm5

	movapd xmm0, [rsp + nb312nf_rsqOO]
	movapd xmm4, [rsp + nb312nf_rsqOH1]	
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312nf_half] ;# iter1 of  
	mulpd   xmm7, [rsp + nb312nf_half] ;# iter1 of  

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312nf_half] ;# rinv
	movapd [rsp + nb312nf_rinvOO], xmm1
	movapd [rsp + nb312nf_rinvOH1], xmm5

	movapd xmm0, [rsp + nb312nf_rsqOH2]
	movapd xmm4, [rsp + nb312nf_rsqH1O]	
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312nf_half] ;# iter1 
	mulpd   xmm7, [rsp + nb312nf_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvOH2], xmm1
	movapd [rsp + nb312nf_rinvH1O], xmm5

	movapd xmm0, [rsp + nb312nf_rsqH1H1]
	movapd xmm4, [rsp + nb312nf_rsqH1H2]	
	cvtpd2ps xmm1, xmm0	
	cvtpd2ps xmm5, xmm4	
	rsqrtps xmm1, xmm1
	rsqrtps xmm5, xmm5
	cvtps2pd xmm1, xmm1
	cvtps2pd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulpd   xmm1, xmm1	;# luA*luA 
	mulpd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	mulpd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subpd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm3, [rsp + nb312nf_half] ;# iter1a 
	mulpd   xmm7, [rsp + nb312nf_half] ;# iter1b 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulpd   xmm3, xmm3	;# luA*luA 
	mulpd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	mulpd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subpd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulpd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulpd   xmm5, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvH1H1], xmm1
	movapd [rsp + nb312nf_rinvH1H2], xmm5

	movapd xmm0, [rsp + nb312nf_rsqH2O]
	cvtpd2ps xmm1, xmm0	
	rsqrtps xmm1, xmm1
	cvtps2pd xmm1, xmm1
	
	movapd  xmm2, xmm1	;# copy of luA 
	mulpd   xmm1, xmm1	;# luA*luA 
	movapd  xmm3, [rsp + nb312nf_three]
	mulpd   xmm1, xmm0	;# rsqA*luA*luA 
	subpd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	mulpd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm3, [rsp + nb312nf_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	mulpd   xmm3, xmm3	;# luA*luA 
	movapd  xmm1, [rsp + nb312nf_three]
	mulpd   xmm3, xmm0	;# rsqA*luA*luA 
	subpd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	mulpd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulpd   xmm1, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvH2O], xmm1
	
	;# start with OO interaction 
	movapd xmm0, [rsp + nb312nf_rinvOO]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqOO] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]

	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOO]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 
    ;# increment vcoul - then we can get rid of mm5 
    ;# update vctot 
    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# start doing lj 
	movapd xmm2, xmm0
	mulpd  xmm2, xmm2
	movapd xmm1, xmm2
	mulpd  xmm1, xmm2
	mulpd  xmm1, xmm2	;# xmm1=rinvsix 
	movapd xmm2, xmm1
	mulpd  xmm2, xmm2	;# xmm2=rinvtwelve 
	mulpd  xmm1, [rsp + nb312nf_c6]
	mulpd  xmm2, [rsp + nb312nf_c12]
	movapd xmm4, xmm2
	subpd  xmm4, xmm1
	addpd  xmm4, [rsp + nb312nf_Vvdwtot]
	movapd [rsp + nb312nf_Vvdwtot], xmm4

	;# O-H1 interaction 
	movapd xmm0, [rsp + nb312nf_rinvOH1]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqOH1] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]

	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# O-H2 interaction  
	movapd xmm0, [rsp + nb312nf_rinvOH2]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqOH2] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]
	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# H1-O interaction 
	movapd xmm0, [rsp + nb312nf_rinvH1O]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqH1O] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]
	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# H1-H1 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH1H1]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqH1H1] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# H1-H2 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH1H2]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqH1H2] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# H2-O interaction 
	movapd xmm0, [rsp + nb312nf_rinvH2O]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqH2O] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# H2-H1 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH2H1]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqH2H1] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# H2-H2 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH2H2]
	movapd xmm1, xmm0
	mulpd  xmm1, [rsp + nb312nf_rsqH2H2] ;# xmm1=r 
	mulpd  xmm1, [rsp + nb312nf_tsc]	
	cvttpd2pi mm6, xmm1	;# mm6 = lu idx 
	cvtpi2pd xmm6, mm6
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	pslld mm6, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ebx, mm6		;# indices in eax/ebx 

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	movapd xmm3, [rsi + rbx*8]	;# Y2 F2 
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 Y2 
	unpckhpd xmm5, xmm3	;# F1 F2 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	movapd xmm3, [rsi + rbx*8 + 16]	;# G2 H2 
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 G2 
	unpckhpd xmm7, xmm3	;# H1 H2 
	;# coulomb table ready, in xmm4-xmm7  		
	mulpd  xmm6, xmm1	;# xmm6=Geps 
	mulpd  xmm7, xmm2	;# xmm7=Heps2 
	addpd  xmm5, xmm6
	addpd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulpd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addpd  xmm5, xmm4 ;# xmm5=VV 
	mulpd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 
	
    addpd  xmm5, [rsp + nb312nf_vctot]
    movapd [rsp + nb312nf_vctot], xmm5

	;# should we do one more iteration? 
	sub dword ptr [rsp + nb312nf_innerk],  2
	jl    .nb312nf_checksingle
	jmp   .nb312nf_unroll_loop
.nb312nf_checksingle:
	mov   edx, [rsp + nb312nf_innerk]
	and   edx, 1
	jnz   .nb312nf_dosingle
	jmp   .nb312nf_updateouterdata
.nb312nf_dosingle:
	mov   rdx, [rsp + nb312nf_innerjjnr]     ;# pointer to jjnr[k] 
	mov   eax, [rdx]

	mov rsi, [rbp + nb312nf_pos]
	lea   rax, [rax + rax*2]  

	;# fetch j coordinates 
	movlpd xmm2, [rsi + rax*8]
	movlpd xmm3, [rsi + rax*8 + 8]
	movlpd xmm4, [rsi + rax*8 + 16]
	movlpd xmm5, [rsi + rax*8 + 24]
	movlpd xmm6, [rsi + rax*8 + 32]
	movlpd xmm7, [rsi + rax*8 + 40]
	movapd 	[rsp + nb312nf_jxO], xmm2
	movapd 	[rsp + nb312nf_jyO], xmm3
	movapd 	[rsp + nb312nf_jzO], xmm4
	movapd 	[rsp + nb312nf_jxH1], xmm5
	movapd 	[rsp + nb312nf_jyH1], xmm6
	movapd 	[rsp + nb312nf_jzH1], xmm7
	movlpd xmm2, [rsi + rax*8 + 48]
	movlpd xmm3, [rsi + rax*8 + 56]
	movlpd xmm4, [rsi + rax*8 + 64]
	movapd 	[rsp + nb312nf_jxH2], xmm2
	movapd 	[rsp + nb312nf_jyH2], xmm3
	movapd 	[rsp + nb312nf_jzH2], xmm4
	
	movapd xmm0, [rsp + nb312nf_ixO]
	movapd xmm1, [rsp + nb312nf_iyO]
	movapd xmm2, [rsp + nb312nf_izO]
	movapd xmm3, [rsp + nb312nf_ixO]
	movapd xmm4, [rsp + nb312nf_iyO]
	movapd xmm5, [rsp + nb312nf_izO]
	subsd  xmm0, [rsp + nb312nf_jxO]
	subsd  xmm1, [rsp + nb312nf_jyO]
	subsd  xmm2, [rsp + nb312nf_jzO]
	subsd  xmm3, [rsp + nb312nf_jxH1]
	subsd  xmm4, [rsp + nb312nf_jyH1]
	subsd  xmm5, [rsp + nb312nf_jzH1]
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm3, xmm4
	addsd  xmm3, xmm5
	movapd [rsp + nb312nf_rsqOO], xmm0
	movapd [rsp + nb312nf_rsqOH1], xmm3

	movapd xmm0, [rsp + nb312nf_ixO]
	movapd xmm1, [rsp + nb312nf_iyO]
	movapd xmm2, [rsp + nb312nf_izO]
	movapd xmm3, [rsp + nb312nf_ixH1]
	movapd xmm4, [rsp + nb312nf_iyH1]
	movapd xmm5, [rsp + nb312nf_izH1]
	subsd  xmm0, [rsp + nb312nf_jxH2]
	subsd  xmm1, [rsp + nb312nf_jyH2]
	subsd  xmm2, [rsp + nb312nf_jzH2]
	subsd  xmm3, [rsp + nb312nf_jxO]
	subsd  xmm4, [rsp + nb312nf_jyO]
	subsd  xmm5, [rsp + nb312nf_jzO]
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm3, xmm4
	addsd  xmm3, xmm5
	movapd [rsp + nb312nf_rsqOH2], xmm0
	movapd [rsp + nb312nf_rsqH1O], xmm3

	movapd xmm0, [rsp + nb312nf_ixH1]
	movapd xmm1, [rsp + nb312nf_iyH1]
	movapd xmm2, [rsp + nb312nf_izH1]
	movapd xmm3, [rsp + nb312nf_ixH1]
	movapd xmm4, [rsp + nb312nf_iyH1]
	movapd xmm5, [rsp + nb312nf_izH1]
	subsd  xmm0, [rsp + nb312nf_jxH1]
	subsd  xmm1, [rsp + nb312nf_jyH1]
	subsd  xmm2, [rsp + nb312nf_jzH1]
	subsd  xmm3, [rsp + nb312nf_jxH2]
	subsd  xmm4, [rsp + nb312nf_jyH2]
	subsd  xmm5, [rsp + nb312nf_jzH2]
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm3, xmm4
	addsd  xmm3, xmm5
	movapd [rsp + nb312nf_rsqH1H1], xmm0
	movapd [rsp + nb312nf_rsqH1H2], xmm3

	movapd xmm0, [rsp + nb312nf_ixH2]
	movapd xmm1, [rsp + nb312nf_iyH2]
	movapd xmm2, [rsp + nb312nf_izH2]
	movapd xmm3, [rsp + nb312nf_ixH2]
	movapd xmm4, [rsp + nb312nf_iyH2]
	movapd xmm5, [rsp + nb312nf_izH2]
	subsd  xmm0, [rsp + nb312nf_jxO]
	subsd  xmm1, [rsp + nb312nf_jyO]
	subsd  xmm2, [rsp + nb312nf_jzO]
	subsd  xmm3, [rsp + nb312nf_jxH1]
	subsd  xmm4, [rsp + nb312nf_jyH1]
	subsd  xmm5, [rsp + nb312nf_jzH1]
	mulsd  xmm0, xmm0
	mulsd  xmm1, xmm1
	mulsd  xmm2, xmm2
	mulsd  xmm3, xmm3
	mulsd  xmm4, xmm4
	mulsd  xmm5, xmm5
	addsd  xmm0, xmm1
	addsd  xmm0, xmm2
	addsd  xmm4, xmm3
	addsd  xmm4, xmm5
	movapd [rsp + nb312nf_rsqH2O], xmm0
	movapd [rsp + nb312nf_rsqH2H1], xmm4

	movapd xmm0, [rsp + nb312nf_ixH2]
	movapd xmm1, [rsp + nb312nf_iyH2]
	movapd xmm2, [rsp + nb312nf_izH2]
	subsd  xmm0, [rsp + nb312nf_jxH2]
	subsd  xmm1, [rsp + nb312nf_jyH2]
	subsd  xmm2, [rsp + nb312nf_jzH2]
	mulsd xmm0, xmm0
	mulsd xmm1, xmm1
	mulsd xmm2, xmm2
	addsd xmm0, xmm1
	addsd xmm0, xmm2
	movapd [rsp + nb312nf_rsqH2H2], xmm0
	
	;# start doing invsqrt use rsq values in xmm0, xmm4 
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312nf_half] ;# iter1 
	mulsd   xmm7, [rsp + nb312nf_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvH2H2], xmm1
	movapd [rsp + nb312nf_rinvH2H1], xmm5

	movapd xmm0, [rsp + nb312nf_rsqOO]
	movapd xmm4, [rsp + nb312nf_rsqOH1]	
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312nf_half] ;# iter1 of  
	mulsd   xmm7, [rsp + nb312nf_half] ;# iter1 of  

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312nf_half] ;# rinv
	movapd [rsp + nb312nf_rinvOO], xmm1
	movapd [rsp + nb312nf_rinvOH1], xmm5

	movapd xmm0, [rsp + nb312nf_rsqOH2]
	movapd xmm4, [rsp + nb312nf_rsqH1O]	
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312nf_half] ;# iter1 
	mulsd   xmm7, [rsp + nb312nf_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvOH2], xmm1
	movapd [rsp + nb312nf_rinvH1O], xmm5

	movapd xmm0, [rsp + nb312nf_rsqH1H1]
	movapd xmm4, [rsp + nb312nf_rsqH1H2]	
	cvtsd2ss xmm1, xmm0	
	cvtsd2ss xmm5, xmm4	
	rsqrtss xmm1, xmm1
	rsqrtss xmm5, xmm5
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm5, xmm5
	
	movapd  xmm2, xmm1	;# copy of luA 
	movapd  xmm6, xmm5	;# copy of luB 
	mulsd   xmm1, xmm1	;# luA*luA 
	mulsd   xmm5, xmm5	;# luB*luB 
	movapd  xmm3, [rsp + nb312nf_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	mulsd   xmm5, xmm4	;# rsqB*luB*luB 	
	movapd  xmm7, xmm3
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	subsd   xmm7, xmm5	;# 3-rsqB*luB*luB 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm7, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm3, [rsp + nb312nf_half] ;# iter1a 
	mulsd   xmm7, [rsp + nb312nf_half] ;# iter1b 

	movapd  xmm2, xmm3	;# copy of luA 
	movapd  xmm6, xmm7	;# copy of luB 
	mulsd   xmm3, xmm3	;# luA*luA 
	mulsd   xmm7, xmm7	;# luB*luB 
	movapd  xmm1, [rsp + nb312nf_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	mulsd   xmm7, xmm4	;# rsqB*luB*luB 	
	movapd  xmm5, xmm1
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	subsd   xmm5, xmm7	;# 3-rsqB*luB*luB 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm5, xmm6	;# luB*(3-rsqB*luB*luB) 
	mulsd   xmm1, [rsp + nb312nf_half] ;# rinv 
	mulsd   xmm5, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvH1H1], xmm1
	movapd [rsp + nb312nf_rinvH1H2], xmm5

	movapd xmm0, [rsp + nb312nf_rsqH2O]
	cvtsd2ss xmm1, xmm0	
	rsqrtss xmm1, xmm1
	cvtss2sd xmm1, xmm1
	
	movapd  xmm2, xmm1	;# copy of luA 
	mulsd   xmm1, xmm1	;# luA*luA 
	movapd  xmm3, [rsp + nb312nf_three]
	mulsd   xmm1, xmm0	;# rsqA*luA*luA 
	subsd   xmm3, xmm1	;# 3-rsqA*luA*luA 
	mulsd   xmm3, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm3, [rsp + nb312nf_half] ;# iter1 

	movapd  xmm2, xmm3	;# copy of luA 
	mulsd   xmm3, xmm3	;# luA*luA 
	movapd  xmm1, [rsp + nb312nf_three]
	mulsd   xmm3, xmm0	;# rsqA*luA*luA 
	subsd   xmm1, xmm3	;# 3-rsqA*luA*luA 
	mulsd   xmm1, xmm2	;# luA*(3-rsqA*luA*luA) 
	mulsd   xmm1, [rsp + nb312nf_half] ;# rinv 
	movapd [rsp + nb312nf_rinvH2O], xmm1
	
	;# start with OO interaction 
	movapd xmm0, [rsp + nb312nf_rinvOO]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqOO] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]

	movd mm0, eax	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1  

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1  
	unpckhpd xmm7, xmm3	;# H1  
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOO]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 
    ;# increment vcoul - then we can get rid of mm5 
    ;# update vctot 
    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# start doing lj 
	movapd xmm2, xmm0
	mulsd  xmm2, xmm2
	movapd xmm1, xmm2
	mulsd  xmm1, xmm2
	mulsd  xmm1, xmm2	;# xmm1=rinvsix 
	movapd xmm2, xmm1
	mulsd  xmm2, xmm2	;# xmm2=rinvtwelve 
	mulsd  xmm1, [rsp + nb312nf_c6]
	mulsd  xmm2, [rsp + nb312nf_c12]
	movapd xmm4, xmm2
	subsd  xmm4, xmm1
	addsd  xmm4, [rsp + nb312nf_Vvdwtot]
	movlpd [rsp + nb312nf_Vvdwtot], xmm4

	;# O-H1 interaction 
	movapd xmm0, [rsp + nb312nf_rinvOH1]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqOH1] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]

	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1  
	unpckhpd xmm5, xmm3	;# F1  

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV 
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# O-H2 interaction  
	movapd xmm0, [rsp + nb312nf_rinvOH2]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqOH2] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]
	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# H1-O interaction 
	movapd xmm0, [rsp + nb312nf_rinvH1O]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqH1O] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]
	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# H1-H1 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH1H1]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqH1H1] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# H1-H2 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH1H2]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqH1H2] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# H2-O interaction 
	movapd xmm0, [rsp + nb312nf_rinvH2O]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqH2O] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqOH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5

	;# H2-H1 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH2H1]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqH2H1] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subpd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulpd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5
	
	;# H2-H2 interaction 
	movapd xmm0, [rsp + nb312nf_rinvH2H2]
	movapd xmm1, xmm0
	mulsd  xmm1, [rsp + nb312nf_rsqH2H2] ;# xmm1=r 
	mulsd  xmm1, [rsp + nb312nf_tsc]	
	cvttsd2si eax, xmm1	;# mm6 = lu idx 
	cvtsi2sd xmm6, eax
	subsd xmm1, xmm6	;# xmm1=eps 
	movapd xmm2, xmm1	
	mulsd  xmm2, xmm2	;# xmm2=eps2 
	
	shl eax, 2		;# idx *= 4 
	mov  rsi, [rbp + nb312nf_VFtab]

	movapd xmm4, [rsi + rax*8]	;# Y1 F1 	
	xorpd xmm3, xmm3
	movapd xmm5, xmm4
	unpcklpd xmm4, xmm3	;# Y1 
	unpckhpd xmm5, xmm3	;# F1 

	movapd xmm6, [rsi + rax*8 + 16]	;# G1 H1 	
	xorpd xmm3, xmm3
	movapd xmm7, xmm6
	unpcklpd xmm6, xmm3	;# G1 
	unpckhpd xmm7, xmm3	;# H1 
	;# coulomb table ready, in xmm4-xmm7  		
	mulsd  xmm6, xmm1	;# xmm6=Geps 
	mulsd  xmm7, xmm2	;# xmm7=Heps2 
	addsd  xmm5, xmm6
	addsd  xmm5, xmm7	;# xmm5=Fp 	
	movapd xmm3, [rsp + nb312nf_qqHH]
	mulsd  xmm5, xmm1 ;# xmm5=eps*Fp 
	addsd  xmm5, xmm4 ;# xmm5=VV 
	mulsd  xmm5, xmm3 ;# vcoul=qq*VV  
    ;# at this point mm5 contains vcoul 

    addsd  xmm5, [rsp + nb312nf_vctot]
    movlpd [rsp + nb312nf_vctot], xmm5
	
.nb312nf_updateouterdata:
	;# get n from stack
	mov esi, [rsp + nb312nf_n]
        ;# get group index for i particle 
        mov   rdx, [rbp + nb312nf_gid]      	;# base of gid[]
        mov   edx, [rdx + rsi*4]		;# ggid=gid[n]

	;# accumulate total potential energy and update it 
	movapd xmm7, [rsp + nb312nf_vctot]
	;# accumulate 
	movhlps xmm6, xmm7
	addsd  xmm7, xmm6	;# low xmm7 has the sum now 
        
	;# add earlier value from mem 
	mov   rax, [rbp + nb312nf_Vc]
	addsd xmm7, [rax + rdx*8] 
	;# move back to mem 
	movsd [rax + rdx*8], xmm7 
	
	;# accumulate total lj energy and update it 
	movapd xmm7, [rsp + nb312nf_Vvdwtot]
	;# accumulate 
	movhlps xmm6, xmm7
	addsd  xmm7, xmm6	;# low xmm7 has the sum now 

	;# add earlier value from mem 
	mov   rax, [rbp + nb312nf_Vvdw]
	addsd xmm7, [rax + rdx*8] 
	;# move back to mem 
	movsd [rax + rdx*8], xmm7 
	
        ;# finish if last 
        mov ecx, [rsp + nb312nf_nn1]
	;# esi already loaded with n
	inc esi
        sub ecx, esi
        jecxz .nb312nf_outerend

        ;# not last, iterate outer loop once more!  
        mov [rsp + nb312nf_n], esi
        jmp .nb312nf_outer
.nb312nf_outerend:
        ;# check if more outer neighborlists remain
        mov   ecx, [rsp + nb312nf_nri]
	;# esi already loaded with n above
        sub   ecx, esi
        jecxz .nb312nf_end
        ;# non-zero, do one more workunit
        jmp   .nb312nf_threadloop
.nb312nf_end:
	mov eax, [rsp + nb312nf_nouter]
	mov ebx, [rsp + nb312nf_ninner]
	mov rcx, [rbp + nb312nf_outeriter]
	mov rdx, [rbp + nb312nf_inneriter]
	mov [rcx], eax
	mov [rdx], ebx

	add rsp, 840
	femms

	pop rbx
	pop	rbp
	ret

