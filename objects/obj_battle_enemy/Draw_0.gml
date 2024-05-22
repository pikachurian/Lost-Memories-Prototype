draw_sprite(momentShadowSprite, image_index, x, y);

draw_sprite_part(
	momentSprite,
	image_index,
	0,
	0,
	sprite_get_width(momentSprite),
	sprite_get_height(momentSprite) * restoredAmount,
	x - sprite_get_width(momentSprite) / 2,
	y - sprite_get_height(momentSprite) / 2
);