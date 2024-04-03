enemy = {
	hp : 4,
	sequenceLength : 3
}

sequence = array_create(enemy.sequenceLength);

//Battle State.
enum BS 
{
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

state = BS.showSequence

//Memory stuff.
guessCost = 5;
timePerGuess = 1 * game_get_speed(gamespeed_fps);
guessMax = 10;

guessTime = 0;
guessTick = 0;

//Enemy stats.
hp = enemy.hp;

function ChangeState(_state)
{
	state = _state;
}

function CreateSequence(_length)
{
	sequence = array_create(_length);

	for(var _i = 0; _i < array_length(sequence); _i ++)
	{
		sequence[_i] = irandom(SYMBOL.enumLength - 1);
	}
}