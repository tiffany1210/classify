.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


	#check if there are an incorrect number of command line args
    addi t0 x0 5
    bne a0 t0 terminate89
    
    add s0 a1 x0
    add s10 a2 x0

	# =====================================
    # LOAD MATRICES
    # =====================================

	# Load pretrained m0
    addi a0 x0 4
    jal malloc
    
    #if malloc fails
    beq a0 x0 terminate88
    
    #malloc for the number of rows in m0
    add s2 a0 x0
    addi a0 x0 4
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    
    #malloc for the number of cols in m0
    add s3 a0 x0
   	lw a0 4(s0)
    add a1 x0 s2
    add a2 x0 s3
    
    #read_matrix(m0)
    jal read_matrix
    #s1 = returned matrix m0
    add s1 a0 x0



    # Load pretrained m1
	addi a0 x0 4
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    
    add s5 a0 x0 
    addi a0 x0 4
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    add s6 a0 x0
    
    lw a0 8(s0)
    add a1 x0 s5
    add a2 x0 s6
    jal read_matrix
    #s4 = returned matrix m1
    add s4 a0 x0



    # Load input matrix
	addi a0, x0, 4
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    
    add s8, a0, x0               
    addi a0, x0, 4
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    add s9, a0, x0                
    lw a0, 12(s0)
    add a1, x0, s8
    add a2, x0, s9
    # read_matrix(input_matrix)
    jal read_matrix
    # s7 = returned input_matrix
    add s7, a0, x0                

    lw s2, 0(s2)
    lw s3, 0(s3)
    lw s5, 0(s5)
    lw s6, 0(s6)
    lw s8, 0(s8)
    lw s9, 0(s9)





    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

	add a0, s2, x0
    mul a0, a0, s9
    addi t0, x0, 4
    mul a0, a0, t0
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    
    add s10, a0, x0
    add a0, s1, x0
    add a1, s2, x0
    add a2, s3, x0
    add a3, s7, x0
    add a4, s8, x0
    add a5, s9, x0
    add a6, s10, x0
    
    # matmul(m0, input_matrix)
    jal matmul                   
    add s1, s10, x0
    add s3, s9, x0

    add a0, s1, x0
    add a1, s2, x0
    mul a1, a1, s3
    # relu(m0*input)
    jal relu                     

    add a0, s5, x0
    mul a0, a0, s3
    addi t0, x0, 4
    mul a0, a0, t0
    jal malloc
    #if malloc fails
    beq a0 x0 terminate88
    
    add s10, a0, x0
    add a0, s4, x0
    add a1, s5, x0
    add a2, s6, x0
    add a3, s1, x0
    add a4, s2, x0
    add a5, s3, x0
    add a6, s10, x0
    # matmul(m1, relu)
    jal matmul                   
    add s1, s10, x0
    add s2, s5, x0
    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
    lw a0 16(s0)                  
    add a1, s1, x0
    add a2, s2, x0
    add a3, s3, x0
    jal write_matrix




    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    add a0, s1, x0
    add a1, s2, x0
    mul a1, a1, s3
    jal argmax

	beq s10 x0 print
    jal exit
    ret
print:
    # Print classification
    add a1, a0, x0
    jal print_int
	# Print newline afterwards for clarity
    addi a1 x0 '\n'
    jal print_char

    jal exit
    ret
    
terminate88:
	li a1 88
    jal exit2
terminate89:
	li a1 89
    jal exit2
