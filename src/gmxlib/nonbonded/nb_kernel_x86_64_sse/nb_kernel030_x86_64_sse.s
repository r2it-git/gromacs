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



.globl nb_kernel030_x86_64_sse
.globl _nb_kernel030_x86_64_sse
nb_kernel030_x86_64_sse:	
_nb_kernel030_x86_64_sse:	
;#	Room for return address and rbp (16 bytes)
.equiv          nb030_fshift,           16
.equiv          nb030_gid,              24
.equiv          nb030_pos,              32
.equiv          nb030_faction,          40
.equiv          nb030_charge,           48
.equiv          nb030_p_facel,          56
.equiv          nb030_argkrf,           64
.equiv          nb030_argcrf,           72
.equiv          nb030_Vc,               80
.equiv          nb030_type,             88
.equiv          nb030_p_ntype,          96
.equiv          nb030_vdwparam,         104
.equiv          nb030_Vvdw,             112
.equiv          nb030_p_tabscale,       120
.equiv          nb030_VFtab,            128
.equiv          nb030_invsqrta,         136
.equiv          nb030_dvda,             144
.equiv          nb030_p_gbtabscale,     152
.equiv          nb030_GBtab,            160
.equiv          nb030_p_nthreads,       168
.equiv          nb030_count,            176
.equiv          nb030_mtx,              184
.equiv          nb030_outeriter,        192
.equiv          nb030_inneriter,        200
.equiv          nb030_work,             208
	;# stack offsets for local variables  
	;# bottom of stack is cache-aligned for sse use 
.equiv          nb030_ix,               0
.equiv          nb030_iy,               16
.equiv          nb030_iz,               32
.equiv          nb030_dx,               48
.equiv          nb030_dy,               64
.equiv          nb030_dz,               80
.equiv          nb030_two,              96
.equiv          nb030_tsc,              112
.equiv          nb030_c6,               128
.equiv          nb030_c12,              144
.equiv          nb030_fscal,            160
.equiv          nb030_Vvdwtot,          176
.equiv          nb030_fix,              192
.equiv          nb030_fiy,              208
.equiv          nb030_fiz,              224
.equiv          nb030_half,             240
.equiv          nb030_three,            256
.equiv          nb030_is3,              272
.equiv          nb030_ii3,              276
.equiv          nb030_nri,              280
.equiv          nb030_iinr,             288
.equiv          nb030_jindex,           296
.equiv          nb030_jjnr,             304
.equiv          nb030_shift,            312
.equiv          nb030_shiftvec,         320
.equiv          nb030_innerjjnr,        328
.equiv          nb030_ntia,             336
.equiv          nb030_innerk,           340
.equiv          nb030_n,                344
.equiv          nb030_nn1,              348
.equiv          nb030_ntype,            352
.equiv          nb030_nouter,           356
.equiv          nb030_ninner,           360

	push rbp
	mov  rbp, rsp
	push rbx

        sub rsp, 376		; # local variable stack space (n*16+8)
	femms

	;# zero 32-bit iteration counters
	mov eax, 0
	mov [rsp + nb030_nouter], eax
	mov [rsp + nb030_ninner], eax

	mov edi, [rdi]
	mov [rsp + nb030_nri], edi
	mov [rsp + nb030_iinr], rsi
	mov [rsp + nb030_jindex], rdx
	mov [rsp + nb030_jjnr], rcx
	mov [rsp + nb030_shift], r8
	mov [rsp + nb030_shiftvec], r9
	mov rdi, [rbp + nb030_p_ntype]
	mov edi, [rdi]
	mov [rsp + nb030_ntype], edi

	mov rax, [rbp + nb030_p_tabscale]
	movss xmm3, [rax]
	shufps xmm3, xmm3, 0
	movaps [rsp + nb030_tsc], xmm3

	;# create constant floating-point factors on stack
	mov eax, 0x3f000000     ;# half in IEEE (hex)
	mov [rsp + nb030_half], eax
	movss xmm1, [rsp + nb030_half]
	shufps xmm1, xmm1, 0    ;# splat to all elements
	movaps xmm2, xmm1       
	addps  xmm2, xmm2	;# one
	movaps xmm3, xmm2
	addps  xmm2, xmm2	;# two
	addps  xmm3, xmm2	;# three
	movaps [rsp + nb030_half],  xmm1
	movaps [rsp + nb030_two], xmm2
	movaps [rsp + nb030_three],  xmm3

.nb030_threadloop:
        mov   rsi, [rbp + nb030_count]          ;# pointer to sync counter
        mov   eax, [rsi]
.nb030_spinlock:
        mov   ebx, eax                          ;# ebx=*count=nn0
        add   ebx, 1                           ;# ebx=nn1=nn0+10
        lock cmpxchg [rsi], ebx                 ;# write nn1 to *counter,
                                                ;# if it hasnt changed.
                                                ;# or reread *counter to eax.
        pause                                   ;# -> better p4 performance
        jnz .nb030_spinlock

        ;# if(nn1>nri) nn1=nri
        mov ecx, [rsp + nb030_nri]
        mov edx, ecx
        sub ecx, ebx
        cmovle ebx, edx                         ;# if(nn1>nri) nn1=nri
        ;# Cleared the spinlock if we got here.
        ;# eax contains nn0, ebx contains nn1.
        mov [rsp + nb030_n], eax
        mov [rsp + nb030_nn1], ebx
        sub ebx, eax                            ;# calc number of outer lists
	mov esi, eax				;# copy n to esi
        jg  .nb030_outerstart
        jmp .nb030_end

.nb030_outerstart:
	;# ebx contains number of outer iterations
	add ebx, [rsp + nb030_nouter]
	mov [rsp + nb030_nouter], ebx

.nb030_outer:
	mov   rax, [rsp + nb030_shift]      ;# rax = pointer into shift[] 
	mov   ebx, [rax+rsi*4]			;# ebx=shift[n] 
	
	lea   rbx, [rbx + rbx*2]    ;# rbx=3*is 
	mov   [rsp + nb030_is3],ebx    	;# store is3 

	mov   rax, [rsp + nb030_shiftvec]   ;# rax = base of shiftvec[] 

	movss xmm0, [rax + rbx*4]
	movss xmm1, [rax + rbx*4 + 4]
	movss xmm2, [rax + rbx*4 + 8] 

	mov   rcx, [rsp + nb030_iinr]       ;# rcx = pointer into iinr[] 	
	mov   ebx, [rcx+rsi*4]	    ;# ebx =ii 

    	mov   rdx, [rbp + nb030_type] 
    	mov   edx, [rdx + rbx*4]
    	imul  edx, [rsp + nb030_ntype]
    	shl   edx, 1
    	mov   [rsp + nb030_ntia], edx
	
	lea   rbx, [rbx + rbx*2]	;# rbx = 3*ii=ii3 
	mov   rax, [rbp + nb030_pos]    ;# rax = base of pos[]  

	addss xmm0, [rax + rbx*4]
	addss xmm1, [rax + rbx*4 + 4]
	addss xmm2, [rax + rbx*4 + 8]
	
	shufps xmm0, xmm0, 0
	shufps xmm1, xmm1, 0
	shufps xmm2, xmm2, 0

	movaps [rsp + nb030_ix], xmm0
	movaps [rsp + nb030_iy], xmm1
	movaps [rsp + nb030_iz], xmm2

	mov   [rsp + nb030_ii3], ebx
	
	;# clear tot potential and i forces 
	xorps xmm4, xmm4
	movaps [rsp + nb030_Vvdwtot], xmm4
	movaps [rsp + nb030_fix], xmm4
	movaps [rsp + nb030_fiy], xmm4
	movaps [rsp + nb030_fiz], xmm4
	
	mov   rax, [rsp + nb030_jindex]
	mov   ecx, [rax + rsi*4]	     ;# jindex[n] 
	mov   edx, [rax + rsi*4+ 4]	     ;# jindex[n+1] 
	sub   edx, ecx               ;# number of innerloop atoms 

	mov   rsi, [rbp + nb030_pos]
	mov   rdi, [rbp + nb030_faction]	
	mov   rax, [rsp + nb030_jjnr]
	shl   ecx, 2
	add   rax, rcx
	mov   [rsp + nb030_innerjjnr], rax     ;# pointer to jjnr[nj0] 
	mov   ecx, edx
	sub   edx,  4
	add   ecx, [rsp + nb030_ninner]
	mov   [rsp + nb030_ninner], ecx
	add   edx, 0
	mov   [rsp + nb030_innerk], edx    ;# number of innerloop atoms 
	jge   .nb030_unroll_loop
	jmp   .nb030_finish_inner
.nb030_unroll_loop:	
	;# quad-unroll innerloop here 
	mov   rdx, [rsp + nb030_innerjjnr]     ;# pointer to jjnr[k] 
	mov   eax, [rdx]	
	mov   ebx, [rdx + 4]              
	mov   ecx, [rdx + 8]            
	mov   edx, [rdx + 12]         ;# eax-edx=jnr1-4 
	add qword ptr [rsp + nb030_innerjjnr],  16 ;# advance pointer (unrolled 4) 

	movd  mm0, eax		;# use mmx registers as temp storage 
	movd  mm1, ebx
	movd  mm2, ecx
	movd  mm3, edx
	
	mov rsi, [rbp + nb030_type]
	mov eax, [rsi + rax*4]
	mov ebx, [rsi + rbx*4]
	mov ecx, [rsi + rcx*4]
	mov edx, [rsi + rdx*4]
	mov rsi, [rbp + nb030_vdwparam]
	shl eax, 1	
	shl ebx, 1	
	shl ecx, 1	
	shl edx, 1	
	mov edi, [rsp + nb030_ntia]
	add eax, edi
	add ebx, edi
	add ecx, edi
	add edx, edi

	movlps xmm6, [rsi + rax*4]
	movlps xmm7, [rsi + rcx*4]
	movhps xmm6, [rsi + rbx*4]
	movhps xmm7, [rsi + rdx*4]

	movaps xmm4, xmm6
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm6, xmm7, 221  ;# 11011101
	
	movd  eax, mm0		
	movd  ebx, mm1
	movd  ecx, mm2
	movd  edx, mm3

	movaps [rsp + nb030_c6], xmm4
	movaps [rsp + nb030_c12], xmm6
	
	mov rsi, [rbp + nb030_pos]       ;# base of pos[] 

	lea   rax, [rax + rax*2]     ;# replace jnr with j3 
	lea   rbx, [rbx + rbx*2]	

	lea   rcx, [rcx + rcx*2]     ;# replace jnr with j3 
	lea   rdx, [rdx + rdx*2]	

	;# move four coordinates to xmm0-xmm2 	

	movlps xmm4, [rsi + rax*4]
	movlps xmm5, [rsi + rcx*4]
	movss xmm2, [rsi + rax*4 + 8]
	movss xmm6, [rsi + rcx*4 + 8]

	movhps xmm4, [rsi + rbx*4]
	movhps xmm5, [rsi + rdx*4]

	movss xmm0, [rsi + rbx*4 + 8]
	movss xmm1, [rsi + rdx*4 + 8]

	shufps xmm2, xmm0, 0
	shufps xmm6, xmm1, 0
	
	movaps xmm0, xmm4
	movaps xmm1, xmm4

	shufps xmm2, xmm6, 136  ;# 10001000
	
	shufps xmm0, xmm5, 136  ;# 10001000
	shufps xmm1, xmm5, 221  ;# 11011101		

	;# move nb030_ix-iz to xmm4-xmm6 
	movaps xmm4, [rsp + nb030_ix]
	movaps xmm5, [rsp + nb030_iy]
	movaps xmm6, [rsp + nb030_iz]

	;# calc dr 
	subps xmm4, xmm0
	subps xmm5, xmm1
	subps xmm6, xmm2

	;# store dr 
	movaps [rsp + nb030_dx], xmm4
	movaps [rsp + nb030_dy], xmm5
	movaps [rsp + nb030_dz], xmm6
	;# square it 
	mulps xmm4,xmm4
	mulps xmm5,xmm5
	mulps xmm6,xmm6
	addps xmm4, xmm5
	addps xmm4, xmm6
	;# rsq in xmm4 

	rsqrtps xmm5, xmm4
	;# lookup seed in xmm5 
	movaps xmm2, xmm5
	mulps xmm5, xmm5
	movaps xmm1, [rsp + nb030_three]
	mulps xmm5, xmm4	;# rsq*lu*lu 			
	movaps xmm0, [rsp + nb030_half]
	subps xmm1, xmm5	;# 30-rsq*lu*lu 
	mulps xmm1, xmm2	
	mulps xmm0, xmm1	;# xmm0=rinv 
	mulps xmm4, xmm0	;# xmm4=r 
	mulps xmm4, [rsp + nb030_tsc]

	movhlps xmm5, xmm4
	cvttps2pi mm6, xmm4
	cvttps2pi mm7, xmm5	;# mm6/mm7 contain lu indices 
	cvtpi2ps xmm6, mm6
	cvtpi2ps xmm5, mm7
	movlhps xmm6, xmm5
	subps xmm4, xmm6	
	movaps xmm1, xmm4	;# xmm1=eps 
	movaps xmm2, xmm1	
	mulps  xmm2, xmm2	;# xmm2=eps2 
	pslld mm6, 3
	pslld mm7, 3

	movd mm0, eax	
	movd mm1, ebx
	movd mm2, ecx
	movd mm3, edx

	mov  rsi, [rbp + nb030_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ecx, mm7
	psrlq mm7, 32
	movd ebx, mm6
	movd edx, mm7

	;# dispersion 
	movlps xmm5, [rsi + rax*4 + 0]
	movlps xmm7, [rsi + rcx*4 + 0]
	movhps xmm5, [rsi + rbx*4 + 0]
	movhps xmm7, [rsi + rdx*4 + 0] ;# got half dispersion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm5, xmm7, 221  ;# 11011101
	
	movlps xmm7, [rsi + rax*4 + 8]
	movlps xmm3, [rsi + rcx*4 + 8]
	movhps xmm7, [rsi + rbx*4 + 8]
	movhps xmm3, [rsi + rdx*4 + 8] ;# other half of dispersion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm3, 136  ;# 10001000
	shufps xmm7, xmm3, 221  ;# 11011101
	;# dispersion table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm7, [rsp + nb030_two]	;# two*Heps2 
	addps  xmm7, xmm6
	addps  xmm7, xmm5 ;# xmm7=FF 
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 

	movaps xmm4, [rsp + nb030_c6]
	mulps  xmm7, xmm4	 ;# fijD 
	mulps  xmm5, xmm4	 ;# Vvdw6 

	;# put scalar force on stack Update Vvdwtot directly 
	addps  xmm5, [rsp + nb030_Vvdwtot]
	movaps [rsp + nb030_fscal], xmm7
	movaps [rsp + nb030_Vvdwtot], xmm5

	;# repulsion 
	movlps xmm5, [rsi + rax*4 + 16]
	movlps xmm7, [rsi + rcx*4 + 16]
	movhps xmm5, [rsi + rbx*4 + 16]
	movhps xmm7, [rsi + rdx*4 + 16] ;# got half repulsion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm5, xmm7, 221  ;# 11011101

	movlps xmm7, [rsi + rax*4 + 24]
	movlps xmm3, [rsi + rcx*4 + 24]
	movhps xmm7, [rsi + rbx*4 + 24]
	movhps xmm3, [rsi + rdx*4 + 24] ;# other half of repulsion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm3, 136  ;# 10001000
	shufps xmm7, xmm3, 221  ;# 11011101
	;# table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm7, [rsp + nb030_two]	;# two*Heps2 
	addps  xmm7, xmm6
	addps  xmm7, xmm5 ;# xmm7=FF 
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 
	
	movaps xmm4, [rsp + nb030_c12]
	mulps  xmm7, xmm4 
	mulps  xmm5, xmm4  
	addps  xmm7, [rsp + nb030_fscal] 
	
	addps  xmm5, [rsp + nb030_Vvdwtot]
	movaps [rsp + nb030_Vvdwtot], xmm5
	xorps  xmm4, xmm4

	mulps xmm7, [rsp + nb030_tsc]
	mulps xmm7, xmm0
	subps  xmm4, xmm7

	movaps xmm0, [rsp + nb030_dx]
	movaps xmm1, [rsp + nb030_dy]
	movaps xmm2, [rsp + nb030_dz]

	movd eax, mm0	
	movd ebx, mm1
	movd ecx, mm2
	movd edx, mm3

	mov    rdi, [rbp + nb030_faction]
	mulps  xmm0, xmm4
	mulps  xmm1, xmm4
	mulps  xmm2, xmm4
	;# xmm0-xmm2 contains tx-tz (partial force) 
	;# now update f_i 
	movaps xmm3, [rsp + nb030_fix]
	movaps xmm4, [rsp + nb030_fiy]
	movaps xmm5, [rsp + nb030_fiz]
	addps  xmm3, xmm0
	addps  xmm4, xmm1
	addps  xmm5, xmm2
	movaps [rsp + nb030_fix], xmm3
	movaps [rsp + nb030_fiy], xmm4
	movaps [rsp + nb030_fiz], xmm5
	;# the fj's - start by accumulating x & y forces from memory 
	movlps xmm4, [rdi + rax*4]
	movlps xmm6, [rdi + rcx*4]
	movhps xmm4, [rdi + rbx*4]
	movhps xmm6, [rdi + rdx*4]

	movaps xmm3, xmm4
	shufps xmm3, xmm6, 136  ;# 10001000
	shufps xmm4, xmm6, 221  ;# 11011101			      

	;# now xmm3-xmm5 contains fjx, fjy, fjz 
	subps  xmm3, xmm0
	subps  xmm4, xmm1
	
	;# unpack them back so we can store them - first x & y in xmm3/xmm4 

	movaps xmm6, xmm3
	unpcklps xmm6, xmm4
	unpckhps xmm3, xmm4	
	;# xmm6(l)=x & y for j1, (h) for j2 
	;# xmm3(l)=x & y for j3, (h) for j4 
	movlps [rdi + rax*4], xmm6
	movlps [rdi + rcx*4], xmm3
	
	movhps [rdi + rbx*4], xmm6
	movhps [rdi + rdx*4], xmm3

	;# and the z forces 
	movss  xmm4, [rdi + rax*4 + 8]
	movss  xmm5, [rdi + rbx*4 + 8]
	movss  xmm6, [rdi + rcx*4 + 8]
	movss  xmm7, [rdi + rdx*4 + 8]
	subss  xmm4, xmm2
	shufps xmm2, xmm2, 229  ;# 11100101
	subss  xmm5, xmm2
	shufps xmm2, xmm2, 234  ;# 11101010
	subss  xmm6, xmm2
	shufps xmm2, xmm2, 255  ;# 11111111
	subss  xmm7, xmm2
	movss  [rdi + rax*4 + 8], xmm4
	movss  [rdi + rbx*4 + 8], xmm5
	movss  [rdi + rcx*4 + 8], xmm6
	movss  [rdi + rdx*4 + 8], xmm7
	
	;# should we do one more iteration? 
	sub dword ptr [rsp + nb030_innerk],  4
	jl    .nb030_finish_inner
	jmp   .nb030_unroll_loop
.nb030_finish_inner:
	;# check if at least two particles remain 
	add dword ptr [rsp + nb030_innerk],  4
	mov   edx, [rsp + nb030_innerk]
	and   edx, 2
	jnz   .nb030_dopair
	jmp   .nb030_checksingle
.nb030_dopair:	
    	mov   rcx, [rsp + nb030_innerjjnr]
	
	mov   eax, [rcx]	
	mov   ebx, [rcx + 4]              
	add qword ptr [rsp + nb030_innerjjnr],  8	
	xorps xmm7, xmm7

	mov rsi, [rbp + nb030_type]
	mov   ecx, eax
	mov   edx, ebx
	mov ecx, [rsi + rcx*4]
	mov edx, [rsi + rdx*4]	
	mov rsi, [rbp + nb030_vdwparam]
	shl ecx, 1	
	shl edx, 1	
	mov edi, [rsp + nb030_ntia]
	add ecx, edi
	add edx, edi
	movlps xmm6, [rsi + rcx*4]
	movhps xmm6, [rsi + rdx*4]
	mov rdi, [rbp + nb030_pos]	
	
	movaps xmm4, xmm6
	shufps xmm4, xmm4, 8 ;# 00001000 	
	shufps xmm6, xmm6, 13 ;# 00001101
	movlhps xmm4, xmm7
	movlhps xmm6, xmm7
	
	movaps [rsp + nb030_c6], xmm4
	movaps [rsp + nb030_c12], xmm6	
	
	lea   rax, [rax + rax*2]
	lea   rbx, [rbx + rbx*2]
	;# move coordinates to xmm0-xmm2 
	movlps xmm1, [rdi + rax*4]
	movss xmm2, [rdi + rax*4 + 8]	
	movhps xmm1, [rdi + rbx*4]
	movss xmm0, [rdi + rbx*4 + 8]	

	movlhps xmm3, xmm7
	
	shufps xmm2, xmm0, 0
	
	movaps xmm0, xmm1

	shufps xmm2, xmm2, 136  ;# 10001000
	
	shufps xmm0, xmm0, 136  ;# 10001000
	shufps xmm1, xmm1, 221  ;# 11011101
	
	mov    rdi, [rbp + nb030_faction]
	;# move nb030_ix-iz to xmm4-xmm6 
	xorps   xmm7, xmm7
	
	movaps xmm4, [rsp + nb030_ix]
	movaps xmm5, [rsp + nb030_iy]
	movaps xmm6, [rsp + nb030_iz]

	;# calc dr 
	subps xmm4, xmm0
	subps xmm5, xmm1
	subps xmm6, xmm2

	;# store dr 
	movaps [rsp + nb030_dx], xmm4
	movaps [rsp + nb030_dy], xmm5
	movaps [rsp + nb030_dz], xmm6
	;# square it 
	mulps xmm4,xmm4
	mulps xmm5,xmm5
	mulps xmm6,xmm6
	addps xmm4, xmm5
	addps xmm4, xmm6
	;# rsq in xmm4 

	rsqrtps xmm5, xmm4
	;# lookup seed in xmm5 
	movaps xmm2, xmm5
	mulps xmm5, xmm5
	movaps xmm1, [rsp + nb030_three]
	mulps xmm5, xmm4	;# rsq*lu*lu 			
	movaps xmm0, [rsp + nb030_half]
	subps xmm1, xmm5	;# 30-rsq*lu*lu 
	mulps xmm1, xmm2	
	mulps xmm0, xmm1	;# xmm0=rinv 
	mulps xmm4, xmm0	;# xmm4=r 
	mulps xmm4, [rsp + nb030_tsc]

	cvttps2pi mm6, xmm4     ;# mm6 contain lu indices 
	cvtpi2ps xmm6, mm6
	subps xmm4, xmm6	
	movaps xmm1, xmm4	;# xmm1=eps 
	movaps xmm2, xmm1	
	mulps  xmm2, xmm2	;# xmm2=eps2 

	pslld mm6, 3

	mov  rsi, [rbp + nb030_VFtab]
	movd ecx, mm6
	psrlq mm6, 32
	movd edx, mm6

	;# dispersion 
	movlps xmm5, [rsi + rcx*4 + 0]
	movhps xmm5, [rsi + rdx*4 + 0];# got half dispersion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm4, 136  ;# 10001000
	shufps xmm5, xmm5, 221  ;# 11011101
	
	movlps xmm7, [rsi + rcx*4 + 8]
	movhps xmm7, [rsi + rdx*4 + 8] ;# other half of dispersion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm6, 136  ;# 10001000
	shufps xmm7, xmm7, 221  ;# 11011101
	;# dispersion table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm7, [rsp + nb030_two]	;# two*Heps2 
	addps  xmm7, xmm6
	addps  xmm7, xmm5 ;# xmm7=FF 
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 

	movaps xmm4, [rsp + nb030_c6]
	mulps  xmm7, xmm4	 ;# fijD 
	mulps  xmm5, xmm4	 ;# Vvdw6 

	;# put scalar force on stack Update Vvdwtot directly 
	addps  xmm5, [rsp + nb030_Vvdwtot]
	movaps [rsp + nb030_fscal], xmm7
	movaps [rsp + nb030_Vvdwtot], xmm5

	;# repulsion 
	movlps xmm5, [rsi + rcx*4 + 16]
	movhps xmm5, [rsi + rdx*4 + 16] ;# got half repulsion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm5, xmm7, 221  ;# 11011101

	movlps xmm7, [rsi + rcx*4 + 24]
	movhps xmm7, [rsi + rdx*4 + 24] ;# other half of repulsion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm3, 136  ;# 10001000
	shufps xmm7, xmm3, 221  ;# 11011101
	;# table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm7, [rsp + nb030_two]	;# two*Heps2 
	addps  xmm7, xmm6
	addps  xmm7, xmm5 ;# xmm7=FF 
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 
 	
	movaps xmm4, [rsp + nb030_c12]
	mulps  xmm7, xmm4 ;# fijR 
	mulps  xmm5, xmm4 ;# Vvdw12 
	addps  xmm7, [rsp + nb030_fscal] 
	
	addps  xmm5, [rsp + nb030_Vvdwtot]
	movaps [rsp + nb030_Vvdwtot], xmm5
	xorps  xmm4, xmm4

	mulps xmm7, [rsp + nb030_tsc]
	mulps xmm7, xmm0
	subps  xmm4, xmm7

	movaps xmm0, [rsp + nb030_dx]
	movaps xmm1, [rsp + nb030_dy]
	movaps xmm2, [rsp + nb030_dz]

	mulps  xmm0, xmm4
	mulps  xmm1, xmm4
	mulps  xmm2, xmm4
	;# xmm0-xmm2 contains tx-tz (partial force) 
	;# now update f_i 
	movaps xmm3, [rsp + nb030_fix]
	movaps xmm4, [rsp + nb030_fiy]
	movaps xmm5, [rsp + nb030_fiz]
	addps  xmm3, xmm0
	addps  xmm4, xmm1
	addps  xmm5, xmm2
	movaps [rsp + nb030_fix], xmm3
	movaps [rsp + nb030_fiy], xmm4
	movaps [rsp + nb030_fiz], xmm5
	;# update the fj's 
	movss   xmm3, [rdi + rax*4]
	movss   xmm4, [rdi + rax*4 + 4]
	movss   xmm5, [rdi + rax*4 + 8]
	subss   xmm3, xmm0
	subss   xmm4, xmm1
	subss   xmm5, xmm2	
	movss   [rdi + rax*4], xmm3
	movss   [rdi + rax*4 + 4], xmm4
	movss   [rdi + rax*4 + 8], xmm5	

	shufps  xmm0, xmm0, 225  ;# 11100001
	shufps  xmm1, xmm1, 225  ;# 11100001
	shufps  xmm2, xmm2, 225  ;# 11100001

	movss   xmm3, [rdi + rbx*4]
	movss   xmm4, [rdi + rbx*4 + 4]
	movss   xmm5, [rdi + rbx*4 + 8]
	subss   xmm3, xmm0
	subss   xmm4, xmm1
	subss   xmm5, xmm2	
	movss   [rdi + rbx*4], xmm3
	movss   [rdi + rbx*4 + 4], xmm4
	movss   [rdi + rbx*4 + 8], xmm5	

.nb030_checksingle:				
	mov   edx, [rsp + nb030_innerk]
	and   edx, 1
	jnz    .nb030_dosingle
	jmp    .nb030_updateouterdata
.nb030_dosingle:
	mov rdi, [rbp + nb030_pos]
	mov   rcx, [rsp + nb030_innerjjnr]
	mov   eax, [rcx]	
	xorps  xmm6, xmm6

	mov rsi, [rbp + nb030_type]
	mov ecx, eax
	mov ecx, [rsi + rcx*4]	
	mov rsi, [rbp + nb030_vdwparam]
	shl ecx, 1
	add ecx, [rsp + nb030_ntia]
	movlps xmm6, [rsi + rcx*4]
	movaps xmm4, xmm6
	shufps xmm4, xmm4, 252  ;# 11111100	
	shufps xmm6, xmm6, 253  ;# 11111101	
	
	movaps [rsp + nb030_c6], xmm4
	movaps [rsp + nb030_c12], xmm6	
	
	lea   rax, [rax + rax*2]
	
	;# move coordinates to xmm0-xmm2 
	movss xmm0, [rdi + rax*4]	
	movss xmm1, [rdi + rax*4 + 4]	
	movss xmm2, [rdi + rax*4 + 8]	 
	
	movaps xmm4, [rsp + nb030_ix]
	movaps xmm5, [rsp + nb030_iy]
	movaps xmm6, [rsp + nb030_iz]

	;# calc dr 
	subps xmm4, xmm0
	subps xmm5, xmm1
	subps xmm6, xmm2

	;# store dr 
	movaps [rsp + nb030_dx], xmm4
	movaps [rsp + nb030_dy], xmm5
	movaps [rsp + nb030_dz], xmm6
	;# square it 
	mulps xmm4,xmm4
	mulps xmm5,xmm5
	mulps xmm6,xmm6
	addps xmm4, xmm5
	addps xmm4, xmm6
	;# rsq in xmm4 

	rsqrtps xmm5, xmm4
	;# lookup seed in xmm5 
	movaps xmm2, xmm5
	mulps xmm5, xmm5
	movaps xmm1, [rsp + nb030_three]
	mulps xmm5, xmm4	;# rsq*lu*lu 			
	movaps xmm0, [rsp + nb030_half]
	subps xmm1, xmm5	;# 30-rsq*lu*lu 
	mulps xmm1, xmm2	
	mulps xmm0, xmm1	;# xmm0=rinv 

	mulps xmm4, xmm0	;# xmm4=r 
	mulps xmm4, [rsp + nb030_tsc]

	cvttps2pi mm6, xmm4     ;# mm6 contain lu indices 
	cvtpi2ps xmm6, mm6
	subps xmm4, xmm6	
	movaps xmm1, xmm4	;# xmm1=eps 
	movaps xmm2, xmm1	
	mulps  xmm2, xmm2	;# xmm2=eps2 

	pslld mm6, 3

	mov  rsi, [rbp + nb030_VFtab]
	movd ebx, mm6
	
	;# dispersion 
	movlps xmm4, [rsi + rbx*4 + 0]
	movlps xmm6, [rsi + rbx*4 + 8]
	movaps xmm5, xmm4
	movaps xmm7, xmm6
	shufps xmm5, xmm5, 1
	shufps xmm7, xmm7, 1
	;# table ready in xmm4-xmm7 
	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm7, [rsp + nb030_two]	;# two*Heps2 
	addps  xmm7, xmm6
	addps  xmm7, xmm5 ;# xmm7=FF 
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 

	movaps xmm4, [rsp + nb030_c6]
	mulps  xmm7, xmm4	 ;# fijD 
	mulps  xmm5, xmm4	 ;# Vvdw6 

	;# put scalar force on stack Update Vvdwtot directly 
	addss  xmm5, [rsp + nb030_Vvdwtot]
	movaps [rsp + nb030_fscal], xmm7
	movss [rsp + nb030_Vvdwtot], xmm5

	;# repulsion 
	movlps xmm4, [rsi + rbx*4 + 16]
	movlps xmm6, [rsi + rbx*4 + 24]
	movaps xmm5, xmm4
	movaps xmm7, xmm6
	shufps xmm5, xmm5, 1
	shufps xmm7, xmm7, 1
	;# table ready in xmm4-xmm7 
	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm7, [rsp + nb030_two]	;# two*Heps2 
	addps  xmm7, xmm6
	addps  xmm7, xmm5 ;# xmm7=FF 
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 
 	
	movaps xmm4, [rsp + nb030_c12]
	mulps  xmm7, xmm4 ;# fijR 
	mulps  xmm5, xmm4 ;# Vvdw12 
	addps  xmm7, [rsp + nb030_fscal] 
	
	addss  xmm5, [rsp + nb030_Vvdwtot]
	movss [rsp + nb030_Vvdwtot], xmm5
	xorps  xmm4, xmm4

	mulps xmm7, [rsp + nb030_tsc]
	mulps xmm7, xmm0
	subps  xmm4, xmm7
	mov    rdi, [rbp + nb030_faction]

	movaps xmm0, [rsp + nb030_dx]
	movaps xmm1, [rsp + nb030_dy]
	movaps xmm2, [rsp + nb030_dz]

	mulps  xmm0, xmm4
	mulps  xmm1, xmm4
	mulps  xmm2, xmm4
	;# xmm0-xmm2 contains tx-tz (partial force) 
	;# now update f_i 
	movaps xmm3, [rsp + nb030_fix]
	movaps xmm4, [rsp + nb030_fiy]
	movaps xmm5, [rsp + nb030_fiz]
	addss  xmm3, xmm0
	addss  xmm4, xmm1
	addss  xmm5, xmm2
	movaps [rsp + nb030_fix], xmm3
	movaps [rsp + nb030_fiy], xmm4
	movaps [rsp + nb030_fiz], xmm5
	;# update fj 
	
	movss   xmm3, [rdi + rax*4]
	movss   xmm4, [rdi + rax*4 + 4]
	movss   xmm5, [rdi + rax*4 + 8]
	subss   xmm3, xmm0
	subss   xmm4, xmm1
	subss   xmm5, xmm2	
	movss   [rdi + rax*4], xmm3
	movss   [rdi + rax*4 + 4], xmm4
	movss   [rdi + rax*4 + 8], xmm5	
.nb030_updateouterdata:
	mov   ecx, [rsp + nb030_ii3]
	mov   rdi, [rbp + nb030_faction]
	mov   rsi, [rbp + nb030_fshift]
	mov   edx, [rsp + nb030_is3]

	;# accumulate i forces in xmm0, xmm1, xmm2 
	movaps xmm0, [rsp + nb030_fix]
	movaps xmm1, [rsp + nb030_fiy]
	movaps xmm2, [rsp + nb030_fiz]

	movhlps xmm3, xmm0
	movhlps xmm4, xmm1
	movhlps xmm5, xmm2
	addps  xmm0, xmm3
	addps  xmm1, xmm4
	addps  xmm2, xmm5 ;# sum is in 1/2 in xmm0-xmm2 

	movaps xmm3, xmm0	
	movaps xmm4, xmm1	
	movaps xmm5, xmm2	

	shufps xmm3, xmm3, 1
	shufps xmm4, xmm4, 1
	shufps xmm5, xmm5, 1
	addss  xmm0, xmm3
	addss  xmm1, xmm4
	addss  xmm2, xmm5	;# xmm0-xmm2 has single force in pos0 

	;# increment i force 
	movss  xmm3, [rdi + rcx*4]
	movss  xmm4, [rdi + rcx*4 + 4]
	movss  xmm5, [rdi + rcx*4 + 8]
	addss  xmm3, xmm0
	addss  xmm4, xmm1
	addss  xmm5, xmm2
	movss  [rdi + rcx*4],     xmm3
	movss  [rdi + rcx*4 + 4], xmm4
	movss  [rdi + rcx*4 + 8], xmm5

	;# increment fshift force  
	movss  xmm3, [rsi + rdx*4]
	movss  xmm4, [rsi + rdx*4 + 4]
	movss  xmm5, [rsi + rdx*4 + 8]
	addss  xmm3, xmm0
	addss  xmm4, xmm1
	addss  xmm5, xmm2
	movss  [rsi + rdx*4],     xmm3
	movss  [rsi + rdx*4 + 4], xmm4
	movss  [rsi + rdx*4 + 8], xmm5

	;# get n from stack
	mov esi, [rsp + nb030_n]
        ;# get group index for i particle 
        mov   rdx, [rbp + nb030_gid]      	;# base of gid[]
        mov   edx, [rdx + rsi*4]		;# ggid=gid[n]

	;# accumulate total lj energy and update it 
	movaps xmm7, [rsp + nb030_Vvdwtot]
	;# accumulate 
	movhlps xmm6, xmm7
	addps  xmm7, xmm6	;# pos 0-1 in xmm7 have the sum now 
	movaps xmm6, xmm7
	shufps xmm6, xmm6, 1
	addss  xmm7, xmm6		

	;# add earlier value from mem 
	mov   rax, [rbp + nb030_Vvdw]
	addss xmm7, [rax + rdx*4] 
	;# move back to mem 
	movss [rax + rdx*4], xmm7 
	
        ;# finish if last 
        mov ecx, [rsp + nb030_nn1]
	;# esi already loaded with n
	inc esi
        sub ecx, esi
        jecxz .nb030_outerend

        ;# not last, iterate outer loop once more!  
        mov [rsp + nb030_n], esi
        jmp .nb030_outer
.nb030_outerend:
        ;# check if more outer neighborlists remain
        mov   ecx, [rsp + nb030_nri]
	;# esi already loaded with n above
        sub   ecx, esi
        jecxz .nb030_end
        ;# non-zero, do one more workunit
        jmp   .nb030_threadloop
.nb030_end:
	
	mov eax, [rsp + nb030_nouter]
	mov ebx, [rsp + nb030_ninner]
	mov rcx, [rbp + nb030_outeriter]
	mov rdx, [rbp + nb030_inneriter]
	mov [rcx], eax
	mov [rdx], ebx

        add rsp, 376
	femms
		
	pop rbx
	pop	rbp
	ret



	

.globl nb_kernel030nf_x86_64_sse
.globl _nb_kernel030nf_x86_64_sse
nb_kernel030nf_x86_64_sse:	
_nb_kernel030nf_x86_64_sse:	
;#	Room for return address and rbp (16 bytes)
.equiv          nb030nf_fshift,         16
.equiv          nb030nf_gid,            24
.equiv          nb030nf_pos,            32
.equiv          nb030nf_faction,        40
.equiv          nb030nf_charge,         48
.equiv          nb030nf_p_facel,        56
.equiv          nb030nf_argkrf,         64
.equiv          nb030nf_argcrf,         72
.equiv          nb030nf_Vc,             80
.equiv          nb030nf_type,           88
.equiv          nb030nf_p_ntype,        96
.equiv          nb030nf_vdwparam,       104
.equiv          nb030nf_Vvdw,           112
.equiv          nb030nf_p_tabscale,     120
.equiv          nb030nf_VFtab,          128
.equiv          nb030nf_invsqrta,       136
.equiv          nb030nf_dvda,           144
.equiv          nb030nf_p_gbtabscale,   152
.equiv          nb030nf_GBtab,          160
.equiv          nb030nf_p_nthreads,     168
.equiv          nb030nf_count,          176
.equiv          nb030nf_mtx,            184
.equiv          nb030nf_outeriter,      192
.equiv          nb030nf_inneriter,      200
.equiv          nb030nf_work,           208
	;# stack offsets for local variables  
	;# bottom of stack is cache-aligned for sse use 
.equiv          nb030nf_ix,             0
.equiv          nb030nf_iy,             16
.equiv          nb030nf_iz,             32
.equiv          nb030nf_tsc,            48
.equiv          nb030nf_c6,             64
.equiv          nb030nf_c12,            80
.equiv          nb030nf_Vvdwtot,        96
.equiv          nb030nf_half,           112
.equiv          nb030nf_three,          128
.equiv          nb030nf_is3,            144
.equiv          nb030nf_ii3,            148
.equiv          nb030nf_innerjjnr,      152
.equiv          nb030nf_nri,            160
.equiv          nb030nf_iinr,           168
.equiv          nb030nf_jindex,         176
.equiv          nb030nf_jjnr,           184
.equiv          nb030nf_shift,          192
.equiv          nb030nf_shiftvec,       200
.equiv          nb030nf_ntia,           208
.equiv          nb030nf_innerk,         212
.equiv          nb030nf_n,              216
.equiv          nb030nf_nn1,            220
.equiv          nb030nf_ntype,          224
.equiv          nb030nf_nouter,         228
.equiv          nb030nf_ninner,         232

	push rbp
	mov  rbp, rsp
	push rbx

        sub rsp, 248		; # local variable stack space (n*16+8)
	femms

	;# zero 32-bit iteration counters
	mov eax, 0
	mov [rsp + nb030nf_nouter], eax
	mov [rsp + nb030nf_ninner], eax

	mov edi, [rdi]
	mov [rsp + nb030nf_nri], edi
	mov [rsp + nb030nf_iinr], rsi
	mov [rsp + nb030nf_jindex], rdx
	mov [rsp + nb030nf_jjnr], rcx
	mov [rsp + nb030nf_shift], r8
	mov [rsp + nb030nf_shiftvec], r9
	mov rdi, [rbp + nb030nf_p_ntype]
	mov edi, [rdi]
	mov [rsp + nb030nf_ntype], edi

	mov rax, [rbp + nb030nf_p_tabscale]
	movss xmm3, [rax]
	shufps xmm3, xmm3, 0
	movaps [rsp + nb030nf_tsc], xmm3

	;# create constant floating-point factors on stack
	mov eax, 0x3f000000     ;# half in IEEE (hex)
	mov [rsp + nb030nf_half], eax
	movss xmm1, [rsp + nb030nf_half]
	shufps xmm1, xmm1, 0    ;# splat to all elements
	movaps xmm2, xmm1       
	addps  xmm2, xmm2	;# one
	movaps xmm3, xmm2
	addps  xmm2, xmm2	;# two
	addps  xmm3, xmm2	;# three
	movaps [rsp + nb030nf_half],  xmm1
	movaps [rsp + nb030nf_three],  xmm3

.nb030nf_threadloop:
        mov   rsi, [rbp + nb030nf_count]          ;# pointer to sync counter
        mov   eax, [rsi]
.nb030nf_spinlock:
        mov   ebx, eax                          ;# ebx=*count=nn0
        add   ebx, 1                           ;# ebx=nn1=nn0+10
        lock cmpxchg [rsi], ebx                 ;# write nn1 to *counter,
                                                ;# if it hasnt changed.
                                                ;# or reread *counter to eax.
        pause                                   ;# -> better p4 performance
        jnz .nb030nf_spinlock

        ;# if(nn1>nri) nn1=nri
        mov ecx, [rsp + nb030nf_nri]
        mov edx, ecx
        sub ecx, ebx
        cmovle ebx, edx                         ;# if(nn1>nri) nn1=nri
        ;# Cleared the spinlock if we got here.
        ;# eax contains nn0, ebx contains nn1.
        mov [rsp + nb030nf_n], eax
        mov [rsp + nb030nf_nn1], ebx
        sub ebx, eax                            ;# calc number of outer lists
	mov esi, eax				;# copy n to esi
        jg  .nb030nf_outerstart
        jmp .nb030nf_end

.nb030nf_outerstart:
	;# ebx contains number of outer iterations
	add ebx, [rsp + nb030nf_nouter]
	mov [rsp + nb030nf_nouter], ebx

.nb030nf_outer:
	mov   rax, [rsp + nb030nf_shift]      	;# rax = pointer into shift[] 
	mov   ebx, [rax+rsi*4]			;# ebx=shift[n] 
	
	lea   rbx, [rbx + rbx*2]    ;# rbx=3*is 
	mov   [rsp + nb030nf_is3],ebx    	;# store is3 

	mov   rax, [rsp + nb030nf_shiftvec]   	;# rax = base of shiftvec[] 

	movss xmm0, [rax + rbx*4]
	movss xmm1, [rax + rbx*4 + 4]
	movss xmm2, [rax + rbx*4 + 8] 

	mov   rcx, [rsp + nb030nf_iinr]       	;# rcx = pointer into iinr[] 	
	mov   ebx, [rcx+rsi*4]	    		;# ebx =ii 

    	mov   rdx, [rbp + nb030nf_type] 
    	mov   edx, [rdx + rbx*4]
    	imul  edx, [rsp + nb030nf_ntype]
    	shl   edx, 1
    	mov   [rsp + nb030nf_ntia], edx
	
	lea   rbx, [rbx + rbx*2]		;# rbx = 3*ii=ii3 
	mov   rax, [rbp + nb030nf_pos]    	;# rax = base of pos[]  

	addss xmm0, [rax + rbx*4]
	addss xmm1, [rax + rbx*4 + 4]
	addss xmm2, [rax + rbx*4 + 8]
	
	shufps xmm0, xmm0, 0
	shufps xmm1, xmm1, 0
	shufps xmm2, xmm2, 0

	movaps [rsp + nb030nf_ix], xmm0
	movaps [rsp + nb030nf_iy], xmm1
	movaps [rsp + nb030nf_iz], xmm2

	mov   [rsp + nb030nf_ii3], ebx
	
	;# clear tot potential and i forces 
	xorps xmm4, xmm4
	movaps [rsp + nb030nf_Vvdwtot], xmm4
	
	mov   rax, [rsp + nb030nf_jindex]
	mov   ecx, [rax + rsi*4]	     	;# jindex[n] 
	mov   edx, [rax + rsi*4 + 4]	     	;# jindex[n+1] 
	sub   edx, ecx               		;# number of innerloop atoms 

	mov   rsi, [rbp + nb030nf_pos]
	mov   rax, [rsp + nb030nf_jjnr]
	shl   ecx, 2
	add   rax, rcx
	mov   [rsp + nb030nf_innerjjnr], rax    ;# pointer to jjnr[nj0] 
	mov   ecx, edx
	sub   edx,  4
	add   ecx, [rsp + nb030nf_ninner]
	mov   [rsp + nb030nf_ninner], ecx
	add   edx, 0
	mov   [rsp + nb030nf_innerk], edx    	;# number of innerloop atoms 
	jge   .nb030nf_unroll_loop
	jmp   .nb030nf_finish_inner
.nb030nf_unroll_loop:	
	;# quad-unroll innerloop here 
	mov   rdx, [rsp + nb030nf_innerjjnr]     ;# pointer to jjnr[k] 
	mov   eax, [rdx]	
	mov   ebx, [rdx + 4]              
	mov   ecx, [rdx + 8]            
	mov   edx, [rdx + 12]         ;# eax-edx=jnr1-4 
	add qword ptr [rsp + nb030nf_innerjjnr],  16 ;# advance pointer (unrolled 4) 

	movd  mm0, eax		;# use mmx registers as temp storage 
	movd  mm1, ebx
	movd  mm2, ecx
	movd  mm3, edx
	
	mov rsi, [rbp + nb030nf_type]
	mov eax, [rsi + rax*4]
	mov ebx, [rsi + rbx*4]
	mov ecx, [rsi + rcx*4]
	mov edx, [rsi + rdx*4]
	mov rsi, [rbp + nb030nf_vdwparam]
	shl eax, 1	
	shl ebx, 1	
	shl ecx, 1	
	shl edx, 1	
	mov edi, [rsp + nb030nf_ntia]
	add eax, edi
	add ebx, edi
	add ecx, edi
	add edx, edi

	movlps xmm6, [rsi + rax*4]
	movlps xmm7, [rsi + rcx*4]
	movhps xmm6, [rsi + rbx*4]
	movhps xmm7, [rsi + rdx*4]

	movaps xmm4, xmm6
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm6, xmm7, 221  ;# 11011101
	
	movd  eax, mm0		
	movd  ebx, mm1
	movd  ecx, mm2
	movd  edx, mm3

	movaps [rsp + nb030nf_c6], xmm4
	movaps [rsp + nb030nf_c12], xmm6
	
	mov rsi, [rbp + nb030nf_pos]       ;# base of pos[] 

	lea   rax, [rax + rax*2]     ;# replace jnr with j3 
	lea   rbx, [rbx + rbx*2]	

	lea   rcx, [rcx + rcx*2]     ;# replace jnr with j3 
	lea   rdx, [rdx + rdx*2]	

	;# move four coordinates to xmm0-xmm2 	

	movlps xmm4, [rsi + rax*4]
	movlps xmm5, [rsi + rcx*4]
	movss xmm2, [rsi + rax*4 + 8]
	movss xmm6, [rsi + rcx*4 + 8]

	movhps xmm4, [rsi + rbx*4]
	movhps xmm5, [rsi + rdx*4]

	movss xmm0, [rsi + rbx*4 + 8]
	movss xmm1, [rsi + rdx*4 + 8]

	shufps xmm2, xmm0, 0
	shufps xmm6, xmm1, 0
	
	movaps xmm0, xmm4
	movaps xmm1, xmm4

	shufps xmm2, xmm6, 136  ;# 10001000
	
	shufps xmm0, xmm5, 136  ;# 10001000
	shufps xmm1, xmm5, 221  ;# 11011101		

	;# move nb030nf_ix-iz to xmm4-xmm6 
	movaps xmm4, [rsp + nb030nf_ix]
	movaps xmm5, [rsp + nb030nf_iy]
	movaps xmm6, [rsp + nb030nf_iz]

	;# calc dr 
	subps xmm4, xmm0
	subps xmm5, xmm1
	subps xmm6, xmm2

	;# square it 
	mulps xmm4,xmm4
	mulps xmm5,xmm5
	mulps xmm6,xmm6
	addps xmm4, xmm5
	addps xmm4, xmm6
	;# rsq in xmm4 

	rsqrtps xmm5, xmm4
	;# lookup seed in xmm5 
	movaps xmm2, xmm5
	mulps xmm5, xmm5
	movaps xmm1, [rsp + nb030nf_three]
	mulps xmm5, xmm4	;# rsq*lu*lu 			
	movaps xmm0, [rsp + nb030nf_half]
	subps xmm1, xmm5	;# 30-rsq*lu*lu 
	mulps xmm1, xmm2	
	mulps xmm0, xmm1	;# xmm0=rinv 
	mulps xmm4, xmm0	;# xmm4=r 
	mulps xmm4, [rsp + nb030nf_tsc]

	movhlps xmm5, xmm4
	cvttps2pi mm6, xmm4
	cvttps2pi mm7, xmm5	;# mm6/mm7 contain lu indices 
	cvtpi2ps xmm6, mm6
	cvtpi2ps xmm5, mm7
	movlhps xmm6, xmm5
	subps xmm4, xmm6	
	movaps xmm1, xmm4	;# xmm1=eps 
	movaps xmm2, xmm1	
	mulps  xmm2, xmm2	;# xmm2=eps2 
	pslld mm6, 3
	pslld mm7, 3

	movd mm0, eax	
	movd mm1, ebx
	movd mm2, ecx
	movd mm3, edx

	mov  rsi, [rbp + nb030nf_VFtab]
	movd eax, mm6
	psrlq mm6, 32
	movd ecx, mm7
	psrlq mm7, 32
	movd ebx, mm6
	movd edx, mm7

	;# dispersion 
	movlps xmm5, [rsi + rax*4 + 0]
	movlps xmm7, [rsi + rcx*4 + 0]
	movhps xmm5, [rsi + rbx*4 + 0]
	movhps xmm7, [rsi + rdx*4 + 0] ;# got half dispersion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm5, xmm7, 221  ;# 11011101
	
	movlps xmm7, [rsi + rax*4 + 8]
	movlps xmm3, [rsi + rcx*4 + 8]
	movhps xmm7, [rsi + rbx*4 + 8]
	movhps xmm3, [rsi + rdx*4 + 8] ;# other half of dispersion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm3, 136  ;# 10001000
	shufps xmm7, xmm3, 221  ;# 11011101
	;# dispersion table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 

	movaps xmm4, [rsp + nb030nf_c6]
	mulps  xmm5, xmm4	 ;# Vvdw6 

	;# Update Vvdwtot 
	addps  xmm5, [rsp + nb030nf_Vvdwtot]
	movaps [rsp + nb030nf_Vvdwtot], xmm5

	;# repulsion 
	movlps xmm5, [rsi + rax*4 + 16]
	movlps xmm7, [rsi + rcx*4 + 16]
	movhps xmm5, [rsi + rbx*4 + 16]
	movhps xmm7, [rsi + rdx*4 + 16] ;# got half repulsion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm5, xmm7, 221  ;# 11011101

	movlps xmm7, [rsi + rax*4 + 24]
	movlps xmm3, [rsi + rcx*4 + 24]
	movhps xmm7, [rsi + rbx*4 + 24]
	movhps xmm3, [rsi + rdx*4 + 24] ;# other half of repulsion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm3, 136  ;# 10001000
	shufps xmm7, xmm3, 221  ;# 11011101
	;# table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 
	
	movaps xmm4, [rsp + nb030nf_c12]
	mulps  xmm5, xmm4  
	addps  xmm5, [rsp + nb030nf_Vvdwtot]
	movaps [rsp + nb030nf_Vvdwtot], xmm5
	xorps  xmm4, xmm4
	
	;# should we do one more iteration? 
	sub dword ptr [rsp + nb030nf_innerk],  4
	jl    .nb030nf_finish_inner
	jmp   .nb030nf_unroll_loop
.nb030nf_finish_inner:
	;# check if at least two particles remain 
	add dword ptr [rsp + nb030nf_innerk],  4
	mov   edx, [rsp + nb030nf_innerk]
	and   edx, 2
	jnz   .nb030nf_dopair
	jmp   .nb030nf_checksingle
.nb030nf_dopair:	
    	mov   rcx, [rsp + nb030nf_innerjjnr]
	
	mov   eax, [rcx]	
	mov   ebx, [rcx + 4]              
	add qword ptr [rsp + nb030nf_innerjjnr],  8	
	xorps xmm7, xmm7

	mov rsi, [rbp + nb030nf_type]
	mov   ecx, eax
	mov   edx, ebx
	mov ecx, [rsi + rcx*4]
	mov edx, [rsi + rdx*4]	
	mov rsi, [rbp + nb030nf_vdwparam]
	shl ecx, 1	
	shl edx, 1	
	mov edi, [rsp + nb030nf_ntia]
	add ecx, edi
	add edx, edi
	movlps xmm6, [rsi + rcx*4]
	movhps xmm6, [rsi + rdx*4]
	mov rdi, [rbp + nb030nf_pos]	
	
	movaps xmm4, xmm6
	shufps xmm4, xmm4, 8 ;# 00001000 	
	shufps xmm6, xmm6, 13 ;# 00001101
	movlhps xmm4, xmm7
	movlhps xmm6, xmm7
	
	movaps [rsp + nb030nf_c6], xmm4
	movaps [rsp + nb030nf_c12], xmm6	
	
	lea   rax, [rax + rax*2]
	lea   rbx, [rbx + rbx*2]
	;# move coordinates to xmm0-xmm2 
	movlps xmm1, [rdi + rax*4]
	movss xmm2, [rdi + rax*4 + 8]	
	movhps xmm1, [rdi + rbx*4]
	movss xmm0, [rdi + rbx*4 + 8]	

	movlhps xmm3, xmm7
	
	shufps xmm2, xmm0, 0
	
	movaps xmm0, xmm1

	shufps xmm2, xmm2, 136  ;# 10001000
	
	shufps xmm0, xmm0, 136  ;# 10001000
	shufps xmm1, xmm1, 221  ;# 11011101
	
	;# move nb030nf_ix-iz to xmm4-xmm6 
	xorps   xmm7, xmm7
	
	movaps xmm4, [rsp + nb030nf_ix]
	movaps xmm5, [rsp + nb030nf_iy]
	movaps xmm6, [rsp + nb030nf_iz]

	;# calc dr 
	subps xmm4, xmm0
	subps xmm5, xmm1
	subps xmm6, xmm2

	;# square it 
	mulps xmm4,xmm4
	mulps xmm5,xmm5
	mulps xmm6,xmm6
	addps xmm4, xmm5
	addps xmm4, xmm6
	;# rsq in xmm4 

	rsqrtps xmm5, xmm4
	;# lookup seed in xmm5 
	movaps xmm2, xmm5
	mulps xmm5, xmm5
	movaps xmm1, [rsp + nb030nf_three]
	mulps xmm5, xmm4	;# rsq*lu*lu 			
	movaps xmm0, [rsp + nb030nf_half]
	subps xmm1, xmm5	;# 30-rsq*lu*lu 
	mulps xmm1, xmm2	
	mulps xmm0, xmm1	;# xmm0=rinv 
	mulps xmm4, xmm0	;# xmm4=r 
	mulps xmm4, [rsp + nb030nf_tsc]

	cvttps2pi mm6, xmm4     ;# mm6 contain lu indices 
	cvtpi2ps xmm6, mm6
	subps xmm4, xmm6	
	movaps xmm1, xmm4	;# xmm1=eps 
	movaps xmm2, xmm1	
	mulps  xmm2, xmm2	;# xmm2=eps2 

	pslld mm6, 3

	mov  rsi, [rbp + nb030nf_VFtab]
	movd ecx, mm6
	psrlq mm6, 32
	movd edx, mm6

	;# dispersion 
	movlps xmm5, [rsi + rcx*4 + 0]
	movhps xmm5, [rsi + rdx*4 + 0];# got half dispersion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm4, 136  ;# 10001000
	shufps xmm5, xmm5, 221  ;# 11011101
	
	movlps xmm7, [rsi + rcx*4 + 8]
	movhps xmm7, [rsi + rdx*4 + 8] ;# other half of dispersion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm6, 136  ;# 10001000
	shufps xmm7, xmm7, 221  ;# 11011101
	;# dispersion table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 

	movaps xmm4, [rsp + nb030nf_c6]
	mulps  xmm5, xmm4	 ;# Vvdw6 

	;#  Update Vvdwtot  
	addps  xmm5, [rsp + nb030nf_Vvdwtot]
	movaps [rsp + nb030nf_Vvdwtot], xmm5

	;# repulsion 
	movlps xmm5, [rsi + rcx*4 + 16]
	movhps xmm5, [rsi + rdx*4 + 16] ;# got half repulsion table 
	movaps xmm4, xmm5
	shufps xmm4, xmm7, 136  ;# 10001000
	shufps xmm5, xmm7, 221  ;# 11011101

	movlps xmm7, [rsi + rcx*4 + 24]
	movhps xmm7, [rsi + rdx*4 + 24] ;# other half of repulsion table 
	movaps xmm6, xmm7
	shufps xmm6, xmm3, 136  ;# 10001000
	shufps xmm7, xmm3, 221  ;# 11011101
	;# table ready, in xmm4-xmm7 	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 
 	
	movaps xmm4, [rsp + nb030nf_c12]
	mulps  xmm5, xmm4 ;# Vvdw12 
	
	addps  xmm5, [rsp + nb030nf_Vvdwtot]
	movaps [rsp + nb030nf_Vvdwtot], xmm5

.nb030nf_checksingle:				
	mov   edx, [rsp + nb030nf_innerk]
	and   edx, 1
	jnz    .nb030nf_dosingle
	jmp    .nb030nf_updateouterdata
.nb030nf_dosingle:
	mov rdi, [rbp + nb030nf_pos]
	mov   rcx, [rsp + nb030nf_innerjjnr]
	mov   eax, [rcx]	
	xorps  xmm6, xmm6

	mov rsi, [rbp + nb030nf_type]
	mov ecx, eax
	mov ecx, [rsi + rcx*4]	
	mov rsi, [rbp + nb030nf_vdwparam]
	shl ecx, 1
	add ecx, [rsp + nb030nf_ntia]
	movlps xmm6, [rsi + rcx*4]
	movaps xmm4, xmm6
	shufps xmm4, xmm4, 252  ;# 11111100	
	shufps xmm6, xmm6, 253  ;# 11111101	
	
	movaps [rsp + nb030nf_c6], xmm4
	movaps [rsp + nb030nf_c12], xmm6	
	
	lea   rax, [rax + rax*2]
	
	;# move coordinates to xmm0-xmm2 
	movss xmm0, [rdi + rax*4]	
	movss xmm1, [rdi + rax*4 + 4]	
	movss xmm2, [rdi + rax*4 + 8]	 
	
	movaps xmm4, [rsp + nb030nf_ix]
	movaps xmm5, [rsp + nb030nf_iy]
	movaps xmm6, [rsp + nb030nf_iz]

	;# calc dr 
	subps xmm4, xmm0
	subps xmm5, xmm1
	subps xmm6, xmm2

	;# square it 
	mulps xmm4,xmm4
	mulps xmm5,xmm5
	mulps xmm6,xmm6
	addps xmm4, xmm5
	addps xmm4, xmm6
	;# rsq in xmm4 

	rsqrtps xmm5, xmm4
	;# lookup seed in xmm5 
	movaps xmm2, xmm5
	mulps xmm5, xmm5
	movaps xmm1, [rsp + nb030nf_three]
	mulps xmm5, xmm4	;# rsq*lu*lu 			
	movaps xmm0, [rsp + nb030nf_half]
	subps xmm1, xmm5	;# 30-rsq*lu*lu 
	mulps xmm1, xmm2	
	mulps xmm0, xmm1	;# xmm0=rinv 

	mulps xmm4, xmm0	;# xmm4=r 
	mulps xmm4, [rsp + nb030nf_tsc]

	cvttps2pi mm6, xmm4     ;# mm6 contain lu indices 
	cvtpi2ps xmm6, mm6
	subps xmm4, xmm6	
	movaps xmm1, xmm4	;# xmm1=eps 
	movaps xmm2, xmm1	
	mulps  xmm2, xmm2	;# xmm2=eps2 

	pslld mm6, 3

	mov  rsi, [rbp + nb030nf_VFtab]
	movd ebx, mm6
	
	;# dispersion 
	movlps xmm4, [rsi + rbx*4 + 0]
	movlps xmm6, [rsi + rbx*4 + 8]
	movaps xmm5, xmm4
	movaps xmm7, xmm6
	shufps xmm5, xmm5, 1
	shufps xmm7, xmm7, 1
	;# table ready in xmm4-xmm7 
	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 

	movaps xmm4, [rsp + nb030nf_c6]
	mulps  xmm5, xmm4	 ;# Vvdw6 

	;# put scalar force on stack Update Vvdwtot directly 
	addss  xmm5, [rsp + nb030nf_Vvdwtot]
	movss [rsp + nb030nf_Vvdwtot], xmm5

	;# repulsion 
	movlps xmm4, [rsi + rbx*4 + 16]
	movlps xmm6, [rsi + rbx*4 + 24]
	movaps xmm5, xmm4
	movaps xmm7, xmm6
	shufps xmm5, xmm5, 1
	shufps xmm7, xmm7, 1
	;# table ready in xmm4-xmm7 
	
	mulps  xmm6, xmm1	;# xmm6=Geps 
	mulps  xmm7, xmm2	;# xmm7=Heps2 
	addps  xmm5, xmm6
	addps  xmm5, xmm7	;# xmm5=Fp 	
	mulps  xmm5, xmm1 ;# xmm5=eps*Fp 
	addps  xmm5, xmm4 ;# xmm5=VV 
 	
	movaps xmm4, [rsp + nb030nf_c12]
	mulps  xmm5, xmm4 ;# Vvdw12 
	
	addss  xmm5, [rsp + nb030nf_Vvdwtot]
	movss [rsp + nb030nf_Vvdwtot], xmm5

.nb030nf_updateouterdata:
	;# get n from stack
	mov esi, [rsp + nb030nf_n]
        ;# get group index for i particle 
        mov   rdx, [rbp + nb030nf_gid]      	;# base of gid[]
        mov   edx, [rdx + rsi*4]		;# ggid=gid[n]

	;# accumulate total lj energy and update it 
	movaps xmm7, [rsp + nb030nf_Vvdwtot]
	;# accumulate 
	movhlps xmm6, xmm7
	addps  xmm7, xmm6	;# pos 0-1 in xmm7 have the sum now 
	movaps xmm6, xmm7
	shufps xmm6, xmm6, 1
	addss  xmm7, xmm6		

	;# add earlier value from mem 
	mov   rax, [rbp + nb030nf_Vvdw]
	addss xmm7, [rax + rdx*4] 
	;# move back to mem 
	movss [rax + rdx*4], xmm7 
	
        ;# finish if last 
        mov ecx, [rsp + nb030nf_nn1]
	;# esi already loaded with n
	inc esi
        sub ecx, esi
        jecxz .nb030nf_outerend

        ;# not last, iterate outer loop once more!  
        mov [rsp + nb030nf_n], esi
        jmp .nb030nf_outer
.nb030nf_outerend:
        ;# check if more outer neighborlists remain
        mov   ecx, [rsp + nb030nf_nri]
	;# esi already loaded with n above
        sub   ecx, esi
        jecxz .nb030nf_end        ;# non-zero, do one more workunit
        jmp   .nb030nf_threadloop
.nb030nf_end:

	mov eax, [rsp + nb030nf_nouter]
	mov ebx, [rsp + nb030nf_ninner]
	mov rcx, [rbp + nb030nf_outeriter]
	mov rdx, [rbp + nb030nf_inneriter]
	mov [rcx], eax
	mov [rdx], ebx

	add rsp, 248
	femms
	 
	pop rbx
	pop	rbp
	ret
