-- server/main.lua
local modem = peripheral.find("modem") or error("Modem required")
rednet.open(peripheral.getName(modem))

print("Base Control Server Online")
print("ID: "..os.getComputerID())

while true do
    local sender, message = rednet.receive()
    local response
    
    -- Registration
    if message == "REGISTER" then
        print("New terminal: "..sender)
        response = "REG_OK-"..sender
    
    -- Light control
    elseif message:find("LIGHTS-") then
        local state = message:sub(8)
        rs.setOutput("left", state == "ON")
        response = "LIGHTS-"..(state == "ON" and "ON" or "OFF")
    
    end
    
    if response then
        rednet.send(sender, response)
        print("Sent: "..response)
    end
end
