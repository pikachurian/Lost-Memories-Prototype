switch(state)
{
	case GS.preSetup:
		obj_memory_visual.image_alpha = 0;
		titleAlpha = sin((tick + 120) * 0.01);
		titleGhostAlpha = sin((tick + 60) * 0.01);
		if(GetInput(INPUT.mousePressed))
		{
			obj_memory_visual.image_alpha = 1;
			ChangeState(GS.setup);
		}
		break;
		
	case GS.setup:
		//Load first room.
		var _rooms = struct_get_names(gameData);
		ChangeRoom("rm_clock_building");//("rm_dennies");//("rm_return_to_friends");//("rm_prom");//("rm_clock_building");//ChangeRoom("rm_in_bed");
		//audio_play_sound(sng_background, 10, true);
		obj_memory_visual.memory = memory;
		break;
		
	case GS.main:
		//Use parallax.
		with(obj_background)
		{
			x = lerp(x, mouse_x * -0.1, 0.5);
			y = lerp(y, mouse_y * -0.1, 0.5);
		}
		
		with(obj_interactable)
		{
			x = lerp(x, mouse_x * -0.1, 0.5);
			y = lerp(y, mouse_y * -0.1, 0.5);
		}
		
		break;
		
	case GS.inTextbox:

		break;
}
//Restart.
if(keyboard_check_pressed(vk_alt))
	game_restart();
	
//Toggle fullscreen.
if(keyboard_check_pressed(vk_f4))
	window_set_fullscreen(!window_get_fullscreen());
	
tick ++;
	
//show_debug_message("state " + string(state));