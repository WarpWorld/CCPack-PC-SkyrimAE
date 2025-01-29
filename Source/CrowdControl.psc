scriptName CrowdControl extends ObjectReference

;-- Properties --------------------------------------
actorbase property DeerRef auto
miscobject property LockpickItem auto
actorbase property CenturionRef auto
leveledactor property BanditsRef auto
actorbase property WolfRef auto
Int[] property SpellsTarget auto
scroll[] property SCROLLS auto
weather property WeatherClear auto
sound property SpookySkel auto
actorbase property FrostAtronachRef auto
leveledactor property Horse auto
actorbase property SprigganRef auto
actorbase property BalgruufRef auto
actorbase property FrostTroll auto
String[] property LocationNames auto
ObjectReference property Location_Falkreath auto
potion property BakedPotatoRef auto
globalvariable property hour auto
weapon[] property DragonBone auto
actorbase property SheoRef auto
spell[] property Spells auto
ObjectReference property Location_Windhelm auto
weather property WeatherBlue auto
ObjectReference property Location_Solitude auto
ObjectReference property Location_Riverwood auto
actorbase property DogRef auto
actorbase property ChickenRef auto
leveledactor property BanditParty3 auto
actorbase property SeranaRef auto
ObjectReference property Location_Riften auto
spell property Fury auto
faction[] property Factions auto
actorbase property ShockAtronachRef auto
leveledactor property BanditParty5 auto
actorbase property RikkeRef auto
weather property WeatherStorm auto
String[] property SpellsName auto
actorbase property BearRef auto
actorbase property AelaRef auto
leveledactor property DraugrRef auto
spell[] property BuffSpells auto
actorbase property HagravenRef auto
actorbase property IceWraith auto
idle property NeutralIdle auto
potion property CheeseWheelPot auto
actorbase property MammothRef auto
miscobject property CheeseWheel auto
scroll[] property SpiderScrolls auto
weather property WeatherSnow auto
potion property PotatoRef auto
actorbase property DraugrOver auto
quest property IntroQuest auto
actorbase property CiceroRef auto
leveledactor[] property BanditParty auto
ObjectReference property Location_Whiterun auto
leveleditem property MagikaPotionRef auto
actorbase property MudcrabRef auto
ammo[] property Arrows auto
soulgem[] property Gems auto
actorbase property UlfricREF auto
miscobject[] property Junk auto
actorbase property MaiqRef auto
leveledactor property BanditParty2 auto
actorbase property CowRef auto
actorbase property MjollRef auto
miscobject[] property ItemList auto
leveleditem property LockpickRef auto
ObjectReference property Location_High_Hrothgar auto
leveledactor property WitchRef auto
faction property BanditFaction auto
actorbase property FlameAtronachRef auto
ObjectReference property AngryChickenRef auto
weather property WeatherGreen auto
leveleditem property HealthPotionRef auto
actorbase property GiantSpiderRef auto
ObjectReference property Location_Morthal auto
leveledactor property FrostAtronarch auto
leveleditem property RedAppleRef auto
faction property PoliceFaction auto
miscobject property GoldItem auto
actorbase property GoatRef auto
ObjectReference property Location_Markarth auto
leveleditem property CheeseWheelRef auto
leveleditem property GoldRef auto
ObjectReference property Location_Winterhold auto
leveledactor property BanditParty4 auto
actorbase property Guard auto
weather property WeatherRed auto
ObjectReference property Location_Dawnstar auto
leveledactor property FlameAtronarch auto
leveledactor property BanditParty1 auto
leveledactor property StormAtronarch auto
leveledactor property Skeletonref auto
leveledactor property LeveledDragonRef auto

;-- Variables ---------------------------------------
Bool jumpReduced
String lastState = ""
Actor player
ObjectReference launchMarker
Float jumpIncreasedBy
Bool canSpawn = true
Int lastCommandId = -1
Bool staminaInfinite
Int lastCommandType = -1
Float jumpReducedBy
Bool weatherOverride
Bool jumpIncreased

;-- Functions ---------------------------------------

function CC_Run() global native

String function CC_GetState() global native

String[] function CC_PopItem() global native

function CC_Reconnect() global native

Float function CC_GetFloatSetting(String section, String key) global native

Int function CC_GetItemCount() global native

function CC_ClearTimers() global native

Int function CC_GetIntSetting(String section, String key) global native

function CC_Respond(Int id, Int status, String message, Int miliseconds) global native

Int function CC_HasTimer(String command_name) global native

String function CC_Version() global native

race function GetRaceRef(String race_name)

	if race_name == "argonian"
		return race.GetRace("ArgonianRace")
	elseIf race_name == "breton"
		return race.GetRace("BretonRace")
	elseIf race_name == "darkelf"
		return race.GetRace("DarkElfRace")
	elseIf race_name == "highelf"
		return race.GetRace("HighElfRace")
	elseIf race_name == "imperial"
		return race.GetRace("ImperialRace")
	elseIf race_name == "khajiit"
		return race.GetRace("KhajiitRace")
	elseIf race_name == "nord"
		return race.GetRace("NordRace")
	elseIf race_name == "orc"
		return race.GetRace("OrcRace")
	elseIf race_name == "redguard"
		return race.GetRace("RedguardRace")
	elseIf race_name == "woodelf"
		return race.GetRace("WoodElfRace")
	endIf
	return none
endFunction

Bool function ShouldNotifyCommand()

	return CrowdControl.CC_GetIntSetting("General", "bEnableCommandNotify") == 1
endFunction

function ProcessCommand(Int id, String command, String viewer, Int type)

	Float del3
	Float del2
	Float del
	if command == "unbound"
		IntroQuest.CompleteAllObjectives()
		IntroQuest.CompleteQuest()
		self.Respond(id, 0, "", 0)
	elseIf command == "give_apple"
		player.AddItem(RedAppleRef as form, 5, false)
		self.Respond(id, 0, viewer + " gave you apples", 0)
	elseIf command == "give_potatos"
		player.AddItem(PotatoRef as form, 5, false)
		self.Respond(id, 0, viewer + " gave you potatos", 0)
	elseIf command == "give_bpotatos"
		player.AddItem(BakedPotatoRef as form, 1, false)
		self.Respond(id, 0, viewer + " gave you baked potatos", 0)
	elseIf command == "spawn_cheese_wheel"
		player.PlaceAtMe(CheeseWheelRef as form, 1, false, false)
		self.Respond(id, 0, viewer + " gave you a cheese wheel", 0)
	elseIf command == "give_health_potion"
		player.AddItem(HealthPotionRef as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a health potion", 0)
	elseIf command == "give_magika_potion"
		player.AddItem(MagikaPotionRef as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a magika potion", 0)
	elseIf command == "give_lockpicks"
		player.AddItem(LockpickRef as form, 5, false)
		self.Respond(id, 0, viewer + " gave you lockpicks", 0)
	elseIf command == "give_gold_10"
		player.AddItem(GoldRef as form, 10, false)
		self.Respond(id, 0, viewer + " gave you 10 gold", 0)
	elseIf command == "give_gold_100"
		player.AddItem(GoldRef as form, 100, false)
		self.Respond(id, 0, viewer + " gave you 100 gold", 0)
	elseIf command == "give_gold_1000"
		player.AddItem(GoldRef as form, 1000, false)
		self.Respond(id, 0, viewer + " gave you 1000 gold", 0)
	elseIf command == "marksman_up"
		Float val = game.GetPlayer().GetAV("Marksman")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Marksman", 1)
			self.Respond(id, 0, viewer + " increased your archery skill", 0)
		endIf
	elseIf command == "marksman_down"
		Float val = player.GetAV("Marksman")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Marksman", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your archery skill", 0)
		endIf
	elseIf command == "onehanded_up"
		Float val = game.GetPlayer().GetAV("OneHanded")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("OneHanded", 1)
			self.Respond(id, 0, viewer + " increased your one handed skill", 0)
		endIf
	elseIf command == "onehanded_down"
		Float val = player.GetAV("OneHanded")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("OneHanded", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your one handed skill", 0)
		endIf
	elseIf command == "twohanded_up"
		Float val = game.GetPlayer().GetAV("TwoHanded")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("TwoHanded", 1)
			self.Respond(id, 0, viewer + " increased your two handed skill", 0)
		endIf
	elseIf command == "twohanded_down"
		Float val = player.GetAV("TwoHanded")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("TwoHanded", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your two handed skill", 0)
		endIf
	elseIf command == "block_up"
		Float val = game.GetPlayer().GetAV("Block")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Block", 1)
			self.Respond(id, 0, viewer + " increased your block skill", 0)
		endIf
	elseIf command == "block_down"
		Float val = player.GetAV("Block")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Block", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your block skill", 0)
		endIf
	elseIf command == "smithing_up"
		Float val = game.GetPlayer().GetAV("Smithing")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Smithing", 1)
			self.Respond(id, 0, viewer + " increased your smithing skill", 0)
		endIf
	elseIf command == "smithing_down"
		Float val = player.GetAV("Smithing")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Smithing", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your smithing skill", 0)
		endIf
	elseIf command == "heavyarmor_up"
		Float val = game.GetPlayer().GetAV("HeavyArmor")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("HeavyArmor", 1)
			self.Respond(id, 0, viewer + " increased your heavy armor skill", 0)
		endIf
	elseIf command == "heavyarmor_down"
		Float val = player.GetAV("HeavyArmor")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("HeavyArmor", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your heavy armor skill", 0)
		endIf
	elseIf command == "lightarmor_up"
		Float val = game.GetPlayer().GetAV("LightArmor")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("LightArmor", 1)
			self.Respond(id, 0, viewer + " increased your light armor skill", 0)
		endIf
	elseIf command == "lightarmor_down"
		Float val = player.GetAV("LightArmor")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("LightArmor", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your light armor skill", 0)
		endIf
	elseIf command == "pickpocket_up"
		Float val = game.GetPlayer().GetAV("Pickpocket")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Pickpocket", 1)
			self.Respond(id, 0, viewer + " increased your pickpocket skill", 0)
		endIf
	elseIf command == "pickpocket_down"
		Float val = player.GetAV("Pickpocket")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Pickpocket", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your pickpocket skill", 0)
		endIf
	elseIf command == "lockpicking_up"
		Float val = game.GetPlayer().GetAV("LockPicking")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("LockPicking", 1)
			self.Respond(id, 0, viewer + " increased your lockpicking skill", 0)
		endIf
	elseIf command == "lockpicking_down"
		Float val = player.GetAV("LockPicking")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("LockPicking", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your lockpicking skill", 0)
		endIf
	elseIf command == "sneak_up"
		Float val = game.GetPlayer().GetAV("Sneak")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Sneak", 1)
			self.Respond(id, 0, viewer + " increased your sneak skill", 0)
		endIf
	elseIf command == "sneak_down"
		Float val = player.GetAV("Sneak")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Sneak", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your sneak skill", 0)
		endIf
	elseIf command == "alchemy_up"
		Float val = game.GetPlayer().GetAV("Alchemy")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Alchemy", 1)
			self.Respond(id, 0, viewer + " increased your alchemy skill", 0)
		endIf
	elseIf command == "alchemy_down"
		Float val = player.GetAV("Alchemy")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Alchemy", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your alchemy skill", 0)
		endIf
	elseIf command == "SpeechCraft_up"
		Float val = game.GetPlayer().GetAV("SpeechCraft")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("SpeechCraft", 1)
			self.Respond(id, 0, viewer + " increased your speech skill", 0)
		endIf
	elseIf command == "SpeechCraft_down"
		Float val = player.GetAV("SpeechCraft")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("SpeechCraft", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your speech skill", 0)
		endIf
	elseIf command == "Alteration_up"
		Float val = game.GetPlayer().GetAV("Alteration")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Alteration", 1)
			self.Respond(id, 0, viewer + " increased your alteration skill", 0)
		endIf
	elseIf command == "Alteration_down"
		Float val = player.GetAV("Alteration")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Alteration", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your alteration skill", 0)
		endIf
	elseIf command == "Conjuration_up"
		Float val = game.GetPlayer().GetAV("Conjuration")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Conjuration", 1)
			self.Respond(id, 0, viewer + " increased your conjuration skill", 0)
		endIf
	elseIf command == "Conjuration_down"
		Float val = player.GetAV("Conjuration")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Conjuration", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your conjuration skill", 0)
		endIf
	elseIf command == "Destruction_up"
		Float val = game.GetPlayer().GetAV("Destruction")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Destruction", 1)
			self.Respond(id, 0, viewer + " increased your destruction skill", 0)
		endIf
	elseIf command == "Destruction_down"
		Float val = player.GetAV("Destruction")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Destruction", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your destruction skill", 0)
		endIf
	elseIf command == "Illusion_up"
		Float val = game.GetPlayer().GetAV("Illusion")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Illusion", 1)
			self.Respond(id, 0, viewer + " increased your illusion skill", 0)
		endIf
	elseIf command == "Illusion_down"
		Float val = player.GetAV("Illusion")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Illusion", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your illusion skill", 0)
		endIf
	elseIf command == "Restoration_up"
		Float val = game.GetPlayer().GetAV("Restoration")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Restoration", 1)
			self.Respond(id, 0, viewer + " increased your restoration skill", 0)
		endIf
	elseIf command == "Restoration_down"
		Float val = player.GetAV("Restoration")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Restoration", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your restoration skill", 0)
		endIf
	elseIf command == "Enchanting_up"
		Float val = game.GetPlayer().GetAV("Enchanting")
		if val >= 99.0000
			self.Respond(id, 1, "Skill at max level", 0)
		else
			game.IncrementSkillBy("Enchanting", 1)
			self.Respond(id, 0, viewer + " increased your enchanting skill", 0)
		endIf
	elseIf command == "Enchanting_down"
		Float val = player.GetAV("Enchanting")
		if val <= 16.0000
			self.Respond(id, 1, "Skill at min level", 0)
		else
			player.SetAV("Enchanting", val - 1.00000)
			self.Respond(id, 0, viewer + " decreased your enchanting skill", 0)
		endIf
	elseIf command == "cheeserain"
		Int loop = 9
		while loop
			loop -= 1
			ObjectReference ref = game.GetPlayer().PlaceAtMe(CheeseWheelPot as form, 1, false, false)
		endWhile
		self.Respond(id, 0, viewer + " sent an explosion of cheese", 0)
	elseIf command == "take_lockpick"
		Int amount = game.GetPlayer().GetItemCount(LockpickItem as form)
		if amount > 0
			player.RemoveItem(LockpickItem as form, 1, false, none)
			self.Respond(id, 0, viewer + " took a lockpick from you", 0)
		else
			self.Respond(id, 1, "", 0)
		endIf
	elseIf command == "take_health_potion"
		Int amount = game.GetPlayer().GetItemCount(HealthPotionRef as form)
		if amount > 0
			player.RemoveItem(HealthPotionRef as form, 1, false, none)
			self.Respond(id, 0, viewer + " took a health potion from you", 0)
		else
			self.Respond(id, 1, "", 0)
		endIf
	elseIf command == "take_magicka_potion"
		Int amount = game.GetPlayer().GetItemCount(MagikaPotionRef as form)
		if amount > 0
			player.RemoveItem(MagikaPotionRef as form, 1, false, none)
			self.Respond(id, 0, viewer + " took a magicka potion from you", 0)
		else
			self.Respond(id, 1, "", 0)
		endIf
	elseIf command == "take_arrows"
		Int count = 32
		while count > 0
			Ammo target = Arrows[utility.RandomInt(0, Arrows.length - 1)]
			count -= 1
			Int amount = game.GetPlayer().GetItemCount(target as form)
			if amount >= 5
				player.RemoveItem(target as form, 5, false, none)
				self.Respond(id, 0, viewer + " took your arrows", 0)
				count = -1
			elseIf amount > 0
				player.RemoveItem(target as form, amount, false, none)
				self.Respond(id, 0, viewer + " took your arrows", 0)
				count = -1
			endIf
		endWhile
		if count == 0
			self.Respond(id, 1, "", 0)
		endIf
	elseIf command == "take_gold_10"
		Int amount = game.GetPlayer().GetItemCount(GoldItem as form)
		if amount >= 10
			player.RemoveItem(GoldItem as form, 10, false, none)
			self.Respond(id, 0, viewer + " took 10 gold from you", 0)
		else
			self.Respond(id, 1, "Not enough gold", 0)
		endIf
	elseIf command == "take_gold_100"
		Int amount = game.GetPlayer().GetItemCount(GoldItem as form)
		if amount >= 100
			player.RemoveItem(GoldItem as form, 100, false, none)
			self.Respond(id, 0, viewer + " took 100 gold from you", 0)
		else
			self.Respond(id, 1, "Not enough gold", 0)
		endIf
	elseIf command == "take_gold_1000"
		Int amount = game.GetPlayer().GetItemCount(GoldItem as form)
		if amount >= 1000
			player.RemoveItem(GoldItem as form, 1000, false, none)
			self.Respond(id, 0, viewer + " took 1000 gold from you", 0)
		else
			self.Respond(id, 1, "Not enough gold", 0)
		endIf
	elseIf command == "full_heal"
		Float heal = player.GetAVMax("health") - player.GetAV("health")
		if heal > 0 as Float
			player.RestoreAV("health", heal)
			self.Respond(id, 0, viewer + " fully healed you", 0)
		else
			self.Respond(id, 1, "Health at full", 0)
		endIf
	elseIf command == "to_ten_health"
		Float damage = player.GetAV("health") - player.GetAVMax("health") * 0.100000
		if damage > 0 as Float
			player.DamageAV("health", damage)
			self.Respond(id, 0, viewer + " sets your health to 10%", 0)
		else
			self.Respond(id, 1, "", 0)
		endIf
	elseIf command == "heal"
		Float miss = player.GetAVMax("health") - player.GetAV("health")
		Float heal = player.GetAVMax("health") * 0.100000
		if miss > 0 as Float
			player.RestoreAV("health", heal)
			self.Respond(id, 0, viewer + " healed you", 0)
		else
			self.Respond(id, 1, "Health at full", 0)
		endIf
	elseIf command == "damage"
		Float damage = player.GetAVMax("health") * 0.100000
		player.DamageAV("health", damage)
		self.Respond(id, 0, viewer + " damaged you", 0)
	elseIf command == "kill_player"
		player.Kill(none)
		self.Respond(id, 0, viewer + " killed the player", 0)
	elseIf command == "good_spell"
		self.CastRandomSpell(id, viewer, true)
	elseIf command == "bad_spell"
		if type == 1
			self.CastRandomSpell(id, viewer, false)
		else
			self.Respond(id, 0, "", 0)
		endIf
	elseIf command == "disable_crouch"
		if type == 1
			if CrowdControl.CC_HasTimer("disable_crouch")
				self.Respond(id, 3, "", 0)
			else
				game.DisablePlayerControls(false, false, false, false, true, false, false, false, 0)
				self.Respond(id, 4, viewer + " disabled crouch", 30000)
			endIf
		else
			game.EnablePlayerControls(false, false, false, false, true, false, false, true, 0)
			self.Respond(id, 0, "Crouch is restored", 0)
		endIf
	elseIf command == "destroy_left" || command == "destroy_right"
		Int hand = 0
		String hand_name = "left"
		if command == "destroy_right"
			hand = 1
			hand_name = "right"
		endIf
		Int itemType = player.GetEquippedItemType(hand)
		if itemType == 0
			self.Respond(id, 1, viewer + " tried to remove nothingness", 0)
		elseIf itemType == 9
			spell cur_spell = player.GetEquippedSpell(hand)
			player.RemoveSpell(cur_spell)
			if player.GetEquippedSpell(hand)
				self.Respond(id, 1, viewer + " could not removed spell " + cur_spell.GetName() + " from you", 0)
			else
				self.Respond(id, 0, viewer + " removed spell " + cur_spell.GetName() + " from you", 0)
			endIf
		elseIf itemType == 10
			armor cur_shield = player.GetEquippedShield()
			player.RemoveItem(cur_shield as form, 1, false, none)
			self.Respond(id, 0, viewer + " destroyed your shield", 0)
		else
			weapon cur_weapon = player.GetEquippedWeapon(hand == 0)
			player.RemoveItem(cur_weapon as form, 1, false, none)
			self.Respond(id, 0, viewer + " destroyed your weapon in " + hand_name + " hand", 0)
		endIf
	elseIf command == "drop_left" || command == "drop_right"
		Int hand = 0
		String hand_name = "left"
		if command == "drop_right"
			hand = 1
			hand_name = "right"
		endIf
		Int itemtype = player.GetEquippedItemType(hand)
		if itemtype == 0
			self.Respond(id, 2, "", 0)
		elseIf itemtype == 9
			spell cur_spell = player.GetEquippedSpell(hand)
			player.UnequipSpell(cur_spell, hand)
			self.Respond(id, 0, viewer + " unequipped spell " + cur_spell.GetName() + " from you", 0)
		elseIf itemtype == 10
			armor cur_shield = player.GetEquippedShield()
			player.UnequipItem(cur_shield as form, false, true)
			self.Respond(id, 0, viewer + " unequipped your shield", 0)
		else
			weapon cur_weapon = player.GetEquippedWeapon(hand == 0)
			player.UnequipItem(cur_weapon as form, false, true)
			self.Respond(id, 0, viewer + " unequipped your weapon in " + hand_name + " hand", 0)
		endIf
	elseIf command == "increase_damage"
		if type == 1
			if CrowdControl.CC_HasTimer("increase_damage") as Bool || CrowdControl.CC_HasTimer("decrease_damage") as Bool
				self.Respond(id, 3, "", 0)
			else
				BuffSpells[1].Cast(self as ObjectReference, self as ObjectReference)
				self.Respond(id, 4, viewer + " increased damage", 30000)
			endIf
		else
			self.Respond(id, 0, "Damage increase has been reverted", 0)
		endIf
	elseIf command == "decrease_damage"
		if type == 1
			if CrowdControl.CC_HasTimer("decrease_damage") as Bool || CrowdControl.CC_HasTimer("increase_damage") as Bool
				self.Respond(id, 3, "", 0)
			else
				BuffSpells[0].Cast(self as ObjectReference, self as ObjectReference)
				self.Respond(id, 4, viewer + " decreased damage", 30000)
			endIf
		else
			self.Respond(id, 0, "Damage decrease has been reverted", 0)
		endIf
	elseIf command == "increase_speed"
		if type == 1
			if CrowdControl.CC_HasTimer("increase_speed") as Bool || CrowdControl.CC_HasTimer("decrease_speed") as Bool || CrowdControl.CC_HasTimer("freeze") as Bool
				self.Respond(id, 3, "", 0)
			else
				BuffSpells[3].Cast(self as ObjectReference, self as ObjectReference)
				player.AddItem(LockpickItem as form, 1, true)
				player.RemoveItem(LockpickItem as form, 1, true, none)
				self.Respond(id, 4, viewer + " increased speed", 31000)
			endIf
		else
			player.AddItem(LockpickItem as form, 1, true)
			player.RemoveItem(LockpickItem as form, 1, true, none)
			self.Respond(id, 0, "Speed increase has been reverted", 0)
		endIf
	elseIf command == "decrease_speed"
		if type == 1
			if CrowdControl.CC_HasTimer("decrease_speed") as Bool || CrowdControl.CC_HasTimer("increase_speed") as Bool || CrowdControl.CC_HasTimer("freeze") as Bool
				self.Respond(id, 3, "", 0)
			else
				BuffSpells[2].Cast(self as ObjectReference, self as ObjectReference)
				player.AddItem(LockpickItem as form, 1, true)
				player.RemoveItem(LockpickItem as form, 1, true, none)
				self.Respond(id, 4, viewer + " decreased speed", 31000)
			endIf
		else
			player.AddItem(LockpickItem as form, 1, true)
			player.RemoveItem(LockpickItem as form, 1, true, none)
			self.Respond(id, 0, "Speed decrease has been reverted", 0)
		endIf
	elseIf command == "freeze"
		if type == 1
			if CrowdControl.CC_HasTimer("freeze") as Bool || CrowdControl.CC_HasTimer("increase_speed") as Bool || CrowdControl.CC_HasTimer("decrease_speed") as Bool
				self.Respond(id, 3, "", 0)
			else
				game.GetPlayer().SetRestrained(true)
				self.Respond(id, 4, viewer + " froze you", 5000)
			endIf
		else
			game.GetPlayer().SetRestrained(false)
			game.EnableFastTravel(true)
			self.Respond(id, 0, "freeze ended", 0)
		endIf
	elseIf command == "increase_jump"
		if type == 1
			if CrowdControl.CC_HasTimer("increase_jump")
				self.Respond(id, 3, "", 0)
			else
				jumpIncreased = true
				self.Respond(id, 4, viewer + " increased jump", 30000)
			endIf
		else
			jumpIncreased = false
			self.Respond(id, 0, "Jump increase has been reverted", 0)
		endIf
	elseIf command == "decrease_jump"
		if type == 1
			if CrowdControl.CC_HasTimer("decrease_jump")
				self.Respond(id, 3, "", 0)
			else
				jumpReduced = true
				self.Respond(id, 4, viewer + " decreased jump", 30000)
			endIf
		else
			jumpReduced = false
			self.Respond(id, 0, "Jump decrease has been reverted", 0)
		endIf
	elseIf command == "infinite_stamina"
		if type == 1
			if CrowdControl.CC_HasTimer("infinite_stamina")
				self.Respond(id, 3, "", 0)
			else
				staminaInfinite = true
				player.ModAV("stamina", 10000 as Float)
				self.Respond(id, 4, viewer + " granted infinite stamina", 30000)
			endIf
		else
			staminaInfinite = false
			player.ModAV("stamina", -10000 as Float)
			player.RestoreAV("stamina", player.GetAVMax("stamina"))
			self.Respond(id, 0, "Stamina no longer infinite", 0)
		endIf
	elseIf command == "deplete_stamina"
		if CrowdControl.CC_HasTimer("infinite_stamina")
			self.Respond(id, 3, "", 0)
		else
			player.DamageAV("stamina", player.GetAV("stamina"))
			self.Respond(id, 0, viewer + " depleted your stamina", 0)
		endIf
	elseIf command == "time_midnight"
		hour.SetValue(0 as Float)
		self.Respond(id, 0, viewer + " changed the time", 0)
	elseIf command == "time_morning"
		hour.SetValue(6 as Float)
		self.Respond(id, 0, viewer + " changed the time", 0)
	elseIf command == "time_noon"
		hour.SetValue(12 as Float)
		self.Respond(id, 0, viewer + " changed the time", 0)
	elseIf command == "time_evening"
		hour.SetValue(18 as Float)
		self.Respond(id, 0, viewer + " changed the time", 0)
	elseIf command == "firstperson"
		Bool view = game.GetPlayer().GetAnimationVariableInt("IsFirstPerson") as Bool
		if view
			self.Respond(id, 3, "Already in first person", 0)
		else
			self.Respond(id, 0, viewer + " forced first person", 0)
			game.ForceFirstPerson()
		endIf
	elseIf command == "thirdperson"
		Bool view = game.GetPlayer().GetAnimationVariableInt("IsFirstPerson") as Bool
		if view
			self.Respond(id, 0, viewer + " forced third person", 0)
			game.ForceThirdPerson()
		else
			self.Respond(id, 3, "Already in third person", 0)
		endIf
	elseIf command == "blood"
		game.TriggerScreenBlood(25)
		self.Respond(id, 4, viewer + " splashed blood on the screen", 10000)
	elseIf command == "vibrate"
		if game.UsingGamepad()
			game.ShakeController(0.750000, 0.750000, 3.00000)
			self.Respond(id, 0, viewer + " vibrated your controller", 0)
		else
			self.Respond(id, 1, "Not using controller", 0)
		endIf
	elseIf command == "scroll_mayhem"
		scroll target = SCROLLS[0]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of mayhem", 0)
	elseIf command == "scroll_hysteria"
		scroll target = SCROLLS[1]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of hysteria", 0)
	elseIf command == "scroll_harmony"
		scroll target = SCROLLS[2]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of harmony", 0)
	elseIf command == "scroll_water"
		scroll target = SCROLLS[3]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of water breathing", 0)
	elseIf command == "scroll_cflame"
		scroll target = SCROLLS[4]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of conjure flame atronach", 0)
	elseIf command == "scroll_cfrost"
		scroll target = SCROLLS[5]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of conjure frost atronach", 0)
	elseIf command == "scroll_cstorm"
		scroll target = SCROLLS[6]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of conjure storm atronach", 0)
	elseIf command == "scroll_tflame"
		scroll target = SCROLLS[7]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of flame thrall", 0)
	elseIf command == "scroll_tfrost"
		scroll target = SCROLLS[8]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of frost thrall", 0)
	elseIf command == "scroll_tstorm"
		scroll target = SCROLLS[9]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of storm thrall", 0)
	elseIf command == "scroll_blizzard"
		scroll target = SCROLLS[10]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of blizzard", 0)
	elseIf command == "scroll_invis"
		scroll target = SCROLLS[11]
		target.Cast(game.GetPlayer() as ObjectReference, game.GetPlayer() as ObjectReference)
		self.Respond(id, 0, viewer + " used a scroll of invisibility", 0)
	elseIf command == "lightning"
		Actor source = game.FindClosestActorFromRef(game.GetPlayer() as ObjectReference, 25.0000)
		if source == none
			self.Respond(id, 1, "", 0)
		else
			scroll target = SCROLLS[12]
			target.Cast(source as ObjectReference, game.GetPlayer() as ObjectReference)
			self.Respond(id, 0, viewer + " called down lightning", 0)
		endIf
	elseIf command == "resetfactions"
		Int index = Factions.length
		self.Respond(id, 0, viewer + " reset your crimes", 0)
		player.StopCombatAlarm()
		while index
			index -= 1
			Factions[index].SetPlayerEnemy(false)
			Factions[index].SetPlayerExpelled(false)
			Factions[index].SetCrimeGold(0)
			Factions[index].SetCrimeGoldViolent(0)
		endWhile
	elseIf command == "dwemercurse"
		Int index = Junk.length
		while index
			index -= 1
			player.AddItem(Junk[index] as form, 5, false)
		endWhile
		self.Respond(id, 0, viewer + " gave you the Dwemer Curse", 0)
	elseIf command == "gem_petty"
		soulgem target = Gems[0]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a petty soul gem", 0)
	elseIf command == "gem_lesser"
		soulgem target = Gems[0]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a lesser soul gem", 0)
	elseIf command == "gem_common"
		soulgem target = Gems[0]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a common soul gem", 0)
	elseIf command == "gem_greater"
		soulgem target = Gems[0]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a greater soul gem", 0)
	elseIf command == "gem_grand"
		soulgem target = Gems[0]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a grand soul gem", 0)
	elseIf command == "give_arrows"
		Ammo target = Arrows[utility.RandomInt(0, Arrows.length - 1)]
		player.AddItem(target as form, 5, false)
		self.Respond(id, 0, viewer + " gave you arrows", 0)
	elseIf command == "give_dragonweap"
		weapon target = DragonBone[utility.RandomInt(0, DragonBone.length - 1)]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a dragonbone weapon", 0)
	elseIf command == "give_spider"
		scroll target = SpiderScrolls[utility.RandomInt(0, SpiderScrolls.length - 1)]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you an exploding spider scroll", 0)
	elseIf command == "jail"
		PoliceFaction.SendPlayerToJail(true, true)
		self.Respond(id, 0, viewer + " sent you to jail", 0)
	elseIf command == "launch_player"
		player.PlaceAtMe(launchMarker as form, 1, false, false)
		launchMarker.MoveTo(player as ObjectReference, 0 as Float, 0 as Float, player.GetPositionZ() - 50 as Float, true)
		launchMarker.PushActorAway(player, 20 as Float)
		self.Respond(id, 0, viewer + " launched you", 0)
	elseIf command == "give_dragonbone"
		miscobject target = ItemList[0]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a dragon bone", 0)
	elseIf command == "give_dragonscale"
		miscobject target = ItemList[1]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you dragon scales", 0)
	elseIf command == "give_diamond"
		miscobject target = ItemList[2]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you a diamond", 0)
	elseIf command == "give_iron"
		miscobject target = ItemList[3]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you an iron ingot", 0)
	elseIf command == "give_gold"
		miscobject target = ItemList[4]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you an gold ingot", 0)
	elseIf command == "give_silver"
		miscobject target = ItemList[5]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you an silver ingot", 0)
	elseIf command == "give_steel"
		miscobject target = ItemList[6]
		player.AddItem(target as form, 1, false)
		self.Respond(id, 0, viewer + " gave you an steel ingot", 0)
	elseIf command == "launch_player_2"
		player.PlaceAtMe(launchMarker as form, 1, false, false)
		launchMarker.MoveTo(player as ObjectReference, 0 as Float, 0 as Float, player.GetPositionZ() - 50 as Float, true)
		launchMarker.PushActorAway(player, 50 as Float)
		self.Respond(id, 0, viewer + " launched you", 0)
	elseIf command == "launch_player_3"
		player.PlaceAtMe(launchMarker as form, 1, false, false)
		launchMarker.MoveTo(player as ObjectReference, 0 as Float, 0 as Float, player.GetPositionZ() - 50 as Float, true)
		launchMarker.PushActorAway(player, 100 as Float)
		self.Respond(id, 0, viewer + " launched you", 0)
	elseIf command == "disable_fast_travel"
		if type == 1
			if CrowdControl.CC_HasTimer("disable_fast_travel")
				self.Respond(id, 3, "", 0)
			else
				game.EnableFastTravel(false)
				self.Respond(id, 4, viewer + " disabled fast travel", 30000)
			endIf
		else
			game.EnableFastTravel(true)
			self.Respond(id, 0, "Fast travel is restored", 0)
		endIf
	elseIf command == "random_fast_travel"
		if player.IsOverEncumbered()
			self.Respond(id, 1, "Can't fast travel while overencumbered", 0)
		else
			self.Respond(id, 0, viewer + " fast traveled you", 0)
			player.ForceRemoveRagdollFromWorld()
			String locationName = LocationNames[utility.RandomInt(0, LocationNames.length - 1)]
			ObjectReference locationObject = self.get_fast_travel_object(locationName)
			game.FastTravel(locationObject)
			if self.ShouldNotifyCommand()
				debug.Notification(viewer + " random fast traveled you to " + locationName)
			endIf
		endIf
	elseIf stringutil.Find(command, "fast_travel_", 0) == 0
		String locationname = stringutil.Substring(command, 12, 0)
		ObjectReference locationobject = self.get_fast_travel_object(locationname)
		if player.IsOverEncumbered()
			self.Respond(id, 1, "Can't fast travel while overencumbered", 0)
		elseIf locationobject == none
			self.Respond(id, 2, viewer + " sent invalid fast travel command \"" + command + "\"", 0)
		else
			self.Respond(id, 0, viewer + " fast traveled you to " + locationname, 0)
			player.ForceRemoveRagdollFromWorld()
			game.FastTravel(locationobject)
			if self.ShouldNotifyCommand()
				debug.Notification(viewer + " fast traveled you to " + locationname)
			endIf
		endIf
	elseIf stringutil.Find(command, "spawn_", 0) == 0
		String spawnName = stringutil.Substring(command, 6, 0)
		if !canSpawn
			self.Respond(id, 3, "", 0)
		else
			leveledactor spawn = self.GetSpawnRef(spawnName)
			if spawn == none
				self.Respond(id, 2, viewer + " tried spawning invalid actor \"" + spawnName + "\"", 0)
			else
				ObjectReference ref = self.PlaceAtMe(spawn as form, 1, false, false)
				if spawnName == "skeleton"
					Int r = utility.RandomInt(1, 50)
					if r == 24 || viewer == "CrowdControl" || viewer == "dtothefourth"
						SpookySkel.Play(player as ObjectReference)
					endIf
				endIf
				if spawnName == "tinydragon"
					ref.SetScale(0.200000)
				endIf
				if spawnName == "bandits"
					self.PlaceAtMe(BanditParty[0] as form, 1, false, false)
					self.PlaceAtMe(BanditParty[1] as form, 1, false, false)
					self.PlaceAtMe(BanditParty[2] as form, 1, false, false)
					self.PlaceAtMe(BanditParty[3] as form, 1, false, false)
				endIf
				self.Respond(id, 0, viewer + " spawned a " + spawnName, 0)
				canSpawn = false
				utility.Wait(3 as Float)
				canSpawn = true
			endIf
		endIf
	elseIf stringutil.Find(command, "weather_", 0) == 0
		String spawnname = stringutil.Substring(command, 8, 0)
		if type == 1
			if weather.GetSkyMode() != 3
				self.Respond(id, 3, "No sky", 0)
			elseIf weatherOverride == true
				self.Respond(id, 3, "Weather Already Active", 0)
			else
				weather spawn = self.GetWeatherRef(spawnname)
				if spawn == none
					self.Respond(id, 2, viewer + " tried starting invalid weather \"" + spawnname + "\"", 0)
				else
					spawn.ForceActive(true)
					weatherOverride = true
					self.Respond(id, 4, viewer + " made the weather " + spawnname, 30000)
				endIf
			endIf
		else
			weatherOverride = false
			weather.ReleaseOverride()
			self.Respond(id, 0, "Weather ended", 0)
		endIf
	elseIf stringutil.Find(command, "spawnb_", 0) == 0
		String spawnname = stringutil.Substring(command, 7, 0)
		if !canSpawn
			self.Respond(id, 3, "", 0)
		else
			actorbase spawn = self.GetSpawnRefB(spawnname)
			if spawn == none
				self.Respond(id, 2, viewer + " tried spawning invalid actor \"" + spawnname + "\"", 0)
			else
				Actor ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
				if spawnname == "mudcrab"
					ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
					ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
					ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
					ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
				endIf
				if spawnName == "chickenstorm"
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
                    ref = self.PlaceAtMe(spawn as form, 1, false, false) as Actor
                    ref.AddToFaction(BanditFaction)
				endIf
				self.Respond(id, 0, viewer + " spawned a " + spawnname, 0)
				canSpawn = false
				utility.Wait(3 as Float)
				canSpawn = true
			endIf
		endIf
	elseIf stringutil.Find(command, "race_", 0) == 0
		String raceName = stringutil.Substring(command, 5, 0)
		race PlayerRace = game.GetPlayer().GetRace()
		race raceref = self.GetRaceRef(raceName)
		if raceref == none
			self.Respond(id, 2, viewer + " tried setting invalid race \"" + raceName + "\"", 0)
		elseIf PlayerRace == raceref
			self.Respond(id, 1, "Player is already race \"" + raceName + "\"", 0)
		else
			game.GetPlayer().SetRace(raceref)
			self.Respond(id, 0, viewer + " changed your race to " + raceName, 0)
		endIf
	elseIf command == "_cc_coins_transaction"
		self.Respond(id, 0, viewer + " redeemed coins", 0)
	else
		self.Respond(id, 2, viewer + " sent invalid command \"" + command + "\"", 0)
	endIf
endFunction

function OnUpdate()

    
	String newState = CrowdControl.CC_GetState()
    
    if newState == ""
        lastState = ""
    endif

	if lastState == ""
		utility.Wait(2 as Float)

        string version = CrowdControl.CC_Version()
        if version == ""
            Debug.Notification("Could not connect to Crowd Control, make sure SKSE is running")
            Utility.Wait(2 as Float)
            return
        else
            if lastState == ""
                Debug.Notification("Crowd Control v" + version)
            endif
        endif

	endIf
	if newState != lastState && newState != ""
		debug.Notification("Crowd Control is " + newState)
		lastState = newState
	endIf
	if newState == "running"
		self.RunCommands()
	elseIf newState == "stopped"
		CrowdControl.CC_Run()
	else
		CrowdControl.CC_Reconnect()
	endIf
endFunction

function CastRandomSpell(Int id, String viewer, Bool good)

	if !good && CrowdControl.CC_HasTimer("bad_spell") as Bool
		self.Respond(id, 3, "", 0)
		return 
	endIf
	Int spellIndex = utility.RandomInt(0, Spells.length - 1)
	spell selectedSpell = Spells[spellIndex]
	Int spellTarget = SpellsTarget[spellIndex]
	Actor curTarget = game.GetPlayer().GetCombatTarget()
	if curTarget == none && (good && spellTarget == 1 || !good && spellTarget == 0)
		self.CastRandomSpell(id, viewer, good)
		return 
	endIf
	String spellName = selectedSpell.GetName()
	if stringutil.Substring(spellName, stringutil.GetLength(spellName) - 4, 0) == "self"
		spellName = stringutil.Substring(spellName, 0, stringutil.GetLength(spellName) - 4)
	endIf
	Int status = 0
	if !good
		status = 4
	endIf
	if good && spellTarget == 0 || !good && spellTarget == 1
		self.Respond(id, status, viewer + " casted " + spellName + " on player", 3000)
		selectedSpell.Cast(self as ObjectReference, self as ObjectReference)
	else
		self.Respond(id, status, viewer + " casted " + spellName + " on enemy", 3000)
		selectedSpell.Cast(curTarget as ObjectReference, curTarget as ObjectReference)
	endIf
endFunction

function PrintMessage(String _message)

	if self.ShouldNotifyCommand()
		debug.Notification(_message)
	endIf
endFunction

function RunCommands()

	if player.IsDead()
		return 
	endIf
	Int item_count = CrowdControl.CC_GetItemCount()
	if item_count > 0
		String[] item = CrowdControl.CC_PopItem()
		Int commandId = item[0] as Int
		Int commandType = item[3] as Int
		if !IntroQuest.IsCompleted() && IntroQuest.GetStage() <= 250 && item[1] != "unbound"
			self.Respond(commandId, 1, "Crowd Control stopped while player is bound", 0)
			return 
		endIf
	    if Game.EnablePlayerControls(false, true, false, false, false, false, false)
            Respond(commandId, 1, "Crowd Control stopped while player is bound", 0)
            return
        endif
        if !VampireQuest.IsCompleted() && VampireQuest.GetStage() < 250 && VampireQuest.GetStage() >= 100
            Respond(commandId, 1, "Crowd Control stopped during Diplomatic Immunity", 0)
            return
        endif	
		if lastCommandId == commandId && lastCommandType == commandType
			if commandType == 1
				self.Respond(commandId, 1, item[2] + " bugged command (1) \"" + item[1] + "\"", 0)
			else
				self.PrintMessage(item[2] + " bugged command (2) \"" + item[1] + "\"")
				self.Respond(commandId, 0, "", 0)
			endIf
		else
			lastCommandId = item[0] as Int
			lastCommandType = item[3] as Int
			self.ProcessCommand(item[0] as Int, item[1], item[2], item[3] as Int)
		endIf
		item_count -= 1
	endIf
endFunction

function Respond(Int id, Int status, String _message, Int miliseconds)

	CrowdControl.CC_Respond(id, status, _message, miliseconds)
	self.PrintMessage(_message)
endFunction

weather function GetWeatherRef(String spawn_name)

	if spawn_name == "clear"
		return WeatherClear
	elseIf spawn_name == "red"
		return WeatherRed
	elseIf spawn_name == "green"
		return WeatherGreen
	elseIf spawn_name == "blue"
		return WeatherBlue
	elseIf spawn_name == "storm"
		return WeatherStorm
	elseIf spawn_name == "snow"
		return WeatherSnow
	endIf
	return none
endFunction

; Skipped compiler generated GetState

function OnInit()
    lastState = ""
	lastCommandId = -1
	lastCommandType = -1
	self.RegisterForUpdate(0.500000)
endFunction

actorbase function GetSpawnRefB(String spawn_name)

	if spawn_name == "flameatronach"
		return FlameAtronachRef
	elseIf spawn_name == "frostatronach"
		return FrostAtronachRef
	elseIf spawn_name == "stormatronach"
		return ShockAtronachRef
	elseIf spawn_name == "mammoth"
		return MammothRef
	elseIf spawn_name == "giantspider"
		return GiantSpiderRef
	elseIf spawn_name == "spriggan"
		return SprigganRef
	elseIf spawn_name == "mudcrab"
		return MudcrabRef
	elseIf spawn_name == "dwarvencenturion"
		return CenturionRef
	elseIf spawn_name == "hagraven"
		return HagravenRef
	elseIf spawn_name == "balgruuf"
		return BalgruufRef
	elseIf spawn_name == "cow"
		return CowRef
	elseIf spawn_name == "chicken"
		return ChickenRef
	elseIf spawn_name == "chickenstorm"
		return ChickenRef
	elseIf spawn_name == "bear"
		return BearRef
	elseIf spawn_name == "deer"
		return DeerRef
	elseIf spawn_name == "dog"
		return DogRef
	elseIf spawn_name == "goat"
		return GoatRef
	elseIf spawn_name == "wolf"
		return WolfRef
	elseIf spawn_name == "sheo"
		return SheoRef
	elseIf spawn_name == "cicero"
		return CiceroRef
	elseIf spawn_name == "aela"
		return AelaRef
	elseIf spawn_name == "ulfric"
		return UlfricREF
	elseIf spawn_name == "serana"
		return SeranaRef
	elseIf spawn_name == "mjoll"
		return MjollRef
	elseIf spawn_name == "maiq"
		return MaiqRef
	elseIf spawn_name == "rikke"
		return RikkeRef
	elseIf spawn_name == "draugr_over"
		return DraugrOver
	elseIf spawn_name == "ice_wraith"
		return IceWraith
	elseIf spawn_name == "frost_troll"
		return FrostTroll
	endIf
	return none
endFunction

function OnPlayerLoadGame()

	CrowdControl.CC_ClearTimers()
	game.EnablePlayerControls(false, false, false, false, true, false, false, true, 0)
	game.EnableFastTravel(true)
	player = game.GetPlayer()
	if launchMarker == none
		launchMarker = player.PlaceAtMe(game.GetFormFromFile(52, "Skyrim.ESM"), 1, false, false)
	endIf
	if weatherOverride
		weatherOverride = false
		weather.ReleaseOverride()
	endIf
	if staminaInfinite as Bool || player.GetAV("stamina") > 7500 as Float
		staminaInfinite = false
		player.ModAV("stamina", -10000 as Float)
	endIf
	if player.GetAV("stamina") < -100 as Float
		player.ModAV("stamina", 10000 as Float)
	endIf
endFunction

leveledactor function GetSpawnRef(String spawn_name)

	if spawn_name == "dragon"
		return LeveledDragonRef
	elseIf spawn_name == "tinydragon"
		return LeveledDragonRef
	elseIf spawn_name == "witch"
		return WitchRef
	elseIf spawn_name == "Horse"
		return Horse
	elseIf spawn_name == "draugr"
		return DraugrRef
	elseIf spawn_name == "bandit"
		return BanditsRef
	elseIf spawn_name == "bandits"
		return BanditsRef
	elseIf spawn_name == "skeleton"
		return Skeletonref
	endIf
	return none
endFunction

; Skipped compiler generated GotoState

ObjectReference function get_fast_travel_object(String location_name)

	if location_name == "whiterun"
		return Location_Whiterun
	elseIf location_name == "riverwood"
		return Location_Riverwood
	elseIf location_name == "solitude"
		return Location_Solitude
	elseIf location_name == "dawnstar"
		return Location_Dawnstar
	elseIf location_name == "winterhold"
		return Location_Winterhold
	elseIf location_name == "windhelm"
		return Location_Windhelm
	elseIf location_name == "riften"
		return Location_Riften
	elseIf location_name == "falkreath"
		return Location_Falkreath
	elseIf location_name == "markarth"
		return Location_Markarth
	elseIf location_name == "morthal"
		return Location_Morthal
	elseIf location_name == "high_hrothgar"
		return Location_High_Hrothgar
	else
		return none
	endIf
endFunction
Quest Property VampireQuest  Auto  
