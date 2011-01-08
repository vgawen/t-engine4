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

require "engine.class"
local Map = require "engine.Map"

module(..., package.seeall, class.make)

function _M:init()
	self.repo = {}
	self.repl = {}
end

function _M:getTile(name)
	if not name then return end

	if type(name) == "table" then
		local n = name[1]
		if rng.percent(name[2]) then n = n..rng.range(name[3], name[4]) end
		name = n
	end

	if self.repo[name] then return self.repo[name]
	else
		self.repo[name] = game.zone:makeEntityByName(game.level, "terrain", name)
		return self.repo[name]
	end
end

function _M:replace(i, j, g)
	if g then
		self.repl[#self.repl+1] = {i, j, g}
	end
end

function _M:postProcessLevelTiles(level)
	for i = 0, level.map.w - 1 do for j = 0, level.map.h - 1 do
		local g = level.map(i, j, Map.TERRAIN)
		if g and Map.tiles.nicer_tiles and g.nice_tiler then
			self["niceTile"..g.nice_tiler.method:capitalize()](self, level, i, j, g, g.nice_tiler)
		end
	end end

	for i = 1, #self.repl do
		local r = self.repl[i]
		level.map(r[1], r[2], Map.TERRAIN, r[3])
	end
end

--- Make walls have a pseudo 3D effect
function _M:niceTileWall3d(level, i, j, g, nt)
	local s = level.map:checkEntity(i, j, Map.TERRAIN, "block_move") and true or false
	local gn = level.map:checkEntity(i, j-1, Map.TERRAIN, "block_move") and true or false
	local gs = level.map:checkEntity(i, j+1, Map.TERRAIN, "block_move") and true or false
	local gw = level.map:checkEntity(i-1, j, Map.TERRAIN, "block_move") and true or false
	local ge = level.map:checkEntity(i+1, j, Map.TERRAIN, "block_move") and true or false

	local gnc = level.map:checkEntity(i, j-1, Map.TERRAIN, "block_move", {open_door=true}, false, true) and true or false
	local gsc = level.map:checkEntity(i, j+1, Map.TERRAIN, "block_move", {open_door=true}, false, true) and true or false

	if gs ~= s and gn ~= s and gw ~= s and ge ~= s then self:replace(i, j, self:getTile(nt.small_pillar))
	elseif gs ~= s and gn ~= s and gw ~= s and ge == s then self:replace(i, j, self:getTile(nt.pillar_4))
	elseif gs ~= s and gn ~= s and gw == s and ge ~= s then self:replace(i, j, self:getTile(nt.pillar_6))
	elseif gs == s and gn ~= s and gw ~= s and ge ~= s then self:replace(i, j, self:getTile(nt.pillar_8))
	elseif gs ~= s and gn == s and gw ~= s and ge ~= s then self:replace(i, j, self:getTile(nt.pillar_2))
	elseif gsc ~= s and gnc ~= s then self:replace(i, j, self:getTile(nt.north_south))
	elseif gsc ~= s then self:replace(i, j, self:getTile(nt.south))
	elseif gnc ~= s then self:replace(i, j, self:getTile(nt.north))
	elseif nt.inner then self:replace(i, j, self:getTile(nt.inner))
	end
end

--- Make doors have a pseudo 3D effect
function _M:niceTileDoor3d(level, i, j, g, nt)
	local gn = level.map:checkEntity(i, j-1, Map.TERRAIN, "block_move") and true or false
	local gs = level.map:checkEntity(i, j+1, Map.TERRAIN, "block_move") and true or false
	local gw = level.map:checkEntity(i-1, j, Map.TERRAIN, "block_move") and true or false
	local ge = level.map:checkEntity(i+1, j, Map.TERRAIN, "block_move") and true or false

	if gs and gn then self:replace(i, j, self:getTile(nt.north_south))
	elseif gw and ge then self:replace(i, j, self:getTile(nt.west_east))
	end
end
