local Object = require "engine.Object"

newTalent{
	name = "Stone Skin",
	type = {"spell/earth", 1},
	mode = "sustained",
	points = 5,
	sustain_mana = 45,
	cooldown = 10,
	tactical = {
		DEFEND = 10,
	},
	activate = function(self, t)
		local power = 4 + self:combatSpellpower(0.03) * self:getTalentLevel(t)
		return {
			armor = self:addTemporaryValue("combat_armor", power),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_armor", p.armor)
		return true
	end,
	require = { stat = { mag=14 }, },
	info = function(self, t)
		return ([[The caster skin grows as hard as stone, granting %d bonus to armor.
		The bonus to armor will increase with the Magic stat]]):format(4 + self:combatSpellpower(0.03) * self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Dig",
	type = {"spell/earth",2},
	points = 5,
	mana = 40,
	range = 20,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), nolock=true}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		for i = 1, self:getTalentLevelRaw(t) do
			self:project(tg, x, y, DamageType.DIG, 1)
		end
		return true
	end,
	require = { stat = { mag=24 } },
	info = function(self, t)
		return ([[Digs up to %d grids into walls/trees/...]]):format(self:getTalentLevelRaw(t))
	end,
}

newTalent{
	name = "Strike",
	type = {"spell/earth",3},
	points = 5,
	mana = 18,
	cooldown = 6,
	tactical = {
		ATTACK = 10,
	},
	range = 20,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SPELLKNOCKBACK, self:spellCrit(8 + self:combatSpellpower(0.15) * self:getTalentLevel(t)))
		return true
	end,
	require = { stat = { mag=24 }, },
	info = function(self, t)
		return ([[Conjures up a fist of stone doing %0.2f physical damage and knocking the target back.
		The damage will increase with the Magic stat]]):format(8 + self:combatSpellpower(0.15) * self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Stone Wall",
	type = {"spell/earth",4},
	points = 5,
	cooldown = 12,
	mana = 70,
	range = 20,
	action = function(self, t)
		local x, y = self.x, self.y
		if self:getTalentLevel(t) >= 4 then
--			local tg = {type="bolt", range=self:getTalentRange(t), nolock=true}
--			local x, y = self:getTarget(tg)
--			if not x or not y then return nil end
--			for i = 1, self:getTalentLevelRaw(t) do
--				self:project(tg, x, y, DamageType.DIG, 1)
--			end
		end

		for i = -1, 1 do for j = -1, 1 do if game.level.map:isBound(x + i, y + j) then
			if not game.level.map:checkAllEntities(x + i, y + j, "block_move") then
				-- Ok some explanation, we make a new *OBJECT* because objects can have energy and act
				-- it stores the current terrain in "old_feat" and restores it when it expires
				-- We CAN set an object as a terrain because they are all entities

				local e = Object.new{
					old_feat = game.level.map(x + i, y + j, Map.TERRAIN),
					name = "summoned wall", image = "terrain/granite_wall1.png",
					display = '#', color_r=255, color_g=255, color_b=255,
					always_remember = true,
					block_move = true,
					block_sight = true,
					temporary = 2 + self:combatSpellpower(0.03) * self:getTalentLevel(t),
					x = x + i, y = y + j,
					canAct = function() return true end,
					act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						if self.temporary <= 0 then
						print("reseting", self.x, self.y, "to", self.old_feat, self.old_feat.name)
							game.level.map(self.x, self.y, Map.TERRAIN, self.old_feat)
							game:removeEntity(self)
							game.level.map:redisplay()
						end
					end
				}
				game:addEntity(e)
				print("setting", x+i, y+j, "to", game.level.map(x + i, y + j, Map.TERRAIN), game.level.map(x + i, y + j, Map.TERRAIN).name)
				game.level.map(x + i, y + j, Map.TERRAIN, e)
			end
		end end end

		return true
	end,
	require = { stat = { mag=34 } },
	info = function(self, t)
		return ([[Entombs yourself in a wall of stone for %d turns.]]):format(2 + self:combatSpellpower(0.03) * self:getTalentLevel(t))
	end,
}
