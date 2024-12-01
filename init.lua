---Runs a specific day exercise
---arg[1]: Day number
---arg[2+]: Other arguments
if arg[1] ~= nil then
    loadfile("day" .. arg[1] .. "/init.lua")(arg)
else
    print("You need to input the day number")
end