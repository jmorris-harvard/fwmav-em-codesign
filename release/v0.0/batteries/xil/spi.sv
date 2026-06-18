module spi_core #(
  // input parameters
  parameter integer ADDR_BW = 32'h8,
  parameter integer DATA_BW = 32'h8,
  parameter integer SPI_FRAME_BW = 32'h8,
  parameter integer SPI_CLK_DIV = 32'h8
) (
  input wire clk,
  input wire rstn,

  // internal control signals
  input wire [ADDR_BW-1:0] addr,
  input wire [DATA_BW-1:0] odata,
  output wire [DATA_BW-1:0] idata,

  input wire send,
  input wire recv,
  input wire tsend,
  input wire trecv,

  output wire done,

  // external ic signals
  input wire miso,
  output wire mosi,
  output wire sclk,
  output wire cs
);

// local parameters
localparam integer ADDR_FRAME_LEN = $ceil (ADDR_BW / SPI_FRAME_BW);
localparam integer DATA_FRAME_LEN = $ceil (DATA_BW / SPI_FRAME_BW);
localparam integer TRUE_DATA_BW = DATA_FRAME_LEN * SPI_FRAME_BW;

// wires and registers
reg [TRUE_DATA_BW - 1:0] idata_s;
reg [DATA_BW-1:0] odata_s;
reg [ADDR_BW-1:0] addr_s;

reg [DATA_BW-1:0] idata_r;

reg send_r;
reg addr_r;

reg mosi_r;
reg cs_r;
reg sclk_r;
reg sclk_buf;

reg done_r;

reg [31:0] sclk_div;
reg [31:0] frame_bit_ctr;
reg [31:0] frame_ctr;
reg frame_start;
reg frame_done;

reg [SPI_FRAME_BW-1:0] write_frame;
reg [SPI_FRAME_BW-1:0] write_frame_buffer;
reg [SPI_FRAME_BW-1:0] read_frame_buffer;

// routing
assign idata = idata_r; 

assign mosi = mosi_r;
assign sclk = sclk_buf;
assign cs = cs_r;

assign done = done_r;

// state machines
// send
reg [1:0] s0;
localparam s0_00 = 2'h0;
localparam s0_01 = 2'h1;
localparam s0_10 = 2'h2;
localparam s0_11 = 2'h3;
always @(posedge clk or negedge rstn) begin
  if ( ~rstn ) begin
    addr_s <= ADDR_BW'('h0);
    odata_s <= DATA_BW'('h0);
    idata_s <= DATA_BW'('h0);
    idata_r <= DATA_BW'('h0);
    send_r <= 1'b0;
    done_r <= 1'b0;
    addr_r <= 1'b0;
    cs_r <= 1'b1;
    s0 <= s0_00;
  end else begin
    case (s0)
      s0_00: begin
        addr_s <= ADDR_BW'('h0);
        odata_s <= DATA_BW'('h0);
        idata_s <= DATA_BW'('h0);
        idata_r <= DATA_BW'('h0);
        send_r <= 1'b0;
        addr_r <= 1'b0;
        done_r <= 1'b0;
        cs_r <= 1'b1;
        s0 <= s0_01;
      end

      s0_01: begin
        // select transaction
        if ( tsend | trecv ) begin
          // send addr
          addr_s <= addr; 
          if ( tsend ) begin
            odata_s <= odata;
            send_r <= 1'b1;
          end else begin
            idata_s <= DATA_BW'('h0);
            send_r <= 1'b0;
          end
          addr_r <= 1'b1;
          cs_r <= 1'b0;
          frame_ctr <= ADDR_FRAME_LEN;
          s0 <= s0_10;
        end else if ( send | recv ) begin
          // do data transaction
          if ( send ) begin
            odata_s <= odata;
            send_r <= 1'b1;
          end else begin
            idata_s <= DATA_BW'('h0);
            send_r <= 1'b0;
          end
          addr_r <= 1'b0;
          cs_r <= 1'b0;
          frame_ctr <= DATA_FRAME_LEN;
          s0 <= s0_11;
        end else begin
          s0 <= s0_01;
        end
      end

      s0_10: begin
        // send addr
        if ( frame_done | ( frame_ctr == ADDR_FRAME_LEN ) ) begin
          if ( ~|frame_ctr ) begin
            // addr send done
            addr_r <= 1'b0;
            frame_ctr <= DATA_FRAME_LEN;
            s0 <= s0_11;
          end else begin
            // send next frame
            write_frame <= addr_s[ADDR_BW - 1:ADDR_BW - SPI_FRAME_BW];
            addr_s <= addr_s << SPI_FRAME_BW;
            frame_ctr <= frame_ctr - 32'h1;
            frame_start <= 1'b1;
          end
        end else begin
          frame_start <= 1'b0;
          s0 <= s0_10;
        end
      end

      s0_11: begin
        // read and/or write data
        if ( frame_done | ( frame_ctr == DATA_FRAME_LEN ) ) begin
          if ( ~|frame_ctr ) begin
            // data done
            idata_r <= {idata_s[TRUE_DATA_BW - SPI_FRAME_BW - 1:0], read_frame_buffer};
            done_r <= 1'h1;
            s0 <= s0_00;
          end else begin
            // next frame
            if ( send_r ) begin
              write_frame <= odata_s[DATA_BW - 1:DATA_BW - SPI_FRAME_BW];
              odata_s <= odata_s << SPI_FRAME_BW;
            end
            idata_s <= {idata_s[TRUE_DATA_BW - SPI_FRAME_BW - 1:0], read_frame_buffer};
            frame_ctr <= frame_ctr - 32'h1;
            frame_start <= 1'h1;
            s0 <= s0_11;
          end
        end else begin
          frame_start <= 1'h0;
          s0 <= s0_11;
        end
      end

      default: begin
        s0 <= s0_00;
      end
    endcase
  end
end

// spi clock generator
reg [1:0] s1;
localparam [1:0] s1_00 = 2'h0;
localparam [1:0] s1_01 = 2'h1;
localparam [1:0] s1_10 = 2'h2;
always @(posedge clk or negedge rstn) begin
  if ( ~rstn ) begin
    sclk_div <= 32'h0;
    sclk_r <= 1'h0;
    frame_bit_ctr <= 32'h0;
    frame_done <= 1'h0;

    s1 <= s1_00;
  end else begin
    case (s1)
      s1_00: begin
        // reset 
        sclk_div <= 32'h0;
        sclk_r <= 1'h0;
        frame_bit_ctr <= 32'h0;
        frame_done <= 1'h0;
        s1 <= s1_01;
      end

      s1_01: begin
        // wait for fram start
        if ( frame_start ) begin
          // begin clk frame
          sclk_r <= 1'h1;
          sclk_div <= SPI_CLK_DIV + 32'h1;
          frame_bit_ctr <= SPI_FRAME_BW - 32'h1;
          s1 <= s1_10;
        end else begin
          s1 <= s1_01;
        end
      end

      s1_10: begin
        // run frame
        if ( ~|sclk_div ) begin
          // divider timer hits 0
          if ( sclk_r ) begin
            // current sclk state is high just go low
            sclk_div <= SPI_CLK_DIV + 32'h1;
            sclk_r <= 1'h0;
          end else begin
            if ( |frame_bit_ctr ) begin
              // still need more bits in frame
              sclk_r <= 1'h1;
              sclk_div <= SPI_CLK_DIV + 32'h1;
              frame_bit_ctr <= frame_bit_ctr - 32'h1;
            end else begin
              // end frame and signal done
              frame_done <= 1'h1;
              s1 <= s1_00;
            end
          end
        end else begin
          // decrement divider timer
          sclk_div <= sclk_div - 32'h1;
        end
      end

      default: begin
        s1 <= s1_00;
      end
    endcase
  end
end

always @(posedge clk) begin
  if ( ~rstn ) begin
    sclk_buf <= 1'h0;
  end else begin
    sclk_buf <= sclk_r;
  end
end

// write
reg [1:0] s2;
localparam [1:0] s2_00 = 2'h0;
localparam [1:0] s2_01 = 2'h1;
always @(posedge sclk or negedge rstn) begin
  if ( ~rstn ) begin
    mosi_r <= 1'h0;
    write_frame_buffer <= SPI_FRAME_BW'('h0);
    s2 <= s2_00;
  end else begin
    case ( s2 )
      s2_00: begin
        if ( addr_r | send_r ) begin
          // begin writing
          write_frame_buffer <= {write_frame[SPI_FRAME_BW - 2:0], 1'h0};
          mosi_r <= write_frame[SPI_FRAME_BW - 1];
          s2 <= s2_01;
        end else begin
          mosi_r <= 1'h1;
          s2 <= s2_00;
        end
      end

      s2_01: begin
        // shift out next bit
        write_frame_buffer <= {write_frame_buffer[SPI_FRAME_BW - 2:0], 1'h0};
        mosi_r <= write_frame_buffer[SPI_FRAME_BW - 1];
        if ( ~|frame_bit_ctr ) begin
          s2 <= s2_00;
        end else begin
          s2 <= s2_01;
        end
      end

      default: begin
        s2 <= s2_00;
      end
    endcase
  end 
end

// read
reg [1:0] s3;
localparam [1:0] s3_00 = 2'h0;
localparam [1:0] s3_01 = 2'h1;
always @(negedge sclk or negedge rstn) begin
  if ( ~rstn ) begin
    read_frame_buffer <= SPI_FRAME_BW'('h0);
    s3 <= s3_00;
  end else begin
    case ( s3 )
      s3_00: begin
        if ( ~addr_s ) begin
          // begin reading
          read_frame_buffer <= {read_frame_buffer[SPI_FRAME_BW-2:0], miso};
          s3 <= s3_01;
        end else begin
          s3 <= s3_00;
        end
      end

      s3_01: begin
        // shift in bit
        read_frame_buffer <= {read_frame_buffer[SPI_FRAME_BW-2:0], miso};
        if ( ~|frame_bit_ctr ) begin
          s3 <= s3_00;
        end else begin
          s3 <= s3_01;
        end
      end

      default: begin
        s3 <= s3_00;
      end
    endcase
  end
end

endmodule
