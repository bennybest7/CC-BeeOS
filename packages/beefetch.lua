beeos = dofile("/beeos/beeos.lua")

local start_x,start_y = term.getCursorPos()
local storage = math.floor((fs.getCapacity("/")-fs.getFreeSpace("/"))/1000).."/"..math.floor(fs.getCapacity("/")/1000).." kB"
local disp_x,disp_y = term.getSize()
local shell_cfg = readConfig("shell.cfg")
if term.isColor() then
    display = disp_x.."x"..disp_y.." (color)"
else
    display = disp_x.."x"..disp_y.." (grayscale)"
end
term.setTextColor(colors.white)
print("             OS: BeeOS v"..getVersion(false))
if os.getComputerLabel() == nil then
else
    print("             Label:",os.getComputerLabel())
end
print("             ID:",os.getComputerID())
print("             Shell: "..shell_cfg)
print("             Desktop:")
print("             Storage: "..storage)
print("             Display: "..display)

term.setCursorPos(start_x,start_y)
term.setTextColor(colors.lightBlue)
print("  %%% ###")
print(" %%%%%####")
print(" %%%%%####")
term.setTextColor(colors.orange)
print(" @ @@ @@ @")
print("@@ @@ @@ @@")
print("@@ @@ @@ @@")
print(" @_@@_@@_@")

