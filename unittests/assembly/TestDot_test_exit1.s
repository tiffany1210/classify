.import ../../src/utils.s
.import ../../src/dot.s

.data
m0: .word 
m1: .word 1

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load 0 into a2
    li a2 0

    # load 1 into a3
    li a3 1

    # load 2 into a4
    li a4 2

    # call dot function
    jal ra dot
    # we expect dot to exit early with code 75

    # exit normally
    jal exit
