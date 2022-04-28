IsProductionBuild = true -- for debugging

local IsInstalled = true
InstallCompleted = Instance.new("BindableEvent")

if (not isfile("ePack/Controller.lua")) then
    IsInstalled = false
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Installer.lua"))()
end

if (not IsInstalled) then
    InstallCompleted.Event:Wait()
    InstallCompleted:Destroy()
end

loadstring(readfile("ePack/Controller.lua"))()

if (game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Controller.lua") ~= readfile("ePack/Controller.lua")) then
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Updater.lua"))()
end
