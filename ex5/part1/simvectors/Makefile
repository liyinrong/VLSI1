# Simple makefile which runs the test vector generator for the traffic
# light FSM of exercise 4 of VLSI I.

all: initial red2green flashall

initial:
	javac -g src/TrafficLightTestVectorGenerator.java
	java -cp src TrafficLightTestVectorGenerator

red2green:
	javac -g src/TrafficLightTestVectorGenerator.java
	java -cp src TrafficLightTestVectorGenerator 1
	
flashall:
	javac -g src/TrafficLightTestVectorGenerator.java
	java -cp src TrafficLightTestVectorGenerator 2

clean:
	@rm ./src/*.class
