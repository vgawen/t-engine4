-- TE4 - T-Engine 4
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
local Base = require "engine.ui.Base"
local Focusable = require "engine.ui.Focusable"

--- A generic UI button
module(..., package.seeall, class.inherit(Base, Focusable))

function _M:init(t)
	self.list = assert(t.list, "no list list")
	self.w = assert(t.width, "no list width")
	self.h = assert(t.height, "no list height")
	self.fct = t.fct
	self.display_prop = t.display_prop or "name"

	Base.init(self, t)
end

function _M:generate()
	self.sel = 1
	self.scroll = 1
	self.max = #self.list

	local ls, ls_w, ls_h = self:getImage("ui/selection-left-sel.png")
	local ms, ms_w, ms_h = self:getImage("ui/selection-middle-sel.png")
	local rs, rs_w, rs_h = self:getImage("ui/selection-right-sel.png")
--	local l, l_w, l_h = self:getImage("ui/button-left.png")
--	local m, m_w, m_h = self:getImage("ui/button-middle.png")
--	local r, r_w, r_h = self:getImage("ui/button-right.png")

	-- Draw the list items
	local fw, fh = self.w, ls_h
	self.fw, self.fh = fw, fh

	self.max_display = math.floor(self.h / fh)

	for i, item in ipairs(self.list) do
		local text = item[self.display_prop]
		local ss = core.display.newSurface(fw, fh)
		local s = core.display.newSurface(fw, fh)

		ss:merge(ls, 0, 0)
		for i = ls_w, fw - rs_w do ss:merge(ms, i, 0) end
		ss:merge(rs, fw - rs_w, 0)
		ss:drawColorStringBlended(self.font, text, ls_w, (fh - self.font_h) / 2, 255, 255, 255, nil, fw - ls_w - rs_w)

		s:erase(0, 0, 0)
--		s:merge(l, 0, 0)
--		for i = l_w, fw - r_w do s:merge(m, i, 0) end
--		s:merge(r, fw - r_w, 0)
		s:drawColorStringBlended(self.font, text, ls_w, (fh - self.font_h) / 2, 255, 255, 255, nil, fw - ls_w - rs_w)

		item._tex, item._tex_w, item._tex_h = s:glTexture()
		item._stex = ss:glTexture()
	end

	-- Add UI controls
	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		self.sel = util.bound(self.scroll + math.floor(by / self.fh), 1, self.max)
		if button == "left" and event == "button" then self:onUse() end
	end)
	self.key:addBinds{
		ACCEPT = function() self:onUse() end,
		MOVE_UP = function() self.sel = util.boundWrap(self.sel - 1, 1, self.max) self.scroll = util.scroll(self.sel, self.scroll, self.max_display) end,
		MOVE_DOWN = function() self.sel = util.boundWrap(self.sel + 1, 1, self.max) self.scroll = util.scroll(self.sel, self.scroll, self.max_display) end,
	}
end

function _M:onUse()
	local item = self.list[self.sel]
	if not item then return end
	if item.fct then item:fct()
	else self.fct(item) end
end

function _M:display(x, y)
	for i = 1, self.max do
		local item = self.list[i]
		if self.sel == i then
			item._stex:toScreenFull(x, y, self.fw, self.fh, item._tex_w, item._tex_h)
		else
			item._tex:toScreenFull(x, y, self.fw, self.fh, item._tex_w, item._tex_h)
		end
		y = y + self.fh
	end
end
