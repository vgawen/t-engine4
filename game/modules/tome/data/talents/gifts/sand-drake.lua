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

newTalent{
	name = "Swallow",
	type = {"wild-gift/sand-drake", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 20,
	range = 1,
	message = "@Source@ swallows its target!",
	tactical = {
		ATTACK = 10,
	},
	requires_target = true,
	no_npc_use = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if math.floor(core.fov.distance(self.x, self.y, x, y)) > 1 then return nil end

		if target.life * 100 / target.max_life > 10 + 3 * self:getTalentLevel(t) then
			return nil
		end

		if target:checkHit(self:combatAttackStr(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("instakill") then
			target:die(self)
			self:incEquilibrium(-target.level - 5)
			self:heal(target.level * 2 + 5)
		else
			game.logSeen(target, "%s resists!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		return ([[When your target is below %d%% life you can try to swallow it, killing it automatically and regaining life and equilibrium depending on its level.]]):
		format(10 + 3 * self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Quake",
	type = {"wild-gift/sand-drake", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = "@Source@ shakes the ground!",
	equilibrium = 4,
	cooldown = 30,
	tactical = {
		ATTACKAREA = 10,
	},
	range = 10,
	no_npc_use = true,
	action = function(self, t)
		local tg = {type="ball", range=0, friendlyfire=false, radius=2 + self:getTalentLevel(t) / 2, talent=t, no_restrict=true}
		self:project(tg, self.x, self.y, DamageType.PHYSKNOCKBACK, {dam=self:combatDamage() * 0.8, dist=4})
		self:doQuake(tg, self.x, self.y)
		return true
	end,
	info = function(self, t)
		return ([[You slam your foot onto the ground, shaking the area around you in a radius of %d, damaging them for %d and knocking back up to 4 titles away.
		The damage will increase with the Strength stat]]):format(2 + self:getTalentLevel(t) / 2, self:combatDamage() * 0.8)
	end,
}

newTalent{
	name = "Burrow",
	type = {"wild-gift/sand-drake", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 50,
	cooldown = 30,
	range = 10,
	action = function(self, t)
		self:setEffect(self.EFF_BURROW, 5 + self:getTalentLevel(t) * 3, {})
		return true
	end,
	info = function(self, t)
		return ([[Allows you to burrow into walls for %d turns.]]):format(5 + self:getTalentLevel(t) * 3)
	end,
}

newTalent{
	name = "Sand Breath",
	type = {"wild-gift/sand-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes sand!",
	tactical = {
		ATTACKAREA = 10,
	},
	range = function(self, t) return 4 + self:getTalentLevelRaw(t) end,
	direct_hit = true,
	requires_target = true,
	action = function(self, t)
		local tg = {type="cone", range=0, radius=self:getTalentRange(t), friendlyfire=false, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SAND, {dur=2+self:getTalentLevelRaw(t), dam=10 + self:getStr() * 0.3 * self:getTalentLevel(t)})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_earth", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[You breathe sand in a frontal cone. Any target caught in the area will take %0.2f physical damage and be blinded for %d turns.
		The damage will increase with the Strength stat]]):format(damDesc(self, DamageType.PHYSICAL, 10 + self:getStr() * 0.3 * self:getTalentLevel(t)), 2+self:getTalentLevelRaw(t))
	end,
}
