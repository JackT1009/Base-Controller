-- update.lua (Self-updating installer)
local GITHUB_USER = "JackT1009"
local GITHUB_REPO = "Base-Controller"
local INSTALL_DIR = "BaseControl"
local BRANCH = os.getComputerLabel() == "BaseCore" and "main-server" or "main-terminal"

-- Self-update check
local function updateSelf()
    local currentContent = fs.exists("update.lua") and fs.open("update.lua", "r").readAll() or ""
    local url = "https://raw.githubusercontent.com/"..GITHUB_USER.."/"..GITHUB_REPO.."/"..BRANCH.."/update.lua"
    local response = http.get(url)
    
    if response then
        local newContent = response.readAll()
        response.close()
        
        if newContent ~= currentContent then
            print("Updating installer...")
            local f = fs.open("update.new", "w")
            f.write(newContent)
            f.close()
            fs.delete("update.lua")
            fs.move("update.new", "update.lua")
            print("Please rerun the installer")
            error() -- Exit gracefully
        end
    end
end

-- Main installation
local function main()
    print("Installing BaseControl...")
    -- (Add your existing installation logic here)
    print("Install complete!")
end

updateSelf()
main()
