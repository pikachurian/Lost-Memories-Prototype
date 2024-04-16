momentSprite = spr_moment_beta;
momentShadowSprite = spr_moment_shadow_beta;

//Goes from 0 to 1.
restoredAmount = 0;//0.5;

hpMax = 4;
hp = hpMax;

function SetHP(_amount)
{
	hp = _amount;
	hp = clamp(hp, 0, hpMax);
	
	restoredAmount = (hpMax - hp) / hpMax;
}