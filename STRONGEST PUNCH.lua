local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
    local yyyyWindow = ArrayField:CreateWindow({
        Name = "STRONGEST PUNCH SIMULATOR - CandyHub",
        LoadingTitle = "CandyHub",
        LoadingSubtitle = "by Flames",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = CandyHub, -- Create a custom folder for your hub/game
            FileName = "CandyHub"
        },
        Discord = {
            Enabled = true,
            Invite = "MpY7h3WqNh", -- The Discord invite code
            RememberJoins = true -- Join the discord every time they load
        },
        KeySystem = true, -- Use our key system
        KeySettings = {
            Title = "CandyHub | Key",
            Subtitle = "Key System",
            Note = "Key is in discord (discord.gg/MpY7h3WqNh)",
            FileName = "Key", -- Use something unique for key file
            SaveKey = false, -- The user's key will be saved
            GrabKeyFromSite = false, -- Get the key from the RAW site
            Actions = {
                [1] = {
                    Text = 'Click here to copy the discord link <--',
                    OnPress = function()
                        setclipboard("discord.gg/MpY7h3WqNh")
                    end,
                }
            },
            Key = {"k4JH8n_9sP$3mV#TgZ*F2qL%6QbRc1E7zXo!Y5W"} -- Accepted keys by the system
        }
    })

local gert3Tab = yyyyWindow:CreateTab("Main", nil) -- Title, Image

local isActivated = false

local function loopActivation()
    while isActivated do
        local args = {
            [1] = {
                [1] = "Activate_Punch"
            }
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        wait(0.05) -- Adjust the frequency as needed.
    end
end

local Toggle = gert3Tab:CreateToggle({
   Name = "Auto Punch",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
       isActivated = Value
       
       if isActivated then
           loopActivation()
       end
   end,
})

local isActivated = false

local function loopActivation()
    while isActivated do
        local args = {
            [1] = {
                [1] = "WarpPlrToOtherMap",
                [2] = "Next"
            }
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        wait(0.05) -- Adjust the frequency as needed.
    end
end

local Toggle = gert3Tab:CreateToggle({
   Name = "Auto Teleport To Next Area",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
       isActivated = Value
       
       if isActivated then
           loopActivation()
       end
   end,
})

local LocalPlayer = game.Players.LocalPlayer
local boostsMainContainer = game:GetService("Workspace").Map.Stages.Boosts
local isActivated = false
local teleportationInterval = 10  -- Default value in seconds
local originalPositions = {}

local function teleportPartsToPlayer()
    while isActivated do
        for i = 1, 30 do
            local boostsContainer = boostsMainContainer[tostring(i)]
            
            if boostsContainer then
                for _, child in ipairs(boostsContainer:GetChildren()) do
                    local target = child:FindFirstChild("0")
                    if target and target:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if not originalPositions[target] then
                            originalPositions[target] = target.CFrame
                        end
                        target.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        wait(teleportationInterval)  -- Waiting for the defined interval
                    end
                end
            end
        end
    end
    
    -- Reset positions when the loop ends (toggle turned off)
    for part, originalCFrame in pairs(originalPositions) do
        if part and part.Parent then
            part.CFrame = originalCFrame
        end
    end
end

local Toggle = gert3Tab:CreateToggle({
   Name = "Auto Collect Orbs",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       isActivated = Value
       
       if isActivated then
           coroutine.wrap(teleportPartsToPlayer)()  -- Using coroutine to run the function
       end
   end,
})

local Slider = gert3Tab:CreateSlider({
   Name = "Collect Orbs Speed",
   Range = {0, 50},
   Increment = 0.5,
   Suffix = "Speed",
   CurrentValue = 10,
   Flag = "Slider1",
   Callback = function(Value)
       teleportationInterval = Value
   end,
})



local Label = gert3Tab:CreateLabel("Warning: You may get banned if too fast!")