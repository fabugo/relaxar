module control_rgb(button_red, button_green, button_blue, button_yellow, led_red, led_green, led_blue);
	input button_red;
	input button_green;
	input button_blue;
	input button_yellow;
	output led_red = 1, led_green = 1, led_blue;
	
	always @(button_yellow or button_blue or button_green or button_red) begin
		if (button_red == 1) begin
			led_red <= 0;
			led_green <= 1;
			led_blue <= 1;
		end else if (button_green == 1) begin
			led_green <= 0;
			led_red <= 1;
			led_blue <= 1;
		end else if (button_blue == 1) begin
			led_blue <= 0;
			led_red <= 1;
			led_green <= 1;
		end else begin
			led_red <= 0;
			led_green <= 0;
			led_blue <= 1;
		end
	end
endmodule


