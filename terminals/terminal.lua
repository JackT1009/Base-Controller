-- terminals/terminal.lua
local modem = peripheral.find("modem") or error("Modem required")
local monitor = peripheral.find("monitor") or term
rednet.open(peripheral.getName(modem))

-- Configure monitor display
monitor.clear()
monitor.setTextScale(0.5) -- Smaller text for more lines
local width, height = monitor.getSize()

-- Display header
monitor.setCursorPos(1,1)
monitor.write("== FLOOR 1 CONTROL ==")

-- Registration
monitor.setCursorPos(1,3)
rednet.send(1, "REGISTER")
local _, response = rednet.receive(2)
monitor.write("Status: "..(response or "No connection!"))

-- Main interface function
local function drawMenu()
    monitor.setCursorPos(1,5)
    monitor.write("1. Lights On  ") -- Clear line with spaces
    monitor.setCursorPos(1,6)
    monitor.write("2. Lights Off ")
    monitor.setCursorPos(1,8)
    monitor.write("Last response: ")
end

-- Main loop
while true do
    drawMenu()
    
    local event, side, x, y = os.pullEvent("monitor_touch")
    
    if y == 5 then -- Lights On
        rednet.send(1, "LIGHTS-ON")
    elseif y == 6 then -- Lights Off
        rednet.send(1, "LIGHTS-OFF")
    end
    
    -- Get response
    local _, msg = rednet.receive(2)
    monitor.setCursorPos(1,8)
    monitor.write("Last response: "..(msg or "Timeout!     "))
end
