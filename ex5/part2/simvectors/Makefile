# Simple makefile which runs the test vector generator for the
# control/datapath example and the Sbox example.

all: initial change1 change2

initial:
	javac -g src/ControlDataPathTestVectorGenerator.java
	java -cp src ControlDataPathTestVectorGenerator

change1:
	javac -g src/ControlDataPathTestVectorGenerator.java
	java -cp src ControlDataPathTestVectorGenerator 1
	
change2:
	javac -g src/ControlDataPathTestVectorGenerator.java
	java -cp src ControlDataPathTestVectorGenerator 2
	
clean:
	@rm ./src/*.class
