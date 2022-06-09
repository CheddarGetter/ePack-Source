local function GET_FORMATTED_PCALL_ERROR_MESSAGE(blob)
    local args = blob:split(":")
    return tostring(args[1]):match("%b\"\"") .. " at Line " .. tostring(args[2]) .. ": " .. tostring(args[3]):sub(2)
end

local function GET_FORMATTED_COMPILATION_ERROR_MESSAGE(blob)
    local args = blob:split(", ")
    return tostring(args[1]):match("%b\"\"") .. " " .. tostring(args[2])
end

function SafeLoadstring(code, env_name)
    local compiled, err = loadstring(code, env_name or "Unknown")

    if (compiled) then
        return compiled
    else
        printconsole(GET_FORMATTED_COMPILATION_ERROR_MESSAGE(err), 255, 0, 0)
    end
end


-- basically like require
local PacksLoaded = Instance.new("BindableEvent")
local ArePacksLoaded = false
local Packs = {}

function import(PackName)
    if (not ArePacksLoaded) then
        PacksLoaded.Event:Wait()
    end

    return Packs[PackName]
end


-- pack class
local Pack = {}
Pack.__index = Pack

function Pack:Connect(Signal, Callback)
    return Signal:Connect(Callback), Callback
end

function Pack:CleanConnections()
    for _, Connection in ipairs(self.Connections) do
        Connection:Disconnect()
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
        self:CleanConnections() -- automatically clean connections when disabled
        self.Enabled = false
        self.DisabledEvent:Fire()
    end
end

function Pack.new(Path, PackName, Constructor)
    local EnabledEvent = Instance.new("BindableEvent")
    local DisabledEvent = Instance.new("BindableEvent")

    local NewPack = setmetatable({
        Public = false;
        Name = PackName;
        Path = Path;
        Enabled = true;
        Connections = {};

        Enabled = EnabledEvent.Event;
        Disabled = DisabledEvent.Event;
        EnabledEvent = EnabledEvent;
        DisabledEvent = DisabledEvent;
    }, Pack)

    if (Constructor) then
        local success, err = pcall(Constructor, NewPack)

        if (not success) then
            printconsole(GET_FORMATTED_PCALL_ERROR_MESSAGE(err), 255, 0, 0)
        end
    end

    if (NewPack.Public == true) then
        Packs[PackName] = NewPack
    end

    EnabledEvent:Fire()

    return NewPack
end


-- config function
local InvalidTypes = {["Instance"] = true, ["table"] = true}
local Configs = {}

function config(ConfigName)
    if (Configs[ConfigName]) then
        return Configs[ConfigName]
    end

    local Path = ("ePack/Data/%s.json"):format(ConfigName)

    if (not isfile(Path)) then
        writefile(Path,  game:GetService("HttpService"):JSONEncode({}))
    end

    local Config = game:GetService("HttpService"):JSONDecode(readfile(Path))
    local ConfigObj = setmetatable({}, {
        __index = Config;
        __newindex = function (_, idx, val)
            if (InvalidTypes[typeof(val)]) then
                warn("Cannot add type \"" .. typeof(val) .. "\" to " .. Path)
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
local ePackConfig = config("ePackConfig")
ePackConfig.ShowControllerOutdatedPrompt = ePackConfig.ShowControllerOutdatedPrompt == nil and true or ePackConfig.ShowControllerOutdatedPrompt


-- load packs
for _, Path in ipairs(listfiles("ePack/Packs")) do
    local PeriodSplit = Path:split(".")

    if (PeriodSplit[#PeriodSplit] == "lua") then
        local compiled = SafeLoadstring(readfile(Path), Path:gsub("\\", "/"))

        if (compiled) then
            local success, catch = pcall(compiled)

            if (success) then
                task.spawn(Pack.new, Path:gsub("\\", "/"), Path:split("\\")[2], catch)
            else
                printconsole(GET_FORMATTED_PCALL_ERROR_MESSAGE(catch), 255, 0, 0)
            end
        end
    end
end


-- fire the event because all of the packs IN THEORY should be loaded
task.defer(function()
    ArePacksLoaded = true

    PacksLoaded:Fire()
    PacksLoaded:Destroy()
    PacksLoaded = nil
end)


-- handle updating
if (ePackConfig.ShowControllerOutdatedPrompt == false) then
    printconsole("ePack controller is outdated", 255, 0, 0)
    return
end

if (readfile("ePack/Controller.lua") ~= game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Controller.lua")) then
    local compiled = SafeLoadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Updater.lua"), "ePack Updater")

    if (compiled) then
        local success, catch = pcall(compiled)

        if (not success) then
            printconsole(GET_FORMATTED_PCALL_ERROR_MESSAGE(catch), 255, 0, 0)
        end
    end
end
