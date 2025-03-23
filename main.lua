local core = require("modules/core")

rednet.open("right")
print("Server ID: "..os.getComputerID())

while true do
    local id, message = core.receive()
    if message then
        -- Safe message handling
        local sender = message.sender or "unknown"
        local command = message.command or "no-command"
        local data = message.data or "no-data"
        
        print(("From %s: %s | %s"):format(
            sender,
            command,
            textutils.serialize(data)
        )
        
        core.send(id, {
            sender = "Server",
            command = "ACK",
            data = command
        })
    end
end
