-- terminal/main.lua
local core = require("modules/core")

rednet.open("left")
local termName = os.getComputerLabel() or "Unnamed"

while true do
    write("Command: ")
    local input = read()
    
    local msg = core.createMessage(termName, input, {})
    core.send(core.CHANNEL, msg)
    
    local id, response = core.receive()
    print(response and response.data or "Timeout")
end
