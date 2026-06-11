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
---@field fire boolean
---@field particle_system love.ParticleSystem
--- Loads the particle system with the specified parameters
---@field load fun(self: Particle)
--- Updates the particle system
---@field update fun(self: Particle, dt: number)
--- Draws the particles
---@field draw fun(self: Particle)
---@field move fun(self: Particle, x: number, y: number)
---@field emitParticles fun(self: Particle)

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
		fire = false,
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
			if self.fire == true then
				self.particle_system:update(dt)
				self.timer = self.timer + dt
				
				if self.fade == true then	--Fade out particles as they get closer to the end of their lifetime
					self.alpha = 1 - (self.timer/self.lifetime)
				end
				
				if self.particle_system:getCount() == 0 then
					self.fire = false
					self.timer = 0
				end
			end
		end,
		
		---@param self Particle
		draw = function(self)
			self.particle_system:setColors(1, 1, 1, self.alpha)		--Draw the particles with an alpha value that can be modified
			love.graphics.draw(self.particle_system)
		end,
		
		---@param self Particle
		---@param x number
		---@param y number
		move = function(self, x, y)
			self.particle_system:moveTo(x, y)
		end,
		
		---@param self Particle
		emitParticles = function(self)
			self.fire = true
			self.particle_system:emit(self.number)
		end,
	}
end