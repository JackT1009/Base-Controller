-- modules/core.lua
local M = {}

-- Shared configuration
M.CHANNEL = 45100
M.TIMEOUT = 5 -- seconds

-- Message protocol
function M.createMessage(sender, command, data)
    return {
        timestamp = os.epoch("utc"),
        sender = sender,
        command = command,
        data = data,
        checksum = math.random(1000, 9999) -- Simple checksum
    }
end

-- Network utilities
function M.send(target, message)
    rednet.send(target, textutils.serialize(message))
end

function M.receive()
    local id, message = rednet.receive(M.TIMEOUT)
    return id, textutils.unserialize(message)
end

return M
