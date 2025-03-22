-- server/main.lua
local module = require("modules/core")

print("Base Control Server Online")
print("ID: "..os.getComputerID())

rednet.open("right") -- Change to your modem side

while true do
    local id, message = rednet.receive()
    print("Received: "..message)
    rednet.send(id, "ACK: "..message)
end
