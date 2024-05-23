enemy = {
	hp : 4,
	sequenceLength : 3,
	momentSprite : spr_moment_beta,
	momentShadowSprite : spr_moment_shadow_beta,
	x : room_width * 0.5,
	y : room_width * 0.15,
	moveOnRoom : "rm_test_room",
	rememberRoom : "rm_test_room"
}

sequence = array_create(enemy.sequenceLength);

//The room to go to if the player moves on.
moveOnRoom = "rm_test_room";

//The room to go to if the player remembers.
rememberRoom = "rm_test_room";

//The room to go to after the battle.
nextRoom = moveOnRoom;

//Battle State.
enum BS 
{
	setup,
	chooseAction,
	showSequence,
	guess,
	checkGuess,
	restoreMoment,
	chooseMemoryToSpend,
	rememberExplanation,
	moveOn,
	moveOnConfirm,
	moveOnExplanation,
	remember,
	leaveBattle
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
guessMin = 1;
guessMax = 10;
guesses = 1;

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

rememberButton = noone;
rememberButtonX = room_width * 0.1;
rememberButtonY = room_height * 0.3;
rememberButtonSprite = spr_remember;

moveOnButton = noone;
moveOnButtonX = room_width * 0.1;
moveOnButtonY = rememberButtonY + 32;
moveOnButtonSprite = spr_move_on;

addButton = noone;
addButtonX = room_width * 0.9;
addButtonY = room_height * 0.5;
addButtonSprite = spr_add;

subtractButton = noone;
subtractButtonX = room_width * 0.1;
subtractButtonY = room_height * 0.5;
subtractButtonSprite = spr_subtract;

confirmCostButton = noone;
confirmCostButtonX = room_width * 0.7;
confirmCostButtonY = room_height * 0.8;
confirmCostButtonSprite = spr_confirm;

//Returns to the action select menu.
toMainButton = noone;
toMainButtonX = room_width * 0.3;
toMainButtonY = room_height * 0.8;
toMainButtonSprite = spr_back;

//The alpha of a button when it is not selectable.
cannotSelectAlpha = 0.5;

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

//How long it takes for the encounter to fade out.
//battleCloseTime = 1 * game_get_speed(gamespeed_fps);
//battleCloseTick = 0;
closeFadeAmount = 0.03;//0.005;
closeFadeTarget = 0.99;//0.005;

function LoadEnemyStruct(_struct)
{
	enemy.hp = _struct.hp;
	enemy.sequenceLength = _struct.sequenceLength;
	enemy.momentSprite = asset_get_index(_struct.momentSprite);
	enemy.momentShadowSprite = asset_get_index(_struct.momentShadowSprite);
	enemy.x = _struct.x;
	enemy.y = _struct.y;
	enemy.moveOnRoom = _struct.moveOnRoom;//asset_get_index(_struct.moveOnRoom);
	enemy.rememberRoom = _struct.rememberRoom;//asset_get_index(_struct.rememberRoom);
	moveOnRoom = enemy.moveOnRoom;
	rememberRoom = enemy.rememberRoom;
}

function ChangeState(_state)
{
	//Actions for leaving a state.
	switch(state)
	{
		case BS.chooseAction:
			if(rememberButton != noone)
				instance_destroy(rememberButton);
				
			if(moveOnButton != noone)
				instance_destroy(moveOnButton);
			break;
			
		case BS.chooseMemoryToSpend:
			if(addButton != noone)
				instance_destroy(addButton);
				
			if(subtractButton != noone)
				instance_destroy(subtractButton);
				
			if(confirmCostButton != noone)
				instance_destroy(confirmCostButton);
				
			if(toMainButton != noone)
				instance_destroy(toMainButton);
			break;
		
		case BS.guess:
			if(makeGuessButton != noone)
				instance_destroy(makeGuessButton);
				
			makeGuessButton = noone;
			break;
			
		case BS.checkGuess:
			showSymbolRateTick = 0;
			symbolsShown = 0;
			correctGuesses = 0;
			
			//Clear sequence and guesses.
			ClearListOfInstances(sequenceList);
			ClearListOfInstances(guessList);
			break;
			
		case BS.moveOnConfirm:		
			if(confirmCostButton != noone)
				instance_destroy(confirmCostButton);
				
			if(toMainButton != noone)
				instance_destroy(toMainButton);
			break;
	}
	
	//Actions for entering a state.
	switch(_state)
	{
		case BS.chooseAction:
			if(obj_game_master.memory >= guessCost)
			{
				rememberButton = instance_create_depth(rememberButtonX, rememberButtonY, depth, obj_button);
				rememberButton.sprite_index = rememberButtonSprite;
			}
			
			moveOnButton = instance_create_depth(moveOnButtonX, moveOnButtonY, depth, obj_button);
			moveOnButton.sprite_index = moveOnButtonSprite;
			break;
			
		case BS.chooseMemoryToSpend:
			guesses = guessMin;
			addButton = instance_create_depth(addButtonX, addButtonY, depth - 100, obj_button);
			addButton.sprite_index = addButtonSprite;
			
			subtractButton = instance_create_depth(subtractButtonX, subtractButtonY, depth - 100, obj_button);
			subtractButton.sprite_index = subtractButtonSprite;
			subtractButton.image_alpha = cannotSelectAlpha;
			
			toMainButton = instance_create_depth(toMainButtonX, toMainButtonY, depth - 100, obj_button);
			toMainButton.sprite_index = toMainButtonSprite;
			
			confirmCostButton = instance_create_depth(confirmCostButtonX, confirmCostButtonY, depth - 100, obj_button);
			confirmCostButton.sprite_index = confirmCostButtonSprite;
			break;
		
		case BS.showSequence:
			/*for(var _i = 0; _i < array_length(enemy.sequenceLength); _i ++)
			{
				//
			}*/
			showTick = 0;
			
			CreateSequenceArray(enemy.sequenceLength);
			if(ds_list_empty(sequenceList))
				SpawnSequence();
					
			ShowSequence();
			break;
			
		case BS.guess:
			HideSequence();	
			SpawnGuesses();
			makeGuessButton = instance_create_depth(makeGuessButtonX, makeGuessButtonY, depth - 100, obj_button);
			makeGuessButton.sprite_index = spr_make_guess;
			break;
			
		case BS.remember:
			nextRoom = rememberRoom;
			//var _fade = instance_create_depth(0, 0, depth, obj_fade);
			obj_fade.lerpAmount = closeFadeAmount;
			obj_fade.lerpTarget = 1;
			obj_fade.alpha = 0;
			//obj_battle_enemy.depth = _fade.depth - 50;
			break;
			
		case BS.moveOnConfirm:
			toMainButton = instance_create_depth(toMainButtonX, toMainButtonY, depth - 100, obj_button);
			toMainButton.sprite_index = toMainButtonSprite;
			
			confirmCostButton = instance_create_depth(confirmCostButtonX, confirmCostButtonY, depth - 100, obj_button);
			confirmCostButton.sprite_index = confirmCostButtonSprite;	
			break;
		
		case BS.moveOn:
			nextRoom = moveOnRoom;
			//var _fade = instance_create_depth(0, 0, depth, obj_fade);
			obj_fade.lerpAmount = closeFadeAmount;
			obj_fade.lerpTarget = 1;
			obj_fade.alpha = 0;
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

//Spawn a series of symbols, according to the sequence array,
//and add them to sequenceList.
function SpawnSequence()
{
	if(array_length(sequence) <= 0)
		return false;
		
	ds_list_clear(sequenceList);
		
	for(var _i = 0; _i < array_length(sequence); _i ++)
	{
		var _inst = instance_create_depth(sequenceX + (_i * sequenceHOffset), sequenceY, depth - 100, obj_symbol);
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
		var _inst = instance_create_depth(guessX + (guessHOffset * _i), guessY, depth - 100, obj_symbol_guess);
		ds_list_add(guessList, _inst);
	}
}

function DeleteGuesses()
{
	for(var _i = 0; _i < ds_list_size(guessList); _i ++)
		ds_list_delete(guessList, _i);
		
	ds_list_clear(guessList);
}

//CreateSequenceArray(enemy.sequenceLength);