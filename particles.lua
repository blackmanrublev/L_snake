---@param x number
---@param y number
---@param speed number
---@param spread number
---@param number number
---@param size1 number
---@param size2 number
---@param lifetime number
---@param alpha number
---@param fade boolean
---@param image any
---@return table
function createParticle(x, y, speed, spread, number, size1, size2, lifetime, alpha, fade, image)
    --local particle = love.graphics.newParticleSystem(image, 32)
	return{
		x = x,
		y = y,
		speed = speed,
		spread = spread,
		number = number,
		size1 = size1,
		size2 = size2 or size1,
		lifetime = lifetime,
		image = image,
		finished = false,
		timer = 0,
		fade = fade,
		alpha = alpha or 1,
		particle = love.graphics.newParticleSystem(image, 32),

		load = function(self)
			self.particle:setParticleLifetime(self.lifetime)
			self.particle:setSpeed(self.speed)
			self.particle:setSizes(self.size1, self.size2)
			self.particle:setSpread(self.spread/60)
			self.particle:setPosition(self.x, self.y)
			self.particle:emit(self.number)
		end,
		
		---@param dt number
		update = function(self, dt)		--Update particles
			self.particle:update(dt)
			self.timer = self.timer + dt
			if self.timer >= self.lifetime then
				--love.event.quit()
				self.finished = true
			end
			if self.fade == true then	--Fade out particles as they get closer to the end of their lifetime
				self.alpha = 1 - (self.timer/self.lifetime)
			end
		end,
		
		draw = function(self)
			self.particle:setColors(1, 1, 1, self.alpha)		--Draw the particles with an alpha value that can be modified
			love.graphics.draw(self.particle)
		end,
	}
end