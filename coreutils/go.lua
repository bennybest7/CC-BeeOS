beeos = dofile("/beeos/beeos.lua")
args = ...
if args == nil then
    printError("Invalid argument.")
else
    setDir(args)
end
