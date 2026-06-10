---@class Particle
---@field x number
---@field y number
---@field speed number
---@field spread number
---@field number number
---@field size1 number
---@field size2 number
---@field lifetime number
---@field image love.Image | love.Canvas
---@field finished boolean
---@field timer number
---@field fade boolean
---@field alpha number
---@field particle_system love.ParticleSystem
---@field load fun(self: Particle)
---@field update fun(self: Particle, dt: number)
---@field draw fun(self: Particle)

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
---@param image love.Image | love.Canvas
---@return Particle
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
		particle_system = love.graphics.newParticleSystem(image, 32),

		---@param self Particle
		load = function(self)
			self.particle_system:setParticleLifetime(self.lifetime)
			self.particle_system:setSpeed(self.speed)
			self.particle_system:setSizes(self.size1, self.size2)
			self.particle_system:setSpread(self.spread/60)
			self.particle_system:setPosition(self.x, self.y)
			self.particle_system:emit(self.number)
		end,
		
		---@param self Particle
		---@param dt number
		update = function(self, dt)		--Update particles
			self.particle_system:update(dt)
			self.timer = self.timer + dt
			if self.timer >= self.lifetime then
				--love.event.quit()
				self.finished = true
			end
			if self.fade == true then	--Fade out particles as they get closer to the end of their lifetime
				self.alpha = 1 - (self.timer/self.lifetime)
			end
		end,
		
		---@param self Particle
		draw = function(self)
			self.particle_system:setColors(1, 1, 1, self.alpha)		--Draw the particles with an alpha value that can be modified
			love.graphics.draw(self.particle_system)
		end,
	}
end