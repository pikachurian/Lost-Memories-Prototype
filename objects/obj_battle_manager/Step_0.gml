switch(state)
{
	case BS.setup: 
		enemyInst = instance_create_depth(enemy.x, enemy.y, depth + 25, obj_battle_enemy);
		enemyInst.momentSprite = enemy.momentSprite;
		enemyInst.momentShadowSprite = enemy.momentShadowSprite;
		enemyInst.sprite_index = enemy.momentSprite;
		enemyInst.hpMax = enemy.hp;
		enemyInst.hp = enemy.hp;
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
		if(GetInput(INPUT.clicked, moveOnButton))
		{
			ChangeState(BS.moveOnConfirm);
		}
		break;
		
	case BS.chooseMemoryToSpend:
		//Activate tutorial.
		if(obj_game_master.showRememberExplanation)
		{
			toMainButton.depth = depth + 10;
			confirmCostButton.depth = depth + 10;
			addButton.depth = depth + 10;
			subtractButton.depth = depth + 10;
			if(GetInput(INPUT.mousePressed))
			{
				//End tutorial.
				obj_game_master.showRememberExplanation = false;
				toMainButton.depth = -100;
				confirmCostButton.depth = -100;
				addButton.depth = -100;
				subtractButton.depth = -100;
			}
			break;
		}
		
		if(GetInput(INPUT.clicked, toMainButton))
		{
			//Return to the action select menu.
			ChangeState(BS.chooseAction);
		}else if(GetInput(INPUT.clicked, addButton))
		{
			//Choose to spend more memory for more time.
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
		}else if(GetInput(INPUT.clicked, subtractButton))
		{
			//Choose to spend less memory for less time.
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
		}else if(GetInput(INPUT.clicked, confirmCostButton))
		{
			//Confirm cost and go to show sequence.
			obj_game_master.SetMemory(obj_game_master.memory - guesses * guessCost); 
			showTime = guesses * timePerGuess;
			ChangeState(BS.showSequence);
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
					ChangeState(BS.restoreMoment);
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
		
		case BS.restoreMoment:
			enemyInst.SetHP(enemyInst.hp - 1);
			audio_sound_pitch(musicInstance, enemyInst.restoredAmount);
			
			if(enemyInst.hp <= 0)
				ChangeState(BS.remember);
			else
				ChangeState(BS.chooseAction);
			break;
			
		case BS.moveOnConfirm:
			//Activate tutorial.
			if(obj_game_master.showMoveOnExplanation)
			{
				toMainButton.depth = depth + 10;
				confirmCostButton.depth = depth + 10;
				if(GetInput(INPUT.mousePressed))
				{
					//End tutorial.
					obj_game_master.showMoveOnExplanation = false;
					toMainButton.depth = -100;
					confirmCostButton.depth = -100;
				}
				break;
			}
		
			if(GetInput(INPUT.clicked, confirmCostButton))
			{
				ChangeState(BS.moveOn);
			}else if(GetInput(INPUT.clicked, toMainButton))
			{
				ChangeState(BS.chooseAction);
			}
			break;
			
		case BS.moveOn:
		case BS.remember:
			show_debug_message("Fade Alpha " + string(obj_fade.alpha));
			if(obj_fade.alpha >= closeFadeTarget)
			{
				show_debug_message("Among Us");
				//with(obj_fade)instance_destroy();
				ChangeState(BS.leaveBattle);
			}
			break;
			
		case BS.leaveBattle:
			//show_debug_message("Next room " + string(nextRoom));
			obj_game_master.ChangeRoom(nextRoom);
			instance_destroy(enemyInst);
			instance_destroy();
			break;
}