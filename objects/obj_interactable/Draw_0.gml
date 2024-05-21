draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);

//Draw shadow.
var _shadowSprite = asset_get_index(sprite_get_name(sprite_index) + "_shadow");
show_debug_message(_shadowSprite);
if(_shadowSprite != noone) && (_shadowSprite != -1)
{
	draw_set_alpha(shadowAlpha);
	//show_debug_message("alpha " + string(shadowAlpha) + " | " + "isShadow " + string(isShadow));
	//draw_sprite(_shadowSprite, 0, x, y);
	draw_sprite_ext(_shadowSprite, image_index, x, y, image_xscale, image_yscale, 0, c_white, shadowAlpha);
	draw_set_alpha(1);
}