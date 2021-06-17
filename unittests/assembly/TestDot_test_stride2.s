.import ../../src/utils.s
.import ../../src/dot.s

.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
msg0: .asciiz "expected a0 to be 50 not: "

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load 4 into a2
    li a2 4

    # load 2 into a3
    li a3 2

    # load 1 into a4
    li a4 1

    # call dot function
    jal ra dot

    # save all return values in the save registers
    mv s0 a0


    # check that a0 == 50
    li t0 50
    beq s0 t0 a0_eq_50
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
    a0_eq_50:


    # exit normally
    jal exit
