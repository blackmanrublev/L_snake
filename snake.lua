local tween = require "tween"
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
		x_tween = "",
		y_tween = "",
		
		load = function(self)
			local x = 6 * self.cell_size
			local y = 1 * self.cell_size
			self.body = {
				{x = x, y = y, size = self.size, draw_x = x, draw_y = y, x_tween = "", y_tween = "", size_tween = ""},
				{x = x-(1*self.cell_size), y = y, size = self.size, draw_x = x-(1*self.cell_size), draw_y = y, x_tween = "", y_tween = ""},
				--{x = 5 * self.cell_size, y = 1 * self.cell_size, size = self.size},
				--{x = 4 * self.cell_size, y = 1 * self.cell_size, size = self.size},
				--{x = 3 * self.cell_size, y = 1 * self.cell_size, size = self.size},
				--{x = 2 * self.cell_size, y = 1 * self.cell_size, size = self.size},
				--{x = 1 * self.cell_size, y = 1 * self.cell_size, size = self.size},
			}
		end,
		
		update = function(self, dt, space)
			self.timer = self.timer + dt
				self.eat = false
			if self.timer >= 0.13  then
				self.last = {x = self.body[#self.body].x, y = self.body[#self.body].y}
				if #self.direction_queue > 0 then
					self.direction = table.remove(self.direction_queue, 1)
				end
				
				self:move(space)
				self.timer = 0
				--print(self.last.x)
				--print(self.body[#self.body].x)
			end
			self:tween(dt)
		end,
		
		tween = function(self, dt)
			for i, v in pairs(self.body) do
				if v.draw_x ~= v.x and v.x_tween == "" then
					v.x_tween = tween.new(self.speed, v, {draw_x = v.x}, "outCubic")
				end
				
				if v.draw_y ~= v.y and v.y_tween == "" then
					v.y_tween = tween.new(self.speed, v, {draw_y = v.y}, "outCubic")
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
			end
		
		end,
		
		draw = function(self)
			for i, v in pairs(self.body) do
				--local x =	(v.x + self.cell_size/2)  - v.size/2
				--local y = (v.y  + self.cell_size/2 ) - v.size/2
				if i == 1 then
					local x =	(v.draw_x + self.cell_size/2)
					local y = (v.draw_y  + self.cell_size/2 )
					love.graphics.circle("fill", x, y, v.size/2)
				else
					local x =	(v.draw_x + self.cell_size/2)  - v.size/2
					local y = (v.draw_y  + self.cell_size/2 ) - v.size/2
					love.graphics.rectangle("fill", x, y, v.size, v.size)
				end
			end
		end,
		
		control = function(self, key)
			--print(key)
			--print(#self.direction_queue)
			if key == "l" then
				self:eatFood()
				--self.eat = false
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
					ttt = {x = self.cell_size, y = 0}
				elseif self.direction == "left" then
					ttt = {x = - self.cell_size, y = 0}
				elseif self.direction== "up" then
					ttt = {x = 0, y = - self.cell_size}
				elseif self.direction == "down" then
					ttt = {x = 0, y = self.cell_size}
				end
			
				if i == 1 then
					t = {x = v.x, y = v.y, size = v.size, draw_x = v.draw_x, draw_y = v.draw_y, x_tween = "", y_tween = ""}
						v.size = self.size
					self.eat = false
					v.x = v.x + ttt.x
					v.y = v.y + ttt.y
				else
					tt = self.body[i]
					self.body[i] = t
					print(self.body[i].x, 1)
					self.body[i].draw_x = tt.draw_x
					self.body[i].draw_y = tt.draw_y
					t = tt
					print(self.body[i].x, 1)
				end
				
				
			end 
		end,
		
		kill = function(self)
			self.alive = false
		end,
		
		eatFood = function(self)
			self.eat = true
			--self.last = {x = self.body[#self.body].x, y = self.body[#self.body].y}
			--print(self.last.y)
			--table.insert(self.body, #self.body + 1, {x = self.body[#self.body].x, y = self.body[#self.body].y, size = self.body[#self.body].size})
			table.insert(self.body, #self.body + 1, {x = self.last.x, y = self.last.y, size = self.body[#self.body].size, draw_x = self.last.x, draw_y = self.last.y, x_tween = "", y_tween = ""})
			--print(self.body[#self.body].y)
			self.body[1].size = cell_size
			self.last = {}
		end,
		
		getBody = function(self)
			local t = {}
			table.move(self.body, 1, #self.body, 1, t)
			return t
		end,
		
		getLastCell = function(self)
			return self.last
		end,
	}
end