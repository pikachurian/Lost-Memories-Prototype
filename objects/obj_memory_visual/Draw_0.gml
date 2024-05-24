draw_set_font(fnt_pixel);
draw_set_color(c_black);
draw_set_halign(fa_center);//draw_set_halign(fa_right);
draw_text_transformed(
	room_width * 0.5 + 1,//x + 1, 
	room_height * 0.025 + 1,//y + 1, 
	"MEMORY: " + string(memory),
	scale,
	scale,
	0
);

draw_set_color(c_white);
draw_text_transformed(
	room_width * 0.5,//x, 
	room_height * 0.025,//y, 
	"MEMORY: " + string(memory),
	scale,
	scale,
	0
);

draw_set_halign(fa_left);