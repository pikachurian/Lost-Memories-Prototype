draw_set_font(fnt_pixel);

switch(state)
{
	case BS.chooseMemoryToSpend:
		draw_set_halign(fa_center);
		draw_set_color(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(room_width * 0.2, 0, room_width * 0.8, room_height * 0.7, false);
		draw_set_alpha(1);
		var _secondsText = "Seconds to memorize " + string((timePerGuess * guesses) / game_get_speed(gamespeed_fps));
		var _memoryCostText =  "Memory cost " + string(guessCost * guesses);
		draw_text(room_width * 0.5 + 1, room_height * 0.5 + 1, _secondsText + "\n" + _memoryCostText);
		draw_set_color(c_white);
		draw_text(room_width * 0.5, room_height * 0.5, _secondsText + "\n" + _memoryCostText);
		break;
}

draw_set_alpha(1);
draw_set_halign(fa_left);