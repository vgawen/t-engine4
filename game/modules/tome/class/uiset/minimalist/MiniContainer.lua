-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
local Mouse = require "engine.Mouse"
local UI = require "engine.ui.Base"

--- Abstract class that defines a UI "item", like th player frame, hotkeys, ...
-- @classmod engine.LogDisplay
module(..., package.seeall, class.make)

function _M:init(minimalist)
	local _ _, _, w, h = self:getDefaultGeometry()
	self.uiset = minimalist
	self.mouse = Mouse.new()
	self.container_id = self:getClassName()
	self.x, self.y = 0, 0
	self.w, self.h = w, h
	self.base_w, self.base_h = w, h
	self.container_z = 0
	self.scale = 1
	self.alpha = 1
	self.locked = true
	self.focused = false
	self.shutdown_mouse_on_unlock = true
	self.resize_mode = "rescale"
	self.orientation = "left"
	self.mousezone_id = self:getClassName() -- Change that in the subclass if there has to be more than one instance

	self.move_handle, self.move_handle_w, self.move_handle_h = self:imageLoader("move_handle.png")

	self.unlocked_container = core.renderer.container()
	self.unlocked_grey_filter = core.renderer.colorQuad(0, 0, 1, 1, 0, 0, 0, 0.235):scale(w, h, 1)
	self.unlocked_container:add(self.unlocked_grey_filter)
	self.unlocked_container:add(self.move_handle)
	local text = core.renderer.text(self.uiset.font):outline(1):text("#{italic}#<"..self:getName()..">#{normal}#"):color(colors.smart1unpack(colors.GREY))
	self.unlocked_container:add(text)	
end

function _M:imageLoader(file, rw, rh)
	local sfile = UI.ui.."-ui/minimalist/"..file
	if fs.exists("/data/gfx/"..sfile) then
		local ts, fx, fy, tsx, tsy, tw, th = UI:checkTileset(sfile)
		if ts then return core.renderer.fromTextureTable({t=ts, tw=fx, th=fy, w=tw, h=th, tx=tsx, ty=tsy}, 0, 0, rw, rh)
		else return core.renderer.surface(core.display.loadImage("/data/gfx/"..sfile), 0, 0, rw, rh) end
	else
		local ts, fx, fy, tsx, tsy, tw, th = UI:checkTileset("ui/"..file)
		if ts then return core.renderer.fromTextureTable({t=ts, tw=fx, th=fy, w=tw, h=th, tx=tsx, ty=tsy}, 0, 0, rw, rh)
		else return core.renderer.surface(core.display.loadImage("/data/gfx/ui/"..file), 0, 0, rw, rh) end
	end
end

function _M:texLoader(file, rw, rh)
	local sfile = UI.ui.."-ui/minimalist/"..file
	if fs.exists("/data/gfx/"..sfile) then
		local ts, fx, fy, tsx, tsy, tw, th = UI:checkTileset(sfile)
		if ts then return {t=ts, tw=fx, th=fy, w=tw, h=th, tx=tsx, ty=tsy}
		else
			local tex, rw, rh, tw, th, iw, ih = core.display.loadImage("/data/gfx/"..sfile):glTexture()
			return {t=tex, w=iw, h=ih, tw=iw/rw, th=ih/rh, tx=0, ty=0}
		end
	else
		local ts, fx, fy, tsx, tsy, tw, th = UI:checkTileset("ui/"..file)
		if ts then return {t=ts, tw=fx, th=fy, w=tw, h=th, tx=tsx, ty=tsy}
		else
			local tex, rw, rh, tw, th, iw, ih = core.display.loadImage("/data/gfx/ui/"..file):glTexture()
			return {t=tex, w=iw, h=ih, tw=iw/rw, th=ih/rh, tx=0, ty=0}
		end
	end
end

function _M:makeFrameDO(base, w, h, iw, ih, center, resizable)
	return UI:makeFrameDO({base=base, fct=function(s) return self:texLoader(s) end}, w, h, iw, ih, center, resizable)
end

function _M:update(nb_keyframes)
end

function _M:getName()
	error("MiniContainer defined without a name")
end

function _M:getDefaultGeometry()
	error("MiniContainer defined without a default geometry")
end

function _M:getMoveHandleLocation()
	return self.w - self.move_handle_w, self.h - self.move_handle_h
end

function _M:getDO()
	error("cant use MiniContainer directly")
end

function _M:move(x, y)
	self.x, self.y = x, y
	self:getDO():translate(x, y, 0):color(1, 1, 1, self.alpha)
	self:setupMouse()
end

function _M:setScale(s)
	self.scale = util.bound(s, 0.5, 2)
	self:resize(self.w, self.h)
end

function _M:resize(w, h)
	if self.resize_mode == "rescale" then
		self.do_container:scale(self.scale, self.scale, 1)
	elseif self.resize_mode == "resize" then
		self.w, self.h = w, h
		self.unlocked_grey_filter:scale(w, h, 1)
		local x, y = self:getMoveHandleLocation()
		self.move_handle:translate(x, y)

		local mhx, mhy = self:getMoveHandleLocation()
		local mhw, mhh = self.move_handle_w, self.move_handle_h
		self.mouse:updateZone("move_handle", mhx, mhy, mhw, mhh, nil, 1)
	end
	self:setupMouse()
end

function _M:setAlpha(a)
	self.alpha = util.bound(a, 0.4, 1)
	self:getDO():color(1, 1, 1, self.alpha)
end

function _M:setOrientation(dir)
	self.orientation = dir
end

function _M:getMoveHandleAddText()
	return ""
end

function _M:uiMoveResize(button, mx, my, xrel, yrel, bx, by, event, on_change)
	if self.locked then return end

	local what = self.container_id
	local mode = self.resize_mode

	local mhx, mhy = self:getMoveHandleLocation()

	if event == "button" and button == "middle" then self:setScale(1) self.uiset:saveSettings()
	elseif event == "button" and button == "wheelup" then self:setAlpha(self.alpha + 0.05) self.uiset:saveSettings()
	elseif event == "button" and button == "wheeldown" then self:setAlpha(self.alpha - 0.05) self.uiset:saveSettings()
	elseif event == "motion" and button == "left" then
		game.mouse:startDrag(mx, my, nil, {kind="ui:move", id=what, dx=mhx*self.scale, dy=mhy*self.scale},
			function(drag, used) self.uiset:saveSettings() if on_change then on_change("move") end end,
			function(drag, _, x, y) self:move(x-drag.payload.dx, y-drag.payload.dy) if on_change then on_change("move") end end,
			true
		)
	elseif event == "motion" and button == "right" then
		if mode == "rescale" then
			game.mouse:startDrag(mx, my, nil, {kind="ui:rescale", id=what, bx=bx, by=by},
				function(drag, used) self.uiset:saveSettings() if on_change then on_change(mode) end end,
				function(drag, _, x, y)
					self:setScale((x - self.x) / mhx)
					if on_change then on_change(mode) end
				end,
				true
			)
		elseif mode == "resize" then
			game.mouse:startDrag(mx, my, nil, {kind="ui:resize", id=what, bx=bx+self.move_handle_w, by=by+self.move_handle_h},
				function(drag, used) self.uiset:saveSettings() if on_change then on_change(mode) end end,
				function(drag, _, x, y)
					self:resize(util.bound(x - self.x, 20, game.w), util.bound(y - self.y, 20, game.h))
					if on_change then on_change(mode) end
				end,
				true
			)
		end
	end
end

function _M:lock(v)
	self.locked = v
	if self.shutdown_mouse_on_unlock then
		self.mouse:enableZone(true, v)
	end

	local zoneid = "move_handle"
	if not v then
		local x, y = self:getMoveHandleLocation()
		local w, h = self.move_handle_w, self.move_handle_h
		self.move_handle:translate(x, y)

		local fct = self:tooltipAll(function(button, mx, my, xrel, yrel, bx, by, event)
			self:uiMoveResize(button, mx, my, xrel, yrel, bx, by, event)
		end, self:getName()..[[
---
Left mouse drag&drop to move the frame
Right mouse drag&drop to scale up/down
Middle click to reset to default scale
Wheel up/down to change transparency
]]..self:getMoveHandleAddText())
		self.mouse:registerZone(x, y, w, h, fct, nil, zoneid, true, 1)
	else
		self.mouse:unregisterZone(zoneid)
	end
end

function _M:getDO()
	-- By default assume this name, overload if different
	return self.do_container
end

function _M:getUnlockedDO()
	-- By default assume this name, overload if different
	return self.unlocked_container
end

function _M:onFocus(v)
end

function _M:tooltipAll(fct, desc)
	return function(button, mx, my, xrel, yrel, bx, by, event)
		if event ~= "out" then game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, tostring(util.getval(desc))) end
		fct(button, mx, my, xrel, yrel, bx, by, event)
	end
end

function _M:tooltipButton(fct, desc)
	return function(button, mx, my, xrel, yrel, bx, by, event)
		if event ~= "out" then game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, tostring(util.getval(desc))) end
		if event == "button" then fct(button, mx, my, xrel, yrel, bx, by, event) end
	end
end

function _M:setupMouse(first)
	if first then self.mouse_first_setup = true end
	if not self.mouse_first_setup then return end

	if not game.mouse:updateZone(self.mousezone_id, self.x, self.y, self.w, self.h, nil, self.scale) then
		game.mouse:unregisterZone(self.mousezone_id)

		local fct = function(button, mx, my, xrel, yrel, bx, by, event)
			local newfocus = event ~= "out"
			if newfocus ~= self.focused then
				self.focused = newfocus
				self:onFocus(self.focused)
			end
			-- Notice how we pass bx, by instead of mx, my! This way we always have 0x0 relative and rescaled and no need to use delegate offsets
			self.mouse:delegate(button, bx, by, xrel, yrel, bx, by, event)
		end
		game.mouse:registerZone(self.x, self.y, self.w, self.h, fct, nil, self.mousezone_id, true, self.scale)
	end
end
