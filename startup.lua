--BEEOS BOOTLOADER v1.0.0

term.setCursorPos(1,1)
term.setBackgroundColor(colors.black)
term.clear()

--BeeOS boot manager
local beeos = dofile("/beeos/beeos.lua")
local disks = {"/"}
if fs.exists("/disk/startup.lua") then
    table.insert(disks,"/disk/")
end
for i = 2,6 do
    if fs.exists("/disk"..i.."/startup.lua") then
        table.insert("/disk"..i.."/")
    end
end
local selection = 1

if #disks > 1 then
    while true do
        term.setCursorPos(1,1)
        term.setTextColor(colors.orange)
        print("Select a boot disk:")
        term.setTextColor(colors.white)
        print("    HDD")
        for i = 2,#disks do
            print("    "..disks[i])
        end
        term.setTextColor(colors.orange)
        term.setCursorPos(2,selection+1)
        print("->")
        
        local event,key = os.pullEvent("key")
        if key == keys.up and selection > 1 then
            selection = selection - 1
        elseif key == keys.down and selection < #disks then
            selection = selection + 1
        elseif key == keys.enter then
            if selection == 1 then break
            else
                term.setTextColor(colors.white)
                os.run({},disks[selection].."startup.lua")
                os.shutdown()
            end
        end
    end
end
--Start BeeOS
term.setCursorPos(1,1)
term.clear()
term.setTextColor(colors.orange)
print("BeeOS v"..getVersion(false))
term.setTextColor(colors.white)

print(" // Clearing /beeos/tmp...")
fs.delete("/beeos/tmp/")
fs.makeDir("/beeos/tmp/")

print(" // Setting directory...")
local file = fs.open("/beeos/tmp/dir","w")
file.write("/")
file.close()

print(" // Running autostart commands...")
local file = fs.open("/beeos/cfg/autostart.cfg","r")
while true do
    local line = file.readLine()
    if not line then break end
    if fs.exists(line) and string.len(line) > 1 then
        os.run({},line)
    else

        if not line or string.len(line) == 0 then
        else
            printError("No such file.")
        end
    end
end
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)

print(" // Starting shell...")
local shell_run = readConfig("shell.cfg")
if fs.exists(shell_run) then
    os.run({},shell_run)
else
    printError("Invalid shell path.")
end
term.setTextColor(colors.orange)
term.setBackgroundColor(colors.black)
print("Press any key to shutdown...")
os.pullEvent("key")
os.shutdown()
