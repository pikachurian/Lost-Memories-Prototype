switch(state)
{
	case BS.setup: 
		enemyInst = instance_create_depth(enemy.x, enemy.y, depth, obj_battle_enemy);
		enemyInst.momentSprite = enemy.momentSprite;
		enemyInst.momentShadowSprite = enemy.momentShadowSprite;
		//ChangeState(BS.showSequence);
		ChangeState(BS.chooseAction);
		break;
		
	case BS.chooseAction:
	
		//Choose to remember.
		if(GetInput(INPUT.clicked, rememberButton))
		{
			ChangeState(BS.chooseMemoryToSpend);
		}
		
		//Choose to move on.
		if(GetInput(INPUT.clicked, rememberButton))
		{
			ChangeState(BS.moveOn);
		}
		break;
		
	case BS.chooseMemoryToSpend:
		//Choose to spend more memory for more time.
		if(GetInput(INPUT.clicked, addButton))
		{
			if(guesses < guessMax) && (obj_game_master.memory >= (guesses + 1) * guessCost)
			{
				guesses += 1;
				addButton.scale = 0.5;
				
				subtractButton.image_alpha = 1;
				addButton.image_alpha = 1;
			}else
			{
				addButton.image_alpha = cannotSelectAlpha;
			}
		}
		
		//Choose to spend less memory for less time.
		if(GetInput(INPUT.clicked, subtractButton))
		{
			if(guesses > guessMin)
			{
				guesses -= 1;
				subtractButton.scale = 0.5;
				
				addButton.image_alpha = 1;
				subtractButton.image_alpha = 1;
			}else
			{
				subtractButton.image_alpha = cannotSelectAlpha;
			}
		}
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
				var _resultTextInst = instance_create_depth(resultTextX, resultTextY, depth - 10, obj_result_text);
				//Change state.
				if(correctGuesses / ds_list_size(sequenceList) >= guessPercentToWin)
				{
					//Win turn.
					ChangeState(BS.chooseAction);
					_resultTextInst.SetText(RT.success);
				}else
				{
					//Lose turn.
					ChangeState(BS.chooseAction);
					_resultTextInst.SetText(RT.failure);
				}
			}else
			{
				sequenceList[|symbolsShown].Show();
				
				//Check if player's guess is corret for this symbol.
				if(guessList[|symbolsShown].symbolIndex == sequenceList[|symbolsShown].symbolIndex)
				{
					correctGuesses += 1;
				}
				
				symbolsShown += 1;
			}
		}else showSymbolRateTick += 1;
		break;
}