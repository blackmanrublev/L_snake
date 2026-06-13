local data = require "data"
require "grid"
require "button"
require "particles"
local profile = require "profile"
local camera = require "camera"
require "functions"
require "snake"
require "apple"

local mouse_x, mouse_y = love.mouse.getPosition()
local win_width, win_height = love.window.getMode()

local scale = 1
local cell_size = 20
local cam = camera()
local line_x = 0
local line_y = 0
local print_report = true
---@type Particle[]
local PARTICLES = {}
---@type Button[]
local BUTTONS = {}
---@type Apple[]
local APPLES = {}
---@type Grid
local grid = createGrid(cell_size, win_width, win_height)
---@type Snake
local player = createSnake(0, 0, cell_size - cell_size/4, cell_size)




local function createCircleTexture(radius, color)
    local size = radius * 2 + 2
    local canvas = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setColor(color)
    love.graphics.circle("fill", size/2, size/2, radius)
	--love.graphics.rectangle("fill", size/2, size/2, size, size)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setCanvas()
    return canvas
end

local circle_texture = createCircleTexture(cell_size/20, {1, 0.3, 0.3, 1})

local game_state = "game"

function love.keypressed(key)
	player:control(key)
	if key == "p" then
		print(profile.report())
		--spawnApple()
	end
end

function love.load()
	profile.start()
	player:load()
	grid:load()
    function reset()
		for i, v in pairs(player:getBody()) do
			if grid:getCell(v.x, v.y).space == "" then
				grid:getCell(v.x, v.y).space = "snake"
			end
		end
	
    end
    reset()
	function spawnApple()
		local space = grid:getRandomFree()
		if space then
			local a = createApple(((space.world_x)) , (space.world_y), cell_size - cell_size/2, cell_size)
			table.insert(APPLES, a)
			grid:getCell(a.x, a.y).space = "apple"
		end
	end
	spawnApple()
	
	-- Create particle emitter during loading because the game would freeze if it were created while it was running
	table.insert(PARTICLES, createParticle(-1000, -1000, (cell_size/20) * 150, 360, math.random(10, 30), (cell_size/20) * 1, (cell_size/20) * 5, 0.5, 1, true, circle_texture))
	PARTICLES[#PARTICLES]:load()
	
	profile.stop()
end

function love.update(dt)
	if print_report then
		print(profile.report())
		print_report = false
	end
	
	mouse_x, mouse_y = love.mouse.getPosition()
	
	profile.reset()
	profile.start()
	
	if game_state == "game" then
		
		local body = player:getBody()
		player:update(dt)
		
		for i, v in pairs(body) do
			local cell = grid:getCell(v.x, v.y)
			if cell then
				if cell.space == "" then
					cell.space = "snake"
				end
				if i == 1 then
					if cell.space == "apple" then
						PARTICLES[1]:move(v.x + cell_size/2, v.y + cell_size/2)
						PARTICLES[1]:emitParticles()
						player:eatFood()
						cell.space = "snake" 
						table.remove(APPLES, 1)
						spawnApple()
						print_report = true
					end
				end
			else
				if i == 1 then
					line_x, line_y = grid:collapse(v.x, v.y)
				end
			end
		end
		
		local last = player:getLastCell()
		if last.x ~= nil then
			if grid:getCell(last.x, last.y) ~= nil and last.x <= win_width then
				grid:getCell(last.x, last.y).space = ""
			end
		end
		
		for i, v in pairs(PARTICLES) do
			v:update(dt)
		end
		
		for i, v in pairs(APPLES) do
			v:update(dt)
		end
		
		profile.stop()
	end
end

function love.draw()
	
	profile.start()
	
	if game_state == "game" then
		--love.graphics.draw(circle_texture)
		--love.graphics.print(love.timer.getFPS())
		--love.graphics.print(collectgarbage("count"))
		love.graphics.print(player:getTotalSegments())
		--profile.reset()
		for i, v in pairs(APPLES) do
			v:draw()
		end
		player:draw()
		for i, v in pairs(PARTICLES) do
			v:draw()
		end
		
		if line_y == 0 or line_y == grid:getHeight() then
			love.graphics.line(line_x, line_y, line_x + cell_size, line_y)
		end
		if line_x == 0 or line_x == grid:getWidth() then
			love.graphics.line(line_x, line_y, line_x, line_y + cell_size)
		end
		
		-- When player's potition is at a corner 
		if line_x == grid:getWidth() and line_y == grid:getHeight() then
			love.graphics.line(line_x, line_y, line_x, line_y - cell_size)
			love.graphics.line(line_x, line_y, line_x - cell_size, line_y)
		elseif line_x == 0 and line_y == 0 then
			love.graphics.line(line_x, line_y, line_x, line_y + cell_size)
			love.graphics.line(line_x, line_y, line_x + cell_size, line_y)
		elseif line_x == 0 and line_y == grid:getHeight() then
			love.graphics.line(line_x, line_y, line_x, line_y - cell_size)
			love.graphics.line(line_x, line_y, line_x + cell_size, line_y)
		elseif line_y == 0 and line_x == grid:getWidth() then
			love.graphics.line(line_x, line_y, line_x, line_y + cell_size)
			love.graphics.line(line_x, line_y, line_x - cell_size, line_y)
		end

		--grid:draw()	
	end
	
	profile.stop()
end
