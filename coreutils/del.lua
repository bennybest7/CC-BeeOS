beeos = dofile("/beeos/beeos.lua")
local args = ...
local dir = resolve(args)
if fs.exists(dir) then
    fs.delete(dir)
else
    printError("No such file/directory.")
end
