-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2018 Nicolas Casalini
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

newTalent{
	name = "Master Summoner",
	type = {"wild-gift/summon-advanced", 1},
	require = gifts_req_high1,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 20,
	cooldown = 10,
	range = 10,
	tactical = { BUFF = 2 },
	getCooldownReduction = function(self, t) return util.bound(self:getTalentLevelRaw(t) / 15, 0.05, 0.3) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local particle
		if self:addShaderAura("master_summoner", "awesomeaura", {time_factor=6200, alpha=0.7, flame_scale=0.8}, "particles_images/naturewings.png") then
			--
		elseif core.shader.active(4) then
			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {radius=1.1}, {type="flames", zoom=2, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
		else
			particle = self:addParticles(Particles.new("master_summoner", 1))
		end
		return {
			cd = self:addTemporaryValue("summon_cooldown_reduction", t.getCooldownReduction(self, t)),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("master_summoner")
		self:removeParticles(p.particle)
		self:removeTemporaryValue("summon_cooldown_reduction", p.cd)
		return true
	end,
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[Reduces the cooldown of all summons by %d%%.]]):
		format(cooldownred * 100)
	end,
}

newTalent{
	name = "Grand Arrival",
	type = {"wild-gift/summon-advanced", 2},
	require = gifts_req_high2,
	points = 5,
	mode = "passive",
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 3.7, "log")) end,
	effectDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	nbEscorts = function(self, t) return math.max(1,math.floor(self:combatTalentScale(t, 0.3, 2.7, "log"))) end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[While Master Summoner is active, when a creature you summon appears in the world, it will trigger a wild effect:
		- Ritch Flamespitter: Reduce fire resistance of all foes in a radius
		- Hydra: Generates a cloud of lingering poison
		- Rimebark: Reduce cold resistance of all foes in a radius
		- Fire Drake: Appears with %d fire drake hatchling(s)
		- War Hound: Reduce physical resistance of all foes in a radius
		- Jelly: Reduce nature resistance of all foes in a radius
		- Minotaur: Reduces movement speed of all foes in a radius
		- Stone Golem: Dazes all foes in a radius
		- Turtle: Heals all friendly targets in a radius
		- Spider: The spider is so hideous that foes around it are repelled
		Radius for effects is %d, and the duration of each lasting effect is %d turns.
		The effects improve with your Willpower.]]):format(t.nbEscorts(self, t), radius, t.effectDuration(self, t))
	end,
}

newTalent{
	name = "Nature's Cycle", short_name = "NATURE_CYCLE",
	type = {"wild-gift/summon-advanced", 3},
	require = gifts_req_high3,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return math.min(100, 30 + self:getTalentLevel(t) * 15) end,
	getReduction = function(self, t) return math.floor(self:combatTalentLimit(t, 5, 1, 3.1)) end, -- Limit < 5
	info = function(self, t)
		return ([[While Master Summoner is active, each new summon will reduce the remaining cooldown of Rage, Detonate and Wild Summon.
		%d%% chance to reduce them by %d.]]):format(t.getChance(self, t), t.getReduction(self, t))
	end,
}

newTalent{
	name = "Wild Summon",
	type = {"wild-gift/summon-advanced", 4},
	require = gifts_req_high4,
	points = 5,
	equilibrium = 9,
	cooldown = 25,
	range = 10,
	tactical = { BUFF = 2 },
	no_energy = true,
	on_pre_use = function(self, t, silent)
		return self:isTalentActive(self.T_MASTER_SUMMONER)
	end,
	duration = function(self, t) return  math.floor(self:combatTalentLimit(t, 25, 1, 5)) end, -- Limit <25
	action = function(self, t)
		self:setEffect(self.EFF_WILD_SUMMON, t.duration(self,t), {chance=100})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[For %d turn(s), you have 100%% chance that your summons appear as a wild version.
		Each turn the chance disminishes.
		Wild creatures have one more talent/power than the base versions:
		- Ritch Flamespitter: sends a blast of flames around it, knocking foes away
		- Hydra: Can disengage from melee range
		- Rimebark: Becomes more resistant to magic damage
		- Fire Drake: Can emit a powerful roar to silence its foes
		- War Hound: Can rage, inreasing its critical chance and armour penetration
		- Jelly: Can swallow foes that are low on life, regenerating your equilibrium
		- Minotaur: Can rush toward its target
		- Stone Golem: Melee blows can deal a small area of effect damage
		- Turtle: Can force all foes in a radius into melee range
		- Spider: Can project an insidious poison at its foes, reducing their healing
		This talent requires Master Summoner to be active to be used.]]):format(t.duration(self,t))
	end,
}
