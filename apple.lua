local tween = require "tween"

---@class Apple
---@field x number
---@field y number
---@field size number
---@field cell_size number
---@field alive boolean
---@field size_tween string
---@field speed number
---@field draw_size number
---@field load fun(self: Apple)
--- Update apple
---@field update fun(self: Apple, dt: number)
--- Tween the apple's size
---@field tween fun(self: Apple, dt: number)
--- Draw apple
---@field draw fun(self: Apple)
--- Kill apple
---@field kill fun(self: Apple)

---@param x number
---@param y number
---@param size number
---@param cell_size number
---@return Apple
function createApple(x, y, size, cell_size)
	return{
		x = x,
		y = y,
		size = size,
		cell_size = cell_size,
		alive = false,
		size_tween = "",
		speed = 0.3,
		draw_size = 0,
		
		---@param self Apple
		load = function(self)
		end,
		
		---@param self Apple
		update = function(self, dt)
			self:tween(dt)
		end,
		
		---@param self Apple
		---@param dt number
		tween = function(self, dt)
			if self.draw_size ~= self.size and self.size_tween == "" then
				self.size_tween = tween.new(self.speed, self, {draw_size = self.size}, "outCubic")
			end
			
			if self.size_tween ~= "" then
				local complete = self.size_tween:update(dt)
				if complete then
					self.size_tween = ""
				end
			end
		end,
		
		---@param self Apple
		draw = function(self)
			love.graphics.setColor(1, 0.3, 0.3)
			local x =	(self.x + self.cell_size/2)  - self.draw_size/2
			local y = (self.y  + self.cell_size/2 ) - self.draw_size/2
			love.graphics.rectangle("fill", x, y, self.draw_size, self.draw_size)
			love.graphics.setColor(1, 1, 1)
		end,
		
		---@param self Apple
		kill = function(self)
			self.alive = false
		end,
	}
end