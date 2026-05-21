function createSnake(x, y, size, cell_size)
	return{
		x = x,
		y = y,
		size = size,
		cell_size = cell_size,
		body = {},
		direction = "right",
		direction_queue = {
			"right",
		},
		eat = false,
		alive = true,
		timer = 0,
		
		load = function(self)
			self.body = {
				{x = 6, y = 1, size = self.size},
				{x = 5, y = 1, size = self.size},
				{x = 4, y = 1, size = self.size},
				{x = 3, y = 1, size = self.size},
				{x = 2, y = 1, size = self.size},
				{x = 1, y = 1, size = self.size},
			}
		end,
		
		update = function(self, dt, space)
			self.timer = self.timer + dt
			if self.timer >= 0.13 then
				if #self.direction_queue > 0 then
					self.direction = table.remove(self.direction_queue, 1)
				end
				
				self:move(space)
				self.timer = 0
			end
		end,
		
		draw = function(self)
			for i, v in pairs(self.body) do
				local x =	((v.x * self.cell_size) + self.cell_size/2)  - v.size/2
				local y = ((v.y * cell_size)  + self.cell_size/2 ) - v.size/2
				if i == 1 then
					local x =	((v.x * self.cell_size) + self.cell_size/2)
					local y = ((v.y * cell_size)  + self.cell_size/2 )
					love.graphics.circle("fill", x, y, v.size/2)
				elseif i == #self.body then
					
				else
					local x =	((v.x * self.cell_size) + self.cell_size/2)  - v.size/2
					local y = ((v.y * cell_size)  + self.cell_size/2 ) - v.size/2
					love.graphics.rectangle("fill", x, y, v.size, v.size)
				end
			end
		end,
		
		control = function(self, key)
			--print(key)
			--print(#self.direction_queue)
			if key == "l" then
				self:eatFood()
			end
			
			if #self.direction_queue ~= 0 then
				if key == "down" and self.direction_queue[#self.direction_queue] ~= "up" then
					table.insert(self.direction_queue, "down")
				elseif key == "left" and self.direction_queue[#self.direction_queue] ~= "right" then
					table.insert(self.direction_queue, "left")
				elseif key == "right" and self.direction_queue[#self.direction_queue] ~= "left" then
					table.insert(self.direction_queue, "right")
				elseif key == "up" and self.direction_queue[#self.direction_queue] ~= "down" then
					table.insert(self.direction_queue, "up")
				end
			else
				if key == "down" and self.direction ~= "up" then
					table.insert(self.direction_queue, "down")
				elseif key == "left" and self.direction ~= "right" then
					table.insert(self.direction_queue, "left")
				elseif key == "right" and self.direction ~= "left" then
					table.insert(self.direction_queue, "right")
				elseif key == "up" and self.direction ~= "down" then
					table.insert(self.direction_queue, "up")
				end
			end
		end,
		
		move = function(self, space)
			local t = {}
			local tt = {}
			
			for i, v in pairs(self.body) do
				local ttt = {}
				
				if self.direction == "right" then
					ttt = {x = 1, y = 0}
				elseif self.direction == "left" then
					ttt = {x = - 1, y = 0}
				elseif self.direction== "up" then
					ttt = {x = 0, y = - 1}
				elseif self.direction == "down" then
					ttt = {x = 0, y = 1}
				end
			
				if i == 1 then
					t = {x = v.x, y = v.y, size = v.size}
					if self.eat == true then
						v.size = 20
					else
						v.size = self.size
					end
					self.eat = false
					--print(t.x .. "t")
					v.x = v.x + ttt.x
					v.y = v.y + ttt.y
					--[[if eat == true then
						v.size = 25
					end]]
				else
					tt = self.body[i]
					self.body[i] = t
					t = tt
				end
				
			end
		end,
		
		kill = function(self)
			self.alive = false
		end,
		
		eatFood = function(self)
			self.eat = true
			table.insert(self.body, #self.body, {x = self.body[1].x, y = self.body[1].y, size = self.body[1].size})
		end,
		
		getBody = function(self)
			return self.body
		end,
		
		getLastCell = function(self)
			return self.body[#self.body]
		end,
	}
end