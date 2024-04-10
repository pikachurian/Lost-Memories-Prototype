startX = x;
startY = y;
faceUp = true;
alpha = 0;
image_speed = 0;

//Can the player edit this guess.
canEdit = true;

function Show()
{
	sprite_index = spr_symbols;
	faceUp = true;
	y -= 10;
}

function Hide()
{
	sprite_index = spr_hidden;
	faceUp = false;
	y -= 10;
}