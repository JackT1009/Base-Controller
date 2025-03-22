-- server/main.lua
local modem = peripheral.find("modem") or error("Need modem")
rednet.open(peripheral.getName(modem))

print("Server ID: "..os.getComputerID())

while true do
    local id, message = rednet.receive()
    local response
    
    if message == "PING" then
        print("Received ping from "..id)
        response = "PONG from Floor 1 Server"
    end
    
    if response then
        rednet.send(id, response)
        print("Sent response to "..id)
    end
end
