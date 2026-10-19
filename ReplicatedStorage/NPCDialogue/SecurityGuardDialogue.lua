-- @ScriptType: ModuleScript
local Dialogue = {}

Dialogue.PreScenario = {
	["Guard"] = {
		[1] = {Type = "Next", Speech = "Please do not disturb me. I am busy being a tough guard."},
		[2] = {Type = "Close"}
	}
}

Dialogue.BlackoutMinus = {
	["Guard"] = {
		[1] = {
			[1] = {Type = "Next", Speech = "Please keep calm. We are trying to sort out the situation."},
			[2] = {Type = "Close"}
		},
		[2] = {
			[1] = {Type = "Next", Speech = "Please keep calm. We are trying to sort out the situation."},
			[2] = {Type = "Close"}
		},
		[3] = {
			[1] = {Type = "Respond", Speech = "Please keep calm. We are trying to sort out the situation.", Responses = {
				[1] = "I've been told the power is completely out. Is this true?"
			}},
			[2] = {Index = 1, Type = "Respond", Speech = "...yes, that's true. Like I said, we are trying to sort out the situation. Keep calm.", Responses = {
				[2] = "I'd like to help. Is there anything I can do??"
			}},
			[3] = {Index = 2, Type = "Next", Speech = "Unfortunately not. Like I said, we are..."},
			[4] = {Index = 2, Type = "Next", Speech = "Oh, to heck with it. We're severely understaffed and help would be nice."},
			[5] = {Index = 2, Type = "Next", Speech = "There's a backup generator we need to power on. I believe it's near the %s. Check there and see what you can do.", Modifier = "loc"},
			[6] = {Index = 2, Type = "Close"}
		},
		[4] = {
			[1] = {Type = "Next", Speech = "Have you found the generator yet? It's near the %s, remember.", Modifier = "loc"},
			[2] = {Type = "Close"}
		},
		[5] = {
			[1] = {Type = "Respond", Speech = "Have you found the generator yet? It's near the %s, remember.", Responses = {
				[1] = "The door is locked."
			}, Modifier = "loc"},
			[2] = {Index = 1, Type = "Next", Speech = "Ah yes, I should've forseen that. You'll need a key then."},
			[3] = {Index = 1, Type = "Next", Speech = "Uh... I totally forgot my keys in my car... which is kind of inconvenient..."},
			[4] = {Index = 1, Type = "Next", Speech = "Oh yeah!!! I also left my car keys in there, and somebody broke into it and then for some reason went into the mall again!!"},
			[5] = {Index = 1, Type = "Next", Speech = "Don't ask how I know that. Actually, one of the other guards told me."},
			[6] = {Index = 1, Type = "Next", Speech = "Well, you can ask around and see if they would be willing to comply with you and hand over the key. Good luck!!"},
			[7] = {Index = 1, Type = "Close"}
		},
		[6] = {
			["HasItem"] = {
				[1] = {Type = "Respond", Speech = "I see you've found the generator. Is it broken or something?", Responses = {
					[1] = "Not exactly. It needs %ss to power it for some reason."
				}, Modifier = "Item"},
				[2] = {Index = 1, Type = "Next", Speech = "Oh, I forgot about that!! Yeah, those generators are weird."},
				[3] = {Index = 1, Type = "Next", Speech = "Well, lucky I grabbed one on the way here and didn't forget it in my car. Here you go."},
				[4] = {Index = 1, Type = "Next", Speech = "I have no idea where any others would be, though. I guess you'll have to scrounge around for them."},
				[5] = {Index = 1, Type = "Close"}
			},
			["Else"] = {
				[1] = {Type = "Respond", Speech = "I see you've found the generator. Is it broken or something?", Responses = {
					[1] = "Not exactly. It needs %ss to power it for some reason."
				}, Modifier = "Item"},
				[2] = {Index = 1, Type = "Next", Speech = "Oh, I forgot about that!! Yeah, those generators are weird."},
				[3] = {Index = 1, Type = "Next", Speech = "I unfortunately don't have any. Sorry. You'll have to scrounge around for them."},
				[4] = {Index = 1, Type = "Close"}
			}
		}
	}
}

return Dialogue
