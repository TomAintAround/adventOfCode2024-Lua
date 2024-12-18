local lfs = require("lfs")

local count = function(line, objective)
	---@type integer
	local sum = 0
	for i = 1, #objective, 1 do
		for _ in line:gmatch(objective[i]) do sum = sum + 1 end
	end

	return sum
end

local countUpperDiagonals = function(lines, objective)
	---@type integer
	local sum = 0
	for i = 0, lines[1]:len() - objective[1]:len(), 1 do
		---@type table
		local diagonal1, diagonal2 = {}, {}
		for j = 1, lines[1]:len() - i, 1 do
			---@type integer
			local reversed = lines[1]:len() - (j - 1) - i
			table.insert(diagonal1, lines[j]:sub(j + i, j + i))
			table.insert(diagonal2, lines[j]:sub(reversed, reversed))
		end

		sum = sum + count(table.concat(diagonal1, ""), objective)
		sum = sum + count(table.concat(diagonal2, ""), objective)
	end
	
	return sum
end

local countLowerDiagonals = function(lines, objective)
	---@type integer
	local sum = 0
	for i = 1, #lines - 4, 1 do
		---@type table
		local diagonal1, diagonal2 = {}, {}
		for j = 1, #lines - i, 1 do
			---@type integer
			local reversed = lines[1]:len() - (j - 1)
			table.insert(diagonal1, lines[j + i]:sub(j, j))
			table.insert(diagonal2, lines[j + i]:sub(reversed, reversed))
		end

		sum = sum + count(table.concat(diagonal1, ""), objective)
		sum = sum + count(table.concat(diagonal2, ""), objective)
	end
	
	return sum
end

local part1 = function(lines)
	---@type table
	local objective = {"XMAS", "SAMX"}
	---@type integer
	local sum = 0

	for i = 1, #lines, 1 do
		sum = sum + count(lines[i], objective)
	end

	---@type table
	local verticalLines = {}
	for i = 1, lines[1]:len(), 1 do
		---@type table
		local verticalLine = {}
		for j = 1, #lines, 1 do
			table.insert(verticalLine, lines[j]:sub(i, i))
		end
		table.insert(verticalLines, table.concat(verticalLine, ""))
		sum = sum + count(table.concat(verticalLine, ""), objective)
	end

	sum = sum + countUpperDiagonals(lines, objective) + countLowerDiagonals(lines, objective)
	return sum
end

local isXorA = function(character)
	if character == "A" or character == "X" then
		return true
	end

	return false
end

local validXmas = function(lines, line, column)
	---@type string
	local character = lines[line]:sub(column, column)
	---@type string
	local topLeft = lines[line - 1]:sub(column - 1, column - 1)
	---@type string
	local topRight = lines[line - 1]:sub(column + 1, column + 1)
	---@type string
	local bottomLeft = lines[line + 1]:sub(column - 1, column - 1)
	---@type string
	local bottomRight = lines[line + 1]:sub(column + 1, column + 1)


	if character ~= "A" then
		return false
	end

	if isXorA(topLeft) or isXorA(topRight) or isXorA(bottomLeft) or isXorA(bottomRight)
	or topLeft == bottomRight or topRight == bottomLeft then
		return false
	end

	print(
		topLeft .. " " .. topRight
		.. "\n" .. " A " .. "\n" ..
		bottomLeft .. " " .. bottomRight .. "\n"
	)

	return true
end

local part2 = function(lines)
	---@type integer
	local sum = 0

	for i = 2, #lines - 1, 1 do
		for j = 2, lines[1]:len() - 1, 1 do
			if validXmas(lines, i, j) then sum = sum + 1 end
		end
	end

	return sum
end

---@type string
local fileName = arg[2] or "defaultInput.txt"
if fileName == "default" then fileName = "defaultInput.txt" end
local file = io.open(lfs.currentdir() .. "/day4/" .. fileName, "r")

if file ~= nil then
	---@type table
	local lines = {}
	for line in file:lines() do table.insert(lines, line) end

	---@type integer
	local result1, result2 = part1(lines), part2(lines)
	print("Part 1: " .. result1)
	print("Part 2: " .. result2)
else print("Failed wasn't loaded successfully.")
end