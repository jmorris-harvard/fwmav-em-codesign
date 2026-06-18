all: sim

.PHONY: run
run:
	g++ Main.cpp Unified.cpp CommTest.cpp -I./ -I../../../driver/ -o Main

sim:
	g++ MainSim.cpp Unified.cpp CommTest.cpp -I./ -I../../../driver/ -o MainSim

test:
	g++ MainTest.cpp Unified.cpp CommTest.cpp -I./ -I../../../driver/ -o MainTest

clean:
	rm -f MainTest MainSim Main
