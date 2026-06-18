module TopWrapper (
  input clk,
  input rstn,

  input prog,

  output [3:0] led,

  input urx,
  output utx,

  output cs,
  output mosi,
  output sck,
  input compare,
  output pdrive,
  output ndrive,
  output drive_en,

  output bcsn,
  output bsdio,
  output bsclk,
  input bcmp,
  output bboost,

  output [1:0] cp_drive,

  inout IF_SWDIO,
  input IF_SWCLK,
  output IF_SWO,
  input IF_RST
);
  // Clocking
  wire mcu_clk;
  wizard wizard_inst (
    .clk_out1 (mcu_clk),
    .clk_in1 (clk)
  );

  // Top Instance
  wire CORE_RESETn;
  wire CORE_SWDI;
  wire CORE_SWCLK;
  wire CORE_SWDO;
  wire CORE_SWDOEN; 

  // -- memories
  // mcu ctrl
  wire flash_mclk;
  wire flash_mresetn;
  wire flash_men;
  wire [31:0] flash_maddr;
  wire [31:0] flash_mdin;
  wire [3:0] flash_mwe;
  wire [31:0] flash_mdout;
  assign flash_mdout = rom_mdout;

  // external ctrl
  reg ext_men;
  reg [31:0] ext_maddr;
  reg [31:0] ext_mdin;
  reg ext_mwe;
  wire [31:0] ext_mdout;
  assign ext_mdout = rom_mdout;

  wire rom_mclk;
  assign rom_mclk = (prog) ? mcu_clk : flash_mclk;
  // wire rom_reset;
  wire rom_men;
  assign rom_men = (prog) ? ext_men : flash_men;
  wire [31:0] rom_maddr = (prog) ? ext_maddr : flash_maddr;
  wire [31:0] rom_mdin = (prog) ? ext_mdin : flash_mdin;
  wire rom_mwe = (prog) ? ext_mwe : |flash_mwe;
  wire [31:0] rom_mdout;

  wire sram_mclk;
  wire sram_mresetn;
  wire sram_men;
  wire [31:0] sram_maddr;
  wire [31:0] sram_mdin;
  wire [3:0] sram_mwe;
  wire [31:0] sram_mdout;

	wire sercomm_0_fifo_clk;
	wire sercomm_0_fifo_rst;
	wire [7:0] sercomm_0_fifo_rx_din;
	wire sercomm_0_fifo_rx_wr;
	wire sercomm_0_fifo_rx_rd;
	wire [7:0] sercomm_0_fifo_rx_dout;
	wire sercomm_0_fifo_rx_empty;
	wire sercomm_0_fifo_rx_full;
	wire [7:0] sercomm_0_fifo_tx_din;
	wire sercomm_0_fifo_tx_wr;
	wire sercomm_0_fifo_tx_rd;
	wire [7:0] sercomm_0_fifo_tx_dout;
	wire sercomm_0_fifo_tx_full;
	wire sercomm_0_fifo_tx_empty;

  // -- uart
  wire ext_uart_clk;
  assign ext_uart_clk = mcu_clk;
  wire ext_uart_rst;
  assign ext_uart_rst = ~prog | ~rstn;
  reg [7:0] ext_uart_tx_dat;
  reg ext_uart_tx_valid;
  wire ext_uart_tx_rdy;
  wire [7:0] ext_uart_rx_dat;
  wire ext_uart_rx_valid;
  reg ext_uart_rx_rdy;
  wire ext_uart_urx;
  assign ext_uart_urx = (prog) ? urx : 1'bz; 
  wire ext_uart_utx;
  reg [15:0] ext_uart_prescale = (16'd520 >> 3);

  reg [1:0] ext_uart_word_ctr;

  // -- sercomm external takeover
  wire sercomm_0_fifo_utx;
  wire sercomm_0_fifo_urx;
  assign sercomm_0_fifo_urx = (prog) ? 1'bz : urx;
  assign utx = (prog) ? ext_uart_utx : sercomm_0_fifo_utx;

  // -- led external takeover
  reg [3:0] ext_led;
  reg [31:0] ext_led_ctr;
  wire [3:0] led_0_led;
  assign led = (prog) ? ext_led : led_0_led;

  // led prog state machine
  always @(posedge mcu_clk) begin
    if ( ~prog ) begin
      ext_led <= 4'b0;
      ext_led_ctr <= 32'b0;
    end else begin
      if ( ext_led_ctr == 32'd5000000 /* 1 second */ ) begin
        ext_led[0] <= ~ext_led[0];
        ext_led[1] <= ~ext_led[1];
        ext_led[2] <= ~ext_led[2];
        ext_led[3] <= ~ext_led[3];
        ext_led_ctr <= 32'b0;
      end else begin
        ext_led_ctr <= ext_led_ctr + 32'b1;
      end
    end
  end

  // prog state machine
  always @(posedge mcu_clk) begin
    if ( ~prog ) begin
      ext_men <= 1'b0;
      ext_maddr <= 32'b0;
      ext_mdin <= 32'b0;
      ext_mwe <= 1'b0;

      ext_uart_tx_dat <= 8'b0;
      ext_uart_tx_valid <= 1'b0;
      ext_uart_rx_rdy <= 1'b0;

      ext_uart_word_ctr <= 2'b0;
    end else begin
      // control uart
      ext_uart_rx_rdy <= 1'b1;
      ext_men <= 1'b1;
      ext_mwe <= 1'b0;

      if ( ext_uart_rx_valid ) begin
        // shift incoming byte into mem din
        ext_mdin <= { ext_mdin[23:0] , ext_uart_rx_dat };
        ext_uart_word_ctr <= ext_uart_word_ctr + 2'b1;

        if ( &ext_uart_word_ctr ) begin
          // with all 4 bytes load into mem
          ext_mwe <= 1'b1;
        end
      end

      if ( ext_mwe ) begin
        // increment address after write
        ext_maddr <= ext_maddr + 32'h4;
      end
    end
  end

  uart #(
    .DATA_WIDTH (8)
  ) ext_uart_inst (
    .clk (ext_uart_clk),
    .rst (ext_uart_rst),

    .s_axis_tdata (ext_uart_tx_dat),
    .s_axis_tvalid (ext_uart_tx_valid),
    .s_axis_tready (ext_uart_tx_rdy),

    .m_axis_tdata (ext_uart_rx_dat),
    .m_axis_tvalid (ext_uart_rx_valid),
    .m_axis_tready (ext_uart_rx_rdy),

    .rxd (ext_uart_urx),
    .txd (ext_uart_utx),

    .tx_busy (),
    .rx_busy (),
    
    .rx_overrun_error (),
    .rx_frame_error (),

    .prescale (ext_uart_prescale)
  );

  Top Top_inst
  (
    .CLK (mcu_clk),
    .RESETn (CORE_RESETn & ~prog),
    // reset truth table
    // CORE_RESETn  prog  ~prog  RESETn
    //  0            0      1     0
    //  0            1      0     0
    //  1            0      1     1
    //  1            1      0     0

    .SWCLKTCK (CORE_SWCLK),
    .SWRSTn (1'b1),
    .SWDITMS (CORE_SWDI),
    .SWDO (CORE_SWDO),
    .SWDOEN (CORE_SWDOEN),
  
    // program memory
    .flash_mclk (flash_mclk),
    .flash_mresetn (flash_mresetn),
    .flash_men (flash_men),
    .flash_maddr (flash_maddr),
    .flash_mdin (flash_mdin),
    .flash_mwe (flash_mwe),
    .flash_mdout (flash_mdout),

    // data memory
    .sram_mclk (sram_mclk),
    .sram_mresetn (sram_mresetn),
    .sram_men (sram_men),
    .sram_maddr (sram_maddr),
    .sram_mdin (sram_mdin),
    .sram_mwe (sram_mwe),
    .sram_mdout (sram_mdout),

    .led_0_LedOut (led_0_led),

	  .sercomm_0_urx (sercomm_0_fifo_urx),
	  .sercomm_0_utx (sercomm_0_fifo_utx),
	  .sercomm_0_fifo_clk (sercomm_0_fifo_clk),
	  .sercomm_0_fifo_rst (sercomm_0_fifo_rst),
	  .sercomm_0_fifo_rx_din (sercomm_0_fifo_rx_din),
	  .sercomm_0_fifo_rx_wr (sercomm_0_fifo_rx_wr),
	  .sercomm_0_fifo_rx_rd (sercomm_0_fifo_rx_rd),
	  .sercomm_0_fifo_rx_dout (sercomm_0_fifo_rx_dout),
	  .sercomm_0_fifo_rx_empty (sercomm_0_fifo_rx_empty),
	  .sercomm_0_fifo_rx_full (sercomm_0_fifo_rx_full),
	  .sercomm_0_fifo_tx_din (sercomm_0_fifo_tx_din),
	  .sercomm_0_fifo_tx_wr (sercomm_0_fifo_tx_wr),
	  .sercomm_0_fifo_tx_rd (sercomm_0_fifo_tx_rd),
	  .sercomm_0_fifo_tx_dout (sercomm_0_fifo_tx_dout),
	  .sercomm_0_fifo_tx_full (sercomm_0_fifo_tx_full),
	  .sercomm_0_fifo_tx_empty (sercomm_0_fifo_tx_empty),

	  .override_0_cs (cs),
	  .override_0_mosi (mosi),
	  .override_0_sck (sck),
	  .override_0_compare (compare),
	  .override_0_pdrive (pdrive),
    .override_0_ndrive (ndrive),
	  .override_0_drive_en (drive_en),

    .boost_0_csn (bcsn),
    .boost_0_sdio (bsdio),
    .boost_0_sclk (bsclk),
    .boost_0_cmp (bcmp),
    .boost_0_drive_boost (bboost),

    .chargepump_0_chargepump_drive (cp_drive)
  );

  SWDInterface SWDInterfaceInst
  (
    .RESETn (rstn),

    .CORE_RSTn (CORE_RESETn),
    .CORE_SWDI (CORE_SWDI),
    .CORE_SWCLK (CORE_SWCLK),
    .CORE_SWDO (CORE_SWDO),
    .CORE_SWDOEN (CORE_SWDOEN),

    .IF_SWDIO (IF_SWDIO),
    .IF_SWCLK (IF_SWCLK),
    .IF_SWO (IF_SWO),
    .IF_RST (IF_RST)
  );

  // memories 
  rom rom_inst (
    .addra  (rom_maddr[31:2]),
    .ena    (rom_men),
    .dina   (rom_mdin),
    .clka   (rom_mclk),
    .wea    (rom_mwe),
    .douta  (rom_mdout)
  );

  ram ram_inst (
    .addra  (sram_maddr[31:2]),
    .ena    (sram_men),
    .dina   (sram_mdin),
    .clka   (sram_mclk),
    .wea    (|sram_mwe),
    .douta  (sram_mdout)
  );

  // uart fifos
  // -- rx
  fifo fifo_rx (
   .clk (sercomm_0_fifo_clk),
   .srst (sercomm_0_fifo_rst),
   .din (sercomm_0_fifo_rx_din),
   .wr_en (sercomm_0_fifo_rx_wr),
   .rd_en (sercomm_0_fifo_rx_rd),
   .dout (sercomm_0_fifo_rx_dout),
   .full (sercomm_0_fifo_rx_full),
   .empty (sercomm_0_fifo_rx_empty)
  ); 

  // -- tx
  fifo fifo_tx (
   .clk (sercomm_0_fifo_clk),
   .srst (sercomm_0_fifo_rst),
   .din (sercomm_0_fifo_tx_din),
   .wr_en (sercomm_0_fifo_tx_wr),
   .rd_en (sercomm_0_fifo_tx_rd),
   .dout (sercomm_0_fifo_tx_dout),
   .full (sercomm_0_fifo_tx_full),
   .empty (sercomm_0_fifo_tx_empty)
  );

endmodule
