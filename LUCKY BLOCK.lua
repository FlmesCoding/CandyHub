local ArrayField11 = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local llWindow = ArrayField11:CreateWindow({
    Name = "Lucky Blocks Battle Grounds - CandyHub",
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

local Main = llWindow:CreateTab("Main", nil) -- Title, Image
local FreeSection = Main:CreateSection("Free Lucky Blocks",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

-- Button for SpawnRainbowBlock
local RainbowButton = Main:CreateButton({
    Name = "SpawnRainbowBlock",
    Interact = 'Click',
    SectionParent = FreeSection,
    Callback = function()
        game:GetService("ReplicatedStorage").SpawnRainbowBlock:FireServer()
    end,
 })
 
 -- Button for SpawnGalaxyBlock
 local GalaxyButton = Main:CreateButton({
    Name = "SpawnGalaxyBlock",
    Interact = 'Click',
    SectionParent = FreeSection,
    Callback = function()
        game:GetService("ReplicatedStorage").SpawnGalaxyBlock:FireServer()
    end,
 })
 
 -- Button for SpawnDiamondBlock
 local DiamondButton = Main:CreateButton({
    Name = "SpawnDiamondBlock",
    Interact = 'Click',
    SectionParent = FreeSection,
    Callback = function()
        game:GetService("ReplicatedStorage").SpawnDiamondBlock:FireServer()
    end,
 })
 
 -- Button for SpawnSuperBlock
 local SuperButton = Main:CreateButton({
    Name = "SpawnSuperBlock",
    Interact = 'Click',
    SectionParent = FreeSection,
    Callback = function()
        game:GetService("ReplicatedStorage").SpawnSuperBlock:FireServer()
    end,
 })
 
 -- Button for SpawnLuckyBlock
 local LuckyButton = Main:CreateButton({
    Name = "SpawnLuckyBlock",
    Interact = 'Click',
    SectionParent = FreeSection,
    Callback = function()
        game:GetService("ReplicatedStorage").SpawnLuckyBlock:FireServer()
    end,
 })
 
 local LoopSection = Main:CreateSection("Loop Open Blocks",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

 local activeLoops = {}

local function handleLoop(remotePath, state)
    if activeLoops[remotePath] then
        activeLoops[remotePath] = false
    end
    
    if state then
        activeLoops[remotePath] = true
        coroutine.wrap(function()
            local remote = loadstring("return " .. remotePath)()  -- Get the remote instance
            while activeLoops[remotePath] and remote and remote.FireServer do
                remote:FireServer()
                wait(0.5)  -- Adjust delay as necessary
            end
        end)()
    end
end

-- For RainbowBlock
local Toggle1 = Main:CreateToggle({
    Name = "Loop SpawnRainbowBlock",
    CurrentValue = false,
    Flag = "ToggleRainbow",
    SectionParent = LoopSection,
    Callback = function(Value)
        handleLoop("game:GetService('ReplicatedStorage').SpawnRainbowBlock", Value)
    end,
})

-- For GalaxyBlock
local Toggle2 = Main:CreateToggle({
    Name = "Loop SpawnGalaxyBlock",
    CurrentValue = false,
    Flag = "ToggleGalaxy",
    SectionParent = LoopSection,
    Callback = function(Value)
        handleLoop("game:GetService('ReplicatedStorage').SpawnGalaxyBlock", Value)
    end,
})

-- For DiamondBlock
local Toggle3 = Main:CreateToggle({
    Name = "Loop SpawnDiamondBlock",
    CurrentValue = false,
    Flag = "ToggleDiamond",
    SectionParent = LoopSection,
    Callback = function(Value)
        handleLoop("game:GetService('ReplicatedStorage').SpawnDiamondBlock", Value)
    end,
})

-- For SuperBlock
local Toggle4 = Main:CreateToggle({
    Name = "Loop SpawnSuperBlock",
    CurrentValue = false,
    Flag = "ToggleSuper",
    SectionParent = LoopSection,
    Callback = function(Value)
        handleLoop("game:GetService('ReplicatedStorage').SpawnSuperBlock", Value)
    end,
})

-- For LuckyBlock
local Toggle5 = Main:CreateToggle({
    Name = "Loop SpawnLuckyBlock",
    CurrentValue = false,
    Flag = "ToggleLucky",
    SectionParent = LoopSection,
    Callback = function(Value)
        handleLoop("game:GetService('ReplicatedStorage').SpawnLuckyBlock", Value)
    end,
})

local miscSection = Main:CreateSection("misc",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local Folder = Instance.new("Folder", game:GetService("CoreGui"))
Folder.Name = ""

local function AddOutline(Character)
    local Highlight = Instance.new("Highlight", Folder)
    
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.Adornee = Character
    
    if true then
        Highlight.FillColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 1
    else
        Highlight.FillTransparency = 1
    end
end

local function AddNameTag(Character)
    local BGui = Instance.new("BillboardGui", Folder)
    local Frame = Instance.new("Frame", BGui)
    local TextLabel = Instance.new("TextLabel", Frame)
    
    BGui.Adornee = Character:WaitForChild("Head")
    BGui.StudsOffset = Vector3.new(0, 3, 0)
    BGui.AlwaysOnTop = true
    
    BGui.Size = UDim2.new(4, 0, 0.5, 0)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    
    Frame.BackgroundTransparency = 1
    TextLabel.BackgroundTransparency = 1
    
    TextLabel.Text = Character.Name
    TextLabel.Font = Enum.Font.RobotoMono
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = false
end

local playerConnections = {}

local function activateFeatures()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer then
            table.insert(playerConnections, player.CharacterAdded:Connect(function(character)
                AddOutline(character)
                AddNameTag(character)
            end))
            
            if player.Character then
                AddOutline(player.Character)
                AddNameTag(player.Character)
            end
        end
    end

    table.insert(playerConnections, game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            AddOutline(character)
            AddNameTag(character)
        end)
    end))
end

local function deactivateFeatures()
    for _, connection in ipairs(playerConnections) do
        connection:Disconnect()
    end
    playerConnections = {}
    for _, v in pairs(Folder:GetChildren()) do
        v:Destroy()
    end
end

-- The Toggle
local Toggle = Main:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ToggleFeatureFlag",
    SectionParent = miscSection,
    Callback = function(Value)
        if Value then
            activateFeatures()
        else
            deactivateFeatures()
        end
    end
})

local Button = Main:CreateButton({
    Name = "Kill Random Player",
    Interact = 'Click',
    SectionParent = miscSection,
    Callback = function()
         if not firetouchinterest then
             ArrayField:Notify({
                 Title = "Incompatible Exploit",
                 Content = "Your exploit does not support this command (missing firetouchinterest)",
                 Duration = 6.5,
                 Image = 4483362458,
                 Actions = {
                     Ignore = {
                         Name = "Okay!",
                         Callback = function()
                             print("The user tapped Okay!")
                         end
                     },
                 }
             })
             return 
         end
         
         local speaker = game.Players.LocalPlayer
         local RS = game:GetService("RunService")
         local Tool = speaker.Character:FindFirstChildWhichIsA("Tool")
         local Handle = Tool and Tool:FindFirstChild("Handle")
         
         if not Tool or not Handle then
             ArrayField:Notify({
                 Title = "Handle Kill",
                 Content = "You need to hold a \"Tool\" that does damage on touch. For example the default \"Sword\" tool.",
                 Duration = 6.5,
                 Image = 4483362458,
                 Actions = {
                     Ignore = {
                         Name = "Okay!",
                         Callback = function()
                             print("The user tapped Okay!")
                         end
                     },
                 }
             })
             return
         end
 
         local players = game:GetService("Players"):GetPlayers()
         local targetPlayer = players[math.random(#players)]
         
         if targetPlayer == speaker then
             return -- skip the current player
         end
 
         task.spawn(function()
             while Tool and speaker.Character and targetPlayer.Character and Tool.Parent == speaker.Character do
                 local Human = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                 if not Human or Human.Health <= 0 then
                     break
                 end
                 for _, v1 in ipairs(targetPlayer.Character:GetChildren()) do
                     if v1:IsA("BasePart") then
                         firetouchinterest(Handle, v1, 1)
                         RS.RenderStepped:Wait()
                         firetouchinterest(Handle, v1, 0)
                     end
                 end
             end
             ArrayField:Notify({
                 Title = "Handle Kill Stopped!",
                 Content = targetPlayer.Name .. " died/left or you unequipped the tool!",
                 Duration = 6.5,
                 Image = 4483362458,
                 Actions = {
                     Ignore = {
                         Name = "Okay!",
                         Callback = function()
                             print("The user tapped Okay!")
                         end
                     },
                 }
             })
         end)
     end
})
 
local Input = Main:CreateInput({
    Name = "Kill Specific Player",
    PlaceholderText = "Enter Player's Name",
    NumbersOnly = false,
    CharacterLimit = 50,
    OnEnter = true,
    RemoveTextAfterFocusLost = false,
    SectionParent = miscSection,
    Callback = function(Text)
        local targetPlayer
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if string.match(player.Name:lower(), Text:lower()) or string.match(player.DisplayName:lower(), Text:lower()) then
                targetPlayer = player
                break
            end
        end
 
        local speaker = game.Players.LocalPlayer
 
        if not targetPlayer or targetPlayer == speaker then
            ArrayField:Notify({
                Title = "Error",
                Content = "Invalid player name or you tried to kill yourself.",
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
            return
        end
 
        -- The handle-kill code:
        if not firetouchinterest then
            ArrayField:Notify({
                Title = "Incompatible Exploit",
                Content = "Your exploit does not support this command (missing firetouchinterest)",
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
            return
        end
        
        local Tool = speaker.Character:FindFirstChildWhichIsA("Tool")
        local Handle = Tool and Tool:FindFirstChild("Handle")
        if not Tool or not Handle then
            ArrayField:Notify({
                Title = "Handle Kill",
                Content = "You need to hold a \"Tool\" that does damage on touch. For example the default \"Sword\" tool.",
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
            return
        end
 
        task.spawn(function()
            while Tool and speaker.Character and targetPlayer.Character and Tool.Parent == speaker.Character do
                local Human = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if not Human or Human.Health <= 0 then
                    break
                end
                for _, v1 in ipairs(targetPlayer.Character:GetChildren()) do
                    if v1:IsA("BasePart") then
                        firetouchinterest(Handle, v1, 1)
                        wait(0.1)
                        firetouchinterest(Handle, v1, 0)
                    end
                end
            end
            ArrayField:Notify({
                Title = "Handle Kill Stopped!",
                Content = targetPlayer.Name .. " died/left or you unequipped the tool!",
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
        end)
    end,
 })

 local Toggle = Main:CreateToggle({
    Name = "Kill All",
    CurrentValue = false,
    Flag = "Toggle1",
    SectionParent = miscSection,
    Callback = function(Value)
        local isLooping = false
        
        -- Define the kill function
        local function handleKill(targetPlayer)
            local speaker = game.Players.LocalPlayer
            local Tool = speaker.Character:FindFirstChildWhichIsA("Tool")
            local Handle = Tool and Tool:FindFirstChild("Handle")
            
            if not Tool or not Handle then
                ArrayField:Notify({
                    Title = "Handle Kill",
                    Content = "You need to hold a \"Tool\" that does damage on touch. For example the default \"Sword\" tool.",
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
                return
            end
 
            while Tool and speaker.Character and targetPlayer.Character and Tool.Parent == speaker.Character and isLooping do
                local Human = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if not Human or Human.Health <= 0 then
                    break
                end
                for _, v1 in ipairs(targetPlayer.Character:GetChildren()) do
                    if v1:IsA("BasePart") then
                        firetouchinterest(Handle, v1, 1)
                        wait(0.1)
                        firetouchinterest(Handle, v1, 0)
                    end
                end
                wait(0.5) -- Just to prevent too much spam and give a little delay
            end
        end
 
        if Value == true then
            isLooping = true
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    task.spawn(handleKill, player)
                end
            end
        else
            isLooping = false
        end
    end,
 })