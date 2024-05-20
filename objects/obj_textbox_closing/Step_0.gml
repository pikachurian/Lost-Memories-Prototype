alpha = lerp(alpha, 0, 0.1);
//Delete this object and return control to the player.
if(alpha <= 0.01)
{
	obj_game_master.ChangeState(obj_game_master.previousState);
	if(obj_game_master.previousState == GS.main)
		obj_game_master.MemoryCheck(obj_game_master.memoryCheckStruct);
	instance_destroy();
}