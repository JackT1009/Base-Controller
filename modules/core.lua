-- modules/core.lua
local M = {
    PROTOCOL = "BASECTRLv1",  -- Unique protocol identifier
    TIMEOUT = 5,             -- Seconds before timeout
    DEBUG = true             -- Enable debug logging
}

--[[
    Message Structure:
    {
        timestamp = number,
        sender = string,
        command = string,
        data = any
    }
]]

function M.log(...)
    if M.DEBUG then
        local args = {...}
        local msg = "["..os.epoch("utc").."] "..table.concat(args, " ")
        print(msg)
    end
end

function M.createMessage(sender, command, data)
    -- Validate mandatory fields
    if type(sender) ~= "string" then
        error("Sender must be string")
    end
    if type(command) ~= "string" then
        error("Command must be string")
    end
    
    return {
        timestamp = os.epoch("utc"),
        sender = sender,
        command = command,
        data = data or nil
    }
end

function M.send(target, message)
    -- Validate message structure
    if not message.timestamp then
        error("Invalid message: missing timestamp")
    end
    
    -- Serialize and transmit
    local serialized = textutils.serialize(message)
    M.log("Sending to", target, ":", serialized)
    rednet.send(target, serialized, M.PROTOCOL)
end

function M.receive()
    -- Receive with timeout
    local id, rawMessage = rednet.receive(M.PROTOCOL, M.TIMEOUT)
    
    if not rawMessage then
        M.log("Receive timeout")
        return nil, nil
    end
    
    -- Deserialize safely
    local success, message = pcall(textutils.unserialize, rawMessage)
    if not success then
        M.log("Failed to unserialize:", rawMessage)
        return id, nil
    end
    
    -- Validate message structure
    if type(message) ~= "table" then
        M.log("Invalid message format")
        return id, nil
    end
    
    -- Validate required fields
    local valid = true
    valid = valid and type(message.timestamp) == "number"
    valid = valid and type(message.sender) == "string"
    valid = valid and type(message.command) == "string"
    
    if not valid then
        M.log("Invalid message fields")
        return id, nil
    end
    
    M.log("Received valid message from", message.sender)
    return id, message
end

-- Helper function for modem setup
function M.initializeModem(side)
    local modem = peripheral.find("modem", side)
    if not modem then
        error("No modem on "..tostring(side))
    end
    rednet.open(peripheral.getName(modem))
    M.log("Modem opened on", side)
end

return M
