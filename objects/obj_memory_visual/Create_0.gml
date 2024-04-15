memory = 100;
startX = x;
startY = y;
scale = 1;

finishedSetup = false;

//Update this visual and trigger any effects for losing/gaining memory.
function UpdateVisual(_memoryAmount)
{
	scale = 1.25;
	memory = _memoryAmount;
}