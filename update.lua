-- Updater.lua (Fixed Path Handling)
local USER = "JackT1009"
local REPO = "Base-Controller"
local INSTALL_DIR = "basecontrol"

local branch = os.getComputerLabel() == "BaseCore" 
    and "main-server" 
    or "main-terminal"

local FILES = {
    "main.lua",
    "update.lua",
    "modules/core.lua"
}

print("=== INSTALLER ===")
fs.delete(INSTALL_DIR)
fs.makeDir(INSTALL_DIR)

for _,file in ipairs(FILES) do
    -- Construct URL and path
    local url = "https://raw.githubusercontent.com/"..
        USER.."/"..REPO.."/"..branch.."/"..file
        
    local path = fs.combine(INSTALL_DIR, file)
    local dir = fs.getDir(path)
    
    -- Debug output
    print("URL:", url)
    print("Path:", path)
    print("Dir:", dir)
    
    -- Create directory structure
    if not fs.exists(dir) then
        print("Creating dir:", dir)
        fs.makeDir(dir)
    end
    
    -- Download and write
    local response = http.get(url)
    if response then
        local handle = fs.open(path, "w")
        if handle then
            handle.write(response.readAll())
            handle.close()
            print("✓ Written:", path)
        else
            print("✗ Failed to open:", path)
        end
    else
        print("✗ Missing:", url)
    end
end

print("\nFinal directory contents:")
print(textutils.tabulate(fs.list(INSTALL_DIR)))
