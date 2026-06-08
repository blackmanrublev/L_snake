local tween = require "tween"
---@param x number
---@param y number
---@param size number
---@param cell_size number
---@return table
function createSnake(x, y, size, cell_size)
	return{
		x = x,
		y = y,
		size = size,
		cell_size = cell_size,
		draw_x = x,
		draw_y = y,
		body = {},
		direction = "right",
		direction_queue = {
			"right",
		},
		eat = false,
		alive = true,
		timer = 0,
		last = {},
		speed = 0.13,
		color = "green",
		
		load = function(self)
			local x = 6 * self.cell_size
			local y = 1 * self.cell_size
			self.body = {
				{x = x, y = y, size = self.size, draw_x = x, draw_y = y, draw_size = size, x_tween = "", y_tween = "", size_tween = ""},
			}
		end,
		
		---@param dt number
		---@param space table
		update = function(self, dt, space)
			self.timer = self.timer + dt
				self.eat = false
			if self.timer >= 0.13  then
				self.last.x = self.body[#self.body].x
				self.last.y = self.body[#self.body].y
				self.last.size = self.body[#self.body].size
				if #self.direction_queue > 0 then
					self.direction = table.remove(self.direction_queue, 1)
				end
				
				self:move()
				self.timer = 0
			end
			self:tween(dt)
		end,
		
		---@param dt number
		tween = function(self, dt)
			for i, v in pairs(self.body) do
				if v.draw_x ~= v.x and v.x_tween == "" then
					v.x_tween = tween.new(self.speed, v, {draw_x = v.x}, "outCubic")
				end
				
				if v.draw_y ~= v.y and v.y_tween == "" then
					v.y_tween = tween.new(self.speed, v, {draw_y = v.y}, "outCubic")
				end
				
				if v.draw_size ~= v.size and v.size_tween == "" then
					v.size_tween = tween.new(self.speed, v, {draw_size = v.size}, "inCubic")
				end
				
				if v.x_tween ~= "" then
					local complete = v.x_tween:update(dt)
					if complete then
						v.x_tween = ""
					end
				end
				
				if v.y_tween ~= "" then
					local complete = v.y_tween:update(dt)
					if complete then
						v.y_tween = ""
					end
				end
				
				if v.size_tween ~= "" then
					local complete = v.size_tween:update(dt)
					if complete then
						v.size_tween = ""
					end
				end
			end
		
		end,
		
		draw = function(self)
			for i, v in pairs(self.body) do
				if i % 2 == 1 then
					love.graphics.setColor(0, 1, 0, 1)
				else
					love.graphics.setColor(0, 0.3, 0, 1)
				end
				if i == 1 then
					local x =	(v.draw_x + self.cell_size/2)
					local y = (v.draw_y  + self.cell_size/2 )
					love.graphics.circle("fill", x, y, v.draw_size/2)
				else
					local x =	(v.draw_x + self.cell_size/2)  - v.draw_size/2
					local y = (v.draw_y  + self.cell_size/2 ) - v.draw_size/2
					love.graphics.rectangle("fill", x, y, v.draw_size, v.draw_size)
				end
			end
			love.graphics.setColor(1, 1, 1, 1)
		end,

		---@param key string
		control = function(self, key)
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
	
		move = function(self)
			for i = #self.body, 1, -1 do
				local v = self.body[i]
				if i == 1 then
					local t = v
					if self.direction == "right" then
						t.x = t.x + self.cell_size
					elseif self.direction == "left" then
						t.x = t.x - self.cell_size
					elseif self.direction== "up" then
						t.y = t.y - self.cell_size
					elseif self.direction == "down" then
						t.y = t.y + self.cell_size
					end
					v.size = self.size
					self.eat = false
				else
					v.x = self.body[i-1].x
					v.y = self.body[i-1].y
					v.size = self.body[i-1].size
				end
			end
		end,
		
		kill = function(self)
			self.alive = false
		end,
		
		eatFood = function(self)
			self.eat = true
			table.insert(self.body, #self.body + 1, {x = self.last.x, y = self.last.y, size = self.body[#self.body].size, draw_x = self.last.x, draw_y = self.last.y, draw_size = self.last.size,x_tween = "", y_tween = "", size_tween = ""})
			self.body[1].size = self.cell_size
			self.last.x = nil
		end,
		

		---@return table
		getBody = function(self)
			return self.body
		end,
		
		---@return table
		getLastCell = function(self)
			return self.last
		end,
	}
end