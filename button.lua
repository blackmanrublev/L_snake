---@class Button
---@field width number
---@field height number
---@field func function
---@field param any
---@field text string
---@field button_x number
---@field button_y number
---@field font any
---@field text_x number
---@field text_y number
---@field checkPressed fun(self: Button, mouse_x: number, mouse_y: number)
---@field draw fun(self: Button, button_x: number, button_y: number)
---@field getWidth fun(self: Button): number
---@field getHeight fun(self: Button): number

---@param text string
---@param func function
---@param param any
---@param width number
---@param height number
---@return Button
function createButton(text, func, param, width, height)
    return{
        width = width or 100,
        height = height or 26,
        func = func or function ()
            print("This button has no function attached")   --This appears in the console when you click a button that doesn't have a function
        end,
        param = param or nil,
        text = text or "No text",
        button_x = 0,
        button_y = 0,
        font = love.graphics.newFont(22),
        text_x = 0,
        text_y = 0,

        ---@param self Button
        ---@param mouse_x number
        ---@param mouse_y number
        checkPressed = function(self, mouse_x, mouse_y)
            if (mouse_x  >=  self.button_x and mouse_x <  self.width + self.button_x)
            and
            (mouse_y  >=  self.button_y and mouse_y <  self.height + self.button_y) then
				self.func(self.param)
			end
        end,

        ---@param self Button
        ---@param button_x number
        ---@param button_y number
        draw = function(self, button_x, button_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y

            if self.text_x then
                self.text_x = self.text_x + self.button_x
            else
                self.text_x = self. button_x
            end

            if self.text_y then
                self.text_y = self.text_y + self.button_y
            else
                self.text_y = self. button_y
            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle(
                "fill",
                self.button_x,
                self.button_y,
                self.width,
                self.height
            )
            love.graphics.setColor(0, 0, 0)
			love.graphics.printf(self.text, self.font, self.button_x, self.button_y, self.width, "center")
			love.graphics.setColor(1, 1, 1)

        end,
		
        ---@param self Button
        ---@return number
		getWidth = function(self)
			return self.width
		end,
		
        ---@param self Button
        ---@return number
		getHeight = function(self)
			return self.height
		end,
    }
end