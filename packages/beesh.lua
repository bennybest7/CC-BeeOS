beeos = dofile("/beeos/beeos.lua")
local version = "1.0.0"
while true do
    term.setTextColor(colors.orange)
    term.setBackgroundColor(colors.black)
    io.write(getDir().." -> ")
    term.setTextColor(colors.white)
    local cmd = read()
    arg = strSplit(cmd)[2]
    arg2 = strSplit(cmd)[3]
    cmd = strSplit(cmd)[1]
    
    
    if fs.exists(resolve(cmd)) then
        os.run({},resolve(cmd),arg,arg2)
    elseif fs.exists("/beeos/bin/"..cmd..".lua") then
        os.run({},"/beeos/bin/"..cmd..".lua",arg,arg2)
    elseif cmd == "exit" then break
    elseif cmd == "beeshver" then
        print("Beesh v"..version)
    else
        printError("File not found.")
    end
end
