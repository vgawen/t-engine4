-- ToME - Tales of Middle-Earth
-- Copyright (C) 2009, 2010 Nicolas Casalini
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

load("/data/general/npcs/faeros.lua")
load("/data/general/npcs/fire_elemental.lua")
load("/data/general/npcs/molten_golem.lua")
load("/data/general/npcs/fire-drake.lua")

local Talents = require("engine.interface.ActorTalents")

newEntity{
	define_as = "BASE_NPC_SUNWALL_DEFENDER",
	type = "humanoid", subtype = "human",
	display = "p", color=colors.WHITE,
	faction = "sunwall",

	combat = { dam=resolvers.rngavg(1,2), atk=2, apr=0, dammod={str=0.4} },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
	lite = 3,

	life_rating = 17,
	rank = 2,
	size_category = 3,

	open_door = true,

	autolevel = "warriormage",
	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	energy = { mod=1 },
	stats = { str=12, dex=8, mag=6, con=10 },
}

newEntity{ base = "BASE_NPC_SUNWALL_DEFENDER", define_as = "SUN_PALADIN_DEFENDER",
	name = "human sun-paladin", color=colors.GOLD,
	desc = [[A human in a shiny plate armour.]],
	level_range = {70, nil}, exp_worth = 1,
	rank = 3,
	positive_regen = 10,
	life_regen = 5,
	max_life = resolvers.rngavg(140,170),
	resolvers.equip{
		{type="weapon", subtype="mace", autoreq=true},
		{type="armor", subtype="shield", autoreq=true},
		{type="armor", subtype="massive", autoreq=true},
	},
	resolvers.talents{
		[Talents.T_MASSIVE_ARMOUR_TRAINING]=5,
		[Talents.T_CHANT_OF_FORTRESS]=5,
		[Talents.T_SEARING_LIGHT]=4,
		[Talents.T_MARTYRDOM]=4,
		[Talents.T_WEAPON_OF_LIGHT]=4,
		[Talents.T_FIREBEAM]=4,
		[Talents.T_WEAPON_COMBAT]=10,
		[Talents.T_HEALING_LIGHT]=4,
	},
	on_added = function(self)
		self.energy.value = game.energy_to_act self:useTalent(self.T_WEAPON_OF_LIGHT)
		self.energy.value = game.energy_to_act self:useTalent(self.T_CHANT_OF_FORTRESS)
	end,
}

newEntity{ base = "BASE_NPC_SUNWALL_DEFENDER", define_as = "SUN_PALADIN_DEFENDER_RODMOUR",
	name = "High Sun-Paladin Rodmour", color=colors.VIOLET,
	desc = [[A human in a shiny plate armour.]],
	level_range = {70, nil}, exp_worth = 1,
	rank = 3,
	positive_regen = 10,
	life_regen = 5,
	max_life = resolvers.rngavg(240,270),
	resolvers.equip{
		{type="weapon", subtype="mace", autoreq=true},
		{type="armor", subtype="shield", autoreq=true},
		{type="armor", subtype="massive", autoreq=true},
	},
	resolvers.talents{
		[Talents.T_MASSIVE_ARMOUR_TRAINING]=5,
		[Talents.T_CHANT_OF_FORTRESS]=5,
		[Talents.T_SEARING_LIGHT]=5,
		[Talents.T_MARTYRDOM]=5,
		[Talents.T_WEAPON_OF_LIGHT]=5,
		[Talents.T_FIREBEAM]=5,
		[Talents.T_WEAPON_COMBAT]=10,
		[Talents.T_HEALING_LIGHT]=5,
	},
	on_added = function(self)
		self.energy.value = game.energy_to_act self:useTalent(self.T_WEAPON_OF_LIGHT)
		self.energy.value = game.energy_to_act self:useTalent(self.T_CHANT_OF_FORTRESS)
		self:doEmote("Go "..game.player.name.."! We will hold the line!", 150)
	end,
}

newEntity{
	define_as = "BASE_NPC_ORC_ATTACKER",
	type = "humanoid", subtype = "orc",
	display = "o", color=colors.UMBER,
	faction = "orc-pride",

	combat = { dam=resolvers.rngavg(5,12), atk=2, apr=6, physspeed=2 },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
	infravision = 20,
	lite = 2,

	life_rating = 11,
	rank = 2,
	size_category = 3,

	open_door = true,

	autolevel = "warrior",
	ai = "dumb_talented_simple", ai_state = { ai_target="mount_doom_target", talent_in=2, },
	energy = { mod=1 },
	stats = { str=20, dex=8, mag=6, con=16 },
}

newEntity{ base = "BASE_NPC_ORC_ATTACKER", define_as = "URUK-HAI_ATTACK",
	name = "uruk-hai", color=colors.DARK_RED,
	desc = [[A fierce soldier-orc.]],
	level_range = {42, nil}, exp_worth = 1,
	max_life = resolvers.rngavg(120,140),
	life_rating = 8,
	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true},
	},
	combat_armor = 10, combat_def = 10,
	resolvers.talents{
		[Talents.T_SUNDER_ARMOUR]=5,
		[Talents.T_CRUSH]=4,
		[Talents.T_RUSH]=4,
		[Talents.T_WEAPON_COMBAT]=4,
	},
	on_added = function(self)
		game.level.nb_attackers = (game.level.nb_attackers or 0) + 1
	end,
	on_die = function(self)
		game.level.nb_attackers = game.level.nb_attackers - 1
	end,
}


newEntity{
	define_as = "ALATAR",
	type = "humanoid", subtype = "istari",
	name = "Alatar the Blue",
	display = "@", color=colors.AQUAMARINE,
	faction = "blue-wizards",

	desc = [[Lost to the memory of the West, the Blue Wizards have setup in the Far East, slowly growing corrupt. Now they must be stopped.]],
	level_range = {70, 70}, exp_worth = 15,
	max_life = 1000, life_rating = 36, fixed_rating = true,
	max_mana = 10000,
	mana_regen = 10,
	rank = 5,
	size_category = 3,
	stats = { str=40, dex=60, cun=60, mag=30, con=40 },
	inc_damage = {all=-70},
	invulnerable = 1,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	resolvers.equip{
		{type="weapon", subtype="staff", ego_chance=100, autoreq=true},
		{type="armor", subtype="cloth", ego_chance=100, autoreq=true},
	},
	resolvers.drops{chance=100, nb=10, {ego_chance=100} },

	resolvers.talents{
		[Talents.T_FLAME]=5,
		[Talents.T_FREEZE]=5,
		[Talents.T_LIGHTNING]=5,
		[Talents.T_MANATHRUST]=5,
		[Talents.T_INFERNO]=5,
		[Talents.T_FLAMESHOCK]=5,
		[Talents.T_STONE_SKIN]=5,
		[Talents.T_STRIKE]=5,
		[Talents.T_HEAL]=5,
		[Talents.T_REGENERATION]=5,
		[Talents.T_ILLUMINATE]=5,
		[Talents.T_QUICKEN_SPELLS]=5,
		[Talents.T_SPELL_SHAPING]=5,
		[Talents.T_ARCANE_POWER]=5,
		[Talents.T_METAFLOW]=5,
		[Talents.T_PHASE_DOOR]=5,
		[Talents.T_ESSENCE_OF_SPEED]=5,
	},

	autolevel = "caster",
	ai = "dumb_talented_simple", ai_state = { talent_in=1, ai_move="move_astar" },

	on_acquire_target = function(self, who)
		self:doEmote("Damn you, you only postpone your death! Fyrk!", 60)
		game.player:hasQuest("mount-doom"):start_fyrk()
		game.player:hasQuest("mount-doom"):setStatus(engine.Quest.COMPLETED, "stopped")
	end,
}

newEntity{
	define_as = "PALLANDO",
	type = "humanoid", subtype = "istari",
	name = "Pallando the Blue",
	display = "@", color=colors.LIGHT_BLUE,
	faction = "blue-wizards",

	desc = [[Lost to the memory of the West, the Blue Wizards have setup in the Far East, slowly growing corrupt. Now they must be stopped.]],
	level_range = {70, 70}, exp_worth = 15,
	max_life = 1000, life_rating = 36, fixed_rating = true,
	max_mana = 10000,
	mana_regen = 10,
	rank = 5,
	size_category = 3,
	stats = { str=40, dex=60, cun=60, mag=30, con=40 },
	inc_damage = {all=-70},
	invulnerable = 1,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	resolvers.equip{
		{type="weapon", subtype="staff", ego_chance=100, autoreq=true},
		{type="armor", subtype="cloth", ego_chance=100, autoreq=true},
	},
	resolvers.drops{chance=100, nb=10, {ego_chance=100} },

	resolvers.talents{
		[Talents.T_FLAME]=5,
		[Talents.T_FREEZE]=5,
		[Talents.T_LIGHTNING]=5,
		[Talents.T_MANATHRUST]=5,
		[Talents.T_INFERNO]=5,
		[Talents.T_FLAMESHOCK]=5,
		[Talents.T_STONE_SKIN]=5,
		[Talents.T_STRIKE]=5,
		[Talents.T_HEAL]=5,
		[Talents.T_REGENERATION]=5,
		[Talents.T_ILLUMINATE]=5,
		[Talents.T_QUICKEN_SPELLS]=5,
		[Talents.T_SPELL_SHAPING]=5,
		[Talents.T_ARCANE_POWER]=5,
		[Talents.T_METAFLOW]=5,
		[Talents.T_PHASE_DOOR]=5,
		[Talents.T_ESSENCE_OF_SPEED]=5,
	},

	autolevel = "caster",
	ai = "dumb_talented_simple", ai_state = { talent_in=1, ai_move="move_astar" },
}

newEntity{ base = "BASE_NPC_FAEROS", define_as = "FYRK",
	name = "Fyrk, Faeros High Guard", color=colors.VIOLET,
	desc = [[Faeros are highly intelligent fire elementals, rarely seen outside volcanos they are probably not native to this world.
This one looks even nastier and looks toward you with what seems to be disdain. Flames swirly all around him.]],
	level_range = {35, nil}, exp_worth = 2,
	rank = 5,
	max_life = resolvers.rngavg(300,400), life_rating = 20, fixed_rating = true,
	combat_armor = 0, combat_def = 20,
	on_melee_hit = { [DamageType.FIRE] = resolvers.mbonus(30, 10), },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, NECK=1 },

	resolvers.equip{
		{type="jewelry", subtype="amulet", defined="FIERY_CHOKER"},
	},

	resolvers.talents{
		[Talents.T_FLAME]=4,
		[Talents.T_FIERY_HANDS]=5,
		[Talents.T_FLAMESHOCK]=5,
		[Talents.T_INFERNO]=5,
		[Talents.T_KNOCKBACK]=5,
		[Talents.T_STUN]=2,
	},

	blind_immune = 1,
	stun_immune = 1,
}
