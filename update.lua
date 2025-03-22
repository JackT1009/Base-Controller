-- update.lua
local GITHUB_USER = "JackT1009"
local GITHUB_REPO = "Base-Controller"
local INSTALL_DIR = "BaseControl"

local BRANCH = "main-server"
if os.getComputerLabel() ~= "BaseCore" then
    BRANCH = "main-terminal"
end

local function debug(msg)
    local colors = {red = colors.red, white = colors.white}
    if peripheral.find("monitor") then term.setTextColor(colors.white) end
    print("> "..msg)
end

local function get(url)
    for i=1,3 do
        local res = http.get(url)
        if res then return res end
        sleep(2)
    end
    return nil
end

local function install()
    debug("Starting install from "..BRANCH)
    
    -- File list with explicit paths
    local files = {
        "update.lua", -- Must be first!
        BRANCH == "main-server" and "server/main.lua" or "terminals/terminal.lua",
        "lib/protocol.lua"
    }
    
    -- Wipe old install
    if fs.exists(INSTALL_DIR) then
        debug("Removing old install")
        fs.delete(INSTALL_DIR)
    end
    fs.makeDir(INSTALL_DIR)
    
    -- Download files
    for _,path in pairs(files) do
        local url = "https://raw.githubusercontent.com/"..
            GITHUB_USER.."/"..GITHUB_REPO.."/"..BRANCH.."/"..path
        
        debug("Downloading: "..url)
        local res = get(url)
        if not res then
            error("Missing: "..url)
        end
        
        local full_path = fs.combine(INSTALL_DIR, path)
        fs.makeDir(fs.getDir(full_path))
        local f = fs.open(full_path, "w")
        f.write(res.readAll())
        f.close()
    end
    
    print("\nSuccess! Run:")
    print("cd "..INSTALL_DIR)
    print(BRANCH == "main-server" and "server/main" or "terminals/terminal")
end

if not pcall(install) then
    print("FAILED! Verify:")
    print("1. Internet connection")
    print("2. Correct repo name")
    print("3. Files exist in branches")
end
