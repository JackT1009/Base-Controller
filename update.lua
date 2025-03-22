-- update.lua
local USER = "JackT1009"
local REPO = "Base-Controller"
local INSTALL_DIR = "base"

-- Auto-detect branch
local branch = "main-server"
if os.getComputerLabel() ~= "BaseCore" then
    branch = "main-terminal"
end

-- File lists
local files = {
    ["main-server"] = {
        "server/main.lua",
        "modules/core.lua"
    },
    ["main-terminal"] = {
        "terminal/main.lua",
        "modules/core.lua"
    }
}

-- Main install routine
print("Installing "..branch)
fs.delete(INSTALL_DIR)
fs.makeDir(INSTALL_DIR)

local success = true
for _,path in pairs(files[branch]) do
    local url = "https://raw.githubusercontent.com/"..
        USER.."/"..REPO.."/"..branch.."/"..path
    
    print("Downloading "..path)
    local response = http.get(url)
    
    if response then
        local fullPath = fs.combine(INSTALL_DIR, path)
        fs.makeDir(fs.getDir(fullPath))
        fs.open(fullPath, "w").write(response.readAll()).close()
    else
        print("FAILED: "..url)
        success = false
    end
end

if success then
    print("\nInstall complete! Run:")
    print("cd "..INSTALL_DIR)
    print(branch == "main-server" and "server/main" or "terminal/main")
else
    print("\nInstallation failed - verify files exist")
end
