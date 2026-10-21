io.write("Rebooting")
for i = 1,3 do
    sleep(0.2)
    io.write(".")
end
sleep(0.2)
os.reboot()
