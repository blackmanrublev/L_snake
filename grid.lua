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
			
			local function gridConvert(coord)
				return (coord - 1) * self.size
			end
			
			for grid_y = 1, grid_y_count do
				for grid_x = 1, grid_x_count do
					table.insert(t, {x = grid_x, y = grid_y, world_x = gridConvert(grid_x), world_y = gridConvert(grid_y),space = ""})
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
		
		convertGrid = function(self, x, y)
			
		end,
		
		getFree = function(self)
			local t = {}
			for i, v in pairs(self.spaces) do
				if v.space == "" then
					table.insert(t, v)
				end
			end
			return t
		end,
		
		getRandomFree = function(self)
			local count = 15 + math.ceil(math.log(self:getGridTotal()))
			local grid_index = 0
			for i = 1, count do
				grid_index = math.random(self:getGridTotal())
				if self.spaces[grid_index].space == "" then
					return self.spaces[grid_index]
				end
			end
			
			local t = self:getFree()
			print(fuh)
			return t[math.random(#t)]
		end,
		
		getGridTotal = function(self)
			return #self.spaces
		end,
		
		getSpaces = function(self)
			return self.spaces
		end,
		
		gridConvert = function(self, coord)
			return (coord - 1) * self.size
		end,
	}
end