local core = require("modules/core")

rednet.open("right")
print("Server ID: "..os.getComputerID())

while true do
    local id, message = core.receive()
    
    -- Validate message structure
    if type(message) ~= "table" then
        print("Invalid message format from "..(id or "unknown"))
        goto continue
    end
    
    -- Safe field access
    local sender = message.sender or "unknown"
    local command = message.command or "no-command"
    
    print(("From [%s]: %s"):format(sender, command))
    
    -- Send acknowledgement
    core.send(id, {
        sender = "Server",
        command = "ACK",
        data = command
    })
    
    ::continue::
end
