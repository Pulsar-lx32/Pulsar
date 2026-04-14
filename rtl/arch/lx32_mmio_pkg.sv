package lx32_mmio_pkg;
  // MMIO Region Start
  localparam logic [31:0] MMIO_BASE        = 32'h4000_0000;
  localparam logic [31:0] MMIO_END         = 32'h4FFF_FFFF;
  // Peripheral Offsets
  localparam logic [31:0] SENSOR_CTRL_BASE = 32'h4000_0000;
  localparam logic [31:0] SENSOR_CTRL_END  = 32'h4000_00FF;
  localparam logic [31:0] DMA_CTRL_BASE    = 32'h4000_0100;
  localparam logic [31:0] DMA_CTRL_END     = 32'h4000_01FF;
  localparam logic [31:0] USB_HID_BASE     = 32'h4000_0200;
  localparam logic [31:0] USB_HID_END      = 32'h4000_02FF;
  localparam logic [31:0] OLED_SPI_BASE    = 32'h4000_0300;
  localparam logic [31:0] OLED_SPI_END     = 32'h4000_03FF;
  localparam logic [31:0] TIMER_BASE       = 32'h4000_0400;
  localparam logic [31:0] TIMER_END        = 32'h4000_04FF;
  // Sensor Data Buffer (Double Buffered)
  localparam logic [31:0] SENSOR_DATA_BASE = 32'h5000_0000;
  localparam logic [31:0] SENSOR_DATA_END  = 32'h5000_FFFF;
endpackage
