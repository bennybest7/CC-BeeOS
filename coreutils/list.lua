beeos = dofile("/beeos/beeos.lua")

start_x,start_y = term.getCursorPos()

args = ...
--args = "/beeos"
if args == nil then
    args = getDir()
end
local dir = resolve(args)
local files = fs.list(dir)
term.setTextColor(colors.orange)
print("Name:          Type:")
term.setTextColor(colors.white)

for i = 1,#files do
    if fs.isDir(fs.combine(dir,files[i])) then
        term.setTextColor(colors.lightBlue)
    else
        term.setTextColor(colors.white)
    end
    print(files[i])
    
    if fs.isDir(fs.combine(dir,files[i])) then
        filetype = "directory"
    else   
        filetype = strSplit(files[i],"%a+")[2]
        if filetype == "lua" then
            filetype = "program"
        elseif filetype == "txt" then
            filetype = "text"
        elseif filetype == "cfg" then
            filetype = "config"
        elseif filetype == "nfp" then
            filetype = "image"
        else
            filetype = "file"
        end
    end
    
    term.setTextColor(colors.white)
    cur_x,cur_y = term.getCursorPos()
    term.setCursorPos(16,cur_y-1)
    print(filetype)
end




