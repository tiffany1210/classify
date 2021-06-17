.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    #check if the rows and columns of m0 are greater than or equal to 1.
    addi t0 x0 1
    blt a1 t0 terminate1
    blt a2 t0 terminate1
    #check if dimensions of m1 is correct.
    blt a4 t0 terminate2
    blt a5 t0 terminate2
    #check if dimensions of m0 and m1 matches and if not, terminates.
    bne a2 a4 terminate3

    # Prologue
    addi sp sp -52
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    sw ra 48(sp)
    
    mv s0 a0  # m0
    mv s1 a1  # rows of m0
    mv s2 a2  # columns of m0
    mv s3 a3  # m1
    mv s4 a4  # rows of m1
    mv s5 a5  # columns of m1
    mv s6 a6  # d
    
    #save the dimensions of the new matrix into s7
	mul s7 s1 s2
    
    #initialize to 0 
    li s8 0 #i = 0, counter
    li s9 0
    #constant 1
    addi s11 x0 1
outer_loop_start:
	#if the counter i is equal to the r0
    #branch to outer_loop_end
	beq s8 s1 outer_loop_end
    add s10 x0 x0 #set j = 0

inner_loop_start:
	#ends when the counter j is equal to the c1
	beq s5 s10 inner_loop_end
    addi t1 x0 4 #t1 = 4
    mul t1 t1 s8 #t1 = 4i
    mul t1 t1 s2 #t1 = 4i*c0
    add t1 s0 t1 #t1 = m0 + 4i*c0
    
    addi t2 x0 4 #t2 = 4
    mul t2 t2 s10 #t2 = 4j
    add t2 s3 t2 #t2 = m1 + 4j
    
    add a0 t1 x0 #a0 = t1
    add a1 t2 x0 #a1 = t2
    add a2 s2 x0 #a2 = s2
    add a3 s11 x0 #a3 = s11 = 1
    add a4 s5 x0 #a4 = s5
    jal ra dot #call function dot
    
    add t0 a0 x0 #t0 = a0 which has been returned by the dot function
    addi t3 x0 4 #t3 = 4
    mul t3 t3 s9 #t3 = 4k
    add t3 s6 t3 #t3 = d + 4k
    sw t0 0(t3) #store t0 (a0) into the indexed element of t3 (d)
    
    addi s9 s9 1 #increment k by 1
    addi s10 s10 1 #increment j by 1
    j inner_loop_start

inner_loop_end:
	addi s8 s8 1 #increment i by 1
    j outer_loop_start

outer_loop_end:
	# Epilogue
	lw ra 48(sp)
    lw s11 44(sp)
    lw s10 40(sp)
    lw s9 36(sp)
    lw s8 32(sp)
    lw s7 28(sp)
    lw s6 24(sp)
    lw s5 20(sp)
    lw s4 16(sp)
    lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp sp 52
    ret
terminate1:
	li a1 72
    jal exit2
    
terminate2:
	li a1 73
    jal exit2
    
#exit with code 74
terminate3:
	li a1 74
    jal exit2