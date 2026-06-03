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
	--local bodyy = player:getBody()
	--print(#body .. "s")
	--print(body[#body].y)
	--print(player.body[#player.body].y)
	player:update(dt, space)
	local count = 0
	--print(#body)
	--local t = grid:getFree()
	--print(#t)
	for i, v in pairs(body) do
		--print(body[#body].x)
		--print(v.y)
		--if (v.x >= 0 and v.y >= 0) and (v.x < (grid:getGridTotal()/2)/10 and v.y < (grid:getGridTotal()/2)/10) then
		if (v.x >= 0 and v.y >= 0) and (v.x < win_width and v.y < win_height) then
			local spawn = true
			if grid:getCell(v.x, v.y).space == "" then
				grid:getCell(v.x, v.y).space = "snake"
				--count = count + 1
			end
			if i == 1 then
				--grid:getCell(v.x, v.y).space = "snake"
				--print(v.x)
				--print(grid:getCell(120, 20).space)
				if grid:getCell(v.x, v.y).space == "apple" then
					player:eatFood()
					grid:getCell(v.x, v.y).space = "snake" 
					APPLES = {}
					spawnApple()
				end
				--print(grid:getCell(20, 20).y .. "d")
			end
			--grid:getCell()
		end
	end
	
	
	local cell = player:getLastCell()
	local bodyy = player:getBody()
	local body = player:getBody()
	
	--[[for i, v in pairs(bodyy) do
		if grid:getCell(v.x, v.y).space == "" then
			grid:getCell(v.x, v.y).space = "snake"
			--count = count + 1
		end
	end]]
	
	
	--if (cell.x >= 0 and cell.y >= 0) and (cell.x < (grid:getGridTotal()/2)/10 and cell.y < (grid:getGridTotal()/2)/10) then
	local last = player:getLastCell()
	if last.x ~= nil then
		if grid:getCell(last.x, last.y) ~= nil and last.x <= win_width then
			--print(grid:getCell(last.x, last.y).y)
			--love.event.quit()
			grid:getCell(last.x, last.y).space = ""
		end
	end
	if (body[#body].x >= 0 and body[#body].y >= 0) and (body[#body].x < win_width and body[#body].y < win_height) then
		--local last = player:getLastCell()
		--print(last.x)
		--if grid:getCell(last.x, last.y).space ~= nil then
			--grid:getCell(last.x, last.y).space = ""
			--[[print(last.x .. "l" .. last.y)
			print(player.body[#player.body].x .. "j" .. player.body[#player.body].y)
			print(grid:getCell(last.x, last.y).x)]]
		--[[if grid:getCell(body[#body].x, body[#body].y).space == "snake" then
			grid:getCell(body[#body].x, body[#body].y).space = ""
		end]]
		--[[print(last.x .. "l")
		print(player.body[#player.body].x .. "j")]]
		--grid:getCell(last.x, last.y).space = ""
		--[[if #body ~= #bodyy  then
			grid:getCell(body[#body].x, body[#body].y).space = "snake"
		end]]
		--end
	end
	--end
	
	
	
	profile.stop()
end

function love.draw()
	love.graphics.print(love.timer.getFPS())
	--love.graphics.print(#player.body)
	--profile.reset()
	profile.start()
	for i, v in pairs(APPLES) do
		v:draw()
	end
	player:draw()
	--grid:draw()	
	profile.stop() 
	--BUTTONS.quit:draw(win_width/2 - BUTTONS.quit:getWidth()/2, win_height/2 - BUTTONS.quit:getHeight()/2)
end