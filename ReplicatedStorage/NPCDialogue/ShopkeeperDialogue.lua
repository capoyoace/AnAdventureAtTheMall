-- @ScriptType: ModuleScript
local Dialogue = {}

Dialogue.PreScenario = {
	["Keeper"] = {
		[1] = {Type = "Next", Speech = "Welcome to the shop!! I hope you find something you like!!!"},
		[2] = {Type = "Next", Speech = "(you nod and smile, deciding not to mention the protuberant lack of items)"},
		[3] = {Type = "Close"}
	},
	["Armorer"] = {
		[1] = {Type = "Next", Speech = "Hey there. Pick what you want, then point at it and I can get it down for you."},
		[2] = {Type = "Next", Speech = "You'll need to show some sort of proof you know how to use the item, though. I won't just sell it to you."},
		[3] = {Type = "Next", Speech = "(You nod and glance at the empty shelves. What a decision you'll have to make....)"},
		[4] = {Type = "Close"}
	},
	["Apothecary"] = {
		[1] = {Type = "Next", Speech = "Eehehehehe!!! You want some of my tasty brews? You'll have to pay a steep price!!"},
		[2] = {Type = "Next", Speech = "My ingredients are even more expensive, so don't think about buying those to avoid the high price of the potions!"},
		[3] = {Type = "Next", Speech = "Besides, you look like you don't even know how to make a powdered drink. You wouldn't be able to brew one of these!!"},
		[4] = {Type = "Next", Speech = "Eeeeheheheheheheheee!!!"},
		[5] = {Type = "Close"}
	}
}

Dialogue.RepeatedDialogue = {
	["BlackoutMinus"] = {
		["Keeper"] = {
			[1] = {Type = "Next", Speech = "Uh.... the lights are out."},
			[2] = {Type = "Next", Speech = "Well, my register isn't working too, so we're closed down. Sorry pal."},
			[3] = {Type = "Close"}
		},
		["Armorer"] = {
			[1] = {Type = "Next", Speech = "....someone must have killed the lights."},
			[2] = {Type = "Next", Speech = "You may want to arm yourself in case they have ill motives. You'll still have to pass the tests and pay the bill, though."},
			[3] = {Type = "Next", Speech = "Only thing that's different is it's dark and I only accept cash now."},
			[4] = {Type = "Close"}
		},
		["Apothecary"] = {
			[1] = {Type = "Next", Speech = "Eeehehehehehe!!! Looks like somebody forgot electricity isn't the best power supply!!"},
			[2] = {Type = "Next", Speech = "Luckily, I have a few potions here that'll help you see in the dark..."},
			[3] = {Type = "Next", Speech = "Of course, they also give you explosive diarrhea, but that's just a minor drawback!! Eeeehehehehe!!!"},
			[4] = {Type = "Close"}
		}
	},
	["MunsterMinus"] = {
		["Keeper"] = {
			[1] = {Type = "Next", Speech = "You're gonna take that thing out, right??"},
			[2] = {Type = "Next", Speech = "Regardless, feel free to recollect yourself in here... it can't get us for some reason. Maybe I'm too intimidating."},
			[3] = {Type = "Close"}
		},
		["Apothecary"] = {
			[1] = {Type = "Next", Speech = "Eeehehehehehe!!! Looks like someone let this big fella loose!!"},
			[2] = {Type = "Next", Speech = "Of course, I know how to take it out and save everyone too..."},
			[3] = {Type = "Next", Speech = "But like always you'll have to pay a steeeeeep price for them!!! Eeeeeehehehehehehe!!!!"},
			[4] = {Type = "Next", Speech = "I drank the potion once. It tasted like tar. Which is, coincidentally, my favorite flavor!!!!"},
			[5] = {Type = "Next", Speech = "Eeeeeeeeeeehehehehehehe!!!!"},
			[6] = {Type = "Next", Speech = "(His incessant cackling really makes you want to plant your fist in his smug little face.)"},
			[7] = {Type = "Close"}
		}
	}
}

Dialogue.BlackoutMinus = {
	["Keeper"] = {
		[1] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[2] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[3] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[4] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[5] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[6] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[7] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[8] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[9] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[10] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[11] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper,
		[12] = Dialogue.RepeatedDialogue.BlackoutMinus.Keeper
	},
	["Armorer"] = {
		[1] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[2] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[3] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[4] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[5] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[6] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[7] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[8] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[9] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[10] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[11] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
		[12] = Dialogue.RepeatedDialogue.BlackoutMinus.Armorer,
	},
	["Apothecary"] = {
		[1] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[2] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[3] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[4] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[5] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[6] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[7] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[8] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[9] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[10] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[11] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
		[12] = Dialogue.RepeatedDialogue.BlackoutMinus.Apothecary,
	}
}

Dialogue.MunsterMinus =  {
	["Keeper"] = {
		[1] = {
			["NPCToFind"] = {
				[1] = {Type = "Next", Speech = "...you good man?"},
				[2] = {Type = "Next", Speech = "Great. At least you're responsive. These folk don't seem to be in the best condition."},
				[3] = {Type = "Respond", Speech = "Your head feel alright?", Responses = {
					[1] = "Uh... yeah. Why?"
				}},
				[4] = {Index = 1, Type = "Next", Speech = "That's good... mine's been bugging me ever since that thing got in."},
				[5] = {Index = 1, Type = "Next", Speech = "Oh... hold on... I think I'm getting a signal on my radio..."},
				[6] = {Index = 1, Type = "Next", Speech = "I was gonna check on everyone else, but I gotta fiddle with this. Could you ask around for me?"},
				[7] = {Index = 1, Type = "Close"}
			}
		},
		[2] = {
			[1] = {Type = "Next", Speech = "..........."},
			[2] = {Type = "Next", Speech = "Finish checking up on people, I'm still tuning this bad boy....."},
			[3] = {Type = "Close"}
		},
		[3] = {
			["NPCToFind"] = {
				[1] = {Type = "Respond", Speech = "Is everyone okay?", Responses = {
					[1] = "Barely... they were all complaining about their heads too."
				}},
				[2] = {Index = 1, Type = "Respond", Speech = "That's not good... something's up with that thing.", Responses = {
					[2] = "Well no crap Sherlock. Did you get something from your radio?"
				}},
				[3] = {Index = 2, Type = "Next", Speech = "Only a little bit. I was able to tell it was a security guard... he said something about the %s...", Modifier = "loc"},
				[4] = {Index = 2, Type = "Next", Speech = "And then the radio went completely dead. I can't revive it at all. And I just recharged it yesterday..."},
				[5] = {Index = 2, Type = "Next", Speech = "If you're feeling alright, you might want to head down to the %s and talk with that guard. I'm gonna see what I can do about these folks.", Modifier = "loc"},
				[6] = {Index = 2, Type=  "Next", Speech = "Be careful out there. That thing's dangerous... these are the only survivors I was able to get in here..."},
				[7] = {Index = 2, Type = "Close"}
			}
		},
		[4] = {
			["Required"] = {
				[1] = {Type = "Next", Speech = "You should probably head over there soon. Be careful."},
				[2] = {Type = "Close"}
			}
		}
	},
	["Armorer"] = {
		[1] = {}
	}
}

return Dialogue
