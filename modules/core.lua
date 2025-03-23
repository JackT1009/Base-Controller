local M = {
    PROTOCOL = "BASECTRL",  -- Changed to string protocol
    TIMEOUT = 5
}

function M.createMessage(sender, command, data)
    return {
        timestamp = os.epoch("utc"),
        sender = sender,
        command = command,
        data = data
    }
end

function M.send(target, message)
    rednet.send(target, textutils.serialize(message), M.PROTOCOL)
end

function M.receive()
    local id, message = rednet.receive(M.PROTOCOL, M.TIMEOUT)
    if not message then return nil, "Timeout" end
    
    local success, data = pcall(textutils.unserialize, message)
    return success and id or nil, data
end

return M
