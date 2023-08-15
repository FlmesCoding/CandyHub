local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
local Window = Rayfield:CreateWindow({
    Name = "Build A Boat For Treasure | CandyHub X",
    LoadingTitle = "CandyHub X💫",
    LoadingSubtitle = "by Flames",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = CandyHub, -- Create a custom folder for your hub/game
       FileName = "CandyHub Hub"
    },
    Discord = {
       Enabled = true,
       Invite = "MpY7h3WqNh", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = false -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "CandyHub - Key🔐",
       Subtitle = "Key System",
       Note = "Key Is In Discord (discord.gg/MpY7h3WqNh)",
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"k4JH8n_9sP$3mV#TgZ*F2qL%6QbRc1E7zXo!Y5W"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local PlayerTab = Window:CreateTab("LocalPlayer", 10579484688) -- Title, Image

 local Section = PlayerTab:CreateSection("Character")

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

-- For JumpPower
local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 250},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "Slider2",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

-- For Gravity
local GravitySlider = PlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 500},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 196,
    Flag = "Slider3",
    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

-- For InfiniteJump
-- Note that this is a checkbox since it's a true/false value
-- For InfiniteJump
local jumpConnection
local InfJumpCheckbox = PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    Flag = "Toggle1",
    Callback = function(Value)
        _G.InfiniteJumpEnabled = Value
        if _G.InfiniteJumpEnabled then
            -- Create the connection if it doesn't exist or has been disconnected.
            jumpConnection = jumpConnection or game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfiniteJumpEnabled then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        elseif jumpConnection then
            -- Disconnect the connection if InfiniteJump is disabled.
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end,
})

-- For Noclip
local noclipConnection
local NoclipCheckbox = PlayerTab:CreateToggle({
    Name = "Noclip",
    Flag = "Toggle2",
    Callback = function(Value)
        _G.NoclipEnabled = Value
        if _G.NoclipEnabled then
            -- Create the connection if it doesn't exist or has been disconnected.
            noclipConnection = noclipConnection or game:GetService('RunService').Stepped:Connect(function()
                if _G.NoclipEnabled then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        elseif noclipConnection then
            -- Disconnect the connection if Noclip is disabled.
            noclipConnection:Disconnect()
            noclipConnection = nil
            -- Re-enable collision for character parts.
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end,
})


local AutoTab = Window:CreateTab("AutoBuy", 6052557392) -- Title, Image

local Section = AutoTab:CreateSection("Chests")

-- Define loop flags
_G.loopingCommon = false
_G.loopingUncommon = false
_G.loopingRare = false
_G.loopingEpic = false
_G.loopingLegendary = false

-- Define a coroutine to handle the looping action
local function loopAction(chestName, loopingFlag)
    local args = {
        [1] = chestName,
        [2] = 1
    }
    while _G[loopingFlag] do
        workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
        wait() -- to prevent locking up the client
    end
end

-- Define toggles
local function createChestToggle(name, flag)
    return AutoTab:CreateToggle({
        Name = "Buy " .. name .. " Chest",
        Flag = flag,
        Callback = function(Value)
            _G[flag] = Value
            if _G[flag] then
                -- Start the loop in a new coroutine
                coroutine.wrap(function()
                    loopAction(name .. " Chest", flag)
                end)()
            end
        end,
    })
end

local ChestToggles = {
    createChestToggle("Common", "loopingCommon"),
    createChestToggle("Uncommon", "loopingUncommon"),
    createChestToggle("Rare", "loopingRare"),
    createChestToggle("Epic", "loopingEpic"),
    createChestToggle("Legendary", "loopingLegendary"),
}

local AutoFarmTab = Window:CreateTab("AutoFarm", 5445557932) -- Title, Image

local Section = AutoFarmTab:CreateSection("Farm")


local Button = AutoFarmTab:CreateButton({
    Name = "AutoFarm",
    Callback = function()
    -- Get the services we need
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Define the teleport destinations
local destinations = {
    Workspace.BoatStages.NormalStages.CaveStage1.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage2.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage3.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage4.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage5.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage6.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage7.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage8.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage9.DarknessPart,
    Workspace.BoatStages.NormalStages.CaveStage10.DarknessPart,
}

-- Get the player's character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the Tweening information
local tweenInfo = TweenInfo.new(
    2, -- Time
    Enum.EasingStyle.Linear, -- Easing style
    Enum.EasingDirection.InOut, -- Easing direction
    0, -- Repeat count (0 means no repeat)
    false, -- Reverses the tween on completion if true
    0 -- Delay before tween starts
)

-- Function to tween the character to a destination
local function teleportCharacterTo(destination)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local goal = {CFrame = destination.CFrame}
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local originalGravity = humanoid.JumpPower -- store original jump power
        humanoid.JumpPower = 0 -- set jump power to 0 to "freeze" in air

        -- Anchor the HumanoidRootPart
        local wasAnchored = humanoidRootPart.Anchored
        humanoidRootPart.Anchored = true

        tween.Completed:Connect(function()
            humanoid.JumpPower = originalGravity -- restore original jump power
            -- Restore original anchored state
            humanoidRootPart.Anchored = wasAnchored
        end)

        tween:Play()
        tween.Completed:Wait() -- Wait for the tween to complete before returning
    end
end

local function killCharacter()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        wait(2.6)
        humanoid.Health = 0
    end
end

local function startAutoFarm()
    for _, destination in ipairs(destinations) do
        teleportCharacterTo(destination)
        wait(0.1)
    end
    teleportCharacterTo(Workspace.BoatStages.NormalStages.TheEnd.GoldenChest.Trigger)
    wait(0.5)  -- Wait for half a second to ensure the teleport completes
    killCharacter()
end

-- Connect the CharacterAdded event first to ensure it's ready
player.CharacterAdded:Connect(function(newChar)
    waitForHumanoidReady(newChar)
    character = newChar  -- update the reference
    startAutoFarm()
end)

-- Start the farming sequence
startAutoFarm()

local function waitForHumanoidReady(char)
    local humanoid = char:WaitForChild("Humanoid")
    char:WaitForChild("HumanoidRootPart")
    repeat wait() until humanoid.Health > 0
end

-- Teleport the character to each destination in order
for _, destination in ipairs(destinations) do
    teleportCharacterTo(destination)
    wait(0.1) -- Wait for a second between each teleport
end

-- Finally, teleport to TheEnd
teleportCharacterTo(Workspace.BoatStages.NormalStages.TheEnd.GoldenChest.Trigger)
    end,
 })

 local LocalPlayer = game:GetService("Players").LocalPlayer

 local TeleportTab = Window:CreateTab("Teleport", 6052561658) -- Title, Image

 local Section = TeleportTab:CreateSection("Teleports")


 local Button1 = TeleportTab:CreateButton({
    Name = "Really blueZone",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(221.835587, -9.89999294, 289.496735, 3.00895917e-05, 1.89661886e-08, -1, -1.8994708e-08, 1, 1.89656184e-08, 1, 1.89941378e-08, 3.00895917e-05)
        Rayfield:Notify({
            Title = "Teleportation",
            Content = "Teleported To Really blueZone",
            Duration = 6.5,
            Image = 5578470911,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user acknowledged the teleportation to Really blueZone!")
                    end
                },
            },
        })
    end,
})

TeleportTab:CreateButton({
    Name = "CamoZone",
    Callback = function()
       LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-328.966553, -9.89999294, 285.890778, 2.32723869e-05, 4.81436508e-08, 1, -8.0430631e-08, 1, -4.81417786e-08, -1, -8.04295084e-08, 2.32723869e-05)
       
       Rayfield:Notify({
          Title = "Teleportation",
          Content = "Teleported To CamoZone",
          Duration = 6.5,
          Image = 4483362458,
          Actions = {
             Ignore = {
                Name = "Okay!",
                Callback = function()
                   print("The user acknowledged the teleportation to CamoZone!")
                end
             },
          },
       })
    end,
 })
 
 
 TeleportTab:CreateButton({
    Name = "MagentaZone",
    Callback = function()
       LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(221.835083, -9.89999294, 647.695251, -2.21245518e-05, -1.27197168e-08, -1, -7.80432288e-08, 1, -1.27179902e-08, 1, 7.80429446e-08, -2.21245518e-05)
       
       Rayfield:Notify({
          Title = "Teleportation",
          Content = "Teleported To MagentaZone",
          Duration = 6.5,
          Image = 4483362458,
          Actions = {
             Ignore = {
                Name = "Okay!",
                Callback = function()
                   print("The user acknowledged the teleportation to MagentaZone!")
                end
             },
          },
       })
    end,
 })

 TeleportTab:CreateButton({
    Name = "Really redZone",
    Callback = function()
       LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(221.835068, -9.89999294, -68.7047195, -2.20595903e-05, -1.15739818e-08, -1, -8.31205469e-08, 1, -1.15721486e-08, 1, 8.31202911e-08, -2.20595903e-05)
       
       Rayfield:Notify({
          Title = "Teleportation",
          Content = "Teleported To Really redZone",
          Duration = 6.5,
          Image = 4483362458,
          Actions = {
             Ignore = {
                Name = "Okay!",
                Callback = function()
                   print("The user acknowledged the teleportation to Really redZone!")
                end
             },
          },
       })
    end,
 })
 
 TeleportTab:CreateButton({
    Name = "WhiteZone",
    Callback = function()
       LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-53.5637512, -9.89999294, -345.507538, 1, 4.29280682e-08, -2.15271102e-05, -4.29279226e-08, 1, 6.71854927e-09, 2.15271102e-05, -6.71762512e-09, 1)
       
       Rayfield:Notify({
          Title = "Teleportation",
          Content = "Teleported To WhiteZone",
          Duration = 6.5,
          Image = 4483362458,
          Actions = {
             Ignore = {
                Name = "Okay!",
                Callback = function()
                   print("The user acknowledged the teleportation to WhiteZone!")
                end
             },
          },
       })
    end,
 })
 
 TeleportTab:CreateButton({
    Name = "New YellerZone",
    Callback = function()
       LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-328.942108, -9.89999294, 643.876709, -0.00115210481, -5.0259036e-08, 0.999999344, 4.44386856e-08, 1, 5.03102662e-08, -0.999999344, 4.44966162e-08, -0.00115210481)
       
       Rayfield:Notify({
          Title = "Teleportation",
          Content = "Teleported To New YellerZone",
          Duration = 6.5,
          Image = 4483362458,
          Actions = {
             Ignore = {
                Name = "Okay!",
                Callback = function()
                   print("The user acknowledged the teleportation to New YellerZone!")
                end
             },
          },
       })
    end,
 })
 
 local ExtraTab = Window:CreateTab("Extra", 6052579475) -- Title, Image

 local Section = ExtraTab:CreateSection("Extra")

-- Button for Kill All
local ButtonKillAll = ExtraTab:CreateButton({
    Name = "Kill All",
    Callback = function()
        Rayfield:Notify({
            Title = "WARNING",
            Content = "Only Works If Players Have Pvp Mode Enabled",
            Duration = 6.5,
            Image = 11745872910,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Okay!",
                  Callback = function()
                  print("The user tapped Okay!")
               end
            },
         },
         })
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-53.5655861, -360.700012, 9391.29199, 0.999978304, 8.00575783e-09, -0.00659008743, -8.00250088e-09, 1, 5.20489041e-10, 0.00659008743, -4.67740568e-10, 0.999978304)
    print("Successfully Teleported Players")
    game:GetService("RunService").Stepped:connect(function()
        for i,v in pairs (game:GetService("Players"):GetChildren()) do
            if v.TeamColor ~= LocalPlayer.TeamColor and v.Name ~= LocalPlayer.Name then
                v.Character.HumanoidRootPart.Anchored = true
                v.Character.HumanoidRootPart.CFrame = CFrame.new(-53.5905228, -360.700012, 9499.88184, 0.99999994, 5.23848342e-09, 0.000277680316, -5.23909627e-09, 1, 2.20502683e-09, -0.000277680316, -2.20648144e-09, 0.99999994)
            end
        end
    end)
    end,
})

-- Button for Big Head Player
local ButtonBigHead = ExtraTab:CreateButton({
    Name = "Big Head Player",
    Callback = function()
        LocalPlayerName = game:GetService("Players").LocalPlayer.Name
        LocalPlayerWorkspace = game:GetService("Workspace")[LocalPlayerName]
        LocalPlayerWorkspace.Head.Size = Vector3.new(4, 2, 2)
        Rayfield:Notify({
            Title = "Character Modification",
            Content = "Head Enlarged",
            Duration = 6.5,
            Image = 5578470911,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user acknowledged the head enlargement!")
                    end
                },
            },
        })
    end,
})