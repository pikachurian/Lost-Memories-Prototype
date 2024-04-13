startX = x;
startY = y;
faceUp = true;
alpha = 0;
image_speed = 0;

//Can the player edit this guess.
canEdit = true;

//Basically the symbol's enum value or image_index.
symbolIndex = 0;

function SetSymbolIndex(_index)
{
	symbolIndex = _index;
	image_index = symbolIndex;
}

function Show()
{
	sprite_index = spr_symbols;
	faceUp = true;
	y -= 10;
	image_index = symbolIndex;
}

function Hide()
{
	sprite_index = spr_hidden;
	faceUp = false;
	y -= 10;
}