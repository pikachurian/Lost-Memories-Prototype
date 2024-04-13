enemy = {
	hp : 4,
	sequenceLength : 3,
	momentSprite : spr_moment_beta,
	momentShadowSprite : spr_moment_shadow_beta,
	x : room_width * 0.5,
	y : room_width * 0.15
}

sequence = array_create(enemy.sequenceLength);

//Battle State.
enum BS 
{
	setup,
	chooseAction,
	showSequence,
	guess,
	checkGuess,
	restoreMoment
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

showTime = 2 * timePerGuess;
showTick = 0;

//Sequence stuff.
sequenceX = room_width * 0.5;//room_width / 2;
sequenceY = room_height * 0.6;//room_height / 2;
sequenceHOffset = 16;
sequenceList = ds_list_create();

//Guess sequence.
guessX = sequenceX;
guessY = sequenceY + 32;
guessHOffset = 16;
guessList = ds_list_create();

//Enemy stats.
enemyInst = noone;
hp = enemy.hp;

//Buttons.
makeGuessButton = noone;
makeGuessButtonX = room_width * 0.3;//room_width / 2;//room_width / 2;
makeGuessButtonY = room_height * 0.6;//room_height / 2;//room_height -120;

//Show sequence and check guess state variables.
showSymbolRateTime = 0.5 * game_get_speed(gamespeed_fps);
showSymbolRateTick = 0;
symbolsShown = 0;
correctGuesses = 0;

resultTextX = room_width * 0.5;
resultTextY = room_height * 0.5;

//The percent, 0 to 1 so not technically percent, of guesses the player needs 
//to get correct to win a turn.
guessPercentToWin = 0.6;


function ChangeState(_state)
{
	//Actions for leaving a state.
	switch(state)
	{
		case BS.guess:
			if(makeGuessButton != noone)
				instance_destroy(makeGuessButton);
				
			makeGuessButton = noone;
			break;
			
		case BS.checkGuess:
			showSymbolRateTick = 0;
			symbolsShown = 0;
			correctGuesses = 0;
			break;
	}
	
	//Actions for entering a state.
	switch(_state)
	{
		case BS.showSequence:
			/*for(var _i = 0; _i < array_length(enemy.sequenceLength); _i ++)
			{
				//
			}*/
			showTick = 0;
			if(ds_list_empty(sequenceList))
				SpawnSequence();
					
			ShowSequence();
			break;
			
		case BS.guess:
			HideSequence();	
			SpawnGuesses();
			makeGuessButton = instance_create_depth(makeGuessButtonX, makeGuessButtonY, depth, obj_button);
			makeGuessButton.sprite_index = spr_make_guess;
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
		//_inst.image_index = sequence[_i];
		_inst.SetSymbolIndex(sequence[_i]);
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

function SpawnGuesses()
{
	ds_list_clear(guessList);
	
	for(var _i = 0; _i < array_length(sequence); _i ++)
	{
		var _inst = instance_create_depth(guessX + (guessHOffset * _i), guessY, depth, obj_symbol_guess);
		ds_list_add(guessList, _inst);
	}
}

function DeleteGuesses()
{
	for(var _i = 0; _i < ds_list_size(guessList); _i ++)
		ds_list_delete(guessList, _i);
		
	ds_list_clear(guessList);
}

CreateSequenceArray(enemy.sequenceLength);