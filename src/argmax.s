.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    #If the length of the vector is less than 1, terminate.
    addi t1, x0, 1
    bge t1, a1, terminate
    
    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    
    #initialize the counter s0
    add s0, x0, x0
    #initialize the next element to compare
    add s2, x0, x0
    
    #initialize the index
    li s3, 0
    
    #load the first element of the array to compare
    lw s1 0(a0)
loop_start:
	#if the counter is equal to the length of the array, we end the loop
    beq s0, a1, loop_end
    #load the element of the array
    lw s2 0(a0)
    #if s1 is greater than s2 we go to loop_continue
    #s1 is kept as the max element
    bge s1 s2 loop_continue
    #else we update s1 as s2
    add s1 x0 s2
    #we update s3 to be s0 which will give the index
    add s3 s0 x0
    j loop_start
loop_continue:
	#add the array pointer by the size of a byte
    addi a0 a0 4
    #increment the counter
    addi s0 s0 1
    j loop_start
loop_end:
	add a0, s3, x0
    # Epilogue
    lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp sp 16
    ret
#terminate with the error code 77. 
terminate:
	li a1, 77
    jal exit2