local core = require("modules/core")

rednet.open("left")
local termName = os.getComputerLabel() or "Terminal"

while true do
    write("> ")
    local input = read()
    
    if input == "exit" then break end
    
    core.send(1, {
        sender = termName,
        command = input,
        data = {}
    })
    
    local id, response = core.receive()
    if response then
        print(("Response: %s"):format(
            response.data or "no-data"
        ))
    else
        print("No response")
    end
end
