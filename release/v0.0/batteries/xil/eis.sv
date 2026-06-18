module eis_core #(
  parameter integer MEM_SIZE = 32'h80
) (
  input wire clk,
  input wire rstn,

  // internal control signals
  input wire trig_s,
  input wire trig_m,

  input wire dac530_i_vn,
  input wire [3:0] dac530_gain, 
  input wire [31:0] dac530_send_timer,

  input wire [31:0] dac530_mem_data,
  input wire dac530_mem_write,
  input wire [31:0] dac530_mem_top,

  input wire [14:0] ina239_shunt_cal,
  input wire ina239_range,
  input wire [31:0] ina239_recv_timer, // delay after requesting data
  input wire [31:0] ina239_delay, // delay after sending trigger request

  input wire ina239_en_sweep, // enable phase sweep
  input wire [31:0] ina239_phase_sweep, // number times to push phase
  input wire [31:0] ina239_phase_step, // phase delta
  input wire [31:0] ina239_phase_samples, // number cycles on phase

  output wire ina239_fifo_clk,
  output wire ina239_fifo_rst,
  output wire [31:0] ina239_fifo_din,
  output wire ina239_fifo_wr,
  input wire ina239_fifo_full,

  // external ic signals
  // measurement
  output wire bat_m_cs,
  output wire bat_m_mosi,
  input wire bat_m_alert,
  input wire bat_m_miso,
  output wire bat_m_sclk,

  // stimulation
  input wire bat_s_miso,
  output wire bat_s_cs,
  output wire bat_s_mosi,
  output wire bat_s_sclk
);

// locals
localparam MEM_SP_SIZE = $clog2 (MEM_SIZE);
localparam TRUE_MEM_SIZE = 32'h1 << MEM_SP_SIZE;

// registers and wires 
reg dac530_rstn_r;
wire dac530_rstn;

reg [6:0] dac530_addr_r;
reg [15:0] dac530_write_data_r;
reg dac530_write_r;
reg [23:0] dac530_read_data_r;

wire [23:0] dac530_write_data;
wire [23:0] dac530_read_data;

reg dac530_send;
reg dac530_recv;
reg dac530_done;

reg dac530_initialized;
reg dac530_configured;
reg dac530_started;

reg [31:0] dac530_counter;
reg dac530_send_done;

reg dac530_i_vn_r;
reg [3:0] dac530_gain_r;
reg [31:0] dac530_send_timer_r;

reg [11:0] dac530_mem [0:TRUE_MEM_SIZE - 1];

reg [MEM_SP_SIZE - 1:0] dac530_mem_read_sp;
reg [MEM_SP_SIZE - 1:0] dac530_mem_write_sp;

reg [31:0] dac530_mem_top_r;

reg ina239_rstn_r;
wire ina239_rstn;

reg [5:0] ina239_addr_r;
wire [7:0] ina239_addr;
reg [15:0] ina239_write_data_r;
reg ina239_write_r;

wire [23:0] ina239_write_data;
wire [23:0] ina239_read_data;

reg ina239_send;
reg ina239_recv;
reg ina239_done;

reg ina239_initialized;
reg ina239_configured;
reg ina239_calibrated;
reg ina239_triggered;

reg [31:0] ina239_counter;
reg ina239_recv_done;

reg [31:0] ina239_delay_r;
reg [31:0] ina239_recv_timer_r;
reg [14:0] ina239_shunt_cal_r;
reg ina239_range_r;

reg [15:0] ina239_v_data;
reg [15:0] ina239_i_data;

reg ina239_fifo_wr_r;

reg ina239_en_sweep_r;
reg [31:0] ina239_phase_sweep_r;
reg [31:0] ina239_phase_step_r;
reg [31:0] ina239_phase_samples_r;
reg [31:0] ina239_phase_sample_counter;

// routing
assign dac530_rstn = rstn & dac530_rstn_r;
assign dac530_write_data = { ~dac530_write_r , dac530_addr_r , dac530_write_data_r };

assign ina239_rstn = rstn & ina239_rstn_r;
assign ina239_addr = { ina239_addr_r , 1'h0 , ~ina239_write_r };
assign ina239_write_data = {ina239_addr, ina239_write_data_r};

assign ina239_fifo_clk = clk;
assign ina239_fifo_rst = ~ina239_rstn;
assign ina239_fifo_din = { ina239_i_data , ina239_v_data };
assign ina239_fifo_wr = ina239_fifo_wr_r;

// state machines
// DAC530 REGISTER MAP
localparam DAC530_CONFIG = 7'h1F;
localparam DAC530_TRIGGER = 7'h20;
localparam DAC530_FUNC = 7'h18;
localparam DAC530_VOUT = 7'h15;
localparam DAC530_IOUT = 7'h16;
localparam DAC530_DATA = 7'h1C;
reg [2:0] s0;
localparam s0_000 = 3'h0;
localparam s0_001 = 3'h1;
localparam s0_010 = 3'h2;
localparam s0_011 = 3'h3;
localparam s0_100 = 3'h4;
localparam s0_101 = 3'h5;
always @(posedge clk or negedge rstn) begin
  if ( ~rstn ) begin
    dac530_addr_r <= 7'h0;
    dac530_write_data_r <= 16'h0;
    dac530_write_r <= 1'h0;
    dac530_read_data_r <= 24'h0;
    dac530_send <= 1'h0;
    dac530_recv <= 1'h0;
    dac530_initialized <= 1'h0;
    dac530_configured <= 1'h0;
    dac530_started <= 1'h0;
    dac530_counter <= 32'h0;
    dac530_send_done <= 1'h0;
    dac530_i_vn_r <= 1'h0;
    dac530_gain_r <= 5'h0;
    dac530_send_timer_r <= 32'h0;
    dac530_mem_read_sp <= MEM_SP_SIZE'('h0);
    dac530_mem_top_r <= 32'h0;
    s0 <= s0_000;
  end else begin
    case ( s0 )
      s0_000: begin
        // reset registers
        dac530_addr_r <= 7'h0;
        dac530_write_data_r <= 16'h0;
        dac530_write_r <= 1'h0;
        dac530_read_data_r <= 24'h0;
        dac530_send <= 1'h0;
        dac530_recv <= 1'h0;
        dac530_initialized <= 1'h0; 
        dac530_configured <= 1'h0;
        dac530_started <= 1'h0;
        dac530_counter <= 32'h0;
        dac530_send_done <= 1'h0;
        dac530_i_vn_r <= 1'h0;
        dac530_gain_r <= 5'h0;
        dac530_send_timer_r <= 32'h0;
        dac530_mem_read_sp <= MEM_SP_SIZE'('h0);
        dac530_mem_top_r <= 32'h0;
        // reset controller
        if ( dac530_rstn_r ) begin
          dac530_rstn_r <= 1'h0;
          s0 <= s0_000;
        end else begin
          dac530_rstn_r <= 1'h1;
          s0 <= s0_001;
        end
      end

      s0_001: begin
        // reset device
        if ( ~dac530_initialized ) begin
          dac530_addr_r <= DAC530_TRIGGER;
          dac530_write_data_r <= { 4'h0 , 4'hA , 4'h0 , 4'h0 };
          dac530_write_r <= 1'h1;
          dac530_send <= 1'h1;
          dac530_initialized <= 1'h1; 
        end else begin
          dac530_send <= 1'h0;
        end
        if ( dac530_done ) begin
          dac530_addr_r <= 7'h0;
          dac530_write_data_r <= 16'h0;
          dac530_write_r <= 1'h0;
          dac530_initialized <= 1'h0; 
          s0 <= s0_010;
        end else begin
          s0 <= s0_001;
        end
      end

      s0_010: begin
        // trigger readings
        if ( trig_s ) begin
          dac530_send_timer_r <= dac530_send_timer;
          dac530_i_vn_r <= dac530_i_vn;
          dac530_gain_r <= dac530_gain;
          dac530_mem_top_r <= dac530_mem_top;
          s0 <= s0_011;
        end else begin
          s0 <= s0_010;
        end
      end

      s0_011: begin
        // configure device
        if ( ~dac530_configured ) begin
          if ( dac530_i_vn_r ) begin
            dac530_addr_r <= DAC530_IOUT;
            //                       nc     gain        nc
            dac530_write_data_r <= { 3'h0 , dac530_gain_r[3:0] , 9'h0 };
          end else begin
            dac530_addr_r <= DAC530_VOUT;
            //                       nc     gain        nc     mode   c-v    c-hz  c-br  c-en
            dac530_write_data_r <= { 3'h0 , dac530_gain_r[2:0] , 5'h0 , 1'h0 , 1'h0 , 1'h0, 1'h0, 1'h0};
          end
          dac530_write_r <= 1'h1;
          dac530_send <= 1'h1;
          dac530_configured <= 1'h1;
        end else begin
          dac530_send <= 1'h0;
        end
        if ( dac530_done ) begin
          dac530_addr_r <= 7'h0;
          dac530_write_data_r <= 16'h0;
          dac530_write_r <= 1'h0;
          dac530_send <= 1'h0;
          dac530_configured <= 1'h0;
          s0 <= s0_100;
        end else begin
          s0 <= s0_011;
        end
      end

      s0_100: begin
        // start device
        if ( ~dac530_started ) begin
          dac530_addr_r <= DAC530_CONFIG;
          //
          if ( dac530_i_vn_r ) begin
            //                       win    lock   dump   iref   vout   iout   nc    nc
            dac530_write_data_r <= { 1'h0 , 1'h0 , 1'h0 , 1'h0 , 2'h3 , 1'h0 , 6'h0, 3'h7 };
          end else begin
            //                       win    lock   dump   iref   vout   iout   nc    nc
            dac530_write_data_r <= { 1'h0 , 1'h0 , 1'h0 , 1'h0 , 2'h0 , 1'h1 , 6'h0, 3'h7 };
          end
          dac530_write_r <= 1'h1;
          dac530_send <= 1'h1;
          dac530_started <= 1'h1;
        end else begin
          dac530_send <= 1'h0; 
        end
        if ( dac530_done ) begin
          dac530_addr_r <= 7'h0;
          dac530_write_data_r <= 16'h0;
          dac530_write_r <= 1'h0;
          dac530_send <= 1'h0;
          dac530_started <= 1'h0;

          dac530_counter <= 32'h0;
          dac530_send_done <= 1'h1;
          dac530_mem_read_sp <= MEM_SP_SIZE'('h0);
          s0 <= s0_101;
        end else begin
          s0 <= s0_100;
        end
      end

      s0_101: begin 
        // wait on end
        if ( trig_s ) begin
          s0 <= s0_000;
        end else begin
          if ( ~|dac530_counter & dac530_send_done ) begin
            dac530_addr_r <= DAC530_DATA;
            dac530_write_data_r <= { dac530_mem[dac530_mem_read_sp] , 4'h0 };
            dac530_write_r <= 1'h1;
            dac530_send <= 1'h1;
            dac530_send_done <= 1'h0;
            if ( dac530_mem_read_sp >= dac530_mem_top_r[MEM_SP_SIZE - 1:0] ) begin
              dac530_mem_read_sp <= MEM_SP_SIZE'('h0);
            end else begin
              dac530_mem_read_sp <= dac530_mem_read_sp + MEM_SP_SIZE'('h1);
            end
            dac530_counter <= dac530_send_timer_r - 32'h1;
          end else begin
            if ( |dac530_counter ) begin
              dac530_counter <= dac530_counter - 32'h1;
            end
            dac530_send <= 1'h0;
          end
          if ( dac530_done ) begin
            dac530_send_done <= 1'h1;
          end else begin
          end
        end
      end

      default: begin
        s0 <= s0_000;
      end
    endcase
  end
end

// dac530 mem writer
reg [1:0] s1;
localparam s1_00 = 2'h0;
localparam s1_01 = 2'h1;
localparam s1_10 = 2'h2;
always @(posedge clk or negedge rstn) begin
  if ( ~rstn ) begin
    dac530_mem_write_sp <= MEM_SP_SIZE'('h1);
    s1 <= s1_00;
  end else begin
    case ( s1 )
      s1_00: begin
        dac530_mem_write_sp <= MEM_SP_SIZE'('h1);
        s1 <= s1_01;
      end

      s1_01: begin
        dac530_mem[dac530_mem_write_sp] <= 12'h0;
        if ( ~|dac530_mem_write_sp ) begin
          s1 <= s1_10;
        end else begin
          dac530_mem_write_sp <= dac530_mem_write_sp + MEM_SP_SIZE'('h1);
          s1 <= s1_01;
        end
      end

      s1_10: begin
        if ( dac530_mem_write ) begin 
          dac530_mem[dac530_mem_write_sp] <= dac530_mem_data[11:0];
          dac530_mem_write_sp <= dac530_mem_write_sp + MEM_SP_SIZE'('h1);
        end else begin
          // do nothing
        end
        s1 <= s1_10;
      end

      default: begin
        s1 <= s1_00;
      end
    endcase
  end
end

// INA239 REGISTER MAP
localparam INA239_CONFIG = 6'h00;
localparam INA239_ADC = 6'h01;
localparam INA239_SHUNT_CAL = 6'h02;
localparam INA239_SHUNT_VOL = 6'h04;
localparam INA239_BUS_VOL = 6'h05;
localparam INA239_CURRENT = 6'h07;
localparam INA239_POWER = 6'h08;
localparam INA239_ALERT = 6'h08;

localparam INA239_MODE = 4'h3; // Triggered Mode
reg [2:0] s2;
localparam s2_000 = 3'h0;
localparam s2_001 = 3'h1; 
localparam s2_010 = 3'h2; 
localparam s2_011 = 3'h3; 
localparam s2_100 = 3'h4; 
localparam s2_101 = 3'h5; 
localparam s2_110 = 3'h6; 
localparam s2_111 = 3'h7; 
always @(posedge clk or negedge rstn) begin
  if ( ~rstn ) begin
    ina239_addr_r <= 6'h0;
    ina239_fifo_wr_r <= 1'h0;
    ina239_write_data_r <= 16'h0;
    ina239_write_r <= 1'h0;
    ina239_v_data <= 16'h0;
    ina239_i_data <= 16'h0;
    ina239_send <= 1'h0;
    ina239_recv <= 1'h0;
    ina239_initialized <= 1'h0;
    ina239_configured <= 1'h0;
    ina239_calibrated <= 1'h0;
    ina239_triggered <= 1'h0;
    ina239_counter <= 32'h0;
    ina239_recv_timer_r <= 32'h0;
    ina239_delay_r <= 32'h0;
    ina239_recv_done <= 1'h0;
    
    ina239_en_sweep_r <= 1'h0;
    ina239_phase_sweep_r <= 32'h0;
    ina239_phase_step_r <= 32'h0;
    ina239_phase_samples_r <= 32'h0;
    ina239_phase_sample_counter <= 32'h0;
    s2 <= s2_000;
  end else begin
    case ( s2 )
      s2_000: begin
        // reset registers
        ina239_addr_r <= 6'h0;
        ina239_fifo_wr_r <= 1'h0;
        ina239_write_data_r <= 16'h0;
        ina239_write_r <= 1'h0;
        ina239_v_data <= 16'h0;
        ina239_i_data <= 16'h0;
        ina239_send <= 1'h0;
        ina239_recv <= 1'h0;
        ina239_initialized <= 1'h0;
        ina239_configured <= 1'h0;
        ina239_calibrated <= 1'h0;
        ina239_triggered <= 1'h0;
        ina239_counter <= 32'h0;
        ina239_recv_timer_r <= 32'h0;
        ina239_delay_r <= 32'h0;
        ina239_recv_done <= 1'h0;
        
        ina239_en_sweep_r <= 1'h0;
        ina239_phase_sweep_r <= 32'h0;
        ina239_phase_step_r <= 32'h0;
        ina239_phase_samples_r <= 32'h0;
        ina239_phase_sample_counter <= 32'h0;
        
        // reset controller
        if ( ina239_rstn_r ) begin
          ina239_rstn_r <= 1'h0;
          s2 <= s2_000;
        end else begin
          ina239_rstn_r <= 1'h1;
          s2 <= s2_001;
        end
      end

      s2_001: begin
        // reset device
        if ( ~ina239_initialized ) begin
          ina239_addr_r <= INA239_CONFIG;
          ina239_write_data_r <= { 1'h1 , 15'h0 };
          ina239_write_r <= 1'h1;
          ina239_send <= 1'h1;
          ina239_initialized <= 1'h1; 
        end else begin
          ina239_send <= 1'h0;
        end
        if ( ina239_done ) begin
          ina239_addr_r <= 6'h0;
          ina239_write_data_r <= 16'h0;
          ina239_write_r <= 1'h0;
          ina239_initialized <= 1'h0; 
          s2 <= s2_010;
        end else begin
          s2 <= s2_001;
        end
      end

      s2_010: begin
        // trigger readings
        if ( trig_m ) begin
          ina239_recv_timer_r <= ina239_recv_timer;
          ina239_delay_r <= ina239_delay;
          ina239_shunt_cal_r <= ina239_shunt_cal;
          ina239_range_r <= ina239_range;
          
          ina239_en_sweep_r <= ina239_en_sweep;
          ina239_phase_sweep_r <= ina239_phase_sweep;
          ina239_phase_step_r <= ina239_phase_step;
          ina239_phase_samples_r <= ina239_phase_samples;
          ina239_phase_sample_counter <= ina239_phase_samples - 32'h1;
        
          s2 <= s2_011;
        end else begin
          s2 <= s2_010;
        end
      end

      s2_011: begin
        // configure device
        if ( ~ina239_configured ) begin
          ina239_addr_r <= INA239_CONFIG;
          //                       rst    nc     dly    nc     range            nc
          ina239_write_data_r <= { 1'h0 , 1'h0 , 8'h0 , 1'h0 , ina239_range_r , 4'h0 };
          ina239_write_r <= 1'h1;
          ina239_send <= 1'h1;
          ina239_configured <= 1'h1;
        end else begin
          ina239_send <= 1'h0;
        end
        if ( ina239_done ) begin
          ina239_addr_r <= 6'h0;
          ina239_write_data_r <= 16'h0;
          ina239_write_r <= 1'h0;
          ina239_send <= 1'h0;
          ina239_configured <= 1'h0;
          s2 <= s2_100;
        end else begin
          s2 <= s2_011;
        end
      end

      s2_100: begin
        // calibrate device
        if ( ~ina239_calibrated ) begin
          ina239_addr_r <= INA239_SHUNT_CAL;
          //                       nc     shunt
          ina239_write_data_r <= { 1'h0 , ina239_shunt_cal };
          ina239_write_r <= 1'h1;
          ina239_send <= 1'h1;
          ina239_calibrated <= 1'h1;
        end else begin
          ina239_send <= 1'h0;
        end
        if ( ina239_done ) begin
          ina239_addr_r <= 6'h0;
          ina239_write_data_r <= 16'h0;
          ina239_write_r <= 1'h0;
          ina239_send <= 1'h0;
          ina239_calibrated <= 1'h0;
          ina239_counter <= 32'h0;
          s2 <= s2_101;
        end else begin
          s2 <= s2_100;
        end
      end

      s2_101: begin
        // trigger device
        ina239_fifo_wr_r <= 1'h0;
        if ( trig_m ) begin
          s2 <= s2_000;
        end else if ( ina239_en_sweep_r & ~|ina239_phase_sweep_r ) begin
          s2 <= s2_000;
        end else begin
            if ( ~ina239_triggered & ~|ina239_counter ) begin
              ina239_addr_r <= INA239_ADC;
              //                       mode          vbct   vsct   tct   adcct
              ina239_write_data_r <= { INA239_MODE , 3'h0 , 3'h0 , 3'h0, 3'h0 };
              ina239_write_r <= 1'h1;
              ina239_send <= 1'h1;
              ina239_triggered <= 1'h1;
            end else begin
              ina239_send <= 1'h0;
            end
            
            if ( ina239_done ) begin
              ina239_addr_r <= 6'h0;
              ina239_write_data_r <= 16'h0;
              ina239_write_r <= 1'h0;
              ina239_send <= 1'h0;
              ina239_triggered <= 1'h0;
              ina239_recv_done <= 1'h1;
              if ( ina239_en_sweep_r ) begin
                if ( ~|ina239_phase_sample_counter ) begin
                  ina239_phase_sample_counter <= ina239_phase_samples_r - 32'h1;
                  ina239_counter <= ina239_delay_r + ina239_phase_step_r - 32'h1;
                  ina239_phase_sweep_r <= ina239_phase_sweep_r - 32'h1;
                end else begin
                  ina239_phase_sample_counter <= ina239_phase_sample_counter - 32'h1;
                  ina239_counter <= ina239_delay_r - 32'h1;
                end 
              end else begin
                ina239_counter <= ina239_delay_r - 32'h1;
              end
              
              s2 <= s2_110;
            end else begin
              if ( |ina239_counter ) begin
                ina239_counter <= ina239_counter - 32'h1;
              end 
              s2 <= s2_101;
            end 
         end
      end

      s2_110: begin
        // read voltage
        if ( trig_m ) begin
          s2 <= s2_000;
        end else begin
          if ( ~|ina239_counter & ina239_recv_done ) begin
            ina239_addr_r <= INA239_BUS_VOL;
            ina239_write_r <= 1'h0;
            ina239_send <= 1'h1; // write does simultaneous read
            ina239_recv_done <= 1'h0;
            ina239_counter <= ina239_recv_timer_r;
          end else begin
            if ( |ina239_counter ) begin
              ina239_counter <= ina239_counter - 32'h1;
            end
            ina239_send <= 1'h0;  // write does simultaneous read
          end
          if ( ina239_done ) begin
            // send to current cycle
            ina239_recv_done <= 1'h1;
            ina239_v_data <= ina239_read_data[15:0];
            s2 <= s2_111;
          end else begin
            s2 <= s2_110;
          end
        end
      end

      s2_111: begin
        // read current
        if ( trig_m ) begin
          s2 <= s2_000;
        end else begin
          if ( ina239_recv_done ) begin
            ina239_addr_r <= INA239_CURRENT;
            ina239_write_r <= 1'h0;
            ina239_send <= 1'h1;  // write does simultaneous read
            ina239_recv_done <= 1'h0;
          end else begin
            ina239_send <= 1'h0;  // write does simultaneous read
          end
          if ( |ina239_counter ) begin
            ina239_counter <= ina239_counter - 32'h1;
          end
          if ( ina239_done ) begin
            // send back to trigger
            ina239_recv_done <= 1'h1;
            ina239_i_data <= ina239_read_data[15:0];
            ina239_fifo_wr_r <= 1'h1;
            s2 <= s2_101;
          end else begin
            s2 <= s2_111;
          end
        end
      end

      default: begin
        s2 <= s2_000;
      end

    endcase
  end
end

// instantiations
spi_core #(
  .ADDR_BW (8),
  .DATA_BW (24),
  .SPI_FRAME_BW (8),
  .SPI_CLK_DIV (1)
) dac530 (
  .clk (clk),
  .rstn (dac530_rstn),

  .addr (8'h0),
  .odata (dac530_write_data),
  .idata (dac530_read_data),

  .send (dac530_send),
  .recv (dac530_recv),
  .tsend (1'h0),
  .trecv (1'h0),

  .done (dac530_done),

  .miso (bat_s_miso),
  .mosi (bat_s_mosi),
  .sclk (bat_s_sclk),
  .cs (bat_s_cs)
); 

spi_core #(
  .ADDR_BW (8),
  .DATA_BW (24),
  .SPI_FRAME_BW (8),
  .SPI_CLK_DIV (1)
) ina239 (
  .clk (clk),
  .rstn (ina239_rstn),

  .addr (8'h0),
  .odata (ina239_write_data),
  .idata (ina239_read_data),

  .send (ina239_send),
  .recv (ina239_recv),
  .tsend (1'h0),
  .trecv (1'h0),

  .done (ina239_done),

  .miso (bat_m_miso),
  .mosi (bat_m_mosi),
  .sclk (bat_m_sclk),
  .cs (bat_m_cs)
);

endmodule
