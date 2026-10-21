beeos = dofile("/beeos/beeos.lua")
local args = {...}
if args[1] then
    if args[2] then
        local dir = resolve(args[2])
        print("Downloading...")
        downloadFile(args[1],dir)
        print("Done!")
    else
        printError("No file specified.")
    end
else
    printError("No URL specified.")
end
