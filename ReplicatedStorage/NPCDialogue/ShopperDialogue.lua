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
	},
	["Shopaholic"] = {
		Unbonded = {
			[1] = {Type = "Respond", Speech = "Ohhhh my gosh you are new to the mall right???? I don't recognize you from the 12232 times I've been hereeeee", Respones = {
				[1] = "Yeah, this is my first time.",
				[2] = "Why do you speak in such an annoying manner?",
				[3] = "Wow, you must really love the mall!"
			}},
			[2] = {Index = 1, Type = "Next", Speech = "Wellll if you need anythinggg make sure to ask meeee cause I know my way around here okay little guyyyy????"},
			[3] = {Index = 1, Type = "Next", Speech = "Well bye I gotta go buy some more stuffff"},
			[4] = {Index = 1, Type = "Close", Consequence = 0},
			[5] = {Index = 2, Type = "Next", Speech = "Um excuse me? What the heck was that forrr?"},
			[6] = {Index = 2, Type = "Next", Speech = "You are a very rude little man go away for reallllll"},
			[7] = {Index = 2, Type = "Close", Consequence = -1},
			[8] = {Index = 3, Type = "Next", Speech = "Oh my gosh yes gurrrrl!!!! I love this place if I could move in I totally would oh my goshhhhhh"},
			[9] = {Index = 3, Type = "Next", Speech = "Thank you so much for appreciating what I loveeee slay all day little guyyyyy"},
			[10] = {Index = 3, Type = "Close", Consequence = 1}
		},
		Bonded = {
			[0] = {
				[1] = {Type = "Respond", Speech = "Heyyy there little guyyy do you need something???", Responses = {
					[1] = "What's your favorite store?",
					[2] = "I really need to find the bathroom!!! I'm already leaking a little bit!!!",
					[3] = "Not really."
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Ohhhh that's a really hard question!!!! I really like them alll because they all have their own little quirks"},
				[3] = {Index = 1, Type = "Next", Speech = "Thank you sooo much for asking little guy you really made my day ^U^"},
				[4] = {Index = 1, Type = "Close", Consequence = 1},
				[5] = {Index = 2, Type = "Next", Speech = "Ummmmm that's a really weird question???? And TMI for reallll"},
				[6] = {Index = 2, Type = "Close", Consequence = -1},
				[7] = {Index = 3, Type = "Next", Speech = "Well if you don't pleaseeee don't interrupt me I am very bussyyyyyyy"},
				[8] = {Index = 3, Type = "Close", Consequence = 0}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "eeeeeeeeeeeeeeee", Respones = {
					[1] = "Increase",
					[2] = "Decrease",
					[3] = "Neutral"
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 1},
				[3] = {Index = 2, Type = "Close", Consequence = -1},
				[4] = {Index = 3, Type = "Close", Consequence = 0}
			},
			[2] = {
				[1] = {Type = "Next", Speech = "Ohhh my gosh it's my favorite little guyyyyy awwwww"},
				[2] = {Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Respond", Speech = "meanieeeeee", Respones = {
					[1] = "Increase",
					[2] = "Decrease",
					[3] = "Neutral"
				}},
				[2] = {Index = 1, Type = "Close", Consequence = 1},
				[3] = {Index = 2, Type = "Close", Consequence = -1},
				[4] = {Index = 3, Type = "Close", Consequence = 0}
			},
			[-2] = {
				[1] = {Type = "Next", Speech = "You little meanie get away from meeeeee"},
				[2] = {Type = "Close"}
			}
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
					[4] = {Index = 1, Type = "Close", Consequence = 1}
				},
				[1] = {
					[1] = {Type = "Next", Speech = "Hey!! I found out what's going on!!"},
					[2] = {Type = "Next", Speech = "The power went out. And while this may seem obvious cause the lights are, y'know, not working..."},
					[3] = {Type = "Next", Speech = "It apparently died HARD. Not even the emergency lights are working. And worse yet..."},
					[4] = {Type = "Next", Speech = "The shops and exits have been locked down automatically. We're stuck here unless someone breaks us out."},
					[5] = {Type = "Next", Speech = "That's what I've heard, at least. Perhaps there's still an exit that is open... might want to look around. I'm gonna go complain to the manager and try to sue."},
					[6] = {Type = "Close", Consequence = 1}
				},
				[-1] = {
					[1] = {Type = "Next", Speech = "You look confused as to what's going on. I know what's going on."},
					[2] = {Type = "Next", Speech = "But why would I ever tell you?? Find someone else to get info from."},
					[3] = {Type = "Close", Consequence = -1}
				}
			}
		},
		[2] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "Why are all of the lights out???", Responses = {
					[1] = "The power completely shut down. Like, completely and totally."
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Huh. That's really strange. I had a blackout at my house the other day too."},
				[3] = {Index = 1, Type = "Next", Speech = "I think the new governer of Robloxia is behind it all. He seems to old to like electricity."},
				[4] = {Index = 1, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Next", Speech = "Gosh, it's dark in here. Who's that?"},
				[2] = {Type = "Next", Speech = "Oh, it's you!! Hi there!"},
				[3] = {Type = "Respond", Speech = "Have you found out anything of note to our current situation?", Responses = {
					[1] = "Currently no. I'm double checking the exits to see if maybe one of them didn't completely shut down."
				}},
				[4] = {Index = 1, Type = "Next", Speech = "Good idea. Maybe there is still hope that an exit is open. I hate the idea of being trapped in here."},
				[5] = {Index = 1, Type = "Next", Speech = "Well, update me if you find out anything. I'm gonna continue to try to see if anyone know what's behind all of this."},
				[6] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Ugh. Not you. Please go away, I'd rather spend time in the solitude of darkness than with you."},
				[2] = {Type = "Close"}
			},
		},
		[3] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "Bro can someone turn the lights on??? I really don't like the dark....", Responses = {
					[1] = "You don't so happen to know where a security guard is, do you?"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "A security guard? I think I saw one by an elevator upstairs."},
				[3] = {Index = 1, Type = "Next", Speech = "Wait, do you think he could turn on the lights? That's brilliant!! I should have thought of it myself."},
				[4] = {Index = 1, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Hey there! Are any of the exits open?", Responses = {
					[1] = "No, unfortunately. I'm looking for a security guard now."
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Darn. I really hoped that one could possibly be open and that we could all go free from this confining place which I am so afeared of."},
				[3] = {Index = 1, Type = "Next", Speech = "You said you needed to fid a security guard? I believe there is one upstairs above the food court, near the elevator."},
				[4] = {Index = 1, Type = "Next", Speech = "He looks a little scared, so I'm sure he knows what's going on. You should try asking him for information!"},
				[5] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Dude. Go away. I've already established that I don't like you and won't be helping you in any capacity."},
				[2] = {Type = "Close"}
			},
		},
		[4] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "I really wanna go home man. This darkness thing is not for me.", Responses = {
					[1] = "Do you so happen to know where the %s could be?"
				}, Modifier = "loc"},
				[2] = {Index = 1, Type = "ModNext", Speech = {
					["downstairs maintenance room"] = "Oh yeah. There's a couple that are near the end of one of the hallways, and there's another near the elevator at the food court.",
					["upstairs maintenace room"] = "I think I do. It's near the elevator above the food court. That's where I've been told it is, at least.",
					["roof"] = "There's a door that has a big ol' \"roof access\" sign on it upstairs above the food court. I don't think you can get in there, though, cause it says you need a permit."
				}},
				[3] = {Index = 1, Type = "Next", Speech = "I'm just a little shopper though, so I could be wrong about all of these things. Oops."},
				[4] = {Index = 1, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Oh hi again! How's it going with the whole figuring out what's going on thing?", Responses = {
					[1] = "I was able to ask a security guard, and all he told me was there's a backup generator at the %s I should activate."
				}, Modifier = "loc"},
				[2] = {Index = 1, Type = "ModNext", Speech = {
					["downstairs maintenance room"] = "Oh, I know where those are! There are three of them, actually."
				}}
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
			[0] = {
				[1] = {Type = "Next", Speech = "Man, I'm hungry. If the power was on I'd be able to buy a big burger at the food court....."},
				[2] = {Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Hello again. Getting any closer to solving this mess?", Responses = {
					[1] = "Yeah, actually. I'm about to go start up the generator."
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Really???? That's incredible!!! I can't wait!!"},
				[3] = {Index = 1, Type = "Next", Speech = "Well, go do it!!! The sooner we get out of here the better."},
				[4] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Dude. Stop talking to me. I'm sick of you."},
				[2] = {Type = "Close"}
			}
		},
		[7] = {
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
					[11] = {Index = 4, Type = "Close", Consequence = 1},
					[12] = {Index = 5, Type = "Next", Speech = "Oh. Ok. Well now you know."},
					[13] = {Index = 5, Type = "Close", Consequence = 0}
				},
				[1] = {
					[1] = {Type = "Respond", Speech = "How's it going? Find anything more out yet?", Responses = {
						[1] = "Actually, yeah. I need a few %s to power a backup generator."
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Really? I have one!!!"},
					[3] = {Index = 1, Type = "Next", Speech = "Here you go. I'm happy I could help! Let me know if you need me for anything else."},
					[4] = {Index = 1, Type = "Close", Consequence = 1}
				},
				[-1] = {
					[1] = {Type = "Respond", Speech = "Ugh. You again. What do you want now?", Responses = {
						[1] = "You don't so happen to have a %s, do you?"
					}, Modifier = "Item"},
					[2] = {Index = 1, Type = "Next", Speech = "Yeah, I do. But you don't get it. Bug off, jerk."},
					[3] = {Index = 1, Type = "Close", Consequence = -1}
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
		},
		[8] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "The dark is so consuming I can taste it....", Responses = {
					[1] = "Well worry not, I'm about to change that!!!"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "What?? How???"},
				[3] = {Index = 1, Type = "Next", Speech = "No... wait... you're just giving me false hope."},
				[4] = {Index = 1, Type = "Next", Speech = "I'd really appreciate it if you didn't. You're just some random dude. What can you do to affect the power?"},
				[5] = {Index = 1, Type = "Next", Speech = "Now, if you don't mind, I'm going to go and think about something sad in a corner. Goodbye."},
				[6] = {Index = 1, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Did you succeed on your treasure hunt?", Responses = {
					[1] = "I did indeed!! Going off to power the generator now!!!"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Great!!!! We've finally succeeded!!"},
				[3] = {Index = 1, Type = "Next", Speech = "Well, I won't keep you. Go power that baby on!!!!"},
				[4] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Dude, I want so bad to get out of here so I don't have to keep running into you."},
				[2] = {Type = "Close"}
			}
		},
		[9] = {
			[0] = {
				[1] = {Type = "Next", Speech = "Oh how I long for the sweet release of death..."},
				[2] = {Type = "Next", Speech = "Anything would be better than sitting here in this cold, dark mall, waiting for my demise to come...."},
				[3] = {Type = "Next", Speech = "Why did I decide to run errands today of all days??? Little did I know it would be my last..."},
				[4] = {Type = "Next", Speech = "But alas, all I can do now is wait for my impending doom..."},
				[5] = {Type = "Next", Speech = "I wonder if the food court has any more cheeseburgers. I want to at least die happy."},
				[6] = {Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Well? What's the holdup? Have you powered the generator on yet?", Responses = {
					[1] = "I did... and nothing happened."
				}},
				[2] = {Index = 1, Type = "Respond", Speech = "Really? That's super weird...", Responses = {
					[2] = "Yeah. I'm gonna go chat with that security guard to see what's up."
				}},
				[3] = {Index = 2, Type = "Next", Speech = "Good idea. Keep me updated on the situation."},
				[4] = {Index = 2, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "I knew you were coming. I could smell you. I'm not interested in chatting right now."},
				[2] = {Type = "Next", Speech = "And, for that matter, I'm not interested in chatting at all, thank you very much. Good afternoon."},
				[3] = {Type = "Close"}
			}
		},
		[10] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "....this place is going to haunt my nightmares", Responses = {
					[1] = "Did you see any keys around the counter at any shops?"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Huhhhwhahahahaaa??"},
				[3] = {Index = 1, Type = "Next", Speech = "Oh, sorry. I didn't realize you were talking to me. I was busy wallowing in my grief."},
				[4] = {Index = 1, Type = "Respond", Speech = "What was your question again?", Responses = {
					[2] = "Oh, nevermind.",
					[3] = "Have you seen any keys in any of the shops? Specifically near the counters?"
				}},
				[5] = {Index = 2, Type = "Next", Speech = "Uh.... okay."},
				[6] = {Index = 2, Type = "Close"},
				[7] = {Index = 3, Type = "Next", Speech = "Oh. Uh... no, sorry. I only payed attention to the shop wares."},
				[8] = {Index = 3, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Next", Speech = "Gosh... my head hurts from this lack of light..."},
				[2] = {Type = "Respond", Speech = "...Oh hey!! I didn't see you there, sorry. What's up?", Responses = {
					[1] = "You're fine. Have you seenn any keys around shop counters?"
				}},
				[3] = {Index = 1, Type = "Next", Speech = "Hmm, let me see here.... uh..."},
				[4] = {Index = 1, Type = "Next", Speech = "Sorry, I haven't... at least not that I can remember."},
				[5] = {Index = 1, Type = "Next", Speech = "I'll keep an eye out though. If that even matters... it's so dark..."},
				[6] = {Index = 1, Type = "Close"},
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "GGGAAAAAAAAAAAAAAAAAAHHHHHHH!!!!!"},
				[2] = {Type = "Next", Speech = "Oh, it's you!! You absolute NOOB! Why would you try to scare me like that???"},
				[3] = {Type = "Next", Speech = "If you try that again, I'm taking you out, jerk! Watch it!!"},
				[4] = {Type = "Close"}
			}
		},
		[11] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "It's so dark I can practically feel it....", Responses = {
					[1] = "Uh... excuse me?"
				}},
				[2] = {Index = 1, Type = "Respond", Speech = "WOah!! Oh sorry. I can't see practically anything, so you surprised me.", Responses = {
					[2] = "Sorry about that. I'm trying to fix it."
				}},
				[3] = {Index = 2, Type = "Next", Speech = "Oh, you're that false hope guy, aren't you?"},
				[4] = {Index = 2, Type = "Next", Speech = "You won't get my hopes up this time. Please leave me alone and stop preaching falsely at me."},
				[5] = {Index = 2, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "....man, this darkness is REALLY dark.... it feels like it's been deepening...", Responses = {
					[1] = "Hey!! It's me!!!"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Woah!! You gave me a bit of a jump there!!!"},
				[3] = {Index = 1, Type = "Respond", Speech = "Well, what's up? Making progress??", Responses = {
					[2] = "Yeah, I need to collect more %ss. Have you seen any around here?"
				}},
				[4] = {Index = 2, Type = "Next", Speech = "...More?? Really??"},
				[5] = {Index = 2, Type = "Respond", Speech = "Why do you need more??", Responses = {
					[3] = "There are more generators that I've got to activate."
				}},
				[6] = {Index = 3, Type = "Next", Speech = "Ah. I see. Well, I can barely see you, so I can't say I have."},
				[7] = {Index = 3, Type = "Next", Speech = "If I stumble on one, I'll try to bring it to you... but that's not going to be easy, given the lack of light..."},
				[8] = {Index = 3, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Respond", Speech = "I swear if that moron comes back and tries to scare me again...", Responses = {
					[1] = "... (walk away)"
				}},
				[2] = {Index = 1, Type = "Close"}
			}
		},
		[12] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "I just want to see light again..........", Responses = {
					[1] = "Well, you're about to, cause I've got all I need to power this building up again!!"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Oh no, not the false prophet again...."},
				[3] = {Index = 1, Type = "Next", Speech = "I'm just gonna walk away... don't need to hear any of your false offerings of hope..."},
				[4] = {Index = 1, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "...It's been so long since I've seen any light...", Responses = {
					[1] = "Don't worry, you're about to see it again!!!"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Really??? That's great!!!"},
				[3] = {Index = 1, Type = "Next", Speech = "But... why are you talking to me? Shouldn't you be powering those generators on?"},
				[4] = {Index = 1, Type = "Next", Speech = "You seem to be delaying so much, one may even think you're bluffing about the whole generator thing..."},
				[5] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "..............................."},
				[2] = {Type = "Close"}
			}
		}
	}
}
	
Dialogue.MunsterMinus = {
	["Normal Dude"] = {
		[1] = {
			[0] = {
				[1] = {Type = "Respond", Speech = "Arrrrrgghhh.... my headddddd...", Responses = {
					[1] = "Are you okay????"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "I think so.... but my heaaaaddd is in pain..."},
				[3] = {Index = 1, Type = "Next", Speech = "I don't know whether it's from how loud that thing is or how bad it smells, but it sure is effective....."},
				[4] = {Index = 1, Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Unnnnngghhh.... it huuuuuurts....", Responses = {
					[1] = "You good man?"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "Probably... I'm just disoriented.... and my head hurts..."},
				[3] = {Index = 1, Type = "Next", Speech = "What even happened??? Where did that thing come from??"},
				[4] = {Index = 1, Type = "Next", Speech = "I think you'd better check on everyone else.... see if they're alright..."},
				[5] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Respond", Speech = "Errrrghghhhghghg, my headddd...", Responses = {
					[1] = "Are you alright??"
				}},
				[2] = {Index = 1, Type = "Next", Speech = "I hope so... but I don't know why you would really care."},
				[3] = {Index = 1, Type = "Next", Speech = "And I'd be better if you weren't talking to me. Leave me alone."},
				[4] = {Index = 1, Type = "Close"}
			}
		},
		[2] = {
			[0] = {
				[1] = {Type = "Next", Speech = "Unnnghhh... my head hurts....."},
				[2] = {Type = "Next", Speech = "Who even let that thing in?? Where did it come from??"},
				[3] = {Type = "Next", Speech = "Heck, what IS it??"},
				[4] = {Type = "Close"}
			},
			[1] = {
				[1] = {Type = "Respond", Speech = "Arrrrgghhh... have you made sure everyone is okay?", Responses = {
					[1] = "Yeah, I checked on them and they seem to be alright. Everyone's head hurts, though."
				}},
				[2] = {Index = 1, Type = "Next", Speech = "I get that. Mine does too. I don't know why."},
				[3] = {Index = 1, Type = "Next", Speech = "If you want to help, though, I heard there is a security officer in the %s shop. You should talk to him."},
				[4] = {Index = 1, Type = "Next", Speech = "Come check on me afterwards. My pain is ebbing away... slowly... so I think I'll be ready."},
				[5] = {Index = 1, Type = "Next", Speech = "Good luck and be careful. That thing does not look safe."},
				[6] = {Index = 1, Type = "Close"}
			},
			[-1] = {
				[1] = {Type = "Next", Speech = "Ohhhhhh my headddddd... it feels worse..."},
				[2] = {Type = "Next", Speech = "Ah, that's why. You're here. Please leave, you're worsening my pain..."},
				[3] = {Type = "Close"}
			}
		}
	}
}

return Dialogue
