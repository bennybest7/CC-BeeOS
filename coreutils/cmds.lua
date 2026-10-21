beeos = dofile("/beeos/beeos.lua")
print("List of commands:")
local listing = fs.list("/beeos/bin/")
local cmds = {}
for i = 1,#listing do
    table.insert(cmds,strSplit(listing[i],"%a+")[1])
end
textutils.pagedTabulate(cmds)
