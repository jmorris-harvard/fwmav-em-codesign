`timescale 1ns / 1ps
module Top (
	// Clocks and Resets
	input wire CLK,
	input wire RESETn,

	// Core Debug Signals
	input wire SWCLKTCK,
	input wire SWRSTn,
	// input wire nTRST,
	input wire SWDITMS,
	// input wire TDI,
	output wire SWDO,
	output wire SWDOEN,
	// output wire TDO,
	// output wire nTDOEN,

	// Exposed flash
	output wire flash_mclk,
	output wire flash_mresetn,
	output wire flash_men,
	output wire [31:0] flash_maddr,
	output wire [31:0] flash_mdin,
	output wire [3:0] flash_mwe,
	input wire [31:0] flash_mdout,

	// Exposed sram
	output wire sram_mclk,
	output wire sram_mresetn,
	output wire sram_men,
	output wire [31:0] sram_maddr,
	output wire [31:0] sram_mdin,
	output wire [3:0] sram_mwe,
	input wire [31:0] sram_mdout,

	output [3:0] led_0_LedOut,

	input [0:0] sercomm_0_urx,
	output [0:0] sercomm_0_utx,
	output [0:0] sercomm_0_fifo_clk,
	output [0:0] sercomm_0_fifo_rst,
	output [7:0] sercomm_0_fifo_rx_din,
	output [0:0] sercomm_0_fifo_rx_wr,
	output [0:0] sercomm_0_fifo_rx_rd,
	input [7:0] sercomm_0_fifo_rx_dout,
	input [0:0] sercomm_0_fifo_rx_empty,
	input [0:0] sercomm_0_fifo_rx_full,
	output [7:0] sercomm_0_fifo_tx_din,
	output [0:0] sercomm_0_fifo_tx_wr,
	output [0:0] sercomm_0_fifo_tx_rd,
	input [7:0] sercomm_0_fifo_tx_dout,
	input [0:0] sercomm_0_fifo_tx_full,
	input [0:0] sercomm_0_fifo_tx_empty,

	output [0:0] override_0_cs,
	output [0:0] override_0_mosi,
	output [0:0] override_0_sck,
	input [0:0] override_0_compare,
	output [0:0] override_0_pdrive,
	output [0:0] override_0_ndrive,
	output [0:0] override_0_drive_en,


	output [0:0] boost_0_csn,
	output [0:0] boost_0_sdio,
	output [0:0] boost_0_sclk,
	input [0:0] boost_0_cmp,
	output [0:0] boost_0_drive_boost,

	output [1:0] chargepump_0_chargepump_drive
);

	// Signals
	// -- Core
	wire		mcu_clk;
	wire		mcu_hresetn;
	wire		mcu_hsel = 1'b1;
	wire [31:0] mcu_haddr;
	wire [2:0] mcu_hburst;
	wire		mcu_hmastlock;
	wire [3:0] mcu_hprot;
	wire [2:0] mcu_hsize;
	wire [1:0] mcu_htrans;
	wire [31:0] mcu_hwdata;
	wire		mcu_hwrite;
	wire [31:0] mcu_hrdata;
	wire		mcu_hready;
	wire		mcu_hresp;
	wire		mcu_hmaster;
	wire		mcu_dbgrestart = 1'b0;
	wire		mcu_edbgrq = 1'b0;
	wire		mcu_nmi = 1'b0;
	wire [31:0] mcu_irq;

	// -- flash
	wire flash_hclk;
	wire flash_hresetn;
	wire [31:0] flash_haddr;
	wire [2:0] flash_hburst;
	wire flash_hmastlock;
	wire [3:0] flash_hprot;
	wire [2:0] flash_hsize;
	wire [1:0] flash_htrans;
	wire [31:0] flash_hwdata;
	wire flash_hwrite;
	wire flash_hsel;
	wire flash_hready;
	wire [31:0] flash_hrdata;
	wire flash_hresp;

	// -- sram
	wire sram_hclk;
	wire sram_hresetn;
	wire [31:0] sram_haddr;
	wire [2:0] sram_hburst;
	wire sram_hmastlock;
	wire [3:0] sram_hprot;
	wire [2:0] sram_hsize;
	wire [1:0] sram_htrans;
	wire [31:0] sram_hwdata;
	wire sram_hwrite;
	wire sram_hsel;
	wire sram_hready;
	wire [31:0] sram_hrdata;
	wire sram_hresp;

	// -- led_0
	wire led_0_hclk;
	wire led_0_hresetn;
	wire [31:0] led_0_haddr;
	wire [2:0] led_0_hburst;
	wire led_0_hmastlock;
	wire [3:0] led_0_hprot;
	wire [2:0] led_0_hsize;
	wire [1:0] led_0_htrans;
	wire [31:0] led_0_hwdata;
	wire led_0_hwrite;
	wire led_0_hsel;
	wire led_0_hready;
	wire [31:0] led_0_hrdata;
	wire led_0_hresp;

	// -- sercomm_0
	wire sercomm_0_hclk;
	wire sercomm_0_hresetn;
	wire [31:0] sercomm_0_haddr;
	wire [2:0] sercomm_0_hburst;
	wire sercomm_0_hmastlock;
	wire [3:0] sercomm_0_hprot;
	wire [2:0] sercomm_0_hsize;
	wire [1:0] sercomm_0_htrans;
	wire [31:0] sercomm_0_hwdata;
	wire sercomm_0_hwrite;
	wire sercomm_0_hsel;
	wire sercomm_0_hready;
	wire [31:0] sercomm_0_hrdata;
	wire sercomm_0_hresp;

	// -- override_0
	wire override_0_hclk;
	wire override_0_hresetn;
	wire [31:0] override_0_haddr;
	wire [2:0] override_0_hburst;
	wire override_0_hmastlock;
	wire [3:0] override_0_hprot;
	wire [2:0] override_0_hsize;
	wire [1:0] override_0_htrans;
	wire [31:0] override_0_hwdata;
	wire override_0_hwrite;
	wire override_0_hsel;
	wire override_0_hready;
	wire [31:0] override_0_hrdata;
	wire override_0_hresp;

	// -- fpu_0
	wire fpu_0_hclk;
	wire fpu_0_hresetn;
	wire [31:0] fpu_0_haddr;
	wire [2:0] fpu_0_hburst;
	wire fpu_0_hmastlock;
	wire [3:0] fpu_0_hprot;
	wire [2:0] fpu_0_hsize;
	wire [1:0] fpu_0_htrans;
	wire [31:0] fpu_0_hwdata;
	wire fpu_0_hwrite;
	wire fpu_0_hsel;
	wire fpu_0_hready;
	wire [31:0] fpu_0_hrdata;
	wire fpu_0_hresp;

	// -- boost_0
	wire boost_0_hclk;
	wire boost_0_hresetn;
	wire [31:0] boost_0_haddr;
	wire [2:0] boost_0_hburst;
	wire boost_0_hmastlock;
	wire [3:0] boost_0_hprot;
	wire [2:0] boost_0_hsize;
	wire [1:0] boost_0_htrans;
	wire [31:0] boost_0_hwdata;
	wire boost_0_hwrite;
	wire boost_0_hsel;
	wire boost_0_hready;
	wire [31:0] boost_0_hrdata;
	wire boost_0_hresp;

	// -- chargepump_0
	wire chargepump_0_hclk;
	wire chargepump_0_hresetn;
	wire [31:0] chargepump_0_haddr;
	wire [2:0] chargepump_0_hburst;
	wire chargepump_0_hmastlock;
	wire [3:0] chargepump_0_hprot;
	wire [2:0] chargepump_0_hsize;
	wire [1:0] chargepump_0_htrans;
	wire [31:0] chargepump_0_hwdata;
	wire chargepump_0_hwrite;
	wire chargepump_0_hsel;
	wire chargepump_0_hready;
	wire [31:0] chargepump_0_hrdata;
	wire chargepump_0_hresp;

	// Routing
	// -- Core
	assign mcu_clk = CLK;
	assign mcu_irq[31:0] = {(32){1'b0}};

	// -- flash
	assign flash_hclk = mcu_clk;
	assign flash_hresetn = mcu_hresetn;
	assign flash_hmastlock = 1'b0;

	// -- sram
	assign sram_hclk = mcu_clk;
	assign sram_hresetn = mcu_hresetn;
	assign sram_hmastlock = 1'b0;

	// -- led_0
	assign led_0_hclk = mcu_clk;
	assign led_0_hresetn = mcu_hresetn;
	assign led_0_hmastlock = 1'b0;

	// -- sercomm_0
	assign sercomm_0_hclk = mcu_clk;
	assign sercomm_0_hresetn = mcu_hresetn;
	assign sercomm_0_hmastlock = 1'b0;

	// -- override_0
	assign override_0_hclk = mcu_clk;
	assign override_0_hresetn = mcu_hresetn;
	assign override_0_hmastlock = 1'b0;

	// -- fpu_0
	assign fpu_0_hclk = mcu_clk;
	assign fpu_0_hresetn = mcu_hresetn;
	assign fpu_0_hmastlock = 1'b0;

	// -- boost_0
	assign boost_0_hclk = mcu_clk;
	assign boost_0_hresetn = mcu_hresetn;
	assign boost_0_hmastlock = 1'b0;

	// -- chargepump_0
	assign chargepump_0_hclk = mcu_clk;
	assign chargepump_0_hresetn = mcu_hresetn;
	assign chargepump_0_hmastlock = 1'b0;

	// Instantiations
	// -- Core
	CM0DbgAHB #(
		.ACG (0),
		.BE (0),
		.BKPT (4),
		.DBG (1),
		.JTAGnSW (0),
		.NUMIRQ (32),
		.RAR (0),
		.SMUL (0),
		.SYST (1),
		.WIC (1),
		.WICLINES (34),
		.WPT (2)
	) u_core (
		.CLK (mcu_clk),
		.SWCLKTCK (SWCLKTCK),
		.SWRSTn (SWRSTn),
		.nTRST (1'b1),
		.SYSRESETn (RESETn),
		.HRESETn (mcu_hresetn),

		.SWDITMS (SWDITMS),
		.TDI (1'b0),
		.SWDO (SWDO),
		.SWDOEN (SWDOEN),
		.TDO (),
		.nTDOEN (),
		.DBGRESTART (mcu_dbgrestart),
		.DBGRESTARTED (DBGRESTARTED),
		.EDBGRQ (mcu_edbgrq),
		.HALTED (HALTED),

		.HADDR (mcu_haddr),
		.HBURST (mcu_hburst),
		.HMASTLOCK (mcu_mastlock),
		.HPROT (mcu_hprot),
		.HSIZE (mcu_hsize),
		.HTRANS (mcu_htrans),
		.HWDATA (mcu_hwdata),
		.HWRITE (mcu_hwrite),
		.HRDATA (mcu_hrdata),
		.HREADY (mcu_hready),
		.HRESP (mcu_hresp),
		.HMASTER (mcu_hmaster),

		.NMI (mcu_nmi),
		.IRQ (mcu_irq),
		.LOCKUP (LOCKUP)
	);

	// Interconnect
	ahb_interconnect #(
		.DATA_WIDTH (32),
		.ADDR_WIDTH (32),

		.M0_PASSTHROUGH (0),
		.M0_BASEADDR (32'h0000_0000),
		.M0_SIZE (32'h0001_0000),

		.M1_PASSTHROUGH (0),
		.M1_BASEADDR (32'h2000_0000),
		.M1_SIZE (32'h0000_8000),

		.M2_PASSTHROUGH (0),
		.M2_BASEADDR (32'h4000_0000),
		.M2_SIZE (32'h0000_1000),

		.M3_PASSTHROUGH (0),
		.M3_BASEADDR (32'h4000_1000),
		.M3_SIZE (32'h0000_1000),

		.M4_PASSTHROUGH (0),
		.M4_BASEADDR (32'h4000_2000),
		.M4_SIZE (32'h0000_1000),

		.M5_PASSTHROUGH (0),
		.M5_BASEADDR (32'h4000_3000),
		.M5_SIZE (32'h0000_1000),

		.M6_PASSTHROUGH (0),
		.M6_BASEADDR (32'h4000_4000),
		.M6_SIZE (32'h0000_1000),

		.M7_PASSTHROUGH (0),
		.M7_BASEADDR (32'h4000_5000),
		.M7_SIZE (32'h0000_1000)
	) u_interconnect (
		.HCLK (mcu_clk),
		.HRESETn (mcu_hresetn),

		.S0_HSEL (mcu_hsel),
		.S0_HADDR (mcu_haddr),
		.S0_HWRITE (mcu_hwrite),
		.S0_HSIZE (mcu_hsize),
		.S0_HBURST (mcu_hburst),
		.S0_HPROT (mcu_hprot),
		.S0_HTRANS (mcu_htrans),
		.S0_HMASTLOCK (mcu_hmastlock),
		.S0_HWDATA (mcu_hwdata),
		.S0_HREADY (mcu_hready),
		.S0_HRESP (mcu_hresp),
		.S0_HRDATA (mcu_hrdata),

		.M0_HSEL (flash_hsel),
		.M0_HADDR (flash_haddr),
		.M0_HWRITE (flash_hwrite),
		.M0_HSIZE (flash_hsize),
		.M0_HBURST (flash_hburst),
		.M0_HPROT (flash_hprot),
		.M0_HTRANS (flash_htrans),
		.M0_HMASTLOCK (flash_hmastlock),
		.M0_HWDATA (flash_hwdata),
		.M0_HREADY (flash_hready),
		.M0_HRESP (flash_hresp),
		.M0_HRDATA (flash_hrdata),

		.M1_HSEL (sram_hsel),
		.M1_HADDR (sram_haddr),
		.M1_HWRITE (sram_hwrite),
		.M1_HSIZE (sram_hsize),
		.M1_HBURST (sram_hburst),
		.M1_HPROT (sram_hprot),
		.M1_HTRANS (sram_htrans),
		.M1_HMASTLOCK (sram_hmastlock),
		.M1_HWDATA (sram_hwdata),
		.M1_HREADY (sram_hready),
		.M1_HRESP (sram_hresp),
		.M1_HRDATA (sram_hrdata),

		.M2_HSEL (led_0_hsel),
		.M2_HADDR (led_0_haddr),
		.M2_HWRITE (led_0_hwrite),
		.M2_HSIZE (led_0_hsize),
		.M2_HBURST (led_0_hburst),
		.M2_HPROT (led_0_hprot),
		.M2_HTRANS (led_0_htrans),
		.M2_HMASTLOCK (led_0_hmastlock),
		.M2_HWDATA (led_0_hwdata),
		.M2_HREADY (led_0_hready),
		.M2_HRESP (led_0_hresp),
		.M2_HRDATA (led_0_hrdata),

		.M3_HSEL (sercomm_0_hsel),
		.M3_HADDR (sercomm_0_haddr),
		.M3_HWRITE (sercomm_0_hwrite),
		.M3_HSIZE (sercomm_0_hsize),
		.M3_HBURST (sercomm_0_hburst),
		.M3_HPROT (sercomm_0_hprot),
		.M3_HTRANS (sercomm_0_htrans),
		.M3_HMASTLOCK (sercomm_0_hmastlock),
		.M3_HWDATA (sercomm_0_hwdata),
		.M3_HREADY (sercomm_0_hready),
		.M3_HRESP (sercomm_0_hresp),
		.M3_HRDATA (sercomm_0_hrdata),

		.M4_HSEL (override_0_hsel),
		.M4_HADDR (override_0_haddr),
		.M4_HWRITE (override_0_hwrite),
		.M4_HSIZE (override_0_hsize),
		.M4_HBURST (override_0_hburst),
		.M4_HPROT (override_0_hprot),
		.M4_HTRANS (override_0_htrans),
		.M4_HMASTLOCK (override_0_hmastlock),
		.M4_HWDATA (override_0_hwdata),
		.M4_HREADY (override_0_hready),
		.M4_HRESP (override_0_hresp),
		.M4_HRDATA (override_0_hrdata),

		.M5_HSEL (fpu_0_hsel),
		.M5_HADDR (fpu_0_haddr),
		.M5_HWRITE (fpu_0_hwrite),
		.M5_HSIZE (fpu_0_hsize),
		.M5_HBURST (fpu_0_hburst),
		.M5_HPROT (fpu_0_hprot),
		.M5_HTRANS (fpu_0_htrans),
		.M5_HMASTLOCK (fpu_0_hmastlock),
		.M5_HWDATA (fpu_0_hwdata),
		.M5_HREADY (fpu_0_hready),
		.M5_HRESP (fpu_0_hresp),
		.M5_HRDATA (fpu_0_hrdata),

		.M6_HSEL (boost_0_hsel),
		.M6_HADDR (boost_0_haddr),
		.M6_HWRITE (boost_0_hwrite),
		.M6_HSIZE (boost_0_hsize),
		.M6_HBURST (boost_0_hburst),
		.M6_HPROT (boost_0_hprot),
		.M6_HTRANS (boost_0_htrans),
		.M6_HMASTLOCK (boost_0_hmastlock),
		.M6_HWDATA (boost_0_hwdata),
		.M6_HREADY (boost_0_hready),
		.M6_HRESP (boost_0_hresp),
		.M6_HRDATA (boost_0_hrdata),

		.M7_HSEL (chargepump_0_hsel),
		.M7_HADDR (chargepump_0_haddr),
		.M7_HWRITE (chargepump_0_hwrite),
		.M7_HSIZE (chargepump_0_hsize),
		.M7_HBURST (chargepump_0_hburst),
		.M7_HPROT (chargepump_0_hprot),
		.M7_HTRANS (chargepump_0_htrans),
		.M7_HMASTLOCK (chargepump_0_hmastlock),
		.M7_HWDATA (chargepump_0_hwdata),
		.M7_HREADY (chargepump_0_hready),
		.M7_HRESP (chargepump_0_hresp),
		.M7_HRDATA (chargepump_0_hrdata)
	);

	mem_ahb_interpreter #(
		.DATA_WIDTH (32),
		.MEM_BYTES (32'h0001_0000)
	) flash_mem_interpreter_inst (
		.HCLK (flash_hclk),
		.HRESETn (flash_hresetn),

		.HADDR (flash_haddr),
		.HBURST (flash_hburst),
		.HPROT (flash_hprot),
		.HSIZE (flash_hsize),
		.HTRANS (flash_htrans),
		.HMASTLOCK (flash_hmastlock),
		.HWDATA (flash_hwdata),
		.HWRITE (flash_hwrite),
		.HSEL (flash_hsel),
		.HREADYIN (flash_hready),
		.HRDATA (flash_hrdata),
		.HREADYOUT (flash_hready),
		.HRESP (flash_hresp),

		.MCLK (flash_mclk),
		.MRESETn (flash_mresetn),
		.MEN (flash_men),
		.MADDR (flash_maddr),
		.MDIN (flash_mdin),
		.MWE (flash_mwe),
		.MDONE (1'b1),
		.MERROR (1'b0),
		.MDOUT (flash_mdout)
	);

	mem_ahb_interpreter #(
		.DATA_WIDTH (32),
		.MEM_BYTES (32'h0000_8000)
	) sram_mem_interpreter_inst (
		.HCLK (sram_hclk),
		.HRESETn (sram_hresetn),

		.HADDR (sram_haddr),
		.HBURST (sram_hburst),
		.HPROT (sram_hprot),
		.HSIZE (sram_hsize),
		.HTRANS (sram_htrans),
		.HMASTLOCK (sram_hmastlock),
		.HWDATA (sram_hwdata),
		.HWRITE (sram_hwrite),
		.HSEL (sram_hsel),
		.HREADYIN (sram_hready),
		.HRDATA (sram_hrdata),
		.HREADYOUT (sram_hready),
		.HRESP (sram_hresp),

		.MCLK (sram_mclk),
		.MRESETn (sram_mresetn),
		.MEN (sram_men),
		.MADDR (sram_maddr),
		.MDIN (sram_mdin),
		.MWE (sram_mwe),
		.MDONE (1'b1),
		.MERROR (1'b0),
		.MDOUT (sram_mdout)
	);

	led_ahb #(
		.DATA_WIDTH (32)
	) led_0_inst (
		.HCLK (led_0_hclk),
		.HRESETn (led_0_hresetn),

		.HADDR (led_0_haddr),
		.HBURST (led_0_hburst),
		.HPROT (led_0_hprot),
		.HSIZE (led_0_hsize),
		.HTRANS (led_0_htrans),
		.HMASTLOCK (led_0_hmastlock),
		.HWDATA (led_0_hwdata),
		.HWRITE (led_0_hwrite),
		.HSEL (led_0_hsel),
		.HREADYIN (led_0_hready),
		.HRDATA (led_0_hrdata),
		.HREADYOUT (led_0_hready),
		.HRESP (led_0_hresp),
		.LedOut (led_0_LedOut)
	);

	sercomm_ahb #(
		.DATA_WIDTH (32)
	) sercomm_0_inst (
		.HCLK (sercomm_0_hclk),
		.HRESETn (sercomm_0_hresetn),

		.HADDR (sercomm_0_haddr),
		.HBURST (sercomm_0_hburst),
		.HPROT (sercomm_0_hprot),
		.HSIZE (sercomm_0_hsize),
		.HTRANS (sercomm_0_htrans),
		.HMASTLOCK (sercomm_0_hmastlock),
		.HWDATA (sercomm_0_hwdata),
		.HWRITE (sercomm_0_hwrite),
		.HSEL (sercomm_0_hsel),
		.HREADYIN (sercomm_0_hready),
		.HRDATA (sercomm_0_hrdata),
		.HREADYOUT (sercomm_0_hready),
		.HRESP (sercomm_0_hresp),
		.urx (sercomm_0_urx),
		.utx (sercomm_0_utx),
		.fifo_clk (sercomm_0_fifo_clk),
		.fifo_rst (sercomm_0_fifo_rst),
		.fifo_rx_din (sercomm_0_fifo_rx_din),
		.fifo_rx_wr (sercomm_0_fifo_rx_wr),
		.fifo_rx_rd (sercomm_0_fifo_rx_rd),
		.fifo_rx_dout (sercomm_0_fifo_rx_dout),
		.fifo_rx_empty (sercomm_0_fifo_rx_empty),
		.fifo_rx_full (sercomm_0_fifo_rx_full),
		.fifo_tx_din (sercomm_0_fifo_tx_din),
		.fifo_tx_wr (sercomm_0_fifo_tx_wr),
		.fifo_tx_rd (sercomm_0_fifo_tx_rd),
		.fifo_tx_dout (sercomm_0_fifo_tx_dout),
		.fifo_tx_full (sercomm_0_fifo_tx_full),
		.fifo_tx_empty (sercomm_0_fifo_tx_empty)
	);

	overrideChip_ahb #(
		.DATA_WIDTH (32)
	) override_0_inst (
		.HCLK (override_0_hclk),
		.HRESETn (override_0_hresetn),

		.HADDR (override_0_haddr),
		.HBURST (override_0_hburst),
		.HPROT (override_0_hprot),
		.HSIZE (override_0_hsize),
		.HTRANS (override_0_htrans),
		.HMASTLOCK (override_0_hmastlock),
		.HWDATA (override_0_hwdata),
		.HWRITE (override_0_hwrite),
		.HSEL (override_0_hsel),
		.HREADYIN (override_0_hready),
		.HRDATA (override_0_hrdata),
		.HREADYOUT (override_0_hready),
		.HRESP (override_0_hresp),
		.cs (override_0_cs),
		.mosi (override_0_mosi),
		.sck (override_0_sck),
		.compare (override_0_compare),
		.pdrive (override_0_pdrive),
		.ndrive (override_0_ndrive),
		.drive_en (override_0_drive_en)
	);

	fpu_ahb #(
		.DATA_WIDTH (32)
	) fpu_0_inst (
		.HCLK (fpu_0_hclk),
		.HRESETn (fpu_0_hresetn),

		.HADDR (fpu_0_haddr),
		.HBURST (fpu_0_hburst),
		.HPROT (fpu_0_hprot),
		.HSIZE (fpu_0_hsize),
		.HTRANS (fpu_0_htrans),
		.HMASTLOCK (fpu_0_hmastlock),
		.HWDATA (fpu_0_hwdata),
		.HWRITE (fpu_0_hwrite),
		.HSEL (fpu_0_hsel),
		.HREADYIN (fpu_0_hready),
		.HRDATA (fpu_0_hrdata),
		.HREADYOUT (fpu_0_hready),
		.HRESP (fpu_0_hresp)
	);

	boost_ahb #(
		.DATA_WIDTH (32)
	) boost_0_inst (
		.HCLK (boost_0_hclk),
		.HRESETn (boost_0_hresetn),

		.HADDR (boost_0_haddr),
		.HBURST (boost_0_hburst),
		.HPROT (boost_0_hprot),
		.HSIZE (boost_0_hsize),
		.HTRANS (boost_0_htrans),
		.HMASTLOCK (boost_0_hmastlock),
		.HWDATA (boost_0_hwdata),
		.HWRITE (boost_0_hwrite),
		.HSEL (boost_0_hsel),
		.HREADYIN (boost_0_hready),
		.HRDATA (boost_0_hrdata),
		.HREADYOUT (boost_0_hready),
		.HRESP (boost_0_hresp),
		.csn (boost_0_csn),
		.sdio (boost_0_sdio),
		.sclk (boost_0_sclk),
		.cmp (boost_0_cmp),
		.drive_boost (boost_0_drive_boost)
	);

	chargepump_ahb #(
		.DATA_WIDTH (32)
	) chargepump_0_inst (
		.HCLK (chargepump_0_hclk),
		.HRESETn (chargepump_0_hresetn),

		.HADDR (chargepump_0_haddr),
		.HBURST (chargepump_0_hburst),
		.HPROT (chargepump_0_hprot),
		.HSIZE (chargepump_0_hsize),
		.HTRANS (chargepump_0_htrans),
		.HMASTLOCK (chargepump_0_hmastlock),
		.HWDATA (chargepump_0_hwdata),
		.HWRITE (chargepump_0_hwrite),
		.HSEL (chargepump_0_hsel),
		.HREADYIN (chargepump_0_hready),
		.HRDATA (chargepump_0_hrdata),
		.HREADYOUT (chargepump_0_hready),
		.HRESP (chargepump_0_hresp),
		.chargepump_drive (chargepump_0_chargepump_drive)
	);

endmodule
