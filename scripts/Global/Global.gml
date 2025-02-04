// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Global(){

}

randomize();

function CreateTextbox(_lines)
{
	obj_game_master.previousState = obj_game_master.state;
	obj_game_master.ChangeState(GS.inTextbox);
	var _textbox = instance_create_layer(0, 120, "Textbox", obj_textbox);//instance_create_layer(0, 96, "Textbox", obj_textbox_opening);//instance_create_layer(0, 96, "Textbox", obj_textbox);
	_textbox.lines = _lines;
}

//Clears a ds list and destroys all instances in that list.
function ClearListOfInstances(_list)
{
	var _listSize = ds_list_size(_list);
	for(var _i = 0; _i < _listSize; _i ++)
	{
		if(instance_exists(_list[|0]))
			instance_destroy(_list[|0]);
			
		ds_list_delete(_list, 0);
	}
}
	
//Returns the first instance of the object whose name matches the name string.
function InstanceGet(_nameString)
{
	//var _spriteString = string_delete(currentLines[lineIndex].shadow_off, 1, 3);
	var _spriteString = string_delete(_nameString, 1, 3);
	_spriteString = "spr" + _spriteString;
	with(obj_interactable)
	{
		if(sprite_index == asset_get_index(_spriteString))
			return id;
	}
	
	return noone;
}

	
/*This code was for testing the game before I added JSON loading.
global.gameData = {
    rm_in_bed : {
        dev_notes : "Game starts in looking at a bed",
        free_move : false,
        lines : [
            { text : "Huh?" },
            {
                choices : [
                    {
                        text : "Where am I?",
                        lines : [
                            { text : "A bedroom, it looks like." }
                        ]
                    },
                    {
                        text : "Who am I?",
                        lines : [
                            { text : "I have absolutely no idea." }
                        ]
                    }
                ]
            },
            {
                text : "I need to get out of here.",
                goto : "rm_bedroom"
            }

        ]
    },
    rm_bedroom : {
        dev_notes : "Looking at a bedroom, containing all the interactables",
        free_move : true,
        interactables : {
            obj_car : {
                lines : [
                    { text : "It's a car" }
                ]
            },
            obj_apple : {
                lines : [
                    {
                        text : "It's an apple. I'm not hungry now but I'll save it for later.",
                        set_true : "has_apple",
                        dev_notes : "This should remove the apple from the room and reveal a key underneath."
                    },
                    {
                        text : "Ah, there's a key underneath"
                    }
                ]
            },
            obj_key : {
                lines : [
                    {
                        if_true : "has_apple",
                        lines : [
                            {
                                text : "Interesting... a key",
                                set_true : "has_key"
                            }
                        ]

                    }
                ]
            },
            obj_door : {
                lines : [
                    {
                        if_true : "has_key",
                        lines : [
                            {
                                text : "Let me open this door",
                                goto : "rm_kitchen"
                            }
                        ]

                    },
                    {
                        text : "Hmm... this door is locked"
                    }
                ]
            }
        }
    },
    rm_kitchen : {
        dev_notes : "Its a pretty normal kitchen, with a fridge in the center.",
        free_move : true,
        lines : [
            { text : "Interesting, I appear to be in a kitchen, but there still isn't a way out." }
        ],
        interactables : {
            obj_door : {
                lines : [
                    {
                        if_true : "met_voice",
                        lines : [
                            { text : "There isn't any food back there" }
                        ]
                    },
                    {
                        if_false : "met_voice",
                        text : "There's no need to go back there."
                    }
                ]
            },
            obj_wooden_fish: {
                lines : [
                    { text : "Hmm... a wooden fish. I wonder who carved it?" }
                ]
            },
            obj_plastic_fish : {
                dev_notes : "This fish looks like a Swedish Fish",
                lines : [
                    { text : "This fish is plastic, or at least that's what it wants you to think" },
                    {
                        if_true : "met_voice",
                        lines : [
                            {
                                text : "Do you think the voice could tell its not edible?"
                            }
                        ]
                    }
                ]
            },
            obj_singing_fish : {
                lines : [
                    {
                        speaker : "Singing Fish",
                        text : "I drove my truck, into the lake, and then I turned, into a fish."
                    },
                    {
                        text : "I can't tell if it's mechanical or magical, but either way its not edible."
                    }
                ]
            },
            obj_fish : {
                lines : [
                    { text : "A fish, a fishy fish." },
                    {
                        if_true : "met_voice",
                        lines : [
                            {
                                text : "I will take this fish in case the voice in the fridge likes fish",
                                set_true : "has_fish"
                            }
                        ]
                    }
                ]
            },
            obj_fridge : {
                lines : [
                    {
                        if_false : "met_voice",
                        lines : [
                            { text : "A fridge? I wonder if it has any food in it" },
                            { text : "*Rumble*" },
                            {
                                speaker : "Voice in Fridge",
                                text:  "Who wants to enter my fridge?"
                            },
                            {
                                choices : [
                                    { text : "I am, I guess?" },
                                    { text :  "Nobody" }
                                ]
                            },
                            {
                                speaker : "Voice in Fridge",
                                text : "If you want to enter the fridge, you must give me food",
                                set_true : "met_voice"
                            }
                        ]
                    },
                    {
                        if_true : "met_voice",
                        lines : [
                            {
                                speaker : "Voice in Fridge",
                                text : "Do you have any food for me?"
                            },
                            {
                                choices : [
                                    {
                                        if_true : "has_fish",
                                        text : "I have a smelly fish.",
                                        lines : [
                                            {
                                                speaker : "Voice in Fridge",
                                                text : "Ah, lovely. Please come in.",
                                                goto : "rm_voice_happy"
                                            }
                                        ]
                                    },
                                    {
                                        if_true : "has_apple",
                                        text : "I have an apple.",
                                        lines : [
                                            {
                                                speaker : "Voice in Fridge",
                                                text : "Absolutely freakish, I am most displeased",
                                                goto : "rm_voice_angry"
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    }

                ]
            }
        }

    },
    rm_voice_happy : {
        dev_notes : "Fridge opens to show an idyllic peaceful landscape and the player escapes to freedom",
        free_move : false,
        lines : [
            { text : "Finally, I can get out of here and follow my true passion: cryptocurrency" },
            { text : "Fin" }
        ]
    },
    rm_voice_angry : {
        dev_notes : "Fridge opens to show a large mouth that eats the player",
        free_move : false,
        lines : [
            {
                speaker : "Voice in/out of Fridge",
                text : "I am going to eat you now"
            },
            {
                text : "Aaaaaah, I am being eaten"
            },
            { text : "Fin" }

        ]

    }
}