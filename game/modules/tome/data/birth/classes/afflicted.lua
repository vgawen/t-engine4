-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newBirthDescriptor{
	type = "class",
	name = "Afflicted",
	locked = function() return profile.mod.allow_build.afflicted end,
	locked_desc = "Some walk in shadow, alone, unloved, unwanted. What powers they wield may be mighty, but their names are forever cursed.",
	desc = {
		"Afflicted classes have been twisted by their association with evil forces.",
		"They can use these forces to their advantage, but at a cost...",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Cursed = "allow",
			Doomed = "allow",
		},
	},
	copy = {
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Cursed",
	locked = function() return profile.mod.allow_build.afflicted_cursed end,
	locked_desc = "Affliction can run to the soul, and hatred can fill one's entire being. Overcome someone else's hated curse to know its dreaded meaning.",
	desc = {
		"Through ignorance, greed or folly the Cursed served some dark design and are now doomed to pay for their sins.",
		"Their only master now is the hatred they carry for every living thing.",
		"Drawing strength from the death of all they encounter, the Cursed become terrifying combatants.",
		"Worse, any who approach the Cursed can be driven mad by their terrible aura.",
		"Their most important stats are: Strength and Willpower",
		"#GOLD#Stat modifiers:",
		"#LIGHT_BLUE# * +5 Strength, +0 Dexterity, +0 Constitution",
		"#LIGHT_BLUE# * +0 Magic, +4 Willpower, +0 Cunning",
	},
	stats = { wil=4, str=5, },
	talents_types = {
		["cursed/gloom"]={true, 0.0},
		["cursed/slaughter"]={true, 0.0},
		["cursed/endless-hunt"]={true, 0.0},
		["cursed/strife"]={true, 0.0},
		["cursed/cursed-form"]={true, 0.0},
		["cursed/fateful-aura"]={true, 0.0},
		["cursed/unyielding"]={true, 0.0},
		["technique/combat-training"]={true, 0.3},
		["cunning/survival"]={false, 0.0},
		["cursed/rampage"]={false, 0.0},
		["cursed/dark-figure"]={false, 0.0},
	},
	talents = {
		[ActorTalents.T_UNNATURAL_BODY] = 1,
		[ActorTalents.T_CURSED_TOUCH] = 1,
		[ActorTalents.T_GLOOM] = 1,
		[ActorTalents.T_SLASH] = 1,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.equip{ id=true,
			{type="weapon", subtype="battleaxe", name="iron battleaxe", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Doomed",
	locked = function() return profile.mod.allow_build.afflicted_doomed end,
	locked_desc = "In shaded places in unknown lands thou must overcome thyself and see thy doom.",
	desc = {
		"The Doomed are fallen mages who once wielded powerful magic wrought by ambition and dark bargains.",
		"They now possess only a twisted shadow of that power as they struggle to keep it from consuming them.",
		"Only time will tell if they can choose a new path or are doomed forever.",
		"The Doomed strike from behind a veil of darkness or a host of shadows.",
		"They feed upon their enemies as they unleash powerful forces and terrible punishments.",
		"Their most important stats are: Magic and Willpower",
		"#GOLD#Stat modifiers:",
		"#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +0 Constitution",
		"#LIGHT_BLUE# * +4 Magic, +4 Willpower, +0 Cunning",
	},
	stats = { wil=4, mag=4, },
	talents_types = {
		["cursed/dark-sustenance"]={true, 0.3},
		["cursed/force-of-will"]={true, 0.3},
		["cursed/punishments"]={true, 0.3},
		["cursed/shadows"]={true, 0.3},
		["cursed/darkness"]={true, 0.3},
		["cursed/primal-magic"]={true, 0.3},
		["cursed/cursed-form"]={true, 0.0},
		["cursed/fateful-aura"]={true, 0.0},
		["cunning/survival"]={false, 0.0},
		["cursed/dark-figure"]={false, 0.0},
	},
	talents = {
		[ActorTalents.T_UNNATURAL_BODY] = 1,
		[ActorTalents.T_CURSED_TOUCH] = 1,
		[ActorTalents.T_FEED] = 1,
		[ActorTalents.T_WILLFUL_STRIKE] = 1,
		[ActorTalents.T_CALL_SHADOWS] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equip{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
	},
}
