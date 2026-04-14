module dma_controller (
	input  logic        clk,
	input  logic        rst,

	// LX.REPORT datapath interface
	input  logic        report_req,
	input  logic [31:0] report_ptr,
	output logic        report_ack,
	output logic        busy,

	// MMIO stub interface
	input  logic        mmio_req,
	input  logic        mmio_we,
	input  logic [31:0] mmio_addr,
	input  logic [31:0] mmio_wdata,
	output logic [31:0] mmio_rdata,
	output logic        mmio_ack
);

  logic [31:0] last_report_ptr;

  assign busy = 1'b0;

  always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
	  report_ack       <= 1'b0;
	  last_report_ptr  <= 32'h0;
	  mmio_ack         <= 1'b0;
	  mmio_rdata       <= 32'h0;
	end else begin
	  report_ack <= report_req;
	  if (report_req) begin
		last_report_ptr <= report_ptr;
	  end

	  mmio_ack <= mmio_req;
	  if (mmio_req) begin
		if (mmio_we) begin
		  // Stub accepts writes but does not execute real transfer yet.
		  last_report_ptr <= mmio_wdata;
		end else begin
		  unique case (mmio_addr[7:2])
			6'h00: mmio_rdata <= {31'h0, busy};
			6'h01: mmio_rdata <= last_report_ptr;
			default: mmio_rdata <= 32'hBEEF_DEAD;
		  endcase
		end
	  end
	end
  end

endmodule

