x = lerp(x, startX, 0.1);
y = lerp(y, startY, 0.1);

if(canEdit)
{
	if(GetInput(INPUT.clicked))
	{
		y -= 10;
		image_index += 1;
		if(image_index >= image_number)
			image_index = 0;
	}
}