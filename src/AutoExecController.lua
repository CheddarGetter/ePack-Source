IsProductionBuild = true -- for debugging

local IsInstalled = true
InstallCompleted = Instance.new("BindableEvent")

if (not isfile("ePack/Controller.lua")) then
    IsInstalled = false
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Installer.lua"), "ePack Installer")()
end

if (not IsInstalled) then
    InstallCompleted.Event:Wait()
    InstallCompleted:Destroy()
end

loadstring(readfile("ePack/Controller.lua"), "ePack Controller")()
