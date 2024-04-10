enemy = {
	hp : 4,
	sequenceLength : 3
}

sequence = array_create(enemy.sequenceLength);

//Battle State.
enum BS 
{
	setup,
	chooseAction,
	showSequence,
	guess,
	showGuess
}

//Symbol
enum SYMBOL
{
	triangle,
	circle,
	square,
	enumLength
}

state = BS.setup;

//Memory stuff.
guessCost = 5;
timePerGuess = 1 * game_get_speed(gamespeed_fps);
guessMax = 10;

guessTime = 0;
guessTick = 0;

//Sequence stuff.
sequenceX = room_width / 2;
sequenceY = room_height / 2;
sequenceHOffset = 16;
sequenceList = ds_list_create();

//Enemy stats.
hp = enemy.hp;

function ChangeState(_state)
{
	switch(_state)
	{
		case BS.showSequence:
			/*for(var _i = 0; _i < array_length(enemy.sequenceLength); _i ++)
			{
				//
			}*/
			if(ds_list_empty(sequenceList))
				SpawnSequence();
					
			ShowSequence();
			show_debug_message("A");
			break;
	}
	
	state = _state;
}

//Set sequence to an array containing symbols represented by enums.
function CreateSequenceArray(_length)
{
	sequence = array_create(_length);

	for(var _i = 0; _i < array_length(sequence); _i ++)
	{
		sequence[_i] = irandom(SYMBOL.enumLength - 1);
	}
}

//Spawn a series of symbols and add them to sequenceList.
function SpawnSequence()
{
	if(array_length(sequence) <= 0)
		return false;
		
	ds_list_clear(sequenceList);
		
	for(var _i = 0; _i < array_length(sequence); _i ++)
	{
		var _inst = instance_create_depth(sequenceX + (_i * sequenceHOffset), sequenceY, depth, obj_symbol);
		_inst.image_index = sequence[_i];
		ds_list_add(sequenceList, _inst);
	}
}

function DeleteSequence()
{
	for(var _i = 0; _i < ds_list_size(sequenceList); _i ++)
		ds_list_delete(sequenceList, _i);
		
	ds_list_clear(sequenceList);
}

function ShowSequence()
{
	if(ds_list_empty(sequenceList))
		return false;
		
	for(var _i = 0; _i < ds_list_size(sequenceList); _i ++)
	{
		sequenceList[|_i].Show();
	}
}

function HideSequence()
{
	if(ds_list_empty(sequenceList))
		return false;
		
	for(var _i = 0; _i < ds_list_size(sequenceList); _i ++)
	{
		sequenceList[|_i].Hide();
	}
}

CreateSequenceArray(enemy.sequenceLength);