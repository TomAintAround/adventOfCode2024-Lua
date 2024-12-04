local lfs = require("lfs")

---Multiplies each element in 2 tables and places them in another table
---@param xTerms table: First table
---@param yTerms table: Second table
---@return table: Table with the result of the multiplications
local multiply = function(xTerms, yTerms)
    ---@type table
    local multiplicationTable = {}
    for i = 1, #xTerms, 1 do
        table.insert(multiplicationTable, xTerms[i] * yTerms[i])
    end
    return multiplicationTable
end

---Calculates the sum of all elements in a table
---@param table table: The table
---@return integer: The sum
local sum = function(table)
    ---@type integer
    local sum = 0
    for i = 1, #table, 1 do
        sum = sum + table[i]
    end
    return sum
end

---Solves the first problem
---@param text string: Input text
---@return integer: Result
local part1 = function(text)
    ---@type table
    local xTerms, yTerms = {}, {}
    for x, y in text:gmatch("mul%((%d+),(%d+)%)") do
        table.insert(xTerms, x)
        table.insert(yTerms, y)
    end

    local multiplications = multiply(xTerms, yTerms)
    return sum(multiplications)
end

---Soves the second problem
---@param text string: Input text
---@return integer: Result
local part2 = function(text)
    ---@type table
    local xTerms, yTerms = {}, {}
    text = text:gsub("don't%(%).-do%(%)", "")
    text = text:gsub("don't%(%).*", "")
    for x, y in text:gmatch("mul%((%d+),(%d+)%)") do
        table.insert(xTerms, x)
        table.insert(yTerms, y)
    end

    ---@type table
    local multiplications = multiply(xTerms, yTerms)
    return sum(multiplications)
end

---@type string
local fileName = arg[2] or "defaultInput.txt"
if fileName == "default" then fileName = "defaultInput.txt" end
local file = io.open(lfs.currentdir() .. "/day3/" .. fileName, "r")

if file ~= nil then
    ---@type string
    local text = file:read("*all")
    ---@type integer
    local result1, result2 = part1(text), part2(text)

    print("Part 1: " .. result1)
    print("Part 2: " .. result2)
else
    print("File wasn't loaded successfully")
end