-- server/main.lua
local core = require("modules/core")

rednet.open("right")
print("Server ID: "..os.getComputerID())

while true do
    local id, msg = core.receive()
    if msg then
        print("From "..msg.sender..": "..msg.command)
        core.send(id, core.createMessage(
            "server",
            "ACK",
            "Received: "..msg.command
        ))
    end
end
