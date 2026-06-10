---@class Grid
---@field size number
---@field width number
---@field height number
---@field spaces table
--- Create the grid and populate the spaces table with the coordinates of each cell
---@field load fun(self: Grid)
--- Draw the grid and the contents of each cell. If mouse_x and mouse_y are provided, also draw a highlight around the cell the mouse is currently over.
---@field draw fun(self: Grid, mouse_x?: number, mouse_y?: number)
--- Get the index of the grid cell at a specific coordinate
---@field getIndex fun(self: Grid, x: number, y: number): number
--- Get the grid cell at a specific coordinate
---@field getCell fun(self: Grid, x: number, y: number, mouse: boolean?): table
--- Convert raw mouse coordinates to grid coordinates
---@field convertMouseToGrid fun(self: Grid, x: number, y: number): table
--- Get a list of all free cells in the grid
---@field getFree fun(self: Grid): table
--- Use this function instead of getFree when you just want a random free cell.
--- Looks for a random free cell a certain number of times before falling back to getFree, which is more expensive to run.
---@field getRandomFree fun(self: Grid): table
--- Get the total number of cells in the grid
---@field getTotalCells fun(self: Grid): number
--- Get the grid.spaces table
---@field getSpaces fun(self: Grid): table
--- Convert grid coordinates to world coordinates
---@field convertGridToWorld fun(self: Grid, coord: number): number

---@param size number
---@param width number
---@param height number
---@return Grid
function createGrid(size, width, height)
	return{
		size = size,
		width = width,
		height = height,
		spaces = {},

		---@param self Grid
		load = function(self)
			local grid_x_count = self.width/self.size
			local grid_y_count = self.height/self.size
			local t = {}
			
			for grid_y = 1, grid_y_count do
				for grid_x = 1, grid_x_count do
					table.insert(t, {x = grid_x, y = grid_y, world_x = self:convertGridToWorld(grid_x), world_y = self:convertGridToWorld(grid_y),space = ""})
				end
			end
			
			self.spaces = t
		end,
		
		---@param self Grid
		---@param mouse_x? number
		---@param mouse_y? number
		draw = function(self, mouse_x, mouse_y)
			for i, v in pairs(self.spaces) do
				love.graphics.print(v.space, v.world_x, v.world_y)
				love.graphics.rectangle("line", v.world_x, v.world_y, self.size, self.size)
			end
			
			if mouse_x ~= nil and mouse_y ~= nil then
				local t = self:convertMouseToGrid(mouse_x, mouse_y)
				
				love.graphics.setColor(0, 0, 0.8)
				love.graphics.rectangle("line", t.x, t.y, self.size, self.size)
				love.graphics.setColor(1, 1, 1)
			end
		end,
		
		--[[This  is the first function ever made, I shall leave it here for posterity]]
		--[[calculateGrid = function(self, x, y)
			local i = ((x / self.size) + 1) + ((y / self.size) * self.win_width / self.size)
			return self.spaces[i]
		end,]]
		
		---@param self Grid
		---@param x number
		---@param y number
		---@return number
		getIndex = function(self, x, y)	--Get the index of the grid cell using its coordinates
			return ((x / self.size) + 1) + ((y / self.size) * self.width / self.size)
		end,
		
		---@param self Grid
		---@param x number
		---@param y number
		---@param mouse boolean? -- if true, treat x,y as raw mouse coordinates (snap to grid)
		---@return table
		getCell = function(self, x, y, mouse)	--Get the grid cell at a specific coordinate, if mouse is true, snap the coordinates to the grid
			local i = 0
			if x >= self.width or y >= self.height or x < 0 or y < 0 then
				return nil
			end
			
			if mouse == true then
				local t = self:convertMouseToGrid(x, y)
				i = self:getIndex(t.x , t.y)
			else
				i = self:getIndex(x ,y)
			end
			
			return self.spaces[i]
		end,
		
		---@param self Grid
		---@param x number
		---@param y number
		---@return table
		convertMouseToGrid = function(self, x, y)	--Convert raw mouse coordinates to grid coordinates
			local mouse_x = math.floor(x / self.size) * self.size
			local mouse_y = math.floor(y / self.size) * self.size
			local t = {x = mouse_x, y = mouse_y}
			return t
		end,
		
		---@param self Grid
		---@return table
		getFree = function(self)	--Get a list of all free cells in the grid
			local t = {}
			for i, v in pairs(self.spaces) do
				if v.space == "" then
					table.insert(t, v)
				end
			end
			return t
		end,
		
		---@param self Grid
		---@return table
		getRandomFree = function(self)	--Get a random free cell in the grid
			local count = 15 + math.ceil(math.log(self:getTotalCells()))
			local grid_index = 0
			for i = 1, count do
				grid_index = math.random(self:getTotalCells())
				if self.spaces[grid_index].space == "" then
					return self.spaces[grid_index]
				end
			end
			
			local t = self:getFree()
			return t[math.random(#t)]
		end,
		
		---@param self Grid
		---@return number
		getTotalCells = function(self)	--Get the total number of cells in the grid
			return #self.spaces
		end,
		
		---@param self Grid
		---@return table
		getSpaces = function(self)	--Get the grid.spaces table
			return self.spaces
		end,
		
		---@param self Grid
		---@param coord number
		---@return number
		convertGridToWorld = function(self, coord)	--Convert grid coordinates to world coordinates
			return (coord - 1) * self.size
		end,
	}
end