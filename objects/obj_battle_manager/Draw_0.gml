draw_set_font(fnt_pixel);

switch(state)
{
	case BS.chooseMemoryToSpend:
		draw_set_halign(fa_center);
		draw_set_color(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(0, 0, room_width, room_height, false);
		draw_set_alpha(1);
		var _secondsText = "Seconds to memorize " + string((timePerGuess * guesses) / game_get_speed(gamespeed_fps));
		var _memoryCostText =  "Memory cost " + string(guessCost * guesses);
		draw_text(room_width * 0.5 + 1, room_height * 0.5 + 1, _secondsText + "\n" + _memoryCostText);
		draw_set_color(c_white);
		draw_text(room_width * 0.5, room_height * 0.5, _secondsText + "\n" + _memoryCostText);
		
		//Explanation.
		if(obj_game_master.showRememberExplanation)
		{
			draw_set_alpha(0.5);
			draw_set_color(c_black);
			draw_rectangle(0, 0, room_width, room_height, false);
			draw_set_alpha(1);
			//var _text = "You've choose to remember a moment from \nyour pastRemembering costs memory and \ninvolves playing a memory game.  \nSpending more memory gives you more time \nto memorize.  However, spent memory is \ngone forever.";
			var _text = "You've chosen to remember a moment from your past.  Remembering costs memory and involves playing a memory game.  Spending more memory gives you more time to memorize.  However, spent memory is gone forever.";
			//draw_text(room_width * 0.5 + 1, room_height * 0.1 + 1, _text);
			draw_text_ext(room_width * 0.5 + 1, room_height * 0.1 + 1, _text, 8, room_width * 0.8);
			draw_set_color(c_white);
			//draw_text(room_width * 0.5, room_height * 0.1, _text);
			draw_text_ext(room_width * 0.5, room_height * 0.1, _text, 8, room_width * 0.8);
		}
		break;
		
	case BS.moveOnConfirm:		
		draw_set_halign(fa_center);
		draw_set_color(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(0, 0, room_width, room_height, false);
		draw_set_alpha(1);
		var _text = "Once you move on, you cannot return \nto the past.  Are you sure?";
		draw_text(room_width * 0.5 + 1, room_height * 0.5 + 1, _text);
		draw_set_color(c_white);
		draw_text(room_width * 0.5, room_height * 0.5, _text);
		break;
		
	case BS.checkGuess:
	case BS.showSequence:
	case BS.guess:
		draw_set_color(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(0, 0, room_width, room_height, false);
		draw_set_alpha(1);
		break;
}

draw_set_alpha(1);
draw_set_halign(fa_left);