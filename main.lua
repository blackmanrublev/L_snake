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
	end
end

function love.load()
	
	player:load()
	grid = createGrid(cell_size, win_width, win_height)
	grid:load()
    function reset()
	
    end
    reset()
	function spawnApple()
		--local t = {}
		local t = grid:getFree()
		local a = createApple(t[math.random(#t)].x, t[math.random(#t)].y, 10, cell_size)
		table.insert(APPLES, a)
	end
	spawnApple()
	--BUTTONS.quit= createButton("QUIT", love.event.quit, nil, 100, 26)
end

function love.update(dt)
	profile.reset()
	profile.start()
	win_width, win_height = love.window.getMode()
	mouse_x = love.mouse.getX()
	mouse_y = love.mouse.getY()
	
	local body = player:getBody()
	player:update(dt, space)
	local count = 0
	--print(#body)
	--local t = grid:getFree()
	--print(#t)
	for i, v in pairs(body) do
		--print(v.y)
		if (v.x >= 0 and v.y >= 0) and (v.x < (grid:getGridTotal()/2)/10 and v.y < (grid:getGridTotal()/2)/10) then
			if i == 1 then
				if grid:getCell(v.x * cell_size, v.y * cell_size).space == "apple" then
				end
			end
			if grid:getCell(v.x * cell_size, v.y * cell_size).space == "" then
				grid:getCell(v.x * cell_size, v.y * cell_size).space = "snake"
				--count = count + 1
			end
		end
	end
	
	local cell = player:getLastCell()
	
	if (cell.x >= 0 and cell.y >= 0) and (cell.x < (grid:getGridTotal()/2)/10 and cell.y < (grid:getGridTotal()/2)/10) then
		if grid:getCell(cell.x * cell_size, cell.y * cell_size).space == "snake" then
			grid:getCell(cell.x * cell_size, cell.y * cell_size).space = ""
		end
	end
	
	profile.stop()
end

function love.draw()
	for i, v in pairs(APPLES) do
		v:draw()
	end
	player:draw()
	--grid:draw()
	--BUTTONS.quit:draw(win_width/2 - BUTTONS.quit:getWidth()/2, win_height/2 - BUTTONS.quit:getHeight()/2)
end