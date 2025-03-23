-- modules/core.lua (Fixed modem initialization)
local M = {
    PROTOCOL = "BASECTRLv1",
    TIMEOUT = 5,
    DEBUG = true
}

-- ... (previous core.lua code remains the same)

function M.initializeModem(side)
    -- Validate modem exists on specified side
    if not peripheral.getType(side) == "modem" then
        error("No modem attached to "..side.." side")
    end
    
    -- Initialize modem properly
    rednet.open(side)
    M.log("Modem initialized on "..side)
end

return M
