local M = {
    PROTOCOL = "BASECTRL",
    TIMEOUT = 5
}

function M.send(target, message)
    message = message or {}
    message.timestamp = os.epoch("utc")
    rednet.send(target, textutils.serialize(message), M.PROTOCOL)
end

function M.receive()
    local id, message = rednet.receive(M.PROTOCOL, M.TIMEOUT)
    if not message then return nil, "Timeout" end
    
    local success, data = pcall(textutils.unserialize, message)
    if not success then
        return nil, "Invalid message format"
    end
    
    return id, data
end

return M
