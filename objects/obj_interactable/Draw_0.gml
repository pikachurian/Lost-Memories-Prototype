draw_self();

//Draw shadow.
var _shadowSprite = asset_get_index(sprite_get_name(sprite_index) + "_shadow");
draw_set_alpha(shadowAlpha);
draw_sprite(_shadowSprite, 0, x, y);
draw_set_alpha(1);