local M = {
    CHANNEL = 45100,
    TIMEOUT = 5
}

function M.createMessage(sender, command, data)
    return textutils.serialize({
        timestamp = os.epoch("utc"),
        sender = sender,
        command = command,
        data = data
    })
end

function M.send(target, message)
    rednet.send(target, message, M.CHANNEL)
end

function M.receive()
    local id, message = rednet.receive(M.CHANNEL, M.TIMEOUT)
    if not message then return nil, "Timeout" end
    
    local success, data = pcall(textutils.unserialize, message)
    return success and id or nil, data
end

return M
