beeos = dofile("/beeos/beeos.lua")
args = ...
if args == nil then
    printError("Invalid argument.")
else
    dir = resolve(args)
    fs.makeDir(dir)
end
