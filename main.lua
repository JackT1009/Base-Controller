local core = require("modules/core")

rednet.open("left")
local termName = os.getComputerLabel() or "Terminal"

while true do
    write(termName.."> ")
    local input = read()
    
    if input == "exit" then break end
    
    local msg = core.createMessage(termName, input, {})
    core.send(core.CHANNEL, msg)
    
    local id, response = core.receive()
    if response then
        print("Server response:", response.data)
    else
        print("No response from server")
    end
end
