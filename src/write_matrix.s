.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)                # the pointer to the start of the matrix
    sw s1, 4(sp)                # the number of rows in the matrix
    sw s2, 8(sp)                # the number of columns in the matrix
    sw s3, 12(sp)               # the returned file descriptor
    sw s4, 16(sp)               # the number of elements
    sw s5, 20(sp)               # counter for elements
    sw ra, 24(sp)

    add s0, a1, x0
    add s1, a2, x0
    add s2, a3, x0

    add a1, a0, x0
    addi a2, x0, 1      # fopen("filename", "-w")
    jal fopen
    
    #check for fopen error
    addi t0, x0, -1
    beq t0, a0, terminate93    

    add s3, a0, x0              # save the returned file descriptor

    add a1, s3, x0
    addi sp, sp, -4
    sw s1, 0(sp)
    add a2, sp, x0
    addi sp, sp, 4
    addi a3, x0, 1
    addi a4, x0, 4
    jal fwrite                 # fwrite(fp, row, 1, 4)
    addi t0 x0 1
    bne a0, t0, terminate94    # if a0 is NOT equal to a3: exit with exit code 1

    add a1, s3, x0
    addi sp, sp, -4
    sw s2, 0(sp)
    add a2, sp, x0
    addi sp, sp, 4
    addi a3, x0, 1
    addi a4, x0, 4
    jal fwrite                 # fwrite(fp, column, 1, 4)
    addi t0 x0 1
    bne a0, t0, terminate94    # if a0 is NOT equal to a3: exit with exit code 1

    mul s4, s1, s2              # s4 <- row*column
    add s5, x0, x0              # s5 is the counter for elements

write_loop:
    bgeu s5, s4, finish
    add a1, s3, x0
    add a2, s5, x0
    addi t0, x0, 4
    mul a2, t0, a2
    add a2, a2, s0
    addi a3, x0, 1
    addi a4, x0, 4
    jal fwrite                 # fwrite(fp, element, 1, 4)
    addi t0 x0 1
    bne a0, t0, terminate94    # if a0 is NOT equal to a3: exit with exit code 1
    addi s5, s5, 1
    j write_loop

finish:
    add a1, s3, x0
    call fclose                 # fclose(fp)
    bne a0, x0, terminate95

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
    
terminate93:
	li a1 93
    jal exit2
    
terminate94:
	li a1 94
    jal exit2
    
terminate95:
	li a1 95
    jal exit2