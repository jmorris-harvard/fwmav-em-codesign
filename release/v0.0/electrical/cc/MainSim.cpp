#include <iostream>

#include <string.h>

#include <Unified.h>

#define REPEATS 80000

int main (int Argc, char **Argv) {
	int Error;
	InitModel ();
	// ReadModel ();
	// return 0;

	DECIMAL State[12] = { 0 };
	DECIMAL StateNext[12] = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
	};


	DECIMAL T = 0;
	DECIMAL dT = 0;
	TimeFunc (&T);
	TimeFunc (&dT); // Second call gives 1/Sampling
	// std::cout << dT << std::endl;
	std::cout << "X,Y,Z,VX,VY,VZ,Alpha,Beta,Gamma,AlphaDot,BetaDot,GammaDot" << std::endl;
	
	INTEGER Rep = 0;
	DECIMAL Ramp = 0;
	while (Rep < REPEATS) {
		State[0] = StateNext[0];
		State[1] = StateNext[1];
		State[2] = StateNext[2];
		State[3] = StateNext[3];
		State[4] = StateNext[4];
		State[5] = StateNext[5];
		State[6] = StateNext[6];
		State[7] = StateNext[7];
		State[8] = StateNext[8];
		State[9] = StateNext[9];
		State[10] = StateNext[10];
		State[11] = StateNext[11];

		std::cout << State[0] << ",";
		std::cout << State[1] << ",";
		std::cout << State[2] << ",";
		std::cout << State[3] << ",";
		std::cout << State[4] << ",";
		std::cout << State[5] << ",";
		std::cout << State[6] << ",";
		std::cout << State[7] << ",";
		std::cout << State[8] << ",";
		std::cout << State[9] << ",";
		std::cout << State[10] << ",";
		std::cout << State[11] << std::endl;

		TimeFunc (&T);

		DECIMAL PCur[3] = {
			State[0], 
			State[1], 
			State[2]
		};

		DECIMAL W[3] = { 0 };
		DECIMAL QAvg[3] = { 0 };
		DECIMAL QRaw[3] = { 0 };
		DECIMAL P[3] = { 0 };
		DECIMAL V[3] = { 0 };
		DECIMAL RAvg[9] = { 0 };
		DECIMAL Omega[3] = { 0 };
		INTEGER Update = 0;
		INTEGER Count = 0;
		PP (PCur, State[6], State[7], State[8], W, QAvg, QRaw, P, V, RAvg, Omega, &Update, &Count);

		DECIMAL PDesired[3] = { 0 };
		DECIMAL VDesired[3] = { 0 };
		DECIMAL ADesired[3] = { 0 };
		DECIMAL B1D[3] = { 0 };
		TRAJ (T, PDesired, VDesired, ADesired, B1D);

		DECIMAL RDesired[9] = { 0 };
		DECIMAL OmegaDesired[3] = { 0 };
		DECIMAL OmegaDotDesired[3] = { 0 };
		DECIMAL EP[3] = { 0 };
		DECIMAL EV[3] = { 0 };
		DECIMAL ER[3] = { 0 };
		DECIMAL EOmega[3] = { 0 };
		DECIMAL ThrustDesired = 0;
		DECIMAL RollTorqueDesired = 0;
		DECIMAL PitchTorqueDesired = 0;
		DECIMAL YawTorqueDesired = 0;
		DECIMAL AdaptiveAttitudeOutput[3] = { 0 };
		DECIMAL AdaptiveLateralOutput[3] = { 0 };
		CONTROL (Update, Count, P, V, RAvg, Omega, PDesired, VDesired, ADesired, B1D, Ramp, RDesired, OmegaDesired, OmegaDotDesired, EP, EV, ER, EOmega, &ThrustDesired, &RollTorqueDesired, &PitchTorqueDesired, &YawTorqueDesired, AdaptiveAttitudeOutput, AdaptiveLateralOutput);

		DECIMAL U[4] = {
			ThrustDesired,
			RollTorqueDesired,
			PitchTorqueDesired,
			YawTorqueDesired
		};

		/*
		std::cout << ThrustDesired * 1e20 << ",";
		std::cout << RollTorqueDesired * 1e20 << ",";
		std::cout << YawTorqueDesired * 1e20 << ",";
		std::cout << PitchTorqueDesired * 1e20 << std::endl;
		*/

		BeeModel (State, U, dT, StateNext);
		++Rep;
		DECIMAL DrvParam[5] = { 0 };
		FTV (ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired, DrvParam);

		DECIMAL OpenLoopControl[5] = { 0, 0, 0, 0, 0 };
		INTEGER Enable = 0;
		DECIMAL SGTime = 0;
		DECIMAL Freq = 0;
		DECIMAL DrvAmp = 0;
		DECIMAL DrvPitchLeft = 0;
		DECIMAL DrvPitchRight = 0;
		DECIMAL DrvRoll = 0;
		DECIMAL DrvA2 = 0;
		OCLS (OpenLoopControl, DrvParam, &Enable, &Ramp, &SGTime, &Freq, &DrvAmp, &DrvPitchLeft, &DrvPitchRight, &DrvRoll, &DrvA2);
	}
}
