local snows = {}
local globalTime = 0.0

local tickTime = 0.05
local snowCount = 0

local rightInertia = 0.0

function love.load()
	love.window.setFullscreen(true)
end

function clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function lerp(a, b, t)
	return a + ((b - a) * t)
end

function lerpColor(a, b, t)
	return {
		r = lerp(a.r, b.r, t),
		g = lerp(a.g, b.g, t),
		b = lerp(a.b, b.b, t)
	}
end

function getColorByFloat(val)
	return {
		r = val, g = val, b = val
	}
end

function getColorByFunction(func)
	return {
		r = func(), g = func(), b = func()
	}
end

function getSnow()
	local screenWidth = love.graphics.getWidth()
	
	local x = math.random(1, screenWidth)
	local y = 0

	local speed = math.random(2.0, 4.5)

	local colorSpeedValue = speed / 4.5

	local minColor = 0.7
	local maxColor = 0.7

	local endColor = {
		r = math.random(minColor, maxColor) * colorSpeedValue, 
		g = math.random(minColor, maxColor) * colorSpeedValue, 
		b = math.random(minColor, maxColor) * colorSpeedValue
	}

	local minOffset = -1.0
	local maxOffset = 1.0

	local startColor = {
		r = endColor.r + math.random(minOffset, maxOffset) * colorSpeedValue,
		g = endColor.g + math.random(minOffset, maxOffset) * colorSpeedValue,
		b = endColor.b + math.random(minOffset, maxOffset) * colorSpeedValue
	}

	return { 
		position = { x = x, y = y }, 
		color = startColor, 
		speed = speed,
		startColor = startColor,
		endColor = endColor
	}
end

function getScreenProportion(screenHeight, y)
	return y / screenHeight
end

function love.draw()
	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.print('Count: '..snowCount, 10, 10)

	for i, j in ipairs(snows) do
		local position = j.position

		love.graphics.setColor(j.color.r, j.color.g, j.color.b)
		love.graphics.circle('fill', position.x, position.y, 3, 30)
	end
end

function love.update(dt)
	globalTime = globalTime + dt

	if globalTime > tickTime then
		globalTime = globalTime - tickTime
		onTick()
	end

	local screenHeight = love.graphics.getHeight()

	for index, snow in ipairs(snows) do
		local position = snow.position
		position.y = position.y + (100 * dt * snow.speed)

		local proportion = getScreenProportion(screenHeight, position.y)
		snow.color = lerpColor(snow.startColor, snow.endColor, proportion)
	end
end

function onTick(dt)
	for i = 1, 5 do 
		table.insert(snows, getSnow())
	end

	local screenHeight = love.graphics.getHeight()

	for i,j in ipairs(snows) do
		local snowY = j.position.y

		if snowY > screenHeight then
			table.remove(snows, i)
		end	-- local whiteColor = { r = 1.0, g = 1.0, b = 1.0 }
	end	-- local blackColor = { r = 0.0, g = 0.0, b = 0.0 }

	snowCount = #snows
end
