local L_28_ = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
L_28_.Audio.Play(5205173410, workspace, 1, 1)
L_28_.Message.New("" .. "🍭 CandyHub Loaded! Thanks For Using Enjoy The Special Candies This script is not finish adding more features some features dont work i was lazy and tired  \240\159\152\129")
local L_29_ = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["First Person Controller"]).DoesOwnGun;
local L_30_ = L_28_.GunCmds.DoesOwnGun;
    local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
    local dwwdqdqWindow = ArrayField:CreateWindow({
        Name = "Big Paintball - CandyHub",
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


local AimbotTab = dwwdqdqWindow:CreateTab("Aimbot", 4483362458) 
local VisualsTab = dwwdqdqWindow:CreateTab("Visuals", 4483362458) 
local GunModsTab = dwwdqdqWindow:CreateTab("Gun Mods", 4483362458) 
local ExtraTab = dwwdqdqWindow:CreateTab("Extra", 4483362458)

local KillAllToggle = AimbotTab:CreateToggle({
    Name = "KillAll",
    CurrentValue = false,
    Flag = "FF_KillAll",
    Callback = function(Value)
    -- Code that runs when the toggle is pressed, you can utilize the Value (boolean) here
    end,
 })
 
 local SilentToggle = AimbotTab:CreateToggle({
    Name = "Silent",
    CurrentValue = false,
    Flag = "FF_Silent",
    Callback = function(Value)
    -- Code that runs when the toggle is pressed, you can utilize the Value (boolean) here
    end,
 })
 

local HighlightEspToggle = VisualsTab:CreateToggle({
     Name = "Highlight Esp",
     CurrentValue = false,
     Flag = "FF_Highlight",
     Callback = function(Value)

     end,
})
 
 
 local FireRateButton = GunModsTab:CreateButton({
    Name = "FireRate",
    Interact = 'Click',
    Callback = function()
       for _, L_63_forvar1 in pairs(getgc(true)) do
          if typeof(L_63_forvar1) == "table" and rawget(L_63_forvar1, "shotrate") then
             L_63_forvar1.shotrate = 0.037
          end
       end
    end
 })
 
 local NoDropButton = GunModsTab:CreateButton({
    Name = "No Drop",
    Interact = 'Click',
    Callback = function()
       for _, L_65_forvar1 in pairs(getgc(true)) do
          if typeof(L_65_forvar1) == "table" and rawget(L_65_forvar1, "shotrate") then
             L_65_forvar1.velocity = 5 + 994
          end
       end
    end
 })
 
 local FullyAutomaticButton = GunModsTab:CreateButton({
    Name = "Fully Automatic",
    Interact = 'Click',
    Callback = function()
       for _, L_70_forvar1 in pairs(getgc(true)) do
          if typeof(L_70_forvar1) == "table" and rawget(L_70_forvar1, "shotrate") then
             L_70_forvar1.automatic = true
          end
       end
    end
 })
 
 local UnlockAllButton = ExtraTab:CreateButton({
    Name = "Unlock All (Client-Sided)",
    Interact = 'Click',
    Warning = "Other players cannot see these weapons",
    Callback = function()
       local L_71_;
       L_71_ = hookmetamethod(game, "__namecall", function(L_72_arg0, ...)
          local L_73_ = {...}
          local L_74_ = getnamecallmethod()
          if tostring(L_72_arg0) == "request respawn" and getnamecallmethod() == "FireServer" then
             if typeof(L_73_[1]) == "table" then
                L_73_[1] = {"1"}
             end;
             return L_72_arg0.FireServer(L_72_arg0, unpack(L_73_))
          end;
          return L_71_(L_72_arg0, ...)
       end)
       hookfunction(getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["First Person Controller"]).DoesOwnGun, function()
          return true
       end)
       hookfunction(L_28_.GunCmds.DoesOwnGun, function()
          return true
       end)
    end
 })
 
 local RemoveLayeredClothingButton = ExtraTab:CreateButton({
    Name = "Loop Remove All Layered Clothing",
    Interact = 'Click',
    Warning = "This should be used to remove any annoying Character particles or Layered Clothing Exploits",
    Callback = function()
       for _, L_79_forvar1 in pairs(game.Players:GetPlayers()) do
          for _, L_81_forvar1 in pairs(L_79_forvar1.Character:GetChildren()) do
             if L_81_forvar1:IsA("Accessory") then
                L_81_forvar1:Destroy()
             end
          end;
          L_79_forvar1.CharacterAdded:connect(function(L_82_arg0)
             wait(.11)
             for _, L_84_forvar1 in pairs(L_82_arg0:GetChildren()) do
                if L_84_forvar1:IsA("Accessory") then
                   L_84_forvar1:Destroy()
                end
             end
          end)
       end
    end
 })