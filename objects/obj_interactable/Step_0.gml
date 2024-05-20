if(GetInput(INPUT.clicked)) && (obj_game_master.state == GS.main) && (lines != "noone")
{
	show_debug_message(sprite_get_name(sprite_index) + " Clicked");
	obj_game_master.interactableTarget = id;
	CreateTextbox(lines);
}

//Shadow.
if(isShadow)
	shadowAlpha = lerp(shadowAlpha, 1, 0.1);
else
	shadowAlpha = lerp(shadowAlpha, 0, 0.1);