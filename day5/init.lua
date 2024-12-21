local lfs = require("lfs")

---Debugs today's challenge
---@param pageOrderingRules table: The page ordering rules
---@param validUpdates table: All valid updates (in strings)
---@param invalidUpdates table: All invalid updates (in strings)
local debugExercise = function(pageOrderingRules, validUpdates, invalidUpdates)
	print("Each number is before    these ones")
	for k, v in pairs(pageOrderingRules) do
		print(k .. "                       " .. table.concat(v, ","))
	end
	print("Each number is before    these ones")
	print()
	print("Valid Updates")
	for i = 1, #validUpdates, 1 do
		print(table.concat(validUpdates[i], ","))
	end
	print("Valid Updates")
	print()
	print("Corrected Invalid Updates")
	for i = 1, #invalidUpdates, 1 do
		print(table.concat(invalidUpdates[i], ","))
	end
	print("Corrected Invalid Updates")
	print()
end

---Sums the middle numbers in tables of numbers, that are in a table
---@param tableOfTables table: Table of tables of numbers
---@return integer: The sum of the middle numbers
local sumMiddleNumbers = function(tableOfTables)
	---@type integer
	local sum = 0
	for i = 1, #tableOfTables, 1 do
		---@type integer
		local middle = math.floor(#tableOfTables[i] / 2) + 1
		sum = sum + tableOfTables[i][middle]
	end

	return sum
end

---Solves the first problem
---@param validUpdates table: Table with the valid updates
---@return integer: The result
local part1 = function(validUpdates)
	return sumMiddleNumbers(validUpdates)
end

---Fixes an invalid update
---@param invalidUpdate table: The invalid update
---@param position integer: The position that is being assessed
---@param pageOrderingRules table: Table with the page ordering rules
---@return table: The invalid update now corrected
FixPosition = function(invalidUpdate, position, pageOrderingRules)
	if position > #invalidUpdate then
		return invalidUpdate
	else
		---@type string
		local previousNumber = invalidUpdate[position - 1]
		---@type string
		local currentNumber = invalidUpdate[position]

		for i = 1, #pageOrderingRules[previousNumber], 1 do
			if currentNumber == pageOrderingRules[previousNumber][i] then
				invalidUpdate[position]	= previousNumber
				invalidUpdate[position - 1] = currentNumber
				return FixPosition(invalidUpdate, 2, pageOrderingRules)
			end
		end
		return FixPosition(invalidUpdate, position + 1, pageOrderingRules)
	end
end

---Solves the second problem
---@param pageOrderingRules table: Table with the page ordering rules
---@param invalidUpdates table: Table with the invalid updates
---@return integer: The result
local part2 = function(pageOrderingRules, invalidUpdates)
	for i = 1, #invalidUpdates, 1 do
		invalidUpdates[i] = FixPosition(invalidUpdates[i], 2, pageOrderingRules)
	end

	return sumMiddleNumbers(invalidUpdates)
end

---Checks if an update is valid
---@param update table: The update in question
---@param pageOrderingRules table: Table with the page ordering rules
---@return boolean: The result
local checkUpdate = function(update, pageOrderingRules)
	for i = 1, #update - 1, 1 do
		---@type string
		local currentNumber, nextNumber = update[i], update[i + 1]
		for j = 1, #pageOrderingRules[currentNumber], 1 do
			if nextNumber == pageOrderingRules[currentNumber][j] then
				return false
			end
		end
	end

	return true
end

---@type string
local fileName = arg[2] or "exampleInput.txt" or "defaultInput.txt"
if arg[2] == "default" then fileName = "defaultInput.txt" end

---@type file*?
local file = io.open(lfs.currentdir() .. "/day5/" .. fileName, "r")

---@type string
local debug = arg[3]

if file ~= nil then
	---@type string
	local text = file:read("*all")
	file:seek("set", 0) -- resetting the file pointer to the beginning

	---@type table
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end

	---@type table
	local pageOrderingRules, updates, validUpdates, invalidUpdates = {}, {}, {}, {}

	--- This creates the page ordering rules. Each key number is associated with
	--- a table with the numbers that cannot be in front of the key number
	for before, after in text:gmatch("(%d+)%|(%d+)") do
		if not pageOrderingRules[after] then
			pageOrderingRules[after] = {before}
		else
			table.insert(pageOrderingRules[after], before)
		end

		if not pageOrderingRules[before] then
			pageOrderingRules[before] = {}
		end
	end

	for i = 1, #lines, 1 do
		if lines[i]:find(",") then
			---@type table
			local update = {}
			for number in lines[i]:gmatch("%d+") do
				table.insert(update, number)
			end
			table.insert(updates, update)
		end
	end

	for i = 1, #updates, 1 do
		if checkUpdate(updates[i], pageOrderingRules) then
			table.insert(validUpdates, updates[i])
		else
			table.insert(invalidUpdates, updates[i])
		end
	end

	---@type integer
	local result1, result2 = part1(validUpdates), part2(pageOrderingRules, invalidUpdates)
	file:close()

	if debug == "True" then
		debugExercise(pageOrderingRules, validUpdates, invalidUpdates)
	end

	print("Part 1: " .. result1)
	print("Part 2: " .. result2)
else
	print("File wasn't loaded successfully")
end