if getgenv().Solace then return warn("Solace is already loaded.") end
getgenv().Solace = {
    Loaded = false,
    Settings = {},
    State = {}
}

local Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/taze292/solace/refs/heads/main/Services.luau"))
local Interface = loadstring(game:HttpGet("https://raw.githubusercontent.com/taze292/solace/refs/heads/main/UI.luau"))
local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/taze292/solace/refs/heads/main/Main.luau"))
Main(Services(), Interface)