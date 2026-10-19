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
			[7] = {Index = 3, Type = "Next", Speech = "D...dude!! What the cheese?!? You don't just say that to somebody!!!"},
			[8] = {Index = 3, Type = "Next", Speech = "Man, I really don't like you!! Go away!!!"},
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
				[1] = {Type = "Respond", Speech = "Go away meanie", Responses = {
					[1] = "Increase",
					[2] = "Decrease",
					[3] = "Neutral",
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 1},
				[3] = {Index = 2, Type = "Close", Consequence = -1},
				[4] = {Index = 3, Type = "Close", Consequence = 0}
			},
			[-2] = {
				[1] = {Type = "Next", Speech = "GO AWAY JERK!!!! AHAHHAHAHAHAHA", Responses = {
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
			["Knowledgeable"] = {
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
		},
		[2] = {
			[0] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
		},
		[3] = {
			[0] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
		},
		[4] = {
			[0] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Placeholder"},
				[2] = {Type = "Close"}
			},
		},
		[5] = {
			["HasKey"] = {
				[0] = {
					[1] = {Type = "Respond", Speech = "Why are all the lights out???? And why on earth are all of the exits shut????????????????", Responses = {
						[1] = "You wouldn't so happen to have a certain security guard's keys, would you?"
					}},
					[2] = {Index = 1, Type = "Next", Speech = "Uh... no... why would you think that?"},
					[3] = {Index = 1, Type = "Respond", Speech = "I mean... why are you looking for them anyways?", Responses = {
						[2] = "To get us out of this situation.",
						[3] = "I want to return them to the security guard.",
						[4] = "The person who stole them needs to be punished." 
					}},
					[4] = {Index = 2, Type = "Next", Speech = "Really? You need them to get us out of here?"},
					[5] = {Index = 2, Type = "Next", Speech = "Well, in that case, I guess I can fork them over. Here you go."},
					[6] = {Index = 2, Type = "Next", Speech = "But if you don't get us out of here, I won't let this fly..."},
					[7] = {Index = 2, Type = "Close", Consequence = 1},
					[8] = {Index = 3, Type = "Next", Speech = "That makes sense. He probably wants them back."},
					[9] = {Index = 3, Type = "Next", Speech = "Well, I hope you find who has them. Good luck. Uh... bye."},
					[10] = {Index = 3, Type = "Close", Consequence = 0},
					[11] = {Index = 4, Type = "Next", Speech = "Oh! Uh... I mean I guess... did he put you on this or something?"},
					[12] = {Index = 4, Type = "Next", Speech = "Well, good luck finding them. Cause it definitely ain't me. Nope."},
					[13] = {Index = 4, Type = "Close", Consequence = -1}
				},
				[1] = {
					[1] = {Type = "Respond", Speech = "Oh hey there! Figure anything out about our situtation?", Responses = {
						[1] = "Working on it. Do you have security guard's keys perchance?"
					}},
					[2] = {Index = 1, Type = "Respond", Speech = "Uh... yeah... why?", Responses = {
						[2] = "I need access to a locked room and he said somebody had his keys."
					}},
					[3] = {Index = 2, Type = "Next", Speech = "Well... that's pretty interesting. I took the keys to... return them. Yeah."},
					[4] = {Index = 2, Type = "Next", Speech = "Here you go. Glad I can be of service!!"},
					[5] = {Index = 2, Type = "Next", Speech = "If you need anything else, just tell me and I can try to help!"},
					[6] = {Index = 2, Type = "Close", Consequence = 1}
				},
				[-1] = {
					[1] = {Type = "Respond", Speech = "What do you want?", Responses = {
						[1] = "You wouldn't so happen to have a certain security guard's keys, would you?"
					}},
					[2] = {Index = 1, Type = "Next", Speech = "Why are you accusing me of that? You think I'm some klepto or something?"},
					[3] = {Index = 1, Type = "Next", Speech = "Bug off, jerk. Even if I had some keys I wouldn't give them to you."},
					[4] = {Index = 1, Type = "Close", Consequence = -1}
				}
			},
			["Else"] = {
				[0] = {
					[1] = {Type = "Respond", Speech = "Why are all the lights out???? And why on earth are all of the exits shut????????????????", Responses = {
						[1] = "You wouldn't so happen to have a certain security guard's keys, would you?"
					}},
					[2] = {Index = 1, Type = "Next", Speech = "What? Are you crazy? Why on earth would I have some random dude's keys?"},
					[3] = {Index = 1, Type = "Close"}
				},
				[1] = {
					[1] = {Type = "Respond", Speech = "Oh hey there! Figure anything out about our situation?", Responses = {
						[1] = "Working on it. Do you have a security guard's keys perchance?"
					}},
					[2] = {Index = 1, Type = "Respond", Speech = "Uh... no, unfortunately not. Why do you need them?", Responses = {
						[2] = "I need to get into a locked room and the guard said somebody stole his keys."
					}},
					[3] = {Index = 2, Type = "Next", Speech = "Huh. Interesting. Sounds like that guard is not good at his job."},
					[4] = {Index = 2, Type = "Next", Speech = "I'll ask around to see if anybody knows where the keys are. If I find them, I'll come running."},
					[5] = {Index = 2, Type = "Close"}
				},
				[-1] = {
					[1] = {Type = "Respond", Speech = "What do you want?", Responses = {
						[1] = "You wouldn't so happen to have a certain security guard's keys, would you?"
					}},
					[2] = {Index = 1, Type = "Next", Speech = "Why are you accusing me of that? You think I'm some klepto or something?"},
					[3] = {Index = 1, Type = "Next", Speech = "Bug off, jerk. Even if I had some keys I wouldn't give them to you."},
					[4] = {Index = 1, Type = "Close"}
				},
			}
		},
		[6] = {
			["HasItem"] = {
				[0] = {
					[1] = {Type = "Respond", Speech = "Dude, I am sick of the dark. Can someone turn the lights on pleaseeeeeeeeee?", Responses = {
						[1] = "You wouldn't so happen to have a %s, would you?"
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Respond", Speech = "Yeah, I actually do. Why do you need it?", Responses = {
						[2] = "I'm hungry. I want a snack.",
						[3] = "Your mom told me to give it to me.",
						[4] = "I need it to power a backup generator.",
						[5] = "No reason. I'm just wondering."
					}},
					[3] = {Index = 2, Type = "Next", Speech = "What? Why would you want to eat my %s?", Modifier = "Item"},
					[4] = {Index = 2, Type = "Next", Speech = "My answer's no, bucko. I ain't gonna fork over my precious. Come up with a better answer and I might consider it."},
					[5] = {Index = 2, Type = "Close", Consequence = 0},
					[6] = {Index = 3, Type = "Next", Speech = "Dude. There's no wifi or cell and my mom's at home. She couldn't have possible told you that."},
					[7] = {Index = 3, Type = "Next", Speech = "You lose bucko. I ain't givin you nuthin."},
					[8] = {Index = 3, Type = "Close", Consequence = -1},
					[9] = {Index = 4, Type = "Next", Speech = "Really? Huh. Strange generator."},
					[10] = {Index = 4, Type = "Next", Speech = "Well, here you go. I really hope this works otherwise I'm taking you to court, bucko."},
					[11] = {Index = 4, Type = "Close"},
					[12] = {Index = 5, Type = "Next", Speech = "Oh. Ok. Well now you know."},
					[13] = {Index = 5, Type = "Close"}
				},
				[1] = {
					[1] = {Type = "Respond", Speech = "How's it going? Find anything more out yet?", Responses = {
						[1] = "Actually, yeah. I need a few %s to power a backup generator."
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Really? I have one!!!"},
					[3] = {Index = 1, Type = "Next", Speech = "Here you go. I'm happy I could help! Let me know if you need me for anything else."},
					[4] = {Index = 1, Type = "Close"}
				},
				[-1] = {
					[1] = {Type = "Respond", Speech = "Ugh. You again. What do you want now?", Responses = {
						[1] = "You don't so happen to have a %s, do you?"
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Yeah, I do. But you don't get it. Bug off, jerk."},
					[3] = {Index = 1, Type = "Close"}
				}
			},
			["Else"] = {
				[0] = {
					[1] = {Type = "Respond", Speech = "Dude, I am sick of the dark. Can someone turn the lights on pleaseeeeeeeeee?", Responses = {
						[1] = "You wouldn't so happen to have a %s, would you?"
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Nope. Sorry man."},
					[3] = {Index = 1, Type = "Close"}
				},
				[1] = {
					[1] = {Type = "Respond", Speech = "How's it going? Find anything more out yet?", Responses = {
						[1] = "Actually, yeah. I need a few %s to power a backup generator."
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Really? Dang, I wish I had one."},
					[3] = {Index = 1, Type = "Next", Speech = "I'll try to find one for you, and if I get one I'll come running."},
					[4] = {Index = 1, Type = "Close"}
				},
				[-1] = {
					[1] = {Type = "Respond", Speech = "Ugh. You again. What do you want now?", Responses = {
						[1] = "You don't so happen to have a %s, do you?"
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Heck no. And even if I did I wouldn't give it to you."},
					[3] = {Index = 1, Type = "Close"}
				}
			}
		}
	}
}

return Dialogue
