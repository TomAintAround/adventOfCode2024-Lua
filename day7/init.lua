local lfs = require("lfs")
local bit = require("bit")

---Tests if the equation could be valid
---@param result number?: The result of the equation
---@param values table: All the values
---@return boolean: Whether the equation could be valid
local testValues = function(result, values)
	-- if there are 3 values, this variable will be 0b11
	---@type integer
	local maximumPossibilities = bit.lshift(1, #values - 1) - 1
	---@type integer
	local state = 0

	while state <= maximumPossibilities do
		---@type integer
		local testResult = values[1]
		for number = 2, #values, 1 do
			if bit.band(bit.rshift(state, number - 2), 1) == 0 then
				testResult = testResult + values[number]
			else
				testResult = testResult * values[number]
			end
		end
		if testResult == result then
			return true
		end
		state = state + 1
	end

	return false
end

---Solves the first proble,
---@param lines table: Table with all the lines of the input
---@return number: The result
local part1 = function(lines)
	---@type integer
	local sum = 0
	for line = 1, #lines, 1 do
		---@type number?
		local result = tonumber(lines[line]:match("%d+"))
		---@type table
		local values = {}
		for number in lines[line]:gmatch(" (%d+)") do
			table.insert(values, number)
		end

		if testValues(result, values) then
			sum = sum + result
		end
	end

	return sum
end

-- TODO
local part2 = function()
	return -1
end

---@type string
local fileName = arg[2] or "defaultInput.txt"
if fileName == "default" then fileName = "defaultInput.txt" end
---@type file*?
local file = io.open(lfs.currentdir() .. "/day7/" .. fileName, "r")

if file ~= nil then
	---@type table
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end

	---@type integer
	local result1, result2 = part1(lines), part2()
	file:close()

	print("Part 1: " .. result1)
	print("Part 2: " .. result2)
else
	print("File wasn't loaded successfully")
end