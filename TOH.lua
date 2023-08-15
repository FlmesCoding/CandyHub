local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local zzzWindow = ArrayField:CreateWindow({
    Name = "Tower Of Hell - CandyHub",
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

local Main33Tab = zzzWindow:CreateTab("Main", nil) -- Title, Image

local Wins = Main33Tab:CreateSection("Wins",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local Button = Main33Tab:CreateButton({
    Name = "Teleport to End",
    Interact = 'Click',
    Callback = function()
        local player = game.Players.LocalPlayer 
        local destination = game:GetService("Workspace").tower.finishes.Finish.Position
 
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(destination)
        end
    end,
 })

 
 local isTeleporting = false
 local Toggle = Main33Tab:CreateToggle({
    Name = "Loop Teleport To End",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        isTeleporting = Value
        
        while isTeleporting do
            local player = game.Players.LocalPlayer 
            local destination = game:GetService("Workspace").tower.finishes.Finish.Position
 
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(destination)
            end
 
            wait(0.5) -- waits for half a second before teleporting again; adjust this value as needed
        end
    end,
 })

 local Wins = Main33Tab:CreateSection("Misc",false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

 local Button = Main33Tab:CreateButton({
    Name = "No Fog",
    Interact = 'Click',
    Callback = function()
        while true do
            wait()
            game.Lighting.FogEnd = 1000000
            wait()
            end
    end,
 })

 local Button = Main33Tab:CreateButton({
    Name = "Free Items",
    Interact = 'Click',
    Callback = function()
for _,e in pairs(game.Players.LocalPlayer.Backpack:GetDescendants()) do
    if e:IsA("Tool") then
    e:Destroy()
    end
    end
    wait() 
    for _,v in pairs(game.ReplicatedStorage.Gear:GetDescendants()) do
    if v:IsA("Tool") then
    local CloneThings = v:Clone()
    wait()
    CloneThings.Parent = game.Players.LocalPlayer.Backpack
    
    end
    end
    end,
 })

 local LocalPlayer = game.Players.LocalPlayer
 local isInvincible = false
 
 local function Invincibility(player)
     if player.Character then
         for i, v in pairs(player.Character:GetChildren()) do
             if v.Name == "hitbox" then
                 v:Destroy()
             end
         end
     end
 end
 
 local function maintainInvincibility()
     while isInvincible do
         Invincibility(LocalPlayer)
         wait(0.5)
     end
 end
 
 local InvincibilityButton = Main33Tab:CreateButton({
    Name = "Invincibility",
    Interact = 'Click',
    Callback = function()
        isInvincible = not isInvincible  -- Toggle the state
        
        if isInvincible then
            maintainInvincibility()
        end
    end,
 })