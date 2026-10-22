local installer_ver = "0.1"
local target_ver = "1.0.0"

function download(url,dir)
    local request = http.get(url)
    local text = request.readAll()
    local file = fs.open(dir,"w")
    file.write(text)
    file.close()
    request.close()
    
end

function downloadTmp(url,line1)
    local file = http.get(url)
    if line1 then
        content = file.readLine()
    else
        content = file.readAll()
    end
    file.close()
    return content
end


term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
io.write("Install BeeOS? [y/N]: ")
if read() == "y" then
    term.setCursorPos(1,1)
    term.clear()
    term.setTextColor(colors.orange)
    print("Installer for: BeeOS v"..target_ver)
    print("Installer version: "..installer_ver)
    print()
    
    term.setTextColor(colors.white)
    print("Checking version...")
    local latest_ver = downloadTmp("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/version.txt",true)
    io.write("Latest BeeOS version is: v"..latest_ver)
    if latest_ver == target_ver then
        print(". Up to date.")
    else
        term.setTextColor(colors.red)
        print(". Out of date, installing may cause issues.")
    end    
    print()
    term.setTextColor(colors.white)
    print("The base system will now be installed.")
    print("Press Enter to continue.")
    
    while true do
        local event,key = os.pullEvent("key")
        if key == keys.enter then
            break
        end
    end
    
    print()
    print("Creating directories...")
    fs.makeDir("/beeos/")
    fs.makeDir("/beeos/bin/")
    fs.makeDir("/beeos/tmp/")
    fs.makeDir("/beeos/cfg/")
    
    print("Downloading Kernel...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/beeos.lua","/beeos/beeos.lua")
    print("Downloading Startup.lua...")
    if fs.exists("/startup.lua") then
        fs.copy("/startup.lua","/startup-old.lua")
        fs.delete("/startup.lua")
    end
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/startup.lua","/startup.lua")
    print("Download coreutils...")
    print(" -> About...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/about.lua","/beeos/bin/about.lua")
    print(" -> Clear...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/clear.lua","/beeos/bin/clear.lua")
    print(" -> Cmds...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/cmds.lua","/beeos/bin/cmds.lua")
    print(" -> Copy...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/copy.lua","/beeos/bin/copy.lua")
    print(" -> Del...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/del.lua","/beeos/bin/del.lua")
    print(" -> Go...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/go.lua","/beeos/bin/go.lua")
    print(" -> List...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/list.lua","/beeos/bin/list.lua")
    print(" -> Mkdir...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/mkdir.lua","/beeos/bin/mkdir.lua")
    print(" -> Move...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/move.lua","/beeos/bin/move.lua")
    print(" -> Reboot...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/reboot.lua","/beeos/bin/reboot.lua")
    print(" -> Shutdown...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/coreutils/shutdown.lua","/beeos/bin/shutdown.lua")
    
    print("Downloading BeeSH shell...")
    download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/packages/beesh.lua","/beeos/bin/beesh.lua")
    
    term.setTextColor(colors.green)
    print("Done!")
    sleep(1)
    
    term.clear()
    local packages = {false,false,false}
    local selection = 1
    function draw()
        term.setCursorPos(1,1)
        term.setTextColor(colors.orange)
        
        print("Optional packages.")
        term.setTextColor(colors.white)
        print("Select optional packages to install:")
        print()
        print("    Beefetch (system info)")
        print("    Btext (text editor)")
        print("    Download (file downloader)")
        term.setCursorPos(1,4)
        for i = 1,3 do
            if selection == i then
                term.setTextColor(colors.orange)
            else
                term.setTextColor(colors.white)
            end
            print("[ ]")
            term.setCursorPos(2,i+3)
            if packages[i] then
                print("X")
            end
            term.setCursorPos(1,i+4)
        end
        
        if selection == 4 then
            term.setTextColor(colors.orange)
        else
            term.setTextColor(colors.white)
        end
        print("Continue")
    end
    while true do
        draw()
        local event,key = os.pullEvent("key")
        if key == keys.down and selection < 4 then
            selection = selection + 1
        elseif key == keys.up and selection > 1 then
            selection = selection - 1
        elseif key == keys.enter then
            if selection == 4 then
                break
            else
                if packages[selection] then
                    packages[selection] = false
                else
                    packages[selection] = true
                end
            end
        end
    end
    
    term.setTextColor(colors.white)
    print()
    if packages[1] then
        print("Downloading Beefetch...")
        download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/packages/beefetch.lua","/beeos/bin/beefetch.lua")
    end
    if packages[2] then
        print("Downloading Btext...")
        download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/packages/btext.lua","/beeos/bin/btext.lua")
    end
    if packages[3] then
        print("Downloading Download...")
        download("https://raw.githubusercontent.com/bennybest7/CC-BeeOS/refs/heads/main/packages/download.lua","/beeos/bin/download.lua")    
    end
    print()
    print("Creating config files...")
    local file = fs.open("/beeos/cfg/label.cfg","w")
    file.write("beeos")
    file.close()
    local file = fs.open("/beeos/cfg/autostart.cfg","w")
    file.write("")
    file.close()
    local file = fs.open("/beeos/cfg/shell.cfg","w")
    file.write("/beeos/bin/beesh.lua")
    file.close()
    
    term.setTextColor(colors.orange)
    print("Installation complete!")
    term.setTextColor(colors.white)
    print("Press enter to reboot.")
    while true do
        local event,key = os.pullEvent("key")
        if key == keys.enter then
            os.reboot()
        end
    end
end
