module boostctl (
  input wire clk,
  input wire rstn,

  // control signals
  // boost
  input wire [15:0] boost_divider,

  // internal signals
  // boost
  input wire boost_trigger,
  output wire boost_running,

  // adc
  input wire adc_send,
  input wire [7:0] adc_threshold,

  // io signals 
  // boost
  output wire boost_drive,

  // comparator output
  input wire cmp,

  // adc feedback control
  output wire csn,
  output wire sdio,
  output wire sclk
);

// wires and registers
reg boost_drive_reg;

reg [15:0] boost_divider_reg;

reg boost_s0;

wire adc_ready;

// logic
assign boost_drive = boost_drive_reg;
assign boost_running = boost_s0;

// instantiations
spi_core #(
  .O_BW (32'h8),
  .I_BW (32'h8),
  .N_SLAVES (1)
) spi_core_inst (
  .clk (clk),
  .rstn (rstn),
  .csn (csn),
  .sclk (sclk),
  .sdio (sdio),
    
  .odata (adc_threshold), // change
  .idata (), // no read

  .send (adc_send),
  .recv (1'b0),

  .ready (adc_ready)
);


// state machines
// boost
localparam boost_s0_0 = 1'b0;
localparam boost_s0_1 = 1'b1;
always @(posedge clk) begin
  if ( ~rstn ) begin
    boost_s0 <= 1'b0;
    boost_divider_reg <= 8'b0;
    boost_drive_reg <= 1'b0;
  end else begin
    case (boost_s0)
      boost_s0_0: begin
        boost_divider_reg <= 8'b0;
        boost_drive_reg <= 1'b0;
        if ( boost_trigger ) begin
          // start running driver
          boost_s0 <= boost_s0_1;
          boost_divider_reg <= boost_divider;
        end
      end

      boost_s0_1: begin
        if ( boost_trigger ) begin
          // end boost driver
          boost_s0 <= boost_s0_0;
        end else if ( ~|boost_divider_reg ) begin
          // counter hit 0
          if ( cmp & ~boost_drive ) begin
            // if feedback is below threshold and not triggered
            boost_drive_reg <= 1'b1;
            boost_divider_reg <= boost_divider_reg;
          end else if ( boost_drive ) begin
            // if done with cycle unset trigger
            boost_drive_reg <= 1'b0;
            boost_divider_reg <= boost_divider_reg;
          end
        end

        if ( |boost_divider_reg ) begin
          boost_divider_reg <= boost_divider_reg - 8'b1;
        end
      end

      default: begin
        boost_s0 <= boost_s0_0;
      end
    endcase
  end
end

endmodule
