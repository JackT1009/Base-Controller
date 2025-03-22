local core = require("modules/core")

rednet.open("right")
print("Server ID: "..os.getComputerID())

while true do
    local id, message = core.receive()
    if message then
        print("Received from "..message.sender..": "..message.command)
        core.send(id, core.createMessage("Server", "ACK", message.command))
    end
end
