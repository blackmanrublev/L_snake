local data = require "data"
require "grid"
require "button"
require "particles"
local profile = require "profile"
local camera = require "camera"
require "functions"
require "snake"
require "apple"

local scale = 1
local cam = camera()
local PARTICLES = {}
local BUTTONS = {}
local APPLES = {}
local grid = {}
local empty_spaces = {}
local cell_size = 20
local player = createSnake(0, 0, 15, cell_size)


local mouse_x, mouse_y = love.mouse.getPosition()
local win_width, win_height = love.window.getMode()


local function createCircleTexture(radius, color)
    local size = radius * 2 + 2  -- a little padding
    local canvas = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()  -- transparent background
    love.graphics.setColor(color)
    love.graphics.circle("fill", size/2, size/2, radius)
	--love.graphics.rectangle("fill", size/2, size/2, size, size)
    love.graphics.setColor(1, 1, 1, 1)  -- reset
    love.graphics.setCanvas()
    return canvas
end

local circle_texture = createCircleTexture(1, {1, 0.3, 0.3, 1})  -- white 16px circle
--local ps = love.graphics.newParticleSystem(circleTexture, 10

local game_state = { -- The different states of the game
    menu = true,    --When the player opens the game, it will show the menu by default
    game = false,
    pause = false,
    over = false,
}

local function start_game()  --Begins the game
    if game_state["over"] then
        reset()
    end
    game_state["menu"] = false
    game_state["game"] = true
    game_state["pause"] = false
    game_state["over"] = false
end

local function start_menu()  --Opens the main menu
    reset()
    if game_state["over"] then
        reset()
    end
    game_state["menu"] = true
    game_state["game"] = false
    game_state["pause"] = false
    game_state["over"] = false
end

local function pause_game()  --Pauses the game
    game_state["menu"] = false
    game_state["game"] = false
    game_state["pause"] = true
    game_state["over"] = false
end

local function end_game()    -- Ends the game (Game Over)
    game_state["menu"] = false
    game_state["game"] = false
    game_state["pause"] = false
    game_state["over"] = true
end

function love.mousepressed(x, y, button, isTouch, presses)
	for i in pairs(BUTTONS) do
		BUTTONS[i]:checkPressed(x, y)
	end
end

function love.keypressed(key)
	player:control(key)
	if key == "p" then
		print(profile.report())
		--spawnApple()
	end
end

function love.load()
	
	player:load()
	grid = createGrid(cell_size, win_width, win_height)
	grid:load()
    function reset()
		for i, v in pairs(player:getBody()) do
			if grid:getCell(v.x, v.y).space == "" then
				grid:getCell(v.x, v.y).space = "snake"
				--count = count + 1
			end
		end
	
    end
    reset()
	function spawnApple()
		--local t = {}
		local t = grid:getFree()
		--[[print(#t)
		print(t[20].world_x)
		local f = math.random(#t)
		local d = math.random(#t)
		print(t[f].world_x .. " | " .. t[f].world_y)
		print(t[d].world_y .. " | " .. t[d].world_x)]]
		local cell = math.random(#t)
		--local a = createApple(((t[f].world_x)) , (t[d].world_y), 10, cell_size)
		local a = createApple(((t[cell].world_x)) , (t[cell].world_y), 10, cell_size)
		table.insert(APPLES, a)
		grid:getCell(a.x, a.y).space = "apple"
		--j:load()
	end
	spawnApple()
	--BUTTONS.quit= createButton("QUIT", love.event.quit, nil, 100, 26)
end

function love.update(dt)
	--j:update(dt)
	profile.reset()
	profile.start()
	win_width, win_height = love.window.getMode()
	mouse_x = love.mouse.getX()
	mouse_y = love.mouse.getY()
	
	local body = player:getBody()
	player:update(dt, space)
	local count = 0
	for i, v in pairs(body) do
		if (v.x >= 0 and v.y >= 0) and (v.x < win_width and v.y < win_height) then
			local spawn = true
			if grid:getCell(v.x, v.y).space == "" then
				grid:getCell(v.x, v.y).space = "snake"
			end
			if i == 1 then
				if grid:getCell(v.x, v.y).space == "apple" then
					table.insert(PARTICLES, createParticle(v.x + cell_size/2, v.y + cell_size/2, 150, 360, math.random(10, 30), 1, 5, 0.5, 1, true, circle_texture))
					PARTICLES[#PARTICLES]:load()
					player:eatFood()
					grid:getCell(v.x, v.y).space = "snake" 
					APPLES = {}
					spawnApple()
				end
			end
		end
	end
	
	
	local cell = player:getLastCell()
	local bodyy = player:getBody()
	local body = player:getBody()
	
	local last = player:getLastCell()
	if last.x ~= nil then
		if grid:getCell(last.x, last.y) ~= nil and last.x <= win_width then
			--print(grid:getCell(last.x, last.y).y)
			--love.event.quit()
			grid:getCell(last.x, last.y).space = ""
		end
	end
	
	
	for i, v in pairs(PARTICLES) do
		v:update(dt)
		if v.finished == true then
			table.remove(PARTICLES, i)
		end
	end
	
	
	
	profile.stop()
end

function love.draw()
	--love.graphics.draw(circle_texture)
	--love.graphics.print(love.timer.getFPS())
	love.graphics.print(collectgarbage("count"))
	--love.graphics.print(#player.body)
	--profile.reset()
	profile.start()
	for i, v in pairs(APPLES) do
		v:draw()
	end
	player:draw()
	for i, v in pairs(PARTICLES) do
		v:draw()
	end
	--grid:draw()	
	profile.stop() 
	--BUTTONS.quit:draw(win_width/2 - BUTTONS.quit:getWidth()/2, win_height/2 - BUTTONS.quit:getHeight()/2)
end