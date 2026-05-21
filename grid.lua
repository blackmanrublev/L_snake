---@param size number
---@param win_width number
---@param win_height number
function createGrid(size, win_width, win_height)
	return{
		size = size,
		win_width = win_width,
		win_height = win_height,
		spaces = {},
		
		load = function(self)			
			local grid_x_count = self.win_width/self.size
			local grid_y_count = self.win_height/self.size
			local t = {}
			
			for grid_y = 1, grid_y_count do
				for grid_x = 1, grid_x_count do
					table.insert(t, {x = grid_x, y = grid_y, space = ""})
				end
			end
			
			self.spaces = t
		end,
		
		---@param mouse_x number
		---@param mouse_y number
		draw = function(self, mouse_x, mouse_y)
			for i, v in pairs(self.spaces) do
				love.graphics.print(v.space, (v.x * self.size) - self.size, (v.y * self.size) - self.size)
				love.graphics.rectangle("line", (v.x * self.size) - self.size, (v.y * self.size) - self.size, size, size)
			end
			
			if mouse_x ~= nil and mouse_y ~= nil then
				local t = self:convertMouse(mouse_x, mouse_y)
				--[[local cube_x = math.floor(mouse_x / self.size) * self.size
				local cube_y = math.floor(mouse_y / self.size) * self.size]]
				
				love.graphics.setColor(0, 0, 0.8)
				love.graphics.rectangle("line", t.x, t.y, self.size, self.size)
				love.graphics.setColor(1, 1, 1)
			end
		end,
		
		--[[calculateGrid = function(self, x, y)
			local i = ((x / self.size) + 1) + ((y / self.size) * self.win_width / self.size)
			return self.spaces[i]
		end,]]
		
		---@param x number
		---@param y number
		getIndex = function(self, x, y)
			return ((x / self.size) + 1) + ((y / self.size) * self.win_width / self.size)
		end,
		
		---@param x number
		---@param y number
		---@param mouse boolean
		getCell = function(self, x, y, mouse)
			local i = 0
			
			if mouse == true then
				local t = self:convertMouse(x, y)
				i = self:getIndex(t.x , t.y)
			else
				i = self:getIndex(x ,y)
			end
			
			return self.spaces[i]
		end,
		
		---@param x number
		---@param y number
		convertMouse = function(self, x, y)
			local mouse_x = math.floor(x / self.size) * self.size
			local mouse_y = math.floor(y / self.size) * self.size
			local t = {x = mouse_x, y = mouse_y}
			return t
		end,
		
		getFree = function(self)
			local t = {}
			--t = self:getSpaces()
			table.move(self.spaces, 1, #self.spaces, 1, t)
			--print(#t)
			--print(t[2].space)
			for i, v in pairs(t) do
				--print(v.x)
				if self:getCell((v.x * self.size) - self.size, (v.y * self.size) - self.size).space ~= "" then
					table.remove(t, i)
				end
			end
			--print(#t)
			return t
		end,
		
		getGridTotal = function(self)
			return #self.spaces
		end,
		
		getSpaces = function(self)
			return self.spaces
		end
	}
end