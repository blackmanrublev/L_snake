function distanceBetween(x1, x2, y1, y2)
	return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end

function angleBetween(x1, x2, y1, y2) -- Math formula for angle between two points ; Player - mouse
       return math.atan2( y1 - y2, x1 - x2) + math.pi -- Added math.pi = 180 degrees
end