local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
    local dwwdddddqdqWindow = ArrayField:CreateWindow({
        Name = "Slap Battles - CandyHub",
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

    local mddakeTab = dwwdddddqdqWindow:CreateTab("Main", 4483362458) -- Title, Image
    local CombatSection = mddakeTab:CreateSection("Combat",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

    local player = game.Players.LocalPlayer
    local toggleStates = {
        RagdollFreeze = false,
        MailPopup = false,
        ScreenShake = false
    }
    local ragdollConnection

    local function applyRagdollFreeze()
        local character = player.Character
        
        if ragdollConnection then
            ragdollConnection:Disconnect()
            ragdollConnection = nil
        end
    
        local bodyGyro = Instance.new("BodyGyro")
        local bodyPosition = Instance.new("BodyPosition")
    
        bodyGyro.MaxTorque = Vector3.new(1e4, 1e4, 1e4)
        bodyPosition.MaxForce = Vector3.new(1e4, 1e4, 1e4)
        
        local function handleRagdollChange(isRagdolled)
            if isRagdolled then
                bodyGyro.CFrame = character.HumanoidRootPart.CFrame
                bodyPosition.Position = character.HumanoidRootPart.Position
    
                bodyGyro.Parent = character.HumanoidRootPart
                bodyPosition.Parent = character.HumanoidRootPart
            else
                bodyGyro.Parent = nil
                bodyPosition.Parent = nil
            end
        end
        
        ragdollConnection = character:WaitForChild("Ragdolled").Changed:Connect(handleRagdollChange)
    end
    
    local function applyMailPopup()
        local function handleMailEvent()
            local mailPopup = PlayerGui:FindFirstChild("MailPopup")
            if mailPopup then
                mailPopup:Destroy()
            end
        end
        game.ReplicatedStorage.MailSend.OnClientEvent:Connect(handleMailEvent)
    end

    local RagdollFreezeToggle = mddakeTab:CreateToggle({
        Name = "Anti Ragdoll",
        CurrentValue = toggleStates.RagdollFreeze,
        Flag = "ToggleRagdollFreeze",
        SectionParent = CombatSection,
        Callback = function(Value)
            toggleStates.RagdollFreeze = Value
            if Value then
                applyRagdollFreeze()
            elseif ragdollConnection then
                ragdollConnection:Disconnect()
                ragdollConnection = nil
            end
        end,
    })
    
player.CharacterAdded:Connect(function()
    wait(1)
    if toggleStates.RagdollFreeze then applyRagdollFreeze() end
    if toggleStates.MailPopup then applyMailPopup() end
    if toggleStates.ScreenShake then applyScreenShake() end
end)
    

local MailPopupToggle = mddakeTab:CreateToggle({
    Name = "Anti Mail",
    CurrentValue = false,
    Flag = "ToggleMailPopup",
    SectionParent = CombatSection,
    Callback = function(Value)
        toggleStates.MailPopup = Value
        if Value then
            applyMailPopup()
        end
    end,
})

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("b")

local detectionRange = 5000  -- Adjust this to the distance you want

local function isPlayerNearby(character, otherPlayer)
    local otherCharacter = otherPlayer.Character
    if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
        local distance = (character.HumanoidRootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude
        return distance <= detectionRange
    end
    return false
end

local function checkNearbyPlayers()
    while wait(0.1) do  -- The loop checks every 0.1 seconds; adjust for sensitivity
        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and isPlayerNearby(player.Character, otherPlayer) then
                local args = {[1] = otherPlayer.Character.HumanoidRootPart}
                remoteEvent:FireServer(unpack(args))
            end
        end
    end
end

local checkPlayersJob

local Toggle = mddakeTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = CombatSection,
    Callback = function(Value)
        if Value then
            checkPlayersJob = coroutine.wrap(checkNearbyPlayers)
            checkPlayersJob()
        else
            if checkPlayersJob then
                coroutine.yield(checkPlayersJob)
                checkPlayersJob = nil
            end
        end
    end,
})





local Button = mddakeTab:CreateButton({
    Name = "AutoFarm Players",
    Interact = 'Click',
    SectionParent = CombatSection,
    Callback = function()
        local player = game.Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remoteEvent = ReplicatedStorage:WaitForChild("b")
        local Workspace = game:GetService("Workspace")
        
        local detectionRange = 1650 
        local heightAbovePlayer = 25  -- Changed the variable name and made it positive
        local safeDistanceFromRock = 50 

        local function hasErrorTool(player)
            if player.Backpack:FindFirstChild("Error") or (player.Character and player.Character:FindFirstChild("Error")) then
                return true
            end
            return false
        end

        local function playerHasTool(p)
            for _, item in pairs(p.Backpack:GetChildren()) do
                if item:IsA('Tool') then
                    return true
                end
            end
            if p.Character then
                for _, item in pairs(p.Character:GetChildren()) do
                    if item:IsA('Tool') then
                        return true
                    end
                end
            end
            return false
        end

        local function playerWithObjectExists()
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("rock") then
                    return true, p
                end
            end
            return false, nil
        end

        local function isTransparent(character)
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("MeshPart") or part:IsA("Part") then
                    if part.Transparency == 0.5 then
                        return true
                    end
                end
            end
            return false
        end

        local function hasLeashTool(player)
            if player.Backpack:FindFirstChild("Leash") or (player.Character and player.Character:FindFirstChild("Leash")) then
                return true
            end
            return false
        end

        local function isWithinLobbyArea(character)
            return game:GetService("Workspace").Lobby:IsAncestorOf(character)
        end

        local function distanceFromRock(position)
            local rock = Workspace:FindFirstChild("rock")
            if rock then
                return (position - rock.Position).Magnitude
            end
            return math.huge
        end

        local function getNextPlayer(currentTarget)
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") and otherPlayer ~= currentTarget then
                    return otherPlayer
                end
            end
            return nil
        end

        local function getClosestPlayer(character)
            local shortestDistance = math.huge
            local closestPlayer = nil
        
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") 
                   and not isTransparent(otherPlayer.Character) and not isWithinLobbyArea(otherPlayer.Character) 
                   and distanceFromRock(otherPlayer.Character.Head.Position) > safeDistanceFromRock 
                   and not hasErrorTool(otherPlayer) and not hasLeashTool(otherPlayer) then
                    local distance = (character.Head.Position - otherPlayer.Character.Head.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        
            return closestPlayer
        end

        local function getClosestPlayerWithTool(character)
            local shortestDistance = math.huge
            local closestPlayer = nil
            
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") 
                   and not isTransparent(otherPlayer.Character) and not isWithinLobbyArea(otherPlayer.Character) 
                   and distanceFromRock(otherPlayer.Character.Head.Position) > safeDistanceFromRock 
                   and not hasErrorTool(otherPlayer) and not hasLeashTool(otherPlayer) and playerHasTool(otherPlayer) then
                    local distance = (character.Head.Position - otherPlayer.Character.Head.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            return closestPlayer
        end

        local function createPlatform(position)
            local platform = Instance.new("Part")
            platform.Position = position
            platform.Size = Vector3.new(10, 1, 10)
            platform.Anchored = true
            platform.CanCollide = true
            platform.BrickColor = BrickColor.new("Really black") -- Set to black color
            platform.Transparency = 1 -- Set to invisible
            platform.Parent = Workspace
            return platform
        end

        local function continuousTeleportAndActivate(character)
            local platform = nil
            local currentTarget = nil
        
            character.Humanoid.Died:Connect(function()
                character:SetPrimaryPartCFrame(Workspace.Lobby.Teleport1.CFrame)
                wait(1)
            end)
        
            while true do
                local hasRock, playerWithRock = playerWithObjectExists()
                if hasRock then
                    currentTarget = getNextPlayer(playerWithRock)
                    if currentTarget then
                        character:SetPrimaryPartCFrame(currentTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, heightAbovePlayer, 0))
                    end
                else
                    local closestPlayer = getClosestPlayer(character)
                    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoid = closestPlayer.Character:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            wait(0.1)
                            closestPlayer = getClosestPlayer(character)
                        end
                        character:SetPrimaryPartCFrame(closestPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, heightAbovePlayer, 0))
                        
                        if not platform then
                            platform = createPlatform(character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                        else
                            platform.Position = character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                        end
        
                        local args = {[1] = closestPlayer.Character.Head}
                        remoteEvent:FireServer(unpack(args))
                        wait(0.05)
                    end
                end
                wait(0)
            end
        end
        
        player.CharacterAdded:Connect(continuousTeleportAndActivate)
        local currentCharacter = player.Character or player.CharacterAdded:Wait()
        continuousTeleportAndActivate(currentCharacter)
    end,
})






local cheeSection = mddakeTab:CreateSection("Character",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element



local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera


local JumpPowerSlider = mddakeTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   SectionParent = cheeSection,
   Callback = function(Value)
      player.Character.Humanoid.JumpPower = Value
   end,
})

local GravitySlider = mddakeTab:CreateSlider({
   Name = "Gravity",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Studs/Sec^2",
   CurrentValue = 196.2,
   Flag = "GravitySlider",
   SectionParent = cheeSection,
   Callback = function(Value)

      workspace.Gravity = Value
   end,
})

local FOVSlider = mddakeTab:CreateSlider({
   Name = "FOV",
   Range = {1, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Flag = "FOVSlider",
   SectionParent = cheeSection,
   Callback = function(Value)
      camera.FieldOfView = Value
   end,
})