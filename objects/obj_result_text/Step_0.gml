image_alpha = lerp(image_alpha, 0, 0.05);
scale = lerp(scale, 1, 0.05);

if(image_alpha <= 0.01)
	instance_destroy();