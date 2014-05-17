-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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
	name = "Spacetime Tuning",
	type = {"chronomancy/other", 1},
	points = 1,
	tactical = { PARADOX = 2 },
	no_npc_use = true,
	no_unlearn_last = true,
	on_learn = function(self, t)
		if not self.preferred_paradox then self.preferred_paradox = 0 end
	end,
	on_unlearn = function(self, t)
		if self.preferred_paradox then self.preferred_paradox = nil end
	end,
	getDuration = function(self, t) 
		local power = math.floor(self:combatSpellpower()/10)
		return math.max(20 - power, 10)
	end,
	action = function(self, t)
		function getQuantity(title, prompt, default, min, max)
			local result
			local co = coroutine.running()

			local dialog = engine.dialogs.GetQuantity.new(
				title,
				prompt,
				default,
				max,
				function(qty)
					result = qty
					coroutine.resume(co)
				end,
				min)
			dialog.unload = function(dialog)
				if not dialog.qty then coroutine.resume(co) end
			end

			game:registerDialog(dialog)
			coroutine.yield()
			return result
		end

		local paradox = getQuantity(
			"Spacetime Tuning",
			"What's your preferred paradox level?",
			math.floor(self.paradox))
		if not paradox then return end
		if paradox > 1000 then paradox = 1000 end
		self.preferred_paradox = paradox
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local preference = self.preferred_paradox
		local multiplier = getParadoxModifier(self, pm)*100
		local _, will_modifier = self:getModifiedParadox()
		local after_will = self:getModifiedParadox()
		local _, failure = self:paradoxFailChance()
		local _, anomaly = self:paradoxAnomalyChance()
		local _, backfire = self:paradoxBackfireChance()
		return ([[Use to set your preferred Paradox.  While resting you'll adjust your Paradox towards this number over %d turns.
		The time it takes you to adjust your Paradox scales down with your Spellpower to a minimum of 10 turns.
		
		Preferred Paradox           : %d
		Paradox effect multiplier   : %d%%
		Willpower failure modifier  : %d
		Paradox after Willpower     : %d
		Current Failure chance      : %d%%
		Current Anomaly chance      : %d%%
		Current Backfire chance     : %d%%]]):format(duration, preference, multiplier, will_modifier, after_will, failure, anomaly, backfire)
	end,
}

newTalent{
	name = "Precognition",
	type = {"chronomancy/chronomancy",1},
	require = temporal_req1,
	points = 5,
	paradox = 5,
	cooldown = 10,
	no_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 14)) end,
	action = function(self, t)
		if checkTimeline(self) == true then
			return
		end
		game:playSoundNear(self, "talents/spell_generic")
		self:setEffect(self.EFF_PRECOGNITION, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[You peer into the future, allowing you to explore your surroundings for %d turns.  When Precognition expires, you'll return to the point in time you first cast the spell.  Dying with precognition active will end the spell prematurely.
		This spell splits the timeline.  Attempting to use another spell that also splits the timeline while this effect is active will be unsuccessful.
		Splitting the timeline is difficult, you will only be protected after the current turn ends.]]):format(duration)
	end,
}

newTalent{
	name = "Foresight",
	type = {"chronomancy/chronomancy",2},
	mode = "passive",
	require = temporal_req2,
	points = 5,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 13)) end,
	do_precog_foresight = function(self, t)
		self:magicMap(t.getRadius(self, t))
		self:setEffect(self.EFF_SENSE, 1, {
			range = t.getRadius(self, t),
			actor = 1,
			object = 1,
			trap = 1,
		})
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		return ([[When the duration of your Precognition expires, you'll be given a vision of your surroundings, sensing terrain, enemies, objects, and traps in a %d radius.]]):
		format(radius)
	end,
}

newTalent{
	name = "Moment of Prescience",
	type = {"chronomancy/chronomancy", 3},
	require = temporal_req3,
	points = 5,
	paradox = 10,
	cooldown = 18,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 18, 3, 10.5)) end, -- Limit < 18
	getPower = function(self, t) return self:combatTalentScale(t, 4, 15) end, -- Might need a buff
	tactical = { BUFF = 4 },
	no_energy = true,
	no_npc_use = true,
	action = function(self, t)
		local power = t.getPower(self, t)
		-- check for Spin Fate
		local eff = self:hasEffect(self.EFF_SPIN_FATE)
		if eff then
			local bonus = math.max(0, (eff.cur_save_bonus or eff.save_bonus) / 2)
			power = power + bonus
		end

		self:setEffect(self.EFF_PRESCIENCE, t.getDuration(self, t), {power=power})
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[You pull your awareness fully into the moment, increasing your stealth detection, see invisibility, defense, and accuracy by %d for %d turns.
		If you have Spin Fate active when you cast this spell, you'll gain a bonus to these values equal to 50%% of your spin.
		This spell takes no time to cast.]]):
		format(power, duration)
	end,
}

newTalent{
	name = "Spin Fate",
	type = {"chronomancy/chronomancy", 4},
	require = temporal_req4,
	mode = "passive",
	points = 5,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	getSaveBonus = function(self, t) return self:combatTalentScale(t, 1, 5, 0.75) end,
	do_spin_fate = function(self, t, type)
		local save_bonus = t.getSaveBonus(self, t)
	
		if type ~= "defense" then
			if not self:hasEffect(self.EFF_SPIN_FATE) then
				game:playSoundNear(self, "talents/spell_generic")
			end
			self:setEffect(self.EFF_SPIN_FATE, t.getDuration(self, t), {max_bonus = t.getSaveBonus(self, t) * 5, save_bonus = t.getSaveBonus(self, t)})
		end
		
		return true
	end,
	info = function(self, t)
		local save = t.getSaveBonus(self, t)
		local duration = t.getDuration(self, t)
		return ([[You've learned to make minor corrections in how future events unfold.  Each time you make a saving throw, all your saves are increased by %d (stacking up to a maximum increase of %d for each value).
		The effect will last %d turns, but the duration will refresh everytime it's reapplied.]]):
		format(save, save * 5, duration)
	end,
}