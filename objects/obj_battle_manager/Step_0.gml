switch(state)
{
	case BS.setup: 
		enemyInst = instance_create_depth(enemy.x, enemy.y, depth, obj_battle_enemy);
		enemyInst.momentSprite = enemy.momentSprite;
		enemyInst.momentShadowSprite = enemy.momentShadowSprite;
		ChangeState(BS.showSequence);
		break;
		
	case BS.showSequence:
		if(showTick >= showTime)
		{			
			ChangeState(BS.guess);
		}else showTick ++;
		break;
		
	case BS.guess:
		var _buttonClicked = false;
		with(makeGuessButton)
		{
			if(GetInput(INPUT.clicked))
				_buttonClicked = true;
		}
		
		if(_buttonClicked)
		{
			with(obj_symbol_guess)
				canEdit = false;
			ChangeState(BS.checkGuess);
		}
		break;
		
	case BS.checkGuess:
		if(showSymbolRateTick >= showSymbolRateTime)
		{
			showSymbolRateTick = 0;
			if(symbolsShown >= ds_list_size(sequenceList))
			{
				//Change state.
			}else
			{
				sequenceList[|symbolsShown].Show();
				symbolsShown += 1;
			}
		}else showSymbolRateTick += 1;
		break;
}