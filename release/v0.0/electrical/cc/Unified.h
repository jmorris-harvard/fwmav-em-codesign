#pragma once

// Model File Headers
#include <Defines.h>

// Timing 
STATUS StartTimer (void);
STATUS TimeFunc (DECIMAL* T);

// Initialization 
STATUS InitModel (void);
#ifdef BEE_DEBUG
STATUS ReadModel (void);
#endif
// Testing
STATUS BeeModel (const DECIMAL X[12], const DECIMAL U[4], const DECIMAL T, DECIMAL XNext[12]);

// Model Functions
// Vicon Correction
STATUS VC (const DECIMAL PCur[3], DECIMAL P[3]);
// Vicon Post Processing Into Raw Rotation Matrix
STATUS VPP_RRM (const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL R[9]);
// Vicon Post Processing Into Vicon Correction
STATUS VPP_VC (const DECIMAL R[9], const DECIMAL RollOffsetAngle, DECIMAL Output[9]);
// Vicon Post Processing Into Vicon Validity Check
STATUS VPP_VVC (const DECIMAL R[9], INTEGER *Cur, INTEGER *Prev);
// Vicon Post Processing
STATUS VPP (const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL Matrix[9], INTEGER *Update, INTEGER *Count);

// Observer For Averaged System Into Position Observer Into Average Position Velocity
STATUS OFAS_PO_APV (const DECIMAL R[3], const INTEGER Update, const INTEGER Count, DECIMAL ROut[3], DECIMAL VOut[3]);
// Observer For Averaged System Into Position Observer
STATUS OFAS_PO (const DECIMAL PRaw[3], const INTEGER Update, const INTEGER Count, DECIMAL P[3], DECIMAL V[3]);
// Observer For Averaged System Into Euler Derivative and Filtered Angular Velocity Into Filtered Derivative
STATUS OFAS_EDFAV_DER (const DECIMAL R[9], DECIMAL RDot[9]);
// Observer For Averaged System Into Euler Derivative and Filtered Angular Velocity Into Angular Velocity
STATUS OFAS_EDFAV_AV (const DECIMAL R[9], const DECIMAL RDot[9], DECIMAL W[3], DECIMAL *FrobError);
// Observer For Averaged System Into Euler Derivative and Filtered Angular Velocity
STATUS OFAS_EDFAV (const DECIMAL R[9], DECIMAL W[3], DECIMAL *FrobError);
// Observer For Averaged System Into Attitude Observer Into Geometric Derivative
STATUS OFAS_AO_GD_FUNC (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDot[3]);
// Observer For Averaged System Into Attitude Observer Into Geometric Derivative
STATUS OFAS_AO_GD (const DECIMAL R[9], const INTEGER Update, INTEGER Count, DECIMAL OmegaDot[3]);
// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix Into Raw Quaternion
STATUS OFAS_AO_GARM_RQ (const DECIMAL R[9], DECIMAL Q[4]);
// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix
STATUS OFAS_AO_GARM_FUNC (const DECIMAL R[9], const INTEGER Update, DECIMAL ROut[9]);
// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix Into Averaged Quaternion
STATUS OFAS_AO_GARM_AQ (const DECIMAL R[9], DECIMAL Q[4]);
// Observer For Averaged System Into Attitude Observer Into Geometric Averaging Rotation Matrix
STATUS OFAS_AO_GARM (const DECIMAL R[9], const INTEGER Update, DECIMAL QAvg[4], DECIMAL RAvg[9], DECIMAL QRaw[4]);
// Observer For Averaged System Into Attitude Observer
STATUS OFAS_AO (const DECIMAL RRaw[9], const INTEGER Update, const INTEGER Count, DECIMAL QAvg[4], DECIMAL RAvg[9], DECIMAL QRaw[4], DECIMAL OmegaDot[3]);
// Observer For Averaged System
STATUS OFAS (const DECIMAL PRaw[3], const DECIMAL RRaw[9], const INTEGER Update, const INTEGER Count, DECIMAL W[3], DECIMAL QAvg[4], DECIMAL QRaw[4], DECIMAL P[3], DECIMAL V[3], DECIMAL RAvg[9], DECIMAL OmegaDot[3]);

// Pre Processing
STATUS PP (const DECIMAL PCur[3], const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL W[3], DECIMAL QAvg[4], DECIMAL QRaw[4], DECIMAL P[3], DECIMAL V[3], DECIMAL RAvg[9], DECIMAL OmegaDot[3], INTEGER* Update, INTEGER* Count);
// Trajectory Generation
STATUS TRAJ_FUNC (const DECIMAL T, const INTEGER TaskFlag, const DECIMAL ComDesired[3], const DECIMAL B1DDesired[3], const DECIMAL TaskParameter[3], DECIMAL PDesired[3], DECIMAL VDesired[3], DECIMAL ADesired[3], DECIMAL B1D[3]);
// Trajectory Generation
STATUS TRAJ (const DECIMAL T, DECIMAL PDesired[3], DECIMAL VDesired[3], DECIMAL ADesired[3], DECIMAL B1D[3]);

// Desired Altitude and Normalized Error Into Saturated Normalized Error Observation Into Saturated Normalized Attitute Error
STATUS DAANE_SNEO_SNAE (const DECIMAL AvgP[3], const DECIMAL PDesired[3], const DECIMAL AvgV[3], const DECIMAL VDesired[3], DECIMAL EP[3], DECIMAL EV[3]);
// Desired Altitude and Normalized Error Into Saturated Normalized Error Observation Into Saturated Normalized eR
STATUS DAANE_SNEO_SN (const DECIMAL R[9], const DECIMAL RDesired[9], DECIMAL ER[3]);
//
STATUS DAANE_SNEO_SAV (const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL R[9], const DECIMAL RDesired[9], DECIMAL EOmega[3]);
//
STATUS DAANE_SNEO (const DECIMAL P[3], const DECIMAL V[3], const DECIMAL R[9], const DECIMAL Omega[3], const DECIMAL PDesired[3], const DECIMAL VDesired[3], const DECIMAL RDesired[9], const DECIMAL OmegaDesired[3], DECIMAL EP[3], DECIMAL EV[3], DECIMAL ER[3], DECIMAL EOmega[3]);
//
STATUS DAANE_DA (const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ADesired[3], const DECIMAL B1D[3], const DECIMAL Update, const DECIMAL AdaptiveLateralControl[3], DECIMAL RDesired[9]);
//
STATUS DAANE_GD_FUNC (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDot[3]);
//
STATUS DAANE_GD_DER (const DECIMAL OmegaDesired[3], DECIMAL Output[3]);
//
STATUS DAANE_GD (const DECIMAL R[9], const INTEGER Update, const INTEGER Count, DECIMAL OmegaDesired[3], DECIMAL OmegaDotDesired[3]);
//
STATUS DAANE (const INTEGER Update, const INTEGER Count, const DECIMAL P[3], const DECIMAL V[3], const DECIMAL R[9], const DECIMAL Omega[3], const DECIMAL PDesired[3], const DECIMAL VDesired[3], const DECIMAL ADesired[3], const DECIMAL B1D[3], const DECIMAL AdaptiveLateralControl[3], DECIMAL RDesired[9], DECIMAL OmegaDesired[3], DECIMAL OmegaDotDesired[3], DECIMAL EP[3], DECIMAL EV[3], DECIMAL ER[3], DECIMAL EOmega[3]);

//
STATUS GC_LS_AC (const DECIMAL CurrentAdaptiveX, const DECIMAL CurrentAdaptiveY, const DECIMAL CurrentAdaptiveZ, const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *DERAdaptiveTorqueX, DECIMAL *DERAdaptiveTorqueY, DECIMAL *DERAdaptiveTorqueZ);
//
STATUS GC_LA (const DECIMAL Ramp, const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *AdaptiveX, DECIMAL* AdaptiveY, DECIMAL *AdaptiveZ, DECIMAL AdaptiveLateralControl[3]);
//
STATUS GC_FUNC (const DECIMAL R[9], const DECIMAL RDesired[3], const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL OmegaDotDesired[3], const DECIMAL ADesired[3], const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL ControlGain[7], const DECIMAL AdaptiveRoll, const DECIMAL AdaptivePitch, const DECIMAL AdaptiveYaw, const DECIMAL AdaptiveX, const DECIMAL AdaptiveY, const DECIMAL AdaptiveZ, DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired);
//
STATUS GC_CONTROL (const DECIMAL Ramp, const DECIMAL R[9], const DECIMAL RDesired[3], const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL OmegaDotDesired[3], const DECIMAL ADesired[3], const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL ControlGain[7], const DECIMAL AdaptiveRoll, const DECIMAL AdaptivePitch, const DECIMAL AdaptiveYaw, const DECIMAL AdaptiveX, const DECIMAL AdaptiveY, const DECIMAL AdaptiveZ, DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired);
//
STATUS GC_AA_AC (const DECIMAL CurrentAdaptiveRoll, const DECIMAL CurrentAdaptivePitch, const DECIMAL CurrentAdaptiveYaw, const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *DERAdaptiveTorqueRoll, DECIMAL *DERAdaptiveTorquePitch, DECIMAL *DERAdaptiveTorqueYaw);
//
STATUS GC_AA (const DECIMAL Ramp, const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL AdaptiveGainLimit[10], DECIMAL *AdaptiveRoll, DECIMAL *AdaptivePitch, DECIMAL *AdaptiveYaw, DECIMAL AdaptiveAttitudeControl[3]);
//
STATUS GC (const DECIMAL R[9], const DECIMAL RDesired[9], const DECIMAL Omega[3], const DECIMAL OmegaDesired[3], const DECIMAL OmegaDotDesired[3], const DECIMAL ADesired[3], const DECIMAL EX[3], const DECIMAL EV[3], const DECIMAL ER[3], const DECIMAL EOmega[3], const DECIMAL Ramp, DECIMAL *ThrustDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired, DECIMAL AdaptiveAttitudeOutput[3], DECIMAL AdaptiveLateralOutput[3]);

//
STATUS CONTROL (const INTEGER Update, const INTEGER Count, const DECIMAL P[3], const DECIMAL V[3], const DECIMAL R[9], const DECIMAL Omega[3], const DECIMAL PDesired[3], const DECIMAL VDesired[3], const DECIMAL ADesired[3], const DECIMAL B1D[3], DECIMAL Ramp, DECIMAL RDesired[9], DECIMAL OmegaDesired[3], DECIMAL OmegaDotDesired[3], DECIMAL EP[3], DECIMAL EV[3], DECIMAL ER[3], DECIMAL EOmega[3], DECIMAL *ThurstDesired, DECIMAL *RollTorqueDesired, DECIMAL *PitchTorqueDesired, DECIMAL *YawTorqueDesired, DECIMAL AdaptiveAttitudeOutput[3], DECIMAL AdaptiveLateralOutput[3]);

//
STATUS FTV_FUNC (const DECIMAL ThurstDesired, const DECIMAL RollTorqueDesired, const DECIMAL PitchTorqueDesired, const DECIMAL YawTorqueDesired, DECIMAL *DrvAmp, DECIMAL *DrvPitchLeft, DECIMAL *DrvPitchRight, DECIMAL *DrvRoll, DECIMAL *A2Coeff);
//
STATUS FTV (const DECIMAL ThrustDesired, const DECIMAL RollTorqueDesired, const DECIMAL PitchTorqueDesired, const DECIMAL YawTorqueDesired, DECIMAL Output[5]);

//
STATUS OCLS_RAMP (const DECIMAL T, DECIMAL *Z);
//
STATUS OCLS_FUNC (const DECIMAL OpenLoopControl[5], const DECIMAL ClosedLoopControl[5], DECIMAL Y[5]);
//
STATUS OCLS_FREQ (const DECIMAL T, DECIMAL *Output);
//
STATUS OCLS_ENABLE (const DECIMAL T, DECIMAL *Y);
//
STATUS OCLS_CONTROL (DECIMAL *Enable,  DECIMAL *Ramp, DECIMAL *Time, DECIMAL *Freq);
//
STATUS OCLS (const DECIMAL OpenLoopControl[5], const DECIMAL ClosedLoopControl[5], INTEGER *Enable, DECIMAL *Ramp, DECIMAL *Time, DECIMAL *Freq, DECIMAL *DrvAmp, DECIMAL *DrvPitchLeft, DECIMAL *DrvPitchRIght, DECIMAL *DrvRoll, DECIMAL *A2Out);

//
STATUS SG_DS_FS (const DECIMAL Time, const DECIMAL Freq, const DECIMAL Phase, const DECIMAL A2, DECIMAL *Output);
//
STATUS SG_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL AmplRaw, const DECIMAL AmplPrev, const DECIMAL OffRaw, const DECIMAL OffPrev, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL A2Prev, const DECIMAL Phase, DECIMAL *Norm, DECIMAL *AmplCur, DECIMAL *OffCur, DECIMAL *A2Cur);
//
STATUS SG_SSL (const DECIMAL Max, const DECIMAL Signal, const DECIMAL *Output);

//
STATUS SG1_TIME (const DECIMAL Ramp, DECIMAL *Time);
//
STATUS SG1_BS (const DECIMAL Ramp, const DECIMAL VoltNew, DECIMAL *VoltCur);
//
STATUS SG1_RAMP (const INTEGER Enable, DECIMAL *Ramp);
//
STATUS SG1_D1_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output);
//
STATUS SG1_D2_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output);
//
STATUS SG1 (const DECIMAL Enable, const DECIMAL Bias, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL PitchBiasLeft, const DECIMAL PitchBiasRight, const DECIMAL RollBias, const DECIMAL A2, const DECIMAL phase, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A);

//
STATUS SG2_TIME (const DECIMAL Ramp, DECIMAL *Time);
//
STATUS SG2_BS (const DECIMAL Ramp, const DECIMAL VoltNew, DECIMAL *VoltCur);
//
STATUS SG2_RAMP (const INTEGER Enable, DECIMAL *Ramp);
//
STATUS SG2_D1_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output);
//
STATUS SG2_D2_DS (const DECIMAL Time, const DECIMAL Ramp, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL Offset, const DECIMAL PitchBias, const DECIMAL A2, const DECIMAL Phase, DECIMAL *Output);
//
STATUS SG2 (const DECIMAL Enable, const DECIMAL Bias, const DECIMAL Freq, const DECIMAL Amplitude, const DECIMAL PitchBiasLeft, const DECIMAL PitchBiasRight, const DECIMAL RollBias, const DECIMAL A2, const DECIMAL phase, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A);

//
STATUS MODEL (const DECIMAL X, const DECIMAL Y, const DECIMAL Z, const DECIMAL Alpha, const DECIMAL Beta, const DECIMAL Gamma, DECIMAL *Timestamp, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A);

//
STATUS SAMPLE_MODEL (DECIMAL *Timestamp, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A);
//
STATUS SAMPLE_MODEL_BUFFER (DECIMAL *Timestamp, DECIMAL *BiasD2A, DECIMAL *LeftD2A, DECIMAL *RightD2A, DECIMAL SignalBufferLeft[SIG_BUF_SIZE], DECIMAL SignalBufferRight[SIG_BUF_SIZE]);

//
STATUS UtilsLP (const DECIMAL XPrev[6], const DECIMAL YPrev[5], DECIMAL *Output);
//
STATUS UtilsVLP (const DECIMAL XPrev[6], const DECIMAL YPrev[5], DECIMAL *Output);
//
STATUS UtilsDer (const DECIMAL X, const DECIMAL XPrev, DECIMAL *Output);
//
STATUS UtilsFDer (const DECIMAL X[9], const DECIMAL XPrev[9], const DECIMAL YPrev[9], DECIMAL Output[9]);

//
STATUS MathSat1 (const DECIMAL Input, const DECIMAL Upper, const DECIMAL Lower, const DECIMAL Gain, DECIMAL *Output);
//
STATUS MathSat3 (const DECIMAL Input[3], const DECIMAL Upper, const DECIMAL Lower, const DECIMAL Gain, DECIMAL Output[3]);
//
STATUS MathSat9 (const DECIMAL Input[9], const DECIMAL Upper, const DECIMAL Lower, const DECIMAL Gain, DECIMAL Output[9]);
//
STATUS MathMatrix3 (const DECIMAL Input[9], DECIMAL Output[9]);
//
STATUS MathVector9 (const DECIMAL Input[9], DECIMAL Output[9]);
//
STATUS MathNorm3 (const DECIMAL Input[3], DECIMAL *Output);
//
STATUS MathHead3 (const DECIMAL Input[3], DECIMAL Output[3]);
//
STATUS MathDot3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL *Output);
//
STATUS MathCross3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL *Output);
//
STATUS MathTrace3 (const DECIMAL Input[9], DECIMAL *Output);
//
STATUS MathTranspose3 (const DECIMAL Input[9], DECIMAL Output[9]);
//
STATUS MathZeroM3 (DECIMAL Output[9]);
//
STATUS MathZeroV3 (DECIMAL Output[3]);
//
STATUS MathZeroV9 (DECIMAL Output[9]); // Same as MathZeroM3
//
STATUS MathCopyM3 (const DECIMAL Input[9], DECIMAL Output[9]);
//
STATUS MathCopyV3 (const DECIMAL Input[3], DECIMAL Output[3]);
// 
STATUS MathCopyV9 (const DECIMAL Input[9], DECIMAL Output[9]);
//
STATUS MathAddV3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL Output[3]);
//
STATUS MathAddV9 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]);
//
STATUS MathAddM3 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]);
//
STATUS MathSubtractV3 (const DECIMAL A[3], const DECIMAL B[3], DECIMAL Output[3]);
//
STATUS MathSubtractV9 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]);
//
STATUS MathSubtractM3 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL OUTPUT[9]);
//
STATUS MathMultiplyM3K (const DECIMAL K, const DECIMAL A[9], DECIMAL Output[9]);
//
STATUS MathMultiplyV3K (const DECIMAL K, const DECIMAL V[3], DECIMAL Output[3]);
//
STATUS MathMultiplyM3V3 (const DECIMAL A[9], const DECIMAL V[3], DECIMAL Output[3]);
//
STATUS MathMultiplyV3M3 (const DECIMAL V[3], const DECIMAL A[9], DECIMAL Output[3]);
//
STATUS MathMultiplyM3 (const DECIMAL A[9], const DECIMAL B[9], DECIMAL Output[9]);
//
STATUS MathExpMap3 (const DECIMAL Input[9], DECIMAL W[3]);
//
STATUS MathFracRot3 (const DECIMAL W[3], const DECIMAL N, DECIMAL Output[9]);
//
STATUS MathRot2Quat (const DECIMAL R[9], DECIMAL Q[4]);

//
DECIMAL OpsMin (const DECIMAL A, const DECIMAL B);
//
DECIMAL OpsMax (const DECIMAL A, const DECIMAL B);
//
DECIMAL OpsPow (const DECIMAL Base, const DECIMAL Exp);
//
DECIMAL OpsSqrt (const DECIMAL Value);
//
DECIMAL OpsAbs (const DECIMAL Value);
//
DECIMAL OpsSin (const DECIMAL Theta);
//
DECIMAL OpsCos (const DECIMAL Theta);
//
DECIMAL OpsAcos (const DECIMAL Theta);
