--BeeOS API

function getVersion(compare)
    if compare then
        return 1
    else
        return "1.0.0"
    end
end

function bWrite(text,textcol,bgcol,x,y)
    local bgcol_old = term.getBackgroundColor()
    local textcol_old = term.getTextColor()
    local x_old,y_old = term.getCursorPos()
    term.setBackgroundColor(bgcol)
    term.setTextColor(textcol)
    term.setCursorPos(x,y)
    io.write(text)
    term.setTextColor(textcol_old)
    term.setBackgroundColor(bgcol_old)
    term.setCursorPos(x_old,y_old)
end

function drawButton(text,x,y,color)
    term.setTextColor(colors.black)
    if color == "red" then
        term.setBackgroundColor(colors.red)
    elseif color == "disabled" then
        term.setBackgroundColor(colors.lightGray)
    else
        term.setBackgroundColor(colors.green)
    end
    term.setCursorPos(x,y)
    io.write(" "..text.." ")
end

function strSplit(str,match)
    if match == nil then
        match = "%S+"
    end
    local words = {}
    for word in str:gmatch(match) do
        table.insert(words,word)
    end
    return words
end

function readConfig(name)
    local file = fs.open("/beeos/cfg/"..name,"r")
    local line = file.readLine()
    file.close()
    return line
end

function downloadFile(url,dir)
    if http.checkURL(url) == true then
        local file = http.get(url)
        local text = file.readAll()
        file.close()
        --print(text)
        local file1 = fs.open(dir,"w")
        file1.write(text)
        file1.close()
    else
        printError("Error: Could not download file.")
    end    
end


--BeeFS
function getDir()
    local file = fs.open("/beeos/tmp/dir","r")
    local dir = file.readLine()
    file.close()
    return dir
end

function setDir(dir)
    local new_dir
    if dir:sub(1,1) == "/" then
        new_dir = dir
    else
        new_dir = "/"..fs.combine(getDir(),dir)
    end
    if new_dir:sub(#new_dir,#new_dir) == "/" then
    else    
        new_dir = new_dir.."/"
    end
    
    if fs.isDir(new_dir) then
        local file = fs.open("/beeos/tmp/dir","w")
        file.write(new_dir)
        file.close()
    else
        printError("Not a directory.")
    end
end

function resolve(dir)
    local new_dir
    if dir:sub(1,1) == "/" then
        new_dir = dir
    else
        new_dir = "/"..fs.combine(getDir(),dir)
        if fs.isDir(new_dir) then
            if new_dir:sub(#new_dir,#new_dir) == "/" then
            else
                new_dir = new_dir.."/"
            end
        end
            
    end
    return new_dir
end



