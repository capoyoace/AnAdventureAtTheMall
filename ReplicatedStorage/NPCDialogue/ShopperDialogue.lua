-- @ScriptType: ModuleScript
local Dialogue = {}

--[[For reference, after responding to an NPC, your bond with them may change. This is referred to as "Consequence."
	0 indicates no change.
	1 indicates positive change; this NPC is now more trusting of you.
	-1 indicates negative change; this NPC distrusts you more now.
	2 indicates more positive change; this NPC is now a buddy of yours.
	-2 indicates more negative change; this NPC now hates you.
]]

Dialogue.PreScenario = { --The hierarchy follows this pattern: Dialogue breed -> Has bonded -> Bond level (if applicable)
	["Normal Dude"] = {
		Unbonded = {
			[1] = {Type = "Respond", Speech = "Hey there buddy. How's it going?", Responses = {
					[1] = "I'm doing fine.",
					[2] = "ABSOLUTELY INCREDIBLE!!!! UwU",
					[3] = "You smell like piss."
				}
			},
			[2] = {Index = 1, Type = "Next",  Speech = "Good for you there bud."},
			[3] = {Index = 1, Type = "Next", Speech = "Uh... yeah. I'm just gonna walk away now."},
			[4] = {Index = 1, Type = "Close", Consequence = 0},
			[5] = {Index = 2, Type = "Next", Speech = "That's great! Hope it continues going that way! UwU"},
			[6] = {Index = 2, Type = "Close", Consequence = 1},
			[7] = {Index = 3, Type = "Next", Speech = "D...dude!! What the ----?!? You don't just say that to somebody!!!"},
			[8] = {Index = 3, Type = "Next", Speech = "Go kill yourself, you stupid -------!"},
			[9] = {Index = 3, Type = "Close", Consequence = -1}
		},
		Bonded = {
			[0] = {
				[1] = {Type = "Next", Speech = "Oh... hey there again."},
				[2] = {Type = "Respond", Speech = "Do you need something?", Responses = {
					[1] = "Nope.",
					[2] = "Yeah, where are the bathrooms again????",
					[3] = "I forgot to ask how your day was going!!!"
				}},
				[3] = {Index = 1, Type = "Next", Speech = "Uh... ok."},
				[4] = {Index = 1, Type = "Close", Consequence = 0},
				[5] = {Index = 2, Type = "Next", Speech = "Uhhhhh, they're over down there."},
				[6] = {Index = 2, Type = "Next", Speech = "You could have asked an employee though. Don't know why you asked me..."},
				[7] = {Index = 2, Type = "Close", Consequence = -1},
				[8] = {Index = 3, Type = "Next", Speech = "Oh! It's going well. Thanks for asking! UwU"},
				[9] = {Index = 3, Type = "Close", Consequence = 1}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Cheeseburger", Responses = {
					[1] = "Increase",
					[2] = "Decrease",
					[3] = "Neutral",
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 1},
				[3] = {Index = 2, Type = "Close", Consequence = -1},
				[4] = {Index = 3, Type = "Close", Consequence = 0}
			},
			[2] = {
				[1] = {Type = "Next", Speech = "You are my favoroit person uwu", Responses = {
					[1] = "Neutral",
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 0},
			},
			[-1] = {
				[1] = {Type = "Respond", Speech = "Go away loozer", Responses = {
					[1] = "Increase",
					[2] = "Decrease",
					[3] = "Neutral",
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 1},
				[3] = {Index = 2, Type = "Close", Consequence = -1},
				[4] = {Index = 3, Type = "Close", Consequence = 0}
			},
			[-2] = {
				[1] = {Type = "Next", Speech = "GO AWAY LOOSER!!!! AHAHHAHAHAHAHA", Responses = {
					[1] = "Neutral",
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 0},
			},
		}
	}
}

Dialogue.BlackoutMinus = { --The hierarchy follows this pattern: Dialogue breed -> Objective -> Knowledge (if applicable) -> Bond
	["Normal Dude"] = {
		[1] = {
			["Clueless"] = {
				[0] = {
					[1] = {Type = "Next", Speech = "Why are all the lights out???"},
					[2] = {Type = "Close"}
				},
				[1] = {
					[1] = {Type = "Respond", Speech = "Oh my gosh dude what's going on???", Responses = {
						[1] = "I'm not sure, that's what I've been trying to figure out."
					}},
					[2] = {Index = 1, Type = "Next", Speech = "Well somebody's gotta know!! I'll keep asking around too. I'll holler if I find anything out!"},
					[3] = {Index = 1, Type = "Close"}
				},
				[-1] = {
					[1] = {Type = "Next", Speech = "You are the last person I want to see in this situation. Scram!!"},
					[2] = {Type = "Close"}
				}
			},
			["Knowledgable"] = {
				[0] = {
					[1] = {Type = "Respond", Speech = "Man, this is annoying!!! Who turned the lights out?", Responses ={
						[1] = "So somebody just flipped a switch and this happened?"
					}},
					[2] = {Index = 1, Type = "Next", Speech = "I mean maybe... all I heard is that the power went out. Like dead out. Even the emergency lights aren't working."},
					[3] = {Index = 1, Type = "Next", Speech = "For some reason that shut all of the shops as well... and the exits. We're all stuck in here until somebody breaks us out..."},
					[4] = {Index = 1, Type = "Close"}
				},
				[1] = {
					[1] = {Type = "Next", Speech = "Hey!! I found out what's going on!!"},
					[2] = {Type = "Next", Speech = "The power went out. And while this may seem obvious cause the lights are, y'know, not working..."},
					[3] = {Type = "Next", Speech = "It apparently died HARD. Not even the emergency lights are working. And worse yet..."},
					[4] = {Type = "Next", Speech = "The shops and exits have been locked down automatically. We're stuck here unless someone breaks us out."},
					[5] = {Type = "Next", Speech = "That's what I've heard, at least. Perhaps there's still an exit that is open... might want to look around. I'm gonna go complain to the manager and try to sue."},
					[6] = {Type = "Close"}
				},
				[-1] = {
					[1] = {Type = "Next", Speech = "You look confused as to what's going on. I know what's going on."},
					[2] = {Type = "Next", Speech = "But why would I ever tell you?? Find someone else to get info from."},
					[3] = {Type = "Close"}
				}
			}
		}
	}
}

return Dialogue
