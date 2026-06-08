---@param x number
---@param y number
---@param size number
---@param cell_size number
function createApple(x, y, size, cell_size)
	return{
		x = x,
		y = y,
		size = size,
		cell_size = cell_size,
		alive = false,
		
		load = function(self)
		end,
		
		update = function(self)
		end,
		
		draw = function(self)
			love.graphics.setColor(1, 0.3, 0.3)
			local x =	(self.x + self.cell_size/2)  - self.size/2
			local y = (self.y  + self.cell_size/2 ) - self.size/2
			love.graphics.rectangle("fill", x, y, self.size, self.size)
			love.graphics.setColor(1, 1, 1)
		end,
		
		kill = function(self)
			self.alive = false
		end,
	}
end