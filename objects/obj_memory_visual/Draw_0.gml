draw_set_font(fnt_pixel);
draw_set_color(c_white);
draw_set_halign(fa_right);

draw_text_transformed(
	x, 
	y, 
	"MEMORY: " + string(memory),
	scale,
	scale,
	0
);

draw_set_halign(fa_left);