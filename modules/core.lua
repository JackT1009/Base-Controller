-- modules/core.lua
local M = {
    PROTOCOL = "BASECTRLv2",  -- Unique protocol identifier
    TIMEOUT = 5,              -- Seconds before timeout
    DEBUG = true              -- Enable debug logging
}

--[[
    Valid Message Structure:
    {
        version = 1,
        timestamp = number,
        sender = string,
        command = string,
        data = table|nil
    }
]]

-- Helper function for logging
function M.log(...)
    if M.DEBUG then
        local args = {...}
        local msg = textutils.serialize(args)
        print(string.format("[%s] CORE: %s", os.epoch("utc"), msg))
    end
end

-- Safe modem initialization
function M.initializeModem(side)
    if not peripheral.getType(side) == "modem" then
        error("No modem on "..tostring(side))
    end
    
    rednet.open(side)
    M.log("Modem opened on", side)
end

-- Message creation with validation
function M.createMessage(sender, command, data)
    -- Type checking
    if type(sender) ~= "string" then
        error("Sender must be string, got "..type(sender))
    end
    if type(command) ~= "string" then
        error("Command must be string, got "..type(command))
    end
    
    return {
        version = 1,
        timestamp = os.epoch("utc"),
        sender = sender,
        command = command,
        data = data or {}
    }
end

-- Safe message sending
function M.send(target, message)
    -- Validate message structure
    if not message.version then
        error("Invalid message: missing version")
    end
    if not message.timestamp then
        error("Invalid message: missing timestamp")
    end
    
    -- Serialize and send
    local serialized = textutils.serialize(message)
    M.log("Sending to", target, ":", serialized)
    
    local success, err = pcall(function()
        rednet.send(target, serialized, M.PROTOCOL)
    end)
    
    if not success then
        M.log("Send failed:", err)
        return false
    end
    return true
end

-- Robust message receiving
function M.receive()
    local startTime = os.epoch("utc")
    local id, message
    
    -- Receive with timeout
    repeat
        id, message = rednet.receive(M.PROTOCOL, 0.5)
    until message or (os.epoch("utc") - startTime > M.TIMEOUT * 1000)
    
    if not message then
        M.log("Receive timeout")
        return nil, nil
    end
    
    -- Deserialize safely
    local success, deserialized = pcall(textutils.unserialize, message)
    if not success then
        M.log("Deserialize failed:", message)
        return id, nil
    end
    
    -- Validate message format
    if type(deserialized) ~= "table" then
        M.log("Invalid message format")
        return id, nil
    end
    
    -- Check required fields
    local required = {"version", "timestamp", "sender", "command"}
    for _, field in ipairs(required) do
        if not deserialized[field] then
            M.log("Missing field:", field)
            return id, nil
        end
    end
    
    M.log("Received valid message from", deserialized.sender)
    return id, deserialized
end

return M
