-- @ScriptType: ModuleScript
local MunsterMinus = {}

local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local ObjectiveService = require(ServerStorage.Tasks.ObjectiveHandler)

MunsterMinus.ObjectiveList = { --List of scenario objectives. Note the decimals; if you fail one objective, it adds a decimal place to the next one.
	[1] = {Type = "AskAround", DisplayInfo = "Check if everyone is okay."},
	[2] = {Type = "FindNPC", DisplayInfo = "Figure out some sort of game plan with the security officer in the %s shop.", Modifier = "loc", loc = "", Specifications = {"NPCType", "SecurityGuard"}},
	[3] = {Type = "LocateArea", DisplayInfo = "Head to the armory... quietly.", Quantity = 1, AreaLocations = {
		[1] = {}
	}},
	[4] = {Type = "CollectItem", DisplayInfo = "Talk to the shopkeeper. See if you can borrow something.", Item = "", ItemType = "NPC"},
	[5] = {Type = "DefeatEnemies", DisplayInfo = "Take out the munster.", Quantity = 1, Enemies = {}},
	[6] = {Type = "EscapeNotice", DisplayInfo = "RUN!!!!"},
	[7] = {Type = "FindNPC", DisplayInfo = "Well, that sure didn't do jack squat. Figure something else out.", Specifications = {"NPCType", "SecurityGuard"}},
	[8] = {Type = "LocateArea", DisplayInfo = "Head to the apothecary... even more quietly. That thing's angry now.", Quantity = 1, AreaLocations = {
		[1] ={}
	}},
	[9] = {Type = "CollectItem", DisplayInfo = "Bargain with this shopkeeper. They may be a bit... tougher.", Item = "", ItemType = "NPC"},
	[10.1] = {Type = "DefeatEnemies", DisplayInfo = "This should deal with the monster. Stun it, then take it out.", Quantity = 1, Enemies = {}},
	[10.2] = {Type = "ActivateItem", DisplayInfo = "Looks like the shopkeeper has to go... create a distraction.", Quantity = 1},
	[11.2] = {Type = "CollectItem", DisplayInfo = "Quick, steal the potion!!!", Quantity = 1, Item = ""},
	[12.2] = {Type = "DefeatEnemies", DisplayInfo = "Whew, that was close... now this should deal with the monster. Stun it, then take it out.", Quantity = 1, Enemies = {}}
}

MunsterMinus.RequiredShops = {"Armory", "Apothecary"} --An array of shops required for the scenario. The game will always spawn these first before randomizing shops.

return MunsterMinus