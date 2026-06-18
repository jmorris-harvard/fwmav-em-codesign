//------------------------------------------------------------------------
// TopWrapper.v
//------------------------------------------------------------------------
`default_nettype wire
`timescale 1ns / 1ps

module TopWrapper (
  input  wire [4:0]  okUH,
  output wire [2:0]  okHU,
  inout  wire [31:0] okUHU,
  inout  wire        okAA,
    
  // -- ios
  input  wire        sys_clkn,
  input  wire        sys_clkp,
  
  //
  // input wire tb_reset,

  // eis ports
  output wire bat_0_m_mosi,
  output wire bat_0_m_cs,
  output wire bat_0_m_sclk,
  input wire bat_0_m_miso,
  input wire bat_0_m_alert,
  output wire bat_0_s_mosi,
  output wire bat_0_s_cs,
  output wire bat_0_s_sclk,
  input wire bat_0_s_miso,

  output wire bat_1_m_mosi,
  output wire bat_1_m_cs,
  output wire bat_1_m_sclk,
  input wire bat_1_m_miso,
  input wire bat_1_m_alert,
  output wire bat_1_s_mosi,
  output wire bat_1_s_cs,
  output wire bat_1_s_sclk,
  input wire bat_1_s_miso,

  // led
  output wire [7:0]    led
);

// signals
// -- ok library
wire        okClk;
wire[112:0] okHE;
wire[64:0]  okEH;


// --- wires
// ---- ins
wire [31:0] wire_in_00; // configuration
// wire_in_00[7:0] = leds

wire [31:0] wire_in_01; // bat_0_s_ctl
// wire_in_01[0] = bat_0_s_i_vn
// wire_in_01[4:1] = bat_0_s_gain

wire [31:0] wire_in_02; // bat_0_s_timer

wire [31:0] wire_in_03; // bat_0_s_mem_data

wire [31:0] wire_in_04; // bat_0_m_ctl
// wire_in_04[0] = bat_0_m_range
// wire_in_04[15:1] = bat_0_shunt
// wire_in_04[16] = bat_0_en_sweep

wire [31:0] wire_in_05; // bat_0_m_timer

wire [31:0] wire_in_06; // bat_0_m_delay

wire [31:0] wire_in_07; // bat_0_m_phase_sweep (number times to sweep phase)

wire [31:0] wire_in_08; // bat_0_phase_step

wire [31:0] wire_in_09; // bat_0_phase_samples

wire [31:0] wire_in_0a; // bat_1_s_ctl
// wire_in_0q[0] = bat_1_s_i_vn
// wire_in_0a[4:1] = bat_1_s_gain

wire [31:0] wire_in_0b; // bat_1_s_timer

wire [31:0] wire_in_0c; // bat_1_s_mem_data

wire [31:0] wire_in_0d; // bat_1_m_ctl
// wire_in_0d[0] = bat_1_m_range
// wire_in_0d[15:1] = bat_1_shunt
// wire_in_0d[16] = bat_1_en_sweep

wire [31:0] wire_in_0e; // bat_1_m_timer

wire [31:0] wire_in_0f; // bat_1_m_delay

wire [31:0] wire_in_10; // bat_1_m_phase_sweep (number times to sweep phase)

wire [31:0] wire_in_11; // bat_1_phase_step

wire [31:0] wire_in_12; // bat_1_phase_samples


// ---- outs
wire  [31:0] wire_out_20;

// --- triggers
// ---- outs
wire [31:0] trigger_in_40; // bat_0_triggers
// trigger_in_40[0] = bat_0_mem_write
// trigger_in_40[1] = bat_0_trig_s
// trigger_in_40[2] = bat_0_trig_m

wire [31:0] trigger_in_41; // bat_1_triggers
// trigger_in_41[0] = bat_1_mem_write
// trigger_in_41[1] = bat_1_trig_s
// trigger_in_41[2] = bat_1_trig_m

wire [31:0] trigger_in_42; // reset 

// --- pipes
// ---- ins
wire [31:0] pipe_in_80_data; // unused
wire        pipe_in_80_write;

// ---- outs
wire [31:0] pipe_out_a0_data; // measure out 0
wire        pipe_out_a0_read;

wire [31:0] pipe_out_a1_data; // measure out 1
wire        pipe_out_a1_read;

// --- Globals
localparam integer RESET_TIME = 32'h32;
reg reset_r;
wire reset;
reg [31:0] reset_timer;
wire sys_clk;
wire core_clk;

// -- nipcb 0 fifo signals
wire bat_0_fifo_clk;
wire bat_0_fifo_rst;
wire [31:0] bat_0_fifo_din;
wire [31:0] bat_0_fifo_dout;
wire bat_0_fifo_wr;
wire bat_0_fifo_full;
wire bat_0_fifo_empty;
wire bat_0_fifo_rd;

// -- nipcb 1 fifo signals
wire bat_1_fifo_clk;
wire bat_1_fifo_rst;
wire [31:0] bat_1_fifo_din;
wire [31:0] bat_1_fifo_dout;
wire bat_1_fifo_wr;
wire bat_1_fifo_full;
wire bat_1_fifo_empty;
wire bat_1_fifo_rd;

// cdcs
wire bat_0_dac530_i_vn;
wire [3:0] bat_0_dac530_gain;
wire [31:0] bat_0_dac530_send_timer;
wire [31:0] bat_0_dac530_mem_data;

wire [14:0] bat_0_ina239_shunt_cal;
wire bat_0_ina239_range;
wire [31:0] bat_0_ina239_recv_timer;
wire [31:0] bat_0_ina239_delay;

wire bat_0_ina239_en_sweep; // enable phase sweep
wire [31:0] bat_0_ina239_phase_sweep; // number times to push phase
wire [31:0] bat_0_ina239_phase_step; // phase delta
wire [31:0] bat_0_ina239_phase_samples; // number cycles on phase

wire bat_1_dac530_i_vn;
wire [3:0] bat_1_dac530_gain;
wire [31:0] bat_1_dac530_send_timer;
wire [31:0] bat_1_dac530_mem_data;

wire [14:0] bat_1_ina239_shunt_cal;
wire bat_1_ina239_range;
wire [31:0] bat_1_ina239_recv_timer;
wire [31:0] bat_1_ina239_delay;

wire bat_1_ina239_en_sweep; // enable phase sweep
wire [31:0] bat_1_ina239_phase_sweep; // number times to push phase
wire [31:0] bat_1_ina239_phase_step; // phase delta
wire [31:0] bat_1_ina239_phase_samples; // number cycles on phase

// logic
// -- globals
// assign reset = reset_r | tb_reset;
assign reset = wire_in_00[8];
genvar i;
generate
for (i = 0; i < 8; i = i + 1) begin
  assign led[i] = ( reset ) ? 1'b0 : ( wire_in_00[i] ) ? 1'b0 : 1'bz;
end
endgenerate

// -- eis_0 fifo
assign bat_0_fifo_rd = ~bat_0_fifo_empty & pipe_out_a0_read;
assign pipe_out_a0_data = (~bat_0_fifo_empty) ? bat_0_fifo_dout : 32'h0;

// -- eis_1 fifo
assign bat_1_fifo_rd = ~bat_1_fifo_empty & pipe_out_a1_read;
assign pipe_out_a1_data = (~bat_1_fifo_empty) ? bat_1_fifo_dout : 32'h0;

// instantiations
IBUFGDS osc_clk_buf(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));

// -- clock wizard
wizard wiz_inst (
  .clk_out1 (core_clk),
  .clk_in1  (okClk)
);

// cdcs
cdc #(
  .DATA_BW (1)
) cdc_bat_0_dac530_i_vn (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_01[0]),
  .dout (bat_0_dac530_i_vn)
);

cdc #(
  .DATA_BW (4)
) cdc_bat_0_dac530_gain (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_01[4:1]),
  .dout (bat_0_dac530_gain)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_0_dac530_send_timer (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_02),
  .dout (bat_0_dac530_send_timer)
);

cdc #(
  .DATA_BW (32)
) cdc_bbat_0_dac530_mem_data (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_03),
  .dout (bat_0_dac530_mem_data)
);

cdc #(
  .DATA_BW (15)
) cdc_bat_0_ina239_shunt_cal (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_04[15:1]),
  .dout (bat_0_ina239_shunt_cal)
);

cdc #(
  .DATA_BW (1)
) cdc_bat_0_ina239_range (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_04[0]),
  .dout (bat_0_ina239_range)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_0_ina239_recv_timer (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_05),
  .dout (bat_0_ina239_recv_timer)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_0_ina239_delay (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_06),
  .dout (bat_0_ina239_delay)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_0_ina239_phase_sweep (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_07),
  .dout (bat_0_ina239_phase_sweep)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_0_ina239_phase_step (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_08),
  .dout (bat_0_ina239_phase_step)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_0_ina239_phase_samples (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_09),
  .dout (bat_0_ina239_phase_samples)
);

cdc #(
  .DATA_BW (1)
) cdc_bat_0_ina239_en_sweep (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_04[16]),
  .dout (bat_0_ina239_en_sweep)
);

// cdc 1
cdc #(
  .DATA_BW (1)
) cdc_bat_1_dac530_i_vn (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0a[0]),
  .dout (bat_1_dac530_i_vn)
);

cdc #(
  .DATA_BW (4)
) cdc_bat_1_dac530_gain (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0a[4:1]),
  .dout (bat_1_dac530_gain)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_dac530_send_timer (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0b),
  .dout (bat_1_dac530_send_timer)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_dac530_mem_data (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0c),
  .dout (bat_1_dac530_mem_data)
);

cdc #(
  .DATA_BW (15)
) cdc_bat_1_ina239_shunt_cal (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0d[15:1]),
  .dout (bat_1_ina239_shunt_cal)
);

cdc #(
  .DATA_BW (1)
) cdc_bat_1_ina239_range (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0d[0]),
  .dout (bat_1_ina239_range)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_ina239_recv_timer (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0e),
  .dout (bat_1_ina239_recv_timer)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_ina239_delay (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0f),
  .dout (bat_1_ina239_delay)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_ina239_phase_sweep (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_10),
  .dout (bat_1_ina239_phase_sweep)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_ina239_phase_step (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_11),
  .dout (bat_1_ina239_phase_step)
);

cdc #(
  .DATA_BW (32)
) cdc_bat_1_ina239_phase_samples (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_12),
  .dout (bat_1_ina239_phase_samples)
);

cdc #(
  .DATA_BW (1)
) cdc_bat_1_ina239_en_sweep (
  .clk (core_clk),
  .rstn (~reset),
  .din (wire_in_0d[16]),
  .dout (bat_1_ina239_en_sweep)
);


// -- eis 0
eis_core #(
  .MEM_SIZE (32'h20)
) eis_0 (
  .clk (core_clk),
  .rstn (~reset),
  
  .trig_s (trigger_in_40[1]),
  .trig_m (trigger_in_40[2]),

  .dac530_i_vn (bat_0_dac530_i_vn),
  .dac530_gain (bat_0_dac530_gain),
  .dac530_send_timer (bat_0_dac530_send_timer),
  .dac530_mem_data (bat_0_dac530_mem_data),
  .dac530_mem_write (trigger_in_40[0]),

  .ina239_shunt_cal (bat_0_ina239_shunt_cal),
  .ina239_range (bat_0_ina239_range),
  .ina239_recv_timer (bat_0_ina239_recv_timer),
  .ina239_delay (bat_0_ina239_delay),
  
  .ina239_en_sweep (bat_0_ina239_en_sweep), // enable phase sweep
  .ina239_phase_sweep (bat_0_ina239_phase_sweep), // number times to push phase
  .ina239_phase_step (bat_0_ina239_phase_step), // phase delta
  .ina239_phase_samples (bat_0_ina239_phase_samples), // number cycles on phase

  .ina239_fifo_clk (bat_0_fifo_clk),
  .ina239_fifo_rst (bat_0_fifo_rst),
  .ina239_fifo_din (bat_0_fifo_din),
  .ina239_fifo_wr (bat_0_fifo_wr),
  .ina239_fifo_full (bat_0_fifo_full),

  .bat_m_cs (bat_0_m_cs),
  .bat_m_mosi (bat_0_m_mosi),
  .bat_m_alert (bat_0_m_alert),
  .bat_m_miso (bat_0_m_miso),
  .bat_m_sclk (bat_0_m_sclk),

  .bat_s_miso (bat_0_s_miso),
  .bat_s_cs (bat_0_s_cs),
  .bat_s_mosi (bat_0_s_mosi),
  .bat_s_sclk (bat_0_s_sclk)
);

// -- eis 1
eis_core #(
  .MEM_SIZE (32'h20)
) eis_1 (
  .clk (core_clk),
  .rstn (~reset),
  
  .trig_s (trigger_in_41[1]),
  .trig_m (trigger_in_41[2]),

  .dac530_i_vn (bat_1_dac530_i_vn),
  .dac530_gain (bat_1_dac530_gain),
  .dac530_send_timer (bat_1_dac530_send_timer),
  .dac530_mem_data (bat_1_dac530_mem_data),
  .dac530_mem_write (trigger_in_41[0]),

  .ina239_shunt_cal (bat_1_ina239_shunt_cal),
  .ina239_range (bat_1_ina239_range),
  .ina239_recv_timer (bat_1_ina239_recv_timer),
  .ina239_delay (bat_1_ina239_delay),
  
  .ina239_en_sweep (bat_1_ina239_en_sweep), // enable phase sweep
  .ina239_phase_sweep (bat_1_ina239_phase_sweep), // number times to push phase
  .ina239_phase_step (bat_1_ina239_phase_step), // phase delta
  .ina239_phase_samples (bat_1_ina239_phase_samples), // number cycles on phase

  .ina239_fifo_clk (bat_1_fifo_clk),
  .ina239_fifo_rst (bat_1_fifo_rst),
  .ina239_fifo_din (bat_1_fifo_din),
  .ina239_fifo_wr (bat_1_fifo_wr),
  .ina239_fifo_full (bat_1_fifo_full),

  .bat_m_cs (bat_1_m_cs),
  .bat_m_mosi (bat_1_m_mosi),
  .bat_m_alert (bat_1_m_alert),
  .bat_m_miso (bat_1_m_miso),
  .bat_m_sclk (bat_1_m_sclk),

  .bat_s_miso (bat_1_s_miso),
  .bat_s_cs (bat_1_s_cs),
  .bat_s_mosi (bat_1_s_mosi),
  .bat_s_sclk (bat_1_s_sclk)
);

// -- fifo
fifo pipe_out_a0_fifo (
  .rst (bat_0_fifo_rst),
  .wr_clk (bat_0_fifo_clk),
  .rd_clk (okClk),
  .din (bat_0_fifo_din),
  .wr_en (bat_0_fifo_wr),
  .rd_en (bat_0_fifo_rd),
  .dout (bat_0_fifo_dout),
  .full (bat_0_fifo_full),
  .empty (bat_0_fifo_empty),
  .wr_rst_busy (),
  .rd_rst_busy ()
);

fifo pipe_out_a1_fifo (
  .rst (bat_1_fifo_rst),
  .wr_clk (bat_1_fifo_clk),
  .rd_clk (okClk),
  .din (bat_1_fifo_din),
  .wr_en (bat_1_fifo_wr),
  .rd_en (bat_1_fifo_rd),
  .dout (bat_1_fifo_dout),
  .full (bat_1_fifo_full),
  .empty (bat_1_fifo_empty),
  .wr_rst_busy (),
  .rd_rst_busy ()
);

//// state machines
//always @(posedge core_clk) begin
//  if ( wire_in_00[8] ) begin
//    reset_r <= 1'h1;
//  end else begin
//    reset_r <= 1'h0;
//  end
//end

// OK Library
localparam nEHx = 4;
wire [65*nEHx-1:0]  okEHx;
okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE),
	.okEH(okEH)
);

okWireOR # (.N(nEHx)) wireOR (okEH, okEHx);

// Wire Ins -- 0x00 - 0x1F
okWireIn     ep00 (.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(wire_in_00));
okWireIn     ep01 (.okHE(okHE),                             .ep_addr(8'h01), .ep_dataout(wire_in_01));
okWireIn     ep02 (.okHE(okHE),                             .ep_addr(8'h02), .ep_dataout(wire_in_02));
okWireIn     ep03 (.okHE(okHE),                             .ep_addr(8'h03), .ep_dataout(wire_in_03));
okWireIn     ep04 (.okHE(okHE),                             .ep_addr(8'h04), .ep_dataout(wire_in_04));
okWireIn     ep05 (.okHE(okHE),                             .ep_addr(8'h05), .ep_dataout(wire_in_05));
okWireIn     ep06 (.okHE(okHE),                             .ep_addr(8'h06), .ep_dataout(wire_in_06));
okWireIn     ep07 (.okHE(okHE),                             .ep_addr(8'h07), .ep_dataout(wire_in_07));
okWireIn     ep08 (.okHE(okHE),                             .ep_addr(8'h08), .ep_dataout(wire_in_08));
okWireIn     ep09 (.okHE(okHE),                             .ep_addr(8'h09), .ep_dataout(wire_in_09));
okWireIn     ep0a (.okHE(okHE),                             .ep_addr(8'h0a), .ep_dataout(wire_in_0a));
okWireIn     ep0b (.okHE(okHE),                             .ep_addr(8'h0b), .ep_dataout(wire_in_0b));
okWireIn     ep0c (.okHE(okHE),                             .ep_addr(8'h0c), .ep_dataout(wire_in_0c));

// Wire Outs -- 0x20 - 0x3F 
okWireOut    ep20 (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(wire_out_20));

// Trigger Ins -- 0x40 - 0x5F
okTriggerIn  ep40 (.okHE(okHE),                             .ep_addr(8'h40), .ep_clk(core_clk), .ep_trigger(trigger_in_40));
okTriggerIn  ep41 (.okHE(okHE),                             .ep_addr(8'h41), .ep_clk(core_clk), .ep_trigger(trigger_in_41));
okTriggerIn  ep42 (.okHE(okHE),                             .ep_addr(8'h42), .ep_clk(core_clk), .ep_trigger(trigger_in_42));

// Pipe Ins -- 0x80 - 0x9F
okPipeIn     ep80 (.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pipe_in_80_write), .ep_dataout(pipe_in_80_data));

// Pipe Outs -- 0xA0 - 0xBF
okPipeOut    epa0 (.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(pipe_out_a0_read),   .ep_datain(pipe_out_a0_data));
okPipeOut    epa1 (.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'ha1), .ep_read(pipe_out_a1_read),   .ep_datain(pipe_out_a1_data));

endmodule
