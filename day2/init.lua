local lfs = require("lfs")

---Prints every line with each safeness value, one for each part
---@param lines table: Lines table
---@param safeness1 table: The first safeness table
---@param safeness2 table: The second safeness table
local debugExercise = function(lines, safeness1, safeness2)
    print("Input numbers", "    ", "Safeness 1", "Safeness2")
    for i = 1, #lines, 1 do
        print(lines[i], "   ", safeness1[i], "  ", safeness2[i])
    end
    print("Input numbers", "    ", "Safeness 1", "Safeness2")
    print()
end

---Makes a copy of a table
---@param table table: The table that will be copied
---@return table: The copied table
local copy = function(table)
    ---@type table
    local copyTable = {}
    for k, v in pairs(table) do
        copyTable[k] = v
    end
    return copyTable
end

---Sums all values in a table
---@param table table: The table
---@return integer: The sim
local sum = function(table)
    ---@type integer
    local value = 0
    for i = 1, #table, 1 do
        value = value + table[i]
    end
    return value
end

---Verifies the safety of each line
---@param currentLine table: Table with the elements of the current line
---@param maxErrors integer: The maximum ammount of errors allowed
---@return boolean: The safety of the line
VerifyLine = function(currentLine, maxErrors)
    ---@type boolean
    local errorOcurred = false
    ---@type table
    local differenceSigns = {}
    for i = 2, #currentLine, 1 do
        ---@type integer
        local difference = currentLine[i] - currentLine[i - 1]
        ---@type integer
        local differenceSign = 0

        if difference < 0 then differenceSign = -1
        elseif difference > 0 then differenceSign = 1
        end

        table.insert(differenceSigns, differenceSign)

        if math.abs(difference) < 0 or math.abs(difference) > 3 then
            errorOcurred = true
        end
    end

    ---@type integer
    local sumDifferences = math.abs(sum(differenceSigns))
    if sumDifferences ~= #differenceSigns then
        errorOcurred = true
    end

    if not errorOcurred then return true end
    if maxErrors > 0 then
        for i = 1, #currentLine, 1 do
            ---@type table
            local currentLineCopy = copy(currentLine)
            table.remove(currentLineCopy, i)

            ---@type boolean
            local nextTry = VerifyLine(currentLineCopy, maxErrors - 1)
            if nextTry then return true end
        end
    end
    return false
end

---Creates a safety table
---@param lines table: The table with all the lines
---@param maxErrors integer: The maximum ammount of errors allowed
---@return table: The safety table
local safety = function(lines, maxErrors)
    ---@type table
    local safeness = {}
    for i = 1, #lines, 1 do
        ---@type table
        local currentLine = {}
        for number in string.gmatch(lines[i], "([^".." ".."]+)") do
            table.insert(currentLine, tonumber(number))
        end

        ---@type boolean
        local valid = VerifyLine(currentLine, maxErrors)

        if valid then table.insert(safeness, 1)
        else table.insert(safeness, 0)
        end
    end
    return safeness
end

---Solves the first problem
---@param lines table: The lines table
---@return integer: Sum of all elements in the safety table
local part1 = function(lines)
    ---@type table
    Safeness1 = safety(lines, 0)
    return sum(Safeness1)
end

---Solves the second problem
---@param lines table: The lines table
---@return integer: Sum of all elements in the safety table
local part2 = function(lines)
    ---@type table
    Safeness2 = safety(lines, 1)
    return sum(Safeness2)
end

---@type string
local fileName = arg[2] or "defaultInput.txt"
if fileName == "default" then fileName = "defaultInput.txt" end
local file = io.open(lfs.currentdir() .. "/day2/" .. fileName, "r")

---@type string
local debug = arg[3]

if file ~= nil then
    ---@type table
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end

    ---@type integer
    local result1, result2 = part1(lines), part2(lines)

    if debug == "True" then
        debugExercise(lines, Safeness1, Safeness2)
    end

    print("Part 1: " .. result1)
    print("Part 2: " .. result2)
else
    print("File wasn't loaded successfully")
end