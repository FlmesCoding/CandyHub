local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local ninjawindow = ArrayField:CreateWindow({
    Name = "Ninja Legends - CandyHub",
    LoadingTitle = "CandyHub",
    LoadingSubtitle = "by Flames",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CandyHub",
        FileName = "CandyHub"
    },
    Discord = {
        Enabled = true,
        Invite = "MpY7h3WqNh",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "CandyHub | Key",
        Subtitle = "Key System",
        Note = "Key is in discord (discord.gg/MpY7h3WqNh)",
        FileName = "Key",
        SaveKey = false,
        GrabKeyFromSite = false,
        Actions = {
            [1] = {
                Text = 'Click here to copy the discord link <--',
                OnPress = function()
                    setclipboard("discord.gg/MpY7h3WqNh")
                end,
            }
        },
        Key = {"k4JH8n_9sP$3mV#TgZ*F2qL%6QbRc1E7zXo!Y5W"}
    }
})

-- Tab Creation
local main = ninjawindow:CreateTab("Main", nil)
local aSection = main:CreateSection("AutoFarm", false)

-- Auto Swing
local fastLoopingActive = false
local FastLoopingToggle = main:CreateToggle({
    Name = "Auto Swing",
    CurrentValue = false,
    Flag = "FastLoopingToggleFlag",
    SectionParent = aSection,
    Callback = function(Value)
        fastLoopingActive = Value
        while fastLoopingActive do
            local args = {[1] = "swingKatana"}
            game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
            wait(0.1)
        end
    end,
})

-- Auto Sell
local teleportingActive = false
local TeleportingToggle = main:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "TeleportingToggleFlag",
    SectionParent = aSection,
    Callback = function(Value)
        teleportingActive = Value
        while teleportingActive do
            local destination = game:GetService("Workspace").sellAreaCircles.sellAreaCircle.circleOuter.CFrame
            game:GetService("Players").LocalPlayer.Character:SetPrimaryPartCFrame(destination)
            wait(0.1)
        end
    end,
})

-- Auto Collect Coins
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local currentSpeed = 0.5

local isCollectingCoins = false

local Toggle = main:CreateToggle({
    Name = "Auto Collect Coins",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = aSection,
    Callback = function(Value)
        isCollectingCoins = Value
        
        -- Using a coroutine to handle the coin collection in the background
        coroutine.wrap(function()
            while isCollectingCoins do
                local character = player.Character or player.CharacterAdded:Wait()
                local targetParts = Workspace.spawnedCoins.Valley:GetChildren()

                for _, object in ipairs(targetParts) do
                    if not isCollectingCoins then break end  -- Stops the loop if the toggle is off
                    
                    local destination
                    if object:IsA("Model") and object.PrimaryPart then
                        destination = object.PrimaryPart.Position
                    elseif object:IsA("Part") then
                        destination = object.Position
                    else
                        warn("Object", object.Name, "is neither a Model with a PrimaryPart nor a Part, so the character cannot be teleported to it.")
                        continue
                    end
                    character:SetPrimaryPartCFrame(CFrame.new(destination))
                    wait(currentSpeed)
                end
                
                wait(0.1)  -- Small delay to not consume too much CPU if there are no coins
            end
        end)()
    end,
})

local Slider = main:CreateSlider({
    Name = "Collect Coin Speed",
    Range = {0, 10},
    Increment = 0.5,
    Suffix = "%",
    CurrentValue = 0.5,
    Flag = "Slider1",
    SectionParent = aSection,
    Callback = function(Value)
        currentSpeed = 1 - (Value / 100)
    end,
})

local isBuyingSwords = false

local BuySwordsToggle = main:CreateToggle({
Name = "Auto Buy Swords",
CurrentValue = false,
Flag = "BuySwordsToggleFlag",  -- Make sure the Flag is unique
SectionParent = aSection,
Callback = function(Value)
    isBuyingSwords = Value
    
    -- Using a coroutine to handle the sword purchase in the background
    coroutine.wrap(function()
        while isBuyingSwords do
            local args = {
                [1] = "buyAllSwords",
                [2] = "Ground"
            }
            game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
            
            wait(0.5)  -- Adding a small delay between purchases to avoid overloading the server or being flagged
        end
    end)()
end,
})

local isBuyingBelts = false

local BuyBeltsToggle = main:CreateToggle({
Name = "Auto Buy Belts",
CurrentValue = false,
Flag = "BuyBeltsToggleFlag",  -- Make sure the Flag is unique
SectionParent = aSection,
Callback = function(Value)
    isBuyingBelts = Value
    
    -- Using a coroutine to handle the belts purchase in the background
    coroutine.wrap(function()
        while isBuyingBelts do
            local args = {
                [1] = "buyAllBelts",
                [2] = "Ground"
            }
            game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
            
            wait(0.5)  -- Adding a small delay between purchases to avoid overloading
        end
    end)()
end,
})

local cSection = main:CreateSection("LocalPlayer", false)

local WalkSpeedSlider = main:CreateSlider({
Name = "WalkSpeed",
Range = {16, 250},
Increment = 1,
Suffix = " Speed",
CurrentValue = 16,
Flag = "WalkSpeed",
SectionParent = cSection,
Callback = function(Value)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
end,
})

local JumpPowerSlider = main:CreateSlider({
Name = "JumpPower",
Range = {50, 1000000},
Increment = 1,
Suffix = " Power",
CurrentValue = 50,
Flag = "JumpPower",
SectionParent = cSection,
Callback = function(Value)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            player.Character.Humanoid.JumpPower = Value
        end
    end
end,
})

local GravitySlider = main:CreateSlider({
Name = "Gravity",
Range = {0, 300},
Increment = 1,
Suffix = " Gravity",
CurrentValue = workspace.Gravity,
Flag = "Gravity",
SectionParent = cSection,
Callback = function(Value)
    workspace.Gravity = Value
end,
})

local FOVSlider = main:CreateSlider({
Name = "FieldOfView",
Range = {70, 120},
Increment = 1,
Suffix = " FOV",
CurrentValue = 70,
Flag = "FOV",
SectionParent = cSection,
Callback = function(Value)
    workspace.CurrentCamera.FieldOfView = Value
end,
})