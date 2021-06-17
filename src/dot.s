.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
	#Check if the length of vector is less than 1
    addi t1 x0 1
    blt a2 t1 terminate1
    
    #check if the stride is less than 1
    blt a3 t1 terminate2
    blt a4 t1 terminate2
    
    # Prologue
    addi sp sp -16
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    
    #initialize counter t0
    li t0 0
    #set s0 and s1 to be zero
    add s0 x0 x0
    add s1 x0 x0
    #counter for stride
    add s2 x0 a3
    add s3 x0 a4
loop_start:
	#if the counter is equal to the length of array, we end the loop
	beq t0 a2 loop_end
    
    #load the element of v0
    lw t1 0(a0)
    #load the element of v1
    lw t2 0(a1)
    #multiply the two elements
    mul s0 t1 t2
    add s1 s1 s0
    
    #multiply stride for each vector by the byte offset 
    addi t3 x0 4
    mul t1 s2 t3
    mul t2 s3 t3
    ebreak
    #add this byte offset to the array
    add a0 a0 t1
    add a1 a1 t2
    #increment counter
    addi t0 t0 1
    j loop_start
loop_end:
	add a0 s1 x0
    # Epilogue
  	lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp sp 16
    ret
#terminate with error code 75
terminate1:
	li a1 75
    jal exit2
#terminate with error code 76
terminate2:
	li a1 76
    jal exit2
