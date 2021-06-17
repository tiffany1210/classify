.import ../../src/utils.s
.import ../../src/abs.s

.data
msg0: .asciiz "expected a0 to be 0 not: "

.globl main_test
.text
# main_test function for testing
main_test:

    # load 0 into a0
    li a0 0

    # call abs function
    jal ra abs

    # save all return values in the save registers
    mv s0 a0


    # check that a0 == 0
    li t0 0
    beq s0 t0 a0_eq_0
    # print error and exit
    la a1, msg0
    jal print_str
    mv a1 s0
    jal print_int
    # Print newline
    li a1 '\n'
    jal ra print_char
    # exit with code 8 to indicate failure
    li a1 8
    jal exit2
    a0_eq_0:


    # exit normally
    jal exit
