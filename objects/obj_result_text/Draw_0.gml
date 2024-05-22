draw_set_alpha(image_alpha);
//Draw success/failure sprite.
var _spriteX = room_width * 0.5;
var _spriteY = room_height * 0.7;
var _sprite = spr_success;
if(result == RT.failure)
	_sprite = spr_failure;
draw_sprite(_sprite, 0, _spriteX, _spriteY);

//Draw text.
draw_set_halign(fa_center);
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