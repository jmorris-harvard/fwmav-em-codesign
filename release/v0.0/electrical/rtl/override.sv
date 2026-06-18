module override (
  input wire clk,
  input wire rstn,

  // Control Signals
  input wire startTrigger,
  input wire write,
  input wire [7:0] data,
  input wire loadTrigger,

  // Output Signals
  output wire cs,
  output wire mosi,
  output wire sck,

  input wire compare,
  output wire pdrive,
  output wire ndrive,
  output wire drive_en
);

// State Machines
reg drive_en_reg;
assign drive_en = ~drive_en_reg; // Attached to inverter
reg pdrive_reg;
assign pdrive = pdrive_reg;
reg ndrive_reg;
assign ndrive = ~ndrive_reg; // Attached to inverter

`define DAC_PRESCALE 32'h186 // Goes through all 128 samples within 1/100 s
`define SPI_PRESCALE 8'h1

`define DAC_IDLE 2'b00
`define DAC_SENDING 2'b01
`define DAC_END 2'b10

localparam BUF_SIZE = 128;

reg [1:0] dac_state;

reg dac_running;
reg dac_send;
reg [7:0] dac_write_addr;
reg [7:0] dac_read_addr;
reg [31:0] dac_counter;
reg [7:0] dac_buffer [0:BUF_SIZE];
reg [7:0] dac_shift [0:BUF_SIZE];

reg ascending;
reg descending;

reg spi_sending;
wire [15:0] spi_out;
reg [7:0] spi_out_counter;
assign spi_out = {8'b00100011, dac_buffer[dac_read_addr]};

wire mosi_wire;
assign mosi_wire = spi_out[spi_out_counter[3:0]];
assign mosi = spi_sending ? mosi_wire : 1'b1;
reg cs_reg;
assign cs = cs_reg;
reg [7:0] spi_clk_counter;
reg spi_clk_reg;
assign sck = spi_sending ? spi_clk_reg : 1'b1;
reg spi_done;

`define DRIVE_WAIT_TIME 8'd10
`define DRIVE_DELAY_TIME 8'd5
`define DRIVE_WAIT 1'b0
`define DRIVE_DELAY 1'b1

reg drive_state;
reg [15:0] drive_counter;

// CONTROLLER
`define PROCESS_IDLE 1'b0
`define PROCESS_RUNNING 1'b1
reg process_state;
always @(posedge clk) begin
  if (~rstn) begin
    process_state <= 1'b0;
    drive_en_reg <= 1'b0;
    dac_running <= 1'b0;
  end else begin
    if (process_state == `PROCESS_IDLE) begin
      if (startTrigger) begin
        dac_running <= 1'b1;
        drive_en_reg <= 1'b1;
        process_state <= `PROCESS_RUNNING;
      end else begin end
    end else if (process_state == `PROCESS_RUNNING) begin
      if (startTrigger) begin
        dac_running <= 1'b0;
        drive_en_reg <= 1'b0;
        process_state <= `PROCESS_IDLE;
      end else begin end
    end
  end
end

// DAC Buffer Writer 
always @(posedge clk) begin
  if (~rstn) begin
    dac_write_addr <= 8'h0;
  end else begin
    if (write) begin
      dac_shift[dac_write_addr] <= data;
      dac_write_addr <= dac_write_addr + 8'h1;
    end else begin end
    if (loadTrigger) begin
      dac_write_addr <= 8'h0;
    end
  end
end

// DAC Buffer Shift
reg loadBuffer;
reg loadedBuffer;
always @(posedge clk) begin
  if (~rstn) begin
    loadBuffer <= 1'b0; 
  end else begin
    if (loadTrigger) begin
      loadBuffer <= 1'b1;
    end else if (loadedBuffer) begin 
      loadBuffer <= 1'b0;
    end
  end
end

// DAC Output Update
integer i;
always @(posedge clk) begin
  if (~rstn) begin
    dac_counter <= 32'h0;
    dac_send <= 1'b0;
    dac_read_addr <= BUF_SIZE - 1;
    loadedBuffer <= 1'b0;
  end else begin
    dac_send <= 1'b0;
    loadedBuffer <= 1'b0;
    if (dac_running) begin
      dac_counter <= dac_counter - 1;
      if (dac_counter == 32'h0) begin
        dac_read_addr <= dac_read_addr + 1;
        dac_counter <= `DAC_PRESCALE;
        dac_send <= 1'b1;

        ascending <= 1'b0;
        descending <= 1'b0;
        if (dac_buffer[dac_read_addr] < dac_buffer[dac_read_addr + 8'h1]) begin
          ascending <= 1'b1;
        end
        if (dac_buffer[dac_read_addr] > dac_buffer[dac_read_addr + 8'h1]) begin
          descending <= 1'b1;
        end

        if (dac_read_addr == BUF_SIZE - 1) begin
          if (loadBuffer & ~loadedBuffer) begin
            for (i = 0; i < BUF_SIZE; i = i + 1) begin
              dac_buffer[i] <= dac_shift[i];
            end
            loadedBuffer <= 1'b1;
          end else begin end
          dac_read_addr <= 8'h0;
        end

      end
    end
  end
end

// SPI DAC Output Start
always @(posedge clk) begin
  if (~rstn) begin
    dac_state <= `DAC_IDLE;
    spi_sending <= 1'b0;
    cs_reg <= 1'b1;
  end else begin
    if (dac_state == `DAC_IDLE) begin
      if (dac_send) begin
        dac_state <= `DAC_SENDING;
      end
    end else if (dac_state == `DAC_SENDING) begin 
      cs_reg <= 1'b0;
      if (spi_clk_reg == 1'b1) begin
        spi_sending <= 1'b1;
      end
      if (spi_done) begin
        dac_state <= `DAC_END;
      end
    end else if (dac_state == `DAC_END) begin
      if (spi_clk_reg & spi_clk_counter == 8'h1) begin
        spi_sending <= 1'b0;
        cs_reg <= 1'b1;
        dac_state <= `DAC_IDLE;
      end
    end else begin
      dac_state <= `DAC_IDLE;
    end
  end
end

// SPI Data Sender
always @(negedge spi_clk_reg) begin
  if (~rstn) begin
    spi_done <= 1'b0;
    spi_out_counter <= 8'h10;
  end else begin
    spi_done <= 1'b0;
    spi_out_counter <= 8'h10;
    if (spi_sending) begin
      spi_out_counter <= spi_out_counter - 4'h1;
      if (spi_out_counter == 4'h1) begin
        spi_done <= 1'b1;
      end 
    end
  end
end

// SPI DAC SCK Generator
always @(posedge clk) begin
  if (~rstn) begin
    spi_clk_reg <= 1'b1;
    spi_clk_counter <= 8'h0;
  end else begin
    if (dac_running) begin
      if (spi_clk_counter == 8'b0) begin
        spi_clk_reg <= ~spi_clk_reg;
        spi_clk_counter <= `SPI_PRESCALE;
      end else begin
        spi_clk_counter <= spi_clk_counter - 1;
      end
    end
  end 
end 

// Driver feedback logic
always @(posedge clk) begin
  if (~rstn) begin
    drive_state <= 1'b0;
    drive_counter <= 16'h0;

    pdrive_reg <= 1'b0; // Attached to inverters
    ndrive_reg <= 1'b0;
  end else begin
    if (drive_en_reg) begin
      drive_counter <= drive_counter - 1;
      if (drive_state == `DRIVE_DELAY) begin
        pdrive_reg <= 1'b0;
        ndrive_reg <= 1'b0;

        if (drive_counter == 16'h0) begin
          if (compare & descending) begin
            pdrive_reg <= 1'b0;
            ndrive_reg <= 1'b1;
          end else if (~compare & ascending) begin
            pdrive_reg <= 1'b1;
            ndrive_reg <= 1'b0;
          end
          drive_counter <= `DRIVE_WAIT_TIME; 
          drive_state <= `DRIVE_WAIT;
        end
      end else if (drive_state == `DRIVE_WAIT) begin
        if (drive_counter == 16'h0) begin
          drive_counter <= `DRIVE_DELAY_TIME;
          drive_state <= `DRIVE_DELAY;
        end
      end else begin
        drive_state <= `DRIVE_DELAY;
      end
    end else begin
      pdrive_reg <= 1'b0;
      ndrive_reg <= 1'b0;
    end
  end
end

endmodule
