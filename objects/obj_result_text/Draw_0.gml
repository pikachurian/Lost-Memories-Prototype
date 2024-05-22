draw_set_halign(fa_center);
draw_set_alpha(image_alpha);
draw_set_font(fnt_pixel);
draw_set_color(textColor);

draw_text_transformed(
	x + 2,
	y + 2,
	resultText,
	scale,
	scale,
	0
);

draw_set_color(c_white);

draw_text_transformed(
	x,
	y,
	resultText,
	scale,
	scale,
	0
);

draw_set_halign(fa_left);
draw_set_alpha(1);