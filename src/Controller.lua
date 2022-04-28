if (not game:GetService("Players").LocalPlayer) then
    game:GetService("Players").PlayerAdded:Wait()
end


-- basically like require but cooler n stuff
local Packs = {}
local ArePacksLoaded = false
local PacksLoaded = Instance.new("BindableEvent")

function GetPack(PackName)
    if (not ArePacksLoaded) then
        PacksLoaded.Event:Wait()
    end

    return Packs[PackName]
end


-- config function
local InvalidTypes = {["Instance"] = true, ["table"] = true}
local Configs = {}

function GetConfig(ConfigName)
    if (Configs[ConfigName]) then
        return Configs[ConfigName]
    end

    local Path = "ePack/Data/" .. ConfigName .. ".json"

    if (not isfile(Path)) then
        writefile(Path,  "[]")
    end

    local Config = game:GetService("HttpService"):JSONDecode(readfile(Path))
    local ConfigObj = setmetatable({}, {
        __index = Config;
        __newindex = function (_, idx, val)
            if (InvalidTypes[typeof(val)]) then
                warn("Cannot add type \"" .. typeof(val) .. "\" to config " .. ConfigName ..".json")
                return
            end
    
            Config[idx] = val
            writefile(Path, game:GetService("HttpService"):JSONEncode(Config))
        end;
    })

    Configs[ConfigName] = ConfigObj
    return ConfigObj
end

-- create the default epack config
local ePackConfig = GetConfig "ePackConfig"
ePackConfig.DeveloperMode = ePackConfig.DeveloperMode or false


-- pack class
Pack = {}
Pack.__index = Pack

function Pack:Connect(Signal, Callback)
    return Signal:Connect(Callback), Callback
end

function Pack:CleanConnections()
    for _, c in ipairs(self.Connections) do
        c:Disconnect()
    end
end

function Pack:Enable()
    if (not self.Enabled) then
        self.Enabled = true
        self._enabled:Fire()
    end
end

function Pack:Disable()
    if (self.Enabled) then
        self.Enabled = false
        self._disabled:Fire()
    end
end

function Pack.new(PackName, Constructor)
    local _enabled  = Instance.new("BindableEvent")
    local _disabled = Instance.new("BindableEvent")

    local NewPack = setmetatable({
        Name = PackName;
        Enabled = true;
        Connections = {};

        Enabled   = _enabled.Event;
        Disabled  = _disabled.Event;
        _enabled  = _enabled;
        _disabled = _disabled;
    }, Pack)

    Packs[PackName] = NewPack

    if (Constructor) then
        Constructor(NewPack)
    end

    _enabled:Fire()

    return NewPack
end


-- load packs
for _, Pack in ipairs(listfiles("ePack/Packs")) do
    local PeriodSplit = Pack:split(".")

    if (PeriodSplit[#PeriodSplit] == "lua") then
        local Compiled, Error = loadstring(readfile(Pack))

        if (Compiled) then
            coroutine.wrap(function()
                local Success, Error = pcall(Compiled)

                if (not Success) then
                    warn("Unhandled exception in \"" .. Pack:split("\\")[2] .. "\", " .. Error)
                end
            end)()
        else
            warn("Pack \"" .. Pack:split("\\")[2] .. "\" " .. Error:split(", ")[2])
        end
    end
end


-- fire the event cus all of the packs IN THEORY should be loaded
task.defer(function()
    ArePacksLoaded = true
    PacksLoaded:Fire()
    PacksLoaded:Destroy()
end)
