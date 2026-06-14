if getgenv().Solace then return warn("Solace is already loaded.") end

getgenv().Solace = {
    Initialized = false,
}

local Main = 