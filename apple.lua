---@class Apple
---@field x number
---@field y number
---@field size number
---@field cell_size number
---@field alive boolean
---@field load fun(self: Apple)
---@field update fun(self: Apple)
---@field draw fun(self: Apple)
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
		
		---@param self Apple
		load = function(self)
		end,
		
		---@param self Apple
		update = function(self)
		end,
		
		---@param self Apple
		draw = function(self)
			love.graphics.setColor(1, 0.3, 0.3)
			local x =	(self.x + self.cell_size/2)  - self.size/2
			local y = (self.y  + self.cell_size/2 ) - self.size/2
			love.graphics.rectangle("fill", x, y, self.size, self.size)
			love.graphics.setColor(1, 1, 1)
		end,
		
		---@param self Apple
		kill = function(self)
			self.alive = false
		end,
	}
end