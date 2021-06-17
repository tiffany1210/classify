# classify
RISC-V assembly code necessary to run a simple Artificial Neural Network (ANN) on the Venus RISC-V simulator

├── inputs (test inputs)
├── outputs (some test outputs)
├── README.md
├── src
│   ├── argmax.s (partA)
│   ├── classify.s (partB)
│   ├── dot.s (partA)
│   ├── main.s (do not modify)
│   ├── matmul.s (partA)
│   ├── read_matrix.s (partB)
│   ├── relu.s (partA)
│   ├── utils.s (do not modify)
│   └── write_matrix.s (partB)
├── tools
│   ├── convert.py (convert matrix files for partB)
│   └── venus.jar (RISC-V simulator)
└── unittests
    ├── assembly (contains outputs from unittests.py)
    ├── framework.py (do not modify)
    └── unittests.py (partA + partB)
    
    
In part A: 
implemented the basic operations such as a vector dot product, matrix-matrix multiplication, the argmax and an activation function. 
In part B:
combined these basic functions in order to load a pretrained network and execute it to classify handwritten digets from the MNIST benchmark set.
