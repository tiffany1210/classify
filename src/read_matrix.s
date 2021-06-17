.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -28
    sw s0, 0(sp)       # the pointer to string representing the filename        
    sw s1, 4(sp)       # a pointer to the number of rows
    sw s2, 8(sp)       # a pointer to the number of columns
    sw s3, 12(sp)      # the file descriptor
    sw s4, 16(sp)      # the pointer to the matrix in memory
    sw s5, 20(sp)      # save the number of entries
    sw ra, 24(sp)

    add s0 a0 x0 #s0 = filename
    add s1 a1 x0 #s1 = pointer to number of rows
    add s2 a2 x0 #s2 = pointer to number of columns

	#open the file
	add a1 s0 x0
	add a2 x0 x0
	jal fopen

	#checks for fopen error or eof
	li t0, -1
	beq a0 t0 terminate90

	#arguments for fread
	add s3 a0 x0 
    add a1 s3 x0
	add a2 s1 x0
	addi a3 x0 4 #a3 = 4, number of bytes to read
	jal fread #read row numbers

	#checks for fread error or eof
	addi t0 x0 4
	bne a0 t0 terminate91

	add a1 s3 x0
	add a2 s2 x0
	addi a3 x0 4
	jal fread #read column numbers

	addi t0 x0 4
	bne a0 t0 terminate91

	#t0 = number of rows
	lw t0 0(s1)

	#t1 = number of columns
	lw t1 0(s2)

	#number of elements in matrix
	mul a0 t0 t1
	addi t0 x0 4
	mul a0 a0 t0
    #store number of bytes of entries in s5
    mv s5 a0
	jal malloc

	#if malloc fails
	beq a0 x0 terminate88

	#s4 = returned pointer
	add s4 a0 x0 
	add a1 s3 x0
	add a2 s4 x0
	lw t0 0(s1)
	lw t1 0(s2)
	mul a3 t0 t1
	addi t0 x0 4

	mul a3 a3 t0
	jal fread

	#if fread fails
	bne a0 s5 terminate91
	
	#arguments to fclose
	add a1 s3 x0
	jal fclose

	#if fclose fails
	li t0, -1
	beq t0 a0 terminate92
    
    add a0 s4 x0
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    ret

terminate88:
	li a1 88
	jal exit2

terminate90:
	li a1 90
	jal exit2

terminate91:
	li a1 91
	jal exit2

terminate92:
	li a1 92
	jal exit2

