-- ToME - Tales of Maj'Eyal
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

newEntity{
	define_as = "BASE_SCROLL",
	slot = "INBELT", use_no_wear=true,
	type = "scroll", subtype="scroll",
	unided_name = "scroll", id_by_type = true,
	display = "?", color=colors.WHITE, image="object/scroll.png",
	encumber = 0.1,
	stacking = true,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	is_magic_device = true,
	fire_destroy = {{10,1}, {20,2}, {40,5}, {60,10}, {120,20}},
	desc = [[Magical scrolls can have wildly different effects! Most of them function better with a high Magic score]],
	egos = "/data/general/objects/egos/scrolls.lua", egos_chance = resolvers.mbonus(10, 5),
}

newEntity{
	define_as = "BASE_INFUSION",
	type = "scroll", subtype="infusion",
	unided_name = "infusion", id_by_type = true,
	display = "?", color=colors.WHITE, image="object/rune_green.png",
	encumber = 0.1,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	is_magic_device = true,
	fire_destroy = {{10,1}, {20,2}, {40,5}, {60,10}, {120,20}},
	desc = [[Natural infusions allow you to inscribe an infusion onto your body, granting you an on-demand ability.]],
	egos = "/data/general/objects/egos/infusions.lua", egos_chance = resolvers.mbonus(10, 5),
}

newEntity{
	define_as = "BASE_RUNE",
	type = "scroll", subtype="rune",
	unided_name = "rune", id_by_type = true,
	display = "?", color=colors.WHITE, image="object/rune_red.png",
	encumber = 0.1,
	use_sound = "actions/read",
	use_no_blind = true,
	use_no_silence = true,
	is_magic_device = true,
	fire_destroy = {{10,1}, {20,2}, {40,5}, {60,10}, {120,20}},
	desc = [[Magical runes allow you to inscribe a rune onto your body, granting you an on-demand ability.]],
	egos = "/data/general/objects/egos/runes.lua", egos_chance = resolvers.mbonus(10, 5),
}

newEntity{
	define_as = "BASE_LORE",
	type = "lore", subtype="lore", not_in_stores=true,
	unided_name = "scroll", identified=true,
	display = "?", color=colors.ANTIQUE_WHITE, image="object/scroll-lore.png",
	encumber = 0.1,
	desc = [[This parchement contains some lore.]],
}

newEntity{ base = "BASE_INFUSION",
	name = "healing infusion",
	level_range = {1, 50},
	rarity = 9,
	cost = 10,
	material_level = 1,

	inscription_data = {
		cooldown = resolvers.rngrange(4, 12),
		heal = resolvers.mbonus(300, 40),
		use_stat_mod = 2,
	},

	use_simple = { name="inscribe your skin with an infusion that allows you to randomly teleport.", use = function(self, who, inven, item)
		if who:setInscription(nil, "INFUSION:_HEALING", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_INFUSION",
	name = "wild infusion",
	level_range = {1, 50},
	rarity = 12,
	cost = 20,
	material_level = 1,

	inscription_data = resolvers.generic(function(e)
		return {
			cooldown = rng.range(10, 15),
			dur = rng.mbonus(4, 4, resolvers.mbonus_max_level),
			power = rng.mbonus(30, 20, resolvers.mbonus_max_level),
			use_stat_mod = 0.1,
			what = {
				poison = true,
				disease = rng.percent(40) and true or nil,
				curse = rng.percent(40) and true or nil,
				hex = rng.percent(40) and true or nil,
				magical = rng.percent(40) and true or nil,
				physical = rng.percent(40) and true or nil,
				mental = rng.percent(40) and true or nil,
			}
		}
	end),

	use_simple = { name="inscribe your skin with an infusion that allows you to cure yourself and reduce damage taken for a few turns.", use = function(self, who, inven, item)
		if who:setInscription(nil, "INFUSION:_WILD", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_INFUSION",
	name = "movement infusion",
	level_range = {10, 50},
	rarity = 9,
	cost = 30,
	material_level = 3,

	inscription_data = {
		cooldown = resolvers.rngrange(10, 15),
		dur = resolvers.mbonus(5, 2),
		use_stat_mod = 0.05,
	},

	use_simple = { name="inscribe your skin with an infusion that allows you to become immune to movement imparing effects.", use = function(self, who, inven, item)
		if who:setInscription(nil, "INFUSION:_MOVEMENT", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_INFUSION",
	name = "sun infusion",
	level_range = {1, 50},
	rarity = 9,
	cost = 10,
	material_level = 1,

	inscription_data = {
		cooldown = resolvers.rngrange(6, 12),
		range = resolvers.mbonus(5, 5),
		use_stat_mod = 0.05,
	},

	use_simple = { name="inscribe your skin with an infusion that allows you to channel the power of the sun to light the surrounding area and reveal stealthed creatures.", use = function(self, who, inven, item)
		if who:setInscription(nil, "INFUSION:_SUN", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_INFUSION",
	name = "strength infusion",
	level_range = {25, 50},
	rarity = 12,
	cost = 40,
	material_level = 3,

	inscription_data = {
		cooldown = resolvers.rngrange(20, 30),
		dur = resolvers.mbonus(7, 7),
		power = resolvers.mbonus(4, 4),
		use_stat_mod = 0.04,
	},

	use_simple = { name="inscribe your skin with an infusion that allows you to improve your physical stats for some turns.", use = function(self, who, inven, item)
		if who:setInscription(nil, "INFUSION:_STRENGTH", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_INFUSION",
	name = "will infusion",
	level_range = {25, 50},
	rarity = 12,
	cost = 40,
	material_level = 3,

	inscription_data = {
		cooldown = resolvers.rngrange(20, 30),
		dur = resolvers.mbonus(7, 7),
		power = resolvers.mbonus(4, 4),
		use_stat_mod = 0.04,
	},

	use_simple = { name="inscribe your skin with an infusion that allows you to improve your mental stats for some turns.", use = function(self, who, inven, item)
		if who:setInscription(nil, "INFUSION:_WILL", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "phase door rune",
	level_range = {1, 50},
	rarity = 9,
	cost = 10,
	material_level = 1,

	inscription_data = {
		cooldown = resolvers.rngrange(5, 9),
		range = resolvers.mbonus(10, 5),
		use_stat_mod = 0.07,
	},

	use_simple = { name="inscribe your skin with a rune that allows you to randomly teleport.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_PHASE_DOOR", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "controlled phase door rune",
	level_range = {35, 50},
	rarity = 14,
	cost = 50,
	material_level = 4,

	inscription_data = {
		cooldown = resolvers.rngrange(7, 12),
		range = resolvers.mbonus(6, 5),
		use_stat_mod = 0.05,
	},

	use_simple = { name="inscribe your skin with a rune that allows you to teleport in a directed manner over a short range.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_CONTROLLED_PHASE_DOOR", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "teleportation rune",
	level_range = {10, 50},
	rarity = 9,
	cost = 10,
	material_level = 2,

	inscription_data = {
		cooldown = resolvers.rngrange(9, 14),
		range = resolvers.mbonus(100, 20),
		use_stat_mod = 1,
	},

	use_simple = { name="inscribe your skin with a rune that allows you to randomly teleport on a big range.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_TELEPORTATION", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "shielding rune",
	level_range = {12, 50},
	rarity = 9,
	cost = 20,
	material_level = 3,

	inscription_data = {
		cooldown = resolvers.rngrange(14, 24),
		dur = resolvers.mbonus(5, 3),
		power = resolvers.mbonus(400, 50),
		use_stat_mod = 2.3,
	},

	use_simple = { name="inscribe your skin with a rune that allows you to summon a protective shield.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_SHIELDING", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "invisibility rune",
	level_range = {18, 50},
	rarity = 12,
	cost = 40,
	material_level = 3,

	inscription_data = {
		cooldown = resolvers.rngrange(14, 24),
		dur = resolvers.mbonus(9, 4),
		power = resolvers.mbonus(8, 7),
		use_stat_mod = 0.08,
		nb_uses = resolvers.mbonus(7, 4),
	},

	use_simple = { name="inscribe your skin with a rune that allows you to become invisible for a few turns.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_INVISIBILITY", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "speed rune",
	level_range = {23, 50},
	rarity = 12,
	cost = 40,
	material_level = 3,

	inscription_data = {
		cooldown = resolvers.rngrange(14, 24),
		dur = resolvers.mbonus(4, 3),
		power = resolvers.mbonus(30, 30),
		use_stat_mod = 0.3,
		nb_uses = resolvers.mbonus(7, 4),
	},

	use_simple = { name="inscribe your skin with a rune that allows you to increase your global speed for a few turns.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_SPEED", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}

newEntity{ base = "BASE_RUNE",
	name = "vision rune",
	level_range = {15, 50},
	rarity = 10,
	cost = 30,
	material_level = 2,

	inscription_data = {
		cooldown = resolvers.rngrange(20, 30),
		range = resolvers.mbonus(10, 8),
		dur = resolvers.mbonus(20, 12),
		power = resolvers.mbonus(20, 10),
		use_stat_mod = 0.14,
	},

	use_simple = { name="inscribe your skin with a rune that allows you to see invisible a some turns and map the area surrounding you.", use = function(self, who, inven, item)
		if who:setInscription(nil, "RUNE:_VISION", self.inscription_data, true, true, {obj=self, inven=inven, item=item}) then
			return "destroy", true
		end
	end}
}
