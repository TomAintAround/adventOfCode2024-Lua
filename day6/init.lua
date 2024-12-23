local lfs = require("lfs")

---Prints the map
---@param lines table: Table with all the lines, each being a table of characters
local debugExercise = function(lines)
	for _, v in pairs(lines) do
		print(table.concat(v, ""))
	end
	print()
end

---Sets the angle of the guard based of the sprite
---@param sprite string: Sprite of the guard
---@param guardSprites table: Table with the sprites of the guard
---@return integer: The angle
local getAngle = function(sprite, guardSprites)
	---@type table
	local angles = {90, 0, 270, 180}

	for k, v in pairs(guardSprites) do
		if sprite == v then
			return angles[k]
		end
	---@diagnostic disable-next-line
	end
end

---Sets the sprite based of the angle of the guard
---@param angle integer: The angle of the guard
---@param guardSprites table: Table with the sprites of the guard
---@return string: The sprite of the guard
local getSprite = function(angle, guardSprites)
	for k, v in pairs({90, 0, 270, 180}) do
		if angle == v then
			return guardSprites[k]
		end
	---@diagnostic disable-next-line
	end
end

---Returns the info about the guard at the start
---@param lines table: Table with the lines of map, each being a table with characters
---@param guardSprites table: Table with the guard sprites
---@return table: The info about the guard
local guardInfo = function(lines, guardSprites)
	for line = 1, #lines, 1 do
		for column = 1, #lines[1], 1 do
			for guard = 1, #guardSprites, 1 do
				if lines[line][column] == guardSprites[guard] then
					return {
						["x"] = column,
						["y"] = line,
						["sprite"] = guardSprites[guard],
						["angle"] = getAngle(guardSprites[guard], guardSprites)
					}
				end
			end
		end
	---@diagnostic disable-next-line
	end
end

---Moves the guard
---@param lines table: Table with the lines of the map, each being a table of characters
---@param guard table: Table with the info about the guard
---@param guardSprites table: Table with all the guard sprites
---@param clock number: The clock time that the function was initialized
---@return boolean: True if the guard is in a loop, false if it leaves the map
MoveGuard = function(lines, guard, guardSprites, clock)
	---@type integer
	local nextX = guard["x"] + math.cos(math.rad(guard["angle"]))
	local nextY = guard["y"] - math.sin(math.rad(guard["angle"]))

	if not lines[nextY] or not lines[nextY][nextX] then
		lines[guard["y"]][guard["x"]] = "X"
		return false
	end

	-- This is how I check if the guard is in a loop
	-- Long live brute forcing
	if os.clock() - clock >= 0.03 then
		lines[guard["y"]][guard["x"]] = "X"
		return true
	end

	if lines[nextY][nextX] == "#" or lines[nextY][nextX] == "O" then
		guard["angle"] = (guard["angle"] - 90) % 360
		guard["sprite"] = getSprite(guard["angle"], guardSprites)
		lines[guard["y"]][guard["x"]] = guard["sprite"]
	else
		lines[guard["y"]][guard["x"]] = "X"
		lines[nextY][nextX] = guard["sprite"]
		guard["x"] = nextX
		guard["y"] = nextY
	end

	return MoveGuard(lines, guard, guardSprites, clock)
end

---Counts the number of ocurrences of a character in a table of tables of characters
---@param lines table: Table of the lines of the map, each being a table of characters
---@param character string: The character in question
---@return integer: The number of ocurrences
local count = function(lines, character)
	---@type integer
	local sum = 0
	for i = 1, #lines, 1 do
		for j = 1, #lines[1], 1 do
			if lines[i][j] == character then
				sum = sum + 1
			end
		end
	end

	return sum
end

---Solves the first problem
---@param lines table: Table of each line of the map, each being a table of characters
---@param guard table: Info about the guard
---@param guardSprites table: Table witha all the guard sprites
---@return integer: The result
local part1 = function(lines, guard, guardSprites)
	MoveGuard(lines, guard, guardSprites, os.clock())
	return count(lines, "X")
end

---Makes a copy of a table
---@param table table: The original table
---@return table: The copy table
DeepCopy = function(table)
	---@type table
	local newTable = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			newTable[k] = DeepCopy(v)
		else
			newTable[k] = v
		end
	end
	return newTable
end

---Solves the second problem
---@param lines table: Table of each line of the map, each being a table of characters
---@param guard table: Info about the guard
---@param guardSprites table: All possible guard sprites
---@return integer: The result
local part2 = function(lines, guard, guardSprites)
	---@type table
	local newLines, oldLines = DeepCopy(lines), DeepCopy(lines)
	oldLines[guard["y"]][guard["x"]] = guard["sprite"]
	for i = 1, #lines, 1 do
		for j = 1, #lines[1], 1 do
			if lines[i][j] == "X" then
				newLines[i][j] = "O"
				lines[i][j] = "O"
				if not MoveGuard(lines, DeepCopy(guard), guardSprites, os.clock()) then
					newLines[i][j] = "X"
				end
				lines = DeepCopy(oldLines) --  return to the initial state
			end
		end
	end

	return count(newLines, "O")
end

---@type string
local fileName = arg[2] or "exampleInput.txt"
if fileName == "default" then fileName = "defaultInput.txt" end

---@type file*?
local file = io.open(lfs.currentdir() .. "/day6/" .. fileName, "r")

---@type string
local debug = arg[3]

if file ~= nil then
	---@type table
	local lines = {}
	for line in file:lines() do
		---@type table
		local column = {}
		for character in line:gmatch(".") do
			table.insert(column, character)
		end
		table.insert(lines, column)
	end
	file:close()

	---@type table
	local guardSprites = {"^", ">", "v", "<"}
	---@type table
	local guard = guardInfo(lines, guardSprites)

	---@type integer
	local result1, result2 = part1(lines, DeepCopy(guard), guardSprites), part2(lines, DeepCopy(guard), guardSprites)

	if debug == "True" then
		debugExercise(lines)
	end

	print("Part 1: " .. result1)
	print("Part 2: " .. result2)
else
	print("File wasn't loaded successfully")
end