-- terminals/terminal.lua
local modem = peripheral.find("modem") or error("Modem required")
local monitor = peripheral.find("monitor") or term
rednet.open(peripheral.getName(modem))

-- Setup
monitor.clear()
monitor.setTextScale(0.5)
monitor.setCursorPos(1,1)
monitor.write("FLOOR 1 CONTROL\n")

-- Register with server
rednet.send(1, "REGISTER") -- Send to server ID 1
local _, response = rednet.receive(5)
monitor.write("Status: "..(response or "No connection!"))

-- Main interface
while true do
    monitor.setCursorPos(1,4)
    monitor.write("1. Lights On\n")
    monitor.write("2. Lights Off\n")
    
    local event, side, x, y = os.pullEvent("monitor_touch")
    
    if y == 4 then -- Lights On
        rednet.send(1, "LIGHTS-ON")
    elseif y == 5 then -- Lights Off
        rednet.send(1, "LIGHTS-OFF")
    end
    
    -- Get response
    local _, msg = rednet.receive(2)
    monitor.setCursorPos(1,8)
    monitor.write("Last response: ")
    monitor.write(msg or "Timeout!")
end
