loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()
getgenv().Aimbot.Settings.Enabled = false
getgenv().Aimbot.FOVSettings.Sides = 15
getgenv().Aimbot.FOVSettings.Visible = false
getgenv().Aimbot.FOVSettings.Thickness = 2
getgenv().SecureMode = true

local InfiniteJump = false
local g_mod = false
_G.high_esp = false

local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Window = ArrayField:CreateWindow({
    Name = "Kat - CandyHub",
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

local combat = Window:CreateTab("Main", nil) -- Title, Image
local visuals = Window:CreateTab("Visuals", nil) -- Title, Image
local misc = Window:CreateTab("Misc", nil) -- Title, Image

local Button = combat:CreateButton({
    Name = "Silent Aim",
    Interact = 'Click',
    Callback = function()
        local localPlayer = game:GetService("Players").LocalPlayer
        local currentCamera = game:GetService("Workspace").CurrentCamera
        local mouse = localPlayer:GetMouse()
    
        local function getClosestPlayerToCursor(x, y)
            local closestPlayer = nil
            local shortestDistance = math.huge
    
            for i, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                    local pos = currentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(x, y)).magnitude
    
                    if magnitude < shortestDistance then
                        closestPlayer = v
                        shortestDistance = magnitude
                    end
                end
            end
    
            return closestPlayer
        end
    
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end
        local newClose = newcclosure or function(f) return f end
    
        mt.__index = newClose(function(t, k)
            if not checkcaller() and t == mouse and tostring(k) == "X" and string.find(getfenv(2).script.Name, "Client") and getClosestPlayerToCursor() then
                local closest = getClosestPlayerToCursor(oldIndex(t, k), oldIndex(t, "Y")).Character.Head
                local pos = currentCamera:WorldToScreenPoint(closest.Position)
                return pos.X
            end
            if not checkcaller() and t == mouse and tostring(k) == "Y" and string.find(getfenv(2).script.Name, "Client") and getClosestPlayerToCursor() then
                local closest = getClosestPlayerToCursor(oldIndex(t, "X"), oldIndex(t, k)).Character.Head
                local pos = currentCamera:WorldToScreenPoint(closest.Position)
                return pos.Y
            end
            if t == mouse and tostring(k) == "Hit" and string.find(getfenv(2).script.Name, "Client") and getClosestPlayerToCursor() then
                return getClosestPlayerToCursor(mouse.X, mouse.Y).Character.Head.CFrame
            end
    
            return oldIndex(t, k)
        end)
    
        if setreadonly then setreadonly(mt, true) else make_writeable(mt, false) end
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfiniteJump == true then
		game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
	end
end)

local AimbotToggle = combat:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
       getgenv().Aimbot.Settings.Enabled = Value
    end,
 })

 local FOVCircleToggle = combat:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = false,
    Flag = "FOVCircleToggle",
    Callback = function(Value)
       getgenv().Aimbot.FOVSettings.Visible = Value
    end,
 })

 local FOVSlider = combat:CreateSlider({
    Name = "FOV",
    Range = {50, 250},
    Increment = 1,
    Suffix = "",  -- I've left the suffix blank, adjust as necessary
    CurrentValue = 190,
    Flag = "FOVSlider",
    Callback = function(Value)
       print(Value)
       getgenv().Aimbot.FOVSettings.Amount = Value
    end,
 })

 local FOVColorPicker = combat:CreateColorPicker({
    Name = "FOV Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "FOVColorPicker",
    Callback = function(Value)
        getgenv().Aimbot.FOVSettings.Color = Value
    end
})

local SpeedBoostButton = misc:CreateButton({
    Name = "Lil SpeedBoost",
    Interact = 'Click',
    Callback = function()
       local mt = getrawmetatable(game)
       local backup
       backup = hookfunction(mt.__newindex, newcclosure(function(self, key, value)
          if key == "WalkSpeed" then
             value = 23
          end
          return backup(self, key, value)
       end))
    end,
 })
 
 local InfJumpToggle = misc:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
       InfiniteJump = Value
    end,
 })
 
 local GunModsToggle = misc:CreateToggle({
    Name = "GunMods",
    CurrentValue = false,
    Flag = "GunModsToggle",
    Callback = function(Value)
       g_mod = Value
    end,
 })

 local Toggle = visuals:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(bool)
        _G.high_esp = bool
	
        if bool == false then
            for _,v in pairs(game.Workspace:GetChildren()) do
                if v:FindFirstChildWhichIsA("Humanoid") then
                    if v:FindFirstChildWhichIsA("Highlight") then
                        v:FindFirstChildWhichIsA("Highlight"):Destroy()
                    end
                end
            end
        end
    end,
 })

 local ColorPicker = visuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(color)
        for _,v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "penis" then
                pcall(function()
                    v.FillColor = color
                end)
            end
        end
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
	if _G.high_esp == true then
		for _,v in pairs(game.Workspace:GetChildren()) do
			if v:FindFirstChildWhichIsA("Humanoid") then
				if not v:FindFirstChildWhichIsA("Highlight") then
					local h = Instance.new("Highlight",v)
					h.Name = "penis"
					h.FillTransparency = 0.1
					h.OutlineTransparency = 1
					h.FillColor = Color3.new(0.666667, 0, 1)
				end
			end
		end
	end
end)

while wait(1) do
	if g_mod == true then
		for i, v in next, getgc(true) do
			if type(v) == "table" then
				if rawget(v, "LoadedAmmo") then
					v.LoadedAmmo = 10000000000
					v.RecoilFactor = 0
					v.Spread = 0
				end
				if rawget(v, "ReloadTime") then
					v.ReloadTime = 0
					v.EquipTime = 0
					v.LoadCapacity = 10000000000
				end
			end
		end
	end
end