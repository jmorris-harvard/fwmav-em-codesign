
//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/ccs_sync_out_vld_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2015 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

module ccs_sync_out_vld_v1 (vld, ivld);
  parameter integer rscid = 1;

  input  ivld;
  output vld;

  wire   vld;

  assign vld = ivld;
endmodule

//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/ccs_sync_in_wait_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2015 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

module ccs_sync_in_wait_v1 (rdy, vld, irdy, ivld);
  parameter integer rscid = 1;

  output rdy;
  input  vld;
  input  irdy;
  output ivld;

  wire   ivld;
  wire   rdy;

  assign ivld = vld;
  assign rdy = irdy;
endmodule

//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/mgc_io_sync_v2.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module mgc_io_sync_v2 (ld, lz);
    parameter valid = 0;

    input  ld;
    output lz;

    wire   lz;

    assign lz = ld;

endmodule


//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/ccs_in_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module ccs_in_v1 (idat, dat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] idat;
  input  [width-1:0] dat;

  wire   [width-1:0] idat;

  assign idat = dat;

endmodule


//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/ccs_out_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2015 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

module ccs_out_v1 (dat, idat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output   [width-1:0] dat;
  input    [width-1:0] idat;

  wire     [width-1:0] dat;

  assign dat = idat;

endmodule




//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/mgc_out_dreg_v2.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module mgc_out_dreg_v2 (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input    [width-1:0] d;
  output   [width-1:0] z;

  wire     [width-1:0] z;

  assign z = d;

endmodule

//------> ../td_ccore_solutions/ac__fx_div_53__881f08bde6072ab5a921d57a8849259a2cb17_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2023.1/1033555 Production Release
//  HLS Date:       Mon Feb 13 11:32:25 PST 2023
// 
//  Generated by:   jmorris@cktcad-c7-x11
//  Generated date: Tue Apr  9 23:16:44 2024
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    ac_fx_div_53_core
// ------------------------------------------------------------------


module ac_fx_div_53_core (
  op1_rsc_dat, op2_rsc_dat, quotient_rsc_z, exact_rsc_z, ccs_ccore_clk, ccs_ccore_en
);
  input [52:0] op1_rsc_dat;
  input [52:0] op2_rsc_dat;
  output [54:0] quotient_rsc_z;
  output exact_rsc_z;
  input ccs_ccore_clk;
  input ccs_ccore_en;


  // Interconnect Declarations
  wire [52:0] op1_rsci_idat;
  wire [52:0] op2_rsci_idat;
  reg exact_rsci_d;
  reg quotient_rsci_d_54;
  reg quotient_rsci_d_53;
  reg quotient_rsci_d_52;
  reg quotient_rsci_d_51;
  reg quotient_rsci_d_50;
  reg quotient_rsci_d_49;
  reg quotient_rsci_d_48;
  reg quotient_rsci_d_47;
  reg quotient_rsci_d_46;
  reg quotient_rsci_d_45;
  reg quotient_rsci_d_44;
  reg quotient_rsci_d_43;
  reg quotient_rsci_d_42;
  reg quotient_rsci_d_41;
  reg quotient_rsci_d_40;
  reg quotient_rsci_d_39;
  reg quotient_rsci_d_38;
  reg quotient_rsci_d_37;
  reg quotient_rsci_d_36;
  reg quotient_rsci_d_35;
  reg quotient_rsci_d_34;
  reg quotient_rsci_d_33;
  reg quotient_rsci_d_32;
  reg quotient_rsci_d_31;
  reg quotient_rsci_d_30;
  reg quotient_rsci_d_29;
  reg quotient_rsci_d_28;
  reg quotient_rsci_d_27;
  reg quotient_rsci_d_26;
  reg quotient_rsci_d_25;
  reg quotient_rsci_d_24;
  reg quotient_rsci_d_23;
  reg quotient_rsci_d_22;
  reg quotient_rsci_d_21;
  reg quotient_rsci_d_20;
  reg quotient_rsci_d_19;
  reg quotient_rsci_d_18;
  reg quotient_rsci_d_17;
  reg quotient_rsci_d_16;
  reg quotient_rsci_d_15;
  reg quotient_rsci_d_14;
  reg quotient_rsci_d_13;
  reg quotient_rsci_d_12;
  reg quotient_rsci_d_11;
  reg quotient_rsci_d_10;
  reg quotient_rsci_d_9;
  reg quotient_rsci_d_8;
  reg quotient_rsci_d_7;
  reg quotient_rsci_d_6;
  reg quotient_rsci_d_5;
  reg quotient_rsci_d_4;
  reg quotient_rsci_d_3;
  reg quotient_rsci_d_2;
  reg quotient_rsci_d_1;
  reg quotient_rsci_d_0;
  wire [53:0] for_acc_54_psp_sva_1;
  wire [54:0] nl_for_acc_54_psp_sva_1;
  wire [53:0] for_acc_53_psp_sva_1;
  wire [54:0] nl_for_acc_53_psp_sva_1;
  wire [53:0] for_acc_52_psp_sva_1;
  wire [54:0] nl_for_acc_52_psp_sva_1;
  wire [53:0] for_acc_51_psp_sva_1;
  wire [54:0] nl_for_acc_51_psp_sva_1;
  wire [53:0] for_acc_50_psp_sva_1;
  wire [54:0] nl_for_acc_50_psp_sva_1;
  wire [53:0] for_acc_49_psp_sva_1;
  wire [54:0] nl_for_acc_49_psp_sva_1;
  wire [53:0] for_acc_48_psp_sva_1;
  wire [54:0] nl_for_acc_48_psp_sva_1;
  wire [53:0] for_acc_47_psp_sva_1;
  wire [54:0] nl_for_acc_47_psp_sva_1;
  wire [53:0] for_acc_46_psp_sva_1;
  wire [54:0] nl_for_acc_46_psp_sva_1;
  wire [53:0] for_acc_45_psp_sva_1;
  wire [54:0] nl_for_acc_45_psp_sva_1;
  wire [53:0] for_acc_44_psp_sva_1;
  wire [54:0] nl_for_acc_44_psp_sva_1;
  wire [53:0] for_acc_43_psp_sva_1;
  wire [54:0] nl_for_acc_43_psp_sva_1;
  wire [53:0] for_acc_42_psp_sva_1;
  wire [54:0] nl_for_acc_42_psp_sva_1;
  wire [53:0] for_acc_41_psp_sva_1;
  wire [54:0] nl_for_acc_41_psp_sva_1;
  wire [53:0] for_acc_40_psp_sva_1;
  wire [54:0] nl_for_acc_40_psp_sva_1;
  wire [53:0] for_acc_39_psp_sva_1;
  wire [54:0] nl_for_acc_39_psp_sva_1;
  wire [53:0] for_acc_38_psp_sva_1;
  wire [54:0] nl_for_acc_38_psp_sva_1;
  wire [53:0] for_acc_37_psp_sva_1;
  wire [54:0] nl_for_acc_37_psp_sva_1;
  wire [53:0] for_acc_36_psp_sva_1;
  wire [54:0] nl_for_acc_36_psp_sva_1;
  wire [53:0] for_acc_35_psp_sva_1;
  wire [54:0] nl_for_acc_35_psp_sva_1;
  wire [53:0] for_acc_34_psp_sva_1;
  wire [54:0] nl_for_acc_34_psp_sva_1;
  wire [53:0] for_acc_33_psp_sva_1;
  wire [54:0] nl_for_acc_33_psp_sva_1;
  wire [53:0] for_acc_32_psp_sva_1;
  wire [54:0] nl_for_acc_32_psp_sva_1;
  wire [53:0] for_acc_31_psp_sva_1;
  wire [54:0] nl_for_acc_31_psp_sva_1;
  wire [53:0] for_acc_30_psp_sva_1;
  wire [54:0] nl_for_acc_30_psp_sva_1;
  wire [53:0] for_acc_29_psp_sva_1;
  wire [54:0] nl_for_acc_29_psp_sva_1;
  wire [53:0] for_acc_28_psp_sva_1;
  wire [54:0] nl_for_acc_28_psp_sva_1;
  wire [53:0] for_acc_27_psp_sva_1;
  wire [54:0] nl_for_acc_27_psp_sva_1;
  wire [53:0] for_acc_26_psp_sva_1;
  wire [54:0] nl_for_acc_26_psp_sva_1;
  wire [53:0] for_acc_25_psp_sva_1;
  wire [54:0] nl_for_acc_25_psp_sva_1;
  wire [53:0] for_acc_24_psp_sva_1;
  wire [54:0] nl_for_acc_24_psp_sva_1;
  wire [53:0] for_acc_23_psp_sva_1;
  wire [54:0] nl_for_acc_23_psp_sva_1;
  wire [53:0] for_acc_22_psp_sva_1;
  wire [54:0] nl_for_acc_22_psp_sva_1;
  wire [53:0] for_acc_21_psp_sva_1;
  wire [54:0] nl_for_acc_21_psp_sva_1;
  wire [53:0] for_acc_20_psp_sva_1;
  wire [54:0] nl_for_acc_20_psp_sva_1;
  wire [53:0] for_acc_19_psp_sva_1;
  wire [54:0] nl_for_acc_19_psp_sva_1;
  wire [53:0] for_acc_18_psp_sva_1;
  wire [54:0] nl_for_acc_18_psp_sva_1;
  wire [53:0] for_acc_17_psp_sva_1;
  wire [54:0] nl_for_acc_17_psp_sva_1;
  wire [53:0] for_acc_16_psp_sva_1;
  wire [54:0] nl_for_acc_16_psp_sva_1;
  wire [53:0] for_acc_15_psp_sva_1;
  wire [54:0] nl_for_acc_15_psp_sva_1;
  wire [53:0] for_acc_14_psp_sva_1;
  wire [54:0] nl_for_acc_14_psp_sva_1;
  wire [53:0] for_acc_13_psp_sva_1;
  wire [54:0] nl_for_acc_13_psp_sva_1;
  wire [53:0] for_acc_12_psp_sva_1;
  wire [54:0] nl_for_acc_12_psp_sva_1;
  wire [53:0] for_acc_11_psp_sva_1;
  wire [54:0] nl_for_acc_11_psp_sva_1;
  wire [53:0] for_acc_10_psp_sva_1;
  wire [54:0] nl_for_acc_10_psp_sva_1;
  wire [53:0] for_acc_9_psp_sva_1;
  wire [54:0] nl_for_acc_9_psp_sva_1;
  wire [53:0] for_acc_8_psp_sva_1;
  wire [54:0] nl_for_acc_8_psp_sva_1;
  wire [53:0] for_acc_7_psp_sva_1;
  wire [54:0] nl_for_acc_7_psp_sva_1;
  wire [53:0] for_acc_6_psp_sva_1;
  wire [54:0] nl_for_acc_6_psp_sva_1;
  wire [53:0] for_acc_5_psp_sva_1;
  wire [54:0] nl_for_acc_5_psp_sva_1;
  wire [53:0] for_acc_4_psp_sva_1;
  wire [54:0] nl_for_acc_4_psp_sva_1;
  wire [53:0] for_acc_3_psp_sva_1;
  wire [54:0] nl_for_acc_3_psp_sva_1;
  wire [53:0] for_acc_psp_sva_1;
  wire [54:0] nl_for_acc_psp_sva_1;
  wire [53:0] for_1_acc_1_psp_sva_1;
  wire [54:0] nl_for_1_acc_1_psp_sva_1;
  wire [53:0] neg_D_sva_1;
  wire [54:0] nl_neg_D_sva_1;
  reg [53:0] neg_D_sva_1_1;
  reg [52:0] op2_buf_sva_1;
  reg [53:0] for_acc_50_psp_sva_1_1;
  reg [52:0] for_qr_52_0_50_lpi_1_dfm_1;
  reg for_slc_for_qr_52_0_0_48_itm_1;
  reg operator_55_true_slc_for_1_acc_1_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_3_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_4_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_5_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_6_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_7_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_8_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_9_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_10_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_11_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_12_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_13_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_14_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_15_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_16_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_17_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_18_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_19_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_20_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_21_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_22_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_23_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_24_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_25_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_26_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_27_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_28_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_29_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_30_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_31_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_32_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_33_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_34_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_35_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_36_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_37_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_38_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_39_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_40_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_41_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_42_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_43_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_44_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_45_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_46_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_47_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_48_psp_53_itm_1;
  reg operator_55_true_slc_for_acc_49_psp_53_itm_1;
  wire [53:0] for_acc_55_psp_sva_1;
  wire [54:0] nl_for_acc_55_psp_sva_1;
  wire [52:0] for_qr_52_0_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_53_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_52_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_51_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_49_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_48_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_47_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_46_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_45_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_44_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_43_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_42_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_41_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_40_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_39_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_38_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_37_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_36_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_35_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_34_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_33_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_32_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_31_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_30_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_29_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_28_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_27_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_26_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_25_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_24_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_23_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_22_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_21_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_20_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_19_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_18_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_17_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_16_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_15_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_14_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_13_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_12_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_11_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_10_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_9_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_8_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_7_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_6_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_5_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_4_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_3_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_2_lpi_1_dfm_mx0;
  wire [52:0] for_qr_52_0_1_lpi_1_dfm_mx0;

  wire for_for_and_53_nl;
  wire for_for_and_52_nl;
  wire for_for_and_51_nl;
  wire for_for_and_50_nl;
  wire for_for_and_49_nl;
  wire for_for_and_48_nl;
  wire for_for_and_47_nl;
  wire for_for_and_46_nl;
  wire for_for_and_45_nl;
  wire for_for_and_44_nl;
  wire for_for_and_43_nl;
  wire for_for_and_42_nl;
  wire for_for_and_41_nl;
  wire for_for_and_40_nl;
  wire for_for_and_39_nl;
  wire for_for_and_38_nl;
  wire for_for_and_37_nl;
  wire for_for_and_36_nl;
  wire for_for_and_35_nl;
  wire for_for_and_34_nl;
  wire for_for_and_33_nl;
  wire for_for_and_32_nl;
  wire for_for_and_31_nl;
  wire for_for_and_30_nl;
  wire for_for_and_29_nl;
  wire for_for_and_28_nl;
  wire for_for_and_27_nl;
  wire for_for_and_26_nl;
  wire for_for_and_25_nl;
  wire for_for_and_24_nl;
  wire for_for_and_23_nl;
  wire for_for_and_22_nl;
  wire for_for_and_21_nl;
  wire for_for_and_20_nl;
  wire for_for_and_19_nl;
  wire for_for_and_18_nl;
  wire for_for_and_17_nl;
  wire for_for_and_16_nl;
  wire for_for_and_15_nl;
  wire for_for_and_14_nl;
  wire for_for_and_13_nl;
  wire for_for_and_12_nl;
  wire for_for_and_11_nl;
  wire for_for_and_10_nl;
  wire for_for_and_9_nl;
  wire for_for_and_8_nl;
  wire for_for_and_7_nl;
  wire for_for_and_6_nl;
  wire for_for_and_5_nl;
  wire for_for_and_4_nl;
  wire for_for_and_3_nl;
  wire for_for_and_2_nl;
  wire for_for_and_1_nl;
  wire for_for_and_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [54:0] nl_quotient_rsci_d;
  assign nl_quotient_rsci_d = {quotient_rsci_d_54 , quotient_rsci_d_53 , quotient_rsci_d_52
      , quotient_rsci_d_51 , quotient_rsci_d_50 , quotient_rsci_d_49 , quotient_rsci_d_48
      , quotient_rsci_d_47 , quotient_rsci_d_46 , quotient_rsci_d_45 , quotient_rsci_d_44
      , quotient_rsci_d_43 , quotient_rsci_d_42 , quotient_rsci_d_41 , quotient_rsci_d_40
      , quotient_rsci_d_39 , quotient_rsci_d_38 , quotient_rsci_d_37 , quotient_rsci_d_36
      , quotient_rsci_d_35 , quotient_rsci_d_34 , quotient_rsci_d_33 , quotient_rsci_d_32
      , quotient_rsci_d_31 , quotient_rsci_d_30 , quotient_rsci_d_29 , quotient_rsci_d_28
      , quotient_rsci_d_27 , quotient_rsci_d_26 , quotient_rsci_d_25 , quotient_rsci_d_24
      , quotient_rsci_d_23 , quotient_rsci_d_22 , quotient_rsci_d_21 , quotient_rsci_d_20
      , quotient_rsci_d_19 , quotient_rsci_d_18 , quotient_rsci_d_17 , quotient_rsci_d_16
      , quotient_rsci_d_15 , quotient_rsci_d_14 , quotient_rsci_d_13 , quotient_rsci_d_12
      , quotient_rsci_d_11 , quotient_rsci_d_10 , quotient_rsci_d_9 , quotient_rsci_d_8
      , quotient_rsci_d_7 , quotient_rsci_d_6 , quotient_rsci_d_5 , quotient_rsci_d_4
      , quotient_rsci_d_3 , quotient_rsci_d_2 , quotient_rsci_d_1 , quotient_rsci_d_0};
  ccs_in_v1 #(.rscid(32'sd1),
  .width(32'sd53)) op1_rsci (
      .dat(op1_rsc_dat),
      .idat(op1_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd2),
  .width(32'sd53)) op2_rsci (
      .dat(op2_rsc_dat),
      .idat(op2_rsci_idat)
    );
  mgc_out_dreg_v2 #(.rscid(32'sd3),
  .width(32'sd55)) quotient_rsci (
      .d(nl_quotient_rsci_d[54:0]),
      .z(quotient_rsc_z)
    );
  mgc_out_dreg_v2 #(.rscid(32'sd4),
  .width(32'sd1)) exact_rsci (
      .d(exact_rsci_d),
      .z(exact_rsc_z)
    );
  assign for_for_and_53_nl = (neg_D_sva_1_1[53]) & (~ (for_acc_54_psp_sva_1[52]));
  assign nl_for_acc_55_psp_sva_1 = ({(for_acc_54_psp_sva_1[52:0]) , (for_qr_52_0_53_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_53_nl , (for_qr_52_0_lpi_1_dfm_mx0[52:1])});
  assign for_acc_55_psp_sva_1 = nl_for_acc_55_psp_sva_1[53:0];
  assign for_qr_52_0_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1_1[52:0]), op2_buf_sva_1,
      for_acc_54_psp_sva_1[52]);
  assign nl_neg_D_sva_1 = ({1'b1 , (~ op2_rsci_idat)}) + 54'b000000000000000000000000000000000000000000000000000001;
  assign neg_D_sva_1 = nl_neg_D_sva_1[53:0];
  assign for_for_and_52_nl = (neg_D_sva_1_1[53]) & (~ (for_acc_53_psp_sva_1[52]));
  assign nl_for_acc_54_psp_sva_1 = ({(for_acc_53_psp_sva_1[52:0]) , (for_qr_52_0_52_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_52_nl , (for_qr_52_0_53_lpi_1_dfm_mx0[52:1])});
  assign for_acc_54_psp_sva_1 = nl_for_acc_54_psp_sva_1[53:0];
  assign for_for_and_51_nl = (neg_D_sva_1_1[53]) & (~ (for_acc_52_psp_sva_1[52]));
  assign nl_for_acc_53_psp_sva_1 = ({(for_acc_52_psp_sva_1[52:0]) , (for_qr_52_0_51_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_51_nl , (for_qr_52_0_52_lpi_1_dfm_mx0[52:1])});
  assign for_acc_53_psp_sva_1 = nl_for_acc_53_psp_sva_1[53:0];
  assign for_for_and_50_nl = (neg_D_sva_1_1[53]) & (~ (for_acc_51_psp_sva_1[52]));
  assign nl_for_acc_52_psp_sva_1 = ({(for_acc_51_psp_sva_1[52:0]) , (for_qr_52_0_50_lpi_1_dfm_1[0])})
      + conv_s2u_53_54({for_for_and_50_nl , (for_qr_52_0_51_lpi_1_dfm_mx0[52:1])});
  assign for_acc_52_psp_sva_1 = nl_for_acc_52_psp_sva_1[53:0];
  assign for_for_and_49_nl = (neg_D_sva_1_1[53]) & (~ (for_acc_50_psp_sva_1_1[52]));
  assign nl_for_acc_51_psp_sva_1 = ({(for_acc_50_psp_sva_1_1[52:0]) , for_slc_for_qr_52_0_0_48_itm_1})
      + conv_s2u_53_54({for_for_and_49_nl , (for_qr_52_0_50_lpi_1_dfm_1[52:1])});
  assign for_acc_51_psp_sva_1 = nl_for_acc_51_psp_sva_1[53:0];
  assign for_for_and_48_nl = (neg_D_sva_1[53]) & (~ (for_acc_49_psp_sva_1[52]));
  assign nl_for_acc_50_psp_sva_1 = ({(for_acc_49_psp_sva_1[52:0]) , (for_qr_52_0_48_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_48_nl , (for_qr_52_0_49_lpi_1_dfm_mx0[52:1])});
  assign for_acc_50_psp_sva_1 = nl_for_acc_50_psp_sva_1[53:0];
  assign for_qr_52_0_53_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1_1[52:0]), op2_buf_sva_1,
      for_acc_53_psp_sva_1[52]);
  assign for_qr_52_0_52_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1_1[52:0]), op2_buf_sva_1,
      for_acc_52_psp_sva_1[52]);
  assign for_qr_52_0_51_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1_1[52:0]), op2_buf_sva_1,
      for_acc_51_psp_sva_1[52]);
  assign for_for_and_47_nl = (neg_D_sva_1[53]) & (~ (for_acc_48_psp_sva_1[52]));
  assign nl_for_acc_49_psp_sva_1 = ({(for_acc_48_psp_sva_1[52:0]) , (for_qr_52_0_47_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_47_nl , (for_qr_52_0_48_lpi_1_dfm_mx0[52:1])});
  assign for_acc_49_psp_sva_1 = nl_for_acc_49_psp_sva_1[53:0];
  assign for_for_and_46_nl = (neg_D_sva_1[53]) & (~ (for_acc_47_psp_sva_1[52]));
  assign nl_for_acc_48_psp_sva_1 = ({(for_acc_47_psp_sva_1[52:0]) , (for_qr_52_0_46_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_46_nl , (for_qr_52_0_47_lpi_1_dfm_mx0[52:1])});
  assign for_acc_48_psp_sva_1 = nl_for_acc_48_psp_sva_1[53:0];
  assign for_for_and_45_nl = (neg_D_sva_1[53]) & (~ (for_acc_46_psp_sva_1[52]));
  assign nl_for_acc_47_psp_sva_1 = ({(for_acc_46_psp_sva_1[52:0]) , (for_qr_52_0_45_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_45_nl , (for_qr_52_0_46_lpi_1_dfm_mx0[52:1])});
  assign for_acc_47_psp_sva_1 = nl_for_acc_47_psp_sva_1[53:0];
  assign for_for_and_44_nl = (neg_D_sva_1[53]) & (~ (for_acc_45_psp_sva_1[52]));
  assign nl_for_acc_46_psp_sva_1 = ({(for_acc_45_psp_sva_1[52:0]) , (for_qr_52_0_44_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_44_nl , (for_qr_52_0_45_lpi_1_dfm_mx0[52:1])});
  assign for_acc_46_psp_sva_1 = nl_for_acc_46_psp_sva_1[53:0];
  assign for_for_and_43_nl = (neg_D_sva_1[53]) & (~ (for_acc_44_psp_sva_1[52]));
  assign nl_for_acc_45_psp_sva_1 = ({(for_acc_44_psp_sva_1[52:0]) , (for_qr_52_0_43_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_43_nl , (for_qr_52_0_44_lpi_1_dfm_mx0[52:1])});
  assign for_acc_45_psp_sva_1 = nl_for_acc_45_psp_sva_1[53:0];
  assign for_for_and_42_nl = (neg_D_sva_1[53]) & (~ (for_acc_43_psp_sva_1[52]));
  assign nl_for_acc_44_psp_sva_1 = ({(for_acc_43_psp_sva_1[52:0]) , (for_qr_52_0_42_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_42_nl , (for_qr_52_0_43_lpi_1_dfm_mx0[52:1])});
  assign for_acc_44_psp_sva_1 = nl_for_acc_44_psp_sva_1[53:0];
  assign for_for_and_41_nl = (neg_D_sva_1[53]) & (~ (for_acc_42_psp_sva_1[52]));
  assign nl_for_acc_43_psp_sva_1 = ({(for_acc_42_psp_sva_1[52:0]) , (for_qr_52_0_41_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_41_nl , (for_qr_52_0_42_lpi_1_dfm_mx0[52:1])});
  assign for_acc_43_psp_sva_1 = nl_for_acc_43_psp_sva_1[53:0];
  assign for_for_and_40_nl = (neg_D_sva_1[53]) & (~ (for_acc_41_psp_sva_1[52]));
  assign nl_for_acc_42_psp_sva_1 = ({(for_acc_41_psp_sva_1[52:0]) , (for_qr_52_0_40_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_40_nl , (for_qr_52_0_41_lpi_1_dfm_mx0[52:1])});
  assign for_acc_42_psp_sva_1 = nl_for_acc_42_psp_sva_1[53:0];
  assign for_for_and_39_nl = (neg_D_sva_1[53]) & (~ (for_acc_40_psp_sva_1[52]));
  assign nl_for_acc_41_psp_sva_1 = ({(for_acc_40_psp_sva_1[52:0]) , (for_qr_52_0_39_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_39_nl , (for_qr_52_0_40_lpi_1_dfm_mx0[52:1])});
  assign for_acc_41_psp_sva_1 = nl_for_acc_41_psp_sva_1[53:0];
  assign for_for_and_38_nl = (neg_D_sva_1[53]) & (~ (for_acc_39_psp_sva_1[52]));
  assign nl_for_acc_40_psp_sva_1 = ({(for_acc_39_psp_sva_1[52:0]) , (for_qr_52_0_38_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_38_nl , (for_qr_52_0_39_lpi_1_dfm_mx0[52:1])});
  assign for_acc_40_psp_sva_1 = nl_for_acc_40_psp_sva_1[53:0];
  assign for_for_and_37_nl = (neg_D_sva_1[53]) & (~ (for_acc_38_psp_sva_1[52]));
  assign nl_for_acc_39_psp_sva_1 = ({(for_acc_38_psp_sva_1[52:0]) , (for_qr_52_0_37_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_37_nl , (for_qr_52_0_38_lpi_1_dfm_mx0[52:1])});
  assign for_acc_39_psp_sva_1 = nl_for_acc_39_psp_sva_1[53:0];
  assign for_for_and_36_nl = (neg_D_sva_1[53]) & (~ (for_acc_37_psp_sva_1[52]));
  assign nl_for_acc_38_psp_sva_1 = ({(for_acc_37_psp_sva_1[52:0]) , (for_qr_52_0_36_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_36_nl , (for_qr_52_0_37_lpi_1_dfm_mx0[52:1])});
  assign for_acc_38_psp_sva_1 = nl_for_acc_38_psp_sva_1[53:0];
  assign for_for_and_35_nl = (neg_D_sva_1[53]) & (~ (for_acc_36_psp_sva_1[52]));
  assign nl_for_acc_37_psp_sva_1 = ({(for_acc_36_psp_sva_1[52:0]) , (for_qr_52_0_35_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_35_nl , (for_qr_52_0_36_lpi_1_dfm_mx0[52:1])});
  assign for_acc_37_psp_sva_1 = nl_for_acc_37_psp_sva_1[53:0];
  assign for_for_and_34_nl = (neg_D_sva_1[53]) & (~ (for_acc_35_psp_sva_1[52]));
  assign nl_for_acc_36_psp_sva_1 = ({(for_acc_35_psp_sva_1[52:0]) , (for_qr_52_0_34_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_34_nl , (for_qr_52_0_35_lpi_1_dfm_mx0[52:1])});
  assign for_acc_36_psp_sva_1 = nl_for_acc_36_psp_sva_1[53:0];
  assign for_for_and_33_nl = (neg_D_sva_1[53]) & (~ (for_acc_34_psp_sva_1[52]));
  assign nl_for_acc_35_psp_sva_1 = ({(for_acc_34_psp_sva_1[52:0]) , (for_qr_52_0_33_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_33_nl , (for_qr_52_0_34_lpi_1_dfm_mx0[52:1])});
  assign for_acc_35_psp_sva_1 = nl_for_acc_35_psp_sva_1[53:0];
  assign for_for_and_32_nl = (neg_D_sva_1[53]) & (~ (for_acc_33_psp_sva_1[52]));
  assign nl_for_acc_34_psp_sva_1 = ({(for_acc_33_psp_sva_1[52:0]) , (for_qr_52_0_32_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_32_nl , (for_qr_52_0_33_lpi_1_dfm_mx0[52:1])});
  assign for_acc_34_psp_sva_1 = nl_for_acc_34_psp_sva_1[53:0];
  assign for_for_and_31_nl = (neg_D_sva_1[53]) & (~ (for_acc_32_psp_sva_1[52]));
  assign nl_for_acc_33_psp_sva_1 = ({(for_acc_32_psp_sva_1[52:0]) , (for_qr_52_0_31_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_31_nl , (for_qr_52_0_32_lpi_1_dfm_mx0[52:1])});
  assign for_acc_33_psp_sva_1 = nl_for_acc_33_psp_sva_1[53:0];
  assign for_for_and_30_nl = (neg_D_sva_1[53]) & (~ (for_acc_31_psp_sva_1[52]));
  assign nl_for_acc_32_psp_sva_1 = ({(for_acc_31_psp_sva_1[52:0]) , (for_qr_52_0_30_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_30_nl , (for_qr_52_0_31_lpi_1_dfm_mx0[52:1])});
  assign for_acc_32_psp_sva_1 = nl_for_acc_32_psp_sva_1[53:0];
  assign for_for_and_29_nl = (neg_D_sva_1[53]) & (~ (for_acc_30_psp_sva_1[52]));
  assign nl_for_acc_31_psp_sva_1 = ({(for_acc_30_psp_sva_1[52:0]) , (for_qr_52_0_29_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_29_nl , (for_qr_52_0_30_lpi_1_dfm_mx0[52:1])});
  assign for_acc_31_psp_sva_1 = nl_for_acc_31_psp_sva_1[53:0];
  assign for_for_and_28_nl = (neg_D_sva_1[53]) & (~ (for_acc_29_psp_sva_1[52]));
  assign nl_for_acc_30_psp_sva_1 = ({(for_acc_29_psp_sva_1[52:0]) , (for_qr_52_0_28_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_28_nl , (for_qr_52_0_29_lpi_1_dfm_mx0[52:1])});
  assign for_acc_30_psp_sva_1 = nl_for_acc_30_psp_sva_1[53:0];
  assign for_for_and_27_nl = (neg_D_sva_1[53]) & (~ (for_acc_28_psp_sva_1[52]));
  assign nl_for_acc_29_psp_sva_1 = ({(for_acc_28_psp_sva_1[52:0]) , (for_qr_52_0_27_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_27_nl , (for_qr_52_0_28_lpi_1_dfm_mx0[52:1])});
  assign for_acc_29_psp_sva_1 = nl_for_acc_29_psp_sva_1[53:0];
  assign for_for_and_26_nl = (neg_D_sva_1[53]) & (~ (for_acc_27_psp_sva_1[52]));
  assign nl_for_acc_28_psp_sva_1 = ({(for_acc_27_psp_sva_1[52:0]) , (for_qr_52_0_26_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_26_nl , (for_qr_52_0_27_lpi_1_dfm_mx0[52:1])});
  assign for_acc_28_psp_sva_1 = nl_for_acc_28_psp_sva_1[53:0];
  assign for_for_and_25_nl = (neg_D_sva_1[53]) & (~ (for_acc_26_psp_sva_1[52]));
  assign nl_for_acc_27_psp_sva_1 = ({(for_acc_26_psp_sva_1[52:0]) , (for_qr_52_0_25_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_25_nl , (for_qr_52_0_26_lpi_1_dfm_mx0[52:1])});
  assign for_acc_27_psp_sva_1 = nl_for_acc_27_psp_sva_1[53:0];
  assign for_for_and_24_nl = (neg_D_sva_1[53]) & (~ (for_acc_25_psp_sva_1[52]));
  assign nl_for_acc_26_psp_sva_1 = ({(for_acc_25_psp_sva_1[52:0]) , (for_qr_52_0_24_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_24_nl , (for_qr_52_0_25_lpi_1_dfm_mx0[52:1])});
  assign for_acc_26_psp_sva_1 = nl_for_acc_26_psp_sva_1[53:0];
  assign for_for_and_23_nl = (neg_D_sva_1[53]) & (~ (for_acc_24_psp_sva_1[52]));
  assign nl_for_acc_25_psp_sva_1 = ({(for_acc_24_psp_sva_1[52:0]) , (for_qr_52_0_23_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_23_nl , (for_qr_52_0_24_lpi_1_dfm_mx0[52:1])});
  assign for_acc_25_psp_sva_1 = nl_for_acc_25_psp_sva_1[53:0];
  assign for_for_and_22_nl = (neg_D_sva_1[53]) & (~ (for_acc_23_psp_sva_1[52]));
  assign nl_for_acc_24_psp_sva_1 = ({(for_acc_23_psp_sva_1[52:0]) , (for_qr_52_0_22_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_22_nl , (for_qr_52_0_23_lpi_1_dfm_mx0[52:1])});
  assign for_acc_24_psp_sva_1 = nl_for_acc_24_psp_sva_1[53:0];
  assign for_for_and_21_nl = (neg_D_sva_1[53]) & (~ (for_acc_22_psp_sva_1[52]));
  assign nl_for_acc_23_psp_sva_1 = ({(for_acc_22_psp_sva_1[52:0]) , (for_qr_52_0_21_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_21_nl , (for_qr_52_0_22_lpi_1_dfm_mx0[52:1])});
  assign for_acc_23_psp_sva_1 = nl_for_acc_23_psp_sva_1[53:0];
  assign for_for_and_20_nl = (neg_D_sva_1[53]) & (~ (for_acc_21_psp_sva_1[52]));
  assign nl_for_acc_22_psp_sva_1 = ({(for_acc_21_psp_sva_1[52:0]) , (for_qr_52_0_20_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_20_nl , (for_qr_52_0_21_lpi_1_dfm_mx0[52:1])});
  assign for_acc_22_psp_sva_1 = nl_for_acc_22_psp_sva_1[53:0];
  assign for_for_and_19_nl = (neg_D_sva_1[53]) & (~ (for_acc_20_psp_sva_1[52]));
  assign nl_for_acc_21_psp_sva_1 = ({(for_acc_20_psp_sva_1[52:0]) , (for_qr_52_0_19_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_19_nl , (for_qr_52_0_20_lpi_1_dfm_mx0[52:1])});
  assign for_acc_21_psp_sva_1 = nl_for_acc_21_psp_sva_1[53:0];
  assign for_for_and_18_nl = (neg_D_sva_1[53]) & (~ (for_acc_19_psp_sva_1[52]));
  assign nl_for_acc_20_psp_sva_1 = ({(for_acc_19_psp_sva_1[52:0]) , (for_qr_52_0_18_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_18_nl , (for_qr_52_0_19_lpi_1_dfm_mx0[52:1])});
  assign for_acc_20_psp_sva_1 = nl_for_acc_20_psp_sva_1[53:0];
  assign for_for_and_17_nl = (neg_D_sva_1[53]) & (~ (for_acc_18_psp_sva_1[52]));
  assign nl_for_acc_19_psp_sva_1 = ({(for_acc_18_psp_sva_1[52:0]) , (for_qr_52_0_17_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_17_nl , (for_qr_52_0_18_lpi_1_dfm_mx0[52:1])});
  assign for_acc_19_psp_sva_1 = nl_for_acc_19_psp_sva_1[53:0];
  assign for_for_and_16_nl = (neg_D_sva_1[53]) & (~ (for_acc_17_psp_sva_1[52]));
  assign nl_for_acc_18_psp_sva_1 = ({(for_acc_17_psp_sva_1[52:0]) , (for_qr_52_0_16_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_16_nl , (for_qr_52_0_17_lpi_1_dfm_mx0[52:1])});
  assign for_acc_18_psp_sva_1 = nl_for_acc_18_psp_sva_1[53:0];
  assign for_for_and_15_nl = (neg_D_sva_1[53]) & (~ (for_acc_16_psp_sva_1[52]));
  assign nl_for_acc_17_psp_sva_1 = ({(for_acc_16_psp_sva_1[52:0]) , (for_qr_52_0_15_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_15_nl , (for_qr_52_0_16_lpi_1_dfm_mx0[52:1])});
  assign for_acc_17_psp_sva_1 = nl_for_acc_17_psp_sva_1[53:0];
  assign for_for_and_14_nl = (neg_D_sva_1[53]) & (~ (for_acc_15_psp_sva_1[52]));
  assign nl_for_acc_16_psp_sva_1 = ({(for_acc_15_psp_sva_1[52:0]) , (for_qr_52_0_14_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_14_nl , (for_qr_52_0_15_lpi_1_dfm_mx0[52:1])});
  assign for_acc_16_psp_sva_1 = nl_for_acc_16_psp_sva_1[53:0];
  assign for_for_and_13_nl = (neg_D_sva_1[53]) & (~ (for_acc_14_psp_sva_1[52]));
  assign nl_for_acc_15_psp_sva_1 = ({(for_acc_14_psp_sva_1[52:0]) , (for_qr_52_0_13_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_13_nl , (for_qr_52_0_14_lpi_1_dfm_mx0[52:1])});
  assign for_acc_15_psp_sva_1 = nl_for_acc_15_psp_sva_1[53:0];
  assign for_for_and_12_nl = (neg_D_sva_1[53]) & (~ (for_acc_13_psp_sva_1[52]));
  assign nl_for_acc_14_psp_sva_1 = ({(for_acc_13_psp_sva_1[52:0]) , (for_qr_52_0_12_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_12_nl , (for_qr_52_0_13_lpi_1_dfm_mx0[52:1])});
  assign for_acc_14_psp_sva_1 = nl_for_acc_14_psp_sva_1[53:0];
  assign for_for_and_11_nl = (neg_D_sva_1[53]) & (~ (for_acc_12_psp_sva_1[52]));
  assign nl_for_acc_13_psp_sva_1 = ({(for_acc_12_psp_sva_1[52:0]) , (for_qr_52_0_11_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_11_nl , (for_qr_52_0_12_lpi_1_dfm_mx0[52:1])});
  assign for_acc_13_psp_sva_1 = nl_for_acc_13_psp_sva_1[53:0];
  assign for_for_and_10_nl = (neg_D_sva_1[53]) & (~ (for_acc_11_psp_sva_1[52]));
  assign nl_for_acc_12_psp_sva_1 = ({(for_acc_11_psp_sva_1[52:0]) , (for_qr_52_0_10_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_10_nl , (for_qr_52_0_11_lpi_1_dfm_mx0[52:1])});
  assign for_acc_12_psp_sva_1 = nl_for_acc_12_psp_sva_1[53:0];
  assign for_for_and_9_nl = (neg_D_sva_1[53]) & (~ (for_acc_10_psp_sva_1[52]));
  assign nl_for_acc_11_psp_sva_1 = ({(for_acc_10_psp_sva_1[52:0]) , (for_qr_52_0_9_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_9_nl , (for_qr_52_0_10_lpi_1_dfm_mx0[52:1])});
  assign for_acc_11_psp_sva_1 = nl_for_acc_11_psp_sva_1[53:0];
  assign for_for_and_8_nl = (neg_D_sva_1[53]) & (~ (for_acc_9_psp_sva_1[52]));
  assign nl_for_acc_10_psp_sva_1 = ({(for_acc_9_psp_sva_1[52:0]) , (for_qr_52_0_8_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_8_nl , (for_qr_52_0_9_lpi_1_dfm_mx0[52:1])});
  assign for_acc_10_psp_sva_1 = nl_for_acc_10_psp_sva_1[53:0];
  assign for_for_and_7_nl = (neg_D_sva_1[53]) & (~ (for_acc_8_psp_sva_1[52]));
  assign nl_for_acc_9_psp_sva_1 = ({(for_acc_8_psp_sva_1[52:0]) , (for_qr_52_0_7_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_7_nl , (for_qr_52_0_8_lpi_1_dfm_mx0[52:1])});
  assign for_acc_9_psp_sva_1 = nl_for_acc_9_psp_sva_1[53:0];
  assign for_for_and_6_nl = (neg_D_sva_1[53]) & (~ (for_acc_7_psp_sva_1[52]));
  assign nl_for_acc_8_psp_sva_1 = ({(for_acc_7_psp_sva_1[52:0]) , (for_qr_52_0_6_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_6_nl , (for_qr_52_0_7_lpi_1_dfm_mx0[52:1])});
  assign for_acc_8_psp_sva_1 = nl_for_acc_8_psp_sva_1[53:0];
  assign for_for_and_5_nl = (neg_D_sva_1[53]) & (~ (for_acc_6_psp_sva_1[52]));
  assign nl_for_acc_7_psp_sva_1 = ({(for_acc_6_psp_sva_1[52:0]) , (for_qr_52_0_5_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_5_nl , (for_qr_52_0_6_lpi_1_dfm_mx0[52:1])});
  assign for_acc_7_psp_sva_1 = nl_for_acc_7_psp_sva_1[53:0];
  assign for_for_and_4_nl = (neg_D_sva_1[53]) & (~ (for_acc_5_psp_sva_1[52]));
  assign nl_for_acc_6_psp_sva_1 = ({(for_acc_5_psp_sva_1[52:0]) , (for_qr_52_0_4_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_4_nl , (for_qr_52_0_5_lpi_1_dfm_mx0[52:1])});
  assign for_acc_6_psp_sva_1 = nl_for_acc_6_psp_sva_1[53:0];
  assign for_for_and_3_nl = (neg_D_sva_1[53]) & (~ (for_acc_4_psp_sva_1[52]));
  assign nl_for_acc_5_psp_sva_1 = ({(for_acc_4_psp_sva_1[52:0]) , (for_qr_52_0_3_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_3_nl , (for_qr_52_0_4_lpi_1_dfm_mx0[52:1])});
  assign for_acc_5_psp_sva_1 = nl_for_acc_5_psp_sva_1[53:0];
  assign for_for_and_2_nl = (neg_D_sva_1[53]) & (~ (for_acc_3_psp_sva_1[52]));
  assign nl_for_acc_4_psp_sva_1 = ({(for_acc_3_psp_sva_1[52:0]) , (for_qr_52_0_2_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_2_nl , (for_qr_52_0_3_lpi_1_dfm_mx0[52:1])});
  assign for_acc_4_psp_sva_1 = nl_for_acc_4_psp_sva_1[53:0];
  assign for_for_and_1_nl = (neg_D_sva_1[53]) & (~ (for_acc_psp_sva_1[52]));
  assign nl_for_acc_3_psp_sva_1 = ({(for_acc_psp_sva_1[52:0]) , (for_qr_52_0_1_lpi_1_dfm_mx0[0])})
      + conv_s2u_53_54({for_for_and_1_nl , (for_qr_52_0_2_lpi_1_dfm_mx0[52:1])});
  assign for_acc_3_psp_sva_1 = nl_for_acc_3_psp_sva_1[53:0];
  assign for_for_and_nl = (neg_D_sva_1[53]) & (~ (for_1_acc_1_psp_sva_1[53]));
  assign nl_for_acc_psp_sva_1 = for_1_acc_1_psp_sva_1 + conv_s2u_53_54({for_for_and_nl
      , (for_qr_52_0_1_lpi_1_dfm_mx0[52:1])});
  assign for_acc_psp_sva_1 = nl_for_acc_psp_sva_1[53:0];
  assign nl_for_1_acc_1_psp_sva_1 = conv_u2s_53_54(op1_rsci_idat) + neg_D_sva_1;
  assign for_1_acc_1_psp_sva_1 = nl_for_1_acc_1_psp_sva_1[53:0];
  assign for_qr_52_0_49_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_49_psp_sva_1[52]);
  assign for_qr_52_0_48_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_48_psp_sva_1[52]);
  assign for_qr_52_0_47_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_47_psp_sva_1[52]);
  assign for_qr_52_0_46_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_46_psp_sva_1[52]);
  assign for_qr_52_0_45_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_45_psp_sva_1[52]);
  assign for_qr_52_0_44_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_44_psp_sva_1[52]);
  assign for_qr_52_0_43_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_43_psp_sva_1[52]);
  assign for_qr_52_0_42_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_42_psp_sva_1[52]);
  assign for_qr_52_0_41_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_41_psp_sva_1[52]);
  assign for_qr_52_0_40_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_40_psp_sva_1[52]);
  assign for_qr_52_0_39_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_39_psp_sva_1[52]);
  assign for_qr_52_0_38_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_38_psp_sva_1[52]);
  assign for_qr_52_0_37_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_37_psp_sva_1[52]);
  assign for_qr_52_0_36_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_36_psp_sva_1[52]);
  assign for_qr_52_0_35_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_35_psp_sva_1[52]);
  assign for_qr_52_0_34_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_34_psp_sva_1[52]);
  assign for_qr_52_0_33_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_33_psp_sva_1[52]);
  assign for_qr_52_0_32_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_32_psp_sva_1[52]);
  assign for_qr_52_0_31_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_31_psp_sva_1[52]);
  assign for_qr_52_0_30_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_30_psp_sva_1[52]);
  assign for_qr_52_0_29_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_29_psp_sva_1[52]);
  assign for_qr_52_0_28_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_28_psp_sva_1[52]);
  assign for_qr_52_0_27_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_27_psp_sva_1[52]);
  assign for_qr_52_0_26_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_26_psp_sva_1[52]);
  assign for_qr_52_0_25_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_25_psp_sva_1[52]);
  assign for_qr_52_0_24_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_24_psp_sva_1[52]);
  assign for_qr_52_0_23_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_23_psp_sva_1[52]);
  assign for_qr_52_0_22_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_22_psp_sva_1[52]);
  assign for_qr_52_0_21_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_21_psp_sva_1[52]);
  assign for_qr_52_0_20_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_20_psp_sva_1[52]);
  assign for_qr_52_0_19_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_19_psp_sva_1[52]);
  assign for_qr_52_0_18_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_18_psp_sva_1[52]);
  assign for_qr_52_0_17_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_17_psp_sva_1[52]);
  assign for_qr_52_0_16_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_16_psp_sva_1[52]);
  assign for_qr_52_0_15_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_15_psp_sva_1[52]);
  assign for_qr_52_0_14_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_14_psp_sva_1[52]);
  assign for_qr_52_0_13_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_13_psp_sva_1[52]);
  assign for_qr_52_0_12_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_12_psp_sva_1[52]);
  assign for_qr_52_0_11_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_11_psp_sva_1[52]);
  assign for_qr_52_0_10_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_10_psp_sva_1[52]);
  assign for_qr_52_0_9_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_9_psp_sva_1[52]);
  assign for_qr_52_0_8_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_8_psp_sva_1[52]);
  assign for_qr_52_0_7_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_7_psp_sva_1[52]);
  assign for_qr_52_0_6_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_6_psp_sva_1[52]);
  assign for_qr_52_0_5_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_5_psp_sva_1[52]);
  assign for_qr_52_0_4_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_4_psp_sva_1[52]);
  assign for_qr_52_0_3_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_3_psp_sva_1[52]);
  assign for_qr_52_0_2_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_acc_psp_sva_1[52]);
  assign for_qr_52_0_1_lpi_1_dfm_mx0 = MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
      for_1_acc_1_psp_sva_1[53]);
  always @(posedge ccs_ccore_clk) begin
    if ( ccs_ccore_en ) begin
      exact_rsci_d <= (~((for_acc_55_psp_sva_1[52:0]!=53'b00000000000000000000000000000000000000000000000000000)
          | (for_qr_52_0_lpi_1_dfm_mx0[0]))) | ((for_acc_55_psp_sva_1[52]) & (({(for_acc_55_psp_sva_1[52:0])
          , (for_qr_52_0_lpi_1_dfm_mx0[0])}) == neg_D_sva_1_1));
      quotient_rsci_d_54 <= ~ operator_55_true_slc_for_1_acc_1_psp_53_itm_1;
      quotient_rsci_d_0 <= ~ (for_acc_55_psp_sva_1[53]);
      quotient_rsci_d_53 <= ~ operator_55_true_slc_for_acc_psp_53_itm_1;
      quotient_rsci_d_1 <= ~ (for_acc_54_psp_sva_1[53]);
      quotient_rsci_d_52 <= ~ operator_55_true_slc_for_acc_3_psp_53_itm_1;
      quotient_rsci_d_2 <= ~ (for_acc_53_psp_sva_1[53]);
      quotient_rsci_d_51 <= ~ operator_55_true_slc_for_acc_4_psp_53_itm_1;
      quotient_rsci_d_3 <= ~ (for_acc_52_psp_sva_1[53]);
      quotient_rsci_d_50 <= ~ operator_55_true_slc_for_acc_5_psp_53_itm_1;
      quotient_rsci_d_4 <= ~ (for_acc_51_psp_sva_1[53]);
      quotient_rsci_d_49 <= ~ operator_55_true_slc_for_acc_6_psp_53_itm_1;
      quotient_rsci_d_5 <= ~ (for_acc_50_psp_sva_1_1[53]);
      quotient_rsci_d_48 <= ~ operator_55_true_slc_for_acc_7_psp_53_itm_1;
      quotient_rsci_d_6 <= ~ operator_55_true_slc_for_acc_49_psp_53_itm_1;
      quotient_rsci_d_47 <= ~ operator_55_true_slc_for_acc_8_psp_53_itm_1;
      quotient_rsci_d_7 <= ~ operator_55_true_slc_for_acc_48_psp_53_itm_1;
      quotient_rsci_d_46 <= ~ operator_55_true_slc_for_acc_9_psp_53_itm_1;
      quotient_rsci_d_8 <= ~ operator_55_true_slc_for_acc_47_psp_53_itm_1;
      quotient_rsci_d_45 <= ~ operator_55_true_slc_for_acc_10_psp_53_itm_1;
      quotient_rsci_d_9 <= ~ operator_55_true_slc_for_acc_46_psp_53_itm_1;
      quotient_rsci_d_44 <= ~ operator_55_true_slc_for_acc_11_psp_53_itm_1;
      quotient_rsci_d_10 <= ~ operator_55_true_slc_for_acc_45_psp_53_itm_1;
      quotient_rsci_d_43 <= ~ operator_55_true_slc_for_acc_12_psp_53_itm_1;
      quotient_rsci_d_11 <= ~ operator_55_true_slc_for_acc_44_psp_53_itm_1;
      quotient_rsci_d_42 <= ~ operator_55_true_slc_for_acc_13_psp_53_itm_1;
      quotient_rsci_d_12 <= ~ operator_55_true_slc_for_acc_43_psp_53_itm_1;
      quotient_rsci_d_41 <= ~ operator_55_true_slc_for_acc_14_psp_53_itm_1;
      quotient_rsci_d_13 <= ~ operator_55_true_slc_for_acc_42_psp_53_itm_1;
      quotient_rsci_d_40 <= ~ operator_55_true_slc_for_acc_15_psp_53_itm_1;
      quotient_rsci_d_14 <= ~ operator_55_true_slc_for_acc_41_psp_53_itm_1;
      quotient_rsci_d_39 <= ~ operator_55_true_slc_for_acc_16_psp_53_itm_1;
      quotient_rsci_d_15 <= ~ operator_55_true_slc_for_acc_40_psp_53_itm_1;
      quotient_rsci_d_38 <= ~ operator_55_true_slc_for_acc_17_psp_53_itm_1;
      quotient_rsci_d_16 <= ~ operator_55_true_slc_for_acc_39_psp_53_itm_1;
      quotient_rsci_d_37 <= ~ operator_55_true_slc_for_acc_18_psp_53_itm_1;
      quotient_rsci_d_17 <= ~ operator_55_true_slc_for_acc_38_psp_53_itm_1;
      quotient_rsci_d_36 <= ~ operator_55_true_slc_for_acc_19_psp_53_itm_1;
      quotient_rsci_d_18 <= ~ operator_55_true_slc_for_acc_37_psp_53_itm_1;
      quotient_rsci_d_35 <= ~ operator_55_true_slc_for_acc_20_psp_53_itm_1;
      quotient_rsci_d_19 <= ~ operator_55_true_slc_for_acc_36_psp_53_itm_1;
      quotient_rsci_d_34 <= ~ operator_55_true_slc_for_acc_21_psp_53_itm_1;
      quotient_rsci_d_20 <= ~ operator_55_true_slc_for_acc_35_psp_53_itm_1;
      quotient_rsci_d_33 <= ~ operator_55_true_slc_for_acc_22_psp_53_itm_1;
      quotient_rsci_d_21 <= ~ operator_55_true_slc_for_acc_34_psp_53_itm_1;
      quotient_rsci_d_32 <= ~ operator_55_true_slc_for_acc_23_psp_53_itm_1;
      quotient_rsci_d_22 <= ~ operator_55_true_slc_for_acc_33_psp_53_itm_1;
      quotient_rsci_d_31 <= ~ operator_55_true_slc_for_acc_24_psp_53_itm_1;
      quotient_rsci_d_23 <= ~ operator_55_true_slc_for_acc_32_psp_53_itm_1;
      quotient_rsci_d_30 <= ~ operator_55_true_slc_for_acc_25_psp_53_itm_1;
      quotient_rsci_d_24 <= ~ operator_55_true_slc_for_acc_31_psp_53_itm_1;
      quotient_rsci_d_29 <= ~ operator_55_true_slc_for_acc_26_psp_53_itm_1;
      quotient_rsci_d_25 <= ~ operator_55_true_slc_for_acc_30_psp_53_itm_1;
      quotient_rsci_d_28 <= ~ operator_55_true_slc_for_acc_27_psp_53_itm_1;
      quotient_rsci_d_26 <= ~ operator_55_true_slc_for_acc_29_psp_53_itm_1;
      quotient_rsci_d_27 <= ~ operator_55_true_slc_for_acc_28_psp_53_itm_1;
      neg_D_sva_1_1 <= neg_D_sva_1;
      operator_55_true_slc_for_1_acc_1_psp_53_itm_1 <= for_1_acc_1_psp_sva_1[53];
      operator_55_true_slc_for_acc_psp_53_itm_1 <= for_acc_psp_sva_1[53];
      operator_55_true_slc_for_acc_3_psp_53_itm_1 <= for_acc_3_psp_sva_1[53];
      operator_55_true_slc_for_acc_4_psp_53_itm_1 <= for_acc_4_psp_sva_1[53];
      operator_55_true_slc_for_acc_5_psp_53_itm_1 <= for_acc_5_psp_sva_1[53];
      operator_55_true_slc_for_acc_6_psp_53_itm_1 <= for_acc_6_psp_sva_1[53];
      for_acc_50_psp_sva_1_1 <= for_acc_50_psp_sva_1;
      operator_55_true_slc_for_acc_7_psp_53_itm_1 <= for_acc_7_psp_sva_1[53];
      operator_55_true_slc_for_acc_49_psp_53_itm_1 <= for_acc_49_psp_sva_1[53];
      operator_55_true_slc_for_acc_8_psp_53_itm_1 <= for_acc_8_psp_sva_1[53];
      operator_55_true_slc_for_acc_48_psp_53_itm_1 <= for_acc_48_psp_sva_1[53];
      operator_55_true_slc_for_acc_9_psp_53_itm_1 <= for_acc_9_psp_sva_1[53];
      operator_55_true_slc_for_acc_47_psp_53_itm_1 <= for_acc_47_psp_sva_1[53];
      operator_55_true_slc_for_acc_10_psp_53_itm_1 <= for_acc_10_psp_sva_1[53];
      operator_55_true_slc_for_acc_46_psp_53_itm_1 <= for_acc_46_psp_sva_1[53];
      operator_55_true_slc_for_acc_11_psp_53_itm_1 <= for_acc_11_psp_sva_1[53];
      operator_55_true_slc_for_acc_45_psp_53_itm_1 <= for_acc_45_psp_sva_1[53];
      operator_55_true_slc_for_acc_12_psp_53_itm_1 <= for_acc_12_psp_sva_1[53];
      operator_55_true_slc_for_acc_44_psp_53_itm_1 <= for_acc_44_psp_sva_1[53];
      operator_55_true_slc_for_acc_13_psp_53_itm_1 <= for_acc_13_psp_sva_1[53];
      operator_55_true_slc_for_acc_43_psp_53_itm_1 <= for_acc_43_psp_sva_1[53];
      operator_55_true_slc_for_acc_14_psp_53_itm_1 <= for_acc_14_psp_sva_1[53];
      operator_55_true_slc_for_acc_42_psp_53_itm_1 <= for_acc_42_psp_sva_1[53];
      operator_55_true_slc_for_acc_15_psp_53_itm_1 <= for_acc_15_psp_sva_1[53];
      operator_55_true_slc_for_acc_41_psp_53_itm_1 <= for_acc_41_psp_sva_1[53];
      operator_55_true_slc_for_acc_16_psp_53_itm_1 <= for_acc_16_psp_sva_1[53];
      operator_55_true_slc_for_acc_40_psp_53_itm_1 <= for_acc_40_psp_sva_1[53];
      operator_55_true_slc_for_acc_17_psp_53_itm_1 <= for_acc_17_psp_sva_1[53];
      operator_55_true_slc_for_acc_39_psp_53_itm_1 <= for_acc_39_psp_sva_1[53];
      operator_55_true_slc_for_acc_18_psp_53_itm_1 <= for_acc_18_psp_sva_1[53];
      operator_55_true_slc_for_acc_38_psp_53_itm_1 <= for_acc_38_psp_sva_1[53];
      operator_55_true_slc_for_acc_19_psp_53_itm_1 <= for_acc_19_psp_sva_1[53];
      operator_55_true_slc_for_acc_37_psp_53_itm_1 <= for_acc_37_psp_sva_1[53];
      operator_55_true_slc_for_acc_20_psp_53_itm_1 <= for_acc_20_psp_sva_1[53];
      operator_55_true_slc_for_acc_36_psp_53_itm_1 <= for_acc_36_psp_sva_1[53];
      operator_55_true_slc_for_acc_21_psp_53_itm_1 <= for_acc_21_psp_sva_1[53];
      operator_55_true_slc_for_acc_35_psp_53_itm_1 <= for_acc_35_psp_sva_1[53];
      operator_55_true_slc_for_acc_22_psp_53_itm_1 <= for_acc_22_psp_sva_1[53];
      operator_55_true_slc_for_acc_34_psp_53_itm_1 <= for_acc_34_psp_sva_1[53];
      operator_55_true_slc_for_acc_23_psp_53_itm_1 <= for_acc_23_psp_sva_1[53];
      operator_55_true_slc_for_acc_33_psp_53_itm_1 <= for_acc_33_psp_sva_1[53];
      operator_55_true_slc_for_acc_24_psp_53_itm_1 <= for_acc_24_psp_sva_1[53];
      operator_55_true_slc_for_acc_32_psp_53_itm_1 <= for_acc_32_psp_sva_1[53];
      operator_55_true_slc_for_acc_25_psp_53_itm_1 <= for_acc_25_psp_sva_1[53];
      operator_55_true_slc_for_acc_31_psp_53_itm_1 <= for_acc_31_psp_sva_1[53];
      operator_55_true_slc_for_acc_26_psp_53_itm_1 <= for_acc_26_psp_sva_1[53];
      operator_55_true_slc_for_acc_30_psp_53_itm_1 <= for_acc_30_psp_sva_1[53];
      operator_55_true_slc_for_acc_27_psp_53_itm_1 <= for_acc_27_psp_sva_1[53];
      operator_55_true_slc_for_acc_29_psp_53_itm_1 <= for_acc_29_psp_sva_1[53];
      operator_55_true_slc_for_acc_28_psp_53_itm_1 <= for_acc_28_psp_sva_1[53];
      op2_buf_sva_1 <= op2_rsci_idat;
      for_qr_52_0_50_lpi_1_dfm_1 <= MUX_v_53_2_2((neg_D_sva_1[52:0]), op2_rsci_idat,
          for_acc_50_psp_sva_1[52]);
      for_slc_for_qr_52_0_0_48_itm_1 <= for_qr_52_0_49_lpi_1_dfm_mx0[0];
    end
  end

  function automatic [52:0] MUX_v_53_2_2;
    input [52:0] input_0;
    input [52:0] input_1;
    input  sel;
    reg [52:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_53_2_2 = result;
  end
  endfunction


  function automatic [53:0] conv_s2u_53_54 ;
    input [52:0]  vector ;
  begin
    conv_s2u_53_54 = {vector[52], vector};
  end
  endfunction


  function automatic [53:0] conv_u2s_53_54 ;
    input [52:0]  vector ;
  begin
    conv_u2s_53_54 =  {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    ac_fx_div_53
// ------------------------------------------------------------------


module ac_fx_div_53 (
  op1_rsc_dat, op2_rsc_dat, quotient_rsc_z, exact_rsc_z, ccs_ccore_clk, ccs_ccore_srst,
      ccs_ccore_en
);
  input [52:0] op1_rsc_dat;
  input [52:0] op2_rsc_dat;
  output [54:0] quotient_rsc_z;
  output exact_rsc_z;
  input ccs_ccore_clk;
  input ccs_ccore_srst;
  input ccs_ccore_en;



  // Interconnect Declarations for Component Instantiations 
  ac_fx_div_53_core ac_fx_div_53_core_inst (
      .op1_rsc_dat(op1_rsc_dat),
      .op2_rsc_dat(op2_rsc_dat),
      .quotient_rsc_z(quotient_rsc_z),
      .exact_rsc_z(exact_rsc_z),
      .ccs_ccore_clk(ccs_ccore_clk),
      .ccs_ccore_en(ccs_ccore_en)
    );
endmodule




//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/mgc_shift_l_beh_v5.v 
module mgc_shift_l_v5(a,s,z);
   parameter    width_a = 4;
   parameter    signd_a = 1;
   parameter    width_s = 2;
   parameter    width_z = 8;

   input [width_a-1:0] a;
   input [width_s-1:0] s;
   output [width_z -1:0] z;

   generate
   if (signd_a)
   begin: SGNED
      assign z = fshl_u(a,s,a[width_a-1]);
   end
   else
   begin: UNSGNED
      assign z = fshl_u(a,s,1'b0);
   end
   endgenerate

   //Shift-left - unsigned shift argument one bit more
   function [width_z-1:0] fshl_u_1;
      input [width_a  :0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      parameter olen = width_z;
      parameter ilen = width_a+1;
      parameter len = (ilen >= olen) ? ilen : olen;
      reg [len-1:0] result;
      reg [len-1:0] result_t;
      begin
        result_t = {(len){sbit}};
        result_t[ilen-1:0] = arg1;
        result = result_t <<< arg2;
        fshl_u_1 =  result[olen-1:0];
      end
   endfunction // fshl_u

   //Shift-left - unsigned shift argument
   function [width_z-1:0] fshl_u;
      input [width_a-1:0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      fshl_u = fshl_u_1({sbit,arg1} ,arg2, sbit);
   endfunction // fshl_u

endmodule

//------> /cad/tools/siemens/catapult/Mgc_home/pkgs/siflibs/mgc_shift_br_beh_v5.v 
module mgc_shift_br_v5(a,s,z);
   parameter    width_a = 4;
   parameter    signd_a = 1;
   parameter    width_s = 2;
   parameter    width_z = 8;

   input [width_a-1:0] a;
   input [width_s-1:0] s;
   output [width_z -1:0] z;

   generate
     if (signd_a)
     begin: SGNED
       assign z = fshr_s(a,s,a[width_a-1]);
     end
     else
     begin: UNSGNED
       assign z = fshr_s(a,s,1'b0);
     end
   endgenerate

   //Shift-left - unsigned shift argument one bit more
   function [width_z-1:0] fshl_u_1;
      input [width_a  :0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      parameter olen = width_z;
      parameter ilen = width_a+1;
      parameter len = (ilen >= olen) ? ilen : olen;
      reg [len-1:0] result;
      reg [len-1:0] result_t;
      begin
        result_t = {(len){sbit}};
        result_t[ilen-1:0] = arg1;
        result = result_t <<< arg2;
        fshl_u_1 =  result[olen-1:0];
      end
   endfunction // fshl_u

   //Shift right - unsigned shift argument
   function [width_z-1:0] fshr_u;
      input [width_a-1:0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      parameter olen = width_z;
      parameter ilen = signd_a ? width_a : width_a+1;
      parameter len = (ilen >= olen) ? ilen : olen;
      reg signed [len-1:0] result;
      reg signed [len-1:0] result_t;
      begin
        result_t = $signed( {(len){sbit}} );
        result_t[width_a-1:0] = arg1;
        result = result_t >>> arg2;
        fshr_u =  result[olen-1:0];
      end
   endfunction // fshr_u

   //Shift right - signed shift argument
   function [width_z-1:0] fshr_s;
     input [width_a-1:0] arg1;
     input [width_s-1:0] arg2;
     input sbit;
     begin
       if ( arg2[width_s-1] == 1'b0 )
       begin
         fshr_s = fshr_u(arg1, arg2, sbit);
       end
       else
       begin
         fshr_s = fshl_u_1({arg1, 1'b0},~arg2, sbit);
       end
     end
   endfunction 

endmodule

//------> ../td_ccore_solutions/leading_sign_53_0_abc61df5d0a863e9cd56a6bd95ed6c84a321_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2023.1/1033555 Production Release
//  HLS Date:       Mon Feb 13 11:32:25 PST 2023
// 
//  Generated by:   jmorris@cktcad-c7-x11
//  Generated date: Wed Sep 27 10:29:03 2023
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    leading_sign_53_0
// ------------------------------------------------------------------


module leading_sign_53_0 (
  mantissa, rtn
);
  input [52:0] mantissa;
  output [5:0] rtn;


  // Interconnect Declarations
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_18_3_sdt_3;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_42_4_sdt_4;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_62_3_sdt_3;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_90_5_sdt_5;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_110_3_sdt_3;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_134_4_sdt_4;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_2;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_14_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_34_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_58_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_78_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_106_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_126_2_sdt_1;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_5;
  wire c_h_1_6;
  wire c_h_1_9;
  wire c_h_1_12;
  wire c_h_1_13;
  wire c_h_1_14;
  wire c_h_1_17;
  wire c_h_1_20;
  wire c_h_1_21;
  wire c_h_1_23;
  wire c_h_1_24;
  wire c_h_1_25;

  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_205_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_216_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_1_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_or_3_nl;

  // Interconnect Declarations for Component Instantiations 
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_2
      = ~((mantissa[50:49]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_1
      = ~((mantissa[52:51]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_14_2_sdt_1
      = ~((mantissa[48:47]!=2'b00));
  assign c_h_1_2 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_2;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_18_3_sdt_3
      = (mantissa[46:45]==2'b00) & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_14_2_sdt_1;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_2
      = ~((mantissa[42:41]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_1
      = ~((mantissa[44:43]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_34_2_sdt_1
      = ~((mantissa[40:39]!=2'b00));
  assign c_h_1_5 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_2;
  assign c_h_1_6 = c_h_1_2 & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_18_3_sdt_3;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_42_4_sdt_4
      = (mantissa[38:37]==2'b00) & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_34_2_sdt_1
      & c_h_1_5;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_2
      = ~((mantissa[34:33]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_1
      = ~((mantissa[36:35]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_58_2_sdt_1
      = ~((mantissa[32:31]!=2'b00));
  assign c_h_1_9 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_2;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_62_3_sdt_3
      = (mantissa[30:29]==2'b00) & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_58_2_sdt_1;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_2
      = ~((mantissa[26:25]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_1
      = ~((mantissa[28:27]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_78_2_sdt_1
      = ~((mantissa[24:23]!=2'b00));
  assign c_h_1_12 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_2;
  assign c_h_1_13 = c_h_1_9 & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_62_3_sdt_3;
  assign c_h_1_14 = c_h_1_6 & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_42_4_sdt_4;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_90_5_sdt_5
      = (mantissa[22:21]==2'b00) & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_78_2_sdt_1
      & c_h_1_12 & c_h_1_13;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_2
      = ~((mantissa[18:17]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_1
      = ~((mantissa[20:19]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_106_2_sdt_1
      = ~((mantissa[16:15]!=2'b00));
  assign c_h_1_17 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_2;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_110_3_sdt_3
      = (mantissa[14:13]==2'b00) & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_106_2_sdt_1;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_2
      = ~((mantissa[10:9]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_1
      = ~((mantissa[12:11]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_126_2_sdt_1
      = ~((mantissa[8:7]!=2'b00));
  assign c_h_1_20 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_2;
  assign c_h_1_21 = c_h_1_17 & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_110_3_sdt_3;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_134_4_sdt_4
      = (mantissa[6:5]==2'b00) & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_126_2_sdt_1
      & c_h_1_20;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_2
      = ~((mantissa[2:1]!=2'b00));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_1
      = ~((mantissa[4:3]!=2'b00));
  assign c_h_1_23 = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_1
      & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_2;
  assign c_h_1_24 = c_h_1_21 & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_134_4_sdt_4;
  assign c_h_1_25 = c_h_1_14 & return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_90_5_sdt_5;
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_205_nl
      = c_h_1_14 & (c_h_1_24 | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_90_5_sdt_5));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_nl
      = c_h_1_6 & (c_h_1_13 | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_42_4_sdt_4))
      & (~((~(c_h_1_21 & (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_134_4_sdt_4)))
      & c_h_1_25));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_216_nl
      = c_h_1_2 & (c_h_1_5 | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_18_3_sdt_3))
      & (~((~(c_h_1_9 & (c_h_1_12 | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_62_3_sdt_3))))
      & c_h_1_14)) & (~((~(c_h_1_17 & (c_h_1_20 | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_110_3_sdt_3))
      & (c_h_1_23 | (~ c_h_1_24)))) & c_h_1_25));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_1_nl
      = return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_1
      & (return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_14_2_sdt_1
      | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_6_2_sdt_2))
      & (~((~(return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_1
      & (return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_34_2_sdt_1
      | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_26_2_sdt_2))))
      & c_h_1_6)) & (~((~(return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_1
      & (return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_58_2_sdt_1
      | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_50_2_sdt_2))
      & (~((~(return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_1
      & (return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_78_2_sdt_1
      | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_70_2_sdt_2))))
      & c_h_1_13)))) & c_h_1_14)) & (~((~(return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_1
      & (return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_106_2_sdt_1
      | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_98_2_sdt_2))
      & (~((~(return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_1
      & (return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_126_2_sdt_1
      | (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_118_2_sdt_2))))
      & c_h_1_21)) & (~((~(return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_1
      & (~ return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_wrs_c_142_2_sdt_2)))
      & c_h_1_24)))) & c_h_1_25));
  assign return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_or_3_nl
      = ((~((mantissa[52]) | (~((mantissa[51:50]!=2'b01))))) & (~(((mantissa[48])
      | (~((mantissa[47:46]!=2'b01)))) & c_h_1_2)) & (~((~((~((mantissa[44]) | (~((mantissa[43:42]!=2'b01)))))
      & (~(((mantissa[40]) | (~((mantissa[39:38]!=2'b01)))) & c_h_1_5)))) & c_h_1_6))
      & (~((~((~((mantissa[36]) | (~((mantissa[35:34]!=2'b01))))) & (~(((mantissa[32])
      | (~((mantissa[31:30]!=2'b01)))) & c_h_1_9)) & (~((~((~((mantissa[28]) | (~((mantissa[27:26]!=2'b01)))))
      & (~(((mantissa[24]) | (~((mantissa[23:22]!=2'b01)))) & c_h_1_12)))) & c_h_1_13))))
      & c_h_1_14)) & (~((~((~((mantissa[20]) | (~((mantissa[19:18]!=2'b01))))) &
      (~(((mantissa[16]) | (~((mantissa[15:14]!=2'b01)))) & c_h_1_17)) & (~((~((~((mantissa[12])
      | (~((mantissa[11:10]!=2'b01))))) & (~(((mantissa[8]) | (~((mantissa[7:6]!=2'b01))))
      & c_h_1_20)))) & c_h_1_21)) & (~(((mantissa[4]) | (~((mantissa[3:2]!=2'b01)))
      | c_h_1_23) & c_h_1_24)))) & c_h_1_25))) | ((~ (mantissa[0])) & c_h_1_23 &
      c_h_1_24 & c_h_1_25);
  assign rtn = {c_h_1_25 , return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_205_nl
      , return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_nl
      , return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_216_nl
      , return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_and_1_nl
      , return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_return_mult_generic_AC_RND_CONV_false_if_leading_sign_53_0_rtn_or_3_nl};
endmodule




//------> ../td_ccore_solutions/leading_sign_57_0_1_0_4d5c77e2299ee1ea53a37d5ddfdd9857ab2b_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2023.1/1033555 Production Release
//  HLS Date:       Mon Feb 13 11:32:25 PST 2023
// 
//  Generated by:   jmorris@cktcad-c7-x11
//  Generated date: Thu Feb  1 20:46:27 2024
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    leading_sign_57_0_1_0
// ------------------------------------------------------------------


module leading_sign_57_0_1_0 (
  mantissa, all_same, rtn
);
  input [56:0] mantissa;
  output all_same;
  output [5:0] rtn;


  // Interconnect Declarations
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_18_3_sdt_3;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_42_4_sdt_4;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_62_3_sdt_3;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_90_5_sdt_5;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_110_3_sdt_3;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_134_4_sdt_4;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_2;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_154_3_sdt_3;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_168_6_sdt_6;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_14_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_34_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_58_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_78_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_106_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_126_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_1;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_150_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_5;
  wire c_h_1_6;
  wire c_h_1_9;
  wire c_h_1_12;
  wire c_h_1_13;
  wire c_h_1_14;
  wire c_h_1_17;
  wire c_h_1_20;
  wire c_h_1_21;
  wire c_h_1_24;
  wire c_h_1_25;
  wire c_h_1_26;
  wire c_h_1_27;

  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_and_221_nl;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_and_219_nl;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_and_nl;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_and_1_nl;
  wire return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_or_4_nl;

  // Interconnect Declarations for Component Instantiations 
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_2 = ~((mantissa[54:53]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_1 = ~((mantissa[56:55]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_14_2_sdt_1 = ~((mantissa[52:51]!=2'b00));
  assign c_h_1_2 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_2;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_18_3_sdt_3 = (mantissa[50:49]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_14_2_sdt_1;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_2 = ~((mantissa[46:45]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_1 = ~((mantissa[48:47]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_34_2_sdt_1 = ~((mantissa[44:43]!=2'b00));
  assign c_h_1_5 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_2;
  assign c_h_1_6 = c_h_1_2 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_18_3_sdt_3;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_42_4_sdt_4 = (mantissa[42:41]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_34_2_sdt_1 & c_h_1_5;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_2 = ~((mantissa[38:37]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_1 = ~((mantissa[40:39]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_58_2_sdt_1 = ~((mantissa[36:35]!=2'b00));
  assign c_h_1_9 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_2;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_62_3_sdt_3 = (mantissa[34:33]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_58_2_sdt_1;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_2 = ~((mantissa[30:29]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_1 = ~((mantissa[32:31]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_78_2_sdt_1 = ~((mantissa[28:27]!=2'b00));
  assign c_h_1_12 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_2;
  assign c_h_1_13 = c_h_1_9 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_62_3_sdt_3;
  assign c_h_1_14 = c_h_1_6 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_42_4_sdt_4;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_90_5_sdt_5 = (mantissa[26:25]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_78_2_sdt_1 & c_h_1_12
      & c_h_1_13;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_2 = ~((mantissa[22:21]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_1 = ~((mantissa[24:23]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_106_2_sdt_1 = ~((mantissa[20:19]!=2'b00));
  assign c_h_1_17 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_2;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_110_3_sdt_3 = (mantissa[18:17]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_106_2_sdt_1;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_2 = ~((mantissa[14:13]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_1 = ~((mantissa[16:15]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_126_2_sdt_1 = ~((mantissa[12:11]!=2'b00));
  assign c_h_1_20 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_2;
  assign c_h_1_21 = c_h_1_17 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_110_3_sdt_3;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_134_4_sdt_4 = (mantissa[10:9]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_126_2_sdt_1 & c_h_1_20;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_2 = ~((mantissa[6:5]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_1 = ~((mantissa[8:7]!=2'b00));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_150_2_sdt_1 = ~((mantissa[4:3]!=2'b00));
  assign c_h_1_24 = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_1
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_2;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_154_3_sdt_3 = (mantissa[2:1]==2'b00)
      & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_150_2_sdt_1;
  assign c_h_1_25 = c_h_1_24 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_154_3_sdt_3;
  assign c_h_1_26 = c_h_1_21 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_134_4_sdt_4;
  assign c_h_1_27 = c_h_1_14 & return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_90_5_sdt_5;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_168_6_sdt_6 = (~
      (mantissa[0])) & c_h_1_25 & c_h_1_26 & c_h_1_27;
  assign all_same = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_168_6_sdt_6;
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_and_221_nl = c_h_1_14 &
      (c_h_1_26 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_90_5_sdt_5));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_and_219_nl = c_h_1_6 &
      (c_h_1_13 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_42_4_sdt_4))
      & (~((~(c_h_1_21 & (c_h_1_25 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_134_4_sdt_4))))
      & c_h_1_27));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_and_nl
      = c_h_1_2 & (c_h_1_5 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_18_3_sdt_3))
      & (~((~(c_h_1_9 & (c_h_1_12 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_62_3_sdt_3))))
      & c_h_1_14)) & (~((~(c_h_1_17 & (c_h_1_20 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_110_3_sdt_3))
      & (~((~(c_h_1_24 & (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_154_3_sdt_3)))
      & c_h_1_26)))) & c_h_1_27));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_and_1_nl
      = return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_1 & (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_14_2_sdt_1
      | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_6_2_sdt_2)) & (~((~(return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_1
      & (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_34_2_sdt_1 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_26_2_sdt_2))))
      & c_h_1_6)) & (~((~(return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_1
      & (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_58_2_sdt_1 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_50_2_sdt_2))
      & (~((~(return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_1 &
      (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_78_2_sdt_1 | (~ return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_70_2_sdt_2))))
      & c_h_1_13)))) & c_h_1_14)) & (~((~(return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_1
      & (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_106_2_sdt_1 | (~
      return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_98_2_sdt_2)) & (~((~(return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_1
      & (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_126_2_sdt_1 | (~
      return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_118_2_sdt_2)))) & c_h_1_21))
      & (~((~(return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_1
      & (return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_150_2_sdt_1 | (~
      return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_142_2_sdt_2)) & (~ c_h_1_25)))
      & c_h_1_26)))) & c_h_1_27));
  assign return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_or_4_nl
      = ((~((mantissa[56]) | (~((mantissa[55:54]!=2'b01))))) & (~(((mantissa[52])
      | (~((mantissa[51:50]!=2'b01)))) & c_h_1_2)) & (~((~((~((mantissa[48]) | (~((mantissa[47:46]!=2'b01)))))
      & (~(((mantissa[44]) | (~((mantissa[43:42]!=2'b01)))) & c_h_1_5)))) & c_h_1_6))
      & (~((~((~((mantissa[40]) | (~((mantissa[39:38]!=2'b01))))) & (~(((mantissa[36])
      | (~((mantissa[35:34]!=2'b01)))) & c_h_1_9)) & (~((~((~((mantissa[32]) | (~((mantissa[31:30]!=2'b01)))))
      & (~(((mantissa[28]) | (~((mantissa[27:26]!=2'b01)))) & c_h_1_12)))) & c_h_1_13))))
      & c_h_1_14)) & (~((~((~((mantissa[24]) | (~((mantissa[23:22]!=2'b01))))) &
      (~(((mantissa[20]) | (~((mantissa[19:18]!=2'b01)))) & c_h_1_17)) & (~((~((~((mantissa[16])
      | (~((mantissa[15:14]!=2'b01))))) & (~(((mantissa[12]) | (~((mantissa[11:10]!=2'b01))))
      & c_h_1_20)))) & c_h_1_21)) & (~(((mantissa[8]) | (~((mantissa[7:6]!=2'b01)))
      | (((mantissa[4]) | (~((mantissa[3:2]!=2'b01)))) & c_h_1_24) | c_h_1_25) &
      c_h_1_26)))) & c_h_1_27))) | return_add_generic_AC_RND_CONV_false_ls_all_sign_wrs_c_168_6_sdt_6;
  assign rtn = {c_h_1_27 , return_add_generic_AC_RND_CONV_false_ls_all_sign_and_221_nl
      , return_add_generic_AC_RND_CONV_false_ls_all_sign_and_219_nl , return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_and_nl
      , return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_and_1_nl
      , return_add_generic_AC_RND_CONV_false_ls_all_sign_return_add_generic_AC_RND_CONV_false_ls_all_sign_or_4_nl};
endmodule




//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2023.1/1033555 Production Release
//  HLS Date:       Mon Feb 13 11:32:25 PST 2023
// 
//  Generated by:   jmorris@cktcad-c7-x11
//  Generated date: Tue Apr 23 15:10:07 2024
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    fpu_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module fpu_core_core_fsm (
  clk, rstn, ac_fx_div_53_ccs_ccore_en, fsm_output
);
  input clk;
  input rstn;
  input ac_fx_div_53_ccs_ccore_en;
  output [11:0] fsm_output;
  reg [11:0] fsm_output;


  // FSM State Type Declaration for fpu_core_core_fsm_1
  parameter
    core_rlp_C_0 = 4'd0,
    main_C_0 = 4'd1,
    main_C_1 = 4'd2,
    main_C_2 = 4'd3,
    main_C_3 = 4'd4,
    main_C_4 = 4'd5,
    main_C_5 = 4'd6,
    main_C_6 = 4'd7,
    main_C_7 = 4'd8,
    main_C_8 = 4'd9,
    main_C_9 = 4'd10,
    main_C_10 = 4'd11;

  reg [3:0] state_var;
  reg [3:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : fpu_core_core_fsm_1
    case (state_var)
      main_C_0 : begin
        fsm_output = 12'b000000000010;
        state_var_NS = main_C_1;
      end
      main_C_1 : begin
        fsm_output = 12'b000000000100;
        state_var_NS = main_C_2;
      end
      main_C_2 : begin
        fsm_output = 12'b000000001000;
        state_var_NS = main_C_3;
      end
      main_C_3 : begin
        fsm_output = 12'b000000010000;
        state_var_NS = main_C_4;
      end
      main_C_4 : begin
        fsm_output = 12'b000000100000;
        state_var_NS = main_C_5;
      end
      main_C_5 : begin
        fsm_output = 12'b000001000000;
        state_var_NS = main_C_6;
      end
      main_C_6 : begin
        fsm_output = 12'b000010000000;
        state_var_NS = main_C_7;
      end
      main_C_7 : begin
        fsm_output = 12'b000100000000;
        state_var_NS = main_C_8;
      end
      main_C_8 : begin
        fsm_output = 12'b001000000000;
        state_var_NS = main_C_9;
      end
      main_C_9 : begin
        fsm_output = 12'b010000000000;
        state_var_NS = main_C_10;
      end
      main_C_10 : begin
        fsm_output = 12'b100000000000;
        state_var_NS = main_C_0;
      end
      // core_rlp_C_0
      default : begin
        fsm_output = 12'b000000000001;
        state_var_NS = main_C_0;
      end
    endcase
  end

  always @(posedge clk) begin
    if ( ~ rstn ) begin
      state_var <= core_rlp_C_0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en ) begin
      state_var <= state_var_NS;
    end
  end

endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_staller
// ------------------------------------------------------------------


module fpu_core_staller (
  clk, en, rstn, core_wten, start_synci_wen_comp, ac_fx_div_53_ccs_ccore_en
);
  input clk;
  input en;
  input rstn;
  output core_wten;
  reg core_wten;
  input start_synci_wen_comp;
  output ac_fx_div_53_ccs_ccore_en;



  // Interconnect Declarations for Component Instantiations 
  assign ac_fx_div_53_ccs_ccore_en = start_synci_wen_comp & en;
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      core_wten <= 1'b0;
    end
    else if ( en ) begin
      core_wten <= ~ start_synci_wen_comp;
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_mult_d_triosy_obj_C_mult_d_triosy_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_C_mult_d_triosy_obj_C_mult_d_triosy_wait_ctrl (
  core_wten, C_mult_d_triosy_obj_iswt0, C_mult_d_triosy_obj_biwt
);
  input core_wten;
  input C_mult_d_triosy_obj_iswt0;
  output C_mult_d_triosy_obj_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign C_mult_d_triosy_obj_biwt = (~ core_wten) & C_mult_d_triosy_obj_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_div_d_triosy_obj_C_div_d_triosy_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_C_div_d_triosy_obj_C_div_d_triosy_wait_ctrl (
  core_wten, C_div_d_triosy_obj_iswt0, C_div_d_triosy_obj_biwt
);
  input core_wten;
  input C_div_d_triosy_obj_iswt0;
  output C_div_d_triosy_obj_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign C_div_d_triosy_obj_biwt = (~ core_wten) & C_div_d_triosy_obj_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_sub_d_triosy_obj_C_sub_d_triosy_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_C_sub_d_triosy_obj_C_sub_d_triosy_wait_ctrl (
  core_wten, C_sub_d_triosy_obj_iswt0, C_sub_d_triosy_obj_biwt
);
  input core_wten;
  input C_sub_d_triosy_obj_iswt0;
  output C_sub_d_triosy_obj_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign C_sub_d_triosy_obj_biwt = (~ core_wten) & C_sub_d_triosy_obj_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_add_d_triosy_obj_C_add_d_triosy_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_C_add_d_triosy_obj_C_add_d_triosy_wait_ctrl (
  core_wten, C_add_d_triosy_obj_iswt0, C_add_d_triosy_obj_biwt
);
  input core_wten;
  input C_add_d_triosy_obj_iswt0;
  output C_add_d_triosy_obj_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign C_add_d_triosy_obj_biwt = (~ core_wten) & C_add_d_triosy_obj_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_B_d_triosy_obj_B_d_triosy_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_B_d_triosy_obj_B_d_triosy_wait_ctrl (
  core_wten, B_d_triosy_obj_iswt0, B_d_triosy_obj_biwt
);
  input core_wten;
  input B_d_triosy_obj_iswt0;
  output B_d_triosy_obj_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign B_d_triosy_obj_biwt = (~ core_wten) & B_d_triosy_obj_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_A_d_triosy_obj_A_d_triosy_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_A_d_triosy_obj_A_d_triosy_wait_ctrl (
  core_wten, A_d_triosy_obj_iswt0, A_d_triosy_obj_biwt
);
  input core_wten;
  input A_d_triosy_obj_iswt0;
  output A_d_triosy_obj_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign A_d_triosy_obj_biwt = (~ core_wten) & A_d_triosy_obj_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_start_synci_start_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_start_synci_start_wait_ctrl (
  start_synci_iswt0, start_synci_biwt, start_synci_ivld
);
  input start_synci_iswt0;
  output start_synci_biwt;
  input start_synci_ivld;



  // Interconnect Declarations for Component Instantiations 
  assign start_synci_biwt = start_synci_iswt0 & start_synci_ivld;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_done_synci_done_wait_ctrl
// ------------------------------------------------------------------


module fpu_core_done_synci_done_wait_ctrl (
  core_wten, done_synci_iswt0, done_synci_biwt
);
  input core_wten;
  input done_synci_iswt0;
  output done_synci_biwt;



  // Interconnect Declarations for Component Instantiations 
  assign done_synci_biwt = (~ core_wten) & done_synci_iswt0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_mult_d_triosy_obj
// ------------------------------------------------------------------


module fpu_core_C_mult_d_triosy_obj (
  C_mult_d_triosy_lz, core_wten, C_mult_d_triosy_obj_iswt0
);
  output C_mult_d_triosy_lz;
  input core_wten;
  input C_mult_d_triosy_obj_iswt0;


  // Interconnect Declarations
  wire C_mult_d_triosy_obj_biwt;


  // Interconnect Declarations for Component Instantiations 
  mgc_io_sync_v2 #(.valid(32'sd0)) C_mult_d_triosy_obj (
      .ld(C_mult_d_triosy_obj_biwt),
      .lz(C_mult_d_triosy_lz)
    );
  fpu_core_C_mult_d_triosy_obj_C_mult_d_triosy_wait_ctrl fpu_core_C_mult_d_triosy_obj_C_mult_d_triosy_wait_ctrl_inst
      (
      .core_wten(core_wten),
      .C_mult_d_triosy_obj_iswt0(C_mult_d_triosy_obj_iswt0),
      .C_mult_d_triosy_obj_biwt(C_mult_d_triosy_obj_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_div_d_triosy_obj
// ------------------------------------------------------------------


module fpu_core_C_div_d_triosy_obj (
  C_div_d_triosy_lz, core_wten, C_div_d_triosy_obj_iswt0
);
  output C_div_d_triosy_lz;
  input core_wten;
  input C_div_d_triosy_obj_iswt0;


  // Interconnect Declarations
  wire C_div_d_triosy_obj_biwt;


  // Interconnect Declarations for Component Instantiations 
  mgc_io_sync_v2 #(.valid(32'sd0)) C_div_d_triosy_obj (
      .ld(C_div_d_triosy_obj_biwt),
      .lz(C_div_d_triosy_lz)
    );
  fpu_core_C_div_d_triosy_obj_C_div_d_triosy_wait_ctrl fpu_core_C_div_d_triosy_obj_C_div_d_triosy_wait_ctrl_inst
      (
      .core_wten(core_wten),
      .C_div_d_triosy_obj_iswt0(C_div_d_triosy_obj_iswt0),
      .C_div_d_triosy_obj_biwt(C_div_d_triosy_obj_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_sub_d_triosy_obj
// ------------------------------------------------------------------


module fpu_core_C_sub_d_triosy_obj (
  C_sub_d_triosy_lz, core_wten, C_sub_d_triosy_obj_iswt0
);
  output C_sub_d_triosy_lz;
  input core_wten;
  input C_sub_d_triosy_obj_iswt0;


  // Interconnect Declarations
  wire C_sub_d_triosy_obj_biwt;


  // Interconnect Declarations for Component Instantiations 
  mgc_io_sync_v2 #(.valid(32'sd0)) C_sub_d_triosy_obj (
      .ld(C_sub_d_triosy_obj_biwt),
      .lz(C_sub_d_triosy_lz)
    );
  fpu_core_C_sub_d_triosy_obj_C_sub_d_triosy_wait_ctrl fpu_core_C_sub_d_triosy_obj_C_sub_d_triosy_wait_ctrl_inst
      (
      .core_wten(core_wten),
      .C_sub_d_triosy_obj_iswt0(C_sub_d_triosy_obj_iswt0),
      .C_sub_d_triosy_obj_biwt(C_sub_d_triosy_obj_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_C_add_d_triosy_obj
// ------------------------------------------------------------------


module fpu_core_C_add_d_triosy_obj (
  C_add_d_triosy_lz, core_wten, C_add_d_triosy_obj_iswt0
);
  output C_add_d_triosy_lz;
  input core_wten;
  input C_add_d_triosy_obj_iswt0;


  // Interconnect Declarations
  wire C_add_d_triosy_obj_biwt;


  // Interconnect Declarations for Component Instantiations 
  mgc_io_sync_v2 #(.valid(32'sd0)) C_add_d_triosy_obj (
      .ld(C_add_d_triosy_obj_biwt),
      .lz(C_add_d_triosy_lz)
    );
  fpu_core_C_add_d_triosy_obj_C_add_d_triosy_wait_ctrl fpu_core_C_add_d_triosy_obj_C_add_d_triosy_wait_ctrl_inst
      (
      .core_wten(core_wten),
      .C_add_d_triosy_obj_iswt0(C_add_d_triosy_obj_iswt0),
      .C_add_d_triosy_obj_biwt(C_add_d_triosy_obj_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_B_d_triosy_obj
// ------------------------------------------------------------------


module fpu_core_B_d_triosy_obj (
  B_d_triosy_lz, core_wten, B_d_triosy_obj_iswt0
);
  output B_d_triosy_lz;
  input core_wten;
  input B_d_triosy_obj_iswt0;


  // Interconnect Declarations
  wire B_d_triosy_obj_biwt;


  // Interconnect Declarations for Component Instantiations 
  mgc_io_sync_v2 #(.valid(32'sd0)) B_d_triosy_obj (
      .ld(B_d_triosy_obj_biwt),
      .lz(B_d_triosy_lz)
    );
  fpu_core_B_d_triosy_obj_B_d_triosy_wait_ctrl fpu_core_B_d_triosy_obj_B_d_triosy_wait_ctrl_inst
      (
      .core_wten(core_wten),
      .B_d_triosy_obj_iswt0(B_d_triosy_obj_iswt0),
      .B_d_triosy_obj_biwt(B_d_triosy_obj_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_A_d_triosy_obj
// ------------------------------------------------------------------


module fpu_core_A_d_triosy_obj (
  A_d_triosy_lz, core_wten, A_d_triosy_obj_iswt0
);
  output A_d_triosy_lz;
  input core_wten;
  input A_d_triosy_obj_iswt0;


  // Interconnect Declarations
  wire A_d_triosy_obj_biwt;


  // Interconnect Declarations for Component Instantiations 
  mgc_io_sync_v2 #(.valid(32'sd0)) A_d_triosy_obj (
      .ld(A_d_triosy_obj_biwt),
      .lz(A_d_triosy_lz)
    );
  fpu_core_A_d_triosy_obj_A_d_triosy_wait_ctrl fpu_core_A_d_triosy_obj_A_d_triosy_wait_ctrl_inst
      (
      .core_wten(core_wten),
      .A_d_triosy_obj_iswt0(A_d_triosy_obj_iswt0),
      .A_d_triosy_obj_biwt(A_d_triosy_obj_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_start_synci
// ------------------------------------------------------------------


module fpu_core_start_synci (
  start_sync_rdy, start_sync_vld, start_synci_oswt, start_synci_wen_comp
);
  output start_sync_rdy;
  input start_sync_vld;
  input start_synci_oswt;
  output start_synci_wen_comp;


  // Interconnect Declarations
  wire start_synci_biwt;
  wire start_synci_ivld;


  // Interconnect Declarations for Component Instantiations 
  ccs_sync_in_wait_v1 #(.rscid(32'sd13)) start_synci (
      .vld(start_sync_vld),
      .rdy(start_sync_rdy),
      .ivld(start_synci_ivld),
      .irdy(start_synci_oswt)
    );
  fpu_core_start_synci_start_wait_ctrl fpu_core_start_synci_start_wait_ctrl_inst
      (
      .start_synci_iswt0(start_synci_oswt),
      .start_synci_biwt(start_synci_biwt),
      .start_synci_ivld(start_synci_ivld)
    );
  assign start_synci_wen_comp = (~ start_synci_oswt) | start_synci_biwt;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core_done_synci
// ------------------------------------------------------------------


module fpu_core_done_synci (
  done_sync_vld, core_wten, done_synci_iswt0
);
  output done_sync_vld;
  input core_wten;
  input done_synci_iswt0;


  // Interconnect Declarations
  wire done_synci_biwt;


  // Interconnect Declarations for Component Instantiations 
  ccs_sync_out_vld_v1 #(.rscid(32'sd12)) done_synci (
      .vld(done_sync_vld),
      .ivld(done_synci_biwt)
    );
  fpu_core_done_synci_done_wait_ctrl fpu_core_done_synci_done_wait_ctrl_inst (
      .core_wten(core_wten),
      .done_synci_iswt0(done_synci_iswt0),
      .done_synci_biwt(done_synci_biwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu_core
// ------------------------------------------------------------------


module fpu_core (
  clk, en, rstn, A_d_rsc_dat, A_d_triosy_lz, B_d_rsc_dat, B_d_triosy_lz, C_add_d_rsc_dat,
      C_add_d_triosy_lz, C_sub_d_rsc_dat, C_sub_d_triosy_lz, C_div_d_rsc_dat, C_div_d_triosy_lz,
      C_mult_d_rsc_dat, C_mult_d_triosy_lz, done_sync_vld, start_sync_rdy, start_sync_vld
);
  input clk;
  input en;
  input rstn;
  input [63:0] A_d_rsc_dat;
  output A_d_triosy_lz;
  input [63:0] B_d_rsc_dat;
  output B_d_triosy_lz;
  output [63:0] C_add_d_rsc_dat;
  output C_add_d_triosy_lz;
  output [63:0] C_sub_d_rsc_dat;
  output C_sub_d_triosy_lz;
  output [63:0] C_div_d_rsc_dat;
  output C_div_d_triosy_lz;
  output [63:0] C_mult_d_rsc_dat;
  output C_mult_d_triosy_lz;
  output done_sync_vld;
  output start_sync_rdy;
  input start_sync_vld;


  // Interconnect Declarations
  wire core_wten;
  wire [63:0] A_d_rsci_idat;
  wire [63:0] B_d_rsci_idat;
  wire start_synci_wen_comp;
  reg C_add_d_triosy_obj_iswt0;
  reg C_sub_d_triosy_obj_iswt0;
  reg C_mult_d_triosy_obj_iswt0;
  wire [54:0] ac_fx_div_53_cmp_quotient_rsc_z;
  wire ac_fx_div_53_cmp_exact_rsc_z;
  wire ac_fx_div_53_ccs_ccore_en;
  reg C_add_d_rsci_idat_63;
  reg [9:0] C_add_d_rsci_idat_62_53;
  reg C_add_d_rsci_idat_52;
  reg C_add_d_rsci_idat_51;
  reg [50:0] C_add_d_rsci_idat_50_0;
  reg C_sub_d_rsci_idat_63;
  reg [9:0] C_sub_d_rsci_idat_62_53;
  reg C_sub_d_rsci_idat_52;
  reg C_sub_d_rsci_idat_51;
  reg [50:0] C_sub_d_rsci_idat_50_0;
  reg C_div_d_rsci_idat_63;
  reg [10:0] C_div_d_rsci_idat_62_52;
  reg C_div_d_rsci_idat_51;
  reg [50:0] C_div_d_rsci_idat_50_0;
  reg C_mult_d_rsci_idat_63;
  reg [10:0] C_mult_d_rsci_idat_62_52;
  reg C_mult_d_rsci_idat_51;
  reg [50:0] C_mult_d_rsci_idat_50_0;
  wire [11:0] fsm_output;
  wire return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aif_return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aelse_and_tmp;
  wire return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp;
  wire [12:0] operator_6_false_4_acc_tmp;
  wire [13:0] nl_operator_6_false_4_acc_tmp;
  wire return_add_generic_AC_RND_CONV_false_1_aif_equal_tmp;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp;
  wire return_add_generic_AC_RND_CONV_false_e1_eq_e2_equal_tmp;
  wire return_extract_return_extract_or_1_tmp;
  wire and_dcpl_28;
  wire and_dcpl_46;
  wire or_dcpl_33;
  wire and_dcpl_52;
  wire or_dcpl_41;
  wire or_tmp_43;
  wire or_tmp_44;
  wire or_tmp_64;
  wire or_tmp_65;
  wire return_div_generic_AC_RND_CONV_false_exception_sva_1;
  reg return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva;
  reg return_add_generic_AC_RND_CONV_false_op1_nan_sva;
  reg operator_11_true_return_1_sva;
  reg return_extract_m_zero_sva;
  wire return_mult_generic_AC_RND_CONV_false_exp_ovf_lor_lpi_1_dfm_2;
  wire return_mult_generic_AC_RND_CONV_false_zero_m_lor_sva_1;
  wire return_mult_generic_AC_RND_CONV_false_lor_lpi_1_dfm_1;
  reg return_add_generic_AC_RND_CONV_false_op2_inf_sva;
  reg return_add_generic_AC_RND_CONV_false_1_do_sub_sva;
  reg operator_11_true_return_sva;
  reg [11:0] return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva;
  wire [12:0] nl_return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva;
  reg return_mult_generic_AC_RND_CONV_false_do_shift_left_1_sva;
  wire return_mult_generic_AC_RND_CONV_false_if_1_aelse_return_mult_generic_AC_RND_CONV_false_if_1_aelse_or_2;
  reg [105:0] return_mult_generic_AC_RND_CONV_false_p_1_sva;
  reg [5:0] return_add_generic_AC_RND_CONV_false_1_e_dif_sat_sva;
  reg return_add_generic_AC_RND_CONV_false_op2_nan_sva;
  wire return_add_generic_AC_RND_CONV_false_op1_inf_sva_mx0w1;
  wire return_add_generic_AC_RND_CONV_false_op2_inf_sva_mx0w1;
  wire return_add_generic_AC_RND_CONV_false_1_exception_sva_1;
  reg return_add_generic_AC_RND_CONV_false_1_else_4_unequal_tmp;
  reg return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva;
  reg return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_cse_sva;
  wire return_add_generic_AC_RND_CONV_false_exception_sva_1;
  wire return_add_generic_AC_RND_CONV_false_op1_nan_sva_mx0w2;
  wire return_add_generic_AC_RND_CONV_false_op2_nan_sva_mx0w1;
  reg return_add_generic_AC_RND_CONV_false_else_4_unequal_tmp;
  wire return_mult_generic_AC_RND_CONV_false_if_nor_ovfl_sva_1;
  wire [12:0] operator_33_true_acc_psp_sva_1;
  wire [13:0] nl_operator_33_true_acc_psp_sva_1;
  wire [10:0] drf_qr_lval_smx_lpi_1_dfm_mx0;
  wire return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0;
  wire [11:0] return_add_generic_AC_RND_CONV_false_e_dif_qr_lpi_1_dfm_mx0;
  reg [12:0] operator_14_false_acc_psp_sva;
  reg [12:0] operator_33_true_2_acc_psp_sva;
  wire [10:0] return_add_generic_AC_RND_CONV_false_1_e_dif_qr_lpi_1_dfm_mx0_10_0;
  reg return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11;
  reg [9:0] return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_9_0;
  wire return_mult_generic_AC_RND_CONV_false_exp_and_ssc;
  reg return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_11;
  reg [10:0] return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0;
  wire operator_53_false_5_and_ssc;
  reg reg_start_synci_oswt_cse;
  reg reg_A_d_triosy_obj_iswt0_cse;
  reg reg_done_synci_iswt0_cse;
  wire and_340_cse;
  wire and_345_cse;
  wire return_add_generic_AC_RND_CONV_false_1_op_bigger_and_cse;
  wire return_extract_m_zero_and_cse;
  wire operator_53_false_mux_cse;
  wire operator_53_false_1_mux_cse;
  wire [50:0] operator_53_false_mux_2_cse;
  wire [50:0] operator_53_false_1_mux_2_cse;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_2_cse;
  wire return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_and_1_cse;
  wire return_mult_generic_AC_RND_CONV_false_return_mult_generic_AC_RND_CONV_false_nor_ssc;
  wire return_mult_generic_AC_RND_CONV_false_and_2_ssc;
  wire [11:0] return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse;
  wire [12:0] nl_return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse;
  wire B_to_helper_t_x_d_and_cse;
  reg [1:0] operator_53_false_4_lshift_itm_52_51;
  reg [50:0] operator_53_false_4_lshift_itm_50_0;
  reg [1:0] operator_53_false_5_lshift_itm_52_51;
  reg [50:0] operator_53_false_5_lshift_itm_50_0;
  wire return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0;
  wire and_295_cse;
  wire [55:0] operator_57_true_lshift_itm;
  wire [52:0] return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm;
  wire [55:0] operator_56_false_1_lshift_itm;
  wire [11:0] z_out_1;
  wire [12:0] z_out_2;
  wire [5:0] z_out_3;
  wire [6:0] nl_z_out_3;
  wire [12:0] z_out_4;
  wire [56:0] z_out_5;
  wire [105:0] z_out_6;
  wire [11:0] z_out_7;
  wire [12:0] nl_z_out_7;
  wire [52:0] z_out_8;
  wire [56:0] z_out_9;
  wire [12:0] z_out_10;
  wire [12:0] z_out_11;
  wire [13:0] nl_z_out_11;
  wire [5:0] rtn_out;
  wire all_same_out;
  wire [5:0] rtn_out_1;
  reg return_extract_return_extract_or_1_cse_sva;
  reg return_extract_1_return_extract_1_or_1_cse_sva;
  reg return_add_generic_AC_RND_CONV_false_do_sub_sva;
  reg return_add_generic_AC_RND_CONV_false_e_r_qelse_or_svs;
  reg return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_52_lpi_1_dfm;
  reg return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_0_lpi_1_dfm;
  reg [11:0] return_add_generic_AC_RND_CONV_false_1_exp_plus_1_12_1_lpi_1_dfm;
  reg return_add_generic_AC_RND_CONV_false_1_exp_plus_1_0_lpi_1_dfm;
  reg return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva;
  reg [3:0] return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_4_1_sva;
  reg return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva;
  reg [5:0] return_div_generic_AC_RND_CONV_false_ls_op1_5_0_sva;
  reg [5:0] return_div_generic_AC_RND_CONV_false_ls_op2_5_0_sva;
  reg [12:0] operator_34_true_acc_psp_sva;
  reg return_add_generic_AC_RND_CONV_false_1_op_bigger_mux_1_itm;
  reg return_add_generic_AC_RND_CONV_false_1_op_bigger_mux_3_itm;
  reg [5:0] return_add_generic_AC_RND_CONV_false_1_mux_4_itm;
  reg return_add_generic_AC_RND_CONV_false_1_mux_itm;
  reg [51:0] return_mult_generic_AC_RND_CONV_false_if_mux_1_itm;
  reg return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_or_itm;
  reg [11:0] return_div_generic_AC_RND_CONV_false_exp_acc_itm;
  reg [54:0] return_div_generic_AC_RND_CONV_false_if_1_slc_operator_57_true_return_55_0_55_1_itm;
  wire return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1;
  wire return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1;
  wire return_add_generic_AC_RND_CONV_false_op_smaller_qr_52_lpi_1_dfm_mx0;
  wire [50:0] return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0;
  wire return_add_generic_AC_RND_CONV_false_op_smaller_qr_0_lpi_1_dfm_mx0;
  wire return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2;
  wire return_add_generic_AC_RND_CONV_false_res_mant_3_0_sva_1;
  wire return_extract_1_return_extract_1_or_1_cse_sva_mx0w0;
  wire [5:0] return_add_generic_AC_RND_CONV_false_e_dif_sat_sva_1;
  wire return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva_1;
  wire [11:0] return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_mx0w1;
  wire [9:0] return_add_generic_AC_RND_CONV_false_e_r_qelse_qr_10_1_lpi_1_dfm_1;
  wire return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva_1;
  wire [51:0] return_add_generic_AC_RND_CONV_false_res_rounded_lpi_1_dfm_51_0_1;
  wire return_add_generic_AC_RND_CONV_false_1_res_mant_3_0_sva_1;
  wire return_mult_generic_AC_RND_CONV_false_e_incr_lpi_1_dfm_2;
  wire return_mult_generic_AC_RND_CONV_false_if_1_and_1_tmp_1;
  wire [55:0] return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0;
  wire [54:0] return_div_generic_AC_RND_CONV_false_if_1_and_psp_sva_1;
  wire return_add_generic_AC_RND_CONV_false_mux_31;
  reg [62:0] A_to_helper_t_x_d_sva_62_0;
  reg [51:0] B_to_helper_t_x_d_sva_51_0;
  reg return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_56;
  reg [55:0] return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0;
  wire [50:0] return_mult_generic_AC_RND_CONV_false_res_bef_rnd_3_53_1_lpi_1_dfm_1_50_0;
  wire [55:0] return_add_generic_AC_RND_CONV_false_res_mant_conc_2_itm_56_1;
  wire and_350_cse;
  wire and_354_cse;
  wire return_extract_m_zero_or_cse;
  wire nor_11_cse;
  wire or_203_cse;
  wire operator_53_false_4_nor_cse;
  wire return_add_generic_AC_RND_CONV_false_nor_1_cse;
  wire return_add_generic_AC_RND_CONV_false_res_mant_or_cse;
  wire return_div_generic_AC_RND_CONV_false_if_1_nor_cse;
  wire return_div_generic_AC_RND_CONV_false_r_inf_acc_itm_12_1;
  wire return_div_generic_AC_RND_CONV_false_exp_and_1_cse;
  wire [11:0] z_out_11_0;

  wire return_add_generic_AC_RND_CONV_false_1_e_r_qelse_mux_1_nl;
  wire return_add_generic_AC_RND_CONV_false_r_nan_or_1_nl;
  wire and_89_nl;
  wire return_add_generic_AC_RND_CONV_false_if_7_return_add_generic_AC_RND_CONV_false_if_7_nor_nl;
  wire return_add_generic_AC_RND_CONV_false_1_r_nan_or_1_nl;
  wire and_103_nl;
  wire return_add_generic_AC_RND_CONV_false_1_if_7_return_add_generic_AC_RND_CONV_false_1_if_7_nor_nl;
  wire and_115_nl;
  wire[10:0] return_mult_generic_AC_RND_CONV_false_else_2_else_return_mult_generic_AC_RND_CONV_false_else_2_else_and_nl;
  wire[10:0] return_mult_generic_AC_RND_CONV_false_else_2_else_else_mux_nl;
  wire return_mult_generic_AC_RND_CONV_false_zero_m_oelse_not_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_2_return_mult_generic_AC_RND_CONV_false_if_2_or_nl;
  wire return_mult_generic_AC_RND_CONV_false_oelse_4_return_mult_generic_AC_RND_CONV_false_if_3_nor_nl;
  wire and_127_nl;
  wire[10:0] return_div_generic_AC_RND_CONV_false_e_r_qelse_return_div_generic_AC_RND_CONV_false_e_r_qelse_and_nl;
  wire return_div_generic_AC_RND_CONV_false_e_r_qelse_return_div_generic_AC_RND_CONV_false_e_r_qelse_nor_nl;
  wire return_div_generic_AC_RND_CONV_false_if_3_return_div_generic_AC_RND_CONV_false_if_3_nor_nl;
  wire return_add_generic_AC_RND_CONV_false_1_if_2_return_add_generic_AC_RND_CONV_false_1_if_2_nor_1_nl;
  wire return_add_generic_AC_RND_CONV_false_1_r_sign_mux_1_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_not_nl;
  wire return_add_generic_AC_RND_CONV_false_1_do_sub_return_add_generic_AC_RND_CONV_false_1_do_sub_return_add_generic_AC_RND_CONV_false_1_do_sub_xnor_nl;
  wire return_mult_generic_AC_RND_CONV_false_r_nan_or_nl;
  wire and_221_nl;
  wire[5:0] return_add_generic_AC_RND_CONV_false_1_e_dif_sat_or_nl;
  wire return_add_generic_AC_RND_CONV_false_1_e_dif_sat_or_1_nl;
  wire return_add_generic_AC_RND_CONV_false_1_e_dif_sat_and_nl;
  wire return_add_generic_AC_RND_CONV_false_1_e_dif_sat_and_1_nl;
  wire return_extract_m_zero_return_extract_m_zero_nor_nl;
  wire return_extract_5_and_nl;
  wire operator_11_true_1_operator_11_true_1_and_nl;
  wire operator_11_true_operator_11_true_and_nl;
  wire return_extract_4_and_nl;
  wire return_div_generic_AC_RND_CONV_false_r_zero_or_nl;
  wire return_add_generic_AC_RND_CONV_false_if_2_return_add_generic_AC_RND_CONV_false_if_2_and_2_nl;
  wire return_div_generic_AC_RND_CONV_false_r_nan_or_nl;
  wire return_add_generic_AC_RND_CONV_false_if_2_and_nl;
  wire return_add_generic_AC_RND_CONV_false_if_2_and_1_nl;
  wire return_extract_1_m_zero_return_extract_1_m_zero_nor_nl;
  wire return_add_generic_AC_RND_CONV_false_or_nl;
  wire and_291_nl;
  wire nor_30_nl;
  wire return_add_generic_AC_RND_CONV_false_res_mant_and_nl;
  wire return_add_generic_AC_RND_CONV_false_res_mant_and_1_nl;
  wire return_add_generic_AC_RND_CONV_false_mux_28_nl;
  wire return_add_generic_AC_RND_CONV_false_if_5_or_2_nl;
  wire return_add_generic_AC_RND_CONV_false_e_dif_sat_or_1_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_if_not_nl;
  wire[9:0] mux_12_nl;
  wire and_363_nl;
  wire not_144_nl;
  wire return_add_generic_AC_RND_CONV_false_not_5_nl;
  wire[12:0] return_div_generic_AC_RND_CONV_false_r_inf_acc_nl;
  wire[13:0] nl_return_div_generic_AC_RND_CONV_false_r_inf_acc_nl;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_8_nl;
  wire[12:0] acc_nl;
  wire[13:0] nl_acc_nl;
  wire return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_and_1_nl;
  wire[10:0] return_div_generic_AC_RND_CONV_false_if_1_mux1h_5_nl;
  wire[3:0] return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_or_2_nl;
  wire[5:0] return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_mux_1_nl;
  wire[12:0] acc_1_nl;
  wire[13:0] nl_acc_1_nl;
  wire[4:0] return_add_generic_AC_RND_CONV_false_e_dif1_mux_4_nl;
  wire[5:0] return_add_generic_AC_RND_CONV_false_e_dif1_mux_5_nl;
  wire return_add_generic_AC_RND_CONV_false_e_dif1_or_1_nl;
  wire[10:0] return_add_generic_AC_RND_CONV_false_e_dif1_mux_6_nl;
  wire[13:0] acc_2_nl;
  wire[14:0] nl_acc_2_nl;
  wire return_mult_generic_AC_RND_CONV_false_exp_return_mult_generic_AC_RND_CONV_false_exp_and_1_nl;
  wire[10:0] return_mult_generic_AC_RND_CONV_false_exp_mux_3_nl;
  wire return_mult_generic_AC_RND_CONV_false_exp_and_6_nl;
  wire[11:0] return_mult_generic_AC_RND_CONV_false_exp_mux_4_nl;
  wire[11:0] return_mult_generic_AC_RND_CONV_false_exp_acc_2_nl;
  wire[12:0] nl_return_mult_generic_AC_RND_CONV_false_exp_acc_2_nl;
  wire[13:0] acc_4_nl;
  wire[14:0] nl_acc_4_nl;
  wire[10:0] return_div_generic_AC_RND_CONV_false_exp_mux_3_nl;
  wire return_div_generic_AC_RND_CONV_false_exp_and_2_nl;
  wire return_div_generic_AC_RND_CONV_false_exp_return_div_generic_AC_RND_CONV_false_exp_and_1_nl;
  wire[4:0] return_div_generic_AC_RND_CONV_false_exp_mux_4_nl;
  wire return_div_generic_AC_RND_CONV_false_exp_mux_5_nl;
  wire[11:0] return_add_generic_AC_RND_CONV_false_if_4_mux1h_2_nl;
  wire[53:0] acc_6_nl;
  wire[54:0] nl_acc_6_nl;
  wire[1:0] return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux1h_1_nl;
  wire return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_3_nl;
  wire return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_4_nl;
  wire return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_5_nl;
  wire[49:0] return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux_5_nl;
  wire return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_or_1_nl;
  wire[50:0] return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_nor_1_nl;
  wire return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux_6_nl;
  wire return_mult_generic_AC_RND_CONV_false_and_3_nl;
  wire return_mult_generic_AC_RND_CONV_false_mux_14_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_1_or_1_nl;
  wire[57:0] acc_7_nl;
  wire[58:0] nl_acc_7_nl;
  wire[3:0] return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_17_nl;
  wire[3:0] return_add_generic_AC_RND_CONV_false_mux_38_nl;
  wire[51:0] return_add_generic_AC_RND_CONV_false_mux1h_7_nl;
  wire return_add_generic_AC_RND_CONV_false_mux1h_8_nl;
  wire return_add_generic_AC_RND_CONV_false_and_7_nl;
  wire return_add_generic_AC_RND_CONV_false_and_8_nl;
  wire return_add_generic_AC_RND_CONV_false_and_9_nl;
  wire return_add_generic_AC_RND_CONV_false_and_10_nl;
  wire return_add_generic_AC_RND_CONV_false_and_11_nl;
  wire return_add_generic_AC_RND_CONV_false_mux_39_nl;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_18_nl;
  wire return_add_generic_AC_RND_CONV_false_mux_40_nl;
  wire return_add_generic_AC_RND_CONV_false_op_bigger_mux_6_nl;
  wire[50:0] return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_19_nl;
  wire[50:0] return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_mux1h_1_nl;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_nor_1_nl;
  wire return_add_generic_AC_RND_CONV_false_and_12_nl;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_20_nl;
  wire return_add_generic_AC_RND_CONV_false_mux_41_nl;
  wire return_add_generic_AC_RND_CONV_false_op_bigger_mux_7_nl;
  wire return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_21_nl;
  wire return_add_generic_AC_RND_CONV_false_mux_42_nl;
  wire return_add_generic_AC_RND_CONV_false_res_rounded_and_3_nl;
  wire return_div_generic_AC_RND_CONV_false_r_rnd_and_1_nl;
  wire return_div_generic_AC_RND_CONV_false_mux_8_nl;
  wire return_div_generic_AC_RND_CONV_false_if_1_or_4_nl;
  wire[13:0] acc_8_nl;
  wire[14:0] nl_acc_8_nl;
  wire[12:0] return_mult_generic_AC_RND_CONV_false_if_mux_4_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_or_6_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_return_mult_generic_AC_RND_CONV_false_if_or_1_nl;
  wire[11:0] operator_33_true_1_operator_33_true_1_operator_33_true_1_mux1h_1_nl;
  wire operator_33_true_1_and_2_nl;
  wire operator_33_true_1_and_3_nl;
  wire operator_33_true_1_operator_33_true_1_mux_2_nl;
  wire return_div_generic_AC_RND_CONV_false_return_div_generic_AC_RND_CONV_false_or_1_nl;
  wire operator_33_true_1_operator_33_true_1_or_1_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [63:0] nl_C_add_d_rsci_idat;
  assign nl_C_add_d_rsci_idat = {C_add_d_rsci_idat_63 , C_add_d_rsci_idat_62_53 ,
      C_add_d_rsci_idat_52 , C_add_d_rsci_idat_51 , C_add_d_rsci_idat_50_0};
  wire [63:0] nl_C_sub_d_rsci_idat;
  assign nl_C_sub_d_rsci_idat = {C_sub_d_rsci_idat_63 , C_sub_d_rsci_idat_62_53 ,
      C_sub_d_rsci_idat_52 , C_sub_d_rsci_idat_51 , C_sub_d_rsci_idat_50_0};
  wire [63:0] nl_C_div_d_rsci_idat;
  assign nl_C_div_d_rsci_idat = {C_div_d_rsci_idat_63 , C_div_d_rsci_idat_62_52 ,
      C_div_d_rsci_idat_51 , C_div_d_rsci_idat_50_0};
  wire [63:0] nl_C_mult_d_rsci_idat;
  assign nl_C_mult_d_rsci_idat = {C_mult_d_rsci_idat_63 , C_mult_d_rsci_idat_62_52
      , C_mult_d_rsci_idat_51 , C_mult_d_rsci_idat_50_0};
  wire [52:0] nl_ac_fx_div_53_cmp_op1_rsc_dat;
  assign nl_ac_fx_div_53_cmp_op1_rsc_dat = {operator_53_false_4_lshift_itm_52_51
      , operator_53_false_4_lshift_itm_50_0};
  wire [52:0] nl_ac_fx_div_53_cmp_op2_rsc_dat;
  assign nl_ac_fx_div_53_cmp_op2_rsc_dat = {operator_53_false_5_lshift_itm_52_51
      , operator_53_false_5_lshift_itm_50_0};
  wire [10:0] nl_operator_57_true_lshift_rg_s;
  assign nl_operator_57_true_lshift_rg_s = {(z_out_7[9:0]) , (~ (z_out_2[0]))};
  wire [5:0] nl_return_mult_generic_AC_RND_CONV_false_else_1_lshift_rg_s;
  assign nl_return_mult_generic_AC_RND_CONV_false_else_1_lshift_rg_s = {return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva_1
      , return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_4_1_sva , return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva_1};
  wire [55:0] nl_operator_56_false_1_lshift_rg_a;
  assign nl_operator_56_false_1_lshift_rg_a = {ac_fx_div_53_cmp_quotient_rsc_z ,
      1'b0};
  wire  nl_operator_56_false_1_lshift_rg_s;
  assign nl_operator_56_false_1_lshift_rg_s = ~ (ac_fx_div_53_cmp_quotient_rsc_z[54]);
  wire return_mult_generic_AC_RND_CONV_false_else_1_and_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_mux1h_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_and_1_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_mux1h_2_nl;
  wire[49:0] return_mult_generic_AC_RND_CONV_false_else_1_mux1h_8_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_mux1h_3_nl;
  wire[1:0] return_mult_generic_AC_RND_CONV_false_else_1_return_mult_generic_AC_RND_CONV_false_else_1_and_nl;
  wire[1:0] return_mult_generic_AC_RND_CONV_false_else_1_mux_nl;
  wire [55:0] nl_operator_56_false_rshift_rg_a;
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_nl = MUX1HOT_s_1_3_2(return_add_generic_AC_RND_CONV_false_op_smaller_qr_52_lpi_1_dfm_mx0,
      return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_52_lpi_1_dfm, (ac_fx_div_53_cmp_quotient_rsc_z[54]),
      {(fsm_output[1]) , (fsm_output[2]) , (fsm_output[10])});
  assign return_mult_generic_AC_RND_CONV_false_else_1_and_nl = return_mult_generic_AC_RND_CONV_false_else_1_mux1h_nl
      & (~ (fsm_output[3]));
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_2_nl = MUX1HOT_s_1_3_2((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[50]),
      (operator_53_false_5_lshift_itm_50_0[50]), (ac_fx_div_53_cmp_quotient_rsc_z[53]),
      {(fsm_output[1]) , (fsm_output[2]) , (fsm_output[10])});
  assign return_mult_generic_AC_RND_CONV_false_else_1_and_1_nl = return_mult_generic_AC_RND_CONV_false_else_1_mux1h_2_nl
      & (~ (fsm_output[3]));
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_8_nl = MUX1HOT_v_50_4_2((return_mult_generic_AC_RND_CONV_false_p_1_sva[105:56]),
      (return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[49:0]),
      (operator_53_false_5_lshift_itm_50_0[49:0]), (ac_fx_div_53_cmp_quotient_rsc_z[52:3]),
      {(fsm_output[3]) , (fsm_output[1]) , (fsm_output[2]) , (fsm_output[10])});
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_3_nl = MUX1HOT_s_1_4_2((return_mult_generic_AC_RND_CONV_false_p_1_sva[55]),
      return_add_generic_AC_RND_CONV_false_op_smaller_qr_0_lpi_1_dfm_mx0, return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_0_lpi_1_dfm,
      (ac_fx_div_53_cmp_quotient_rsc_z[2]), {(fsm_output[3]) , (fsm_output[1]) ,
      (fsm_output[2]) , (fsm_output[10])});
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux_nl = MUX_v_2_2_2((return_mult_generic_AC_RND_CONV_false_p_1_sva[54:53]),
      (ac_fx_div_53_cmp_quotient_rsc_z[1:0]), fsm_output[10]);
  assign return_mult_generic_AC_RND_CONV_false_else_1_return_mult_generic_AC_RND_CONV_false_else_1_and_nl
      = MUX_v_2_2_2(2'b00, return_mult_generic_AC_RND_CONV_false_else_1_mux_nl, nor_11_cse);
  assign nl_operator_56_false_rshift_rg_a = {return_mult_generic_AC_RND_CONV_false_else_1_and_nl
      , return_mult_generic_AC_RND_CONV_false_else_1_and_1_nl , return_mult_generic_AC_RND_CONV_false_else_1_mux1h_8_nl
      , return_mult_generic_AC_RND_CONV_false_else_1_mux1h_3_nl , return_mult_generic_AC_RND_CONV_false_else_1_return_mult_generic_AC_RND_CONV_false_else_1_and_nl
      , 1'b0};
  wire[4:0] return_mult_generic_AC_RND_CONV_false_else_1_return_mult_generic_AC_RND_CONV_false_else_1_and_1_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_nor_1_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_mux1h_1_nl;
  wire[3:0] return_mult_generic_AC_RND_CONV_false_else_1_mux1h_7_nl;
  wire return_mult_generic_AC_RND_CONV_false_else_1_mux1h_6_nl;
  wire [11:0] nl_operator_56_false_rshift_rg_s;
  assign return_mult_generic_AC_RND_CONV_false_else_1_nor_1_nl = ~((fsm_output[3:1]!=3'b000));
  assign return_mult_generic_AC_RND_CONV_false_else_1_return_mult_generic_AC_RND_CONV_false_else_1_and_1_nl
      = MUX_v_5_2_2(5'b00000, (return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_9_0[9:5]),
      return_mult_generic_AC_RND_CONV_false_else_1_nor_1_nl);
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_1_nl = MUX1HOT_s_1_4_2(return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva,
      (return_add_generic_AC_RND_CONV_false_e_dif_sat_sva_1[5]), (return_add_generic_AC_RND_CONV_false_1_e_dif_sat_sva[5]),
      (return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_9_0[4]), {(fsm_output[3])
      , (fsm_output[1]) , (fsm_output[2]) , (fsm_output[10])});
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_7_nl = MUX1HOT_v_4_4_2(return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_4_1_sva,
      (return_add_generic_AC_RND_CONV_false_e_dif_sat_sva_1[4:1]), (return_add_generic_AC_RND_CONV_false_1_e_dif_sat_sva[4:1]),
      (return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_9_0[3:0]), {(fsm_output[3])
      , (fsm_output[1]) , (fsm_output[2]) , (fsm_output[10])});
  assign return_mult_generic_AC_RND_CONV_false_else_1_mux1h_6_nl = MUX1HOT_s_1_4_2(return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva,
      (return_add_generic_AC_RND_CONV_false_e_dif_sat_sva_1[0]), (return_add_generic_AC_RND_CONV_false_1_e_dif_sat_sva[0]),
      (~ (operator_34_true_acc_psp_sva[0])), {(fsm_output[3]) , (fsm_output[1]) ,
      (fsm_output[2]) , (fsm_output[10])});
  assign nl_operator_56_false_rshift_rg_s = {1'b0 , return_mult_generic_AC_RND_CONV_false_else_1_return_mult_generic_AC_RND_CONV_false_else_1_and_1_nl
      , return_mult_generic_AC_RND_CONV_false_else_1_mux1h_1_nl , return_mult_generic_AC_RND_CONV_false_else_1_mux1h_7_nl
      , return_mult_generic_AC_RND_CONV_false_else_1_mux1h_6_nl};
  wire operator_53_false_4_operator_53_false_4_and_nl;
  wire operator_53_false_4_operator_53_false_4_and_1_nl;
  wire operator_53_false_4_operator_53_false_4_and_2_nl;
  wire operator_53_false_4_operator_53_false_4_and_3_nl;
  wire operator_53_false_4_operator_53_false_4_and_4_nl;
  wire operator_53_false_4_operator_53_false_4_and_5_nl;
  wire operator_53_false_4_operator_53_false_4_and_6_nl;
  wire operator_53_false_4_operator_53_false_4_and_7_nl;
  wire operator_53_false_4_operator_53_false_4_and_8_nl;
  wire operator_53_false_4_operator_53_false_4_and_9_nl;
  wire operator_53_false_4_operator_53_false_4_and_10_nl;
  wire operator_53_false_4_operator_53_false_4_and_11_nl;
  wire operator_53_false_4_operator_53_false_4_and_12_nl;
  wire operator_53_false_4_operator_53_false_4_and_13_nl;
  wire operator_53_false_4_operator_53_false_4_and_14_nl;
  wire operator_53_false_4_operator_53_false_4_and_15_nl;
  wire operator_53_false_4_operator_53_false_4_and_16_nl;
  wire operator_53_false_4_operator_53_false_4_and_17_nl;
  wire operator_53_false_4_operator_53_false_4_and_18_nl;
  wire operator_53_false_4_operator_53_false_4_and_19_nl;
  wire operator_53_false_4_operator_53_false_4_and_20_nl;
  wire operator_53_false_4_operator_53_false_4_and_21_nl;
  wire operator_53_false_4_operator_53_false_4_and_22_nl;
  wire operator_53_false_4_operator_53_false_4_and_23_nl;
  wire operator_53_false_4_operator_53_false_4_and_24_nl;
  wire operator_53_false_4_operator_53_false_4_and_25_nl;
  wire operator_53_false_4_operator_53_false_4_and_26_nl;
  wire operator_53_false_4_operator_53_false_4_and_27_nl;
  wire operator_53_false_4_operator_53_false_4_and_28_nl;
  wire operator_53_false_4_operator_53_false_4_and_29_nl;
  wire operator_53_false_4_operator_53_false_4_and_30_nl;
  wire operator_53_false_4_operator_53_false_4_and_31_nl;
  wire operator_53_false_4_operator_53_false_4_and_32_nl;
  wire operator_53_false_4_operator_53_false_4_and_33_nl;
  wire operator_53_false_4_operator_53_false_4_and_34_nl;
  wire operator_53_false_4_operator_53_false_4_and_35_nl;
  wire operator_53_false_4_operator_53_false_4_and_36_nl;
  wire operator_53_false_4_operator_53_false_4_and_37_nl;
  wire operator_53_false_4_operator_53_false_4_and_38_nl;
  wire operator_53_false_4_operator_53_false_4_and_39_nl;
  wire operator_53_false_4_operator_53_false_4_and_40_nl;
  wire operator_53_false_4_operator_53_false_4_and_41_nl;
  wire operator_53_false_4_operator_53_false_4_and_42_nl;
  wire operator_53_false_4_operator_53_false_4_and_43_nl;
  wire operator_53_false_4_operator_53_false_4_and_44_nl;
  wire operator_53_false_4_operator_53_false_4_and_45_nl;
  wire operator_53_false_4_operator_53_false_4_and_46_nl;
  wire operator_53_false_4_operator_53_false_4_and_47_nl;
  wire operator_53_false_4_operator_53_false_4_and_48_nl;
  wire operator_53_false_4_operator_53_false_4_and_49_nl;
  wire operator_53_false_4_mux_nl;
  wire[2:0] operator_53_false_4_and_nl;
  wire[2:0] operator_53_false_4_mux1h_6_nl;
  wire operator_53_false_4_nor_50_nl;
  wire operator_53_false_4_or_2_nl;
  wire operator_53_false_4_mux1h_7_nl;
  wire[51:0] operator_53_false_4_or_3_nl;
  wire[51:0] operator_53_false_4_mux1h_8_nl;
  wire [105:0] nl_operator_53_false_4_lshift_rg_a;
  assign operator_53_false_4_operator_53_false_4_and_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[105])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_1_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[104])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_2_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[103])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_3_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[102])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_4_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[101])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_5_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[100])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_6_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[99])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_7_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[98])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_8_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[97])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_9_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[96])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_10_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[95])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_11_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[94])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_12_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[93])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_13_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[92])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_14_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[91])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_15_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[90])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_16_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[89])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_17_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[88])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_18_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[87])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_19_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[86])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_20_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[85])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_21_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[84])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_22_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[83])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_23_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[82])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_24_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[81])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_25_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[80])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_26_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[79])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_27_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[78])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_28_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[77])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_29_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[76])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_30_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[75])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_31_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[74])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_32_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[73])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_33_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[72])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_34_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[71])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_35_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[70])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_36_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[69])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_37_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[68])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_38_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[67])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_39_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[66])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_40_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[65])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_41_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[64])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_42_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[63])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_43_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[62])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_44_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[61])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_45_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[60])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_46_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[59])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_47_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[58])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_operator_53_false_4_and_48_nl = (return_mult_generic_AC_RND_CONV_false_p_1_sva[57])
      & operator_53_false_4_nor_cse;
  assign operator_53_false_4_mux_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_56,
      (return_mult_generic_AC_RND_CONV_false_p_1_sva[56]), fsm_output[6]);
  assign operator_53_false_4_operator_53_false_4_and_49_nl = operator_53_false_4_mux_nl
      & (~((fsm_output[7]) | (fsm_output[5]) | (fsm_output[1]) | (fsm_output[3])));
  assign operator_53_false_4_mux1h_6_nl = MUX1HOT_v_3_3_2(3'b011, (return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0[55:53]),
      (return_mult_generic_AC_RND_CONV_false_p_1_sva[55:53]), {return_add_generic_AC_RND_CONV_false_res_mant_or_cse
      , or_203_cse , (fsm_output[6])});
  assign operator_53_false_4_nor_50_nl = ~((fsm_output[7]) | (fsm_output[5]));
  assign operator_53_false_4_and_nl = MUX_v_3_2_2(3'b000, operator_53_false_4_mux1h_6_nl,
      operator_53_false_4_nor_50_nl);
  assign operator_53_false_4_mux1h_7_nl = MUX1HOT_s_1_4_2(return_extract_return_extract_or_1_cse_sva,
      return_extract_1_return_extract_1_or_1_cse_sva, (return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0[52]),
      (return_mult_generic_AC_RND_CONV_false_p_1_sva[52]), {(fsm_output[7]) , (fsm_output[5])
      , or_203_cse , (fsm_output[6])});
  assign operator_53_false_4_or_2_nl = operator_53_false_4_mux1h_7_nl | (fsm_output[1])
      | (fsm_output[3]);
  assign operator_53_false_4_mux1h_8_nl = MUX1HOT_v_52_4_2((A_to_helper_t_x_d_sva_62_0[51:0]),
      B_to_helper_t_x_d_sva_51_0, (return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0[51:0]),
      (return_mult_generic_AC_RND_CONV_false_p_1_sva[51:0]), {(fsm_output[7]) , (fsm_output[5])
      , or_203_cse , (fsm_output[6])});
  assign operator_53_false_4_or_3_nl = MUX_v_52_2_2(operator_53_false_4_mux1h_8_nl,
      52'b1111111111111111111111111111111111111111111111111111, return_add_generic_AC_RND_CONV_false_res_mant_or_cse);
  assign nl_operator_53_false_4_lshift_rg_a = {operator_53_false_4_operator_53_false_4_and_nl
      , operator_53_false_4_operator_53_false_4_and_1_nl , operator_53_false_4_operator_53_false_4_and_2_nl
      , operator_53_false_4_operator_53_false_4_and_3_nl , operator_53_false_4_operator_53_false_4_and_4_nl
      , operator_53_false_4_operator_53_false_4_and_5_nl , operator_53_false_4_operator_53_false_4_and_6_nl
      , operator_53_false_4_operator_53_false_4_and_7_nl , operator_53_false_4_operator_53_false_4_and_8_nl
      , operator_53_false_4_operator_53_false_4_and_9_nl , operator_53_false_4_operator_53_false_4_and_10_nl
      , operator_53_false_4_operator_53_false_4_and_11_nl , operator_53_false_4_operator_53_false_4_and_12_nl
      , operator_53_false_4_operator_53_false_4_and_13_nl , operator_53_false_4_operator_53_false_4_and_14_nl
      , operator_53_false_4_operator_53_false_4_and_15_nl , operator_53_false_4_operator_53_false_4_and_16_nl
      , operator_53_false_4_operator_53_false_4_and_17_nl , operator_53_false_4_operator_53_false_4_and_18_nl
      , operator_53_false_4_operator_53_false_4_and_19_nl , operator_53_false_4_operator_53_false_4_and_20_nl
      , operator_53_false_4_operator_53_false_4_and_21_nl , operator_53_false_4_operator_53_false_4_and_22_nl
      , operator_53_false_4_operator_53_false_4_and_23_nl , operator_53_false_4_operator_53_false_4_and_24_nl
      , operator_53_false_4_operator_53_false_4_and_25_nl , operator_53_false_4_operator_53_false_4_and_26_nl
      , operator_53_false_4_operator_53_false_4_and_27_nl , operator_53_false_4_operator_53_false_4_and_28_nl
      , operator_53_false_4_operator_53_false_4_and_29_nl , operator_53_false_4_operator_53_false_4_and_30_nl
      , operator_53_false_4_operator_53_false_4_and_31_nl , operator_53_false_4_operator_53_false_4_and_32_nl
      , operator_53_false_4_operator_53_false_4_and_33_nl , operator_53_false_4_operator_53_false_4_and_34_nl
      , operator_53_false_4_operator_53_false_4_and_35_nl , operator_53_false_4_operator_53_false_4_and_36_nl
      , operator_53_false_4_operator_53_false_4_and_37_nl , operator_53_false_4_operator_53_false_4_and_38_nl
      , operator_53_false_4_operator_53_false_4_and_39_nl , operator_53_false_4_operator_53_false_4_and_40_nl
      , operator_53_false_4_operator_53_false_4_and_41_nl , operator_53_false_4_operator_53_false_4_and_42_nl
      , operator_53_false_4_operator_53_false_4_and_43_nl , operator_53_false_4_operator_53_false_4_and_44_nl
      , operator_53_false_4_operator_53_false_4_and_45_nl , operator_53_false_4_operator_53_false_4_and_46_nl
      , operator_53_false_4_operator_53_false_4_and_47_nl , operator_53_false_4_operator_53_false_4_and_48_nl
      , operator_53_false_4_operator_53_false_4_and_49_nl , operator_53_false_4_and_nl
      , operator_53_false_4_or_2_nl , operator_53_false_4_or_3_nl};
  wire operator_53_false_4_or_nl;
  wire [5:0] nl_operator_53_false_4_lshift_rg_s;
  assign operator_53_false_4_or_nl = (fsm_output[3]) | (fsm_output[6]);
  assign nl_operator_53_false_4_lshift_rg_s = MUX1HOT_v_6_5_2(return_div_generic_AC_RND_CONV_false_ls_op1_5_0_sva,
      return_div_generic_AC_RND_CONV_false_ls_op2_5_0_sva, return_add_generic_AC_RND_CONV_false_e_dif_sat_sva_1,
      return_add_generic_AC_RND_CONV_false_1_mux_4_itm, return_add_generic_AC_RND_CONV_false_1_e_dif_sat_sva,
      {(fsm_output[7]) , (fsm_output[5]) , (fsm_output[1]) , or_203_cse , operator_53_false_4_or_nl});
  wire return_div_generic_AC_RND_CONV_false_ls_op2_qelse_leading_sign_53_0_rtn_mux1h_nl;
  wire return_mult_generic_AC_RND_CONV_false_if_return_mult_generic_AC_RND_CONV_false_if_and_nl;
  wire[51:0] return_div_generic_AC_RND_CONV_false_ls_op2_qelse_leading_sign_53_0_rtn_mux1h_1_nl;
  wire [52:0] nl_leading_sign_53_0_rg_mantissa;
  assign return_mult_generic_AC_RND_CONV_false_if_return_mult_generic_AC_RND_CONV_false_if_and_nl
      = return_extract_1_return_extract_1_or_1_cse_sva & return_extract_return_extract_or_1_cse_sva;
  assign return_div_generic_AC_RND_CONV_false_ls_op2_qelse_leading_sign_53_0_rtn_mux1h_nl
      = MUX1HOT_s_1_3_2(return_extract_1_return_extract_1_or_1_cse_sva_mx0w0, return_extract_return_extract_or_1_cse_sva,
      return_mult_generic_AC_RND_CONV_false_if_return_mult_generic_AC_RND_CONV_false_if_and_nl,
      {(fsm_output[1]) , (fsm_output[2]) , (fsm_output[3])});
  assign return_div_generic_AC_RND_CONV_false_ls_op2_qelse_leading_sign_53_0_rtn_mux1h_1_nl
      = MUX1HOT_v_52_3_2((B_d_rsci_idat[51:0]), (A_to_helper_t_x_d_sva_62_0[51:0]),
      return_mult_generic_AC_RND_CONV_false_if_mux_1_itm, {(fsm_output[1]) , (fsm_output[2])
      , (fsm_output[3])});
  assign nl_leading_sign_53_0_rg_mantissa = {return_div_generic_AC_RND_CONV_false_ls_op2_qelse_leading_sign_53_0_rtn_mux1h_nl
      , return_div_generic_AC_RND_CONV_false_ls_op2_qelse_leading_sign_53_0_rtn_mux1h_1_nl};
  ccs_in_v1 #(.rscid(32'sd5),
  .width(32'sd64)) A_d_rsci (
      .dat(A_d_rsc_dat),
      .idat(A_d_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd6),
  .width(32'sd64)) B_d_rsci (
      .dat(B_d_rsc_dat),
      .idat(B_d_rsci_idat)
    );
  ccs_out_v1 #(.rscid(32'sd7),
  .width(32'sd64)) C_add_d_rsci (
      .idat(nl_C_add_d_rsci_idat[63:0]),
      .dat(C_add_d_rsc_dat)
    );
  ccs_out_v1 #(.rscid(32'sd8),
  .width(32'sd64)) C_sub_d_rsci (
      .idat(nl_C_sub_d_rsci_idat[63:0]),
      .dat(C_sub_d_rsc_dat)
    );
  ccs_out_v1 #(.rscid(32'sd9),
  .width(32'sd64)) C_div_d_rsci (
      .idat(nl_C_div_d_rsci_idat[63:0]),
      .dat(C_div_d_rsc_dat)
    );
  ccs_out_v1 #(.rscid(32'sd10),
  .width(32'sd64)) C_mult_d_rsci (
      .idat(nl_C_mult_d_rsci_idat[63:0]),
      .dat(C_mult_d_rsc_dat)
    );
  ac_fx_div_53  ac_fx_div_53_cmp (
      .op1_rsc_dat(nl_ac_fx_div_53_cmp_op1_rsc_dat[52:0]),
      .op2_rsc_dat(nl_ac_fx_div_53_cmp_op2_rsc_dat[52:0]),
      .quotient_rsc_z(ac_fx_div_53_cmp_quotient_rsc_z),
      .exact_rsc_z(ac_fx_div_53_cmp_exact_rsc_z),
      .ccs_ccore_clk(clk),
      .ccs_ccore_srst(rstn),
      .ccs_ccore_en(ac_fx_div_53_ccs_ccore_en)
    );
  mgc_shift_l_v5 #(.width_a(32'sd1),
  .signd_a(32'sd1),
  .width_s(32'sd11),
  .width_z(32'sd56)) operator_57_true_lshift_rg (
      .a(1'b1),
      .s(nl_operator_57_true_lshift_rg_s[10:0]),
      .z(operator_57_true_lshift_itm)
    );
  mgc_shift_l_v5 #(.width_a(32'sd53),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd53)) return_mult_generic_AC_RND_CONV_false_else_1_lshift_rg (
      .a(53'b11111111111111111111111111111111111111111111111111111),
      .s(nl_return_mult_generic_AC_RND_CONV_false_else_1_lshift_rg_s[5:0]),
      .z(return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm)
    );
  mgc_shift_l_v5 #(.width_a(32'sd56),
  .signd_a(32'sd0),
  .width_s(32'sd1),
  .width_z(32'sd56)) operator_56_false_1_lshift_rg (
      .a(nl_operator_56_false_1_lshift_rg_a[55:0]),
      .s(nl_operator_56_false_1_lshift_rg_s),
      .z(operator_56_false_1_lshift_itm)
    );
  mgc_shift_br_v5 #(.width_a(32'sd56),
  .signd_a(32'sd0),
  .width_s(32'sd12),
  .width_z(32'sd57)) operator_56_false_rshift_rg (
      .a(nl_operator_56_false_rshift_rg_a[55:0]),
      .s(nl_operator_56_false_rshift_rg_s[11:0]),
      .z(z_out_5)
    );
  mgc_shift_l_v5 #(.width_a(32'sd106),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd106)) operator_53_false_4_lshift_rg (
      .a(nl_operator_53_false_4_lshift_rg_a[105:0]),
      .s(nl_operator_53_false_4_lshift_rg_s[5:0]),
      .z(z_out_6)
    );
  leading_sign_53_0  leading_sign_53_0_rg (
      .mantissa(nl_leading_sign_53_0_rg_mantissa[52:0]),
      .rtn(rtn_out)
    );
  leading_sign_57_0_1_0  leading_sign_57_0_1_0_rg (
      .mantissa(z_out_9),
      .all_same(all_same_out),
      .rtn(rtn_out_1)
    );
  fpu_core_done_synci fpu_core_done_synci_inst (
      .done_sync_vld(done_sync_vld),
      .core_wten(core_wten),
      .done_synci_iswt0(reg_done_synci_iswt0_cse)
    );
  fpu_core_start_synci fpu_core_start_synci_inst (
      .start_sync_rdy(start_sync_rdy),
      .start_sync_vld(start_sync_vld),
      .start_synci_oswt(reg_start_synci_oswt_cse),
      .start_synci_wen_comp(start_synci_wen_comp)
    );
  fpu_core_A_d_triosy_obj fpu_core_A_d_triosy_obj_inst (
      .A_d_triosy_lz(A_d_triosy_lz),
      .core_wten(core_wten),
      .A_d_triosy_obj_iswt0(reg_A_d_triosy_obj_iswt0_cse)
    );
  fpu_core_B_d_triosy_obj fpu_core_B_d_triosy_obj_inst (
      .B_d_triosy_lz(B_d_triosy_lz),
      .core_wten(core_wten),
      .B_d_triosy_obj_iswt0(reg_A_d_triosy_obj_iswt0_cse)
    );
  fpu_core_C_add_d_triosy_obj fpu_core_C_add_d_triosy_obj_inst (
      .C_add_d_triosy_lz(C_add_d_triosy_lz),
      .core_wten(core_wten),
      .C_add_d_triosy_obj_iswt0(C_add_d_triosy_obj_iswt0)
    );
  fpu_core_C_sub_d_triosy_obj fpu_core_C_sub_d_triosy_obj_inst (
      .C_sub_d_triosy_lz(C_sub_d_triosy_lz),
      .core_wten(core_wten),
      .C_sub_d_triosy_obj_iswt0(C_sub_d_triosy_obj_iswt0)
    );
  fpu_core_C_div_d_triosy_obj fpu_core_C_div_d_triosy_obj_inst (
      .C_div_d_triosy_lz(C_div_d_triosy_lz),
      .core_wten(core_wten),
      .C_div_d_triosy_obj_iswt0(reg_done_synci_iswt0_cse)
    );
  fpu_core_C_mult_d_triosy_obj fpu_core_C_mult_d_triosy_obj_inst (
      .C_mult_d_triosy_lz(C_mult_d_triosy_lz),
      .core_wten(core_wten),
      .C_mult_d_triosy_obj_iswt0(C_mult_d_triosy_obj_iswt0)
    );
  fpu_core_staller fpu_core_staller_inst (
      .clk(clk),
      .en(en),
      .rstn(rstn),
      .core_wten(core_wten),
      .start_synci_wen_comp(start_synci_wen_comp),
      .ac_fx_div_53_ccs_ccore_en(ac_fx_div_53_ccs_ccore_en)
    );
  fpu_core_core_fsm fpu_core_core_fsm_inst (
      .clk(clk),
      .rstn(rstn),
      .ac_fx_div_53_ccs_ccore_en(ac_fx_div_53_ccs_ccore_en),
      .fsm_output(fsm_output)
    );
  assign and_340_cse = ac_fx_div_53_ccs_ccore_en & (fsm_output[2]);
  assign and_345_cse = ac_fx_div_53_ccs_ccore_en & (fsm_output[4]);
  assign and_350_cse = ac_fx_div_53_ccs_ccore_en & (fsm_output[6]);
  assign and_354_cse = ac_fx_div_53_ccs_ccore_en & (fsm_output[10]);
  assign B_to_helper_t_x_d_and_cse = ac_fx_div_53_ccs_ccore_en & (fsm_output[1]);
  assign return_add_generic_AC_RND_CONV_false_1_op_bigger_and_cse = ac_fx_div_53_ccs_ccore_en
      & (or_tmp_43 | or_tmp_44);
  assign return_div_generic_AC_RND_CONV_false_exp_and_1_cse = ac_fx_div_53_ccs_ccore_en
      & (~(and_dcpl_28 & (~ (fsm_output[10])) & nor_11_cse));
  assign return_extract_m_zero_or_cse = (fsm_output[2:1]!=2'b00);
  assign return_extract_m_zero_and_cse = ac_fx_div_53_ccs_ccore_en & return_extract_m_zero_or_cse;
  assign and_295_cse = (~ (z_out_7[11])) & (fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_res_mant_or_cse = (fsm_output[1]) |
      (fsm_output[3]);
  assign return_mult_generic_AC_RND_CONV_false_exp_and_ssc = ac_fx_div_53_ccs_ccore_en
      & ((fsm_output[3]) | return_extract_m_zero_or_cse);
  assign operator_53_false_5_and_ssc = ac_fx_div_53_ccs_ccore_en & ((fsm_output[5])
      | return_extract_m_zero_or_cse);
  assign return_add_generic_AC_RND_CONV_false_if_5_or_2_nl = return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva
      | (~((operator_33_true_2_acc_psp_sva!=13'b0000000000000)));
  assign return_add_generic_AC_RND_CONV_false_mux_28_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva,
      return_add_generic_AC_RND_CONV_false_if_5_or_2_nl, z_out_9[53]);
  assign return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0 = return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva
      | (~ return_add_generic_AC_RND_CONV_false_mux_28_nl);
  assign nl_return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse = ({1'b1 , (B_d_rsci_idat[62:52])})
      + conv_u2s_11_12(~ (A_d_rsci_idat[62:52])) + 12'b000000000001;
  assign return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse = nl_return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse[11:0];
  assign return_add_generic_AC_RND_CONV_false_e_dif_qr_lpi_1_dfm_mx0 = MUX_v_12_2_2(z_out_1,
      return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse, z_out_1[11]);
  assign operator_53_false_mux_cse = MUX_s_1_2_2(return_extract_return_extract_or_1_tmp,
      (A_d_rsci_idat[51]), return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp);
  assign operator_53_false_mux_2_cse = MUX_v_51_2_2((A_d_rsci_idat[51:1]), (A_d_rsci_idat[50:0]),
      return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp);
  assign return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1 = (A_d_rsci_idat[0])
      & (~ return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp);
  assign operator_53_false_1_mux_cse = MUX_s_1_2_2(return_extract_1_return_extract_1_or_1_cse_sva_mx0w0,
      (B_d_rsci_idat[51]), return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp);
  assign operator_53_false_1_mux_2_cse = MUX_v_51_2_2((B_d_rsci_idat[51:1]), (B_d_rsci_idat[50:0]),
      return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp);
  assign return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1 = (B_d_rsci_idat[0])
      & (~ return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp);
  assign drf_qr_lval_smx_lpi_1_dfm_mx0 = MUX_v_11_2_2((B_d_rsci_idat[62:52]), (A_d_rsci_idat[62:52]),
      and_dcpl_52);
  assign return_add_generic_AC_RND_CONV_false_op_smaller_qr_52_lpi_1_dfm_mx0 = MUX_s_1_2_2(operator_53_false_mux_cse,
      operator_53_false_1_mux_cse, and_dcpl_52);
  assign return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0 =
      MUX_v_51_2_2(operator_53_false_mux_2_cse, operator_53_false_1_mux_2_cse, and_dcpl_52);
  assign return_add_generic_AC_RND_CONV_false_op_smaller_qr_0_lpi_1_dfm_mx0 = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1,
      return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1, and_dcpl_52);
  assign return_add_generic_AC_RND_CONV_false_e1_eq_e2_equal_tmp = (A_d_rsci_idat[62:52])
      == (B_d_rsci_idat[62:52]);
  assign return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_and_1_cse
      = (z_out_8[52]) & return_add_generic_AC_RND_CONV_false_e1_eq_e2_equal_tmp;
  assign return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2 = return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_and_1_cse
      | (z_out_1[11]);
  assign return_add_generic_AC_RND_CONV_false_res_mant_3_0_sva_1 = (return_add_generic_AC_RND_CONV_false_op_smaller_qr_52_lpi_1_dfm_mx0
      & (~ (z_out_6[54]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[50])
      & (~ (z_out_6[53]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[49])
      & (~ (z_out_6[52]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[48])
      & (~ (z_out_6[51]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[47])
      & (~ (z_out_6[50]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[46])
      & (~ (z_out_6[49]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[45])
      & (~ (z_out_6[48]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[44])
      & (~ (z_out_6[47]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[43])
      & (~ (z_out_6[46]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[42])
      & (~ (z_out_6[45]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[41])
      & (~ (z_out_6[44]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[40])
      & (~ (z_out_6[43]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[39])
      & (~ (z_out_6[42]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[38])
      & (~ (z_out_6[41]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[37])
      & (~ (z_out_6[40]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[36])
      & (~ (z_out_6[39]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[35])
      & (~ (z_out_6[38]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[34])
      & (~ (z_out_6[37]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[33])
      & (~ (z_out_6[36]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[32])
      & (~ (z_out_6[35]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[31])
      & (~ (z_out_6[34]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[30])
      & (~ (z_out_6[33]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[29])
      & (~ (z_out_6[32]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[28])
      & (~ (z_out_6[31]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[27])
      & (~ (z_out_6[30]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[26])
      & (~ (z_out_6[29]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[25])
      & (~ (z_out_6[28]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[24])
      & (~ (z_out_6[27]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[23])
      & (~ (z_out_6[26]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[22])
      & (~ (z_out_6[25]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[21])
      & (~ (z_out_6[24]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[20])
      & (~ (z_out_6[23]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[19])
      & (~ (z_out_6[22]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[18])
      & (~ (z_out_6[21]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[17])
      & (~ (z_out_6[20]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[16])
      & (~ (z_out_6[19]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[15])
      & (~ (z_out_6[18]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[14])
      & (~ (z_out_6[17]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[13])
      & (~ (z_out_6[16]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[12])
      & (~ (z_out_6[15]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[11])
      & (~ (z_out_6[14]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[10])
      & (~ (z_out_6[13]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[9])
      & (~ (z_out_6[12]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[8])
      & (~ (z_out_6[11]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[7])
      & (~ (z_out_6[10]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[6])
      & (~ (z_out_6[9]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[5])
      & (~ (z_out_6[8]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[4])
      & (~ (z_out_6[7]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[3])
      & (~ (z_out_6[6]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[2])
      & (~ (z_out_6[5]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[1])
      & (~ (z_out_6[4]))) | ((return_add_generic_AC_RND_CONV_false_op_smaller_qr_51_1_lpi_1_dfm_mx0[0])
      & (~ (z_out_6[3]))) | (return_add_generic_AC_RND_CONV_false_op_smaller_qr_0_lpi_1_dfm_mx0
      & (~ (z_out_6[2])));
  assign nl_operator_33_true_acc_psp_sva_1 = conv_s2s_7_13({z_out_3 , (~ (rtn_out_1[0]))})
      + conv_u2s_11_13(drf_qr_lval_smx_lpi_1_dfm_mx0);
  assign operator_33_true_acc_psp_sva_1 = nl_operator_33_true_acc_psp_sva_1[12:0];
  assign return_add_generic_AC_RND_CONV_false_1_e_dif_qr_lpi_1_dfm_mx0_10_0 = MUX_v_11_2_2((z_out_1[10:0]),
      (return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse[10:0]), z_out_1[11]);
  assign return_mult_generic_AC_RND_CONV_false_if_nor_ovfl_sva_1 = ~((z_out_2[9:6]==4'b1111));
  assign return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0 = (A_d_rsci_idat[63])
      ^ (B_d_rsci_idat[63]);
  assign return_extract_return_extract_or_1_tmp = (A_d_rsci_idat[62:52]!=11'b00000000000);
  assign return_extract_1_return_extract_1_or_1_cse_sva_mx0w0 = (B_d_rsci_idat[62:52]!=11'b00000000000);
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp
      = ~((B_d_rsci_idat[62:52]!=11'b00000000000));
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp
      = ~((A_d_rsci_idat[62:52]!=11'b00000000000));
  assign return_add_generic_AC_RND_CONV_false_res_mant_conc_2_itm_56_1 = MUX_v_56_2_2((z_out_5[56:1]),
      (~ (z_out_5[56:1])), return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0);
  assign return_add_generic_AC_RND_CONV_false_op1_inf_sva_mx0w1 = operator_11_true_return_sva
      & return_extract_m_zero_sva;
  assign return_add_generic_AC_RND_CONV_false_e_dif_sat_or_1_nl = (return_add_generic_AC_RND_CONV_false_e_dif_qr_lpi_1_dfm_mx0[11:6]!=6'b000000);
  assign return_add_generic_AC_RND_CONV_false_e_dif_sat_sva_1 = MUX_v_6_2_2((return_add_generic_AC_RND_CONV_false_e_dif_qr_lpi_1_dfm_mx0[5:0]),
      6'b111111, return_add_generic_AC_RND_CONV_false_e_dif_sat_or_1_nl);
  assign return_add_generic_AC_RND_CONV_false_op1_nan_sva_mx0w2 = operator_11_true_return_sva
      & (~ return_extract_m_zero_sva);
  assign return_add_generic_AC_RND_CONV_false_op2_inf_sva_mx0w1 = operator_11_true_return_1_sva
      & return_add_generic_AC_RND_CONV_false_op2_inf_sva;
  assign return_add_generic_AC_RND_CONV_false_op2_nan_sva_mx0w1 = operator_11_true_return_1_sva
      & (~ return_add_generic_AC_RND_CONV_false_op2_inf_sva);
  assign return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva_1 = (~ (operator_14_false_acc_psp_sva[0]))
      | return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva;
  assign return_mult_generic_AC_RND_CONV_false_if_if_not_nl = ~ (operator_6_false_4_acc_tmp[12]);
  assign return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_mx0w1 = MUX_v_12_2_2(12'b000000000000,
      (operator_6_false_4_acc_tmp[11:0]), return_mult_generic_AC_RND_CONV_false_if_if_not_nl);
  assign and_363_nl = (z_out_9[53]) & (~ return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0);
  assign mux_12_nl = MUX_v_10_2_2((operator_33_true_2_acc_psp_sva[10:1]), (return_add_generic_AC_RND_CONV_false_1_exp_plus_1_12_1_lpi_1_dfm[9:0]),
      and_363_nl);
  assign not_144_nl = ~ return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0;
  assign return_add_generic_AC_RND_CONV_false_e_r_qelse_qr_10_1_lpi_1_dfm_1 = MUX_v_10_2_2(10'b0000000000,
      mux_12_nl, not_144_nl);
  assign return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva_1 = (~ (operator_14_false_acc_psp_sva[5]))
      | return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva;
  assign return_add_generic_AC_RND_CONV_false_not_5_nl = ~ (z_out_9[53]);
  assign return_add_generic_AC_RND_CONV_false_res_rounded_lpi_1_dfm_51_0_1 = MUX_v_52_2_2(52'b0000000000000000000000000000000000000000000000000000,
      (z_out_9[51:0]), return_add_generic_AC_RND_CONV_false_not_5_nl);
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_2_cse
      = ((operator_33_true_2_acc_psp_sva[11]) | (~ return_add_generic_AC_RND_CONV_false_else_4_unequal_tmp))
      & return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva;
  assign return_add_generic_AC_RND_CONV_false_exception_sva_1 = return_add_generic_AC_RND_CONV_false_op1_inf_sva_mx0w1
      | return_add_generic_AC_RND_CONV_false_op2_inf_sva_mx0w1 | return_add_generic_AC_RND_CONV_false_op1_nan_sva_mx0w2
      | return_add_generic_AC_RND_CONV_false_op2_nan_sva_mx0w1 | return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_2_cse
      | return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp;
  assign nl_operator_6_false_4_acc_tmp = operator_14_false_acc_psp_sva + conv_s2s_7_13({1'b1
      , (~ rtn_out)}) + 13'b0000000000001;
  assign operator_6_false_4_acc_tmp = nl_operator_6_false_4_acc_tmp[12:0];
  assign return_add_generic_AC_RND_CONV_false_1_res_mant_3_0_sva_1 = (return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_52_lpi_1_dfm
      & (~ (z_out_6[54]))) | ((operator_53_false_5_lshift_itm_50_0[50]) & (~ (z_out_6[53])))
      | ((operator_53_false_5_lshift_itm_50_0[49]) & (~ (z_out_6[52]))) | ((operator_53_false_5_lshift_itm_50_0[48])
      & (~ (z_out_6[51]))) | ((operator_53_false_5_lshift_itm_50_0[47]) & (~ (z_out_6[50])))
      | ((operator_53_false_5_lshift_itm_50_0[46]) & (~ (z_out_6[49]))) | ((operator_53_false_5_lshift_itm_50_0[45])
      & (~ (z_out_6[48]))) | ((operator_53_false_5_lshift_itm_50_0[44]) & (~ (z_out_6[47])))
      | ((operator_53_false_5_lshift_itm_50_0[43]) & (~ (z_out_6[46]))) | ((operator_53_false_5_lshift_itm_50_0[42])
      & (~ (z_out_6[45]))) | ((operator_53_false_5_lshift_itm_50_0[41]) & (~ (z_out_6[44])))
      | ((operator_53_false_5_lshift_itm_50_0[40]) & (~ (z_out_6[43]))) | ((operator_53_false_5_lshift_itm_50_0[39])
      & (~ (z_out_6[42]))) | ((operator_53_false_5_lshift_itm_50_0[38]) & (~ (z_out_6[41])))
      | ((operator_53_false_5_lshift_itm_50_0[37]) & (~ (z_out_6[40]))) | ((operator_53_false_5_lshift_itm_50_0[36])
      & (~ (z_out_6[39]))) | ((operator_53_false_5_lshift_itm_50_0[35]) & (~ (z_out_6[38])))
      | ((operator_53_false_5_lshift_itm_50_0[34]) & (~ (z_out_6[37]))) | ((operator_53_false_5_lshift_itm_50_0[33])
      & (~ (z_out_6[36]))) | ((operator_53_false_5_lshift_itm_50_0[32]) & (~ (z_out_6[35])))
      | ((operator_53_false_5_lshift_itm_50_0[31]) & (~ (z_out_6[34]))) | ((operator_53_false_5_lshift_itm_50_0[30])
      & (~ (z_out_6[33]))) | ((operator_53_false_5_lshift_itm_50_0[29]) & (~ (z_out_6[32])))
      | ((operator_53_false_5_lshift_itm_50_0[28]) & (~ (z_out_6[31]))) | ((operator_53_false_5_lshift_itm_50_0[27])
      & (~ (z_out_6[30]))) | ((operator_53_false_5_lshift_itm_50_0[26]) & (~ (z_out_6[29])))
      | ((operator_53_false_5_lshift_itm_50_0[25]) & (~ (z_out_6[28]))) | ((operator_53_false_5_lshift_itm_50_0[24])
      & (~ (z_out_6[27]))) | ((operator_53_false_5_lshift_itm_50_0[23]) & (~ (z_out_6[26])))
      | ((operator_53_false_5_lshift_itm_50_0[22]) & (~ (z_out_6[25]))) | ((operator_53_false_5_lshift_itm_50_0[21])
      & (~ (z_out_6[24]))) | ((operator_53_false_5_lshift_itm_50_0[20]) & (~ (z_out_6[23])))
      | ((operator_53_false_5_lshift_itm_50_0[19]) & (~ (z_out_6[22]))) | ((operator_53_false_5_lshift_itm_50_0[18])
      & (~ (z_out_6[21]))) | ((operator_53_false_5_lshift_itm_50_0[17]) & (~ (z_out_6[20])))
      | ((operator_53_false_5_lshift_itm_50_0[16]) & (~ (z_out_6[19]))) | ((operator_53_false_5_lshift_itm_50_0[15])
      & (~ (z_out_6[18]))) | ((operator_53_false_5_lshift_itm_50_0[14]) & (~ (z_out_6[17])))
      | ((operator_53_false_5_lshift_itm_50_0[13]) & (~ (z_out_6[16]))) | ((operator_53_false_5_lshift_itm_50_0[12])
      & (~ (z_out_6[15]))) | ((operator_53_false_5_lshift_itm_50_0[11]) & (~ (z_out_6[14])))
      | ((operator_53_false_5_lshift_itm_50_0[10]) & (~ (z_out_6[13]))) | ((operator_53_false_5_lshift_itm_50_0[9])
      & (~ (z_out_6[12]))) | ((operator_53_false_5_lshift_itm_50_0[8]) & (~ (z_out_6[11])))
      | ((operator_53_false_5_lshift_itm_50_0[7]) & (~ (z_out_6[10]))) | ((operator_53_false_5_lshift_itm_50_0[6])
      & (~ (z_out_6[9]))) | ((operator_53_false_5_lshift_itm_50_0[5]) & (~ (z_out_6[8])))
      | ((operator_53_false_5_lshift_itm_50_0[4]) & (~ (z_out_6[7]))) | ((operator_53_false_5_lshift_itm_50_0[3])
      & (~ (z_out_6[6]))) | ((operator_53_false_5_lshift_itm_50_0[2]) & (~ (z_out_6[5])))
      | ((operator_53_false_5_lshift_itm_50_0[1]) & (~ (z_out_6[4]))) | ((operator_53_false_5_lshift_itm_50_0[0])
      & (~ (z_out_6[3]))) | (return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_0_lpi_1_dfm
      & (~ (z_out_6[2])));
  assign return_add_generic_AC_RND_CONV_false_1_exception_sva_1 = operator_11_true_return_1_sva
      | return_add_generic_AC_RND_CONV_false_op2_inf_sva | return_add_generic_AC_RND_CONV_false_op1_nan_sva
      | return_add_generic_AC_RND_CONV_false_op2_nan_sva | (((operator_33_true_2_acc_psp_sva[11])
      | (~ return_add_generic_AC_RND_CONV_false_1_else_4_unequal_tmp)) & return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva)
      | return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp;
  assign return_mult_generic_AC_RND_CONV_false_if_1_aelse_return_mult_generic_AC_RND_CONV_false_if_1_aelse_or_2
      = (~ return_mult_generic_AC_RND_CONV_false_do_shift_left_1_sva) | (z_out_6[105]);
  assign return_mult_generic_AC_RND_CONV_false_e_incr_lpi_1_dfm_2 = ~((~(((z_out_6[104:52]==53'b11111111111111111111111111111111111111111111111111111)
      & ((z_out_6[51]) | return_mult_generic_AC_RND_CONV_false_if_1_aelse_return_mult_generic_AC_RND_CONV_false_if_1_aelse_or_2))
      | (z_out_6[105]))) | (operator_14_false_acc_psp_sva[12]));
  assign return_mult_generic_AC_RND_CONV_false_zero_m_lor_sva_1 = operator_11_true_return_sva
      | return_extract_m_zero_sva;
  assign return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aif_return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aelse_and_tmp
      = (return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0[10:1]==10'b1111111111)
      & (~(return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_11 | (return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0[0])))
      & return_mult_generic_AC_RND_CONV_false_e_incr_lpi_1_dfm_2;
  assign return_mult_generic_AC_RND_CONV_false_exp_ovf_lor_lpi_1_dfm_2 = return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aif_return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aelse_and_tmp
      | (return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva[11]);
  assign return_mult_generic_AC_RND_CONV_false_lor_lpi_1_dfm_1 = operator_11_true_return_1_sva
      | return_add_generic_AC_RND_CONV_false_op2_inf_sva | return_add_generic_AC_RND_CONV_false_1_do_sub_sva;
  assign return_mult_generic_AC_RND_CONV_false_return_mult_generic_AC_RND_CONV_false_nor_ssc
      = ~(return_mult_generic_AC_RND_CONV_false_if_1_and_1_tmp_1 | (operator_14_false_acc_psp_sva[12]));
  assign return_mult_generic_AC_RND_CONV_false_and_2_ssc = return_mult_generic_AC_RND_CONV_false_if_1_and_1_tmp_1
      & (~ (operator_14_false_acc_psp_sva[12]));
  assign return_mult_generic_AC_RND_CONV_false_res_bef_rnd_3_53_1_lpi_1_dfm_1_50_0
      = MUX1HOT_v_51_3_2((z_out_6[102:52]), (z_out_6[101:51]), operator_53_false_4_lshift_itm_50_0,
      {return_mult_generic_AC_RND_CONV_false_return_mult_generic_AC_RND_CONV_false_nor_ssc
      , return_mult_generic_AC_RND_CONV_false_and_2_ssc , (operator_14_false_acc_psp_sva[12])});
  assign return_mult_generic_AC_RND_CONV_false_if_1_and_1_tmp_1 = return_mult_generic_AC_RND_CONV_false_do_shift_left_1_sva
      & (~ (z_out_6[105]));
  assign return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0 = MUX_v_56_2_2((z_out_5[55:0]),
      operator_56_false_1_lshift_itm, return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11);
  assign return_div_generic_AC_RND_CONV_false_if_1_and_psp_sva_1 = ac_fx_div_53_cmp_quotient_rsc_z
      & (~ return_div_generic_AC_RND_CONV_false_if_1_slc_operator_57_true_return_55_0_55_1_itm);
  assign nl_return_div_generic_AC_RND_CONV_false_r_inf_acc_nl = (~ z_out_11) + 13'b0011111111111;
  assign return_div_generic_AC_RND_CONV_false_r_inf_acc_nl = nl_return_div_generic_AC_RND_CONV_false_r_inf_acc_nl[12:0];
  assign return_div_generic_AC_RND_CONV_false_r_inf_acc_itm_12_1 = readslicef_13_1_12(return_div_generic_AC_RND_CONV_false_r_inf_acc_nl);
  assign return_div_generic_AC_RND_CONV_false_exception_sva_1 = return_add_generic_AC_RND_CONV_false_op1_nan_sva
      | ((~ return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva) & return_div_generic_AC_RND_CONV_false_r_inf_acc_itm_12_1)
      | operator_11_true_return_1_sva | return_extract_m_zero_sva;
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_8_nl
      = (operator_33_true_2_acc_psp_sva[0]) & return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva;
  assign return_add_generic_AC_RND_CONV_false_mux_31 = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_8_nl,
      return_add_generic_AC_RND_CONV_false_1_exp_plus_1_0_lpi_1_dfm, z_out_9[53]);
  assign return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp
      = (return_add_generic_AC_RND_CONV_false_1_exp_plus_1_12_1_lpi_1_dfm[9:0]==10'b1111111111)
      & return_add_generic_AC_RND_CONV_false_1_exp_plus_1_0_lpi_1_dfm & (return_add_generic_AC_RND_CONV_false_1_exp_plus_1_12_1_lpi_1_dfm[11:10]==2'b00)
      & (z_out_9[53]);
  assign return_add_generic_AC_RND_CONV_false_1_aif_equal_tmp = ({operator_53_false_mux_cse
      , operator_53_false_mux_2_cse , return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1})
      == ({operator_53_false_1_mux_cse , operator_53_false_1_mux_2_cse , return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1});
  assign and_dcpl_28 = ~((fsm_output[0]) | (fsm_output[11]));
  assign and_dcpl_46 = ~(return_extract_m_zero_sva | operator_11_true_return_1_sva);
  assign or_dcpl_33 = return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_2_cse
      | operator_11_true_return_1_sva | operator_11_true_return_sva | return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp;
  assign and_dcpl_52 = ~(return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_return_add_generic_AC_RND_CONV_false_op1_smaller_oelse_and_1_cse
      | (z_out_1[11]));
  assign or_dcpl_41 = (fsm_output[5:4]!=2'b00);
  assign or_tmp_43 = return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2
      & (fsm_output[1]);
  assign or_tmp_44 = and_dcpl_52 & (fsm_output[1]);
  assign or_tmp_64 = return_add_generic_AC_RND_CONV_false_e1_eq_e2_equal_tmp & return_add_generic_AC_RND_CONV_false_1_aif_equal_tmp
      & (fsm_output[1]);
  assign or_tmp_65 = (~(return_add_generic_AC_RND_CONV_false_e1_eq_e2_equal_tmp &
      return_add_generic_AC_RND_CONV_false_1_aif_equal_tmp)) & (fsm_output[1]);
  assign nor_11_cse = ~((fsm_output[2:1]!=2'b00));
  assign or_203_cse = (fsm_output[2]) | (fsm_output[4]);
  assign return_add_generic_AC_RND_CONV_false_nor_1_cse = ~(or_203_cse | (fsm_output[10]));
  assign operator_53_false_4_nor_cse = ~((fsm_output[7]) | (fsm_output[5]) | (fsm_output[1])
      | or_203_cse | (fsm_output[3]));
  assign return_div_generic_AC_RND_CONV_false_if_1_nor_cse = ~((fsm_output[1]) |
      (fsm_output[3]));
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en ) begin
      return_add_generic_AC_RND_CONV_false_1_mux_4_itm <= MUX1HOT_v_6_3_2(rtn_out_1,
          (drf_qr_lval_smx_lpi_1_dfm_mx0[5:0]), (return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0[5:0]),
          {return_add_generic_AC_RND_CONV_false_or_nl , and_291_nl , and_295_cse});
      return_add_generic_AC_RND_CONV_false_1_exp_plus_1_0_lpi_1_dfm <= (z_out_11_0[0])
          | (~ (z_out_7[11]));
      return_add_generic_AC_RND_CONV_false_1_exp_plus_1_12_1_lpi_1_dfm <= MUX_v_12_2_2(12'b000000000000,
          (z_out_11[11:0]), nor_30_nl);
      return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva <= MUX_s_1_2_2(return_mult_generic_AC_RND_CONV_false_if_nor_ovfl_sva_1,
          return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_0_sva_1, fsm_output[2]);
      return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_56 <= z_out_9[56];
      return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0 <= MUX1HOT_v_56_3_2((z_out_9[55:0]),
          (z_out_5[56:1]), (~ (z_out_5[56:1])), {return_add_generic_AC_RND_CONV_false_res_mant_or_cse
          , return_add_generic_AC_RND_CONV_false_res_mant_and_nl , return_add_generic_AC_RND_CONV_false_res_mant_and_1_nl});
      return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva <= return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_5_sva_1;
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      reg_done_synci_iswt0_cse <= 1'b0;
      reg_start_synci_oswt_cse <= 1'b0;
      reg_A_d_triosy_obj_iswt0_cse <= 1'b0;
      C_add_d_triosy_obj_iswt0 <= 1'b0;
      C_sub_d_triosy_obj_iswt0 <= 1'b0;
      C_mult_d_triosy_obj_iswt0 <= 1'b0;
      return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_cse_sva
          <= 1'b0;
      operator_33_true_2_acc_psp_sva <= 13'b0000000000000;
      return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva
          <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en ) begin
      reg_done_synci_iswt0_cse <= fsm_output[10];
      reg_start_synci_oswt_cse <= ~ and_dcpl_28;
      reg_A_d_triosy_obj_iswt0_cse <= fsm_output[1];
      C_add_d_triosy_obj_iswt0 <= fsm_output[2];
      C_sub_d_triosy_obj_iswt0 <= fsm_output[4];
      C_mult_d_triosy_obj_iswt0 <= fsm_output[6];
      return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_cse_sva
          <= return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp;
      operator_33_true_2_acc_psp_sva <= MUX_v_13_2_2(operator_33_true_acc_psp_sva_1,
          z_out_4, fsm_output[3]);
      return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva
          <= z_out_7[11];
    end
  end
  always @(posedge clk) begin
    if ( and_340_cse ) begin
      C_add_d_rsci_idat_52 <= (return_add_generic_AC_RND_CONV_false_mux_31 & (~ return_add_generic_AC_RND_CONV_false_1_e_r_qelse_mux_1_nl))
          | return_add_generic_AC_RND_CONV_false_exception_sva_1;
      C_add_d_rsci_idat_51 <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_r_nan_or_1_nl,
          (return_add_generic_AC_RND_CONV_false_res_rounded_lpi_1_dfm_51_0_1[51]),
          and_89_nl);
      C_add_d_rsci_idat_62_53 <= MUX_v_10_2_2(return_add_generic_AC_RND_CONV_false_e_r_qelse_qr_10_1_lpi_1_dfm_1,
          10'b1111111111, return_add_generic_AC_RND_CONV_false_exception_sva_1);
      C_add_d_rsci_idat_50_0 <= MUX_v_51_2_2(51'b000000000000000000000000000000000000000000000000000,
          (return_add_generic_AC_RND_CONV_false_res_rounded_lpi_1_dfm_51_0_1[50:0]),
          return_add_generic_AC_RND_CONV_false_if_7_return_add_generic_AC_RND_CONV_false_if_7_nor_nl);
      C_add_d_rsci_idat_63 <= return_add_generic_AC_RND_CONV_false_op1_nan_sva;
      operator_34_true_acc_psp_sva <= z_out_2;
      return_div_generic_AC_RND_CONV_false_ls_op1_5_0_sva <= rtn_out;
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11 <= 1'b0;
      return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_9_0 <= 10'b0000000000;
    end
    else if ( and_340_cse ) begin
      return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11 <= z_out_7[11];
      return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_9_0 <= z_out_7[9:0];
    end
  end
  always @(posedge clk) begin
    if ( and_345_cse ) begin
      C_sub_d_rsci_idat_52 <= (return_add_generic_AC_RND_CONV_false_mux_31 & (~ return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0))
          | return_add_generic_AC_RND_CONV_false_1_exception_sva_1;
      C_sub_d_rsci_idat_51 <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_r_nan_or_1_nl,
          (return_add_generic_AC_RND_CONV_false_res_rounded_lpi_1_dfm_51_0_1[51]),
          and_103_nl);
      C_sub_d_rsci_idat_62_53 <= MUX_v_10_2_2(return_add_generic_AC_RND_CONV_false_e_r_qelse_qr_10_1_lpi_1_dfm_1,
          10'b1111111111, return_add_generic_AC_RND_CONV_false_1_exception_sva_1);
      C_sub_d_rsci_idat_50_0 <= MUX_v_51_2_2(51'b000000000000000000000000000000000000000000000000000,
          (return_add_generic_AC_RND_CONV_false_res_rounded_lpi_1_dfm_51_0_1[50:0]),
          return_add_generic_AC_RND_CONV_false_1_if_7_return_add_generic_AC_RND_CONV_false_1_if_7_nor_nl);
      C_sub_d_rsci_idat_63 <= return_add_generic_AC_RND_CONV_false_1_mux_itm;
    end
  end
  always @(posedge clk) begin
    if ( and_350_cse ) begin
      C_mult_d_rsci_idat_51 <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_do_sub_sva,
          (z_out_8[51]), and_115_nl);
      C_mult_d_rsci_idat_62_52 <= MUX_v_11_2_2(return_mult_generic_AC_RND_CONV_false_else_2_else_return_mult_generic_AC_RND_CONV_false_else_2_else_and_nl,
          11'b11111111111, return_mult_generic_AC_RND_CONV_false_if_2_return_mult_generic_AC_RND_CONV_false_if_2_or_nl);
      C_mult_d_rsci_idat_50_0 <= MUX_v_51_2_2(51'b000000000000000000000000000000000000000000000000000,
          (z_out_8[50:0]), return_mult_generic_AC_RND_CONV_false_oelse_4_return_mult_generic_AC_RND_CONV_false_if_3_nor_nl);
      C_mult_d_rsci_idat_63 <= return_add_generic_AC_RND_CONV_false_do_sub_sva;
    end
  end
  always @(posedge clk) begin
    if ( and_354_cse ) begin
      C_div_d_rsci_idat_51 <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op1_nan_sva,
          (z_out_9[51]), and_127_nl);
      C_div_d_rsci_idat_62_52 <= MUX_v_11_2_2(return_div_generic_AC_RND_CONV_false_e_r_qelse_return_div_generic_AC_RND_CONV_false_e_r_qelse_and_nl,
          11'b11111111111, return_div_generic_AC_RND_CONV_false_exception_sva_1);
      C_div_d_rsci_idat_50_0 <= MUX_v_51_2_2(51'b000000000000000000000000000000000000000000000000000,
          (z_out_9[50:0]), return_div_generic_AC_RND_CONV_false_if_3_return_div_generic_AC_RND_CONV_false_if_3_nor_nl);
      C_div_d_rsci_idat_63 <= return_add_generic_AC_RND_CONV_false_do_sub_sva;
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_add_generic_AC_RND_CONV_false_else_4_unequal_tmp <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & (fsm_output[1]) & (z_out_7[11]) ) begin
      return_add_generic_AC_RND_CONV_false_else_4_unequal_tmp <= ~((operator_33_true_acc_psp_sva_1[11:0]==12'b011111111111));
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_add_generic_AC_RND_CONV_false_e_r_qelse_or_svs <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & (~((~ (fsm_output[2])) | or_dcpl_33)) )
        begin
      return_add_generic_AC_RND_CONV_false_e_r_qelse_or_svs <= return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0;
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_add_generic_AC_RND_CONV_false_1_else_4_unequal_tmp <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & (fsm_output[3]) & (z_out_7[11]) ) begin
      return_add_generic_AC_RND_CONV_false_1_else_4_unequal_tmp <= ~((z_out_4[11:0]==12'b011111111111));
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_mult_generic_AC_RND_CONV_false_do_shift_left_1_sva <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & (~ (operator_14_false_acc_psp_sva[12]))
        & (fsm_output[3]) ) begin
      return_mult_generic_AC_RND_CONV_false_do_shift_left_1_sva <= z_out_10[12];
    end
  end
  always @(posedge clk) begin
    if ( B_to_helper_t_x_d_and_cse ) begin
      B_to_helper_t_x_d_sva_51_0 <= B_d_rsci_idat[51:0];
      A_to_helper_t_x_d_sva_62_0 <= A_d_rsci_idat[62:0];
      return_add_generic_AC_RND_CONV_false_do_sub_sva <= return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0;
      return_extract_1_return_extract_1_or_1_cse_sva <= return_extract_1_return_extract_1_or_1_cse_sva_mx0w0;
      return_div_generic_AC_RND_CONV_false_ls_op2_5_0_sva <= rtn_out;
      return_mult_generic_AC_RND_CONV_false_if_mux_1_itm <= MUX_v_52_2_2((B_d_rsci_idat[51:0]),
          (A_d_rsci_idat[51:0]), and_221_nl);
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      operator_14_false_acc_psp_sva <= 13'b0000000000000;
      return_extract_return_extract_or_1_cse_sva <= 1'b0;
    end
    else if ( B_to_helper_t_x_d_and_cse ) begin
      operator_14_false_acc_psp_sva <= z_out_2;
      return_extract_return_extract_or_1_cse_sva <= return_extract_return_extract_or_1_tmp;
    end
  end
  always @(posedge clk) begin
    if ( return_add_generic_AC_RND_CONV_false_1_op_bigger_and_cse ) begin
      return_add_generic_AC_RND_CONV_false_1_op_bigger_mux_1_itm <= MUX_s_1_2_2(operator_53_false_1_mux_cse,
          operator_53_false_mux_cse, or_tmp_44);
      return_add_generic_AC_RND_CONV_false_1_op_bigger_mux_3_itm <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1,
          return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1, or_tmp_44);
      return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_52_lpi_1_dfm <= MUX_s_1_2_2(operator_53_false_mux_cse,
          operator_53_false_1_mux_cse, or_tmp_44);
      return_add_generic_AC_RND_CONV_false_1_op_smaller_qr_0_lpi_1_dfm <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1,
          return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1, or_tmp_44);
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (or_tmp_64 | or_tmp_65) ) begin
      return_add_generic_AC_RND_CONV_false_1_mux_itm <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_if_2_return_add_generic_AC_RND_CONV_false_1_if_2_nor_1_nl,
          return_add_generic_AC_RND_CONV_false_1_r_sign_mux_1_nl, or_tmp_65);
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (~ (fsm_output[2])) ) begin
      return_mult_generic_AC_RND_CONV_false_if_ac_fixed_cctor_4_1_sva <= ~(MUX_v_4_2_2(4'b0000,
          (z_out_2[4:1]), return_mult_generic_AC_RND_CONV_false_if_not_nl));
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (~(or_dcpl_41 | (fsm_output[3:2]!=2'b00))) )
        begin
      return_mult_generic_AC_RND_CONV_false_p_1_sva <= ({return_extract_return_extract_or_1_tmp
          , (A_d_rsci_idat[51:0])}) * ({return_extract_1_return_extract_1_or_1_cse_sva_mx0w0
          , (B_d_rsci_idat[51:0])});
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_add_generic_AC_RND_CONV_false_1_do_sub_sva <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & ((fsm_output[1]) | (fsm_output[4])) ) begin
      return_add_generic_AC_RND_CONV_false_1_do_sub_sva <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_do_sub_return_add_generic_AC_RND_CONV_false_1_do_sub_return_add_generic_AC_RND_CONV_false_1_do_sub_xnor_nl,
          return_mult_generic_AC_RND_CONV_false_r_nan_or_nl, fsm_output[4]);
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (~(or_dcpl_41 | (fsm_output[2]))) ) begin
      return_add_generic_AC_RND_CONV_false_1_e_dif_sat_sva <= MUX1HOT_v_6_3_2(return_add_generic_AC_RND_CONV_false_1_e_dif_sat_or_nl,
          rtn_out, (operator_14_false_acc_psp_sva[5:0]), {(fsm_output[1]) , return_add_generic_AC_RND_CONV_false_1_e_dif_sat_and_nl
          , return_add_generic_AC_RND_CONV_false_1_e_dif_sat_and_1_nl});
    end
  end
  always @(posedge clk) begin
    if ( return_div_generic_AC_RND_CONV_false_exp_and_1_cse ) begin
      return_div_generic_AC_RND_CONV_false_exp_acc_itm <= MUX_v_12_2_2((z_out_4[11:0]),
          z_out_11_0, fsm_output[2]);
      return_div_generic_AC_RND_CONV_false_if_1_slc_operator_57_true_return_55_0_55_1_itm
          <= operator_57_true_lshift_itm[55:1];
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_extract_m_zero_sva <= 1'b0;
      operator_11_true_return_1_sva <= 1'b0;
      operator_11_true_return_sva <= 1'b0;
      return_add_generic_AC_RND_CONV_false_op2_inf_sva <= 1'b0;
      return_add_generic_AC_RND_CONV_false_op2_nan_sva <= 1'b0;
    end
    else if ( return_extract_m_zero_and_cse ) begin
      return_extract_m_zero_sva <= MUX_s_1_2_2(return_extract_m_zero_return_extract_m_zero_nor_nl,
          return_extract_5_and_nl, fsm_output[2]);
      operator_11_true_return_1_sva <= MUX_s_1_2_2(operator_11_true_1_operator_11_true_1_and_nl,
          return_add_generic_AC_RND_CONV_false_op1_inf_sva_mx0w1, fsm_output[2]);
      operator_11_true_return_sva <= MUX_s_1_2_2(operator_11_true_operator_11_true_and_nl,
          return_extract_4_and_nl, fsm_output[2]);
      return_add_generic_AC_RND_CONV_false_op2_inf_sva <= MUX_s_1_2_2(return_extract_1_m_zero_return_extract_1_m_zero_nor_nl,
          return_add_generic_AC_RND_CONV_false_op2_inf_sva_mx0w1, fsm_output[2]);
      return_add_generic_AC_RND_CONV_false_op2_nan_sva <= MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp,
          return_add_generic_AC_RND_CONV_false_op2_nan_sva_mx0w1, fsm_output[2]);
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & ((fsm_output[6]) | (fsm_output[3]) | (fsm_output[1]))
        ) begin
      return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva <= MUX_s_1_2_2(all_same_out,
          return_div_generic_AC_RND_CONV_false_r_zero_or_nl, fsm_output[6]);
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_add_generic_AC_RND_CONV_false_op1_nan_sva <= 1'b0;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & (or_tmp_64 | or_tmp_65 | (fsm_output[2])
        | (fsm_output[4])) ) begin
      return_add_generic_AC_RND_CONV_false_op1_nan_sva <= MUX1HOT_s_1_5_2(return_add_generic_AC_RND_CONV_false_if_2_return_add_generic_AC_RND_CONV_false_if_2_and_2_nl,
          (A_d_rsci_idat[63]), (B_d_rsci_idat[63]), return_add_generic_AC_RND_CONV_false_op1_nan_sva_mx0w2,
          return_div_generic_AC_RND_CONV_false_r_nan_or_nl, {or_tmp_64 , return_add_generic_AC_RND_CONV_false_if_2_and_nl
          , return_add_generic_AC_RND_CONV_false_if_2_and_1_nl , (fsm_output[2])
          , (fsm_output[4])});
    end
  end
  always @(posedge clk) begin
    if ( return_mult_generic_AC_RND_CONV_false_exp_and_ssc ) begin
      return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_11 <= return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_mx0w1[11];
    end
  end
  always @(posedge clk) begin
    if ( return_mult_generic_AC_RND_CONV_false_exp_and_ssc & (~ (fsm_output[2]))
        ) begin
      return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0 <= MUX1HOT_v_11_3_2((B_d_rsci_idat[62:52]),
          (A_d_rsci_idat[62:52]), (return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_mx0w1[10:0]),
          {or_tmp_43 , or_tmp_44 , (fsm_output[3])});
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (~ or_dcpl_41) ) begin
      operator_53_false_4_lshift_itm_52_51 <= MUX_v_2_2_2((z_out_5[53:52]), (z_out_6[52:51]),
          fsm_output[7]);
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (~ (fsm_output[2])) & (~ or_dcpl_41) ) begin
      operator_53_false_4_lshift_itm_50_0 <= MUX1HOT_v_51_4_2(operator_53_false_1_mux_2_cse,
          operator_53_false_mux_2_cse, (z_out_5[51:1]), (z_out_6[50:0]), {or_tmp_43
          , or_tmp_44 , (fsm_output[3]) , (fsm_output[7])});
    end
  end
  always @(posedge clk) begin
    if ( operator_53_false_5_and_ssc ) begin
      operator_53_false_5_lshift_itm_52_51 <= z_out_6[52:51];
    end
  end
  always @(posedge clk) begin
    if ( operator_53_false_5_and_ssc & (~ (fsm_output[2])) ) begin
      operator_53_false_5_lshift_itm_50_0 <= MUX1HOT_v_51_3_2(operator_53_false_mux_2_cse,
          operator_53_false_1_mux_2_cse, (z_out_6[50:0]), {or_tmp_43 , or_tmp_44
          , (fsm_output[5])});
    end
  end
  always @(posedge clk) begin
    if ( ac_fx_div_53_ccs_ccore_en & (~(or_dcpl_41 | (fsm_output[3]))) ) begin
      return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_or_itm
          <= ((return_mult_generic_AC_RND_CONV_false_p_1_sva[105]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[52])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[104]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[51])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[103]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[50])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[102]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[49])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[101]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[48])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[100]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[47])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[99]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[46])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[98]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[45])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[97]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[44])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[96]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[43])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[95]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[42])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[94]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[41])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[93]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[40])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[92]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[39])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[91]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[38])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[90]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[37])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[89]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[36])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[88]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[35])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[87]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[34])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[86]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[33])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[85]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[32])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[84]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[31])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[83]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[30])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[82]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[29])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[81]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[28])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[80]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[27])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[79]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[26])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[78]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[25])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[77]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[24])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[76]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[23])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[75]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[22])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[74]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[21])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[73]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[20])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[72]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[19])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[71]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[18])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[70]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[17])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[69]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[16])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[68]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[15])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[67]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[14])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[66]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[13])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[65]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[12])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[64]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[11])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[63]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[10])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[62]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[9])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[61]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[8])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[60]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[7])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[59]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[6])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[58]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[5])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[57]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[4])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[56]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[3])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[55]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[2])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[54]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[1])))
          | ((return_mult_generic_AC_RND_CONV_false_p_1_sva[53]) & (~ (return_mult_generic_AC_RND_CONV_false_else_1_lshift_itm[0])))
          | (return_mult_generic_AC_RND_CONV_false_p_1_sva[52:0]!=53'b00000000000000000000000000000000000000000000000000000);
    end
  end
  always @(posedge clk) begin
    if ( ~ rstn ) begin
      return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva <= 12'b000000000000;
    end
    else if ( ac_fx_div_53_ccs_ccore_en & (fsm_output[3]) ) begin
      return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva <= nl_return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva[11:0];
    end
  end
  assign return_add_generic_AC_RND_CONV_false_or_nl = ((z_out_7[11]) & (fsm_output[1]))
      | ((z_out_7[11]) & (fsm_output[3]));
  assign and_291_nl = (~ (z_out_7[11])) & (fsm_output[1]);
  assign nor_30_nl = ~((~((z_out_7[11]) | (fsm_output[3]))) | and_295_cse);
  assign return_add_generic_AC_RND_CONV_false_res_mant_and_nl = (~ return_add_generic_AC_RND_CONV_false_1_do_sub_sva)
      & (fsm_output[2]);
  assign return_add_generic_AC_RND_CONV_false_res_mant_and_1_nl = return_add_generic_AC_RND_CONV_false_1_do_sub_sva
      & (fsm_output[2]);
  assign return_add_generic_AC_RND_CONV_false_1_e_r_qelse_mux_1_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_1_e_r_qelse_or_svs_mx0w0,
      return_add_generic_AC_RND_CONV_false_e_r_qelse_or_svs, or_dcpl_33);
  assign return_add_generic_AC_RND_CONV_false_r_nan_or_1_nl = return_add_generic_AC_RND_CONV_false_op1_nan_sva_mx0w2
      | return_add_generic_AC_RND_CONV_false_op2_nan_sva_mx0w1 | (return_add_generic_AC_RND_CONV_false_op1_inf_sva_mx0w1
      & return_add_generic_AC_RND_CONV_false_op2_inf_sva_mx0w1 & return_add_generic_AC_RND_CONV_false_do_sub_sva);
  assign and_89_nl = (~(((~((~ (operator_33_true_2_acc_psp_sva[11])) & return_add_generic_AC_RND_CONV_false_else_4_unequal_tmp))
      & return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva)
      | operator_11_true_return_1_sva)) & (~(operator_11_true_return_sva | return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp
      | return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva)) & (fsm_output[2]);
  assign return_add_generic_AC_RND_CONV_false_if_7_return_add_generic_AC_RND_CONV_false_if_7_nor_nl
      = ~(return_add_generic_AC_RND_CONV_false_exception_sva_1 | return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva);
  assign return_add_generic_AC_RND_CONV_false_1_r_nan_or_1_nl = return_add_generic_AC_RND_CONV_false_op1_nan_sva
      | return_add_generic_AC_RND_CONV_false_op2_nan_sva | (operator_11_true_return_1_sva
      & return_add_generic_AC_RND_CONV_false_op2_inf_sva & return_add_generic_AC_RND_CONV_false_1_do_sub_sva);
  assign and_103_nl = (~((~((~ (operator_33_true_2_acc_psp_sva[11])) & return_add_generic_AC_RND_CONV_false_1_else_4_unequal_tmp))
      & return_add_generic_AC_RND_CONV_false_1_if_4_slc_return_add_generic_AC_RND_CONV_false_1_acc_2_11_mdf_sva))
      & (~(operator_11_true_return_1_sva | return_add_generic_AC_RND_CONV_false_op2_inf_sva))
      & (~(return_add_generic_AC_RND_CONV_false_op2_nan_sva | return_add_generic_AC_RND_CONV_false_op1_nan_sva))
      & (~(return_add_generic_AC_RND_CONV_false_1_if_5_return_add_generic_AC_RND_CONV_false_1_if_5_and_1_tmp
      | return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva)) & (fsm_output[4]);
  assign return_add_generic_AC_RND_CONV_false_1_if_7_return_add_generic_AC_RND_CONV_false_1_if_7_nor_nl
      = ~(return_add_generic_AC_RND_CONV_false_1_exception_sva_1 | return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva);
  assign and_115_nl = and_dcpl_46 & (~(operator_11_true_return_sva | return_add_generic_AC_RND_CONV_false_op2_inf_sva))
      & (~(return_add_generic_AC_RND_CONV_false_1_do_sub_sva | (return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva[11])
      | return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aif_return_mult_generic_AC_RND_CONV_false_exp_ovf_oif_aelse_and_tmp))
      & (fsm_output[6]);
  assign return_mult_generic_AC_RND_CONV_false_else_2_else_else_mux_nl = MUX_v_11_2_2(return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0,
      (return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva[10:0]), return_mult_generic_AC_RND_CONV_false_e_incr_lpi_1_dfm_2);
  assign return_mult_generic_AC_RND_CONV_false_zero_m_oelse_not_nl = ~ return_mult_generic_AC_RND_CONV_false_zero_m_lor_sva_1;
  assign return_mult_generic_AC_RND_CONV_false_else_2_else_return_mult_generic_AC_RND_CONV_false_else_2_else_and_nl
      = MUX_v_11_2_2(11'b00000000000, return_mult_generic_AC_RND_CONV_false_else_2_else_else_mux_nl,
      return_mult_generic_AC_RND_CONV_false_zero_m_oelse_not_nl);
  assign return_mult_generic_AC_RND_CONV_false_if_2_return_mult_generic_AC_RND_CONV_false_if_2_or_nl
      = return_mult_generic_AC_RND_CONV_false_exp_ovf_lor_lpi_1_dfm_2 | return_mult_generic_AC_RND_CONV_false_lor_lpi_1_dfm_1;
  assign return_mult_generic_AC_RND_CONV_false_oelse_4_return_mult_generic_AC_RND_CONV_false_if_3_nor_nl
      = ~(return_mult_generic_AC_RND_CONV_false_exp_ovf_lor_lpi_1_dfm_2 | return_mult_generic_AC_RND_CONV_false_zero_m_lor_sva_1
      | return_mult_generic_AC_RND_CONV_false_lor_lpi_1_dfm_1);
  assign and_127_nl = and_dcpl_46 & (~ return_add_generic_AC_RND_CONV_false_op1_nan_sva)
      & (~(return_div_generic_AC_RND_CONV_false_r_inf_acc_itm_12_1 | return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva))
      & (fsm_output[10]);
  assign return_div_generic_AC_RND_CONV_false_e_r_qelse_return_div_generic_AC_RND_CONV_false_e_r_qelse_nor_nl
      = ~(return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva | (~((z_out_9[53:52]!=2'b00))));
  assign return_div_generic_AC_RND_CONV_false_e_r_qelse_return_div_generic_AC_RND_CONV_false_e_r_qelse_and_nl
      = MUX_v_11_2_2(11'b00000000000, (z_out_11[10:0]), return_div_generic_AC_RND_CONV_false_e_r_qelse_return_div_generic_AC_RND_CONV_false_e_r_qelse_nor_nl);
  assign return_div_generic_AC_RND_CONV_false_if_3_return_div_generic_AC_RND_CONV_false_if_3_nor_nl
      = ~(return_div_generic_AC_RND_CONV_false_exception_sva_1 | return_add_generic_AC_RND_CONV_false_1_r_zero_1_sva);
  assign and_221_nl = (~ return_extract_return_extract_or_1_tmp) & (fsm_output[1]);
  assign return_add_generic_AC_RND_CONV_false_1_if_2_return_add_generic_AC_RND_CONV_false_1_if_2_nor_1_nl
      = ~((B_d_rsci_idat[63]) | (~ (A_d_rsci_idat[63])));
  assign return_add_generic_AC_RND_CONV_false_1_r_sign_mux_1_nl = MUX_s_1_2_2((A_d_rsci_idat[63]),
      (~ (B_d_rsci_idat[63])), return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2);
  assign return_mult_generic_AC_RND_CONV_false_if_not_nl = ~ return_mult_generic_AC_RND_CONV_false_if_nor_ovfl_sva_1;
  assign return_add_generic_AC_RND_CONV_false_1_do_sub_return_add_generic_AC_RND_CONV_false_1_do_sub_return_add_generic_AC_RND_CONV_false_1_do_sub_xnor_nl
      = ~((A_d_rsci_idat[63]) ^ (B_d_rsci_idat[63]));
  assign return_mult_generic_AC_RND_CONV_false_r_nan_or_nl = return_add_generic_AC_RND_CONV_false_op1_nan_sva
      | return_add_generic_AC_RND_CONV_false_op2_nan_sva | (operator_11_true_return_1_sva
      & return_extract_m_zero_sva) | (operator_11_true_return_sva & return_add_generic_AC_RND_CONV_false_op2_inf_sva);
  assign return_add_generic_AC_RND_CONV_false_1_e_dif_sat_or_1_nl = (return_add_generic_AC_RND_CONV_false_1_e_dif_qr_lpi_1_dfm_mx0_10_0[10:6]!=5'b00000)
      | ((return_add_generic_AC_RND_CONV_false_e_dif_qif_acc_1_cse[11]) & (z_out_1[11]));
  assign return_add_generic_AC_RND_CONV_false_1_e_dif_sat_or_nl = MUX_v_6_2_2((return_add_generic_AC_RND_CONV_false_1_e_dif_qr_lpi_1_dfm_mx0_10_0[5:0]),
      6'b111111, return_add_generic_AC_RND_CONV_false_1_e_dif_sat_or_1_nl);
  assign return_add_generic_AC_RND_CONV_false_1_e_dif_sat_and_nl = (~ (operator_6_false_4_acc_tmp[12]))
      & (fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_1_e_dif_sat_and_1_nl = (operator_6_false_4_acc_tmp[12])
      & (fsm_output[3]);
  assign return_extract_m_zero_return_extract_m_zero_nor_nl = ~((A_d_rsci_idat[51:0]!=52'b0000000000000000000000000000000000000000000000000000));
  assign return_extract_5_and_nl = return_add_generic_AC_RND_CONV_false_op2_nan_sva
      & return_add_generic_AC_RND_CONV_false_op2_inf_sva;
  assign operator_11_true_1_operator_11_true_1_and_nl = (B_d_rsci_idat[62:52]==11'b11111111111);
  assign operator_11_true_operator_11_true_and_nl = (A_d_rsci_idat[62:52]==11'b11111111111);
  assign return_extract_4_and_nl = return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_cse_sva
      & return_extract_m_zero_sva;
  assign return_extract_1_m_zero_return_extract_1_m_zero_nor_nl = ~((B_d_rsci_idat[51:0]!=52'b0000000000000000000000000000000000000000000000000000));
  assign return_div_generic_AC_RND_CONV_false_r_zero_or_nl = operator_11_true_return_sva
      | return_add_generic_AC_RND_CONV_false_op2_inf_sva;
  assign return_add_generic_AC_RND_CONV_false_if_2_return_add_generic_AC_RND_CONV_false_if_2_and_2_nl
      = (B_d_rsci_idat[63]) & (A_d_rsci_idat[63]);
  assign return_div_generic_AC_RND_CONV_false_r_nan_or_nl = return_add_generic_AC_RND_CONV_false_op1_nan_sva
      | return_add_generic_AC_RND_CONV_false_op2_nan_sva | return_add_generic_AC_RND_CONV_false_op1_inf_sva_mx0w1
      | return_add_generic_AC_RND_CONV_false_op2_inf_sva_mx0w1;
  assign return_add_generic_AC_RND_CONV_false_if_2_and_nl = (~ return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2)
      & or_tmp_65;
  assign return_add_generic_AC_RND_CONV_false_if_2_and_1_nl = return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2
      & or_tmp_65;
  assign nl_return_mult_generic_AC_RND_CONV_false_exp_plus_1_acc_psp_1_sva  = return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_mx0w1
      + 12'b000000000001;
  assign return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_and_1_nl
      = (z_out_2[12]) & return_div_generic_AC_RND_CONV_false_if_1_nor_cse;
  assign return_div_generic_AC_RND_CONV_false_if_1_mux1h_5_nl = MUX1HOT_v_11_3_2((z_out_2[11:1]),
      drf_qr_lval_smx_lpi_1_dfm_mx0, return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0,
      {(fsm_output[2]) , (fsm_output[1]) , (fsm_output[3])});
  assign return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_or_2_nl
      = MUX_v_4_2_2((z_out_7[9:6]), 4'b1111, return_add_generic_AC_RND_CONV_false_res_mant_or_cse);
  assign return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_mux_1_nl
      = MUX_v_6_2_2((z_out_7[5:0]), (~ rtn_out_1), return_add_generic_AC_RND_CONV_false_res_mant_or_cse);
  assign nl_acc_nl = ({return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_and_1_nl
      , return_div_generic_AC_RND_CONV_false_if_1_mux1h_5_nl , (~ (fsm_output[2]))})
      + conv_s2u_12_13({(~ (fsm_output[2])) , return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_or_2_nl
      , return_div_generic_AC_RND_CONV_false_if_1_return_div_generic_AC_RND_CONV_false_if_1_mux_1_nl
      , 1'b1});
  assign acc_nl = nl_acc_nl[12:0];
  assign z_out_11_0 = readslicef_13_12_1(acc_nl);
  assign return_add_generic_AC_RND_CONV_false_e_dif1_mux_4_nl = MUX_v_5_2_2((A_d_rsci_idat[62:58]),
      5'b01111, fsm_output[2]);
  assign return_add_generic_AC_RND_CONV_false_e_dif1_mux_5_nl = MUX_v_6_2_2((A_d_rsci_idat[57:52]),
      (~ rtn_out), fsm_output[2]);
  assign return_add_generic_AC_RND_CONV_false_e_dif1_or_1_nl = return_extract_1_return_extract_1_or_1_cse_sva
      | (fsm_output[1]);
  assign return_add_generic_AC_RND_CONV_false_e_dif1_mux_6_nl = MUX_v_11_2_2((~ (B_d_rsci_idat[62:52])),
      (A_to_helper_t_x_d_sva_62_0[62:52]), fsm_output[2]);
  assign nl_acc_1_nl = ({1'b1 , return_add_generic_AC_RND_CONV_false_e_dif1_mux_4_nl
      , return_add_generic_AC_RND_CONV_false_e_dif1_mux_5_nl , return_add_generic_AC_RND_CONV_false_e_dif1_or_1_nl})
      + conv_u2u_12_13({return_add_generic_AC_RND_CONV_false_e_dif1_mux_6_nl , 1'b1});
  assign acc_1_nl = nl_acc_1_nl[12:0];
  assign z_out_1 = readslicef_13_12_1(acc_1_nl);
  assign return_mult_generic_AC_RND_CONV_false_exp_return_mult_generic_AC_RND_CONV_false_exp_and_1_nl
      = (return_div_generic_AC_RND_CONV_false_exp_acc_itm[11]) & (fsm_output[2]);
  assign return_mult_generic_AC_RND_CONV_false_exp_mux_3_nl = MUX_v_11_2_2((A_d_rsci_idat[62:52]),
      (return_div_generic_AC_RND_CONV_false_exp_acc_itm[10:0]), fsm_output[2]);
  assign return_mult_generic_AC_RND_CONV_false_exp_and_6_nl = return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_1_return_add_generic_AC_RND_CONV_false_op2_normal_return_extract_1_nor_tmp
      & (~ (fsm_output[2]));
  assign nl_return_mult_generic_AC_RND_CONV_false_exp_acc_2_nl = conv_u2s_11_12(B_d_rsci_idat[62:52])
      + conv_s2s_11_12({10'b1000000000 , (~ return_extract_return_extract_or_1_tmp)})
      + 12'b000000000001;
  assign return_mult_generic_AC_RND_CONV_false_exp_acc_2_nl = nl_return_mult_generic_AC_RND_CONV_false_exp_acc_2_nl[11:0];
  assign return_mult_generic_AC_RND_CONV_false_exp_mux_4_nl = MUX_v_12_2_2(return_mult_generic_AC_RND_CONV_false_exp_acc_2_nl,
      z_out_1, fsm_output[2]);
  assign nl_acc_2_nl = conv_u2u_13_14({return_mult_generic_AC_RND_CONV_false_exp_return_mult_generic_AC_RND_CONV_false_exp_and_1_nl
      , return_mult_generic_AC_RND_CONV_false_exp_mux_3_nl , return_mult_generic_AC_RND_CONV_false_exp_and_6_nl})
      + conv_s2u_13_14({return_mult_generic_AC_RND_CONV_false_exp_mux_4_nl , 1'b1});
  assign acc_2_nl = nl_acc_2_nl[13:0];
  assign z_out_2 = readslicef_14_13_1(acc_2_nl);
  assign nl_z_out_3 = ({1'b1 , (~ (rtn_out_1[5:1]))}) + 6'b000001;
  assign z_out_3 = nl_z_out_3[5:0];
  assign return_div_generic_AC_RND_CONV_false_exp_mux_3_nl = MUX_v_11_2_2((~ (B_d_rsci_idat[62:52])),
      return_mult_generic_AC_RND_CONV_false_exp_1_11_0_lpi_1_dfm_10_0, fsm_output[3]);
  assign return_div_generic_AC_RND_CONV_false_exp_and_2_nl = return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_if_return_add_generic_AC_RND_CONV_false_op1_normal_return_extract_nor_tmp
      & (~ (fsm_output[3]));
  assign return_div_generic_AC_RND_CONV_false_exp_return_div_generic_AC_RND_CONV_false_exp_and_1_nl
      = (z_out_3[5]) & (fsm_output[3]);
  assign return_div_generic_AC_RND_CONV_false_exp_mux_4_nl = MUX_v_5_2_2((rtn_out[5:1]),
      (z_out_3[4:0]), fsm_output[3]);
  assign return_div_generic_AC_RND_CONV_false_exp_mux_5_nl = MUX_s_1_2_2((rtn_out[0]),
      (~ (rtn_out_1[0])), fsm_output[3]);
  assign nl_acc_4_nl = conv_u2u_12_14({return_div_generic_AC_RND_CONV_false_exp_mux_3_nl
      , return_div_generic_AC_RND_CONV_false_exp_and_2_nl}) + conv_s2u_8_14({return_div_generic_AC_RND_CONV_false_exp_return_div_generic_AC_RND_CONV_false_exp_and_1_nl
      , return_div_generic_AC_RND_CONV_false_exp_mux_4_nl , return_div_generic_AC_RND_CONV_false_exp_mux_5_nl
      , 1'b1});
  assign acc_4_nl = nl_acc_4_nl[13:0];
  assign z_out_4 = readslicef_14_13_1(acc_4_nl);
  assign return_add_generic_AC_RND_CONV_false_if_4_mux1h_2_nl = MUX1HOT_v_12_3_2((~
      (operator_33_true_acc_psp_sva_1[11:0])), (~ (z_out_4[11:0])), (~ (z_out_2[12:1])),
      {(fsm_output[1]) , (fsm_output[3]) , (fsm_output[2])});
  assign nl_z_out_7 = return_add_generic_AC_RND_CONV_false_if_4_mux1h_2_nl + 12'b000000000001;
  assign z_out_7 = nl_z_out_7[11:0];
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_3_nl = return_mult_generic_AC_RND_CONV_false_return_mult_generic_AC_RND_CONV_false_nor_ssc
      & (fsm_output[6]);
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_4_nl = return_mult_generic_AC_RND_CONV_false_and_2_ssc
      & (fsm_output[6]);
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_5_nl = (operator_14_false_acc_psp_sva[12])
      & (fsm_output[6]);
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux1h_1_nl
      = MUX1HOT_v_2_4_2((A_d_rsci_idat[51:50]), (z_out_6[104:103]), (z_out_6[103:102]),
      operator_53_false_4_lshift_itm_52_51, {(~ (fsm_output[6])) , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_3_nl
      , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_4_nl , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_and_5_nl});
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux_5_nl = MUX_v_50_2_2((A_d_rsci_idat[49:0]),
      (return_mult_generic_AC_RND_CONV_false_res_bef_rnd_3_53_1_lpi_1_dfm_1_50_0[50:1]),
      fsm_output[6]);
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_or_1_nl = (~ (fsm_output[6]))
      | (fsm_output[1]);
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_nor_1_nl
      = ~(MUX_v_51_2_2((B_d_rsci_idat[51:1]), 51'b111111111111111111111111111111111111111111111111111,
      (fsm_output[6])));
  assign return_mult_generic_AC_RND_CONV_false_if_1_or_1_nl = (z_out_6[50:0]!=51'b000000000000000000000000000000000000000000000000000)
      | (return_mult_generic_AC_RND_CONV_false_if_1_aelse_return_mult_generic_AC_RND_CONV_false_if_1_aelse_or_2
      & (z_out_6[51]));
  assign return_mult_generic_AC_RND_CONV_false_mux_14_nl = MUX_s_1_2_2(return_mult_generic_AC_RND_CONV_false_if_1_or_1_nl,
      return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_return_mult_generic_AC_RND_CONV_false_else_1_sticky_bit_or_itm,
      operator_14_false_acc_psp_sva[12]);
  assign return_mult_generic_AC_RND_CONV_false_and_3_nl = (return_mult_generic_AC_RND_CONV_false_res_bef_rnd_3_53_1_lpi_1_dfm_1_50_0[0])
      & (return_mult_generic_AC_RND_CONV_false_mux_14_nl | (return_mult_generic_AC_RND_CONV_false_res_bef_rnd_3_53_1_lpi_1_dfm_1_50_0[1]));
  assign return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux_6_nl = MUX_s_1_2_2((~
      (B_d_rsci_idat[0])), return_mult_generic_AC_RND_CONV_false_and_3_nl, fsm_output[6]);
  assign nl_acc_6_nl = ({(~ (fsm_output[6])) , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux1h_1_nl
      , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux_5_nl , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_or_1_nl})
      + conv_u2u_53_54({return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_nor_1_nl
      , return_add_generic_AC_RND_CONV_false_1_ma1_lt_ma2_mux_6_nl , 1'b1});
  assign acc_6_nl = nl_acc_6_nl[53:0];
  assign z_out_8 = readslicef_54_53_1(acc_6_nl);
  assign return_add_generic_AC_RND_CONV_false_mux_38_nl = MUX_v_4_2_2((return_add_generic_AC_RND_CONV_false_res_mant_conc_2_itm_56_1[55:52]),
      (return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0[55:52]), fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_17_nl
      = MUX_v_4_2_2(4'b0000, return_add_generic_AC_RND_CONV_false_mux_38_nl, return_add_generic_AC_RND_CONV_false_nor_1_cse);
  assign return_add_generic_AC_RND_CONV_false_mux1h_7_nl = MUX1HOT_v_52_4_2((return_add_generic_AC_RND_CONV_false_res_mant_conc_2_itm_56_1[51:0]),
      (return_add_generic_AC_RND_CONV_false_1_res_mant_4_sva_55_0[51:0]), (z_out_6[56:5]),
      (return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0[55:4]), {(fsm_output[1])
      , (fsm_output[3]) , or_203_cse , (fsm_output[10])});
  assign return_add_generic_AC_RND_CONV_false_and_7_nl = (~ return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0)
      & (fsm_output[1]);
  assign return_add_generic_AC_RND_CONV_false_and_8_nl = return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0
      & (fsm_output[1]);
  assign return_add_generic_AC_RND_CONV_false_and_9_nl = (~ return_add_generic_AC_RND_CONV_false_1_do_sub_sva)
      & (fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_and_10_nl = return_add_generic_AC_RND_CONV_false_1_do_sub_sva
      & (fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_mux1h_8_nl = MUX1HOT_s_1_6_2(return_add_generic_AC_RND_CONV_false_res_mant_3_0_sva_1,
      (~ return_add_generic_AC_RND_CONV_false_res_mant_3_0_sva_1), return_add_generic_AC_RND_CONV_false_1_res_mant_3_0_sva_1,
      (~ return_add_generic_AC_RND_CONV_false_1_res_mant_3_0_sva_1), (z_out_6[4]),
      (return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0[3]), {return_add_generic_AC_RND_CONV_false_and_7_nl
      , return_add_generic_AC_RND_CONV_false_and_8_nl , return_add_generic_AC_RND_CONV_false_and_9_nl
      , return_add_generic_AC_RND_CONV_false_and_10_nl , or_203_cse , (fsm_output[10])});
  assign return_add_generic_AC_RND_CONV_false_mux_39_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_do_sub_sva_mx0w0,
      return_add_generic_AC_RND_CONV_false_1_do_sub_sva, fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_and_11_nl = return_add_generic_AC_RND_CONV_false_mux_39_nl
      & return_add_generic_AC_RND_CONV_false_nor_1_cse;
  assign return_add_generic_AC_RND_CONV_false_op_bigger_mux_6_nl = MUX_s_1_2_2(operator_53_false_mux_cse,
      operator_53_false_1_mux_cse, return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2);
  assign return_add_generic_AC_RND_CONV_false_mux_40_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op_bigger_mux_6_nl,
      return_add_generic_AC_RND_CONV_false_1_op_bigger_mux_1_itm, fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_18_nl
      = return_add_generic_AC_RND_CONV_false_mux_40_nl & return_add_generic_AC_RND_CONV_false_nor_1_cse;
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_nor_1_nl
      = ~(return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2 | (fsm_output[3]));
  assign return_add_generic_AC_RND_CONV_false_and_12_nl = return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2
      & (~ (fsm_output[3]));
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_mux1h_1_nl
      = MUX1HOT_v_51_3_2(operator_53_false_mux_2_cse, operator_53_false_1_mux_2_cse,
      operator_53_false_4_lshift_itm_50_0, {return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_nor_1_nl
      , return_add_generic_AC_RND_CONV_false_and_12_nl , (fsm_output[3])});
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_19_nl
      = MUX_v_51_2_2(51'b000000000000000000000000000000000000000000000000000, return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_mux1h_1_nl,
      return_add_generic_AC_RND_CONV_false_nor_1_cse);
  assign return_add_generic_AC_RND_CONV_false_op_bigger_mux_7_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op1_mu_0_lpi_1_dfm_1,
      return_add_generic_AC_RND_CONV_false_op2_mu_0_lpi_1_dfm_1, return_add_generic_AC_RND_CONV_false_op1_smaller_lor_lpi_1_dfm_2);
  assign return_add_generic_AC_RND_CONV_false_mux_41_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_op_bigger_mux_7_nl,
      return_add_generic_AC_RND_CONV_false_1_op_bigger_mux_3_itm, fsm_output[3]);
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_20_nl
      = return_add_generic_AC_RND_CONV_false_mux_41_nl & return_add_generic_AC_RND_CONV_false_nor_1_cse;
  assign return_add_generic_AC_RND_CONV_false_res_rounded_and_3_nl = (z_out_6[3])
      & ((z_out_6[0]) | (z_out_6[1]) | (z_out_6[2]) | (z_out_6[4]));
  assign return_div_generic_AC_RND_CONV_false_if_1_or_4_nl = (~ ac_fx_div_53_cmp_exact_rsc_z)
      | (return_div_generic_AC_RND_CONV_false_if_1_and_psp_sva_1!=55'b0000000000000000000000000000000000000000000000000000000);
  assign return_div_generic_AC_RND_CONV_false_mux_8_nl = MUX_s_1_2_2(return_div_generic_AC_RND_CONV_false_if_1_or_4_nl,
      (~ ac_fx_div_53_cmp_exact_rsc_z), return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11);
  assign return_div_generic_AC_RND_CONV_false_r_rnd_and_1_nl = (return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0[2])
      & ((return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0[0]) | return_div_generic_AC_RND_CONV_false_mux_8_nl
      | (return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0[1]) | (return_div_generic_AC_RND_CONV_false_q_3_lpi_1_dfm_mx0[3]));
  assign return_add_generic_AC_RND_CONV_false_mux_42_nl = MUX_s_1_2_2(return_add_generic_AC_RND_CONV_false_res_rounded_and_3_nl,
      return_div_generic_AC_RND_CONV_false_r_rnd_and_1_nl, fsm_output[10]);
  assign return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_21_nl
      = return_add_generic_AC_RND_CONV_false_mux_42_nl & return_div_generic_AC_RND_CONV_false_if_1_nor_cse;
  assign nl_acc_7_nl = ({return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_17_nl
      , return_add_generic_AC_RND_CONV_false_mux1h_7_nl , return_add_generic_AC_RND_CONV_false_mux1h_8_nl
      , return_add_generic_AC_RND_CONV_false_and_11_nl}) + conv_u2u_57_58({return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_18_nl
      , return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_19_nl
      , return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_20_nl
      , 2'b00 , return_add_generic_AC_RND_CONV_false_return_add_generic_AC_RND_CONV_false_and_21_nl
      , 1'b1});
  assign acc_7_nl = nl_acc_7_nl[57:0];
  assign z_out_9 = readslicef_58_57_1(acc_7_nl);
  assign return_mult_generic_AC_RND_CONV_false_if_mux_4_nl = MUX_v_13_2_2((~ operator_6_false_4_acc_tmp),
      operator_34_true_acc_psp_sva, fsm_output[10]);
  assign return_mult_generic_AC_RND_CONV_false_if_or_6_nl = (~ (fsm_output[3])) |
      (fsm_output[10]);
  assign return_mult_generic_AC_RND_CONV_false_if_return_mult_generic_AC_RND_CONV_false_if_or_1_nl
      = (ac_fx_div_53_cmp_quotient_rsc_z[54]) | (~ (fsm_output[10]));
  assign nl_acc_8_nl = ({return_mult_generic_AC_RND_CONV_false_if_mux_4_nl , return_mult_generic_AC_RND_CONV_false_if_or_6_nl})
      + conv_s2u_3_14({(fsm_output[10]) , return_mult_generic_AC_RND_CONV_false_if_return_mult_generic_AC_RND_CONV_false_if_or_1_nl
      , 1'b1});
  assign acc_8_nl = nl_acc_8_nl[13:0];
  assign z_out_10 = readslicef_14_13_1(acc_8_nl);
  assign operator_33_true_1_and_2_nl = (~ return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11)
      & (fsm_output[10]);
  assign operator_33_true_1_and_3_nl = return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11
      & (fsm_output[10]);
  assign operator_33_true_1_operator_33_true_1_operator_33_true_1_mux1h_1_nl = MUX1HOT_v_12_3_2((signext_12_10(z_out_11_0[11:2])),
      return_div_generic_AC_RND_CONV_false_exp_acc_itm, (z_out_10[12:1]), {(~ (fsm_output[10]))
      , operator_33_true_1_and_2_nl , operator_33_true_1_and_3_nl});
  assign return_div_generic_AC_RND_CONV_false_return_div_generic_AC_RND_CONV_false_or_1_nl
      = (z_out_10[0]) | (~ return_div_generic_AC_RND_CONV_false_shift_r_acc_psp_1_sva_11);
  assign operator_33_true_1_operator_33_true_1_mux_2_nl = MUX_s_1_2_2((z_out_11_0[1]),
      return_div_generic_AC_RND_CONV_false_return_div_generic_AC_RND_CONV_false_or_1_nl,
      fsm_output[10]);
  assign operator_33_true_1_operator_33_true_1_or_1_nl = (z_out_9[53]) | (fsm_output[1])
      | (fsm_output[3]);
  assign nl_z_out_11 = ({operator_33_true_1_operator_33_true_1_operator_33_true_1_mux1h_1_nl
      , operator_33_true_1_operator_33_true_1_mux_2_nl}) + conv_u2u_1_13(operator_33_true_1_operator_33_true_1_or_1_nl);
  assign z_out_11 = nl_z_out_11[12:0];

  function automatic  MUX1HOT_s_1_3_2;
    input  input_2;
    input  input_1;
    input  input_0;
    input [2:0] sel;
    reg  result;
  begin
    result = input_0 & sel[0];
    result = result | (input_1 & sel[1]);
    result = result | (input_2 & sel[2]);
    MUX1HOT_s_1_3_2 = result;
  end
  endfunction


  function automatic  MUX1HOT_s_1_4_2;
    input  input_3;
    input  input_2;
    input  input_1;
    input  input_0;
    input [3:0] sel;
    reg  result;
  begin
    result = input_0 & sel[0];
    result = result | (input_1 & sel[1]);
    result = result | (input_2 & sel[2]);
    result = result | (input_3 & sel[3]);
    MUX1HOT_s_1_4_2 = result;
  end
  endfunction


  function automatic  MUX1HOT_s_1_5_2;
    input  input_4;
    input  input_3;
    input  input_2;
    input  input_1;
    input  input_0;
    input [4:0] sel;
    reg  result;
  begin
    result = input_0 & sel[0];
    result = result | (input_1 & sel[1]);
    result = result | (input_2 & sel[2]);
    result = result | (input_3 & sel[3]);
    result = result | (input_4 & sel[4]);
    MUX1HOT_s_1_5_2 = result;
  end
  endfunction


  function automatic  MUX1HOT_s_1_6_2;
    input  input_5;
    input  input_4;
    input  input_3;
    input  input_2;
    input  input_1;
    input  input_0;
    input [5:0] sel;
    reg  result;
  begin
    result = input_0 & sel[0];
    result = result | (input_1 & sel[1]);
    result = result | (input_2 & sel[2]);
    result = result | (input_3 & sel[3]);
    result = result | (input_4 & sel[4]);
    result = result | (input_5 & sel[5]);
    MUX1HOT_s_1_6_2 = result;
  end
  endfunction


  function automatic [10:0] MUX1HOT_v_11_3_2;
    input [10:0] input_2;
    input [10:0] input_1;
    input [10:0] input_0;
    input [2:0] sel;
    reg [10:0] result;
  begin
    result = input_0 & {11{sel[0]}};
    result = result | (input_1 & {11{sel[1]}});
    result = result | (input_2 & {11{sel[2]}});
    MUX1HOT_v_11_3_2 = result;
  end
  endfunction


  function automatic [11:0] MUX1HOT_v_12_3_2;
    input [11:0] input_2;
    input [11:0] input_1;
    input [11:0] input_0;
    input [2:0] sel;
    reg [11:0] result;
  begin
    result = input_0 & {12{sel[0]}};
    result = result | (input_1 & {12{sel[1]}});
    result = result | (input_2 & {12{sel[2]}});
    MUX1HOT_v_12_3_2 = result;
  end
  endfunction


  function automatic [1:0] MUX1HOT_v_2_4_2;
    input [1:0] input_3;
    input [1:0] input_2;
    input [1:0] input_1;
    input [1:0] input_0;
    input [3:0] sel;
    reg [1:0] result;
  begin
    result = input_0 & {2{sel[0]}};
    result = result | (input_1 & {2{sel[1]}});
    result = result | (input_2 & {2{sel[2]}});
    result = result | (input_3 & {2{sel[3]}});
    MUX1HOT_v_2_4_2 = result;
  end
  endfunction


  function automatic [2:0] MUX1HOT_v_3_3_2;
    input [2:0] input_2;
    input [2:0] input_1;
    input [2:0] input_0;
    input [2:0] sel;
    reg [2:0] result;
  begin
    result = input_0 & {3{sel[0]}};
    result = result | (input_1 & {3{sel[1]}});
    result = result | (input_2 & {3{sel[2]}});
    MUX1HOT_v_3_3_2 = result;
  end
  endfunction


  function automatic [3:0] MUX1HOT_v_4_4_2;
    input [3:0] input_3;
    input [3:0] input_2;
    input [3:0] input_1;
    input [3:0] input_0;
    input [3:0] sel;
    reg [3:0] result;
  begin
    result = input_0 & {4{sel[0]}};
    result = result | (input_1 & {4{sel[1]}});
    result = result | (input_2 & {4{sel[2]}});
    result = result | (input_3 & {4{sel[3]}});
    MUX1HOT_v_4_4_2 = result;
  end
  endfunction


  function automatic [49:0] MUX1HOT_v_50_4_2;
    input [49:0] input_3;
    input [49:0] input_2;
    input [49:0] input_1;
    input [49:0] input_0;
    input [3:0] sel;
    reg [49:0] result;
  begin
    result = input_0 & {50{sel[0]}};
    result = result | (input_1 & {50{sel[1]}});
    result = result | (input_2 & {50{sel[2]}});
    result = result | (input_3 & {50{sel[3]}});
    MUX1HOT_v_50_4_2 = result;
  end
  endfunction


  function automatic [50:0] MUX1HOT_v_51_3_2;
    input [50:0] input_2;
    input [50:0] input_1;
    input [50:0] input_0;
    input [2:0] sel;
    reg [50:0] result;
  begin
    result = input_0 & {51{sel[0]}};
    result = result | (input_1 & {51{sel[1]}});
    result = result | (input_2 & {51{sel[2]}});
    MUX1HOT_v_51_3_2 = result;
  end
  endfunction


  function automatic [50:0] MUX1HOT_v_51_4_2;
    input [50:0] input_3;
    input [50:0] input_2;
    input [50:0] input_1;
    input [50:0] input_0;
    input [3:0] sel;
    reg [50:0] result;
  begin
    result = input_0 & {51{sel[0]}};
    result = result | (input_1 & {51{sel[1]}});
    result = result | (input_2 & {51{sel[2]}});
    result = result | (input_3 & {51{sel[3]}});
    MUX1HOT_v_51_4_2 = result;
  end
  endfunction


  function automatic [51:0] MUX1HOT_v_52_3_2;
    input [51:0] input_2;
    input [51:0] input_1;
    input [51:0] input_0;
    input [2:0] sel;
    reg [51:0] result;
  begin
    result = input_0 & {52{sel[0]}};
    result = result | (input_1 & {52{sel[1]}});
    result = result | (input_2 & {52{sel[2]}});
    MUX1HOT_v_52_3_2 = result;
  end
  endfunction


  function automatic [51:0] MUX1HOT_v_52_4_2;
    input [51:0] input_3;
    input [51:0] input_2;
    input [51:0] input_1;
    input [51:0] input_0;
    input [3:0] sel;
    reg [51:0] result;
  begin
    result = input_0 & {52{sel[0]}};
    result = result | (input_1 & {52{sel[1]}});
    result = result | (input_2 & {52{sel[2]}});
    result = result | (input_3 & {52{sel[3]}});
    MUX1HOT_v_52_4_2 = result;
  end
  endfunction


  function automatic [55:0] MUX1HOT_v_56_3_2;
    input [55:0] input_2;
    input [55:0] input_1;
    input [55:0] input_0;
    input [2:0] sel;
    reg [55:0] result;
  begin
    result = input_0 & {56{sel[0]}};
    result = result | (input_1 & {56{sel[1]}});
    result = result | (input_2 & {56{sel[2]}});
    MUX1HOT_v_56_3_2 = result;
  end
  endfunction


  function automatic [5:0] MUX1HOT_v_6_3_2;
    input [5:0] input_2;
    input [5:0] input_1;
    input [5:0] input_0;
    input [2:0] sel;
    reg [5:0] result;
  begin
    result = input_0 & {6{sel[0]}};
    result = result | (input_1 & {6{sel[1]}});
    result = result | (input_2 & {6{sel[2]}});
    MUX1HOT_v_6_3_2 = result;
  end
  endfunction


  function automatic [5:0] MUX1HOT_v_6_5_2;
    input [5:0] input_4;
    input [5:0] input_3;
    input [5:0] input_2;
    input [5:0] input_1;
    input [5:0] input_0;
    input [4:0] sel;
    reg [5:0] result;
  begin
    result = input_0 & {6{sel[0]}};
    result = result | (input_1 & {6{sel[1]}});
    result = result | (input_2 & {6{sel[2]}});
    result = result | (input_3 & {6{sel[3]}});
    result = result | (input_4 & {6{sel[4]}});
    MUX1HOT_v_6_5_2 = result;
  end
  endfunction


  function automatic  MUX_s_1_2_2;
    input  input_0;
    input  input_1;
    input  sel;
    reg  result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_s_1_2_2 = result;
  end
  endfunction


  function automatic [9:0] MUX_v_10_2_2;
    input [9:0] input_0;
    input [9:0] input_1;
    input  sel;
    reg [9:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_10_2_2 = result;
  end
  endfunction


  function automatic [10:0] MUX_v_11_2_2;
    input [10:0] input_0;
    input [10:0] input_1;
    input  sel;
    reg [10:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_11_2_2 = result;
  end
  endfunction


  function automatic [11:0] MUX_v_12_2_2;
    input [11:0] input_0;
    input [11:0] input_1;
    input  sel;
    reg [11:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_12_2_2 = result;
  end
  endfunction


  function automatic [12:0] MUX_v_13_2_2;
    input [12:0] input_0;
    input [12:0] input_1;
    input  sel;
    reg [12:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_13_2_2 = result;
  end
  endfunction


  function automatic [1:0] MUX_v_2_2_2;
    input [1:0] input_0;
    input [1:0] input_1;
    input  sel;
    reg [1:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_2_2_2 = result;
  end
  endfunction


  function automatic [2:0] MUX_v_3_2_2;
    input [2:0] input_0;
    input [2:0] input_1;
    input  sel;
    reg [2:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_3_2_2 = result;
  end
  endfunction


  function automatic [3:0] MUX_v_4_2_2;
    input [3:0] input_0;
    input [3:0] input_1;
    input  sel;
    reg [3:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_4_2_2 = result;
  end
  endfunction


  function automatic [49:0] MUX_v_50_2_2;
    input [49:0] input_0;
    input [49:0] input_1;
    input  sel;
    reg [49:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_50_2_2 = result;
  end
  endfunction


  function automatic [50:0] MUX_v_51_2_2;
    input [50:0] input_0;
    input [50:0] input_1;
    input  sel;
    reg [50:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_51_2_2 = result;
  end
  endfunction


  function automatic [51:0] MUX_v_52_2_2;
    input [51:0] input_0;
    input [51:0] input_1;
    input  sel;
    reg [51:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_52_2_2 = result;
  end
  endfunction


  function automatic [55:0] MUX_v_56_2_2;
    input [55:0] input_0;
    input [55:0] input_1;
    input  sel;
    reg [55:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_56_2_2 = result;
  end
  endfunction


  function automatic [4:0] MUX_v_5_2_2;
    input [4:0] input_0;
    input [4:0] input_1;
    input  sel;
    reg [4:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_5_2_2 = result;
  end
  endfunction


  function automatic [5:0] MUX_v_6_2_2;
    input [5:0] input_0;
    input [5:0] input_1;
    input  sel;
    reg [5:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_6_2_2 = result;
  end
  endfunction


  function automatic [11:0] readslicef_13_12_1;
    input [12:0] vector;
    reg [12:0] tmp;
  begin
    tmp = vector >> 1;
    readslicef_13_12_1 = tmp[11:0];
  end
  endfunction


  function automatic [0:0] readslicef_13_1_12;
    input [12:0] vector;
    reg [12:0] tmp;
  begin
    tmp = vector >> 12;
    readslicef_13_1_12 = tmp[0:0];
  end
  endfunction


  function automatic [12:0] readslicef_14_13_1;
    input [13:0] vector;
    reg [13:0] tmp;
  begin
    tmp = vector >> 1;
    readslicef_14_13_1 = tmp[12:0];
  end
  endfunction


  function automatic [52:0] readslicef_54_53_1;
    input [53:0] vector;
    reg [53:0] tmp;
  begin
    tmp = vector >> 1;
    readslicef_54_53_1 = tmp[52:0];
  end
  endfunction


  function automatic [56:0] readslicef_58_57_1;
    input [57:0] vector;
    reg [57:0] tmp;
  begin
    tmp = vector >> 1;
    readslicef_58_57_1 = tmp[56:0];
  end
  endfunction


  function automatic [11:0] signext_12_10;
    input [9:0] vector;
  begin
    signext_12_10= {{2{vector[9]}}, vector};
  end
  endfunction


  function automatic [12:0] conv_s2s_7_13 ;
    input [6:0]  vector ;
  begin
    conv_s2s_7_13 = {{6{vector[6]}}, vector};
  end
  endfunction


  function automatic [11:0] conv_s2s_11_12 ;
    input [10:0]  vector ;
  begin
    conv_s2s_11_12 = {vector[10], vector};
  end
  endfunction


  function automatic [13:0] conv_s2u_3_14 ;
    input [2:0]  vector ;
  begin
    conv_s2u_3_14 = {{11{vector[2]}}, vector};
  end
  endfunction


  function automatic [13:0] conv_s2u_8_14 ;
    input [7:0]  vector ;
  begin
    conv_s2u_8_14 = {{6{vector[7]}}, vector};
  end
  endfunction


  function automatic [12:0] conv_s2u_12_13 ;
    input [11:0]  vector ;
  begin
    conv_s2u_12_13 = {vector[11], vector};
  end
  endfunction


  function automatic [13:0] conv_s2u_13_14 ;
    input [12:0]  vector ;
  begin
    conv_s2u_13_14 = {vector[12], vector};
  end
  endfunction


  function automatic [11:0] conv_u2s_11_12 ;
    input [10:0]  vector ;
  begin
    conv_u2s_11_12 =  {1'b0, vector};
  end
  endfunction


  function automatic [12:0] conv_u2s_11_13 ;
    input [10:0]  vector ;
  begin
    conv_u2s_11_13 = {{2{1'b0}}, vector};
  end
  endfunction


  function automatic [12:0] conv_u2u_1_13 ;
    input [0:0]  vector ;
  begin
    conv_u2u_1_13 = {{12{1'b0}}, vector};
  end
  endfunction


  function automatic [12:0] conv_u2u_12_13 ;
    input [11:0]  vector ;
  begin
    conv_u2u_12_13 = {1'b0, vector};
  end
  endfunction


  function automatic [13:0] conv_u2u_12_14 ;
    input [11:0]  vector ;
  begin
    conv_u2u_12_14 = {{2{1'b0}}, vector};
  end
  endfunction


  function automatic [13:0] conv_u2u_13_14 ;
    input [12:0]  vector ;
  begin
    conv_u2u_13_14 = {1'b0, vector};
  end
  endfunction


  function automatic [53:0] conv_u2u_53_54 ;
    input [52:0]  vector ;
  begin
    conv_u2u_53_54 = {1'b0, vector};
  end
  endfunction


  function automatic [57:0] conv_u2u_57_58 ;
    input [56:0]  vector ;
  begin
    conv_u2u_57_58 = {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    fpu
// ------------------------------------------------------------------


module fpu_block (
  clk, en, rstn, A_d_rsc_dat, A_d_triosy_lz, B_d_rsc_dat, B_d_triosy_lz, C_add_d_rsc_dat,
      C_add_d_triosy_lz, C_sub_d_rsc_dat, C_sub_d_triosy_lz, C_div_d_rsc_dat, C_div_d_triosy_lz,
      C_mult_d_rsc_dat, C_mult_d_triosy_lz, done_sync_vld, start_sync_rdy, start_sync_vld
);
  input clk;
  input en;
  input rstn;
  input [63:0] A_d_rsc_dat;
  output A_d_triosy_lz;
  input [63:0] B_d_rsc_dat;
  output B_d_triosy_lz;
  output [63:0] C_add_d_rsc_dat;
  output C_add_d_triosy_lz;
  output [63:0] C_sub_d_rsc_dat;
  output C_sub_d_triosy_lz;
  output [63:0] C_div_d_rsc_dat;
  output C_div_d_triosy_lz;
  output [63:0] C_mult_d_rsc_dat;
  output C_mult_d_triosy_lz;
  output done_sync_vld;
  output start_sync_rdy;
  input start_sync_vld;



  // Interconnect Declarations for Component Instantiations 
  fpu_core fpu_core_inst (
      .clk(clk),
      .en(en),
      .rstn(rstn),
      .A_d_rsc_dat(A_d_rsc_dat),
      .A_d_triosy_lz(A_d_triosy_lz),
      .B_d_rsc_dat(B_d_rsc_dat),
      .B_d_triosy_lz(B_d_triosy_lz),
      .C_add_d_rsc_dat(C_add_d_rsc_dat),
      .C_add_d_triosy_lz(C_add_d_triosy_lz),
      .C_sub_d_rsc_dat(C_sub_d_rsc_dat),
      .C_sub_d_triosy_lz(C_sub_d_triosy_lz),
      .C_div_d_rsc_dat(C_div_d_rsc_dat),
      .C_div_d_triosy_lz(C_div_d_triosy_lz),
      .C_mult_d_rsc_dat(C_mult_d_rsc_dat),
      .C_mult_d_triosy_lz(C_mult_d_triosy_lz),
      .done_sync_vld(done_sync_vld),
      .start_sync_rdy(start_sync_rdy),
      .start_sync_vld(start_sync_vld)
    );
endmodule



