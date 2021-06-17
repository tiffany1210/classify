.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    #If the length of the vector is less than 1, terminate.
    addi t1, x0, 1
    blt a1, t1, terminate
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    #Copy the start of array to saved register
    mv s0, a0
    #Copy the length of array to saved register
    mv s1, a1
    
    #initialize counter to 0
    li t0, 0
 loop_start:
    #if the counter is equal to the length of the array, we end the loop
    beq t0, s1, loop_end
    
    #convert array index to byte offset
    slli t1, t0, 2
    #add the offset to start of array
    add a0, s0, t1
    
    #load the first value of a0 onto t1
    lw t1, 0(a0)
    #check if t1 is positive
    bge t1, x0, loop_continue
    add t1, x0, x0
    #store zero as the new element
    sw t1, 0(a0)
    j loop_start
loop_continue:
	#increment the counter
    addi t0, t0, 1
    j loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
	ret
#terminate with the error code 78. 
terminate:
	li a1, 78
    jal exit2


