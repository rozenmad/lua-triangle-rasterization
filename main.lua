local function array_set(array, x, y, value)
	local xarray = array[x] or {}
	array[x] = xarray
	xarray[y] = value
end

local function array_get(array, x, y)
	if array[x] then
		return array[x][y]
	end
end

local function bresenhams_line(x1, y1, x2, y2, callback)
	local cx = x1
	local cy = y1
	local dx = math.abs(x2 - x1)
	local dy =-math.abs(y2 - y1)
	local sx = x1 < x2 and 1 or -1
	local sy = y1 < y2 and 1 or -1

	local err = dx + dy
	local e2 = 0

	while true do
		callback(cx, cy)
		if cx == x2 and cy == y2 then break end
		e2 = 2 * err
		if e2 >= dy then
			err, cx = err + dy, cx + sx
		end
		if e2 <= dx then
			err, cy = err + dx, cy + sy
		end
	end
end

local function raster_triangle(array, points)
	if points[1][2] > points[2][2] then points[1], points[2] = points[2], points[1] end
	if points[1][2] > points[3][2] then points[1], points[3] = points[3], points[1] end
	if points[2][2] > points[3][2] then points[2], points[3] = points[3], points[2] end

	local x1 = math.floor(points[1][1])
	local y1 = math.floor(points[1][2])
	local x2 = math.floor(points[2][1])
	local y2 = math.floor(points[2][2])
	local x3 = math.floor(points[3][1])
	local y3 = math.floor(points[3][2])
	local x4 = x1 + ((y2 - y1) / (y3 - y1)) * (x3 - x1)

	local sx = x4 > x2 and -1 or 1

	local function set_color(x, y)
		array_set(array, x, y, {1, 1, 1, 1})
	end

	bresenhams_line(x1, y1, x2, y2, set_color)
	bresenhams_line(x2, y2, x3, y3, set_color)
	bresenhams_line(x3, y3, x1, y1, function (x, y)
		while not array_get(array, x, y) do
			array_set(array, x, y, {1, 1, 1, 1})
			x = x + sx
		end
	end)
end

local sizex = 200
local sizey = 200

local array = {}
local points = {{}, {}, {}}
for i = 1, 3 do
	points[i][1] = math.random() * sizex
	points[i][2] = math.random() * sizey
end

raster_triangle(array, points)