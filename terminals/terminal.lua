-- terminals/terminal.lua
local modem = peripheral.find("modem") or error("Need modem")
local monitor = peripheral.find("monitor") or term
rednet.open(peripheral.getName(modem))

monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Floor 1 Terminal\n")

while true do
    monitor.setCursorPos(1,3)
    monitor.write("1. Ping Server\n")
    monitor.write("2. Exit\n")
    
    local event, side, x, y = os.pullEvent("monitor_touch")
    if y == 3 then
        rednet.send(1, "PING") -- Send to server ID 1
        local _, response = rednet.receive(2) -- Wait 2 seconds
        monitor.setCursorPos(1,6)
        monitor.clearLine()
        monitor.write(response or "No response!")
    elseif y == 4 then
        error()
    end
end
