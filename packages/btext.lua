beeos = dofile("/beeos/beeos.lua")
local can_continue = true
local args = ...

--local args = "/beeos/bin/beefetch.lua"

if args == nil then 
    can_continue = false
    printError("No file path specified.")
end
if can_continue then
    dir = resolve(args)
end
--local dir = "/test.txt"
if can_continue then
    if fs.isDir(dir) then 
        printError("Specified path is a directory.")
        can_continue = false 
        
    end
end

if can_continue and not fs.exists(dir) then
    local file = fs.open(dir,"w")
    file.write("")
    file.close()
end

local size_x,size_y = term.getSize()
local scroll = 1
local scroll_x = 1
local selection = 1
local mode = "select"
local info = "small"
local document = {}

--Open File
if can_continue then
    local file = fs.open(dir,"r")
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(document,line)
    end
    file.close()
end


function draw()
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    --term.clear()
    term.setCursorPos(1,1)
    for i = 1,size_y do
        term.setCursorPos(1,i)
        if selection == i then
            term.setBackgroundColor(colors.gray)
        else
            term.setBackgroundColor(colors.black)
        end
        io.write("   ")
        term.setCursorPos(1,i)
        io.write(i+scroll-1)
        
        paintutils.drawLine(4,i,size_x,i,colors.black)
        
        term.setCursorPos(4,i)
        --local text_field = window.create(term.current(),4,i,size_x-4,1)
        --local old_term = term.redirect(text_field)
        term.setBackgroundColor(colors.black)
        if document[i+scroll-1] then
            term.write(document[i+scroll-1]:sub(scroll_x,#document[i+scroll-1]))
            if #document[i+scroll-1]-scroll_x+1 > size_x then
                term.setCursorPos(size_x-2,i)
                io.write("...")
            end
        end
    end
    if info == "small" then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.orange)
        term.setCursorPos(size_x-16,1)
        print("Press H for help.")
    elseif info == "full" then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.orange)
        term.setCursorPos(size_x-20,1)
        print("H - Close this menu. ")
        term.setCursorPos(size_x-20,2)
        print("S - Save file.       ")
        term.setCursorPos(size_x-20,3)
        print("R - Run file.        ")
        term.setCursorPos(size_x-20,4)
        print("E - Exit.            ")
        term.setCursorPos(size_x-20,5)
        print("I - Insert line.     ")
        term.setCursorPos(size_x-20,6)
        print("btext v1.0.          ")
        term.setCursorPos(size_x-20,7)
        print("Made by Bennybest7.  ")
        
    else
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.orange)
        term.setCursorPos(1,size_y)
        io.write("Press H for help. Size: "..#document)
    end
    term.setTextColor(colors.white)
end

while can_continue do
    draw()
    if mode == "select" then
        local event,key = os.pullEvent("key")
        
        if info == "small" then
            info = "none"
        end
        
        
        if key == keys.up then
            selection = selection - 1
            if selection < 3 and scroll > 1 then
                scroll = scroll - 1
                selection = selection + 1
            end
        elseif key == keys.down then
            selection = selection + 1
            if selection > 15 then
                scroll = scroll + 1
                selection = selection - 1
            end
        elseif key == keys.right then
            scroll_x = scroll_x + 1
        elseif key == keys.left and scroll_x > 1 then
            scroll_x = scroll_x - 1
        elseif key == keys.enter then
            mode = "type"
            while selection+scroll-1 > #document do
                table.insert(document,"")
            end
        elseif key == keys.e then
            term.setBackgroundColor(colors.black)
            term.setCursorPos(1,1)
            term.clear()
            break
        elseif key == keys.h then
            if info == "full" then
                info = "hidden"
            else
                info = "full"
            end
        elseif key == keys.s then
            local file = fs.open(dir,"w")
            for i = 1,#document do
                file.writeLine(document[i])
            end
            file.close()
            term.setTextColor(colors.green)
            term.setCursorPos(size_x-16,1)
            print("   File Saved!   ")
            sleep(1)
        elseif key == keys.i then
            table.insert(document,selection+scroll-1,"")

        elseif key == keys.r then
            local file = fs.open("/beeos/tmp/btext-temp.lua","w")
            for i = 1,#document do
                file.writeLine(document[i])
            end
            file.close()
        
        
            term.setBackgroundColor(colors.black)
            term.clear()
            paintutils.drawLine(1,1,size_x,1,colors.gray)
            term.setTextColor(colors.white)
            term.setCursorPos(1,1)
            print("btext - testing program...")
            local prog_window = window.create(term.current(),1,2,size_x,size_y-1)
            local old_term = term.redirect(prog_window)
            os.run({},"/beeos/tmp/btext-temp.lua")
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.orange)
            print("Press any key to exit...")
            local event,key = os.pullEvent("key")
            local event,key = os.pullEvent("key_up")
            term.redirect(old_term)
        end
        
        
        if selection < 1 then
            selection = 1
        end
    elseif mode == "type" then
        term.setCursorPos(4,selection)
        document[selection+scroll-1] = read(nil,nil,nil,document[selection+scroll-1])
        mode = "select"
    end
end
