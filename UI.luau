-- Init
if not getgenv().Solace then return warn("Load the init script first.") end

local Repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(Repo .. "Library.lua", true))
local SaveManager = loadstring(game:HttpGet(Repo .. "addons/SaveManager.lua", true))
local ThemeManager = loadstring(game:HttpGet(Repo .. "addons/ThemeManager.lua", true))

Library = Library()
SaveManager = SaveManager()
ThemeManager = ThemeManager()

ThemeManager:SetFolder("solace")
SaveManager:SetFolder("solace")

ThemeManager.BuiltInThemes["Default"] = {1, {
    BackgroundColor = "161616",
    MainColor = "1a1a1a",
    AccentColor = "6d8fa8",
    OutlineColor = "373737",
    FontColor = "ffffff"
}}

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:ApplyTheme("Default")

-- Window init
local Window = Library:CreateWindow {
    Title = "solace.lua",
    Center = true,
    AutoShow = true,
    TabPadding = 0,
    MenuFadeTime = 0.2
}

local Tabs = {
    Legit = Window:AddTab("Legit"),
    Rage = Window:AddTab("Rage"),
    Visuals = Window:AddTab("Visuals"),
    Player = Window:AddTab("Player"),
    Misc = Window:AddTab("Misc"),
    Settings = Window:AddTab("Setting")
}

local Settings = getgenv().Solace.Settings
local State = getgenv().Solace.State

-- Aimbot Section
local AimbotGroup = Tabs.Legit:AddLeftGroupbox("Aimbot")
AimbotGroup:AddToggle("AimbotEnabled", {
    Text = "Enabled",
    Default = false,
    
    Callback = function(Value)
        print(Value)
    end
})