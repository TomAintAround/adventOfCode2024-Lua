local lfs = require("lfs")

---Prints the tables and the corresponding differences and number of occurrences of the first table
---@param table1 table: First row
---@param table2 table: Second row
---@param differences table: Differences between the first row and the second
---@param occurrences table: Number of occurrences of numbers in the first row in the second
local function debugExercise(table1, table2, differences, occurrences)
	print("Row 1", "Row 2", "Diff", "Occurrences")
	for i = 1, #table1, 1 do
		print(table1[i], table2[i], differences[i], occurrences[i])
	end
	print("Row 1", "Row 2", "Diff", "Occurrences")
	print("")
end

---Solves the first problem
---@param file any: File that will be read
---@return integer: Result of the first part
local function part1(file)
	---@type table
	local lines = {}
	for line in file:lines() do
		lines[#lines + 1] = line
	end

	---@type table
	Array1 = {}
	---@type table
	Array2 = {}
	for i = 1, #lines, 1 do
		---@type table
		local numbers = {}
		for number in string.gmatch(lines[i], "([^".."	 ".."]+)") do
			table.insert(numbers, number)
		end

		table.insert(Array1, numbers[1])
		table.insert(Array2, numbers[2])
	end

	table.sort(Array1)
	table.sort(Array2)

	---@type table
	Differences = {}
	for i = 1, #Array1, 1 do
		Differences[i] = math.abs(Array1[i] - Array2[i])
	end

	---@type integer
	local sum = 0
	for i = 1, #Differences, 1 do
		sum = sum + Differences[i]
	end

	return sum
end

---Solves the second problem
---@return integer: Result of the second part
local function part2()
	---@type table
	Occurrences = {}
	for i = 1, #Array1, 1 do
		---@type integer
		local count = 0
		for j = 1, #Array2, 1 do
			if Array1[i] == Array2[j] then count = count + 1 end
		end
		table.insert(Occurrences, count)
	end
	
	---@type integer
	local sum = 0
	for i = 1, #Occurrences, 1 do
		sum = sum + Array1[i] * Occurrences[i]
	end

	return sum
end

---@type string
local fileName = arg[2] or "defaultInput.txt"
if fileName == "default" then fileName = "defaultInput.txt" end
local file = io.open(lfs.currentdir() .. "/" .. fileName, "r")

---@type string
local debug = arg[3]

if file ~= nil then
	---@type integer
	local result1 = part1(file)
	---@type integer
	local result2 = part2()
	file:close()

	if debug == "True" then
		debugExercise(Array1, Array2, Differences, Occurrences)
	end

	print("Part 1: " .. result1)
	print("Part 2: " .. result2)
else print("The file wasn't read successfully")
end
