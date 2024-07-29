// :)
// @@@ = something that needs to be addressed

.stack 0x5000

.text 0x7000
.label printf

.data 0x100
.label sia		// static int sia[] = {50, 43, 100, -5, -10, 50, 0};
50
43
100
-5
-10
50
0
.label sib		// static int sib[] = {500, 43, 100, -5, -10, 50, 0};
500
43
100
-5
-10
50
0

.data 0x1000
.label fmt0
.string //s1: %d, s2: %d

.data 0x1100
.label fmt1
.string //cmp_arrays(sia, sib): %d

.data 0x1200
.label fmt2
.string //ia[%d]: %d

.data 0x1300
.label fmt3
.string //sia[%d]: %d

.data 0x1400
.label fmt4
.string //smallest(ia): %d

.data 0x1500
.label fmt5
.string //smallest(sia): %d

.data 0x1600
.label fmt6
.string //Something bad

.data 0x1700
.label fmt7
.string //Nice sort and smallest

.data 0x1800
.label fmt8
.string //factorial(4) is: %d

.data 0x1900
.label fmt9
.string //factorial(7) is: %d

.data 0x2000
.label fmt10
.string //cmp_arrays(sia, sia): %d

.data 0x2100
.label fmt11
.string //cmp_arrays(ia, sib): %d



.text 0x200
// FINISHED //

.label sum_array	// r0 points to int *ia

mov r1, 0		// s = 0
.label loop_a
ldr r2, [r0]
cmp r2, 0		// if *ia = 0
beq end_loop_a
ldr r2, [r0]
add r1, r1, r2		// else, s += *ia
add r0, r0, 4		// *ia++
bal loop_a
.label end_loop_a
mov r0, r1
mov r15, r14		// return to function call



.text 0x300
// FINISHED //

.label cmp_arrays

sub sp, sp, 12		// allocates 12 bytes to stack
str r14, [sp, 0]	// stores link reg on stack
str r1, [sp, 4]		// stores ia2 on stack
blr sum_array		// function call
str r0, [sp, 8]		// stores returned value on stack
ldr r0, [sp, 4]		// loads ia2 into r0
blr sum_array		// function call		
mov r2, r0
mva r0, fmt0
ldr r1, [sp, 8]
cmp r1, r2
bgt gt
blt lt
mov r3, 0
bal cmp_arrays_end
.label gt
mov r3, 1
bal cmp_arrays_end
.label lt
mov r3, -1
.label cmp_arrays_end
str r3, [sp, 8]
blr printf
ldr r0, [sp, 8]
ldr r14, [sp, 0]	// restore link register
add sp, sp, 12		// deallocates stack (sp -> 0x5000)
mov r15, r14		// return to function call



.text 0x400
// FINISHED //

.label numelems

mov r1, 0		// c = 0
.label loop_b
ldr r2, [r0]
cmp r2, 0		// if *ia = 0
beq end_loop_b
add r1, r1, 1		// else, c += 1
add r0, r0, 4		// *ia++
bal loop_b
.label end_loop_b
mov r0, r1
mov r15, r14		// return to function call



.text 0x500
// FINISHED //

.label sort

sub sp, sp, 32		// allocate 8 bytes on stack
str r14, [sp, 0]	// store link reg on stack
str r0, [sp, 4]		// store ia on stack
str r4, [sp, 8]		// store r4 on stack
str r5, [sp, 12]	// store r5 on stack
str r6, [sp, 16]	// store r6 on stack
str r7, [sp, 20]	// store r7 on stack
str r8, [sp, 24]	// store r8 on stack
str r9, [sp, 28]	// store r8 on stack

blr numelems
mov r2, r0		// r2 = length of ia (s)
ldr r0, [sp, 4]		// r0 = ia
mov r1, 0		// r1 = 0 (i)
.label sort_outer_loop
cmp r1, r2
beq end_outer_loop
mov r3, 0		// r3 = 0 (j)
.label sort_inner_loop
mov r4, r2
sub r4, r4, 1
sub r4, r4, r1		// r4 = s-1-i
cmp r3, r4
beq end_inner_loop
mul r7, r3, 4
add r5, r0, r7		// r5 = &ia[j]
ldr r8, [r5]		// r8 = ia[j]
add r6, r0, r7
add r6, r6, 4		// r6 = &ia[j+1]
ldr r9, [r6]		// r9 = ia[j+1]
cmp r8, r9		// if ia[j] > ia[j+1]
ble sort_skip
str r8, [r6]		// swap ia[j] and ia[j+1]
str r9, [r5]
.label sort_skip
add r3, r3, 1		// r3++
bal sort_inner_loop
.label end_inner_loop
add r1, r1, 1		// r1++
bal sort_outer_loop
.label end_outer_loop

ldr r4, [sp, 8]	// restore r4-9
ldr r5, [sp, 12]
ldr r6, [sp, 16]
ldr r7, [sp, 20]
ldr r8, [sp, 24]
ldr r9, [sp, 28]
ldr r14, [sp, 0]	// restore link reg
add sp, sp, 32		// deallocate stack
mov r15, r14		// return to function call



.text 0x600
// FINISHED //

.label smallest

sub sp, sp, 8		// allocate 8 bytes on stack
str r14, [sp, 0]	// store link reg on stack
str r0, [sp, 4]		// store ia on stack
blr numelems
ldr r1, [sp, 4]		// r1 = ia
mul r0, r0, 4		// s = s*4 (4 bytes per element in array)
add r2, r1, r0		// r2 = ia+s
ldr r0, [r1]		// r0 = smallest (*ia)
.label smallest_loop
cmp r1, r2
beq end_smallest_loop
ldr r3, [r1]		// r3 = *ia
cmp r3, r0
bge smallest_skip
mov r0, r3		// r0 = *ia
.label smallest_skip
add r1, r1, 4		// ia++
bal smallest_loop
.label end_smallest_loop
ldr r14, [sp, 0]	// restore link reg
add sp, sp, 8		// deallocate stack
mov r15, r14		// return to function call



.text 0x700
// FINISHED //

.label factorial

sub sp, sp, 8
str r14, [sp, 0]
str r0, [sp, 4]
mov r1, 1
cmp r0, r1
beq factorial_return
sub r0, r0, 1
blr factorial
.label factorial_return
ldr r0, [sp, 4]
mul r1, r1, r0
ldr r14, [sp, 0]
add sp, sp, 8
mov r0, r1
mov r15, r14		// return to function call



.text 0x800
// FINISHED //

.label main

//testing
mva r0, fmt0
mva r1, sia
mva r2, sib

sub sp, sp, 20		// allocate 20 bytes for stack
mov r0, 2		// int ia[] = {2,3,5,1,0}
str r0, [sp, 0]
mov r0, 3
str r0, [sp, 4]
mov r0, 5
str r0, [sp, 8]
mov r0, 1
str r0, [sp, 12]
mov r0, 0
str r0, [sp, 16]
mov r4, 0		// int cav = 0
mov r5, 0		// n = 0
mov r6, 0		// sm1 = 0
mov r7, 0		// sm2 = 0

mva r0, sia
mva r1, sib
blr cmp_arrays
mov r4, r0		// cav = cmp_arrays(sia, sib);
mva r0, fmt1
mov r1, r4
blr printf

mva r0, sia
mva r1, sia
blr cmp_arrays
mov r4, r0		// cav = cmp_arrays(sia, sia);
mva r0, fmt10
mov r1, r4
blr printf

mov r0, 4
str r0, sib		// sib[0] = 4
mva r0, sia
mva r1, sib
blr cmp_arrays
mov r4, r0		// cav = cmp_arrays(sia, sib);
mva r0, fmt1
mov r1, r4
blr printf

mva r0, sp
mva r1, sib
blr cmp_arrays
mov r4, r0		// cav = cmp_arrays(ia, sib);
mva r0, fmt11
mov r1, r4
blr printf

.label main_half

mov r0, sp
blr sort		// sort(ia);

mov r0, sp
blr numelems
mov r5, r0		// n = numelems(ia);

mov r8, 0		// i = 0;
.label main_for_1
cmp r8, r5
beq end_main_for_1	// i < n;
mov r1, r8
mul r8, r8, 4
add r2, sp, r8
div r8, r8, 4
ldr r2, [r2]
mva r0, fmt2
blr printf
add r8, r8, 1
bal main_for_1
.label end_main_for_1

mov r0, sia
blr sort		// sort(sia);

mov r0, sia
blr numelems
mov r5, r0		// n = numelems(sia);

mov r8, 0		// i = 0;
.label main_for_2
cmp r8, r5
beq end_main_for_2	// i < n;
mov r1, r8
mul r8, r8, 4
add r2, r8, 0x100
div r8, r8, 4
ldr r2, [r2]
mva r0, fmt3
blr printf
add r8, r8, 1
bal main_for_2
.label end_main_for_2

mva r0, sp
//ldr r0, [sp, 0]
blr smallest
mov r6, r0		// sm1 = smallest(ia)
mov r1, r0
mov r0, fmt4
blr printf

mva r0, sia
blr smallest
mov r7, r0		// sm2 = smallest(sia)
mov r1, r0
mov r0, fmt5
blr printf

ldr r10, [sp, 0]
cmp r6, r10		// if (sm1 == ia[0])
beq main_beq1
mva r0, fmt6
blr printf
bal main_skip1
.label main_beq1
mva r0, fmt7
blr printf
.label main_skip1

ldr r10, sia
cmp r7, r10		// if (sm2 == sia[0])
beq main_beq2
mva r0, fmt6
blr printf
bal main_skip2
.label main_beq2
mva r0, fmt7
blr printf
.label main_skip2

mov r0, 4
blr factorial
mov r5, r0		// n = factorial(4)
mov r1, r0
mva r0, fmt8
blr printf

mov r0, 7
blr factorial
mov r5, r0		// n = factorial(7)
mov r1, r0
mva r0, fmt9
blr printf

.label end
bal end
