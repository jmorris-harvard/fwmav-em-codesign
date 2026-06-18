module SWDInterface (
  input RESETn,

  output CORE_RSTn,
  output CORE_SWDI,
  output CORE_SWCLK,
  input CORE_SWDO,
  input CORE_SWDOEN,
  
  inout IF_SWDIO, // 
  input IF_SWCLK,
  output IF_SWO,
  input IF_RST
);

// Reset
assign CORE_RSTn = RESETn & ~IF_RST;

// SWDI
assign CORE_SWDI = IF_SWDIO;

// SWCLK
assign CORE_SWCLK = IF_SWCLK;

// SWDO
assign IF_SWDIO = (CORE_SWDOEN) ? CORE_SWDO : 1'bz;
assign IF_SWO = CORE_SWDO;

endmodule

