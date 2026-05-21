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
			local x =	((self.x * self.cell_size) + self.cell_size/2)  - self.size/2
			local y = ((self.y * cell_size)  + self.cell_size/2 ) - self.size/2
			love.graphics.rectangle("fill", x, y, self.size, self.size)
		end,
		
		kill = function(self)
			self.alive = false
		end,
	}
end