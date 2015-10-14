module control_rgb(button_red, button_green, rst, button_blue, button_yellow, led_red, led_green, led_blue);
	input button_red, button_green, button_blue, button_yellow;
	input rst;
	logic [2:0] led;
	output led_red, led_green, led_blue;

	always @(button_yellow or button_blue or button_green or button_red or rst) begin
		if (rst) led = 3'b000;
		else begin
			if (button_red) led = 3'b100;
			else if (button_green) led = 3'b010;
			else if (button_blue) led = 3'b001;
			else if (button_yellow) led = 3'b110;
			else led = 3'b000;
		end
		led_green = led[2];
		led_red = led[1];
		led_blue = led[0];
	end
endmodule
