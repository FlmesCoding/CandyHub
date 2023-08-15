-- i used some scripts from r3th so credits to him hes a legend

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local Chat = game:GetService("Chat")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local DataStoreService = game:GetService("DataStoreService")
local AssetService = game:GetService("AssetService")
local BadgeService = game:GetService("BadgeService")
local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local ContextActionService = game:GetService("ContextActionService")
local MessagingService = game:GetService("MessagingService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local UIS = game:GetService("UserInputService");
local Teams = game:GetService("Teams");
local ScriptContext = game:GetService("ScriptContext");
local CoreGui = game:GetService("CoreGui");
local Camera = Workspace.CurrentCamera;
local Terrain = Workspace.Terrain;
local VirtualUser = game:GetService("VirtualUser");


-- =====================================================================
local LP = Players.LocalPlayer
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()
local trapRange = 10
local isProximityTrapActive = false

-- =====================================================================

-- =====================================================================
local sprintSpeed = 32 -- Define this to your desired sprint speed.
local defaultWalkSpeed = 16 -- The default walkspeed in Roblox.
local isSprintEnabled = false -- Whether or not the sprint functionality is enabled.

local verticalOffset = -3
local platformActive = false
-- =====================================================================

-- =====================================================================
getgenv().SecureMode = true
local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Window = ArrayField:CreateWindow({
    Name = "Murder Mystery 2 - CandyHub",
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
    KeySystem = false, -- Use our key system
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
-- =====================================================================
local PlayerTab = Window:CreateTab("Player", 10579484688)
local VisualsTab = Window:CreateTab("Visuals", 6523858394)
local WorldTab = Window:CreateTab("World", 11395780588)
local TradeTab = Window:CreateTab("Trading", 2614876855)
local PerkTab = Window:CreateTab("Perks", 14372323895)
local RolesTab = Window:CreateTab("Roles", 14372303673)
local SettingsTab = Window:CreateTab("Settings", 7059346373)
-- =====================================================================
local MobilitySection = PlayerTab:CreateSection("Mobility Settings", false)

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    SectionParent = MobilitySection,
    Callback = function(Value)
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                player.Character.Humanoid.WalkSpeed = Value
            end
        end
    end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 1,
    Suffix = " Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    SectionParent = MobilitySection,
    Callback = function(Value)
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                player.Character.Humanoid.JumpPower = Value
            end
        end
    end,
})


local ToggleSprint = PlayerTab:CreateToggle({
    Name = "Sprint",
    CurrentValue = false,
    Flag = "ToggleSprint",
    SectionParent = MobilitySection,
    Callback = function(Value)
        isSprintEnabled = Value
        if not Value then
            stopSprint(Players.LocalPlayer)  -- Reset speed to default when toggled off
        end
    end,
})

-- This is the part that changes the sprintSpeed value based on the slider's value.
local SprintSpeedSlider = PlayerTab:CreateSlider({
    Name = "Sprint Speed",
    Range = {defaultWalkSpeed, 100},
    Increment = 2,
    Suffix = " Speed",
    CurrentValue = sprintSpeed,
    Flag = "SprintSpeed",
    SectionParent = MobilitySection,
    Callback = function(Value)
        sprintSpeed = Value -- Only set the sprintSpeed, don't change the current walkspeed
    end,
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function teleportToCursor()
    local player = Players.LocalPlayer
    local mouse = player:GetMouse()
    local targetPos = mouse.Hit.p

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.x, targetPos.y + 3, targetPos.z) -- +3 to y position to ensure player doesn't get stuck below surfaces
    end
end

local Keybind = PlayerTab:CreateKeybind({
    Name = "Teleport to Cursor",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Flag = "TeleportToCursorKeybind",
    SectionParent = MobilitySection,
    Callback = function(Keybind)
        if not Keybind then -- This ensures the key is not being held (because HoldToInteract is false)
            teleportToCursor()
        end
    end,
})


local PhysicsSection = PlayerTab:CreateSection("World Physics", false)


local GravitySlider = PlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 300},
    Increment = 1,
    Suffix = " Gravity",
    CurrentValue = workspace.Gravity,
    Flag = "Gravity",
    SectionParent = PhysicsSection,
    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

local CameraSection = PlayerTab:CreateSection("Camera Settings", false)

local FOVSlider = PlayerTab:CreateSlider({
    Name = "FieldOfView",
    Range = {70, 120},
    Increment = 1,
    Suffix = " FOV",
    CurrentValue = 70,
    Flag = "FOV",
    SectionParent = CameraSection,
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end,
})

local UnlockCameraToggle = PlayerTab:CreateToggle({
    Name = "Unlock Camera",
    CurrentValue = false,
    Flag = "UnlockCamera",
    SectionParent = CameraSection,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.CameraMaxZoomDistance = 10000
        else
            game.Players.LocalPlayer.CameraMaxZoomDistance = 24 
        end
    end,
})

local CameraNoclipToggle = PlayerTab:CreateToggle({
    Name = "Camera Noclip",
    CurrentValue = false,
    Flag = "CameraNoclip",
    SectionParent = CameraSection,
    Callback = function(Value)
        if Value then
            for _, func in next,getgc() do
                if getfenv(func).script == game.Players.LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper and typeof(func) == "function" then
                    for number, value in next, getconstants(func) do
                        if tonumber(value) == 0.25 then
                            setconstant(func, number, 0)
                        end
                    end
                end
            end
        else
            for _, func in next,getgc() do
                if getfenv(func).script == game.Players.LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper and typeof(func) == "function" then
                    for number, value in next, getconstants(func) do
                        if tonumber(value) == 0 then
                            setconstant(func, number, 0.25)
                        end
                    end
                end
            end
        end
    end,
})

local AbilitiesSection = PlayerTab:CreateSection("Special Abilities", false)

local InfJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    SectionParent = AbilitiesSection,
    Callback = function(Value)
        if InfJumpConnection then
            InfJumpConnection:Disconnect()
            InfJumpConnection = nil
        end

        if Value then
            InfJumpConnection = UserInputService.JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

local NoClipToggle = PlayerTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    SectionParent = AbilitiesSection,
    Callback = function(Value)
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end

        if Value then
            NoClipConnection = RunService.Stepped:Connect(function()
                local player = game.Players.LocalPlayer
                if player and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local player = game.Players.LocalPlayer
            if player and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})



-- ====================SPRINT SHIFT=====================================
local function startSprint(player)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = sprintSpeed
    end
end

local function stopSprint(player)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
    end
end

UserInputService.InputBegan:Connect(function(input, isProcessed)
    -- Using isProcessed will return true for the ShiftLock feature, so we'll use another method
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
        if isSprintEnabled then
            startSprint(Players.LocalPlayer)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
        if isSprintEnabled then
            stopSprint(Players.LocalPlayer)
        end
    end
end)

-- =====================================================================



local MiscellaneousSection = WorldTab:CreateSection("Miscellaneous", false)

local function announceRole(roleName, stopMessage)
    local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    for playerName, roleData in pairs(roles) do
        if roleData.Role == roleName then
            if not stopMessage then
                local message = roleName .. " Is: " .. playerName
                local args = { message, "normalchat" }
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
            end
            return playerName
        end
    end
    return "nil"
end
local Button = WorldTab:CreateButton({
    Name = "Expose Roles In Chat",
    Interact = 'Click',
    SectionParent = MiscellaneousSection,
    Callback = function()
        stopmessagemurd = false
        _G.murdchatcheck = game:GetService("RunService").RenderStepped:Connect(function()
            MurdName = announceRole("Murderer", stopmessagemurd)
            stopmessagemurd = true
            wait(5)
        end)
        wait()
        _G.murdchatcheck:Disconnect()
        
        stopmessagesheriff = false
        _G.sheriffchatcheck = game:GetService("RunService").RenderStepped:Connect(function()
            SheriffName = announceRole("Sheriff", stopmessagesheriff)
            stopmessagesheriff = true
            wait(5)
        end)
        wait()
        _G.sheriffchatcheck:Disconnect()
    end
})

local Button = WorldTab:CreateButton({
    Name = "Remove Barriers",
    Interact = 'Click',
    SectionParent = MiscellaneousSection,
    Callback = function()
        for i,v in pairs (workspace:GetDescendants()) do
            if v.Name == "GlitchProof" then
                v:Destroy()
            end
        end
        for i,v in pairs (workspace:GetDescendants()) do
            if v.Name == "InvisWalls" then
                v:Destroy()
            end
        end
    end,
})

local Toggle = WorldTab:CreateToggle({
    Name = "See Dead Chat",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = MiscellaneousSection, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        if SEEDEADCHAT099 == true then
            _G.R3THSEEDEADCHAT = true
        end
        if SEEDEADCHAT099 == false then
            _G.R3THSEEDEADCHAT = false
        end
    end,
 })

local XRayToggle = WorldTab:CreateToggle({
    Name = "X-Ray",
    CurrentValue = false,
    Flag = "XRay",
    SectionParent = MiscellaneousSection,
    Callback = function(Value)
        xRayEnabled = Value
        ApplyXRay()
        ArrayField:Notify({
            Title = "Warning",
            Content = "X-Ray May lag your game",
            Duration = 6.5,
            Image = nil,
            Actions = { 
               Ignore = {
                  Name = "Okay!",
                  Callback = function()
                  print("The user tapped Okay!")
               end
            },
          },
         })
    end,
})
game:GetService("RunService").Heartbeat:Connect(function()
    if xRayEnabled then
        ApplyXRay()
    end
end)
function ApplyXRay()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency ~= 1 then
            part.LocalTransparencyModifier = xRayEnabled and 0.5 or 0
        end
    end
end

local TeleportsSection = WorldTab:CreateSection("Teleports", false)

local Button = WorldTab:CreateButton({
    Name = "Teleport to Lobby",
    Interact = 'Click',
    SectionParent = TeleportsSection,
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108.04826354980469, 138.34988403320312, 44.17262649536133)
    end,
 })

 local Button = WorldTab:CreateButton({
    Name = "Teleport to Voting Area",
    Interact = 'Click',
    SectionParent = TeleportsSection,
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108.5022201538086, 140.69989013671875, 83.28791809082031)
    end,
 })

 local Button = WorldTab:CreateButton({
    Name = "Teleport to Map",
    Interact = 'Click',
    SectionParent = TeleportsSection,
    Callback = function()
        if workspace:FindFirstChild("Bank2") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1690.4061279296875, 22.199838638305664, -951.4534912109375)
        else
            if workspace:FindFirstChild("BioLab") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4192.08740234375, 35.095394134521484, 460.15704345703125)
            else
                if workspace:FindFirstChild("Factory") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3354.25, 27.85502052307129, 1391.8026123046875)
                else
                    if workspace:FindFirstChild("Hospital3") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-688.3023681640625, 20.30002784729004, -2678.230224609375)
                    else
                        if workspace:FindFirstChild("Hotel") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1890.1318359375, 8.199942588806152, 869.2552490234375)
                        else
                            if workspace:FindFirstChild("House2") then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1536.351318359375, 35.80088806152344, -1074.702880859375)
                            else
                                if workspace:FindFirstChild("Mansion2") then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-981.7781372070312, 17.40009880065918, -1971.6483154296875)
                                else
                                    if workspace:FindFirstChild("MilBase") then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3385.1298828125, 15.456457138061523, 2988.390625)
                                    else
                                        if workspace:FindFirstChild("nSOffice") then
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(300.28521728515625, 26.006328582763672, 2392.3662109375)
                                        else
                                            if workspace:FindFirstChild("Office3") then
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(94.03734588623047, 49.703670501708984, -3051.67041015625)
                                            else
                                                if workspace:FindFirstChild("PoliceStation") then
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2869.74609375, 41.10031509399414, 265.38165283203125)
                                                else
                                                    if workspace:FindFirstChild("ResearchFacility") then
                                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(360.1957702636719, 36.0999755859375, -107.99964904785156)
                                                    else
                                                        if workspace:FindFirstChild("Workplace") then
                                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3127.547607421875, 17.224634170532227, -514.2977905273438)
                                                        else
                                                            if workspace:FindFirstChild("Lobby") then
                                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108.04826354980469, 138.34988403320312, 44.17262649536133)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
 })

 local Button = WorldTab:CreateButton({
    Name = "Teleport AboveMap",
    Interact = 'Click',
    SectionParent = TeleportsSection,
    Callback = function()
        if workspace:FindFirstChild("Bank2") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1657.433349609375, 55.1998291015625, -894.1311645507812)
        else
            if workspace:FindFirstChild("BioLab") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4281.05224609375, 77.2977294921875, 513.7952270507812)
            else
                if workspace:FindFirstChild("Factory") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3396.335205078125, 72.9106216430664, 1395.3807373046875)
                else
                    if workspace:FindFirstChild("Hospital3") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-701.52197265625, 53.100040435791016, -2679.240966796875)
                    else
                        if workspace:FindFirstChild("Hotel") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1845.1964111328125, 42.99995040893555, 842.2034301757812)
                        else
                            if workspace:FindFirstChild("House2") then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1499.271728515625, 63.80094528198242, -1143.742431640625)
                            else
                                if workspace:FindFirstChild("Mansion2") then
                                    for i,v in pairs (workspace.Mansion2:GetDescendants()) do
                                        if v.Name == "GlitchProof" then
                                              v:Destroy()
                                        end
                                    end
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-902.5350952148438, 29.500106811523438, -1906.47314453125)
                                else
                                    if workspace:FindFirstChild("MilBase") then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3308.32421875, 125.00634765625, 2854.347900390625)
                                    else
                                        if workspace:FindFirstChild("nSOffice") then
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(360.3828125, 66.00631713867188, 2420.55908203125)
                                        else
                                            if workspace:FindFirstChild("Office3") then
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(155.65457153320312, 73.00385284423828, -2992.73974609375)
                                            else
                                                if workspace:FindFirstChild("PoliceStation") then
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2934.41357421875, 72.90029907226562, 263.7356262207031)
                                                else
                                                    if workspace:FindFirstChild("ResearchFacility") then
                                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(435.5243225097656, 64.59996032714844, -78.25444793701172)
                                                    else
                                                        if workspace:FindFirstChild("Workplace") then
                                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3159.590087890625, 44.20138931274414, -571.6121215820312)
                                                        else
                                                            if workspace:FindFirstChild("Lobby") then
                                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-107.46256256103516, 223.2144012451172, 22.349220275878906)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
 })

 local Button = WorldTab:CreateButton({
    Name = "Teleport to Murder",
    Interact = 'Click',
    SectionParent = TeleportsSection,
    Callback = function()
        _G.tpmurd0 = game:GetService("RunService").RenderStepped:Connect(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LP = Players.LocalPlayer
            local roles
            
            roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
            for i, v in pairs(roles) do
                if v.Role == "Murderer" then
                    Murder = i
                    R3THTPTOMURD = i
                    players = game:GetService("Players")
                    R3THTPTOPLAYER = players:FindFirstChild(R3THTPTOMURD)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(R3THTPTOPLAYER.Character.HumanoidRootPart.Position)
                    wait()
                end
            end
            wait(5)
        end)
        wait()
        _G.tpmurd0:Disconnect()
        wait()
    end,
 })

 local Button = WorldTab:CreateButton({
    Name = "Teleport to Sheriff",
    Interact = 'Click',
    SectionParent = TeleportsSection,
    Callback = function()
        _G.tpsheriff0 = game:GetService("RunService").RenderStepped:Connect(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LP = Players.LocalPlayer
            local roles
            
            roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
            for i, v in pairs(roles) do
                if v.Role == "Sheriff" then
                    Sheriff = i
                    R3THTPTOSHERIFF = i
                    players = game:GetService("Players")
                    R3THTPTOPLAYER = players:FindFirstChild(R3THTPTOSHERIFF)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(R3THTPTOPLAYER.Character.HumanoidRootPart.Position)
                    wait()
                elseif v.Role == "Hero" then
                    Hero = i
                    R3THTPTOSHERIFF = i
                    players = game:GetService("Players")
                    R3THTPTOPLAYER = players:FindFirstChild(R3THTPTOSHERIFF)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(R3THTPTOPLAYER.Character.HumanoidRootPart.Position)
                    wait()
                end
            end
            wait(5)
        end)
        wait()
        _G.tpsheriff0:Disconnect()
        wait()
    end,
 })


local PerformanceSection = WorldTab:CreateSection("Performance Boosts", false)

local function deleteItems()
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == "Pet" or item.Name == "KnifeDisplay" or item.Name == "GunDisplay" then
            item:Destroy()
        end
    end
end
local Toggle = WorldTab:CreateToggle({
    Name = "Delete Chromas",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = PerformanceSection,
    Callback = function(r3thimprovefps)
        _G.r3thimprovefps = r3thimprovefps
        
        if r3thimprovefps then
            while _G.r3thimprovefps do
                deleteItems()
                wait(10)
            end
        else
            wait()
        end
    end
})

local childAddedConnection
local Toggle = WorldTab:CreateToggle({
    Name = "Delete Images",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = PerformanceSection,
    Callback = function(deletealldecals)
        _G.r3thremovedecals = deletealldecals
        
        if deletealldecals then
            childAddedConnection = workspace.ChildAdded:Connect(function(p)
                if _G.r3thremovedecals and p.Name == "Spray" then
                    p:Destroy()
                end
            end)
        else
            if childAddedConnection then
                childAddedConnection:Disconnect()
            end
        end
    end
})

local SpectateSection = WorldTab:CreateSection("Spectating", false)

local function stopViewing()
    for _, connectionName in pairs({"Murderer", "Sheriff", "GunDrop"}) do
        local connection = _G["r3thview" .. connectionName]
        if connection then
            connection:Disconnect()
        end
    end

    if LP and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        workspace.Camera.CameraSubject = LP.Character.Humanoid
    end
end

local ButtonStopViewing = WorldTab:CreateButton({
    Name = "Stop Viewing",
    Interact = 'Click',
    SectionParent = SpectateSection,
    Callback = function()
        stopViewing()
    end,
})


local function viewRoleOrObject(Value, roleName, objectName)
    local connectionName = roleName or objectName
    
    if _G["r3thview" .. connectionName] then
        _G["r3thview" .. connectionName]:Disconnect()
    end
    
    if Value then
        _G["r3thview" .. connectionName] = RunService.Heartbeat:Connect(function()
            if roleName then
                local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
                for i, v in pairs(roles) do
                    if v.Role == roleName then
                        local R3THVIEWPLAYER = Players[i]
                        if R3THVIEWPLAYER and R3THVIEWPLAYER.Character and R3THVIEWPLAYER.Character:FindFirstChild("Humanoid") then
                            workspace.Camera.CameraSubject = R3THVIEWPLAYER.Character.Humanoid
                            wait()
                        end
                    end
                end
            elseif objectName then
                local object = workspace:FindFirstChild(objectName)
                if object then
                    workspace.Camera.CameraSubject = object
                    wait()
                end
            end
            wait(5)
        end)
    else
        workspace.Camera.CameraSubject = LP.Character.Humanoid
    end
end


local ButtonMurderer = WorldTab:CreateButton({
    Name = "View Murderer",
    Interact = 'Click',
    SectionParent = SpectateSection,
    Callback = function()
        viewRoleOrObject(true, "Murderer")
    end
})

local ButtonSheriff = WorldTab:CreateButton({
    Name = "View Sheriff",
    Interact = 'Click',
    SectionParent = SpectateSection,
    Callback = function()
        viewRoleOrObject(true, "Sheriff")
    end
})

local ButtonGunDrop = WorldTab:CreateButton({
    Name = "View Gun",
    Interact = 'Click',
    SectionParent = SpectateSection,
    Callback = function()
        viewRoleOrObject(true, nil, "GunDrop")
    end
})


local AutoTradeSection = TradeTab:CreateSection("Auto Trade", false)

local Players = game:GetService("Players")
local playerNames = {}

for _, player in pairs(Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end

local PlayerListDropdown = TradeTab:CreateDropdown({
   Name = "Player List",
   Options = playerNames,
   CurrentOption = playerNames[1],
   MultiSelection = false,
   Flag = "PlayerListDropdown",
   SectionParent = AutoTradeSection,
   Callback = function(Option)
       local selectedPlayer = Players[Option]
       
       if selectedPlayer then
           game:GetService("ReplicatedStorage").Trade.SendRequest:InvokeServer(selectedPlayer)
       end
   end,
})

Players.PlayerAdded:Connect(function(player)
    PlayerListDropdown:Add(player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerListDropdown:Remove(player.Name)
end)

local TradeManagementSection = TradeTab:CreateSection("Trade Management", false)

local isLooping = false
local function startLoopingTradeDecline()
    while isLooping do
        game:GetService("ReplicatedStorage").Trade.DeclineTrade:FireServer()
        wait(1)
    end
end
local Toggle = TradeTab:CreateToggle({
   Name = "Auto Decline Trade",
   CurrentValue = false,
   Flag = "ToggleTradeDecline",
   SectionParent = TradeManagementSection,
   Callback = function(Value)
       if Value then
           isLooping = true
           startLoopingTradeDecline()
       else
           isLooping = false
       end
   end,
})

local isCancelLooping = false
local function startLoopingTradeCancel()
    while isCancelLooping do
        game:GetService("ReplicatedStorage").Trade.CancelRequest:FireServer()
        wait(1)
    end
end

local CancelToggle = TradeTab:CreateToggle({
   Name = "Auto Cancel Trade",
   CurrentValue = false,
   Flag = "ToggleTradeCancel",
   SectionParent = TradeManagementSection,
   Callback = function(Value)
       if Value then
           isCancelLooping = true
           startLoopingTradeCancel()
       else
           isCancelLooping = false
       end
   end,
})

local isAcceptLooping = false
local function startLoopingTradeAccept()
    while isAcceptLooping do
        game:GetService("ReplicatedStorage").Trade.AcceptRequest:FireServer()
        wait(1)
    end
end

local AcceptToggle = TradeTab:CreateToggle({
   Name = "Auto Accept Trade",
   CurrentValue = false,
   Flag = "ToggleTradeAccept",
   SectionParent = TradeManagementSection,
   Callback = function(Value)
       if Value then
           isAcceptLooping = true
           startLoopingTradeAccept()
       else
           isAcceptLooping = false
       end
   end,
})


local InoocentSection = RolesTab:CreateSection("Innocent",false)

local notifyWhenSheriffFound = false
local hasNotifiedForSheriff = false
local function checkForSheriff()
    if notifyWhenSheriffFound and not hasNotifiedForSheriff then
        for _, player in ipairs(Players:GetPlayers()) do
            local hasGunInBackpack = player.Backpack:FindFirstChild("Gun")
            local hasGunEquipped = player.Character and player.Character:FindFirstChild("Gun")

            if hasGunInBackpack or hasGunEquipped then
                hasNotifiedForSheriff = true
                ArrayField:Notify({
                    Title = "Sheriff Detected!",
                    Content = player.Name .. " is the sheriff.",
                    Duration = 6.5,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user identified the sheriff!")
                            end
                        }
                    }
                })
                break 
            end
        end
    end
end
local ToggleSheriff = RolesTab:CreateToggle({
    Name = "Notify when Sheriff is found",
    CurrentValue = false,
    Flag = "ToggleSheriffNotification",
    SectionParent = InoocentSection,
    Callback = function(Value)
        notifyWhenSheriffFound = Value
        if not Value then
            hasNotifiedForSheriff = false
        end
        checkForSheriff()
    end
})

Players.PlayerAdded:Connect(function(player)
    player.Backpack.ChildAdded:Connect(checkForSheriff)
    if player.Character then
        player.Character.ChildAdded:Connect(checkForSheriff)
    end
    player.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(checkForSheriff)
    end)
end)


local notifyWhenMurdererFound = false
local hasNotifiedForMurderer = false
local function checkForMurderer()
    if notifyWhenMurdererFound and not hasNotifiedForMurderer then
        for _, player in ipairs(Players:GetPlayers()) do
            local hasKnifeInBackpack = player.Backpack:FindFirstChild("Knife")
            local hasKnifeEquipped = player.Character and player.Character:FindFirstChild("Knife")

            if hasKnifeInBackpack or hasKnifeEquipped then
                hasNotifiedForMurderer = true 
                ArrayField:Notify({
                    Title = "Murderer Detected!",
                    Content = player.Name .. " is the murderer.",
                    Duration = 6.5,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                                print("The user identified the murderer!")
                            end
                        }
                    }
                })
                break
            end
        end
    end
end

local ToggleMurderer = RolesTab:CreateToggle({
    Name = "Notify when Murderer is found",
    CurrentValue = false,
    Flag = "ToggleMurdererNotification",
    SectionParent = InoocentSection,
    Callback = function(Value)
        notifyWhenMurdererFound = Value
        if not Value then
            hasNotifiedForMurderer = false
        end
        checkForMurderer()
    end
})

Players.PlayerAdded:Connect(function(player)
    player.Backpack.ChildAdded:Connect(checkForMurderer)
    if player.Character then
        player.Character.ChildAdded:Connect(checkForMurderer)
    end
    player.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(checkForMurderer)
    end)
end)


local notifyWhenGunDrops = false
local hasNotified = false
local function checkForGunDrop()
    if notifyWhenGunDrops and not hasNotified and workspace:FindFirstChild("GunDrop") then
        hasNotified = true
        ArrayField:Notify({
            Title = "GunDrop Detected!",
            Content = "The Gun has been found.",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                }
            }
        })
    end
end
local Toggle = RolesTab:CreateToggle({
    Name = "Notify when GunDrop is found",
    CurrentValue = false,
    Flag = "ToggleGunDropNotification",
    SectionParent = InoocentSection,
    Callback = function(Value)
        notifyWhenGunDrops = Value
        if not Value then
            hasNotified = false
        end
    end
})

workspace.ChildAdded:Connect(checkForGunDrop)


local originalPosition = nil 
local isTeleportingToGunDrop = false 

local function teleportToGunDropLoop()
    while isTeleportingToGunDrop do
        local gunDrop = Workspace:FindFirstChild("GunDrop")

        if gunDrop and isTeleportingToGunDrop then
            if not originalPosition then
                originalPosition = LP.Character.HumanoidRootPart.CFrame
            end
            
            LP.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            wait(0.5) 
        else

            wait(0.1)
        end
    end

    if originalPosition then
        LP.Character.HumanoidRootPart.CFrame = originalPosition
        originalPosition = nil 
    end
end

local Toggle = RolesTab:CreateToggle({
   Name = "Auto Teleport to Gun",
   CurrentValue = false,
   Flag = "ToggleGunDrop",
   SectionParent = InoocentSection,
   Callback = function(Value)
       isTeleportingToGunDrop = Value
       
       if Value and not isTeleportingToGunDrop then
           coroutine.wrap(teleportToGunDropLoop)()
       end
   end,
})


local originalPosition = nil 
local isTeleportingToGunDrop = false
local function teleportToGunDropLoop()
    while isTeleportingToGunDrop do
        local gunDrop = Workspace:FindFirstChild("GunDrop")
        if gunDrop and not originalPosition then
            originalPosition = LP.Character.HumanoidRootPart.CFrame
            LP.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
        elseif not gunDrop and originalPosition then
            LP.Character.HumanoidRootPart.CFrame = originalPosition
            originalPosition = nil
            isTeleportingToGunDrop = false
        end
        wait(0.5)
    end
end

local Keybind = RolesTab:CreateKeybind({
   Name = "Teleport to Gun",
   CurrentKeybind = "G",
   HoldToInteract = false,
   Flag = "KeybindGunDrop",
   SectionParent = InoocentSection,
   Callback = function(Keybind)
       if isTeleportingToGunDrop then
           isTeleportingToGunDrop = false
       else
           isTeleportingToGunDrop = true
           teleportToGunDropLoop()
       end
   end,
})

local GunDropLabel = RolesTab:CreateLabel("Checking for GunDrop...")

local function updateGunDropLabel()
    local gunDrop = Workspace:FindFirstChild("GunDrop")
    
    if gunDrop then
        GunDropLabel:Set("Gun found!")
    else
        GunDropLabel:Set("Gun not found.")
    end
end
updateGunDropLabel()
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "GunDrop" then
        updateGunDropLabel()
    end
end)
Workspace.ChildRemoved:Connect(function(child)
    if child.Name == "GunDrop" then
        updateGunDropLabel()
    end
end)

local SheriffSection = RolesTab:CreateSection("Sheriff",false)

local Toggle = RolesTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "ToggleAim",
    SectionParent = SheriffSection,
    Callback = function(Value)
        getgenv().SheriffAim = Value 
    end
})

local Slider = RolesTab:CreateSlider({
    Name = "Gun Accuracy",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 10,
    Flag = "SliderAccuracy",
    SectionParent = SheriffSection,
    Callback = function(Value)
        getgenv().GunAccuracy = Value
    end
})
local GunHook
GunHook = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if not checkcaller() then
        if typeof(self) == "Instance" and self.Name == "ShootGun" and method == "InvokeServer" then
            if getgenv().SheriffAim and getgenv().GunAccuracy then
                local targetPlayer = nil

                for _, player in pairs(Players:GetPlayers()) do
                    local character = player.Character
                    local backpack = player:FindFirstChild("Backpack")

                    if (backpack and backpack:FindFirstChild("Knife")) or 
                       (character and character:FindFirstChildWhichIsA("Tool") and character:FindFirstChildWhichIsA("Tool").Name == "Knife") then
                        targetPlayer = player
                        break
                    end
                end

                if targetPlayer then
                    local Root = targetPlayer.Character.PrimaryPart
                    local Veloc = Root.AssemblyLinearVelocity
                    local Pos = Root.Position + (Veloc * Vector3.new(getgenv().GunAccuracy / 200, 0, getgenv().GunAccuracy/ 200))
                    args[2] = Pos
                end
            end
        end
    end
    return GunHook(self, unpack(args))
end)


local MurderSection = RolesTab:CreateSection("Murderer",false)

local ATTACK_DELAY = 0.1
local lastAttackTime = 0

local isAutoAttackEnabled = false

function attackPlayer(player)
    local success, message = pcall(function()
        local knife = Client.Backpack:FindFirstChild("Knife") or Client.Character:FindFirstChild("Knife")
        if knife and knife:IsA("Tool") then
            local enemyRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local distance = (enemyRoot.Position - Client.Character.PrimaryPart.Position).Magnitude
                if distance <= getgenv().KnifeRange then
                    VirtualUser:ClickButton1(Vector2.new())
                    firetouchinterest(enemyRoot, knife.Handle, 1)
                    firetouchinterest(enemyRoot, knife.Handle, 0)
                    lastAttackTime = tick()
                end
            end
        end
    end)

    if not success then
        warn("Error in attackPlayer function: " .. message)
    end
end

RunService.Heartbeat:Connect(function()
    if isAutoAttackEnabled and tick() - lastAttackTime >= ATTACK_DELAY then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Client and player.Character then
                attackPlayer(player)
            end
        end
    end
end)

local Toggle = RolesTab:CreateToggle({
    Name = "Auto Attack",
    CurrentValue = false,
    Flag = "ToggleAutoAttack",
    SectionParent = MurderSection,
    Callback = function(Value)
        isAutoAttackEnabled = Value
    end
})

local Slider = RolesTab:CreateSlider({
    Name = "Attack Range",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 10,
    Flag = "SliderAttackRange",
    SectionParent = MurderSection,
    Callback = function(Value)
        getgenv().KnifeRange = Value
    end
})

local GameOver = nil;
local Blocked = nil;
local function attackWithKnife()
    pcall(function()
        local Knife = Client.Backpack:FindFirstChild("Knife") or Client.Character:FindFirstChild("Knife")

        if Knife then
            if Knife.Parent.Name == "Backpack" then
                Humanoid:EquipTool(Knife)
            end
        
            if Knife:IsA("Tool") then
                for _, v in ipairs(Players:GetPlayers()) do
                    if v ~= Client and v.Character then
                        local EnemyRoot = v.Character.HumanoidRootPart
                        
                        -- Simulate a click (although this might not have any effect without a specific target)
                        VirtualUser:ClickButton1(Vector2.new())
                        
                        -- Touch the enemy with the knife
                        firetouchinterest(EnemyRoot, Knife.Handle, 1)
                        firetouchinterest(EnemyRoot, Knife.Handle, 0)

                        lastAttack = tick()
                    end
                end
            end
        end
    end)
end

-- Set up the keybind
local Keybind = RolesTab:CreateKeybind({
    Name = "Kill All",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "KeybindAttack",
    SectionParent = MurderSection,
    Callback = function()
        attackWithKnife()
    end
})





local PlayerESPSection = VisualsTab:CreateSection("Player ESP",false)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local updateRate = 1 -- checks every second

local function hasSpecificTool(player, toolName)
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then
            return true
        end
    end
    
    local character = player.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == toolName then
                return true
            end
        end
    end

    return false
end

local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if hasSpecificTool(player, "Knife") then
            if not player.Character:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)  -- Red
                highlight.FillTransparency = 1
            else
                player.Character.Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)  -- Red
            end
        elseif hasSpecificTool(player, "Gun") then
            if not player.Character:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.OutlineColor = Color3.fromRGB(0, 0, 255)  -- Blue
                highlight.FillTransparency = 1
            else
                player.Character.Highlight.OutlineColor = Color3.fromRGB(0, 0, 255)  -- Blue
            end
        else
            if not player.Character:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.OutlineColor = Color3.fromRGB(0, 255, 0)  -- Green
                highlight.FillTransparency = 1
            else
                player.Character.Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)  -- Green
            end
        end
    end
end

local function updateHighlightForTool(player, toolName, color)
    if hasSpecificTool(player, toolName) then
        if not player.Character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight", player.Character)
            highlight.OutlineColor = color
            highlight.FillTransparency = 1
        else
            player.Character.Highlight.OutlineColor = color
        end
    else
        if player.Character:FindFirstChild("Highlight") then
            player.Character.Highlight:Destroy()
        end
    end
end

local ESPUpdateConnection = nil

local Toggle = VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = ESPEnabled,
    Flag = "ToggleESP",
    SectionParent = PlayerESPSection,
    Callback = function(Value)
        if Value then
            ESPUpdateConnection = RunService.Heartbeat:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if hasSpecificTool(player, "Knife") then
                        updateHighlightForTool(player, "Knife", Color3.fromRGB(255, 0, 0))
                    elseif hasSpecificTool(player, "Gun") then
                        updateHighlightForTool(player, "Gun", Color3.fromRGB(0, 0, 255))
                    else
                        if not player.Character:FindFirstChild("Highlight") then
                            local highlight = Instance.new("Highlight", player.Character)
                            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                            highlight.FillTransparency = 1
                        else
                            player.Character.Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
            end)
        else
            if ESPUpdateConnection then
                ESPUpdateConnection:Disconnect()
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character:FindFirstChild("Highlight") then
                        player.Character.Highlight:Destroy()
                    end
                end
            end
        end
    end,
})


local ESPMurdererUpdateConnection = nil

local ToggleMurderer = VisualsTab:CreateToggle({
    Name = "Murderer ESP",
    CurrentValue = ESPMurdererEnabled,
    Flag = "ToggleMurderer",
    SectionParent = PlayerESPSection,
    Callback = function(Value)
        if Value then
            ESPMurdererUpdateConnection = RunService.Heartbeat:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    updateHighlightForTool(player, "Knife", Color3.fromRGB(255, 0, 0))
                end
            end)
        else
            if ESPMurdererUpdateConnection then
                ESPMurdererUpdateConnection:Disconnect()
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character:FindFirstChild("Highlight") then
                        player.Character.Highlight:Destroy()
                    end
                end
            end
        end
    end,
})

local ESPSheriffUpdateConnection = nil

local ToggleSheriff = VisualsTab:CreateToggle({
    Name = "Sheriff ESP",
    CurrentValue = ESPSheriffEnabled,
    Flag = "ToggleSheriff",
    SectionParent = PlayerESPSection,
    Callback = function(Value)
        if Value then
            ESPSheriffUpdateConnection = RunService.Heartbeat:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    updateHighlightForTool(player, "Gun", Color3.fromRGB(0, 0, 255))
                end
            end)
        else
            if ESPSheriffUpdateConnection then
                ESPSheriffUpdateConnection:Disconnect()
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character:FindFirstChild("Highlight") then
                        player.Character.Highlight:Destroy()
                    end
                end
            end
        end
    end,
})






local ItemsESPSection = VisualsTab:CreateSection("Item's ESP",false)

-- Services
local RunService = game:GetService("RunService");

-- Variables
local ESPEnabledCoin = false;
local ESPEnabledGunDrop = false;
local lastAdornments = {};

-- Functions
local function HighlightObject(object, color)
    local adornment = Instance.new("BoxHandleAdornment");
    adornment.Adornee = object;
    adornment.Size = object.Size;
    adornment.ZIndex = 10;
    adornment.AlwaysOnTop = true;
    adornment.Color3 = color;
    adornment.Parent = game.Workspace.CurrentCamera;

    table.insert(lastAdornments, adornment);
end;

local function FindCoinContainer()
    for _, child in pairs(workspace:GetChildren()) do
        local coinContainer = child:FindFirstChild("CoinContainer")
        if coinContainer then
            return coinContainer
        end
    end
    return nil
end

local function ClearLastAdornments()
    for _, adornment in pairs(lastAdornments) do
        adornment:Destroy()
    end
    lastAdornments = {}
end

local function CoinEsp()
    if ESPEnabledCoin then
        local coinContainer = FindCoinContainer()
        if coinContainer then
            for _, coin in pairs(coinContainer:GetChildren()) do
                if coin:IsA("Part") and coin.Name == "Coin_Server" then
                    HighlightObject(coin, Color3.new(1, 1, 0))  -- Yellow
                end
            end
        end
    end

    if ESPEnabledGunDrop then
        local gunDrop = workspace:FindFirstChild("GunDrop")
        if gunDrop then
            HighlightObject(gunDrop, Color3.new(0, 0, 1))  -- Blue
        end
    end
end;

-- Main
RunService.RenderStepped:Connect(CoinEsp);

-- Toggle for Coin
local ToggleCoin = VisualsTab:CreateToggle({
    Name = "Toggle Coin ESP",
    CurrentValue = ESPEnabledCoin,
    Flag = "ToggleCoin",
    SectionParent = ItemsESPSection,
    Callback = function(Value)
        ESPEnabledCoin = Value
        if not Value then
            ClearLastAdornments()
        end
    end,
})

-- Toggle for GunDrop
local ToggleGunDrop = VisualsTab:CreateToggle({
    Name = "Gun ESP",
    CurrentValue = ESPEnabledGunDrop,
    Flag = "ToggleGunDrop",
    SectionParent = ItemsESPSection,
    Callback = function(Value)
        ESPEnabledGunDrop = Value
        if not Value then
            ClearLastAdornments()
        end
    end,
})

local FunESPSection = VisualsTab:CreateSection("Item's ESP",false)

local Button = VisualsTab:CreateButton({
    Name = "Fake Inventory",
    Interact = 'Click',
    SectionParent = FunESPSection,
    Callback = function()
        local WeaponOwnRange = {
            min=1,
            max=5
           }
           
           local DataBase, PlayerData = getrenv()._G.Database, getrenv()._G.PlayerData
           
           local newOwned = {}
           
           for i,v in next, DataBase.Item do
            newOwned[i] = math.random(WeaponOwnRange.min, WeaponOwnRange.max) -- newOwned[Weapon]: ItemCount
           end
           
           local PlayerWeapons = PlayerData.Weapons
           
           game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
            PlayerWeapons.Owned = newOwned
           end)
           
           game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end,
 })

 local ReplicatedStorage = game:GetService("ReplicatedStorage")
 local Client = game.Players.LocalPlayer
 
 local Modules = ReplicatedStorage.Modules
 local EmoteModule = require(Modules.EmoteModule)
 
 local EmoteList = {"headless", "zombie", "zen", "ninja", "floss", "dab"}
 
 local Button = VisualsTab:CreateButton({
     Name = "Free Emotes",
     Interact = 'Click',
     SectionParent = FunESPSection,
     Callback = function()
         -- Fetch the latest references inside the callback to ensure we always get the current ones
         local Emotes = Client.PlayerGui.MainGUI.Game:FindFirstChild("Emotes")
         if Emotes then
             EmoteModule.GeneratePage(EmoteList, Emotes, 'Free Emotes')
         end
     end
 })
 
 

local FakeGunSection = PerkTab:CreateSection("FakeGuns",false)

local Button = PerkTab:CreateButton({
    Name = "Delete Guns",
    Interact = 'Click',
    SectionParent = FakeGunSection,
    Callback = function()
        for i,v in pairs(workspace:getDescendants()) do
            if v:IsA('Tool') then
                v:Destroy()
            end
        end
        task.wait()
    end,
})

local Button = PerkTab:CreateButton({
    Name = "Fake Gun",
    Interact = 'Click',
    SectionParent = FakeGunSection,
    Callback = function()
        local args = {
            [1] = true
        }
        game:GetService("ReplicatedStorage").Remotes.Gameplay.FakeGun:FireServer(unpack(args))
    end,
 })

 local Toggle = PerkTab:CreateToggle({
    Name = "Loop Drop Guns",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = FakeGunSection,
    Callback = function(Value)
        if Value then
            _G.loopdropgun = game:GetService("RunService").RenderStepped:Connect(function()
                game:GetService("ReplicatedStorage").Remotes.Gameplay.FakeGun:FireServer(true)
                task.wait()
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Parent = workspace
                task.wait()
            end)
        else
            _G.loopdropgun:Disconnect()
            task.wait(1)
            DeleteAllBackpackGuns()
        end
    end,
})

local function FireGunAtPosition(position)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = position
    task.wait()
    game:GetService("ReplicatedStorage").Remotes.Gameplay.FakeGun:FireServer(true)
end

local positions = {
    CFrame.new(-110.61995697021484, 178.46054077148438, 24.172264099121094),
    CFrame.new(-107.0545425415039, 178.46054077148438, 49.758445739746094),
    CFrame.new(-107.48245239257812, 178.32301330566406, -21.168886184692383),
    CFrame.new(-66.5235595703125, 178.3394317626953, -6.834407329559326),
    CFrame.new(-64.53665924072266, 178.43014526367188, 22.159414291381836),
    CFrame.new(-107.0545425415039, 178.46054077148438, 49.758445739746094),
    CFrame.new(-76.67523956298828, 178.47299194335938, 46.36599349975586),
    CFrame.new(-147.1442108154297, 178.46054077148438, 48.81122589111328),
    CFrame.new(-158.49029541015625, 178.46054077148438, 18.649372100830078),
    CFrame.new(-151.8859405517578, 178.30340576171875, -8.303387641906738),
}

local Toggle = PerkTab:CreateToggle({
    Name = "Rain Guns Lobby",
    CurrentValue = false,
    Flag = "Toggle2",
    SectionParent = FakeGunSection,
    Callback = function(Value)
        if Value then
            lastposgunrain = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            local R3THRAINGUNS = Instance.new("Part", workspace)
            R3THRAINGUNS.Name = "R3THRAINGUNS"
            R3THRAINGUNS.Anchored = true
            R3THRAINGUNS.BottomSurface = Enum.SurfaceType.Smooth
            R3THRAINGUNS.TopSurface = Enum.SurfaceType.Smooth
            R3THRAINGUNS.Color = Color3.fromRGB(0, 0, 0)
            R3THRAINGUNS.Material = Enum.Material.Plastic
            R3THRAINGUNS.Size = Vector3.new(300, 0, 300)
            R3THRAINGUNS.CFrame = CFrame.new(-110, 174, 23)
            R3THRAINGUNS.Transparency = 1
            R3THRAINGUNS.Parent = workspace
            _G.looptprainguns = true
            _G.looptprainguns0 = game:GetService("RunService").Heartbeat:Connect(function()
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Parent = workspace
            end)
            while _G.looptprainguns do
                for _, position in ipairs(positions) do
                    FireGunAtPosition(position)
                    task.wait()
                end
            end
        else
            _G.looptprainguns0:Disconnect()
            _G.looptprainguns = false
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastposgunrain)
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "R3THRAINGUNS" then
                    v:Destroy()
                end
            end
            task.wait(1)
            DeleteAllBackpackGuns()
        end
    end,
})

local function picupallgunsnobreak()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
        end
    end
end

local Toggle = PerkTab:CreateToggle({
    Name = "Pickup All Guns",
    CurrentValue = false,
    Flag = "Toggle3",
    SectionParent = FakeGunSection,
    Callback = function(Value)
        if Value then
            _G.pickupallguns0 = true
            while _G.pickupallguns0 do
                pcall(picupallgunsnobreak)
                task.wait()
            end
        else
            _G.pickupallguns0 = false
        end
    end,
})

local TrapsSection = PerkTab:CreateSection("Traps",false)

function looptrapall0()
    task.wait(0.05)
    local randomPlayer = players:GetPlayers()[math.random(#players:GetPlayers())]
    local targetPosition = randomPlayer.Character.Head.Position
    local args = {
        [1] = CFrame.new(targetPosition.X, targetPosition.Y, targetPosition.Z)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("TrapSystem"):WaitForChild("PlaceTrap"):InvokeServer(unpack(args))
end


local Toggle = PerkTab:CreateToggle({
    Name = "Loop Trap All",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = TrapsSection,
    Callback = function(Value)
        if Value then
            _G.looptrapall = true
            while _G.looptrapall do
                pcall(looptrapall0)
                task.wait()
            end
        else
            _G.looptrapall = false
        end
    end,
})

-- Variable for trap range
local trapRange = 10  -- This is the default value

-- Function to trap nearby players
function trapNearbyPlayers()
    local myPosition = localPlayer.Character and localPlayer.Character.HumanoidRootPart.Position
    if not myPosition then return end

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            local distance = (myPosition - playerPosition).Magnitude
            if distance <= trapRange then
                local targetPosition = player.Character.Head.Position
                local args = {
                    [1] = CFrame.new(targetPosition.X, targetPosition.Y, targetPosition.Z)
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("TrapSystem"):WaitForChild("PlaceTrap"):InvokeServer(unpack(args))
                end)
            end
        end
    end
end

-- Toggle for trapping nearby players
local ProximityTrapToggle = PerkTab:CreateToggle({
    Name = "Trap Aura",
    CurrentValue = false,
    Flag = "ToggleProximityTrap",
    SectionParent = TrapsSection,  -- Make sure to use the appropriate section
    Callback = function(Value)
        if Value then
            _G.trapNearby = true
            while _G.trapNearby do
                trapNearbyPlayers()
                task.wait(0.5)  -- Check every half-second
            end
        else
            _G.trapNearby = false
        end
    end,
})

local TrapRangeSlider = PerkTab:CreateSlider({
    Name = "Trap Range",
    Range = {1, 50},  -- Adjust as per your needs
    Increment = 1,
    Suffix = " studs",
    CurrentValue = trapRange,  -- Initialize with default value
    Flag = "SliderTrapRange",  -- Using a different flag to avoid conflicts
    SectionParent = TrapsSection,  -- Make sure to use the appropriate section
    Callback = function(Value)
        trapRange = Value
    end,
})



local Keybind = PerkTab:CreateKeybind({
   Name = "Place Trap at Mouse Position",
   CurrentKeybind = "Q",
   HoldToInteract = false,
   Flag = "Keybind1",
   SectionParent = TrapsSection,
   Callback = function(Keybind)
       if not Keybind then
           local mousePosition = mouse.Hit.p
           local adjustedPosition = Vector3.new(mousePosition.X, mousePosition.Y + 2, mousePosition.Z)  -- Adjusting Y-coordinate for humanoid height
           local args = {
               [1] = CFrame.new(adjustedPosition)
           }
           game:GetService("ReplicatedStorage"):WaitForChild("TrapSystem"):WaitForChild("PlaceTrap"):InvokeServer(unpack(args))
       end
   end,
})


PaintSection = PerkTab:CreateSection("Spray Paint",false)



Misc22Section = PerkTab:CreateSection("Miscellaneous",false)

Toggle = PerkTab:CreateToggle({
    Name = "Infinite Ghost",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = Misc22Section,
    Callback = function(infiniteghost)
        if infiniteghost == true then
            local args = {
                [1] = true
            }
    
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(unpack(args))
            wait()
        end
        if infiniteghost == false then
            local args = {
                [1] = false
            }
            
            game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(unpack(args))
            wait()
        end
    end,
 })

 
local ToooolsSection = SettingsTab:CreateSection("Tools",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local Button = SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Interact = 'Click',
    SectionParent = ToooolsSection,
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
        
        ArrayField:Notify({
            Title = "Server Rejoin",
            Content = "You will now rejoin the same server.",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Got It!",
                    Callback = function()
                        print("The user acknowledged the notification.")
                    end
                },
            },
        })
    end,
})

local TargetPlaceId = 142823291 -- Replace this with the target place ID you want to switch to
local Button = SettingsTab:CreateButton({
    Name = "Switch Server",
    Interact = 'Click',
    SectionParent = ToooolsSection,
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(TargetPlaceId, game.JobId)
        
        ArrayField:Notify({
            Title = "Server Switch",
            Content = "You will now switch to a different server.",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user acknowledged the notification.")
                    end
                },
            },
        })
    end,
})