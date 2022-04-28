local IsInstalled = true
InstallCompleted = Instance.new("BindableEvent")

if (not isfile("ePack/Controller.lua")) then
    IsInstalled = false
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack/main/Installer.lua"))()
end

if (not IsInstalled) then
    InstallCompleted.Event:Wait()
end

IsProductionBuild = true -- for debugging

loadstring(readfile("ePack/Controller.lua"))()

if (game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack/main/Controller.lua") ~= readfile("ePack/Controller.lua")) then
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack/main/Updater.lua"))()
end

InstallCompleted:Destroy()
