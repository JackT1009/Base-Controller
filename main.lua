local core = require("modules/core")

-- Initialize
rednet.open("left")
local termName = os.getComputerLabel() or "Terminal"

while true do
    write("> ")
    local input = read()
    
    if input == "exit" then break end
    
    -- Send and receive with error handling
    core.send(1, core.createMessage(termName, input, {}))
    local id, response = core.receive()
    
    print(response and ("Server: "..response.data) or "No response")
end
