local core = require("modules/core")

-- Initialize modem
core.initializeModem("left")  -- Change to your modem side

-- Terminal setup
local termName = os.getComputerLabel() or "UnnamedTerminal"
print("Terminal Online:", termName)

-- Main loop
while true do
    -- Safe input handling
    term.write("> ")
    local input = string.trim(read() or "")
    
    if input == "" then
        print("Error: Empty command")
        goto continue
    end
    
    if input == "exit" then
        print("Shutting down...")
        break
    end
    
    -- Create validated message
    local message = core.createMessage(termName, input, {})
    
    -- Send with error handling
    local ok, err = pcall(function()
        core.send(1, message)  -- Send to server ID 1
    end)
    
    if not ok then
        print("Send failed:", err)
        goto continue
    end
    
    -- Receive response
    local _, response = core.receive()
    if response then
        print("Server:", response.command)
    else
        print("No response")
    end
    
    ::continue::
end
