-- modules/core.lua (Fixed modem initialization)
local M = {
    PROTOCOL = "BASECTRLv1",
    TIMEOUT = 5,
    DEBUG = true
}

-- ... (previous core.lua code remains the same)

function M.initializeModem(side)
    -- Validate side parameter
    if not peripheral.getType(side) == "modem" then
        error("No modem on "..tostring(side))
    end
    
    -- Get modem reference
    local modem = peripheral.wrap(side)
    rednet.open(side)  -- Open modem on specified side
    
    M.log("Modem initialized on", side)
    return modem
end

return M
