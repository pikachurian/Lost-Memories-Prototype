gameData = noone;//global.gameData;

//Load JSON.
if(file_exists("data.json"))
{
	var _buffer = buffer_load("data.json");
	var _string = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
	gameData = json_parse(_string);
}

//Game State.
enum GS 
{
	inTextbox,
	main,
	setup,
	paused,
	preSetup,
	inBattle
}

state = GS.preSetup;//GS.inBattle;
previousState = state;

currentRoomString = noone;

//The ID of the current instance being interacted with.
interactableTarget = noone;

has_apple = false;
has_key = false;
met_voice = false;
has_fish = false;

//Clock Building Room.
read_clock_building_intro = false;
can_enter_outside_door = false;
met_friends = false;
school_revealed = false;

heart_tree_is_shadow = true;
mom_car_is_shadow = true;
school_door_is_shadow = true;

//Tutorial variables.
showRememberExplanation = true;
showMoveOnExplanation = true;

//Memory
memoryMin = 0;
memoryMax = 1000;
memory = 100;

//Parallax.
backgroundXScale = 1.15;//1.25;
backgroundYScale = 1.15;//1.25;

//Passive memory check.
memoryCheckStruct = noone;

function SetMemory(_amount)
{
	memory = _amount
	memory = clamp(memory, memoryMin, memoryMax);
	obj_memory_visual.UpdateVisual(memory);
}

function GainMemory(_amount)
{
	SetMemory(memory + _amount);
}

//Checks memory against a value.  If successful, run the memory check lines.
function MemoryCheck(_struct)
{
	
	if(_struct == noone)
		return false;
		
	var _success = false;
	if(struct_exists(_struct, "memory_greater_than"))
	{
		if(memory > _struct.memory_greater_than)
			_success = true;
	}
	
	if(_success)
	{
		memoryCheckStruct = noone;
		CreateTextbox(_struct.lines);
	}
}



function ChangeRoom(_roomString)
{
	//Fade effect.
	obj_fade.alpha = 1;
	obj_fade.lerpTarget = 0;
	obj_fade.lerpAmount = 0.05;
	
	//Delete existing interactables.
	with(obj_interactable)
		instance_destroy();
		
	with(obj_textbox_closing)
		instance_destroy();
		
	show_debug_message(_roomString);
	var _roomStruct = struct_get(gameData, _roomString);
	
	ChangeState(GS.main);
	
	//Music.
	if(struct_exists(_roomStruct, "stop_music"))
	{
		if(_roomStruct.stop_music)
			audio_stop_all();
	}
	
	//Change background sprite.
	var _backgroundSprite = spr_test;
	var _backgroundString = string_delete(_roomString, 1, 2);
	_backgroundString = "spr" + _backgroundString;
	//show_debug_message(_roomStruct);
	if(struct_exists(_roomStruct, "background_sprite"))
	{
		_backgroundString = _roomStruct.background_sprite;
	}

	obj_background.sprite_index = asset_get_index(_backgroundString);
	
	//Background animation.
	obj_background.image_index = 0;
	obj_background.image_speed = 1;
	obj_background.playOnce = false;
	if(struct_exists(_roomStruct, "play_once"))
	{
		obj_background.playOnce = _roomStruct.play_once;
	}
	
	//Create interactables.
	if(is_struct(gameData)) && (struct_exists(_roomStruct, "interactables"))
	{
		var _interactableNames = struct_get_names(_roomStruct.interactables);
		for(var _i = 0; _i < array_length(_interactableNames); _i ++)
		{
			var _inst = instance_create_layer(0, 0, "Instances", obj_interactable);
			var _struct = struct_get(_roomStruct.interactables, _interactableNames[_i])
			switch(variable_struct_names_count(_struct))
			{
				case 3:
					//show_debug_message("AAAAAAAAAAAAAAAAAA");
					_inst.LoadStructData(_struct, _interactableNames[_i], _struct.layer,_struct.is_shadow);
					break;
				case 2:
					_inst.LoadStructData(_struct, _interactableNames[_i], _struct.layer);
					break;
				default:
					//show_debug_message("BBBBBBBBBBBBBBBBBBBBBBB");
					_inst.LoadStructData(_struct, _interactableNames[_i]);
					break;
			}
			//if(variable_struct_names_count(_struct) == 2)
			//	_inst.LoadStructData(_struct, _interactableNames[_i], _struct.isShadow);
			//else if ()
			//	_inst.LoadStructData(_struct, _interactableNames[_i]);
			//_inst.LoadStructData(struct_get(_roomStruct.interactables, _interactableNames[_i]), _interactableNames[_i]);
		}
	}
	
	
	obj_background.image_xscale = backgroundXScale;
	obj_background.image_yscale = backgroundYScale;
	
	with(obj_interactable)
	{
		image_xscale = other.backgroundXScale;
		image_yscale = other.backgroundYScale;
	}
	
	//Check the free_move struct variable to see if the player is paused.
	if(is_struct(gameData)) && (struct_exists(_roomStruct, "free_move"))
	{
		if(_roomStruct.free_move == false)
		{
			ChangeState(GS.paused);	
			obj_background.image_xscale = 1;
			obj_background.image_yscale = 1;
			obj_background.x = 0;
			obj_background.y = 0;
			with(obj_interactable)
			{
				image_xscale = 0;
				image_yscale = 0;
				x = 0;
				y = 0;
			}
		}
	}

	//Set memory check struct.
	memoryCheckStruct = noone;
	if(struct_exists(_roomStruct, "memory_check"))
		memoryCheckStruct = _roomStruct.memory_check;
	
	UpdateFromVariables();
	
	//Create a textbox with lines.
	if(is_struct(gameData)) && (struct_exists(_roomStruct, "lines"))
	{
		CreateTextbox(_roomStruct.lines);
	}else
	{
		//MemoryCheck(_roomStruct.memoryCheck);
	}
}

function Encounter(_encounter)
{
	ChangeRoom("rm_battle");
	ChangeState(GS.inBattle);
	var _battleInst = instance_create_depth(0, 0, depth, obj_battle_manager);
	_battleInst.LoadEnemyStruct(_encounter);
	_battleInst.Setup();
}

function ChangeState(_state)
{
	//Last state.
	switch(state)
	{
		case GS.inTextbox:
			//MemoryCheck(memoryCheckStruct);
			//MemoryCheck(memoryCheckStruct);
			break;
	}
	
	state = _state;
	
	//Next state.
	switch(_state)
	{
		case GS.main:
			MemoryCheck(memoryCheckStruct);
			break;
	}
}

//Set a variable to true or false.
function SetBool(_varString, _bool)
{
	variable_instance_set(id, _varString, _bool);
	show_debug_message(_varString + " set to " + string(variable_instance_get(id, _varString)));
}

//Set a variable to true.
function SetTrue(_varString)
{
	SetBool(_varString, true);
	
	switch(_varString)
	{
		//Delete this interactables when they are collected.
		case "has_apple":
		case "has_key":
		case "has_fish":
			if(instance_exists(interactableTarget))
				instance_destroy(interactableTarget);
			//audio_play_sound(sfx_item_get, 15, false);
			break;
	}
}

//Set a variable to false.
function SetFalse(_varString)
{
	SetBool(_varString, false);
}

//Checks the game variables and updates anything that needs it.
//Updates the game according to the game variables.
function UpdateFromVariables()
{
	//Clock building.
	if(met_friends) && (InstanceGet("obj_clock_building_friends") != noone)
		InstanceGet("obj_clock_building_friends").isShadow = false;
		
	if(school_revealed) && (InstanceGet("obj_clock_building") != noone)
		InstanceGet("obj_clock_building").isShadow = false;
		
	if(InstanceGet("obj_school_door") != noone)
		InstanceGet("obj_school_door").isShadow = school_door_is_shadow;
		
	if(InstanceGet("obj_mom_car") != noone)
		InstanceGet("obj_mom_car").isShadow = mom_car_is_shadow;
		
	if(InstanceGet("obj_heart_tree") != noone)
		InstanceGet("obj_heart_tree").isShadow = heart_tree_is_shadow;
}