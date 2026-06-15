-- Initialization
local Data = {...}
Data = Data[1] :: { Services: {}, Interface: () -> nil }
local Services = Data["Services"]
local Interface = Data["Interface"]

print(Data, Services, Interface, getgenv().Solace)
if not Data or not Services or not Interface or not getgenv().Solace then
    return warn("Please run the init script.")
end

local SolaceGlobal = getgenv().Solace
local Initialized = SolaceGlobal.Initialized
local Settings = SolaceGlobal.Settings
local State = SolaceGlobal.State

-- Definitions
local LocalPlayer = Services.Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local LocalRootPart = LocalCharacter.HumanoidRootPart
local LocalHumanoid = LocalCharacter.Humanoid

local Camera = workspace.CurrentCamera

-- Utility functions
local function Alive(Character: Model)
    if not Character then return false end

    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    local Alive = RootPart and Humanoid and Humanoid.Health > 0

    if Alive then
        return RootPart, Humanoid
    end

    return false
end

local function GetCharacters(PlayerCheck)
    local Result = {}

    for _, Humanoid in workspace:QueryDescendants("Humanoid") do
        local Character = Humanoid:FindFirstAncestorOfClass("Model")

        if not Alive(Character) then
            continue
        end

        if PlayerCheck and not Services.Players:GetPlayerFromCharacter(Character) then
            continue
        end

        table.insert(Result, Character)
    end

    return Result
end

local function GetTarget(Options)
    if not Alive(LocalPlayer) then return end

    local ClosestDistance = Options.FOV or math.huge
    local Closest

    local Characters = GetCharacters(Options.PlayerCheck)
    for _, Character in Characters do
        if not Alive(Character) then
            continue
        end

        local HitPart = Character:FindFirstChild(Options.HitPart or "Head")

        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(HitPart.Position)
        if not OnScreen then
            continue
        end

        local Center = Camera.ViewportSize / 2
        local Distance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - Center).Magnitude

        if Distance < ClosestDistance then
            ClosestDistance = Distance
            Closest = HitPart
        end
    end

    return Closest
end

-- Aimbot
Settings.Aimbot = {
    Enabled = false,
    HitPart = "Head",
    PlayerCheck = false,
}

State.Aimbot = {
    Aiming = false,
    Target = nil,
    Smoothing = 0
}

local AimbotSettings = Settings.Aimbot
local AimbotState = State.Aimbot

local function HandleAimbot()
    if not AimbotState.Aiming then
        return
    end

    if not AimbotState.Target then
        AimbotState.Target = GetTarget({
            PlayerCheck = AimbotSettings.PlayerCheck,
            HitPart = AimbotSettings.HitPart
        })
    end

    if not AimbotState.Target then
        return
    end

    local SmoothingFactor = 1 - AimbotSettings.Smoothing
    local LookVector = CFrame.lookAt(Camera.CFrame.Position, AimbotState.Target.CFrame.Position)
    local NewCFrame = Camera.CFrame:Lerp(LookVector, SmoothingFactor)

    Camera.CFrame = NewCFrame
end

Services.RunService.Heartbeat:Connect(HandleAimbot)
Interface()