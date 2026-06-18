#include <math.h>

#ifdef BEE_DEBUG
#include <iostream>
#endif

#include <Comm.h>
#include <Unified.h>

static struct {
	DECIMAL A2LB;
	DECIMAL A2OpenLoop;
	DECIMAL A2UB;
	DECIMAL AdaptiveDelay;
	INTEGER AdaptiveFlag;
	DECIMAL AdaptiveGain[10];
	INTEGER AdaptiveLateralFlag;
	DECIMAL AdaptivePitchInit;
	DECIMAL AdaptivePitchLimit;
	DECIMAL AdaptivePitchLimitLow;
	DECIMAL AdaptiveRollInit;
	DECIMAL AdaptiveRollLimit;
	DECIMAL AdaptiveRollLimitLow;
	DECIMAL AdaptiveXInit;
	DECIMAL AdaptiveXLimit;
	DECIMAL AdaptiveXLimitLow;
	DECIMAL AdaptiveYInit;
	DECIMAL AdaptiveYLimit;
	DECIMAL AdaptiveYLimitLow;
	DECIMAL AdaptiveYawInit;
	DECIMAL AdaptiveYawLimit;
	DECIMAL AdaptiveYawLimitLow;
	DECIMAL AdaptiveZInit;
	DECIMAL AdaptiveZLimit;
	DECIMAL AdaptiveZLimitLow;
	DECIMAL AlphaXX;
	DECIMAL AttK;
	DECIMAL AttLambda;
	DECIMAL AttS;
	DECIMAL AttS2;
	DECIMAL B1DDesired[3];
	DECIMAL C1UppBound;
	DECIMAL C1Adaptive;
	DECIMAL C2Adaptive;
	DECIMAL C2UppBound;
	DECIMAL CROverCL;
	INTEGER ClosedLoopFlag;
	DECIMAL ClosedLoopMaxDrvBias;
	INTEGER ControlFlag;
	DECIMAL ControlGain[7];
	DECIMAL Delay[11];
	DECIMAL DrvAmp;
	DECIMAL DrvAmpLimit;
	DECIMAL DrvBias;
	DECIMAL DrvPch;
	DECIMAL DrvPitchLeft;
	DECIMAL DrvPitchLeftLimit;
	DECIMAL DrvPitchRight;
	DECIMAL DrvPitchRightLimit;
	DECIMAL DrvRoll;
	DECIMAL DrvRollLimit;
	DECIMAL E1[3];
	DECIMAL E2[3];
	DECIMAL E3[3];
	DECIMAL F;
	DECIMAL FFin;
	DECIMAL FInt;
	DECIMAL FRes;
	DECIMAL FTauLimit[4];
	DECIMAL FrequencyRef;
	DECIMAL FSVicon;
	DECIMAL G;
	DECIMAL GammaAdaptive;
	DECIMAL GammaLateralAdaptive;
	DECIMAL IMomentVec[3];
	DECIMAL IXX;
	DECIMAL IYY;
	DECIMAL IZZ;
	DECIMAL KDA;
	DECIMAL KDA2;
	DECIMAL KOmega;
	DECIMAL KR;
	DECIMAL KRX;
	DECIMAL KV;
	DECIMAL KVZ;
	DECIMAL KX;
	DECIMAL KZ;
	DECIMAL LeftMapping[4];
	DECIMAL LowBound;
	DECIMAL LowBoundER;
	DECIMAL LowBoundVX;
	DECIMAL LowBoundVY;
	DECIMAL LowBoundVZ;
	DECIMAL LowBoundX;
	DECIMAL LowBoundY;
	DECIMAL LowBoundZ;
	DECIMAL LPDen[6];
	DECIMAL LPNum[6];
	DECIMAL M;
	DECIMAL MaxDrivBias;
	DECIMAL NumCycle;
	DECIMAL ParamsVec[9];
	DECIMAL PeriodRef;
	DECIMAL Phase;
	DECIMAL PhiP2PNominalLeft;
	DECIMAL PhiP2PNominalOpenLoop;
	DECIMAL PhiP2PNominalRight;
	DECIMAL PhiPitchOffsetOpenLoop;
	DECIMAL PhiRollOffsetOpenLoop;
	DECIMAL RDesired[3];
	DECIMAL RadiusRatio;
	DECIMAL RadiusRef;
	DECIMAL RampDelay;
	DECIMAL RightMapping[4];
	DECIMAL RollOffsetAngle;
	DECIMAL RunningTime;
	DECIMAL RunningTimeControl;
	DECIMAL SampleCycle;
	DECIMAL SamplingF;
	DECIMAL SamplingTime;
	DECIMAL SaveFlag;
	DECIMAL Scale;
	DECIMAL SimpleS;
	DECIMAL StartDelay;
	DECIMAL StartDelayAdpative;
	DECIMAL StartDelayControl;
	DECIMAL T;
	INTEGER TaskFlag;
	DECIMAL TaskParameter[3];
	DECIMAL ThrustLimit;
	DECIMAL TorquePitchLimit;
	DECIMAL TorqueRollLimit;
	DECIMAL TorqueYawLimit;
	DECIMAL U1Limit;
	DECIMAL U2Limit;
	DECIMAL U3Limit;
	DECIMAL U4Limit;
	DECIMAL UppBound;
	DECIMAL UppBoundER;
	DECIMAL UppBoundVX;
	DECIMAL UppBoundVY;
	DECIMAL UppBoundVZ;
	DECIMAL UppBoundX;
	DECIMAL UppBoundY;
	DECIMAL UppBoundZ;
	DECIMAL VDesired[3];
	DECIMAL VLP2PLimit;
	DECIMAL VOffsetLimit;
	DECIMAL VRP2PLimit;
	DECIMAL ViconSampleCycles;
	DECIMAL VLPDen[6];
	DECIMAL VLPNum[6];
	DECIMAL VZDesired;
	DECIMAL XDDDot[3];
	DECIMAL ZDesired;
	INTEGER Mode;
} Config;

// Timing 
STATUS StartTimer (void) { return 0; }

STATUS TimeFunc (DECIMAL* T) {
  const DECIMAL SamplingF = Config.SamplingF;
  static INTEGER N = 0;
  *T = N / SamplingF;
  N = N + 1;
  return 0;
}

// Initialization 
STATUS InitModel (void) { 
  INTEGER i;

  // Reads In ASCII Order (Uppercase)
	Read (&Config.CROverCL);
	for (i = 0; i < 4; ++i) {
		Read (&Config.FTauLimit[i]);
	}
	for (i = 0; i < 3; ++i) {
		Read (&Config.IMomentVec[i]);
	}
	Read (&Config.IXX);
	Read (&Config.IYY);
	Read (&Config.IZZ);
	Read (&Config.PhiP2PNominalLeft);
	Read (&Config.PhiP2PNominalOpenLoop);
	Read (&Config.PhiP2PNominalRight);
	Read (&Config.PhiPitchOffsetOpenLoop);
	Read (&Config.PhiRollOffsetOpenLoop);
	Read (&Config.T);
	Read (&Config.ThrustLimit);
	Read (&Config.TorquePitchLimit);
	Read (&Config.TorqueRollLimit);
	Read (&Config.TorqueYawLimit);
	Read (&Config.VLP2PLimit);
	Read (&Config.VRP2PLimit);
	Read (&Config.VOffsetLimit);
	
  // (Lowercase)
  Read (&Config.A2LB);
	Read (&Config.A2OpenLoop);
	Read (&Config.A2UB);
	Read (&Config.AdaptiveDelay);
	Read (&Config.AdaptiveFlag);
  for (i = 0; i < 10; ++i) {
    Read (&Config.AdaptiveGain[i]);
  }
	Read (&Config.AdaptiveLateralFlag);
	Read (&Config.AdaptivePitchInit);
	Read (&Config.AdaptivePitchLimit);
	Read (&Config.AdaptivePitchLimitLow);
	Read (&Config.AdaptiveRollInit);
	Read (&Config.AdaptiveRollLimit);
	Read (&Config.AdaptiveRollLimitLow);
	Read (&Config.AdaptiveXInit);
	Read (&Config.AdaptiveXLimit);
	Read (&Config.AdaptiveXLimitLow);
	Read (&Config.AdaptiveYInit);
	Read (&Config.AdaptiveYLimit);
	Read (&Config.AdaptiveYLimitLow);
	Read (&Config.AdaptiveYawInit);
	Read (&Config.AdaptiveYawLimit);
	Read (&Config.AdaptiveYawLimitLow);
	Read (&Config.AdaptiveZInit);
	Read (&Config.AdaptiveZLimit);
	Read (&Config.AdaptiveZLimitLow);
	Read (&Config.AlphaXX);
	Read (&Config.AttLambda);
	Read (&Config.AttK);
	Read (&Config.AttS);
	Read (&Config.AttS2);
	for (i = 0; i < 3; ++i) {
		Read (&Config.B1DDesired[i]);
	}
	Read (&Config.C1UppBound);
	Read (&Config.C1Adaptive);
	Read (&Config.C2Adaptive);
	Read (&Config.C2UppBound);
	Read (&Config.ClosedLoopFlag);
	Read (&Config.ClosedLoopMaxDrvBias);
	Read (&Config.ControlFlag);
	for (i = 0; i < 7; ++i) {
		Read (&Config.ControlGain[i]);
	}
	for (i = 0; i < 11; ++i) {
		Read (&Config.Delay[i]);
	}
	Read (&Config.DrvAmp);
	Read (&Config.DrvAmpLimit);
	Read (&Config.DrvBias);
	Read (&Config.DrvPch);
	Read (&Config.DrvPitchLeft);
	Read (&Config.DrvPitchLeftLimit);
	Read (&Config.DrvPitchRight);
	Read (&Config.DrvPitchRightLimit);
	Read (&Config.DrvRoll);
	Read (&Config.DrvRollLimit);
	for (i = 0; i < 3; ++i) {
		Read (&Config.E1[i]);
	}
	for (i = 0; i < 3; ++i) {
		Read (&Config.E2[i]);
	}
	for (i = 0; i < 3; ++i) {
		Read (&Config.E3[i]);
	}
	Read (&Config.F);
	Read (&Config.FFin);
	Read (&Config.FInt);
	Read (&Config.FRes);
	Read (&Config.FrequencyRef);
	Read (&Config.FSVicon);
	Read (&Config.G);
	Read (&Config.GammaAdaptive);
	Read (&Config.GammaLateralAdaptive);
	Read (&Config.KOmega);
	Read (&Config.KR);
	Read (&Config.KRX);
	Read (&Config.KDA);
	Read (&Config.KDA2);
	Read (&Config.KV);
	Read (&Config.KVZ);
	Read (&Config.KX);
	Read (&Config.KZ);
  for (i = 0; i < 4; ++i) {
	  Read (&Config.LeftMapping[i]);
  }
	Read (&Config.LowBound);
	Read (&Config.LowBoundER);
	Read (&Config.LowBoundVX);
	Read (&Config.LowBoundVY);
	Read (&Config.LowBoundVZ);
	Read (&Config.LowBoundX);
	Read (&Config.LowBoundY);
	Read (&Config.LowBoundZ);
	for (i = 0; i < 6; ++i) {
		Read (&Config.LPDen[i]);
	}
	for (i = 0; i < 6; ++i) {
		Read (&Config.LPNum[i]);
	}
	Read (&Config.M);
	Read (&Config.MaxDrivBias);
	Read (&Config.NumCycle);
	for (i = 0; i < 9; ++i) {
		Read (&Config.ParamsVec[i]);
	}
	Read (&Config.PeriodRef);
	Read (&Config.Phase);
	for (i = 0; i < 3; ++i) {
		Read (&Config.RDesired[i]);
	}
	Read (&Config.RadiusRatio);
	Read (&Config.RadiusRef);
	Read (&Config.RampDelay);
	for (i = 0; i < 4; ++i) {
		Read (&Config.RightMapping[i]);
	}
	Read (&Config.RollOffsetAngle);
	Read (&Config.RunningTime);
	Read (&Config.RunningTimeControl);
	Read (&Config.SampleCycle);
	Read (&Config.SamplingF);
	Read (&Config.SamplingTime);
	Read (&Config.SaveFlag);
	Read (&Config.Scale);
	Read (&Config.SimpleS);
	Read (&Config.StartDelay);
	Read (&Config.StartDelayAdpative);
	Read (&Config.StartDelayControl);
	Read (&Config.TaskFlag);
	for (i = 0; i < 3; ++i) {
		Read (&Config.TaskParameter[i]);
	}
	Read (&Config.U1Limit);
	Read (&Config.U2Limit);
	Read (&Config.U3Limit);
	Read (&Config.U4Limit);
	Read (&Config.UppBound);
	Read (&Config.UppBoundER);
	Read (&Config.UppBoundVX);
	Read (&Config.UppBoundVY);
	Read (&Config.UppBoundVZ);
	Read (&Config.UppBoundX);
	Read (&Config.UppBoundY);
	Read (&Config.UppBoundZ);
	for (i = 0; i < 3; ++i) {
		Read (&Config.VDesired[i]);
	}
	Read (&Config.ViconSampleCycles);
	for (i = 0; i < 6; ++i) {
		Read (&Config.VLPDen[i]);
	}
	for (i = 0; i < 6; ++i) {
		Read (&Config.VLPNum[i]);
	}
	Read (&Config.VZDesired);
	for (i = 0; i < 3; ++i) {
		Read (&Config.XDDDot[i]);
	}
	Read (&Config.ZDesired);
	// Read (&Config.Mode);
  Config.Mode = 0;
  return 0;
}

#ifdef BEE_DEBUG
STATUS ReadModel (void) { 
  INTEGER i;

  // Reads In ASCII Order (Uppercase)
	std::cout << "CROverCL" << Config.CROverCL << std::endl;
	for (i = 0; i < 4; ++i) {
		std::cout << "FTauLimit[i]" << Config.FTauLimit[i] << std::endl;
	}
	for (i = 0; i < 3; ++i) {
		std::cout << "IMomentVec[i]" << Config.IMomentVec[i] << std::endl;
	}
	std::cout << "IXX" << Config.IXX << std::endl;
	std::cout << "IYY" << Config.IYY << std::endl;
	std::cout << "IZZ" << Config.IZZ << std::endl;
	std::cout << "PhiP2PNominalLeft" << Config.PhiP2PNominalLeft << std::endl;
	std::cout << "PhiP2PNominalOpenLoop" << Config.PhiP2PNominalOpenLoop << std::endl;
	std::cout << "PhiP2PNominalRight" << Config.PhiP2PNominalRight << std::endl;
	std::cout << "PhiPitchOffsetOpenLoop" << Config.PhiPitchOffsetOpenLoop << std::endl;
	std::cout << "PhiRollOffsetOpenLoop" << Config.PhiRollOffsetOpenLoop << std::endl;
	std::cout << "T" << Config.T << std::endl;
	std::cout << "ThrustLimit" << Config.ThrustLimit << std::endl;
	std::cout << "TorquePitchLimit" << Config.TorquePitchLimit << std::endl;
	std::cout << "TorqueRollLimit" << Config.TorqueRollLimit << std::endl;
	std::cout << "TorqueYawLimit" << Config.TorqueYawLimit << std::endl;
	std::cout << "VLP2PLimit" << Config.VLP2PLimit << std::endl;
	std::cout << "VRP2PLimit" << Config.VRP2PLimit << std::endl;
	std::cout << "VOffsetLimit" << Config.VOffsetLimit << std::endl;
	
  // (Lowercase)
  std::cout << "A2LB" << Config.A2LB << std::endl;
	std::cout << "A2OpenLoop" << Config.A2OpenLoop << std::endl;
	std::cout << "A2UB" << Config.A2UB << std::endl;
	std::cout << "AdaptiveDelay" << Config.AdaptiveDelay << std::endl;
	std::cout << "AdaptiveFlag" << Config.AdaptiveFlag << std::endl;
  for (i = 0; i < 10; ++i) {
    std::cout << "AdaptiveGain[i]" << Config.AdaptiveGain[i] << std::endl;
  }
	std::cout << "AdaptiveLateralFlag" << Config.AdaptiveLateralFlag << std::endl;
	std::cout << "AdaptivePitchInit" << Config.AdaptivePitchInit << std::endl;
	std::cout << "AdaptivePitchLimit" << Config.AdaptivePitchLimit << std::endl;
	std::cout << "AdaptivePitchLimitLow" << Config.AdaptivePitchLimitLow << std::endl;
	std::cout << "AdaptiveRollInit" << Config.AdaptiveRollInit << std::endl;
	std::cout << "AdaptiveRollLimit" << Config.AdaptiveRollLimit << std::endl;
	std::cout << "AdaptiveRollLimitLow" << Config.AdaptiveRollLimitLow << std::endl;
	std::cout << "AdaptiveXInit" << Config.AdaptiveXInit << std::endl;
	std::cout << "AdaptiveXLimit" << Config.AdaptiveXLimit << std::endl;
	std::cout << "AdaptiveXLimitLow" << Config.AdaptiveXLimitLow << std::endl;
	std::cout << "AdaptiveYInit" << Config.AdaptiveYInit << std::endl;
	std::cout << "AdaptiveYLimit" << Config.AdaptiveYLimit << std::endl;
	std::cout << "AdaptiveYLimitLow" << Config.AdaptiveYLimitLow << std::endl;
	std::cout << "AdaptiveYawInit" << Config.AdaptiveYawInit << std::endl;
	std::cout << "AdaptiveYawLimit" << Config.AdaptiveYawLimit << std::endl;
	std::cout << "AdaptiveYawLimitLow" << Config.AdaptiveYawLimitLow << std::endl;
	std::cout << "AdaptiveZInit" << Config.AdaptiveZInit << std::endl;
	std::cout << "AdaptiveZLimit" << Config.AdaptiveZLimit << std::endl;
	std::cout << "AdaptiveZLimitLow" << Config.AdaptiveZLimitLow << std::endl;
	std::cout << "AlphaXX" << Config.AlphaXX << std::endl;
	std::cout << "AttLambda" << Config.AttLambda << std::endl;
	std::cout << "AttK" << Config.AttK << std::endl;
	std::cout << "AttS" << Config.AttS << std::endl;
	std::cout << "AttS2" << Config.AttS2 << std::endl;
	for (i = 0; i < 3; ++i) {
		std::cout << "B1DDesired[i]" << Config.B1DDesired[i] << std::endl;
	}
	std::cout << "C1UppBound" << Config.C1UppBound << std::endl;
	std::cout << "C1Adaptive" << Config.C1Adaptive << std::endl;
	std::cout << "C2Adaptive" << Config.C2Adaptive << std::endl;
	std::cout << "C2UppBound" << Config.C2UppBound << std::endl;
	std::cout << "ClosedLoopFlag" << Config.ClosedLoopFlag << std::endl;
	std::cout << "ClosedLoopMaxDrvBias" << Config.ClosedLoopMaxDrvBias << std::endl;
	std::cout << "ControlFlag" << Config.ControlFlag << std::endl;
	for (i = 0; i < 7; ++i) {
		std::cout << "ControlGain[i]" << Config.ControlGain[i] << std::endl;
	}
	for (i = 0; i < 11; ++i) {
		std::cout << "Delay[i]" << Config.Delay[i] << std::endl;
	}
	std::cout << "DrvAmp" << Config.DrvAmp << std::endl;
	std::cout << "DrvAmpLimit" << Config.DrvAmpLimit << std::endl;
	std::cout << "DrvBias" << Config.DrvBias << std::endl;
	std::cout << "DrvPch" << Config.DrvPch << std::endl;
	std::cout << "DrvPitchLeft" << Config.DrvPitchLeft << std::endl;
	std::cout << "DrvPitchLeftLimit" << Config.DrvPitchLeftLimit << std::endl;
	std::cout << "DrvPitchRight" << Config.DrvPitchRight << std::endl;
	std::cout << "DrvPitchRightLimit" << Config.DrvPitchRightLimit << std::endl;
	std::cout << "DrvRoll" << Config.DrvRoll << std::endl;
	std::cout << "DrvRollLimit" << Config.DrvRollLimit << std::endl;
	for (i = 0; i < 3; ++i) {
		std::cout << "E1[i]" << Config.E1[i] << std::endl;
	}
	for (i = 0; i < 3; ++i) {
		std::cout << "E2[i]" << Config.E2[i] << std::endl;
	}
	for (i = 0; i < 3; ++i) {
		std::cout << "E3[i]" << Config.E3[i] << std::endl;
	}
	std::cout << "F" << Config.F << std::endl;
	std::cout << "FFin" << Config.FFin << std::endl;
	std::cout << "FInt" << Config.FInt << std::endl;
	std::cout << "FRes" << Config.FRes << std::endl;
	std::cout << "FrequencyRef" << Config.FrequencyRef << std::endl;
	std::cout << "FSVicon" << Config.FSVicon << std::endl;
	std::cout << "G" << Config.G << std::endl;
	std::cout << "GammaAdaptive" << Config.GammaAdaptive << std::endl;
	std::cout << "GammaLateralAdaptive" << Config.GammaLateralAdaptive << std::endl;
	std::cout << "KOmega" << Config.KOmega << std::endl;
	std::cout << "KR" << Config.KR << std::endl;
	std::cout << "KRX" << Config.KRX << std::endl;
	std::cout << "KDA" << Config.KDA << std::endl;
	std::cout << "KDA2" << Config.KDA2 << std::endl;
	std::cout << "KV" << Config.KV << std::endl;
	std::cout << "KVZ" << Config.KVZ << std::endl;
	std::cout << "KX" << Config.KX << std::endl;
	std::cout << "KZ" << Config.KZ << std::endl;
  for (i = 0; i < 4; ++i) {
	  std::cout << "LeftMapping[i]" << Config.LeftMapping[i] << std::endl;
  }
	std::cout << "LowBound" << Config.LowBound << std::endl;
	std::cout << "LowBoundER" << Config.LowBoundER << std::endl;
	std::cout << "LowBoundVX" << Config.LowBoundVX << std::endl;
	std::cout << "LowBoundVY" << Config.LowBoundVY << std::endl;
	std::cout << "LowBoundVZ" << Config.LowBoundVZ << std::endl;
	std::cout << "LowBoundX" << Config.LowBoundX << std::endl;
	std::cout << "LowBoundY" << Config.LowBoundY << std::endl;
	std::cout << "LowBoundZ" << Config.LowBoundZ << std::endl;
	for (i = 0; i < 6; ++i) {
		std::cout << "LPDen[i]" << Config.LPDen[i] << std::endl;
	}
	for (i = 0; i < 6; ++i) {
		std::cout << "LPNum[i]" << Config.LPNum[i] << std::endl;
	}
	std::cout << "M" << Config.M << std::endl;
	std::cout << "MaxDrivBias" << Config.MaxDrivBias << std::endl;
	std::cout << "NumCycle" << Config.NumCycle << std::endl;
	for (i = 0; i < 9; ++i) {
		std::cout << "ParamsVec[i]" << Config.ParamsVec[i] << std::endl;
	}
	std::cout << "PeriodRef" << Config.PeriodRef << std::endl;
	std::cout << "Phase" << Config.Phase << std::endl;
	for (i = 0; i < 3; ++i) {
		std::cout << "RDesired[i]" << Config.RDesired[i] << std::endl;
	}
	std::cout << "RadiusRatio" << Config.RadiusRatio << std::endl;
	std::cout << "RadiusRef" << Config.RadiusRef << std::endl;
	std::cout << "RampDelay" << Config.RampDelay << std::endl;
	for (i = 0; i < 4; ++i) {
		std::cout << "RightMapping[i]" << Config.RightMapping[i] << std::endl;
	}
	std::cout << "RollOffsetAngle" << Config.RollOffsetAngle << std::endl;
	std::cout << "RunningTime" << Config.RunningTime << std::endl;
	std::cout << "RunningTimeControl" << Config.RunningTimeControl << std::endl;
	std::cout << "SampleCycle" << Config.SampleCycle << std::endl;
	std::cout << "SamplingF" << Config.SamplingF << std::endl;
	std::cout << "SamplingTime" << Config.SamplingTime << std::endl;
	std::cout << "SaveFlag" << Config.SaveFlag << std::endl;
	std::cout << "Scale" << Config.Scale << std::endl;
	std::cout << "SimpleS" << Config.SimpleS << std::endl;
	std::cout << "StartDelay" << Config.StartDelay << std::endl;
	std::cout << "StartDelayAdpative" << Config.StartDelayAdpative << std::endl;
	std::cout << "StartDelayControl" << Config.StartDelayControl << std::endl;
	std::cout << "TaskFlag" << Config.TaskFlag << std::endl;
	for (i = 0; i < 3; ++i) {
		std::cout << "TaskParameter[i]" << Config.TaskParameter[i] << std::endl;
	}
	std::cout << "U1Limit" << Config.U1Limit << std::endl;
	std::cout << "U2Limit" << Config.U2Limit << std::endl;
	std::cout << "U3Limit" << Config.U3Limit << std::endl;
	std::cout << "U4Limit" << Config.U4Limit << std::endl;
	std::cout << "UppBound" << Config.UppBound << std::endl;
	std::cout << "UppBoundER" << Config.UppBoundER << std::endl;
	std::cout << "UppBoundVX" << Config.UppBoundVX << std::endl;
	std::cout << "UppBoundVY" << Config.UppBoundVY << std::endl;
	std::cout << "UppBoundVZ" << Config.UppBoundVZ << std::endl;
	std::cout << "UppBoundX" << Config.UppBoundX << std::endl;
	std::cout << "UppBoundY" << Config.UppBoundY << std::endl;
	std::cout << "UppBoundZ" << Config.UppBoundZ << std::endl;
	for (i = 0; i < 3; ++i) {
		std::cout << "VDesired[i]" << Config.VDesired[i] << std::endl;
	}
	std::cout << "ViconSampleCycles" << Config.ViconSampleCycles << std::endl;
	for (i = 0; i < 6; ++i) {
		std::cout << "VLPDen[i]" << Config.VLPDen[i] << std::endl;
	}
	for (i = 0; i < 6; ++i) {
		std::cout << "VLPNum[i]" << Config.VLPNum[i] << std::endl;
	}
	std::cout << "VZDesired" << Config.VZDesired << std::endl;
	for (i = 0; i < 3; ++i) {
		std::cout << "XDDDot[i]" << Config.XDDDot[i] << std::endl;
	}
	std::cout << "ZDesired" << Config.ZDesired << std::endl;
	// std::cout << "Mode" << Config.Mode << std::endl;
  Config.Mode = 0;
  return 0;
}
#endif

// Testing
STATUS Determinant3(const DECIMAL A[9], DECIMAL *D) {
	DECIMAL DetA = A[3 * 1 + 1] * A[3 * 2 + 2] - A[3 * 1 + 2] * A[3 * 2 + 1];
	DECIMAL DetB = A[3 * 1 + 0] * A[3 * 2 + 2] - A[3 * 1 + 2] * A[3 * 2 + 0];
	DECIMAL DetC = A[3 * 1 + 0] * A[3 * 2 + 1] - A[3 * 1 + 1] * A[3 * 2 + 0];
	*D = A[3 * 0 + 0] * DetA - A[3 * 0 + 1] * DetB + A[3 * 0 + 2] * DetC;
	return 0;
}

STATUS Adjoint3 (const DECIMAL A[9], DECIMAL Adjugate[9]) {
	DECIMAL AdjT[9];
	AdjT[0] = A[3 * 1 + 1] * A[3 * 2 + 2] - A[3 * 1 + 2] * A[3 * 2 + 1];
	AdjT[1] = -1.0 * (A[3 * 1 + 0] * A[3 * 2 + 2] - A[3 * 1 + 2] * A[3 * 2 + 0]);
	AdjT[2] = A[3 * 1 + 0] * A[3 * 2 + 1] - A[3 * 1 + 1] * A[3 * 2 + 0];
	AdjT[3] = -1.0 * (A[3 * 0 + 1] * A[3 * 2 + 2] - A[3 * 0 + 2] * A[3 * 2 + 1]);
	AdjT[4] = A[3 * 0 + 0] * A[3 * 2 + 2] - A[3 * 0 + 2] * A[3 * 2 + 0];
	AdjT[5] = -1.0 * (A[3 * 0 + 0] * A[3 * 2 + 1] - A[3 * 0 + 1] * A[3 * 2 + 0]);
	AdjT[6] = A[3 * 0 + 1] * A[3 * 1 + 2] - A[3 * 0 + 2] * A[3 * 1 + 1];
	AdjT[7] = -1.0 * (A[3 * 0 + 0] * A[3 * 1 + 2] - A[3 * 0 + 2] * A[3 * 1 + 0]);
	AdjT[8] = A[3 * 0 + 0] * A[3 * 1 + 1] - A[3 * 0 + 1] * A[3 * 1 + 0];
	MathTranspose3 (AdjT, Adjugate);
	return 0;
}

STATUS Inverse3 (const DECIMAL A[9], DECIMAL AInv[9]) {
	DECIMAL Det;
	Determinant3 (A, &Det);
	if (Det == 0) {
		return 1;
	}
	Adjoint3 (A, AInv);
	AInv[0] = AInv[0] / Det;
	AInv[1] = AInv[1] / Det;
	AInv[2] = AInv[2] / Det;
	AInv[3] = AInv[3] / Det;
	AInv[4] = AInv[4] / Det;
	AInv[5] = AInv[5] / Det;
	AInv[6] = AInv[6] / Det;
	AInv[7] = AInv[7] / Det;
	AInv[8] = AInv[8] / Det;
	return 0;
}

STATUS BeeModel (const DECIMAL X[12], const DECIMAL U[4], const DECIMAL dT, DECIMAL XNext[12]) {
	DECIMAL Sum = U[0] + U[1] + U[2] + U[3];
	if (Sum != 0) {
		const DECIMAL *P = &X[0];
		const DECIMAL *V = &X[3];
		const DECIMAL *W = &X[6];
		const DECIMAL *R = &X[9];

		const DECIMAL *PDot = V;

		const DECIMAL SinW[3] = {
			OpsSin (W[0]),
			OpsSin (W[1]),
			OpsSin (W[2])
		};

		const DECIMAL CosW[3] = {
			OpsCos (W[0]),
			OpsCos (W[1]),
			OpsCos (W[2])
		};

		const DECIMAL Rot[9] = {
			CosW[1] * CosW[2], 
			SinW[1] * CosW[2] * SinW[0] - SinW[2] * CosW[0],
			SinW[1] * CosW[2] * CosW[0] + SinW[2] * SinW[0],
			CosW[1] * SinW[0],
			SinW[1] * SinW[2] * SinW[0] + CosW[2] * CosW[0],
			SinW[1] * SinW[2] * CosW[0] - CosW[2] * SinW[0],
			-SinW[1],
			CosW[1] * SinW[0],
			CosW[1] * CosW[0]
		};

		const DECIMAL T[9] = {
			1.0,
			SinW[0] * SinW[1] / CosW[1],
			CosW[0] * SinW[1] / CosW[1],
			0,
			CosW[0],
			-SinW[0],
			0,
			SinW[0] / CosW[1],
			CosW[0] / CosW[1]
		};

		const DECIMAL Iff[9] = {
			Config.IMomentVec[0], 0, 0,
			0, Config.IMomentVec[1], 0,
			0, 0, Config.IMomentVec[2]
		};

		DECIMAL VDot[3];
		const DECIMAL VMultiplier = U[0] / Config.M - 1.2 * V[2];
		MathMultiplyM3V3 (R, Config.E3, VDot);
		VDot[0] = VDot[0] * VMultiplier;
		VDot[1] = VDot[1] * VMultiplier;
		VDot[2] = VDot[2] * VMultiplier;
		const DECIMAL VDotAdder[3] = {
			-Config.G * Config.E3[0],
			-Config.G * Config.E3[1],
			-Config.G * Config.E3[2]
		};
		VDot[0] = VDot[0] + VDotAdder[0];
		VDot[1] = VDot[1] + VDotAdder[1];
		VDot[2] = VDot[2] + VDotAdder[2];

		DECIMAL WDot[3];
		MathMultiplyM3V3 (T, R, WDot);

		DECIMAL RDot[3];
		DECIMAL IffInv[9];
		Inverse3 (Iff, IffInv);

		DECIMAL RDotVec[3];
		DECIMAL Temp0[3];
		MathMultiplyM3V3 (Iff, R, Temp0);
		const DECIMAL NegR[3] = {
			-R[0],
			-R[1],
			-R[2]
		};
		DECIMAL Temp1[3];
		MathCross3 (NegR, Temp0, Temp1);
		Temp1[0] = Temp1[0] + U[1];
		Temp1[1] = Temp1[1] + U[2];
		Temp1[2] = Temp1[2] + U[3];

		XNext[0] = X[0] + PDot[0] * dT;
		XNext[1] = X[1] + PDot[1] * dT;
		XNext[2] = X[2] + PDot[2] * dT;
		XNext[3] = X[3] + VDot[0] * dT;
		XNext[4] = X[4] + VDot[1] * dT;
		XNext[5] = X[5] + VDot[2] * dT;
		XNext[6] = X[6] + WDot[0] * dT;
		XNext[7] = X[7] + WDot[1] * dT;
		XNext[8] = X[8] + WDot[2] * dT;
		XNext[9] = X[9] + RDot[0] * dT;
		XNext[10] = X[10] + RDot[1] * dT;
		XNext[11] = X[11] + RDot[2] * dT;
	} else {
		XNext[0] = X[0];
		XNext[1] = X[1];
		XNext[2] = X[2];
		XNext[3] = X[3];
		XNext[4] = X[4];
		XNext[5] = X[5];
		XNext[6] = X[6];
		XNext[7] = X[7];
		XNext[8] = X[8];
		XNext[9] = X[9];
		XNext[10] = X[10];
		XNext[11] = X[11];
	}
	return 0;
}

// Model Functions
// Vicon Correction
STATUS VC (const DECIMAL PCur[3], DECIMAL P[3]) { // CHECK
	const DECIMAL RollOffsetAngle = Config.RollOffsetAngle;
	const DECIMAL SinRollOffsetAngle = OpsSin (RollOffsetAngle);
	const DECIMAL CosRollOffsetAngle = OpsCos (RollOffsetAngle);
	static DECIMAL RotCorrection[3 * 3];
	RotCorrection[0] = 1.0;
	RotCorrection[1] = 0;
	RotCorrection[2] = 0;
	RotCorrection[3] = 0;
	RotCorrection[4] = CosRollOffsetAngle;
	RotCorrection[5] = -SinRollOffsetAngle;
	RotCorrection[6] = 0;
	RotCorrection[7] = SinRollOffsetAngle;
	RotCorrection[8] = CosRollOffsetAngle;
	MathMultiplyM3V3 (RotCorrection, PCur, P);
	return 0;
}

// Vicon Post Processing Into Raw Rotation Matrix
STATUS VPP_RRM (const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL R[9]) { // CHECK
	const DECIMAL SinAlpha = OpsSin (Alpha);
	const DECIMAL CosAlpha = OpsCos (Alpha);
	const DECIMAL SinBeta = OpsSin (Beta);
	const DECIMAL CosBeta = OpsCos (Beta);
	const DECIMAL SinGamma = OpsSin (Gamma);
	const DECIMAL CosGamma = OpsCos (Gamma);
	R[0] = CosBeta * CosGamma;
	R[1] = -CosBeta * SinGamma;
	R[2] = SinBeta;
	R[3] = CosAlpha * SinGamma + SinAlpha * SinBeta * CosGamma;
	R[4] = CosAlpha * CosGamma - SinAlpha * SinBeta * SinGamma;
	R[5] = -CosBeta * SinAlpha;
	R[6] = SinAlpha * SinGamma - CosAlpha * SinBeta * CosGamma;
	R[7] = SinAlpha * CosGamma + CosAlpha * SinBeta * SinGamma;
	R[8] = CosAlpha * CosBeta;
	return 0;
}

// Vicon Post Processing Into Vicon Correction
STATUS VPP_VC (const DECIMAL R[9], const DECIMAL RollOffsetAngle, DECIMAL Output[9]) { // CHECK
	const DECIMAL SinRollOffsetAngle = OpsSin (RollOffsetAngle);
	const DECIMAL CosRollOffsetAngle = OpsCos (RollOffsetAngle);

  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);
	const DECIMAL RotCorrection[3 * 3] = {
		1.0, 0, 0,
		0, CosRollOffsetAngle, -SinRollOffsetAngle,
		0, SinRollOffsetAngle, CosRollOffsetAngle
	};
  DECIMAL RotCorrected[3 * 3];
	MathMultiplyM3 (RotCorrection, Rot, RotCorrected);
  MathVector9 (RotCorrected, Output);
	return 0;
}

// Vicon Post Processing Into Vicon Validity Check
STATUS VPP_VVC (const DECIMAL R[9], INTEGER *Cur, INTEGER *Prev) { // CHECK
	static DECIMAL RPrev[9] = { 0 };
	static INTEGER Count = 0;
	static INTEGER StatPrev = 0;
  
  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);
  DECIMAL RotPrev[3 * 3];
  MathMatrix3 (RPrev, RotPrev);

	DECIMAL TransposeRot[3 * 3];
	MathTranspose3 (Rot, TransposeRot);

	DECIMAL A[3 * 3];
	MathMultiplyM3 (TransposeRot, RotPrev, A);
	for (INTEGER i = 0; i < 3; ++i) {
    A[3 * i + i] = A[3 * i + i] - 1.0;
  }
	
  DECIMAL TransposeA[3 * 3];
	MathTranspose3 (A, TransposeA);
	
  DECIMAL TraceMatrix[3 * 3];
	MathMultiplyM3 (TransposeA, A, TraceMatrix);
	
  DECIMAL Error;
	MathTrace3 (TraceMatrix, &Error);
	
  INTEGER Stat;
	if (Error < 1.0E-18) {
		Stat = 0;
	} else {
		Stat = 1;
	}

	*Prev = Count;
	if (StatPrev == 0 && Stat == 1) {
		Count = 0;
	} else {
		++Count;
	}

	*Cur = Count;
	StatPrev = Stat;
	MathCopyV9 (R, RPrev);
	return 0;
}

// Vicon Post Processing
STATUS VPP (const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL Matrix[9], INTEGER *Update, INTEGER *Count) { // CHECK
	const DECIMAL RollOffsetAngle = Config.RollOffsetAngle;
  DECIMAL R[9];
  VPP_RRM (Alpha, Beta, Gamma, R);
  VPP_VC (R, RollOffsetAngle, Matrix);
  VPP_VVC (Matrix, Update, Count);
  return 0;
}

// Observer For Averaged System Into Position Observer Into Average Position Velocity
STATUS OFAS_PO_APV (const DECIMAL R[3], const INTEGER Update, const INTEGER Count, DECIMAL ROut[3], DECIMAL VOut[3]) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;

  static DECIMAL RPrev[50 * 3] = { 0 };
  DECIMAL *RPrev1 = &RPrev[ 9 * 3];
  DECIMAL *RPrev2 = &RPrev[29 * 3];
  DECIMAL *RPrev3 = &RPrev[49 * 3];

  static DECIMAL ROutPrev[3] = { 0 };
  static DECIMAL VOutPrev[3] = { 0 };

  if (Update > 0) {
    MathCopyV3 (ROutPrev, ROut);
    MathCopyV3 (VOutPrev, VOut);
  } else {
    // 1 Cycle Average
    DECIMAL N = 4.0;

    for (INTEGER i = 0; i < 3; ++i) {
      ROut[i] = (RPrev1[i] + RPrev2[i] + RPrev3[i] + R[i]) / N;
      VOut[i] = (ROut[i] - ROutPrev[i]) * SamplingF / ((double) (Count + 1));
    }
  }

  for (INTEGER i = 49; i >= 0; --i) {
    for (INTEGER j = 0; j < 3; ++j) {
      if (i == 0) {
        RPrev[i * 3 + j] = R[j];
      } else {
        RPrev[i * 3 + j] = RPrev[(i - 1) * 3 + j];
      }
    }
  }

  MathCopyV3 (ROut, ROutPrev);
  MathCopyV3 (VOut, VOutPrev);

  return 0;
}

// Observer For Averaged System Into Position Observer
STATUS OFAS_PO (const DECIMAL PRaw[3], const INTEGER Update, const INTEGER Count, DECIMAL P[3], DECIMAL V[3]) { // CHECK
  INTEGER i, j;

  OFAS_PO_APV (PRaw, Update, Count, P, V);

  DECIMAL *X = P;
  
  // LPF
  static DECIMAL XPrev[3 * 6];
  static DECIMAL YPrev[3 * 5];

  for (i = 5; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        XPrev[j * 6 + i] = X[j];
      } else {
        XPrev[j * 6 + i] = XPrev[j * 6 + i - 1];
      }
    }
  }
  
  DECIMAL Y[3];
  for (i = 0; i < 3; ++i) {
    UtilsLP (&XPrev[6 * i], &YPrev[5 * i], &Y[i]);
  }

  for (i = 4; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        YPrev[j * 5 + i] = Y[j];
      } else {
        YPrev[j * 5 + i] = YPrev[j * 5 + i - 1];
      }
    }
  }

  MathCopyV3 (Y, P);
  DECIMAL *U = V;

  // LPF
  static DECIMAL UPrev[3 * 6];
  static DECIMAL ZPrev[3 * 5];

  for (i = 5; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        UPrev[j * 6 + i] = U[j];
      } else {
        UPrev[j * 6 + i] = UPrev[j * 6 + i - 1];
      }
    }
  }

  DECIMAL Z[3];
  for (i = 0; i < 3; ++i) {
    UtilsLP (&UPrev[i * 6], &ZPrev[i * 5], &Z[i]);
  }

  for (i = 4; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        ZPrev[j * 5 + i] = Z[j];
      } else {
        ZPrev[j * 5 + i] = ZPrev[j * 5 + i - 1];
      }
    }
  }

  MathCopyV3 (Z, V);

  return 0;
}

// Observer For Averaged System Into Euler Derivative and Filtered Angular Velocity Into Filtered Derivative
STATUS OFAS_EDFAV_DER (const DECIMAL R[9], DECIMAL RDot[9]) { // CHECK
  const DECIMAL AttS = Config.AttS;
  
  DECIMAL X[9];
  for (INTEGER i = 0; i < 9; ++i) {
    X[i] = AttS * R[i];
  }

  static DECIMAL XPrev[9] = { 0 };
  static DECIMAL YPrev[9] = { 0 };

  DECIMAL Y[9];
  UtilsFDer (X, XPrev, YPrev, Y);

  MathCopyV9 (X, XPrev);
  MathCopyV9 (Y, YPrev);

  MathCopyV9 (Y, RDot);

  return 0;
}

// Observer For Averaged System Into Euler Derivative and Filtered Angular Velocity Into Angular Velocity
STATUS OFAS_EDFAV_AV (const DECIMAL R[9], const DECIMAL RDot[9], DECIMAL W[3], DECIMAL *FrobError) { // CHECK
  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);
  
  DECIMAL RotDot[3 * 3];
  MathMatrix3 (RDot, RotDot);

  DECIMAL TransposeRot[3 * 3];
  MathTranspose3 (Rot, TransposeRot);

  DECIMAL A[3 * 3];
  MathMultiplyM3 (TransposeRot, RotDot, A);

  DECIMAL TransposeA[3 * 3];
  MathTranspose3 (A, TransposeA);
  DECIMAL WHat[3 * 3];

  MathSubtractM3 (A, TransposeA, WHat);
  MathMultiplyM3K (0.5, WHat, WHat);

  W[0] = WHat[3 * 2 + 1];
  W[1] = WHat[3 * 0 + 2];
  W[2] = WHat[3 * 1 + 0];

  DECIMAL Sum[3 * 3];
  MathAddM3 (A, TransposeA, Sum);
  DECIMAL Tmp[3 * 3];
  MathMultiplyM3 (Sum, Sum, Tmp);

  MathTrace3 (Tmp, FrobError);

  return 0;
}

// Observer For Averaged System Into Euler Derivative and Filtered Angular Velocity
STATUS OFAS_EDFAV (const DECIMAL R[9], DECIMAL W[3], DECIMAL *FrobError) { // CHECK
  INTEGER i, j;

  DECIMAL RDot[9];
  OFAS_EDFAV_DER (R, RDot);

  DECIMAL *X = RDot;
  static DECIMAL XPrev[9 * 6];
  static DECIMAL YPrev[9 * 5];

  for (i = 5; i >= 0; --i) {
    for (j = 0; j < 9; ++j) {
      if (i == 0) {
        XPrev[j * 6 + i] = X[j];
      } else {
        XPrev[j * 6 + i] = XPrev[j * 6 + i - 1];
      }
    }
  }

  DECIMAL Y[9];
  for (i = 0; i < 9; ++i) {
    UtilsLP (&XPrev[i * 6], &YPrev[i * 5], &Y[i]);
  }
  
  for (i = 4; i >= 0; --i) {
    for (j = 0; j < 9; ++j) {
      if (i == 0) {
        YPrev[j * 5 + i] = Y[j];
      } else {
        YPrev[j * 5 + i] = YPrev[j * 5 + i - 1];
      }
    }
  }

  MathCopyV9 (Y, RDot);
  OFAS_EDFAV_AV (R, RDot, W, FrobError);

  return 0;
}

// Observer For Averaged System Into Attitude Observer Into Geometric Derivative
STATUS OFAS_AO_GD_FUNC (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDot[3]) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;

  static DECIMAL RPrev[9] = { 0 };
  static DECIMAL OmegaDotPrev[3] = { 0 };

  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);
  DECIMAL RotPrev[3 * 3];
  MathMatrix3 (RPrev, RotPrev);

  DECIMAL TransposeRotPrev[3 * 3];
  MathTranspose3 (RotPrev, TransposeRotPrev);

  DECIMAL RDiff[3 * 3];
  MathMultiplyM3 (TransposeRotPrev, Rot, RDiff);
  
  DECIMAL TrRDiff;
  MathTrace3 (RDiff, &TrRDiff);

  if (Update > 0) {
    MathCopyV3 (OmegaDotPrev, OmegaDot);
  } else {
    DECIMAL Tmp = (TrRDiff - 1.0) / 2.0;
    DECIMAL Theta;
    if (OpsAbs (Tmp) < 1.0) {
      Theta = OpsAcos (Tmp);
    } else {
      Theta = OpsAcos (Tmp / OpsAbs (Tmp));
    }

    if (Theta == 0) {
      Theta = 1.0E-14;
    }

    DECIMAL W[3];
    W[0] = RDiff[3 * 2 + 1] - RDiff[3 * 1 + 2];
    W[1] = RDiff[3 * 0 + 2] - RDiff[3 * 2 + 0];
    W[2] = RDiff[3 * 1 + 0] - RDiff[3 * 0 + 1];
    MathMultiplyV3K (1.0 / (2.0 * OpsSin (Theta)), W, W);
    MathMultiplyV3K (Theta * SamplingF / ((double) (Count + 1)), W, OmegaDot);
  }

  MathCopyV9 (R, RPrev);
  MathCopyV3 (OmegaDot, OmegaDotPrev);

  return 0;
}

// Observer For Averaged System Into Attitude Observer Into Geometric Derivative
STATUS OFAS_AO_GD (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDot[3]) { // CHECK
  INTEGER i, j;
  OFAS_AO_GD_FUNC (R, Update, Count, OmegaDot);

  DECIMAL *X = OmegaDot;
  // LPF
  static DECIMAL XPrev[3 * 6];
  static DECIMAL YPrev[3 * 5];

  for (i = 5; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        XPrev[j * 6 + i] = X[j];
      } else {
        XPrev[j * 6 + i] = XPrev[j * 6 + i - 1];
      }
    }
  }

  DECIMAL Y[3];
  for (i = 0; i < 3; ++i) {
    UtilsLP (&XPrev[i * 6], &YPrev[i * 5], &Y[i]);
  }

  for (i = 4; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        YPrev[j * 5 + i] = Y[j];
      } else {
        YPrev[j * 5 + i] = YPrev[j * 5 + i - 1];
      }
    }
  }

  MathCopyV3 (Y, OmegaDot);
  return 0;
}

// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix Into Raw Quaternion
STATUS OFAS_AO_GARM_RQ (const DECIMAL R[9], DECIMAL Q[4]) { // CHECK
  return MathRot2Quat (R, Q);
}

// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix
STATUS OFAS_AO_GARM_FUNC (const DECIMAL R[9], const INTEGER Update, DECIMAL ROut[9]) { // CHECK
  static DECIMAL ROutPrev[9] = { 0 };
  static DECIMAL RPrev[50 * 9] = { 0 };

  DECIMAL *RPrev1 = &RPrev[ 9 * 9];
  DECIMAL *RPrev2 = &RPrev[29 * 9];
  DECIMAL *RPrev3 = &RPrev[49 * 9];

  if (Update > 0) {
    MathCopyV9 (ROutPrev, ROut);
  } else {
    const DECIMAL N = 4.0;
    DECIMAL WR0[3];
    DECIMAL WR1[3];
    DECIMAL WR2[3];
    DECIMAL WR3[3];
    
    MathExpMap3 (R, WR0);
    MathExpMap3 (RPrev1, WR1);
    MathExpMap3 (RPrev2, WR2);
    MathExpMap3 (RPrev3, WR3);

    DECIMAL Tmp30, Tmp31, Tmp32;
    MathDot3 (WR3, WR0, &Tmp30);
    MathDot3 (WR3, WR1, &Tmp31);
    MathDot3 (WR3, WR1, &Tmp32);
    if (Tmp30 < 0) {
      MathMultiplyV3K (-1.0, WR0, WR0);
    }
    if (Tmp31 < 0) {
      MathMultiplyV3K (-1.0, WR1, WR1);
    }
    if (Tmp32 < 0) {
      MathMultiplyV3K (-1.0, WR2, WR2);
    }

    DECIMAL MeanR0[3 * 3];
    DECIMAL MeanR1[3 * 3];
    DECIMAL MeanR2[3 * 3];
    DECIMAL MeanR3[3 * 3];

    MathFracRot3 (WR0, N, MeanR0);
    MathFracRot3 (WR1, N, MeanR1);
    MathFracRot3 (WR2, N, MeanR2);
    MathFracRot3 (WR3, N, MeanR3);

    DECIMAL MeanT32[3 * 3];
    MathMultiplyM3 (MeanR3, MeanR2, MeanT32);
    DECIMAL MeanT321[3 * 3];
    MathMultiplyM3 (MeanT32, MeanR1, MeanT321);
    DECIMAL MeanR[3 * 3];
    MathMultiplyM3 (MeanT321, MeanR0, MeanR);

    MathVector9 (MeanR, ROut);
  }

  for (INTEGER i = 49; i >= 0; --i) {
    for (INTEGER j = 0; j < 9; ++j) {
      if (i == 0) {
        RPrev[i * 9 + j] = R[j];
      } else {
        RPrev[i * 9 + j] = RPrev[(i - 1) * 9 + j];
      }
    }
  }

  MathCopyV9 (ROut, ROutPrev);
  return 0;
}

// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix Into Averaged Quaternion
STATUS OFAS_AO_GARM_AQ (const DECIMAL R[9], DECIMAL Q[4]) { // CHECK
  return MathRot2Quat (R, Q);
}

// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix
STATUS OFAS_AO_GARM (const DECIMAL R[9], const INTEGER Update, DECIMAL QAvg[4], DECIMAL RAvg[9], DECIMAL QRaw[4]) { // CHECK
  OFAS_AO_GARM_FUNC (R, Update, RAvg);
  OFAS_AO_GARM_AQ (RAvg, QAvg);
  OFAS_AO_GARM_RQ (R, QRaw);
  return 0;
}

// Observer For Averaged System Into Attitude Observer
STATUS OFAS_AO (const DECIMAL RRaw[9], const INTEGER Update, const INTEGER Count, DECIMAL QAvg[4], DECIMAL RAvg[9], DECIMAL QRaw[4], DECIMAL OmegaDot[3]) { // CHECK
  OFAS_AO_GARM (RRaw, Update, QAvg, RAvg, QRaw);
  OFAS_AO_GD (RAvg, Update, Count, OmegaDot);
  return 0;
}

// Observer For Averaged System
STATUS OFAS (const DECIMAL PRaw[3], const DECIMAL RRaw[9], const INTEGER Update, const INTEGER Count, DECIMAL W[3], DECIMAL QAvg[4], DECIMAL QRaw[4], DECIMAL P[3], DECIMAL V[3], DECIMAL RAvg[9], DECIMAL OmegaDot[3]) { // CHECK
  DECIMAL FrobError;
  OFAS_EDFAV (RRaw, W, &FrobError);
  OFAS_AO (RRaw, Update, Count, QAvg, RAvg, QRaw, OmegaDot);
  OFAS_PO (PRaw, Update, Count, P, V);
  return 0;
}

// Pre Processing
STATUS PP (const DECIMAL PCur[3], const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL W[3], DECIMAL QAvg[4], DECIMAL QRaw[4], DECIMAL P[3], DECIMAL V[3], DECIMAL RAvg[9], DECIMAL OmegaDot[3], INTEGER* Update, INTEGER* Count) { // CHECK
  DECIMAL PRaw[3];
  DECIMAL RRaw[9];

  VC (PCur, PRaw);
  VPP (Alpha, Beta, Gamma, RRaw, Update, Count);
  OFAS (PRaw, RRaw, *Update, *Count, W, QAvg, QRaw, P, V, RAvg, OmegaDot);

  return 0;
}

// TRAJectory Generation
STATUS TRAJ_FUNC (const DECIMAL T, const INTEGER TaskFlag, const DECIMAL ComDesired[3], const DECIMAL B1DDesired[3], const DECIMAL TaskParameter[3], DECIMAL PDesired[3], DECIMAL VDesired[3], DECIMAL ADesired[3], DECIMAL B1D[3]) { // CHECK
  if (TaskFlag == 1) {
    DECIMAL RadiusRef = TaskParameter[0];
    DECIMAL FrequencyRef = TaskParameter[1];

    MathCopyV3 (ComDesired, PDesired);
    PDesired[0] += RadiusRef * OpsCos (FrequencyRef * T);
    PDesired[1] += RadiusRef * OpsSin (FrequencyRef * T);

    VDesired[0] = -RadiusRef * FrequencyRef * OpsSin (FrequencyRef * T);
    VDesired[1] = RadiusRef * FrequencyRef * OpsCos (FrequencyRef * T);
    VDesired[2] = 0;
    
    ADesired[0] = -RadiusRef * FrequencyRef * FrequencyRef * OpsCos (FrequencyRef * T);
    ADesired[1] = -RadiusRef * FrequencyRef * FrequencyRef * OpsSin (FrequencyRef * T);
    ADesired[2] = 0;

    if (RadiusRef < 1.0E-6) {
      MathCopyV3 (B1DDesired, B1D);
    } else {
      MathHead3 (VDesired, B1D);
    }
  } else if (TaskFlag == 2) {
    DECIMAL RadiusRef = TaskParameter[0];
    DECIMAL FrequencyRef = TaskParameter[1];
    DECIMAL RadiusRatio = TaskParameter[2];

    MathCopyV3 (ComDesired, PDesired);
    PDesired[0] += RadiusRatio * RadiusRef * OpsCos (FrequencyRef * T);
    PDesired[1] += -RadiusRef * OpsSin (FrequencyRef * T);

    VDesired[0] = -RadiusRef * FrequencyRef * RadiusRatio * OpsSin (FrequencyRef * T);
    VDesired[1] = -RadiusRef * FrequencyRef * OpsCos (FrequencyRef * T);
    VDesired[2] = 0;
    
    ADesired[0] = -RadiusRef * FrequencyRef * FrequencyRef * RadiusRatio * OpsCos (FrequencyRef * T);
    ADesired[1] = RadiusRef * FrequencyRef * FrequencyRef * OpsSin (FrequencyRef * T);
    ADesired[2] = 0;

    if (RadiusRef < 1.0E-6) {
      MathCopyV3 (B1DDesired, B1D);
    } else {
      MathHead3 (VDesired, B1D);
    }
  } else {
    MathCopyV3 (ComDesired, PDesired);
    MathZeroV3 (VDesired);
    MathZeroV3 (ADesired);
    MathCopyV3 (B1DDesired, B1D);
  }

  return 0;
}

// TRAJectory Generation
STATUS TRAJ (const DECIMAL T, DECIMAL PDesired[3], DECIMAL VDesired[3], DECIMAL ADesired[3], DECIMAL B1D[3]) { // CHECK
  const INTEGER TaskFlag = Config.TaskFlag;
  const DECIMAL *TaskParameter = Config.TaskParameter;
  const DECIMAL *ComDesired = Config.RDesired; // !!!ON PURPOSE!!!
  const DECIMAL *B1DDesired = Config.B1DDesired;

  return TRAJ_FUNC (T, TaskFlag, ComDesired, B1DDesired, TaskParameter, PDesired, VDesired, ADesired, B1D);
}

// Desired Altitude and Normalized Error Into Saturated Normalized Error Observation Into Saturated Normalized Attitute Error
STATUS DAANE_SNEO_SNAE (const DECIMAL AvgP[3], const DECIMAL PDesired[3], const DECIMAL AvgV[3], const DECIMAL VDesired[3], DECIMAL EP[3], DECIMAL EV[3]) { // CHECK
  const DECIMAL UppBoundX = Config.UppBoundX;
  const DECIMAL LowBoundX = Config.LowBoundX;
  const DECIMAL UppBoundVX = Config.UppBoundVX;
  const DECIMAL LowBoundVX = Config.LowBoundVX;

  const DECIMAL UppBoundY = Config.UppBoundY;
  const DECIMAL LowBoundY = Config.LowBoundY;
  const DECIMAL UppBoundVY = Config.UppBoundVY;
  const DECIMAL LowBoundVY = Config.LowBoundVY;

  const DECIMAL UppBoundZ = Config.UppBoundZ;
  const DECIMAL LowBoundZ = Config.LowBoundZ;
  const DECIMAL UppBoundVZ = Config.UppBoundVZ;
  const DECIMAL LowBoundVZ = Config.LowBoundVZ;

  const DECIMAL KX = ((DECIMAL) 2.0) / (UppBoundX - LowBoundX);
  const DECIMAL KY = ((DECIMAL) 2.0) / (UppBoundY - LowBoundY);
  const DECIMAL KZ = ((DECIMAL) 2.0) / (UppBoundZ - LowBoundZ);
  const DECIMAL KVX = ((DECIMAL) 2.0) / (UppBoundVX - LowBoundVX);
  const DECIMAL KVY = ((DECIMAL) 2.0) / (UppBoundVY - LowBoundVY);
  const DECIMAL KVZ = ((DECIMAL) 2.0) / (UppBoundVZ - LowBoundVZ);

  DECIMAL PE[3];
  DECIMAL VE[3];
  MathSubtractV3 (AvgP, PDesired, PE);
  MathSubtractV3 (AvgV, VDesired, VE);

  MathSat1 (PE[0], UppBoundX, LowBoundX, KX, &EP[0]);
  MathSat1 (PE[1], UppBoundY, LowBoundY, KY, &EP[1]);
  MathSat1 (PE[2], UppBoundZ, LowBoundZ, KZ, &EP[2]);

  MathSat1 (VE[0], UppBoundVX, LowBoundVX, KVX, &EV[0]);
  MathSat1 (VE[1], UppBoundVY, LowBoundVY, KVY, &EV[1]);
  MathSat1 (VE[2], UppBoundVZ, LowBoundVZ, KVZ, &EV[2]);

  return 0;
}

// Desired Altitude and Normalized Error Into Saturated Normalized Error Observation Into Saturated Normalized eR
STATUS DAANE_SNEO_SN (const DECIMAL R[9], const DECIMAL RDesired[9], DECIMAL ER[3]) { // CHECK
  INTEGER i, j;

  const DECIMAL UppBoundER = Config.UppBoundER;
  const DECIMAL LowBoundER = Config.LowBoundER;

  DECIMAL K = ((DECIMAL) 2.0) / (UppBoundER - LowBoundER);
  DECIMAL Rot[9];
  DECIMAL RotDesired[9];

  Rot[0] = R[0];
  Rot[3] = R[1];
  Rot[6] = R[2];
  Rot[1] = R[3];
  Rot[4] = R[4];
  Rot[7] = R[5];
  Rot[2] = R[6];
  Rot[5] = R[7];
  Rot[8] = R[8];

  RotDesired[0] = RDesired[0];
  RotDesired[3] = RDesired[1];
  RotDesired[6] = RDesired[2];
  RotDesired[1] = RDesired[3];
  RotDesired[4] = RDesired[4];
  RotDesired[7] = RDesired[5];
  RotDesired[2] = RDesired[6];
  RotDesired[5] = RDesired[7];
  RotDesired[8] = RDesired[8];

  INTEGER i0, i1, i2, i3, i4, i5, idx;
  DECIMAL ArrA[9];
  DECIMAL ArrB[9];

  for (i = 0; i < 3; ++i) {
    i0 = 3 * i;
    i1 = 3 * i + 1;
    i2 = 3 * i + 2;
    for (j = 0; j < 3; ++j) {
      i3 = 3 * j;
      i4 = 3 * j + 1;
      i5 = 3 * j + 2;
      idx = i + 3 * j;
      ArrA[idx] = (Rot[i0] * RotDesired[i3] + Rot[i1] * RotDesired[i4]) + (Rot[i2] * RotDesired[i5]);
      ArrB[idx] = (Rot[i3] * RotDesired[i0] + Rot[i4] * RotDesired[i1]) + (Rot[i5] * RotDesired[i2]);
    }
  }

  DECIMAL ERSO3[9];
  for (i = 0; i < 9; ++i) {
    ERSO3[i] = 0.5 * (ArrB[i] - ArrA[i]);
  }
  ER[0] = ERSO3[5];
  ER[1] = ERSO3[6];
  ER[2] = ERSO3[1];

  MathSat3 (ER, UppBoundER, LowBoundER, K, ER);
  return 0;
}

//
STATUS DAANE_SNEO_SAV (const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL R[9], const DECIMAL RDesired[9], DECIMAL EOmega[3]) { // CHECK
  const DECIMAL UppBound = Config.UppBound;
  const DECIMAL LowBound = Config.LowBound;

  DECIMAL BR[9];
  DECIMAL BRDesired[9];
  DECIMAL d, d1, d2, d3;

  DECIMAL K = ((DECIMAL) 2.0) / (UppBound - LowBound);
  MathCopyV9 (R, BR);
  BRDesired[0] = RDesired[0];
  BRDesired[3] = RDesired[1];
  BRDesired[6] = RDesired[2];
  BRDesired[1] = RDesired[3];
  BRDesired[4] = RDesired[4];
  BRDesired[7] = RDesired[5];
  BRDesired[2] = RDesired[6];
  BRDesired[5] = RDesired[7];
  BRDesired[8] = RDesired[8];

  for (INTEGER i = 0; i < 3; ++i) {
    d = 0;
    d1 = BR[i];
    d2 = BR[i + 3];
    d3 = BR[i + 6];
    for (INTEGER j = 0; j < 3; ++j) {
      INTEGER i1 = 3 * j;
      d += ((d1 * BRDesired[i1] + d2 * BRDesired[i1 + 1]) + d3 * BRDesired[i1 + 2]) * OmegaDesired[j];
    }
    EOmega[i] = Omega[i] - d;
  }

  MathSat3 (EOmega, UppBound, LowBound, K, EOmega);

  return 0;
}

//
STATUS DAANE_SNEO (const DECIMAL P[3], const DECIMAL V[3], const DECIMAL R[9], const DECIMAL Omega[3], const DECIMAL PDesired[3], const DECIMAL VDesired[3], const DECIMAL RDesired[9], const DECIMAL OmegaDesired[3], DECIMAL EP[3], DECIMAL EV[3], DECIMAL ER[3], DECIMAL EOmega[3]) { // CHECK
  DAANE_SNEO_SAV (Omega, OmegaDesired, R, RDesired, EOmega);
  DAANE_SNEO_SN (R, RDesired, ER);
  DAANE_SNEO_SNAE (P, PDesired, V, VDesired, EP, EV);

  return 0;
}

//
STATUS DAANE_DA (const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ADesired[3], const DECIMAL B1D[3], const DECIMAL Update, const DECIMAL AdaptiveLateralControl[3], DECIMAL RDesired[9]) { // CHECK
  static DECIMAL RDesiredPrev[9] = { 0 };

  if (Update > 0) {
    MathCopyV9 (RDesiredPrev, RDesired);
  } else {
    const DECIMAL *ControlGain = Config.ControlGain;
    const DECIMAL M = Config.M;
    const DECIMAL G = Config.G;

    DECIMAL KX = ControlGain[0];
    DECIMAL KV = ControlGain[1];
    DECIMAL KZ = ControlGain[4];
    DECIMAL KVZ = ControlGain[5];

    DECIMAL XK[3] = {KX, KX, KZ};
    DECIMAL VK[3] = {KV, KV, KVZ};

    DECIMAL E3[3] = {0, 0, 1.0};
    DECIMAL Tmp[3];
    MathHead3 (B1D, Tmp);

    DECIMAL B3D[3];
    for (INTEGER i = 0; i < 3; ++i) {
      B3D[i] = -XK[i] * EX[i] - VK[i] * EV[i] - AdaptiveLateralControl[i] + M * G * E3[i] + M * ADesired[i]; // G Creates the Error
    }

    MathHead3 (B3D, B3D);

    DECIMAL B2D[3];
    MathCross3 (B3D, Tmp, B2D);
    MathHead3 (B2D, B2D);

    DECIMAL B4D[3];
    MathCross3 (B2D, B3D, B4D);

    RDesired[0] = B4D[0];
    RDesired[1] = B2D[0];
    RDesired[2] = B3D[0];
    RDesired[3] = B4D[1];
    RDesired[4] = B2D[1];
    RDesired[5] = B3D[1];
    RDesired[6] = B4D[2];
    RDesired[7] = B2D[2];
    RDesired[8] = B3D[2];
  }

  MathCopyV9 (RDesired, RDesiredPrev);
  return 0;
}

//
STATUS DAANE_GD_FUNC (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDot[3]) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;

  static DECIMAL RPrev[9] = { 0 };
  static DECIMAL OmegaDotPrev[3] = { 0 };

  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);
  DECIMAL RotPrev[3 * 3];
  MathMatrix3 (RPrev, RotPrev);

  DECIMAL TransposeRotPrev[3 * 3];
  MathTranspose3 (RotPrev, TransposeRotPrev);

  DECIMAL RDiff[3 * 3];
  MathMultiplyM3 (TransposeRotPrev, Rot, RDiff);

  DECIMAL TrRDiff;
  MathTrace3 (RDiff, &TrRDiff);

  if (Update > 0) {
    MathCopyV3 (OmegaDotPrev, OmegaDot);
  } else {
    DECIMAL Tmp = (TrRDiff - 1.0) / 2.0;
    DECIMAL Theta;

    if (OpsAbs (Tmp) < 1.0) {
      Theta = OpsAcos (Tmp);
    } else {
      Theta = OpsAcos (Tmp / OpsAbs (Tmp));
    }

    if (Theta == 0) {
      Theta = 1.0E-14;
    }

    DECIMAL W[3];
    W[0] = RDiff[3 * 2 + 1] - RDiff[3 * 1 + 2];
    W[1] = RDiff[3 * 0 + 2] - RDiff[3 * 2 + 0];
    W[2] = RDiff[3 * 1 + 0] - RDiff[3 * 0 + 1];
    MathMultiplyV3K (1.0 / (2.0 * OpsSin (Theta)), W, W);
    MathMultiplyV3K (Theta * SamplingF / ((double) (Count + 1)), W, OmegaDot);
  }

  MathCopyV9 (R, RPrev);
  MathCopyV3 (OmegaDot, OmegaDotPrev);

  return 0;
}

//
STATUS DAANE_GD_DER (const DECIMAL OmegaDesired[3], DECIMAL Output[3]) { // CHECK
  INTEGER i, j;
  static DECIMAL Prev[3] = {0, 0, 0};
  for (i = 0; i < 3; ++i) {
    UtilsDer (OmegaDesired[i], Prev[i], &Output[i]);
  }
  MathCopyV3 (OmegaDesired, Prev);

  DECIMAL *X = Output;
  
  // LPF
  static DECIMAL XPrev[3 * 6];
  static DECIMAL YPrev[3 * 5];

  for (i = 5; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        XPrev[j * 6 + i] = X[j];
      } else {
        XPrev[j * 6 + i] = XPrev[j * 6 + i - 1];
      }
    }
  }

  DECIMAL Y[3];
  for (i = 0; i < 3; ++i) {
    UtilsVLP (&XPrev[i * 6], &YPrev[i * 5], &Y[i]);
  }

  for (i = 4; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        YPrev[j * 5 + i] = Y[j];
      } else {
        YPrev[j * 5 + i] = YPrev[j * 5 + i - 1];
      }
    }
  }

  MathCopyV3 (Y, Output);
  return 0;
}

//
STATUS DAANE_GD (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDesired[3], DECIMAL OmegaDotDesired[3]) { // CHECK
  INTEGER i, j;

  DAANE_GD_FUNC (R, Update, Count, OmegaDesired);

  DECIMAL *X = OmegaDesired;
  
  // LPF
  static DECIMAL XPrev[3 * 6];
  static DECIMAL YPrev[3 * 5];

  for (i = 5; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        XPrev[j * 6 + i] = X[j];
      } else {
        XPrev[j * 6 + i] = XPrev[j * 6 + i - 1];
      }
    }
  }

  DECIMAL Y[3];
  for (i = 0; i < 3; ++i) {
    UtilsLP (&XPrev[i * 6], &YPrev[i * 5], &Y[i]);
  }

  for (i = 4; i >= 0; --i) {
    for (j = 0; j < 3; ++j) {
      if (i == 0) {
        YPrev[j * 5 + i] = Y[j];
      } else {
        YPrev[j * 5 + i] = YPrev[j * 5 + i - 1];
      }
    }
  }

  for (i = 0; i < 3; ++i) {
    OmegaDesired[i] = Y[i];
  }

  DAANE_GD_DER (OmegaDesired, OmegaDotDesired);
  return 0;
}

//
STATUS DAANE (const INTEGER Update, const INTEGER Count, const DECIMAL P[3], const DECIMAL V[3], const DECIMAL R[9], const DECIMAL Omega[3], const DECIMAL PDesired[3], const DECIMAL VDesired[3], const DECIMAL ADesired[3], const DECIMAL B1D[3], const DECIMAL AdaptiveLateralControl[3], DECIMAL RDesired[9], DECIMAL OmegaDesired[3], DECIMAL OmegaDotDesired[3], DECIMAL EP[3], DECIMAL EV[3], DECIMAL ER[3], DECIMAL EOmega[3]) { // CHECK
  static DECIMAL EPPrev[3] = { 0 };
  static DECIMAL EVPrev[3] = { 0 };

  DAANE_DA (EPPrev, EVPrev, ADesired, B1D, Update, AdaptiveLateralControl, RDesired);
  DAANE_GD (RDesired, Update, Count, OmegaDesired, OmegaDotDesired);
  DAANE_SNEO (P, V, R, Omega, PDesired, VDesired, RDesired, OmegaDesired, EP, EV, ER, EOmega);

  MathCopyV3 (EP, EPPrev);
  MathCopyV3 (EV, EVPrev);

  return 0;
}

//
STATUS GC_LA_AC (const DECIMAL CurrentAdaptiveX, const DECIMAL CurrentAdaptiveY, const DECIMAL CurrentAdaptiveZ, const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *DerAdaptiveTorqueX, DECIMAL *DerAdaptiveTorqueY, DECIMAL *DerAdaptiveTorqueZ) { // CHECK
  // Current Adaptation
  DECIMAL AdaptiveTorqueX = CurrentAdaptiveX;
  DECIMAL AdaptiveTorqueY = CurrentAdaptiveY;
  DECIMAL AdaptiveTorqueZ = CurrentAdaptiveZ;

  // Adaptive Control Parameters
  DECIMAL GammaLateralAdaptive = AdaptiveGainLimit[5];
  DECIMAL AdaptiveXLimit = AdaptiveGainLimit[6];
  DECIMAL AdaptiveYLimit = AdaptiveGainLimit[7];
  DECIMAL AdaptiveZLimit = AdaptiveGainLimit[8];
  DECIMAL C1 = AdaptiveGainLimit[9];

  // The Limit Flag
  DECIMAL AdaptiveFlagX = AdaptiveTorqueX * (EV[0] + C1 * EX[0]);
  DECIMAL AdaptiveFlagY = AdaptiveTorqueY * (EV[1] + C1 * EX[1]);
  DECIMAL AdaptiveFlagZ = AdaptiveTorqueZ * (EV[2] + C1 * EX[2]);

  // Derivative
  DECIMAL DerAdaptive[3];
  for (INTEGER i = 0; i < 3; ++i) {
    DerAdaptive[i] = GammaLateralAdaptive * (EV[i] + C1 * EX[i]);
  }

  if (((AdaptiveFlagX <= 0) && (OpsAbs(AdaptiveTorqueX) == AdaptiveXLimit)) || (OpsAbs (AdaptiveTorqueX) < AdaptiveXLimit)) {
    *DerAdaptiveTorqueX = DerAdaptive[0];
  } else {
    *DerAdaptiveTorqueX = 0;
  }

  if (((AdaptiveFlagY <= 0) && (OpsAbs(AdaptiveTorqueY) == AdaptiveYLimit)) || (OpsAbs (AdaptiveTorqueY) < AdaptiveYLimit)) {
    *DerAdaptiveTorqueY = DerAdaptive[1];
  } else {
    *DerAdaptiveTorqueY = 0;
  }

  if (((AdaptiveFlagZ <= 0) && (OpsAbs(AdaptiveTorqueZ) == AdaptiveZLimit)) || (OpsAbs (AdaptiveTorqueZ) < AdaptiveZLimit)) {
    *DerAdaptiveTorqueZ = DerAdaptive[2];
  } else {
    *DerAdaptiveTorqueZ = 0;
  }

  return 0;
}

//
STATUS GC_LA (const DECIMAL Ramp, const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *AdaptiveX, DECIMAL* AdaptiveY, DECIMAL *AdaptiveZ, DECIMAL AdaptiveLateralControl[3]) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;
  const INTEGER AdaptiveLateralFlag = Config.AdaptiveLateralFlag;
  const DECIMAL AdaptiveXInit = Config.AdaptiveXInit;
  const DECIMAL AdaptiveXLimit = Config.AdaptiveXLimit;
  const DECIMAL AdaptiveXLimitLow = Config.AdaptiveXLimitLow;
  const DECIMAL AdaptiveYInit = Config.AdaptiveYInit;
  const DECIMAL AdaptiveYLimit = Config.AdaptiveYLimit;
  const DECIMAL AdaptiveYLimitLow = Config.AdaptiveYLimitLow;
  const DECIMAL AdaptiveZInit = Config.AdaptiveZInit;
  const DECIMAL AdaptiveZLimit = Config.AdaptiveZLimit;
  const DECIMAL AdaptiveZLimitLow = Config.AdaptiveZLimitLow;

  static INTEGER First = 1;
  static DECIMAL X, Y, Z;
  if (First != 0) {
    X = AdaptiveXInit;
    Y = AdaptiveYInit;
    Z = AdaptiveZInit;
    First = 0;
  }

  DECIMAL DerAdaptiveTorqueX;
  DECIMAL DerAdaptiveTorqueY;
  DECIMAL DerAdaptiveTorqueZ;

  GC_LA_AC (X, Y, Z, EX, EV, AdaptiveGainLimit, &DerAdaptiveTorqueX, &DerAdaptiveTorqueY, &DerAdaptiveTorqueZ);

  MathSat1 (X + Ramp * DerAdaptiveTorqueX / SamplingF, AdaptiveXLimit, AdaptiveXLimitLow, 1.0, &X);
  MathSat1 (Y + Ramp * DerAdaptiveTorqueY / SamplingF, AdaptiveYLimit, AdaptiveYLimitLow, 1.0, &Y);
  MathSat1 (Z + Ramp * DerAdaptiveTorqueZ / SamplingF, AdaptiveZLimit, AdaptiveZLimitLow, 1.0, &Z);
  
  if (AdaptiveLateralFlag > 0) {
    *AdaptiveX = X;
    *AdaptiveY = Y;
    *AdaptiveZ = Z;
  } else {
    *AdaptiveX = 0;
    *AdaptiveY = 0;
    *AdaptiveZ = 0;
  }

  AdaptiveLateralControl[0] = X;
  AdaptiveLateralControl[1] = Y;
  AdaptiveLateralControl[2] = Z;

  return 0;
}

//
STATUS GC_FUNC (const DECIMAL R[9], const DECIMAL RDesired[3], const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL OmegaDotDesired[3], const DECIMAL ADesired[3], const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL ControlGain[7], const DECIMAL AdaptiveRoll, const DECIMAL AdaptivePitch, const DECIMAL AdaptiveYaw, const DECIMAL AdaptiveX, const DECIMAL AdaptiveY, const DECIMAL AdaptiveZ, DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired) { // CHECK
  INTEGER i;

  const DECIMAL *IMomentVec = Config.IMomentVec;
  const DECIMAL M = Config.M;
  const DECIMAL G = Config.G;

  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);
  DECIMAL RotDesired[3 * 3];
  MathMatrix3 (RDesired, RotDesired);

  DECIMAL KX = ControlGain[0];
  DECIMAL KV = ControlGain[1];
  DECIMAL KR = ControlGain[2];
  DECIMAL KOmega = ControlGain[3];
  DECIMAL KZ = ControlGain[4];
  DECIMAL KVZ = ControlGain[5];
  DECIMAL KRX = ControlGain[6];

  DECIMAL E3[3] = { 0, 0, 1.0 };
  DECIMAL IMoment[3 * 3] = { 0 };
  for (i = 0; i < 3; ++i) {
    IMoment[i * 3 + i] = IMomentVec[i];
  }

  DECIMAL WHat[3 * 3] = { 0 };
  WHat[3 * 0 + 1] = -Omega[2];
  WHat[3 * 1 + 0] = Omega[2];
  WHat[3 * 0 + 2] = Omega[1];
  WHat[3 * 2 + 0] = -Omega[1];
  WHat[3 * 1 + 2] = -Omega[0];
  WHat[3 * 2 + 1] = Omega[0];

  DECIMAL XK[3] = { KX, KX, KZ };
  DECIMAL VK[3] = { KV, KV, KVZ };
  DECIMAL RK[3] = { KRX, KR, KR };

  DECIMAL Tmp31[3 * 3];
  MathMultiplyM3 (WHat, IMoment, Tmp31);
  DECIMAL Tmp32[3];
  MathMultiplyM3V3 (Tmp31, Omega, Tmp32);

  DECIMAL TransposeRot[3 * 3];
  MathTranspose3 (Rot, TransposeRot);


  DECIMAL Tmp41[3 * 3];
  MathMultiplyM3 (WHat, TransposeRot, Tmp41);
  DECIMAL Tmp42[3 * 3];
  MathMultiplyM3 (Tmp41, RotDesired, Tmp42);
  DECIMAL Tmp43[3];
  MathMultiplyM3V3 (Tmp42, OmegaDesired, Tmp43);

  DECIMAL Tmp44[3 * 3];
  MathMultiplyM3 (TransposeRot, RotDesired, Tmp44);
  DECIMAL Tmp45[3];
  MathMultiplyM3V3 (Tmp44, OmegaDotDesired, Tmp45);

  DECIMAL Tmp46[3];
  for (i = 0; i < 3; ++i) {
    Tmp46[i] = Tmp43[i] - Tmp45[i];
  }
  DECIMAL Tmp47[3];
  MathMultiplyM3V3 (IMoment, Tmp46, Tmp47);

  DECIMAL MVec[3];
  for (i = 0; i < 3; ++i) {
    MVec[i] = -RK[i] * ER[i] - KOmega * EOmega[i] + Tmp32[i] - Tmp47[i];
  }


  *RollTorqueDesired = MVec[0] - AdaptiveRoll;
  *PitchTorqueDesired = MVec[1] - AdaptivePitch;
  *YawTorqueDesired = MVec[2] / 6.0 - AdaptiveYaw;

  DECIMAL AdaptiveLateral[3] = { AdaptiveX, AdaptiveY, AdaptiveZ };
  DECIMAL Tmp51[3];
  for (i = 0; i < 3; ++i) {
    Tmp51[i] = -XK[i] * EX[i] - VK[i] * EV[i] - AdaptiveLateral[i] + M * G * E3[i] + M * ADesired[i];
  }

  DECIMAL Tmp52[3];
  MathMultiplyV3M3 (Tmp51, Rot, Tmp52);
  MathDot3 (Tmp52, E3, ThrustDesired);

  if (*ThrustDesired >= 1.2E-3) {
    *ThrustDesired = 1.2E-3;
  } else if (*ThrustDesired <= 0.5E-3) {
    *ThrustDesired = 0.5E-3;
  }

  if (*RollTorqueDesired >= 0.25E-6) {
    *RollTorqueDesired = 0.25E-6;
  } else if (*RollTorqueDesired <= -0.25E-6) {
    *RollTorqueDesired = -0.25E-6;
  }

  if (*PitchTorqueDesired >= 0.2E-6) {
    *PitchTorqueDesired = 0.2E-6;
  } else if (*PitchTorqueDesired <= -0.2E-6) {
    *PitchTorqueDesired = -0.2E-6;
  }

  if (*YawTorqueDesired >= 0.4E-7) {
    *YawTorqueDesired = 0.4E-7;
  } else if (*YawTorqueDesired <= -1.0E-7) {
    *YawTorqueDesired = -1.0E-7;
  }

  return 0;
}

//
STATUS GC_CONTROL (const DECIMAL Ramp, const DECIMAL R[9], const DECIMAL RDesired[3], const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL OmegaDotDesired[3], const DECIMAL ADesired[3], const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL ControlGain[7], const DECIMAL AdaptiveRoll, const DECIMAL AdaptivePitch, const DECIMAL AdaptiveYaw, const DECIMAL AdaptiveX, const DECIMAL AdaptiveY, const DECIMAL AdaptiveZ, DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired) { // CHECK
  GC_FUNC (R, RDesired, Omega, OmegaDesired, OmegaDotDesired, ADesired, EX, EV, ER, EOmega, ControlGain, AdaptiveRoll, AdaptivePitch, AdaptiveYaw, AdaptiveX, AdaptiveY, AdaptiveZ, ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired);

  *ThrustDesired = Ramp * (*ThrustDesired);
  *RollTorqueDesired = Ramp * (*RollTorqueDesired);
  *PitchTorqueDesired = Ramp * (*PitchTorqueDesired);
  *YawTorqueDesired = Ramp * (*YawTorqueDesired);

  return 0;
}

//
STATUS GC_AA_AC (const DECIMAL CurrentAdaptiveRoll, const DECIMAL CurrentAdaptivePitch, const DECIMAL CurrentAdaptiveYaw, const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *DerAdaptiveTorqueRoll, DECIMAL *DerAdaptiveTorquePitch, DECIMAL *DerAdaptiveTorqueYaw) { // CHECK
  DECIMAL AdaptiveTorqueRoll = CurrentAdaptiveRoll;
  DECIMAL AdaptiveTorquePitch = CurrentAdaptivePitch;
  DECIMAL AdaptiveTorqueYaw = CurrentAdaptiveYaw;

  DECIMAL GammaAttitudeAdaptive = AdaptiveGainLimit[0];
  DECIMAL AdaptiveRollLimit = AdaptiveGainLimit[1];
  DECIMAL AdaptivePitchLimit = AdaptiveGainLimit[2];
  DECIMAL AdaptiveYawLimit = AdaptiveGainLimit[3];
  DECIMAL C2 = AdaptiveGainLimit[4];

  DECIMAL AdaptiveFlagRoll = AdaptiveTorqueRoll * (EOmega[0] + C2 * ER[0]);
  DECIMAL AdaptiveFlagPitch = AdaptiveTorquePitch * (EOmega[1] + C2 * ER[1]);
  DECIMAL AdaptiveFlagYaw = AdaptiveTorqueYaw * (EOmega[2] + C2 * ER[2]);

  DECIMAL DerAdaptive[3];
  for (INTEGER i = 0; i < 3; ++i) {
    DerAdaptive[i] = GammaAttitudeAdaptive * (EOmega[i] + C2 * ER[i]);
  }

  if (((AdaptiveFlagRoll <= 0) && (OpsAbs (AdaptiveTorqueRoll) == AdaptiveRollLimit)) || (OpsAbs (AdaptiveTorqueRoll) < AdaptiveRollLimit)) {
    *DerAdaptiveTorqueRoll = DerAdaptive[0];
  } else {
    *DerAdaptiveTorqueRoll = 0;
  }

  if (((AdaptiveFlagPitch <= 0) && (OpsAbs (AdaptiveTorquePitch) == AdaptivePitchLimit)) || (OpsAbs (AdaptiveTorquePitch) < AdaptivePitchLimit)) {
    *DerAdaptiveTorquePitch = DerAdaptive[1];
  } else {
    *DerAdaptiveTorquePitch = 0;
  }

  if (((AdaptiveFlagYaw <= 0) && (OpsAbs (AdaptiveTorqueYaw) == AdaptiveYawLimit)) || (OpsAbs (AdaptiveTorqueYaw) < AdaptiveYawLimit)) {
    *DerAdaptiveTorqueYaw = DerAdaptive[2];
  } else {
    *DerAdaptiveTorqueYaw = 0;
  }

  return 0;
}

//
STATUS GC_AA (const DECIMAL Ramp, const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *AdaptiveRoll, DECIMAL *AdaptivePitch, DECIMAL *AdaptiveYaw, DECIMAL AdaptiveAttitudeControl[3]) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;
  const INTEGER AdaptiveFlag = Config.AdaptiveFlag;
  const DECIMAL AdaptiveRollInit = Config.AdaptiveRollInit;
  const DECIMAL AdaptiveRollLimit = Config.AdaptiveRollLimit;
  const DECIMAL AdaptiveRollLimitLow = Config.AdaptiveRollLimitLow;
  const DECIMAL AdaptivePitchInit = Config.AdaptivePitchInit;
  const DECIMAL AdaptivePitchLimit = Config.AdaptivePitchLimit;
  const DECIMAL AdaptivePitchLimitLow = Config.AdaptivePitchLimitLow;
  const DECIMAL AdaptiveYawInit = Config.AdaptiveYawInit;
  const DECIMAL AdaptiveYawLimit = Config.AdaptiveYawLimit;
  const DECIMAL AdaptiveYawLimitLow = Config.AdaptiveYawLimitLow;

  static INTEGER First = 1;
  static DECIMAL Roll, Pitch, Yaw;
  if (First != 0) {
    Roll = AdaptiveRollInit;
    Pitch = AdaptivePitchInit;
    Yaw = AdaptiveYawInit;

    First = 0;
  }

  DECIMAL DerAdaptiveTorqueRoll;
  DECIMAL DerAdaptiveTorquePitch;
  DECIMAL DerAdaptiveTorqueYaw;

  GC_AA_AC (Roll, Pitch, Yaw, ER, EOmega, AdaptiveGainLimit, &DerAdaptiveTorqueRoll, &DerAdaptiveTorquePitch, &DerAdaptiveTorqueYaw);

  // TODO: Check MathSat1 Arguments Is 1 a Decimal
  MathSat1 (Roll + Ramp * DerAdaptiveTorqueRoll / SamplingF, AdaptiveRollLimit, AdaptiveRollLimitLow, 1.0, &Roll);
  MathSat1 (Pitch + Ramp * DerAdaptiveTorquePitch / SamplingF, AdaptivePitchLimit, AdaptivePitchLimitLow, 1.0, &Pitch);
  MathSat1 (Yaw + Ramp * DerAdaptiveTorqueYaw / SamplingF, AdaptiveYawLimit, AdaptiveYawLimitLow, 1.0, &Yaw);

  if (AdaptiveFlag > 0) {
    *AdaptiveRoll = Roll;
    *AdaptivePitch = Pitch;
    *AdaptiveYaw = Yaw;
  } else {
    *AdaptiveRoll = 0;
    *AdaptivePitch = 0;
    *AdaptiveYaw = 0;
  }

  AdaptiveAttitudeControl[0] = Roll;
  AdaptiveAttitudeControl[1] = Pitch;
  AdaptiveAttitudeControl[2] = Yaw;

  return 0;
}

//
STATUS GC (const DECIMAL R[9], const DECIMAL RDesired[9], const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL OmegaDotDesired[3], const DECIMAL ADesired[3], const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL Ramp, DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired, DECIMAL AdaptiveAttitudeOutput[3], DECIMAL AdaptiveLateralOutput[3]) { // CHECK
  const DECIMAL *ControlGain = Config.ControlGain;
  const DECIMAL *AdaptiveGainLimit = Config.AdaptiveGain;

  DECIMAL AdaptiveX, AdaptiveY, AdaptiveZ;
  DECIMAL AdaptiveRoll, AdaptivePitch, AdaptiveYaw;
  GC_AA (Ramp, ER, EOmega, AdaptiveGainLimit, &AdaptiveRoll, &AdaptivePitch, &AdaptiveYaw, AdaptiveAttitudeOutput);
  
  GC_LA (Ramp, EX, EV, AdaptiveGainLimit, &AdaptiveX, &AdaptiveY, &AdaptiveZ, AdaptiveLateralOutput); 

  GC_CONTROL (Ramp, R, RDesired, Omega, OmegaDesired, OmegaDotDesired, ADesired, EX, EV, ER, EOmega, ControlGain, AdaptiveRoll, AdaptivePitch, AdaptiveYaw, AdaptiveX, AdaptiveY, AdaptiveZ, ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired);

  return 0;
}

//
STATUS CONTROL (const INTEGER Update, const INTEGER Count, const DECIMAL P[3], const DECIMAL V[3], const DECIMAL R[9], const DECIMAL Omega[3], const DECIMAL PDesired[3], const DECIMAL VDesired[3], const DECIMAL ADesired[3], const DECIMAL B1D[3], DECIMAL Ramp, DECIMAL RDesired[9], DECIMAL OmegaDesired[3], DECIMAL OmegaDotDesired[3], DECIMAL EP[3], DECIMAL EV[3], DECIMAL ER[3], DECIMAL EOmega[3], DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired, DECIMAL AdaptiveAttitudeOutput[3], DECIMAL AdaptiveLateralOutput[3]) { // CHECK
  static DECIMAL AdaptiveLateralControl[3] = { 0 };

  DAANE (Update, Count, P, V, R, Omega, PDesired, VDesired, ADesired, B1D, AdaptiveLateralControl, RDesired, OmegaDesired, OmegaDotDesired, EP, EV, ER, EOmega);

  GC (R, RDesired, Omega, OmegaDesired, OmegaDotDesired, ADesired, EP, EV, ER, EOmega, Ramp, ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired, AdaptiveAttitudeOutput, AdaptiveLateralOutput);

  MathCopyV3 (AdaptiveLateralOutput, AdaptiveLateralControl);

  return 0;
}

//
STATUS FTVFunc (const DECIMAL ThrustDesired, const DECIMAL RollTorqueDesired, const DECIMAL PitchTorqueDesired, const DECIMAL YawTorqueDesired, DECIMAL *DrvAmp, DECIMAL *DrvPitchLeft, DECIMAL *DrvPitchRight, DECIMAL *DrvRoll, DECIMAL *A2Coeff) { // CHECK
  const DECIMAL A2UB = Config.A2UB;
  const DECIMAL A2LB = Config.A2LB;
  const DECIMAL *ParamsVec = Config.ParamsVec;

  DECIMAL Delta1 = ParamsVec[0];
  DECIMAL Delta2 = ParamsVec[1];
  DECIMAL Delta3 = ParamsVec[2];
  DECIMAL Gamma1 = ParamsVec[3];
  DECIMAL Gamma2 = ParamsVec[4];
  DECIMAL Gamma3 = ParamsVec[5];
  DECIMAL Eta = ParamsVec[6];
  DECIMAL Nu = ParamsVec[7];
  DECIMAL Mu = ParamsVec[8];

  DECIMAL U4;
  if (ThrustDesired == 0) {
    U4 = 0;
  } else {
    U4 = PitchTorqueDesired / (ThrustDesired * Delta3 * Gamma2) - Nu;
  }

  DECIMAL U3;
  DECIMAL LB, UB, Tmp1, Tmp2;
  if (OpsAbs (YawTorqueDesired) < 1.0E-12) {
    U3 = -Mu;
  } else {
    LB = (ThrustDesired / 2.0) * (Gamma2 * Gamma3 * Delta2 * Mu / Delta1 - OpsSqrt (OpsPow (Gamma2 * Gamma3 * Delta2 * ThrustDesired * Mu / Delta1, 2.0) + Gamma2 * Gamma3));
    UB = (ThrustDesired / 2.0) * (Gamma2 * Gamma3 * Delta2 * Mu / Delta1 + OpsSqrt (OpsPow (Gamma2 * Gamma3 * Delta2 * ThrustDesired * Mu / Delta1, 2.0) + Gamma2 * Gamma3));

    MathSat1 (YawTorqueDesired, UB, LB, 1.0, &Tmp1);

    Tmp2 = OpsPow (Gamma2 * Gamma3 * ThrustDesired, 2.0) - 4.0 * Tmp1 * (Tmp1 - Gamma2 * Gamma3 * Delta2 * ThrustDesired * Mu / Delta1);
    if (Tmp2 < 0) {
      Tmp2 = 0;
    }
    U3 = Delta1 * (Gamma2 * Gamma3 * ThrustDesired - OpsSqrt (Tmp2)) / (2.0 * Delta2 * Tmp1);
  }

  DECIMAL D = OpsPow (Delta1, 2.0) + OpsPow (Delta2, 2.0) * OpsPow (U3, 2.0);
  DECIMAL U1 = (Gamma2 * ThrustDesired + RollTorqueDesired) / (2.0 * Gamma1 * Gamma2 * D * Eta);
  if (U1 < 0) {
    U1 = 0;
  }
  DECIMAL U2 = (Gamma2 * ThrustDesired - RollTorqueDesired) / (2.0 * Gamma1 * Gamma2 * D);
  if (U2 < 0) {
    U2 = 0;
  }

  DECIMAL VLeftP2P = OpsSqrt (U1) * 2.0;
  DECIMAL VRightP2P = OpsSqrt (U2) * 2.0;
  
  DECIMAL VLeftPitch = U4;
  DECIMAL VRightPitch = U4;

  *DrvAmp = OpsAbs (VLeftP2P - VRightP2P) / 2.0 + OpsMin (VLeftP2P, VRightP2P);
  *DrvPitchLeft = VLeftPitch;
  *DrvPitchRight = VRightPitch;
  *DrvRoll = (VLeftP2P - VRightP2P) / 4.0;
  MathSat1 (U3, A2UB, A2LB, 1.0, A2Coeff);
  return 0;
}

//
STATUS FTV (const DECIMAL ThrustDesired, const DECIMAL RollTorqueDesired, const DECIMAL PitchTorqueDesired, const DECIMAL YawTorqueDesired, DECIMAL Output[5]) { // CHECK
  return FTVFunc (ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired,&Output[0], &Output[1], &Output[2], &Output[3], &Output[4]);
}

//
STATUS OCLS_RAMP (const DECIMAL T, DECIMAL *Z) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;
  const DECIMAL RampDelay = Config.RampDelay;
  const DECIMAL StartDelayControl = Config.StartDelayControl;
  const DECIMAL RunningTimeControl = Config.RunningTimeControl;

  static DECIMAL Y = 0;

  DECIMAL Der;
  if ((T < RunningTimeControl) && (T > StartDelayControl)) {
    Der = 1.0;
  } else {
    Der = -1.0;
  }

  Y = Y + 1.0 / (SamplingF * RampDelay) * Der;
  if (Y < 0) {
    Y = 0;
  } else if (Y > 1.0) {
    Y = 1.0;
  }
  *Z = Y;

  return 0;
}

//
STATUS OCLS_FUNC (const DECIMAL OpenLoopControl[5], const DECIMAL ClosedLoopControl[5], DECIMAL Y[5]) { // CHECK
  const INTEGER ClosedLoopFlag = Config.ClosedLoopFlag;

  const DECIMAL *X;
  if (ClosedLoopFlag == 1) {
    X = ClosedLoopControl;
  } else {
    X = OpenLoopControl;
  }

  for (INTEGER i = 0; i < 5; ++i) {
    Y[i] = X[i];
  }

  return 0;
}

//
STATUS OCLS_FREQ (const DECIMAL T, DECIMAL *Output) { // Check
  const DECIMAL F = Config.F;
  const DECIMAL FInt = Config.FInt;
  const DECIMAL FFin = Config.FFin;
  const DECIMAL Tc = Config.T;

  DECIMAL Freq = FInt;
  DECIMAL BufferT = 0;
  DECIMAL RelTime = T - BufferT;
  if (RelTime > 0) {
    Freq += (FFin - FInt) * (RelTime / Tc);
  }

  if (Freq > FFin) {
    Freq = FFin;
  }

  *Output = Freq;

  return 0;
}

//
STATUS OCLS_ENABLE (const DECIMAL T, INTEGER *Y) { // CHECK
  const DECIMAL StartDelay = Config.StartDelay;
  const DECIMAL RunningTime = Config.RunningTime;

  if ((T < RunningTime) && (T > StartDelay)) {
    *Y = 1;
  } else {
    *Y = 0;
  }

  return 0;
}

//
STATUS OCLS_CONTROL (INTEGER *Enable, DECIMAL *Ramp, DECIMAL *Time, DECIMAL *Freq) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;

  static INTEGER N = 0;
  DECIMAL T = ((DECIMAL) N) / SamplingF;
  *Time = T;
  OCLS_ENABLE (T, Enable);
  OCLS_RAMP (T, Ramp);
  OCLS_FREQ (T, Freq);

  N = N + 1;

  return 0;
}

//
STATUS OCLS (const DECIMAL OpenLoopControl[5], const DECIMAL ClosedLoopControl[5], INTEGER *Enable, DECIMAL *Ramp, DECIMAL *Time, DECIMAL *Freq, DECIMAL *DrvAmp, DECIMAL *DrvPitchLeft, DECIMAL *DrvPitchRight, DECIMAL *DrvRoll, DECIMAL *A2Out) { // CHECK
  OCLS_CONTROL (Enable, Ramp, Time, Freq);
  DECIMAL Y[5];
  OCLS_FUNC (OpenLoopControl, ClosedLoopControl, Y);

  *DrvAmp = Y[0] * (*Ramp);
  *DrvPitchLeft = Y[1] * (*Ramp);
  *DrvPitchRight = Y[2] * (*Ramp);
  *DrvRoll = Y[3] * (*Ramp);
  *A2Out = Y[4] * (*Ramp);

  return 0;
}

//
STATUS SG_DS_FS (const DECIMAL Time, const DECIMAL Freq, const DECIMAL Phase, const DECIMAL A2, DECIMAL *Output) { // Check
  const DECIMAL Pi = CONST_PI;

  DECIMAL Theta = Freq * 2.0 * Pi * Time;
  *Output = 1.1 * OpsSin (Theta + Phase) + A2 * OpsSin (2.0 * Theta + Phase) + 0.1 * OpsSin (3.0 * Theta + Phase);

  return 0;
}

//
STATUS SG_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL AmplRaw, const DECIMAL AmplPrev, const DECIMAL OffRaw, const DECIMAL OffPrev, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL A2Prev, const DECIMAL Phase, DECIMAL *Norm, DECIMAL *AmplCur, DECIMAL *OffCur, DECIMAL *A2Cur) { // CHECK
  const DECIMAL PreGain = 1.0;
  *A2Cur = 0.95 * A2Prev + 0.05 * A2;
  DECIMAL Running;
  if (Ramp > 0) {
    Running = 1.0;
  } else {
    Running = 0.0;
  }
  SG_DS_FS (Time, Freq * Running, Phase * Running, *A2Cur, Norm);

  DECIMAL AmplNew = PreGain * AmplRaw;
  *AmplCur = 0.95 * AmplPrev + 0.05 * AmplNew;

  DECIMAL OffNew = PreGain * (OffRaw + PitchBias);
  *OffCur = 0.95 * OffPrev + 0.05 * OffNew;

  return 0;
}

STATUS SG2_DS_FS (const DECIMAL Time, const DECIMAL Freq, const DECIMAL Phase, const DECIMAL A2, const DECIMAL Ampl, const DECIMAL Offset, DECIMAL *Output, DECIMAL SignalBuffer[SIG_BUF_SIZE]) { // Check
  const DECIMAL Pi = CONST_PI;

  DECIMAL Theta = Freq * 2.0 * Pi * Time;
  *Output = 1.1 * OpsSin (Theta + Phase) + A2 * OpsSin (2.0 * Theta + Phase) + 0.1 * OpsSin (3.0 * Theta + Phase);

	for (INTEGER i = 0; i < SIG_BUF_SIZE; ++i) {
		SignalBuffer[i] = 1.1 * OpsSin ((2.0 * Pi * i) / ((DECIMAL) SIG_BUF_SIZE));
		SignalBuffer[i] = SignalBuffer[i] + A2 * OpsSin ((4.0 * Pi * i) / ((DECIMAL) SIG_BUF_SIZE));
		SignalBuffer[i] = SignalBuffer[i] + 0.1 * OpsSin ((6.0 * Pi * i) / ((DECIMAL) SIG_BUF_SIZE));
		SignalBuffer[i] = Ampl * SignalBuffer[i] + Offset;
	}
  return 0;
}

//
STATUS SG2_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL AmplRaw, const DECIMAL AmplPrev, const DECIMAL OffRaw, const DECIMAL OffPrev, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL A2Prev, const DECIMAL Phase, DECIMAL *Norm, DECIMAL *AmplCur, DECIMAL *OffCur, DECIMAL *A2Cur, DECIMAL SignalBuffer[SIG_BUF_SIZE]) { // CHECK
  const DECIMAL PreGain = 1.0;
  *A2Cur = 0.95 * A2Prev + 0.05 * A2;
  DECIMAL Running;
  if (Ramp > 0) {
    Running = 1.0;
  } else {
    Running = 0.0;
  }

  DECIMAL AmplNew = PreGain * AmplRaw;
  *AmplCur = 0.95 * AmplPrev + 0.05 * AmplNew;

  DECIMAL OffNew = PreGain * (OffRaw + PitchBias);
  *OffCur = 0.95 * OffPrev + 0.05 * OffNew;
  
	SG2_DS_FS (Time, Freq * Running, Phase * Running, *A2Cur, *AmplCur, *OffCur, Norm, SignalBuffer);

  return 0;
}

//
STATUS SG2_SSL (const DECIMAL Max, const DECIMAL Signal, const DECIMAL PostGain, DECIMAL *Output, DECIMAL SignalBuffer[SIG_BUF_SIZE]) { // CHECK
  const DECIMAL Min = 1.0;

  *Output = Signal;
  if (*Output > Max) {
    *Output = Max;
  } else if (*Output < Min) {
    *Output = Min;
  }

	// Addition
	for (INTEGER i = 0; i < SIG_BUF_SIZE; ++i) {
		if (SignalBuffer[i] > Max) {
			SignalBuffer[i] = Max;
		} else if (SignalBuffer[i] < Min) {
			SignalBuffer[i] = Min;
		}
		SignalBuffer[i] = SignalBuffer[i] * PostGain;
	}

  return 0;
}


//
STATUS SG_SSL (const DECIMAL Max, const DECIMAL Signal, DECIMAL *Output) { // CHECK
  const DECIMAL Min = 1.0;

  *Output = Signal;
  if (*Output > Max) {
    *Output = Max;
  } else if (*Output < Min) {
    *Output = Min;
  }

  return 0;
}

//
STATUS SG1_TIME (const DECIMAL Ramp, DECIMAL *Time) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;
  static INTEGER N = 0;

  *Time = ((DECIMAL) N) / ((DECIMAL) SamplingF);
  if (Ramp > 0) {
    N = N + 1;
  }

  return 0;
}

//
STATUS SG1_BS (const DECIMAL Ramp, const DECIMAL VoltNew, DECIMAL *VoltCur) { // CHECK
  static DECIMAL VoltPrev = 0;
  DECIMAL Tmp = VoltPrev * 0.95 + VoltNew * 0.05;
  *VoltCur = Tmp * Ramp;
  VoltPrev = Tmp;

  return 0;
}

//
STATUS SG1_RAMP (const INTEGER Enable, DECIMAL *Ramp) { // Check
  const DECIMAL SamplingF = Config.SamplingF;
  const DECIMAL RampDelay = Config.RampDelay;

  static DECIMAL RampPrev = 0;

  DECIMAL Der;
  if (Enable == 1) {
    Der = 1.0;
  } else {
    Der = -1.0;
  }

  *Ramp = RampPrev + 1.0 / (SamplingF * RampDelay) * Der;
  if (*Ramp < 0) {
    *Ramp = 0;
  } else if (*Ramp > 1.0) {
    *Ramp = 1.0;
  }

  RampPrev = *Ramp;
  return 0;
}

//
STATUS SG1_D1_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output) { // CHECK
  static DECIMAL AmplPrev = 0;
  static DECIMAL OffPrev = 0;
  static DECIMAL A2Prev = 0;

  DECIMAL Norm, AmplCur, OffCur, A2Cur;
  SG_DS (Time, Ramp, Freq, Amplitude, AmplPrev, Offset, OffPrev, PitchBias, A2, A2Prev, Phase, &Norm, &AmplCur, &OffCur, &A2Cur);
  AmplPrev = AmplCur;
  OffPrev = OffCur;
  A2Prev = A2Cur;

  DECIMAL Base = Norm * AmplCur;
  DECIMAL DC = OffCur;
  
  *Output = Ramp * (Base + DC);

  return 0;
}

//
STATUS SG1_D2_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output) { // Check
  static DECIMAL AmplPrev = 0;
  static DECIMAL OffPrev = 0;
  static DECIMAL A2Prev = 0;

  DECIMAL Norm, AmplCur, OffCur, A2Cur;
  SG_DS (Time, Ramp, Freq, Amplitude, AmplPrev, Offset, OffPrev, PitchBias, A2, A2Prev, Phase, &Norm, &AmplCur, &OffCur, &A2Cur);
  AmplPrev = AmplCur;
  OffPrev = OffCur;
  A2Prev = A2Cur;

  DECIMAL Base = Norm * AmplCur;
  DECIMAL DC = OffCur;

  *Output = Ramp * (Base + DC);

  return 0;
}

//
STATUS SG1 (const INTEGER Enable, const DECIMAL Bias, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL PitchBiasLeft, const DECIMAL PitchBiasRight, const DECIMAL RollBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A) { // CHECK
  const DECIMAL PostGain = 0.01;

  DECIMAL Ramp;
  SG1_RAMP (Enable, &Ramp);
  DECIMAL Time;
  SG1_TIME (Ramp, &Time);

  DECIMAL TmpBias;
  SG1_BS (Ramp, Bias, &TmpBias);
  *BiasD2A = PostGain * TmpBias;

  DECIMAL AmplLeft = Amplitude / 2.0 + RollBias;
  DECIMAL AmplRight = Amplitude / 2.0 - RollBias;
  DECIMAL Offset = Bias / 2.0;
  
  DECIMAL TmpLeft;
  SG1_D1_DS (Time, Ramp, Freq, AmplLeft, Offset, PitchBiasLeft, A2, Phase, &TmpLeft);
  DECIMAL TmpRight;
  SG1_D2_DS (Time, Ramp, Freq, AmplRight, Offset, PitchBiasRight, -A2, 0, &TmpRight);

  SG_SSL (TmpBias, TmpLeft, LeftD2A);
  *LeftD2A = PostGain * (*LeftD2A);
  SG_SSL (TmpBias, TmpRight, RightD2A);
  *RightD2A = PostGain * (*RightD2A);

  return 0;
}

//
STATUS SG2_TIME (const DECIMAL Ramp, DECIMAL *Time) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;

  static INTEGER N = 0;

  *Time = (DECIMAL) N / (DECIMAL) SamplingF;
  if (Ramp > 0) {
    N = N + 1;
  }

  return 0;
}

//
STATUS SG2_BS (const DECIMAL Ramp, const DECIMAL VoltNew, DECIMAL *VoltCur) { // CHECK
  static DECIMAL VoltPrev = 0;

  DECIMAL Tmp = VoltPrev * 0.95 + VoltNew * 0.05;
  *VoltCur = Tmp * Ramp;
  VoltPrev = Tmp;

  return 0;
}

//
STATUS SG2_RAMP (const INTEGER Enable, DECIMAL *Ramp) { // CHECK
  const DECIMAL SamplingF = Config.SamplingF;
  const DECIMAL RampDelay = Config.RampDelay;

  static DECIMAL RampPrev = 0;

  DECIMAL Der;
  if (Enable == 1) {
    Der = 1.0;
  } else {
    Der = -1.0;
  }

  *Ramp = RampPrev + 1.0 / (SamplingF * RampDelay) * Der;
  if (*Ramp < 0.0) {
    *Ramp = 0;
  } else if (*Ramp > 1.0) {
    *Ramp = 1.0;
  }

  RampPrev = *Ramp;

  return 0;
}

//
STATUS SG2_D1_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output, DECIMAL SignalBuffer[SIG_BUF_SIZE]) { // CHECK
  static DECIMAL AmplPrev = 0;
  static DECIMAL OffPrev = 0;
  static DECIMAL A2Prev = 0;

  DECIMAL Norm, AmplCur, OffCur, A2Cur;
  SG2_DS (Time, Ramp, Freq, Amplitude, AmplPrev, Offset, OffPrev, PitchBias, A2, A2Prev, Phase, &Norm, &AmplCur, &OffCur, &A2Cur, SignalBuffer);
  AmplPrev = AmplCur;
  OffPrev = OffCur;
  A2Prev = A2Cur;

  DECIMAL Base = Norm * AmplCur;
  DECIMAL DC = OffCur;

  *Output = Ramp * (Base + DC);

  return 0;
}

//
STATUS SG2_D2_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output, DECIMAL SignalBuffer[SIG_BUF_SIZE]) { // CHECK
  static DECIMAL AmplPrev = 0;
  static DECIMAL OffPrev = 0;
  static DECIMAL A2Prev = 0;

  DECIMAL Norm, AmplCur, OffCur, A2Cur;
  SG2_DS (Time, Ramp, Freq, Amplitude, AmplPrev, Offset, OffPrev, PitchBias, A2, A2Prev, Phase, &Norm, &AmplCur, &OffCur, &A2Cur, SignalBuffer);
  AmplPrev = AmplCur;
  OffPrev = OffCur;
  A2Prev = A2Cur;

  DECIMAL Base = Norm * AmplCur;
  DECIMAL DC = OffCur;

  *Output = Ramp * (Base + DC);

  return 0;
}

/*
//
STATUS SG2 (const INTEGER Enable, const DECIMAL Bias, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL PitchBiasLeft, const DECIMAL PitchBiasRight, const DECIMAL RollBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A) { // CHECK
  const DECIMAL PostGain = 0.01;

  DECIMAL Ramp;
  SG2_RAMP (Enable, &Ramp);
  DECIMAL Time;
  SG2_TIME (Ramp, &Time);

  DECIMAL TmpBias;
  SG2_BS (Ramp, Bias, &TmpBias);
  *BiasD2A = PostGain * TmpBias;

  DECIMAL AmplLeft = Amplitude / 2.0 + RollBias;
  DECIMAL AmplRight = Amplitude / 2.0 - RollBias;
  DECIMAL Offset = Bias / 2.0;

  DECIMAL TmpLeft;
  SG2_D1_DS (Time, Ramp, Freq, AmplLeft, Offset, PitchBiasLeft, A2, Phase, &TmpLeft);
  DECIMAL TmpRight;
  SG2_D2_DS (Time, Ramp, Freq, AmplRight, Offset, PitchBiasRight, -A2, 0, &TmpRight);

  SG_SSL (TmpBias, TmpLeft, LeftD2A);
  *LeftD2A = PostGain * (*LeftD2A);
  SG_SSL (TmpBias, TmpRight, RightD2A);
  *RightD2A = PostGain * (*RightD2A);

  return 0;
}
*/

STATUS SignalBufferGenerator (const INTEGER Enable, const DECIMAL Bias, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL PitchBiasLeft, const DECIMAL PitchBiasRight, const DECIMAL RollBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A, DECIMAL BufferLeft[SIG_BUF_SIZE], DECIMAL BufferRight[SIG_BUF_SIZE]) {
  const DECIMAL PostGain = 0.01;

  DECIMAL Ramp;
  SG2_RAMP (Enable, &Ramp);
  DECIMAL Time;
  SG2_TIME (Ramp, &Time);

  DECIMAL TmpBias;
  SG2_BS (Ramp, Bias, &TmpBias);
  *BiasD2A = PostGain * TmpBias;

  DECIMAL AmplLeft = Amplitude / 2.0 + RollBias;
  DECIMAL AmplRight = Amplitude / 2.0 - RollBias;
  DECIMAL Offset = Bias / 2.0;

  DECIMAL TmpLeft;
  SG2_D1_DS (Time, Ramp, Freq, AmplLeft, Offset, PitchBiasLeft, A2, Phase, &TmpLeft, BufferLeft);
  DECIMAL TmpRight;
  SG2_D2_DS (Time, Ramp, Freq, AmplRight, Offset, PitchBiasRight, -A2, 0, &TmpRight, BufferRight);

  SG2_SSL (TmpBias, TmpLeft, PostGain, LeftD2A, BufferLeft);
  *LeftD2A = PostGain * (*LeftD2A);
  SG2_SSL (TmpBias, TmpRight, PostGain, RightD2A, BufferRight);
  *RightD2A = PostGain * (*RightD2A);
	return 0;
}

//
STATUS MODEL (const DECIMAL X, const DECIMAL Y, const DECIMAL Z, const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL *Timestamp, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A) { // CHECK
  static DECIMAL Ramp = 0;
  
  DECIMAL T = 0;
  TimeFunc (&T);

  DECIMAL PCur[3] = { X, Y, Z };
  DECIMAL W[3] = { 0 };
  DECIMAL QAvg[3] = { 0 };
  DECIMAL QRaw[3] = { 0 };
  DECIMAL P[3] = { 0 };
  DECIMAL V[3] = { 0 };
  DECIMAL RAvg[9] = { 0 };
  DECIMAL Omega[3] = { 0 };
  INTEGER Update = 0;
  INTEGER Count = 0;
  PP (PCur, Alpha, Beta, Gamma, W, QAvg, QRaw, P, V, RAvg, Omega, &Update, &Count);

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

  DECIMAL DrvParam[5] = { 0 };
  FTV (ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired, DrvParam);

  DECIMAL OpenLoopControl[5] = { Config.DrvAmp, Config.DrvPitchLeft, Config.DrvPitchRight, Config.DrvRoll, Config.A2OpenLoop };
  INTEGER Enable = 0;
  DECIMAL SGTime = 0;
  DECIMAL Freq = 0;
  DECIMAL DrvAmp = 0;
  DECIMAL DrvPitchLeft = 0;
  DECIMAL DrvPitchRight = 0;
  DECIMAL DrvRoll = 0;
  DECIMAL DrvA2 = 0;
  OCLS (OpenLoopControl, DrvParam, &Enable, &Ramp, &SGTime, &Freq, &DrvAmp, &DrvPitchLeft, &DrvPitchRight, &DrvRoll, &DrvA2);

  DECIMAL Bias = Config.DrvBias;
  DECIMAL Phase = Config.Phase;
  SG1 (Enable, Bias, Freq, DrvAmp, DrvPitchLeft, DrvPitchRight, DrvRoll, DrvA2, Phase, BiasD2A, LeftD2A, RightD2A);

  *Timestamp = SGTime;

  return 0;
}

//
STATUS SAMPLE_MODEL (DECIMAL *Timestamp, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A) { // CHECK
  static DECIMAL X, Y, Z, Alpha, Beta, Gamma;
  Read (&X);
  Read (&Y);
  Read (&Z);
  Read (&Alpha);
  Read (&Beta);
  Read (&Gamma);

  return MODEL (X, Y, Z, Alpha, Beta, Gamma, Timestamp, BiasD2A, LeftD2A, RightD2A);
}

STATUS SAMPLE_MODEL_BUFFER (DECIMAL *Timestamp, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A, DECIMAL SignalBufferLeft[SIG_BUF_SIZE], DECIMAL SignalBufferRight[SIG_BUF_SIZE]) { // CHECK
  static DECIMAL Ramp = 0;

  static DECIMAL X, Y, Z, Alpha, Beta, Gamma;
  Read (&X);
  Read (&Y);
  Read (&Z);
  Read (&Alpha);
  Read (&Beta);
  Read (&Gamma);
  
  DECIMAL T = 0;
  TimeFunc (&T);

  DECIMAL PCur[3] = { X, Y, Z };
  DECIMAL W[3] = { 0 };
  DECIMAL QAvg[3] = { 0 };
  DECIMAL QRaw[3] = { 0 };
  DECIMAL P[3] = { 0 };
  DECIMAL V[3] = { 0 };
  DECIMAL RAvg[9] = { 0 };
  DECIMAL Omega[3] = { 0 };
  INTEGER Update = 0;
  INTEGER Count = 0;
  PP (PCur, Alpha, Beta, Gamma, W, QAvg, QRaw, P, V, RAvg, Omega, &Update, &Count);

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

  DECIMAL DrvParam[5] = { 0 };
  FTV (ThrustDesired, RollTorqueDesired, PitchTorqueDesired, YawTorqueDesired, DrvParam);

  DECIMAL OpenLoopControl[5] = { Config.DrvAmp, Config.DrvPitchLeft, Config.DrvPitchRight, Config.DrvRoll, Config.A2OpenLoop };
  INTEGER Enable = 0;
  DECIMAL SGTime = 0;
  DECIMAL Freq = 0;
  DECIMAL DrvAmp = 0;
  DECIMAL DrvPitchLeft = 0;
  DECIMAL DrvPitchRight = 0;
  DECIMAL DrvRoll = 0;
  DECIMAL DrvA2 = 0;
  OCLS (OpenLoopControl, DrvParam, &Enable, &Ramp, &SGTime, &Freq, &DrvAmp, &DrvPitchLeft, &DrvPitchRight, &DrvRoll, &DrvA2);

  DECIMAL Bias = Config.DrvBias;
  DECIMAL Phase = Config.Phase;
  SignalBufferGenerator (Enable, Bias, Freq, DrvAmp, DrvPitchLeft, DrvPitchRight, DrvRoll, DrvA2, Phase, BiasD2A, LeftD2A, RightD2A, SignalBufferLeft, SignalBufferRight);

  *Timestamp = SGTime;

  return 0;
}

//
STATUS UtilsLP (const DECIMAL XPrev[6], const DECIMAL YPrev[5], DECIMAL *Output) { // CHECK
  INTEGER i;

  const DECIMAL *LPNum = Config.LPNum;
  const DECIMAL *LPDen = Config.LPDen;

  DECIMAL Sum1 = 0;
  for (i = 1; i < 6; ++i) {
    Sum1 += -LPDen[i] * YPrev[i - 1];
  }

  DECIMAL Sum2 = 0;
  for (i = 0; i < 6; ++i) {
    Sum2 += LPNum[i] * XPrev[i];
  }

  *Output = (Sum1 + Sum2) / LPDen[0];

  return 0;
}

//
STATUS UtilsVLP (const DECIMAL XPrev[6], const DECIMAL YPrev[5], DECIMAL *Output) { // CHECK
  INTEGER i;

  const DECIMAL *VLPNum = Config.VLPNum;
  const DECIMAL *VLPDen = Config.VLPDen;

  DECIMAL Sum1 = 0;
  for (i = 1; i < 6; ++i) {
    Sum1 += -VLPDen[i] * YPrev[i - 1];
  }

  DECIMAL Sum2 = 0;
  for (i = 0; i < 6; ++i) {
    Sum2 += VLPNum[i] * XPrev[i];
  }

  *Output = (Sum1 + Sum2) / VLPDen[0];

  return 0;
}

//
STATUS UtilsDer (const DECIMAL X, const DECIMAL XPrev, DECIMAL *Output) {
  const DECIMAL SamplingF = Config.SamplingF;

  const DECIMAL K = 1.0;

  *Output = K * SamplingF * (X - XPrev);

  return 0;
}

// TODO: Abstract Out Some Following Functions

//
STATUS UtilsFDer (const DECIMAL X[9], const DECIMAL XPrev[9], const DECIMAL YPrev[9], DECIMAL Output[9]) { // CHECK
  const DECIMAL KDA = Config.KDA;

  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = KDA * YPrev[i] + (X[i] - XPrev[i]);
  }

  return 0;
}

//
STATUS MathSat1 (const DECIMAL Input, const DECIMAL Upper, const DECIMAL Lower, const DECIMAL Gain, DECIMAL *Output) { // CHECK
  if (Input > Upper) {
    *Output = Upper;
  } else if (Input < Lower) {
    *Output = Lower;
  } else {
    *Output = Input;
  }
  *Output = Gain * (*Output);

  return 0;
}

//
STATUS MathSat3 (const DECIMAL Input[3], const DECIMAL Upper, const DECIMAL Lower, const DECIMAL Gain, DECIMAL Output[3]) { // CHECK
  INTEGER i;

  for (i = 0; i < 3; ++i) {
    if (Input[i] > Upper) {
      Output[i] = Upper;
    } else if (Input[i] < Lower) {
      Output[i] = Lower;
    } else {
      Output[i] = Input[i];
    }
  }

  for (i = 0; i < 3; ++i) {
    Output[i] = Gain * Output[i];
  }

  return 0;
}

//
STATUS MathSat9 (const DECIMAL Input[9], const DECIMAL Upper, const DECIMAL Lower, const DECIMAL Gain, DECIMAL Output[9]) { // CHECK
  INTEGER i;

  for (i = 0; i < 9; ++i) {
    if (Input[i] > Upper) {
      Output[i] = Upper;
    } else if (Input[i] < Lower) {
      Output[i] = Lower;
    } else {
      Output[i] = Input[i];
    }
  }

  for (i = 0; i < 9; ++i) {
    Output[i] = Gain * Output[i];
  }

  return 0;
}

//
STATUS MathMatrix3 (const DECIMAL Input[9], DECIMAL Output[3 * 3]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = Input[i];
  }
  return 0;
}

//
STATUS MathVector9 (const DECIMAL Input[3 * 3], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = Input[i];
  }
  return 0;
}

//
STATUS MathNorm3 (const DECIMAL Input[3], DECIMAL *Output) {
  DECIMAL Sum = 0;
  for (INTEGER i = 0; i < 3; ++i) {
    Sum += OpsPow (Input[i], 2.0);
  }
  *Output = OpsSqrt (Sum);

  return 0;
}

//
STATUS MathHead3 (const DECIMAL Input[3], DECIMAL Output[3]) {
  DECIMAL Norm;
  MathNorm3 (Input, &Norm);
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = Input[i] / Norm;
  }

  return 0;
}

//
STATUS MathDot3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL *Output) {
  *Output = 0;
  for (INTEGER i = 0; i < 3; ++i) {
    *Output += A[i] * B[i];
  }

  return 0;
}

//
STATUS MathCross3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL *Output) {
  Output[0] = A[1] * B[2] - A[2] * B[1];
  Output[1] = A[2] * B[0] - A[0] * B[2];
  Output[2] = A[0] * B[1] - A[1] * B[0];
  return 0;
}

//
STATUS MathTrace3 (const DECIMAL Input[3 * 3], DECIMAL *Output) {
  DECIMAL Sum = 0;
  for (INTEGER i = 0; i < 3; ++i) {
    Sum += Input[i * 3 + i]; 
  }
  *Output = Sum;
  return 0;
}

//
STATUS MathTranspose3 (const DECIMAL Input[3 * 3], DECIMAL Output[3 * 3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    for (INTEGER j = 0; j < 3; ++j) {
      Output[3 * j + i] = Input[3 * i + j];
    }
  }

  return 0;
}

//
STATUS MathZeroM3 (DECIMAL Output[3 * 3]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = 0;
  }

  return 0;
}

//
STATUS MathZeroV3 (DECIMAL Output[3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = 0;
  }

  return 0;
}

//
STATUS MathZeroV9 (DECIMAL Output[9]) { // Same as MathZeroM3
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = 0;
  }

  return 0;
}

//
STATUS MathCopyM3 (const DECIMAL Input[3 * 3], DECIMAL Output[3 * 3]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = Input[i];
  }

  return 0;
}

//
STATUS MathCopyV3 (const DECIMAL Input[3], DECIMAL Output[3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = Input[i];
  }

  return 0;
}

// 
STATUS MathCopyV9 (const DECIMAL Input[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = Input[i];
  }

  return 0;
}

//
STATUS MathAddV3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL Output[3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = A[i] + B[i];
  }

  return 0;
}

//
STATUS MathAddV9 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = A[i] + B[i];
  }

  return 0;
}

//
STATUS MathAddM3 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = A[i] + B[i];
  }

  return 0;
}

//
STATUS MathSubtractV3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL Output[3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = A[i] - B[i];
  }

  return 0;
}

//
STATUS MathSubtractV9 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = A[i] - B[i];
  }

  return 0;
}

//
STATUS MathSubtractM3 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = A[i] - B[i];
  }

  return 0;
}

//
STATUS MathMultiplyM3K (const DECIMAL K, const DECIMAL A[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 9; ++i) {
    Output[i] = A[i] * K;
  }

  return 0;
}

//
STATUS MathMultiplyV3K (const DECIMAL K, const DECIMAL V[3], DECIMAL Output[3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = V[i] * K;
  }

  return 0;
}

//
STATUS MathMultiplyM3V3 (const DECIMAL A[9], const DECIMAL V[3], DECIMAL Output[3]) {
  for (INTEGER i = 0; i < 3; ++i) {
    Output[i] = 0;
    for (INTEGER j = 0; j < 3; ++j) {
      Output[i] = Output[i] + A[3 * i + j] * V[j];
    }
  }

  return 0;
}

//
STATUS MathMultiplyV3M3 (const DECIMAL V[3], const DECIMAL A[9], DECIMAL Output[3]) {
  for (INTEGER j = 0; j < 3; ++j) {
    Output[j] = 0;
    for (INTEGER i = 0; i < 3; ++i) {
      Output[j] = Output[j] + V[i] * A[3 * i + j];
    }
  }

  return 0;
}

//
STATUS MathMultiplyM3 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]) {
  for (INTEGER i = 0; i < 3; ++i) {
    for (INTEGER j = 0; j < 3; ++j) {
      Output[3 * i + j] = 0;
      for (INTEGER k = 0; k < 3; ++k) {
        Output[3 * i + j] = Output[3 * i + j] + A[3 * i + k] * B[3 * k + j];
      }
    }
  }

  return 0;
}

//
STATUS MathExpMap3 (const DECIMAL Input[9], DECIMAL W[3]) {
  DECIMAL Matrix[3 * 3];
  MathMatrix3 (Input, Matrix);

  DECIMAL Trace = 0;
  for (INTEGER i = 0; i < 3; ++i) {
    Trace = Trace + Matrix[3 * i + i];
  }

  DECIMAL Theta;
  DECIMAL Tmp = (Trace - 1.0) / 2.0;
  if (OpsAbs (Tmp) <= 1.0) {
    Theta = OpsAcos (Tmp);
  } else {
    Theta = OpsAcos (Tmp / OpsAbs (Tmp));
  }

  if (Theta == 0) {
    W[0] = 0;
    W[1] = 0;
    W[2] = 0;
  } else {
    W[0] = Theta / (2.0 * OpsSin (Theta)) * (Matrix[3 * 2 + 1] - Matrix[3 * 1 + 2]);
    W[1] = Theta / (2.0 * OpsSin (Theta)) * (Matrix[3 * 0 + 2] - Matrix[3 * 2 + 0]);
    W[2] = Theta / (2.0 * OpsSin (Theta)) * (Matrix[3 * 1 + 0] - Matrix[3 * 0 + 1]);
  }

  return 0;
}

//
STATUS MathFracRot3 (const DECIMAL W[3], const DECIMAL N, DECIMAL Output[9]) {
  DECIMAL Theta = ((DECIMAL) 1.0) / N;

  DECIMAL K[3 * 3];
  K[0] = 0;
  K[1] = -W[2];
  K[2] = W[1];
  K[3] = W[2];
  K[4] = 0;
  K[5] = -W[0];
  K[6] = -W[1];
  K[7] = W[0];
  K[8] = 0;

  DECIMAL K2[3 * 3] = { 0 };
  MathMultiplyM3 (K, K, K2);

  DECIMAL Tmp1[3 * 3] = { 0 };
  MathMultiplyM3K (OpsSin (Theta), K, Tmp1);

  DECIMAL Tmp2[3 * 3] = { 0 };
  MathMultiplyM3K (((DECIMAL) 1.0) - OpsCos (Theta), K2, Tmp2);

  MathAddM3 (Tmp1, Tmp2, Output);

  for (INTEGER i = 0; i < 3; ++i) {
    Output[3 * i + i] = Output[3 * i + i] + 1.0;
  }

  return 0;
}

//
STATUS MathRot2Quat (const DECIMAL R[9], DECIMAL Q[4]) {
  DECIMAL Rot[3 * 3];
  MathMatrix3 (R, Rot);

  DECIMAL Trace = Rot[3 * 0 + 0] + Rot[3 * 1 + 1] + Rot[3 * 2 + 2];
  if (Trace > 0) {
    DECIMAL SInv = 0.5 / OpsSqrt (Trace + 1.0);
    Q[0] = 0.25 / SInv;
    Q[1] = (Rot[3 * 2 + 1] - Rot[3 * 1 + 2]) * SInv;
    Q[2] = (Rot[3 * 0 + 2] - Rot[3 * 2 + 0]) * SInv;
    Q[3] = (Rot[3 * 1 + 0] - Rot[3 * 0 + 1]) * SInv;
  } else {
    if ((Rot[3 * 0 + 0] > Rot[3 * 1 + 1]) && (Rot[3 * 0 + 0] > Rot[3 * 2 + 2])) {
      DECIMAL SInv = 0.5 / OpsSqrt (1.0 + Rot[3 * 0 + 0] - Rot[3 * 1 + 1] - Rot[3 * 2 + 2]);
      Q[0] = (Rot[3 * 2 + 1] - Rot[3 * 1 + 2]) * SInv;
      Q[1] = 0.25 / SInv;
      Q[2] = (Rot[3 * 0 + 1] + Rot[3 * 1 + 0]) * SInv;
      Q[3] = (Rot[3 * 0 + 2] + Rot[3 * 2 + 0]) * SInv;
    } else if (Rot[3 * 1 + 1] > Rot[3 * 2 + 2]) {
      DECIMAL SInv = 0.5 / OpsSqrt (1.0 + Rot[3 * 1 + 1] - Rot[3 * 0 + 0] - Rot[3 * 2 + 2]);
      Q[0] = (Rot[3 * 0 + 2] - Rot[3 * 2 + 0]) * SInv;
      Q[1] = (Rot[3 * 0 + 1] + Rot[3 * 1 + 0]) * SInv;
      Q[2] = 0.25 / SInv;
      Q[3] = (Rot[3 * 1 + 2] + Rot[3 * 2 + 1]) * SInv;
    } else {
      DECIMAL SInv = 0.5 / OpsSqrt (1.0 + Rot[3 * 2 + 2] - Rot[3 * 0 + 0] - Rot[3 * 1 + 1]);
      Q[0] = (Rot[3 * 1 + 0] - Rot[3 * 0 + 1]) * SInv;
      Q[1] = (Rot[3 * 0 + 2] + Rot[3 * 2 + 0]) * SInv;
      Q[2] = (Rot[3 * 1 + 2] + Rot[3 * 2 + 1]) * SInv;
      Q[3] = 0.25 / SInv;
    }
  }

  return 0;
}

//
DECIMAL OpsMin (const DECIMAL A, const DECIMAL B) {
  if (A <= B) {
    return A;
  } else {
    return B;
  }
}

//
DECIMAL OpsMax (const DECIMAL A, const DECIMAL B) {
  if (A >= B) {
    return A;
  } else {
    return B;
  }
}

// TODO: No Math Library >:(

//
DECIMAL OpsPow (const DECIMAL Base, const DECIMAL Exp) {
  return pow (static_cast<double> (Base), static_cast<double> (Exp));
}

//
DECIMAL OpsSqrt (const DECIMAL Value) {
  return sqrt (static_cast<double> (Value));
}

//
DECIMAL OpsAbs (const DECIMAL Value) {
  return fabs (static_cast<double> (Value));
}

//
DECIMAL OpsSin (const DECIMAL Theta) {
  return sin (static_cast<double> (Theta));
}

//
DECIMAL OpsCos (const DECIMAL Theta) {
  return cos (static_cast<double> (Theta));
}

//
DECIMAL OpsAcos (const DECIMAL Theta) {
  return acos (static_cast<double> (Theta));
}
