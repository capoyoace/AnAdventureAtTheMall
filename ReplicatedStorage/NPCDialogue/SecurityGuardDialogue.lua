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
		[7] = {
			["HasItem"] = {
				[1] = {Type = "Respond", Speech = "I see you've found the generator. Is it broken or something?", Responses = {
					[1] = "Not exactly. It needs %ss to power it for some reason."
				}, Modifier = "Item"},
				[2] = {Index = 1, Type = "Next", Speech = "Oh, I forgot about that!! Yeah, those generators are weird."},
				[3] = {Index = 1, Type = "Next", Speech = "Well, lucky I grabbed one on the way here and didn't forget it in my car. Here you go."},
				[4] = {Index = 1, Type = "Next", Speech = "I have no idea where any others would be, though. I guess you'll have to scrounge around for them."},
				[5] = {Index = 1, Type = "Close", Consequence = 1}
			},
			["Else"] = {
				[1] = {Type = "Respond", Speech = "I see you've found the generator. Is it broken or something?", Responses = {
					[1] = "Not exactly. It needs %ss to power it for some reason."
				}, Modifier = "Item"},
				[2] = {Index = 1, Type = "Next", Speech = "Oh, I forgot about that!! Yeah, those generators are weird."},
				[3] = {Index = 1, Type = "Next", Speech = "I unfortunately don't have any. Sorry. You'll have to scrounge around for them."},
				[4] = {Index = 1, Type = "Close"}
			}
		},
		[8] = {
			[1] = {Type = "Respond", Speech = "Have you found all that you need to power up that generator?", Responses = {
				[1] = "Yup. I just gotta install them now and power it up."
			}},
			[2] = {Index = 1, Type = "Next", Speech = "Great!!! Thanks for your help. I'm sure everyone will appreciate being able to see again."},
			[3] = {Index = 1, Type = "Next", Speech = "Well, what are you waiting for? Go turn that generator on!!!"},
			[4] = {Index = 1, Type = "Close"}
		},
		[9] = {
			[1] = {Type = "Respond", Speech = "Man, you really like keeping me in suspense, don't you? What's the holdup?", Responses = {
				[1] = "So... I powered on the generator and next to nothing happened."
			}},
			[2] = {Index = 1, Type = "Next", Speech = "What? That makes no sense!! I swore that it would..."},
			[3] = {Index = 1, Type = "Respond", Speech  = "...oh. You've got to be kidding me.", Responses = {
				[2] = "What?? What is it???"
			}},
			[4] = {Index = 2, Type = "Next", Speech = "I just remembered that there are more generators. We have to power them all on."},
			[5] = {Index = 2, Type = "Next", Speech = "It kind of makes sense... how could one puny generator power this entire building?"},
			[6] = {Index = 2, Type = "Next", Speech = "Well darn. If I remember correctly, there's %s other generators. Each of them needs exactly what the first one does."},
			[7] = {Index = 2, Type = "Next", Speech = "However, first you're gonna need a master key to get into all of the maintenance rooms. Which, unfortunately, I'm too low of a position to have."},
			[8] = {Index = 2, Type = "Next", Speech = "But I do remember seeing one behind a counter in one of the various stores when I was doing my rounds. I just forget which one it was."},
			[9] = {Index = 2, Type = "Next", Speech = "I would start there though. Then you can go about collecting stuff and powering them on. Good luck!!!"},
			[10] = {Index = 2, Type = "Close"}
		},
		[10] = {
			[1] = {Type = "Next", Speech = "Have you found the master key yet? Remember, it's behind one of the counters in one of the stores. It's small and gold."},
			[2] = {Type = "Close"}
		},
		[11] = {
			[1] = {Type = "Next", Speech = "Ah, you found the key!! Great job!!"},
			[2] = {Type = "Next", Speech = "Now you gotta go collect a bunch more %ss. And while you were busy finding the key..."},
			[3] = {Type = "Next", Speech = "I went around and collected them from a bunch of people!!!"},
			[4] = {Type = "Next", Speech = "But then one dude didn't want to give me his, so he knocked me out and ran off with all of the stuff."},
			[5] = {Type = "Next", Speech = "Don't worry, though!! I'm pretty sure he slipped and all of the %ss fell out of his hands and are now scattered around the mall."},
			[6] = {Type = "Next", Speech = "Good luck finding them!! Check everywhere. Like, EVERYWHERE. He fell pretty hard."},
			[7] = {Type = "Close"}
		},
		[12] = {
			[1] = {Type = "Next", Speech = "Righty!!! You've collected all you need. Go power up those generators and let's get out of here!!!!"},
			[2] = {Type = "Close"}
		}
 	}
}

Dialogue.MunsterMinus = {
	["Guard"] = {
		[2] = {
			[1] = {Type = "Respond", Speech = "Darn thing, infiltrating into the facility and cutting of comms... work, please! *punches his radio*", Responses = {
				[1] = "Uh... excuse me?"
			}},
			[2] = {Index = 1, Type = "Next", Speech = "Eh? Who's that?"},
			[3] = {Index = 1, Type = "Respond", Speech = "Oh, it's just a random shopper. I thought you might be another officer or something.", Responses = {
				[2] = "I actually want to help with what's going on."
			}},
			[4] = {Index = 2, Type = "Next", Speech = "Is that so? Well, I would love it if you helped, but it seems that everyone is incapacitated at the moment."},
			[5] = {Index = 2, Type = "Respond", Speech = "How about you go sit in that corner and let your head rest?", Responses = {
				[3] = "My head doesn't hurt, though. I don't think I need to."
			}},
			[6] = {Index = 3, Type = "Next", Speech = "Wait... really? You feel fine??"},
			[7] = {Index = 3, Type = "Next", Speech = "Well in that case, I think I could use your help. Some others offered, but they could barely move without clutching their head and moaning."},
			[8] = {Index = 3, Type = "Next", Speech = "Since you feel alright, I'll tell you want I was thinking."},
			[9] = {Index = 3, Type = "Next", Speech = "There's an armory in the mall somewhere... I never really memorized it's location. I could swear it's just been gone a couple times."},
			[10] = {Index = 3, Type = "Next", Speech = "Needless to say, I think we ought to head there and pick up some sort of weapon."},
			[11] = {Index = 3, Type = "Next", Speech = "Then, once we have that, we can take out that beast. Got it?"},
			[12] = {Index = 3, Type = "Next", Speech = "Great, let's go. Be careful... that thing can hear you pretty well."},
			[13] = {Index = 3, Type = "Close"}
		},
		[3] = {
			[1] = {Type = "Next", Speech = "Remember, we're heading to the armory to pick up a weapon. Let's keep it going."},
			[2] = {Type = "Close"}
		},
		[4] = {
			[1] = {Type = "Next", Speech = "Phew!! We made it!!"},
			[2] = {Type = "Next", Speech = "Alright, let's go up to the shopkeeper. He should have something we can use against this thing."},
			[3] = {Type = "Close"}
		},
		[5] = {
			[1] = {Type = "Next", Speech = "Dang, this thing is HUGE!!! It will definitely show that munster who's boss!!"},
			[2] = {Type = "Next", Speech = "Now all we gotta do is find it, which shouldn't be too hard. Once we spot it, rush at it and SWING!!!"},
			[3] = {Type = "Next", Speech = "We'll carry its corpse off to the police station immediately. See what the heck it is and where the heck it came from."},
			[4] = {Type = "Next", Speech = "You ready? Let's go."},
			[5] = {Type = "Close"}
		},
		[6] = {
			[1] = {Type = "Next", Speech = "Uh.... I don't think that quite worked..."},
			[2] = {Type = "Next", Speech = "RUNNNNNN!!!!"},
			[3] = {Type = "Close"}
		},
		[7] = {
			[1] = {Type = "Next", Speech = "Well that was a disaster. We almost got ourselves fried."},
			[2] = {Type = "Next", Speech = "Dangit... that was my only idea... how else are we going to take out this thing??"},
			[3] = {Type = "Next", Speech = "...hold up. I think I have an idea."},
			[4] = {Type = "Next", Speech = "You know the apothecary? There's bound to be somethign in there that'll soften that thing up."},
			[5] = {Type = "Next", Speech = "Only thing is, the shopkeeper there is nuts. I wouldn't be surprised if he spawned that thing in the first place."},
			[6] = {Type = "Next", Speech = "Be prepared for him to deny us what we need. In that case, we'll probably have to create some sort of distraction."},
			[7] = {Type = "Next", Speech = "Let's move out and head that way... quietly. The munster's probably really mad now that we attacked it."}
		}
	}
}

return Dialogue
