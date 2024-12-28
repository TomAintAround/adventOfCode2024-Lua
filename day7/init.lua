local lfs = require("lfs")

---Tests if the equation could be valid
---@param result number?: The result of the equation
---@param values table: All the values
---@param base integer: Number of operators
---@return boolean: Whether the equation could be valid
local testValues = function(result, values, base)
	---@type integer
	local maximumPossibilities = base ^ (#values - 1)
	---@type integer
	local state = 0

	while state < maximumPossibilities do
		---@type integer
		local testResult = values[1]
		for number = 2, #values, 1 do
			---@type integer
			local digit = math.floor(state / base ^ (number - 2)) % base
			if digit == 0 then
				testResult = testResult + values[number]
			elseif digit == 1 then
				testResult = testResult * values[number]
			else -- this will never be run if the base is 2
				---@type integer
				local jump = values[number]:len()
				testResult = testResult * 10 ^ jump + values[number]
			end
		end
		if testResult == result then
			return true
		end
		state = state + 1
	end

	return false
end

---Sums the correct equations
---@param lines table: Every line of the input
---@param base integer: The number of operators used
---@return integer: The sum
local sumCorrectEquations = function(lines, base)
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

		if testValues(result, values, base) then
			sum = sum + result
		end
	end

	return sum
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

	print("Part 1: " .. sumCorrectEquations(lines, 2))
	-- Without this hack, the number will be printed like this: 2.0e+12 (example)
	print(string.format("Part 2: %.0f", sumCorrectEquations(lines, 3)))
	file:close()
else
	print("File wasn't loaded successfully")
end