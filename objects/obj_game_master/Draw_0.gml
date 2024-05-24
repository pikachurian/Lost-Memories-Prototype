switch(state)
{
	case GS.preSetup:
		draw_set_font(fnt_pixel);
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_text(room_width / 2, room_height / 2, "CLICK TO START");
		draw_text(room_width * 0.5, room_height * 0.8, "By pikachurian");
		draw_set_halign(fa_left);
		
		//Title card.
		//draw_sprite(spr_title, 0, room_width * 0.5, room_height * 0.15);
		draw_sprite_ext(spr_title_ghost, 0, room_width * 0.5, room_height * 0.15, 2, 2, 0, c_white, 1);
		draw_sprite_ext(spr_title, 0, room_width * 0.5, room_height * 0.15, 2, 2, 0, c_white, titleAlpha);
		break;
}