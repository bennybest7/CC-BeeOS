beeos = dofile("/beeos/beeos.lua")
local args = {...}
local dir1 = resolve(args[1])
local dir2 = resolve(args[2])
if fs.exists(dir1) then
    fs.copy(dir1,dir2)
else
    printError("No such file/directory.")
end

